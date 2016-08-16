classdef ImageStitcher
    %ImageStitcher �����ͼ��ƴ��Ϊȫ��ͼ��
    %   �����ͼ��ƴ��Ϊһ��ȫ��ͼ��
    
    properties
        cameras % struct�ṹ�����飬������¼����Ĳ���
        canvas_row_num; % ���������� 
        canvas_col_num; % ���������� 
    end
    
    methods
        canvas = stitch(obj, images) % ����N��image,���ƴ�ӽ��
        obj = estimate(obj, images) % ����N��image������ƴ�Ӳ���
    end
    
    methods(Static)
        H = estimate_homography(image1, image2) % ʹ��SURF������������ͼ֮���͸�ӱ任����
        H = DLT(match_points1, match_points2) % ʹ��DLT�㷨��������ƥ���֮���͸�ӱ任����
        pos_c = cylindrical(pos_e,s) % ��ֱ������ϵ����ת��ΪԲ������ϵ����
        pos_e = inv_cylindrical(pos_c,f) % ��ֱ������ϵ����ת��ΪԲ������ϵ����
    end
    
end

