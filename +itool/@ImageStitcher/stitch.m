function canvas = stitch(obj, images)
% stitch : 对多个图片进行拼接
% images : 输入的N个图片
% canvas ：拼接完成的结果

    number_of_images = length(images); % 共有N个图片

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