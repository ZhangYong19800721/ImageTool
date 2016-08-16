function pos_c = cylindrical(pos_e,s) 
%CYLINDRICAL 将直角坐标系坐标转换为圆柱坐标系坐标
%   pos_e: 直角坐标系坐标
%   s: 圆柱体的半径
    pos_c = zeros(size(pos_e));
    pos_c(1,:) = s * atan(pos_e(1,:) ./ pos_e(3,:));
    pos_c(2,:) = s * (pos_e(2,:) ./ sqrt(pos_e(1,:).^2 + pos_e(3,:).^2)); 
    pos_c(3,:) = s;
end

