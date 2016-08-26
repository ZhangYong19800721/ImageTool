function XYZ_euclid = inv_cylindrical(XYZ_cylind)
%INV_CYLINDRICAL 将圆柱坐标系坐标转换为直角坐标系坐标
%   XYZ_cylind: 圆柱坐标系的坐标值
%   XYZ_euclid：欧氏坐标系的坐标值
    XYZ_euclid = zeros(size(XYZ_cylind));
    theda = XYZ_cylind(2,:) ./ XYZ_cylind(3,:);
    XYZ_euclid(2,:) = XYZ_cylind(3,:) .* sin(theda);
    XYZ_euclid(1,:) = XYZ_cylind(1,:);
    XYZ_euclid(3,:) = XYZ_cylind(3,:) .* cos(theda);
end

