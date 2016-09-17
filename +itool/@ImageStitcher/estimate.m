function obj = estimate(obj, images, row_num, col_num)
%estimate 估计拼接参数
%   images：需要被拼接的图片数组
    obj.canvas_row_num = row_num; obj.canvas_col_num = col_num; angle = 360 * pi / 180; % 计算最终的行数和列数，即最终的图像分辨率
    radius_cylind = (obj.canvas_col_num+1)/angle; % 计算圆柱的半径
    midx = (obj.canvas_row_num-1)/2 + 1; midy = (obj.canvas_col_num-1)/2 + 1; % 计算X坐标的中值点和Y坐标的中值点
    [Y_cylind,X_cylind] = meshgrid(1:obj.canvas_col_num,1:obj.canvas_row_num); % 获取坐标网格（圆柱坐标系）
    X_cylind = X_cylind - midx; Y_cylind = Y_cylind - midy; % 将中心位置对准坐标原点（圆柱坐标系）
    Z_cylind = radius_cylind * ones(size(X_cylind)); % 半径（圆柱坐标系）
    X_cylind = reshape(X_cylind,1,[]); Y_cylind = reshape(Y_cylind,1,[]); Z_cylind = reshape(Z_cylind,1,[]); 
    XYZ_cylind = cat(1,X_cylind,Y_cylind,Z_cylind); % 得到所有坐标点的坐标网格（圆柱坐标系）
    XYZ_euclid = itool.ImageStitcher.inv_cylindrical(XYZ_cylind); % 将圆柱坐标系的坐标值变换为欧氏坐标系的坐标值
    
    obj = obj.bundle_adjust(images); % 对所有的相机参数进行估计
    % obj = obj.wave_correct(); % 波浪形修正
    obj = obj.interp_pos(XYZ_euclid,images); % 根据相机参数K,R，计算每个图片对应的蒙板和插值查询点坐标
    obj = obj.gain_compensation(images); % 计算增益补偿权值
end

