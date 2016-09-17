function obj = estimate(obj, images, row_num, col_num)
%estimate ����ƴ�Ӳ���
%   images����Ҫ��ƴ�ӵ�ͼƬ����
    obj.canvas_row_num = row_num; obj.canvas_col_num = col_num; angle = 360 * pi / 180; % �������յ������������������յ�ͼ��ֱ���
    radius_cylind = (obj.canvas_col_num+1)/angle; % ����Բ���İ뾶
    midx = (obj.canvas_row_num-1)/2 + 1; midy = (obj.canvas_col_num-1)/2 + 1; % ����X�������ֵ���Y�������ֵ��
    [Y_cylind,X_cylind] = meshgrid(1:obj.canvas_col_num,1:obj.canvas_row_num); % ��ȡ��������Բ������ϵ��
    X_cylind = X_cylind - midx; Y_cylind = Y_cylind - midy; % ������λ�ö�׼����ԭ�㣨Բ������ϵ��
    Z_cylind = radius_cylind * ones(size(X_cylind)); % �뾶��Բ������ϵ��
    X_cylind = reshape(X_cylind,1,[]); Y_cylind = reshape(Y_cylind,1,[]); Z_cylind = reshape(Z_cylind,1,[]); 
    XYZ_cylind = cat(1,X_cylind,Y_cylind,Z_cylind); % �õ�������������������Բ������ϵ��
    XYZ_euclid = itool.ImageStitcher.inv_cylindrical(XYZ_cylind); % ��Բ������ϵ������ֵ�任Ϊŷ������ϵ������ֵ
    
    obj = obj.bundle_adjust(images); % �����е�����������й���
    % obj = obj.wave_correct(); % ����������
    obj = obj.interp_pos(XYZ_euclid,images); % �����������K,R������ÿ��ͼƬ��Ӧ���ɰ�Ͳ�ֵ��ѯ������
    obj = obj.gain_compensation(images); % �������油��Ȩֵ
end

