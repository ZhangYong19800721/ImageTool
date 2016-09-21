function obj = create_canvas(obj,row_num,col_num,alfa,warper)
%CREATE_CANVAS 创建画布
%   此处显示详细说明
    obj.canvas_row_num = row_num; % 画布行数
    obj.canvas_col_num = col_num; % 画布列数
    obj.alfa = alfa; % 水平全景视角，度
    radius_warp = (obj.canvas_col_num+1) / (obj.alfa * pi / 180); % 计算圆柱/球的半径
    midx = (obj.canvas_row_num-1)/2 + 1; midy = (obj.canvas_col_num-1)/2 + 1; % 计算X坐标的中值点和Y坐标的中值点
    [Y_warp,X_warp] = meshgrid(1:obj.canvas_col_num,1:obj.canvas_row_num); % 获取坐标网格（圆柱/球坐标系）
    X_warp = X_warp - midx; % 将中心位置对准坐标原点（圆柱/球坐标系）
    Y_warp = Y_warp - midy; % 将中心位置对准坐标原点（圆柱/球坐标系）
    Z_warp = radius_warp * ones(size(X_warp)); % 半径（圆柱/球坐标系）
    X_warp = reshape(X_warp,1,[]); Y_warp = reshape(Y_warp,1,[]); Z_warp = reshape(Z_warp,1,[]); 
    xyz_warp = cat(1,X_warp,Y_warp,Z_warp); % 得到所有坐标点的坐标网格（圆柱/球坐标系）
    if strcmp(warper,'cylindrical')
        obj.xyz = itool.ImageStitcher.inv_cylindrical(xyz_warp); % 将圆柱坐标系的坐标值变换为欧氏坐标系的坐标值
    elseif strcmp(warper,'spherical')
        obj.xyz = itool.ImageStitcher.inv_spherical(xyz_warp); % 将圆柱坐标系的坐标值变换为欧氏坐标系的坐标值
        obj.beda = (obj.canvas_row_num / obj.canvas_col_num) * obj.alfa;
    end
end

