function obj = gain_compensation(obj,images) % 亮度增益补偿算法
%GAIN_COMPENSATION 亮度增益补偿算法
%   此处显示详细说明
    number_of_images = length(images);
    N_value = zeros(number_of_images); % 第(i,j)个元素表示第i个图像和第j个图像之间的重叠像素个数（重叠区域的面积）
    for n = 1:number_of_images
        for m = n:number_of_images
            N_value(n,m) = sum(obj.cameras(n).mask & obj.cameras(m).mask);
        end
    end
    N_value = triu(N_value) + triu(N_value)';
    
    I_value = zeros(number_of_images,number_of_images,3); % 第(i,j)个元素表示第i个图像中与第j个图像重叠区域的平均像素值
    for n = 1:number_of_images
        for m = 1:number_of_images
            if m~=n
                overlap_mask = obj.cameras(n).mask & obj.cameras(m).mask; % 重叠区域的蒙板
                mask_in_mask = overlap_mask(obj.cameras(n).mask);
                query_x = obj.cameras(n).query_x(mask_in_mask);
                query_y = obj.cameras(n).query_y(mask_in_mask);
    
                image_n = images(n).image; 
                image_Y = image_n(:,:,1);
                image_U = image_n(:,:,2);
                image_V = image_n(:,:,3);
                [image_row_num, image_col_num] = size(image_Y);
                [IX, IY] = meshgrid(1:image_row_num,1:image_col_num);
                Y = interp2(IX,IY,double(image_Y)',query_x,query_y);
                U = interp2(IX,IY,double(image_U)',query_x,query_y);
                V = interp2(IX,IY,double(image_V)',query_x,query_y);
                I_value(n,m,1) = sum(reshape(Y,[],1));
                I_value(n,m,2) = sum(reshape(U,[],1));
                I_value(n,m,3) = sum(reshape(V,[],1));
            end
        end
    end
    
    I_value = I_value ./ repmat(N_value,1,1,3);
    I_value(repmat(N_value,1,1,3) == 0) = 0;
    
    delta_N = 10; delta_g = 0.1;
        
    x_start = ones(1,3*number_of_images);
    % 用levenberg-marquardt算法进行最优化
    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt', ...
            'MaxFunEvals',1e6,'TolFun',1e-8,'TolX',1e-8,'MaxIter',1e4,'Display','iter');
    x_solution = lsqnonlin(@error_func,x_start,[],[],options);
    x_solution = reshape(x_solution,3,number_of_images);
    % 将解向量变换为gain矩阵
    for k = 1:number_of_images
        obj.cameras(k).gain = x_solution(:,k);
    end
    
    function f_error = error_func(gain)
        gain = reshape(gain,3,number_of_images);
        
        g_i_Y = repmat(reshape(gain(1,:),[],1),1,number_of_images);
        g_j_Y = repmat(reshape(gain(1,:),1,[]),number_of_images,1);
        f_error_Y = N_value .* (((g_i_Y .* I_value(:,:,1) - g_j_Y .* I_value(:,:,1)').^2) ./ (delta_N.^2) + ((1-g_i_Y).^2) ./ (delta_g.^2));
        f_error_Y = reshape(f_error_Y,[],1);
        
        g_i_U = repmat(reshape(gain(2,:),[],1),1,number_of_images);
        g_j_U = repmat(reshape(gain(2,:),1,[]),number_of_images,1);
        f_error_U = N_value .* (((g_i_U .* I_value(:,:,2) - g_j_U .* I_value(:,:,2)').^2) ./ (delta_N.^2) + ((1-g_i_U).^2) ./ (delta_g.^2));
        f_error_U = reshape(f_error_U,[],1);
        
        g_i_V = repmat(reshape(gain(3,:),[],1),1,number_of_images);
        g_j_V = repmat(reshape(gain(3,:),1,[]),number_of_images,1);
        f_error_V = N_value .* (((g_i_V .* I_value(:,:,3) - g_j_V .* I_value(:,:,3)').^2) ./ (delta_N.^2) + ((1-g_i_V).^2) ./ (delta_g.^2));
        f_error_V = reshape(f_error_V,[],1);
        
        f_error = cat(1,f_error_Y,f_error_U,f_error_V);
        f_error = reshape(sqrt(f_error),[],1);
    end
end

