function obj = estimate(obj, images, row_num, col_num, alfa, warper)
%estimate ����ƴ�Ӳ���
%   images����Ҫ��ƴ�ӵ�ͼƬ����
    obj = obj.create_canvas(row_num, col_num, alfa, warper); % ��������
    obj = obj.bundle_adjust(images); % ���������K,R���й���
    obj = obj.wave_correct(); % ����������
    obj = obj.interp_pos(images); % �����������K,R������ÿ��ͼƬ��Ӧ���ɰ�Ͳ�ֵ��ѯ������
    obj = obj.gain_compensation(images); % �������油��Ȩֵ
    obj = obj.blend_estimate(); % ����ͼ���ں���Ҫ�Ĳ���
end

