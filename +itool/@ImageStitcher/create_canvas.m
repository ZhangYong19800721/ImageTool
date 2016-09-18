function obj = create_canvas(obj, row_num, col_num)
%CREATE_CANVAS 创建画布
%   此处显示详细说明
    obj.canvas_row_num = row_num; obj.canvas_col_num = col_num; angle = 360 * pi / 180; % 计算最终的行数和列数，即最终的图像分辨率
    radius_cylind = (obj.canvas_col_num+1)/angle; % 计算圆柱的半径
    midx = (obj.canvas_row_num-1)/2 + 1; midy = (obj.canvas_col_num-1)/2 + 1; % 计算X坐标的中值点和Y坐标的中值点
    [Y_cylind,X_cylind] = meshgrid(1:obj.canvas_col_num,1:obj.canvas_row_num); % 获取坐标网格（圆柱坐标系）
    X_cylind = X_cylind - midx; Y_cylind = Y_cylind - midy; % 将中心位置对准坐标原点（圆柱坐标系）
    Z_cylind = radius_cylind * ones(size(X_cylind)); % 半径（圆柱坐标系）
    X_cylind = reshape(X_cylind,1,[]); Y_cylind = reshape(Y_cylind,1,[]); Z_cylind = reshape(Z_cylind,1,[]); 
    XYZ_cylind = cat(1,X_cylind,Y_cylind,Z_cylind); % 得到所有坐标点的坐标网格（圆柱坐标系）
    obj.XYZ_euclid = itool.ImageStitcher.inv_cylindrical(XYZ_cylind); % 将圆柱坐标系的坐标值变换为欧氏坐标系的坐标值
end

