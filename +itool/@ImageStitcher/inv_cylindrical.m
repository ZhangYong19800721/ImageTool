function XYZ_euclid = inv_cylindrical(XYZ_cylind)
%INV_CYLINDRICAL ��Բ������ϵ����ת��Ϊֱ������ϵ����
%   XYZ_cylind: Բ������ϵ������ֵ
%   XYZ_euclid��ŷ������ϵ������ֵ
    XYZ_euclid = zeros(size(XYZ_cylind));
    theda = XYZ_cylind(2,:) ./ XYZ_cylind(3,:);
    XYZ_euclid(2,:) = XYZ_cylind(3,:) .* sin(theda);
    XYZ_euclid(1,:) = XYZ_cylind(1,:);
    XYZ_euclid(3,:) = XYZ_cylind(3,:) .* cos(theda);
end

