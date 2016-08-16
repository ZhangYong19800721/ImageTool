function pos_e = inv_cylindrical(pos_c,f)
%INV_CYLINDRICAL ��Բ������ϵ����ת��Ϊֱ������ϵ����
%   pos_c: ֱ������ϵ����
%   f������
    pos_e = zeros(size(pos_c));
    pos_e(1,:) = f * tan(pos_c(1,:)./pos_c(3,:));
    pos_e(2,:) = f * (pos_c(2,:) ./ pos_c(3,:)) * sec(pos_c(1,:) ./ pos_c(3,:));
    pos_e(3,:) = f;
end

