function canvas = stitch(obj, images, options)
% stitch : 对多个图片进行拼接
% images : 输入的N个图片
% canvas ：拼接完成的结果

    number_of_images = length(images); % 共有N个图片

    Y = zeros(obj.canvas_row_num,obj.canvas_col_num);
    U = zeros(obj.canvas_row_num,obj.canvas_col_num);
    V = zeros(obj.canvas_row_num,obj.canvas_col_num);
    M = logical(zeros(size(Y)));
    
    for n = obj.sequence
        image = double(images(n).image);
        
        if options.is_gain_compensation
            image(:,:,1) = obj.cameras(n).gain(1) .* image(:,:,1);
            image(:,:,2) = obj.cameras(n).gain(2) .* image(:,:,2);
            image(:,:,3) = obj.cameras(n).gain(3) .* image(:,:,3);
        end
        
        [image_row_num, image_col_num, ~] = size(image);
        [IX, IY] = meshgrid(1:image_row_num,1:image_col_num);
        mask2d = reshape(logical(obj.cameras(n).mask),obj.canvas_row_num,obj.canvas_col_num);
        
        if options.is_blending    
            temp_Y = zeros(obj.canvas_row_num,obj.canvas_col_num); 
            temp_U = zeros(obj.canvas_row_num,obj.canvas_col_num);
            temp_V = zeros(obj.canvas_row_num,obj.canvas_col_num);
            
            temp_Y(mask2d) = interp2(IX,IY,double(image(:,:,1))',obj.cameras(n).query_x,obj.cameras(n).query_y);
            temp_U(mask2d) = interp2(IX,IY,double(image(:,:,2))',obj.cameras(n).query_x,obj.cameras(n).query_y);
            temp_V(mask2d) = interp2(IX,IY,double(image(:,:,3))',obj.cameras(n).query_x,obj.cameras(n).query_y);
            
            Y = obj.blend(Y,M,temp_Y,mask2d,9);
            U = obj.blend(U,M,temp_U,mask2d,9);
            V = obj.blend(V,M,temp_V,mask2d,9);
            M(mask2d) = 1;
        else
            Y(mask2d) = interp2(IX,IY,double(image(:,:,1))',obj.cameras(n).query_x,obj.cameras(n).query_y);
            U(mask2d) = interp2(IX,IY,double(image(:,:,2))',obj.cameras(n).query_x,obj.cameras(n).query_y);
            V(mask2d) = interp2(IX,IY,double(image(:,:,3))',obj.cameras(n).query_x,obj.cameras(n).query_y);
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