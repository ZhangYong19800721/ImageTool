function obj = estimate(obj, images)
%estimate 估计拼接参数
%   images：需要被拼接的图片数组
    obj.canvas_row_num = 1080; obj.canvas_col_num = 1920; angle = 190 * pi / 180;
    row_num = obj.canvas_row_num; col_num = obj.canvas_col_num; % 计算最终的行数和列数，即最终的图像分辨率 
    radius_cylind = (col_num+1)/angle; % 计算圆柱的半径
    midx = (row_num-1)/2 + 1; midy = (col_num-1)/2 + 1; % 计算X坐标的中值点和Y坐标的中值点
    [Y_cylind,X_cylind] = meshgrid(1:col_num,1:row_num); % 获取坐标网格（圆柱坐标系）
    X_cylind = X_cylind - midx; Y_cylind = Y_cylind - midy; % 将中心位置对准坐标原点（圆柱坐标系）
    Z_cylind = radius_cylind * ones(size(X_cylind)); % 半径（圆柱坐标系）
    X_cylind = reshape(X_cylind,1,[]); Y_cylind = reshape(Y_cylind,1,[]); Z_cylind = reshape(Z_cylind,1,[]); 
    XYZ_cylind = cat(1,X_cylind,Y_cylind,Z_cylind); % 得到所有坐标点的坐标网格（圆柱坐标系）
    XYZ_euclid = itool.ImageStitcher.inv_cylindrical(XYZ_cylind); % 将圆柱坐标系的坐标值变换为欧氏坐标系的坐标值
    
    % 对所有的相机参数进行估计
    obj = obj.bundle_adjust(images,radius_cylind);
    
    % 计算增益补偿权值
    % obj = obj.gain_compensation(images);
    
    % 根据相机参数H，计算每个图片对应的蒙板和插值查询点坐标
    number_of_images = length(images); % 需要拼接的图片个数
    for n = 1:number_of_images
        XYZ_Q_euclid = obj.cameras(n).H * XYZ_euclid; % 开始计算插值查询点坐标
        XYZ_I_euclid = radius_cylind * XYZ_Q_euclid ./ repmat(XYZ_Q_euclid(3,:),3,1);
        X_I_euclid = XYZ_I_euclid(1,:); Y_I_euclid = XYZ_I_euclid(2,:); Z_Q_euclid = XYZ_Q_euclid(3,:); 
        [image_row_num,image_col_num,~] = size(images(n).image); % 获取图像的大小
        image_midx = (image_row_num-1)/2 + 1; image_midy = (image_col_num-1)/2 + 1; % 计算图像的中值点
        mask = (X_I_euclid >= (1-image_midx)) & (X_I_euclid <= (image_row_num-image_midx)) & ...
               (Y_I_euclid >= (1-image_midy)) & (Y_I_euclid <= (image_col_num-image_midy)) & ...
               (Z_Q_euclid > 0); % 计算得到该图像对应的蒙板
        obj.cameras(n).mask = mask; % 记录第n个图片的蒙板
        obj.cameras(n).query_x = X_I_euclid(mask) + image_midx; % 记录第n个图片的插值查询点 
        obj.cameras(n).query_y = Y_I_euclid(mask) + image_midy; % 记录第n个图片的插值查询点
    end
end

