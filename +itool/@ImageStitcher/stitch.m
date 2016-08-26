function canvas = stitch(obj, images)
% stitch : �Զ��ͼƬ����ƴ��
% images : �����N��ͼƬ
% canvas ��ƴ����ɵĽ��

    number_of_images = length(images); % ����N��ͼƬ

    Y = zeros(obj.canvas_row_num,obj.canvas_col_num);
    U = zeros(obj.canvas_row_num,obj.canvas_col_num);
    V = zeros(obj.canvas_row_num,obj.canvas_col_num);
   
    for n = 1:number_of_images
        image = images(n).image;
        [image_row_num, image_col_num, ~] = size(image);
        [IX, IY] = meshgrid(1:image_row_num,1:image_col_num);
        image_mask = logical(obj.cameras(n).mask);
        Y(image_mask) = interp2(IX,IY,double(image(:,:,1))',obj.cameras(n).query_x,obj.cameras(n).query_y);
        U(image_mask) = interp2(IX,IY,double(image(:,:,2))',obj.cameras(n).query_x,obj.cameras(n).query_y);
        V(image_mask) = interp2(IX,IY,double(image(:,:,3))',obj.cameras(n).query_x,obj.cameras(n).query_y);
    end
    canvas = uint8(cat(3,Y,U,V));
end