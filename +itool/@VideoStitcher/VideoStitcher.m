classdef VideoStitcher
    %VIDEOSTITCHER ��N·YUV��Ƶ��֡ƴ��Ϊ���/ȫ����Ƶ
    %   ��N·YUV��Ƶ��֡ƴ��Ϊ���/ȫ����Ƶ
    
    properties
        image_stitcher; % ImageStitcher����
    end
    
    methods
        obj = estimate(obj, input_yuv_list, row_num, col_num, alfa, warper) % ��ƴ�Ӳ������й���
        output_yuv = stitch(obj, input_yuv_list,count) % ����N��YUV����ƴ��
    end
    
    methods(Static)
        exit = unit_test();
    end
end

