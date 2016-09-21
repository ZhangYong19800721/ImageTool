function obj = create_canvas(obj,row_num,col_num,alfa,warper)
%CREATE_CANVAS ��������
%   �˴���ʾ��ϸ˵��
    obj.canvas_row_num = row_num; % ��������
    obj.canvas_col_num = col_num; % ��������
    obj.alfa = alfa; % ˮƽȫ���ӽǣ���
    radius_warp = (obj.canvas_col_num+1) / (obj.alfa * pi / 180); % ����Բ��/��İ뾶
    midx = (obj.canvas_row_num-1)/2 + 1; midy = (obj.canvas_col_num-1)/2 + 1; % ����X�������ֵ���Y�������ֵ��
    [Y_warp,X_warp] = meshgrid(1:obj.canvas_col_num,1:obj.canvas_row_num); % ��ȡ��������Բ��/������ϵ��
    X_warp = X_warp - midx; % ������λ�ö�׼����ԭ�㣨Բ��/������ϵ��
    Y_warp = Y_warp - midy; % ������λ�ö�׼����ԭ�㣨Բ��/������ϵ��
    Z_warp = radius_warp * ones(size(X_warp)); % �뾶��Բ��/������ϵ��
    X_warp = reshape(X_warp,1,[]); Y_warp = reshape(Y_warp,1,[]); Z_warp = reshape(Z_warp,1,[]); 
    xyz_warp = cat(1,X_warp,Y_warp,Z_warp); % �õ�������������������Բ��/������ϵ��
    if strcmp(warper,'cylindrical')
        obj.xyz = itool.ImageStitcher.inv_cylindrical(xyz_warp); % ��Բ������ϵ������ֵ�任Ϊŷ������ϵ������ֵ
    elseif strcmp(warper,'spherical')
        obj.xyz = itool.ImageStitcher.inv_spherical(xyz_warp); % ��Բ������ϵ������ֵ�任Ϊŷ������ϵ������ֵ
        obj.beda = (obj.canvas_row_num / obj.canvas_col_num) * obj.alfa;
    end
end

