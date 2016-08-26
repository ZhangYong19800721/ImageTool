function [canvas,mask] = homography(f,R,image)
%HOMOGRAPHY ��ͼ��image����͸�ӱ任��ͶӰ��������
%   H��ͶӰ�任����
%   image����ͶӰ�任��ͼ��
    focal = 500;
    H = diag([f f 1]) * R;
    [image_row, image_col, ~] = size(image); % ��ȡͼ��Ĵ�С
    midx = (image_row-1)/2+1; midy = (image_col-1)/2+1;
    [IY,IX] = meshgrid(1:image_col,1:image_row); % imageͼ������������
    IX = reshape(IX,1,[]); IX = IX - midx; % ��ͼ������ĵ��ƶ�������ԭ��
    IY = reshape(IY,1,[]); IY = IY - midy; % ��ͼ������ĵ��ƶ�������ԭ��
    IP = cat(1,IX,IY,focal*ones(1,length(IX))); % �õ�imageͼ��������
    CP = H * IP; % �任�õ�imageͼ������������Ӧ�Ļ��������
    CP = focal * (CP ./ repmat(CP(3,:),3,1)); % �õ��任��Ļ��������
    
    cminx = ceil(min(CP(1,:))); cmaxx = floor(max(CP(1,:))); % �ҵ��������������ֵ����Сֵ
    cminy = ceil(min(CP(2,:))); cmaxy = floor(max(CP(2,:))); % �ҵ��������������ֵ����Сֵ

    canvas_row = cmaxx - cminx + 1; canvas_col = cmaxy - cminy + 1; % �õ�����������������
    canvas_Y = zeros(canvas_row,canvas_col); % ��ʼ������Y����
    canvas_U = zeros(canvas_row,canvas_col); % ��ʼ������U����
    canvas_V = zeros(canvas_row,canvas_col); % ��ʼ������V����
    
    [CY,CX] = meshgrid(1:canvas_col,1:canvas_row); % �������������������
    CX = reshape(CX,1,[]) + cminx; CY = reshape(CY,1,[]) + cminy; % �ƶ����������������
    CC = cat(1,CX,CY,focal * ones(1,length(CX))); % ��ɻ������������
    IC = H\CC; IC = focal * (IC ./ repmat(IC(3,:),3,1)); % �任��ͼ������ϵ

    IIX = IC(1,:); 
    IIY = IC(2,:);
    
    mask = (IIX >= (1-midx)) & (IIX <= (image_row-midx)) & (IIY >= (1-midy)) & (IIY <= (image_col-midy)); % ����ɰ�
    CQ = cat(1,CX(mask),CY(mask),focal * ones(1,sum(sum(mask))));  % canvas����ϵ�µĲ�ѯ������
    IQ = H\CQ; IQ = focal * (IQ ./ repmat(IQ(3,:),3,1)); % image����ϵ�µĲ�ѯ������
    
    IQX = IQ(1,:); IQY = IQ(2,:);
    
    [IGX,IGY] = meshgrid(1:image_row,1:image_col);
    IGX = IGX - midx; IGY = IGY - midy;
    IQ_Y = interp2(IGX,IGY,double(image(:,:,1))',IQX,IQY);
    IQ_U = interp2(IGX,IGY,double(image(:,:,2))',IQX,IQY);
    IQ_V = interp2(IGX,IGY,double(image(:,:,3))',IQX,IQY);
    
    canvas_Y(mask) = IQ_Y;
    canvas_U(mask) = IQ_U;
    canvas_V(mask) = IQ_V;
    
    canvas = uint8(cat(3,canvas_Y,canvas_U,canvas_V));
end

