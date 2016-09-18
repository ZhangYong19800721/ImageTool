function xyz_e = inv_spherical(xyz_s)
%INV_SPHERICAL ����������任Ϊŷ���������
%   �˴���ʾ��ϸ˵��
    xyz_e = zeros(size(xyz_s));
    alfa = xyz_s(2,:) ./ xyz_s(3,:);
    beda = xyz_s(1,:) ./ xyz_s(3,:);
    
    xyz_e(1,:) = xyz_s(3,:) .* sin(beda);
    xyz_e(2,:) = xyz_s(3,:) .* cos(beda) .* sin(alfa);
    xyz_e(3,:) = xyz_s(3,:) .* cos(beda) .* cos(alfa);
end

