classdef VideoStitcher
    %VIDEOSTITCHER ������YUV��Ƶ��֡ƴ��Ϊ�����Ƶ
    %   ������YUV��Ƶ��֡ƴ��Ϊ�����Ƶ
    
    properties
        H; % The 3x3 Homography Matrix
        row_min; % ��С���� 
        row_max; % �������
        col_min; % ��С����
        col_max; % �������
        width;
        height;
    end
    
    methods
        [yuv, width, height, chroma] = stitch(obj, input_yuv1, width1, height1, input_yuv2, width2, height2, frame_count) % ��������YUV�ļ��������ƴ�Ӻ��YUV�ļ���     
        obj = estimate(obj, input_yuv1, row_num1, col_num1, chroma1, ...
                            input_yuv2, row_num2, col_num2, chroma2) % ��������YUV�ļ���������ƴ�Ӳ���
        obj = estimate_homography_matrix( obj, image1, image2 )
        [cw,ch] = chroma(obj,width,height,chroma_format)
        H = DLT(obj, match_points1, match_points2) % ʹ��Direct Linear Transform�㷨����������ͼ֮���͸�ӱ任����
    end
    
end

