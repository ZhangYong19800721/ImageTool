classdef ImageStitcher
    %ImageStitcher �����ͼ��ƴ��Ϊȫ��ͼ��
    %   �����ͼ��ƴ��Ϊһ��ȫ��ͼ��
    
    properties
        cameras % struct�ṹ�����飬������¼����Ĳ���
        % H; % 3x3xN͸�ӱ任���󣬵�iҳ��ʾ��i·��Ƶ��������͸�ӱ任����
        % mask; % ����������x����������xN���߼����󣬵�iҳ�����i·��Ƶ���ɰ�
        % interp_pos; % ���ڲ�ֵ�Ĳ�ѯ��λ������
        canvas_row_num; % ���������� 
        canvas_col_num; % ���������� 
    end
    
    methods
        canvas = stitch(obj, images) % ����N��image,���ƴ�ӽ��
        obj = estimate(obj, images) % ����N��image������ƴ�Ӳ���
        % [canvas,mask] = homography(obj,H,canvas_size,image) % ��ͼ��ͶӰ�������ϣ����������ڻ����ϵ��ɰ�
    end
    
    methods(Static)
        H = estimate_homography(image1, image2) % ʹ��SURF������������ͼ֮���͸�ӱ任����
        H = DLT(match_points1, match_points2) % ʹ��DLT�㷨��������ƥ���֮���͸�ӱ任����
    end
    
end

