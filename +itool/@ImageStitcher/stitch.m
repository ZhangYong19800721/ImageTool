function canvas = stitch(obj, images)
% stitch : �Զ��ͼƬ����ƴ��
% images : �����N��ͼƬ
% canvas ��ƴ����ɵĽ��

    N = length(images); % ����N��ͼƬ

    Y = zeros(obj.canvas_row_num,obj.canvas_col_num);
    U = zeros(obj.canvas_row_num,obj.canvas_col_num);
    V = zeros(obj.canvas_row_num,obj.canvas_col_num);
   
    for n = N:-1:1
        image = images(n).image;
        [image_row_num, image_col_num, ~] = size(image);
        [x_g_i, y_g_i] = meshgrid(1:image_row_num,1:image_col_num);
        image_mask = logical(obj.cameras(n).mask);
        Y(image_mask) = interp2(x_g_i,y_g_i,double(image(:,:,1))',obj.cameras(n).interp_pos.x,obj.cameras(n).interp_pos.y);
        U(image_mask) = interp2(x_g_i,y_g_i,double(image(:,:,2))',obj.cameras(n).interp_pos.x,obj.cameras(n).interp_pos.y);
        V(image_mask) = interp2(x_g_i,y_g_i,double(image(:,:,3))',obj.cameras(n).interp_pos.x,obj.cameras(n).interp_pos.y);
    end
    canvas = uint8(cat(3,Y,U,V));
end