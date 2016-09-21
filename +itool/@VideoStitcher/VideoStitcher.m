classdef VideoStitcher
    %VIDEOSTITCHER ��N·YUV��Ƶ��֡ƴ��Ϊ���/ȫ����Ƶ
    %   ��N·YUV��Ƶ��֡ƴ��Ϊ���/ȫ����Ƶ
    
    properties
        H; % 3x3xN͸�ӱ任���󣬵�iҳ��ʾ��i·��Ƶ��������͸�ӱ任����
        mask; % ����������x����������xN���߼����󣬵�iҳ�����i·��Ƶ���ɰ�
        interp_pos;
        canvas_row_num; % ���������� 
        canvas_col_num; % ���������� 
    end
    
    methods
        yuv = stitch(obj, yuvs, count) % ����N��YUV����ƴ��
        obj = estimate(obj, yuvs) % ����N��YUV�ļ�����������ƴ�Ӳ���
        [canvas,mask] = homography(obj,H,canvas_size,image) % ��ͼ��ͶӰ�������ϣ����������ڻ����ϵ��ɰ�
    end
    
    methods(Static)
        H = estimate_homography(image1, image2) % ʹ��SURF������������ͼ֮���͸�ӱ任����
        H = DLT(match_points1, match_points2) % ʹ��DLT�㷨��������ƥ���֮���͸�ӱ任����
        exit = unit_test();
    end
end

