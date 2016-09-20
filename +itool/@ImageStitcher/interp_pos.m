function obj = interp_pos(obj,images)
%INTERP_POS 此处显示有关此函数的摘要
%   此处显示详细说明
    number_of_images = length(images); % 需要拼接的图片个数
    for n = 1:number_of_images
        XYZ_Q_euclid = obj.cameras(n).K * obj.cameras(n).R * obj.correct * obj.xyz; % 开始计算插值查询点坐标
        XYZ_I_euclid = 1000 * XYZ_Q_euclid ./ abs(repmat(XYZ_Q_euclid(3,:),3,1));
        X_I_euclid = XYZ_I_euclid(1,:); Y_I_euclid = XYZ_I_euclid(2,:); Z_I_euclid = XYZ_I_euclid(3,:); 
        [image_row_num,image_col_num,~] = size(images(n).image); % 获取图像的大小
        image_midx = (image_row_num-1)/2 + 1; image_midy = (image_col_num-1)/2 + 1; % 计算图像的中值点
        mask = (X_I_euclid >= (1-image_midx)) & (X_I_euclid <= (image_row_num-image_midx)) & ...
               (Y_I_euclid >= (1-image_midy)) & (Y_I_euclid <= (image_col_num-image_midy)) & ...
               (Z_I_euclid > 0); % 计算得到该图像对应的蒙板
        obj.cameras(n).mask = reshape(mask,obj.canvas_row_num,obj.canvas_col_num); % 记录第n个图片的蒙板
        obj.cameras(n).query_x = X_I_euclid(mask) + image_midx; % 记录第n个图片的插值查询点 
        obj.cameras(n).query_y = Y_I_euclid(mask) + image_midy; % 记录第n个图片的插值查询点
        
        front_finder = ones(3,3); front_finder(5) = -8;
        front_mat = conv2(double(mask),front_finder,'same');
        obj.cameras(n).front = find(front_mat<0); % 计算得到第n个图片的边框线条
    end
end

