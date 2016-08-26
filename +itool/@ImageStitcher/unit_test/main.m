clear all;
close all;

images(1).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0025.JPG');
% images(2).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0026.JPG');
% images(3).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0027.JPG');
% images(4).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0028.JPG');
% images(5).image = imread('E:\WorkSpace\itool\+itool\@ImageStitcher\unit_test\IMG_0029.JPG');

[image_row_num,image_col_num,~] = size(images(1).image);

line1_E = cat(1,ones(1,image_col_num),1:image_col_num);                  %ֱ������ϵ�µı߿���
line2_E = cat(1,1:image_row_num,image_col_num*ones(1,image_row_num));    %ֱ������ϵ�µı߿���
line3_E = cat(1,image_row_num*ones(1,image_col_num),image_col_num:-1:1); %ֱ������ϵ�µı߿���
line4_E = cat(1,image_row_num:-1:1,ones(1,image_row_num));               %ֱ������ϵ�µı߿���

f = 2500; % �趨ͼƬ����
rim_E = cat(2,line1_E,line2_E,line3_E,line4_E); rim_E = cat(1,rim_E,f*ones(1,length(rim_E(1,:)))); % ֱ������ϵ�µı߿�
H = [1 0 -((image_row_num-1)/2+1)/f; 0 1 -((image_col_num-1)/2+1)/f; 0 0 1]; % �任���󣬽��߿�����Ķ�׼����ԭ��
rim_E = H * rim_E; % ���߿�任Ϊ���Ķ�׼����ԭ��

figure(1);
plot(rim_E(1,:),rim_E(2,:));

rim_C = itool.ImageStitcher.cylindrical(rim_E,f); % ��������任���õ���������ϵ�µı߿�
figure(2);
plot(rim_C(1,:),rim_C(2,:));

rim_C_row_min = ceil(min(rim_C(1,:)));
rim_C_row_max = floor(max(rim_C(1,:)));
rim_C_col_min = ceil(min(rim_C(2,:)));
rim_C_col_max = floor(max(rim_C(2,:)));

[G_Y_C,G_X_C] = meshgrid(rim_C_col_min:rim_C_col_max,rim_C_row_min:rim_C_row_max); % ������ϵ�µ����������
G_X_1D_C = reshape(G_X_C,1,[]); G_Y_1D_C = reshape(G_Y_C,1,[]); G_Z_1D_C = f*ones(1,length(G_X_1D_C));
pos_C = cat(1,G_X_1D_C,G_Y_1D_C,G_Z_1D_C); % ������ϵ�µ����������
pos_E = itool.ImageStitcher.inv_cylindrical(pos_C,f); % ��������ϵ�µ����������ת��Ϊֱ������ϵ�µ������
IH = inv(H);
pos_E = IH * pos_E;
row_num = rim_C_row_max - rim_C_row_min + 1;
col_num = rim_C_col_max - rim_C_col_min + 1;
MX = reshape(pos_E(1,:),row_num,col_num);
MY = reshape(pos_E(2,:),row_num,col_num);
mask = (MX >= 1) & (MX <= image_row_num) & (MY >= 1) & (MY <= image_col_num);

Y = zeros(row_num,col_num);
U = zeros(row_num,col_num);
V = zeros(row_num,col_num);

% ��������ֵ��ѯ��
Q_X_C = G_X_C(mask)';
Q_Y_C = G_Y_C(mask)';
Q_Z_C = f * ones(1,length(Q_X_C));
Q_POS_C = cat(1,Q_X_C,Q_Y_C,Q_Z_C);
Q_POS_E = itool.ImageStitcher.inv_cylindrical(Q_POS_C,f);
Q_POS_E = IH * Q_POS_E;

[x_g_i, y_g_i] = meshgrid(1:image_row_num,1:image_col_num);
image_mask = mask;
Y(image_mask) = interp2(x_g_i,y_g_i,double(images(1).image(:,:,1))',Q_POS_E(1,:),Q_POS_E(2,:));
U(image_mask) = interp2(x_g_i,y_g_i,double(images(1).image(:,:,2))',Q_POS_E(1,:),Q_POS_E(2,:));
V(image_mask) = interp2(x_g_i,y_g_i,double(images(1).image(:,:,3))',Q_POS_E(1,:),Q_POS_E(2,:));
canvas = uint8(cat(3,Y,U,V));
figure(3)
imshow(canvas);


%istitcher = itool.ImageStitcher();
%istitcher = istitcher.estimate(images);
%result = istitcher.stitch(images);