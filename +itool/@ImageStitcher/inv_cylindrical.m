function pos_e = inv_cylindrical(pos_c,f)
%INV_CYLINDRICAL 将圆柱坐标系坐标转换为直角坐标系坐标
%   pos_c: 直角坐标系坐标
%   f：焦距
    pos_e = zeros(size(pos_c));
    pos_e(1,:) = f * tan(pos_c(1,:)./pos_c(3,:));
    pos_e(2,:) = f * (pos_c(2,:) ./ pos_c(3,:)) * sec(pos_c(1,:) ./ pos_c(3,:));
    pos_e(3,:) = f;
end

