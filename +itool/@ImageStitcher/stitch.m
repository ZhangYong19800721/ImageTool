function canvas = stitch(obj, images, options)
% stitch : �Զ��ͼƬ����ƴ��
% images : �����N��ͼƬ
% canvas ��ƴ����ɵĽ��

    number_of_images = length(images); % ����N��ͼƬ

    Y = zeros(obj.canvas_row_num,obj.canvas_col_num);
    U = zeros(obj.canvas_row_num,obj.canvas_col_num);
    V = zeros(obj.canvas_row_num,obj.canvas_col_num);
    
    for n = obj.sequence
        image = double(images(n).image);
        
        if options.is_gain_compensation
            image(:,:,1) = obj.cameras(n).gain(1) .* image(:,:,1);
            image(:,:,2) = obj.cameras(n).gain(2) .* image(:,:,2);
            image(:,:,3) = obj.cameras(n).gain(3) .* image(:,:,3);
        end
        
        [image_row_num, image_col_num, ~] = size(image);
        [IX, IY] = meshgrid(1:image_row_num,1:image_col_num);
        mask_n = obj.cameras(n).mask;
        
        if options.is_blending    
            Y_n = zeros(obj.canvas_row_num,obj.canvas_col_num); 
            U_n = zeros(obj.canvas_row_num,obj.canvas_col_num);
            V_n = zeros(obj.canvas_row_num,obj.canvas_col_num);
            
            Y_n(mask_n) = interp2(IX,IY,double(image(:,:,1))',obj.cameras(n).query_x,obj.cameras(n).query_y);
            U_n(mask_n) = interp2(IX,IY,double(image(:,:,2))',obj.cameras(n).query_x,obj.cameras(n).query_y);
            V_n(mask_n) = interp2(IX,IY,double(image(:,:,3))',obj.cameras(n).query_x,obj.cameras(n).query_y);
            
            Y = obj.blend(Y,Y_n,n);
            U = obj.blend(U,U_n,n);
            V = obj.blend(V,V_n,n);
        else
            Y(mask_n) = interp2(IX,IY,double(image(:,:,1))',obj.cameras(n).query_x,obj.cameras(n).query_y);
            U(mask_n) = interp2(IX,IY,double(image(:,:,2))',obj.cameras(n).query_x,obj.cameras(n).query_y);
            V(mask_n) = interp2(IX,IY,double(image(:,:,3))',obj.cameras(n).query_x,obj.cameras(n).query_y);
        end
        
        % imwrite(uint8(cat(3,Y,U,V)),strcat(strcat('figure',num2str(n)),'.bmp'));
    end
    
    if options.is_show_skeleton
        color = rgb2ycbcr([255 0 0]);
        for n = number_of_images:-1:1    
            Y(obj.cameras(n).front) = color(1); 
            U(obj.cameras(n).front) = color(2); 
            V(obj.cameras(n).front) = color(3);
        end
    end
    
    canvas = uint8(cat(3,Y,U,V));
end