classdef VideoStitcher
    %VIDEOSTITCHER 将N路YUV视频逐帧拼接为广角/全景视频
    %   将N路YUV视频逐帧拼接为广角/全景视频
    
    properties
        image_stitcher; % ImageStitcher对象
    end
    
    methods
        obj = estimate(obj, input_yuv_list, row_num, col_num, alfa, warper) % 对拼接参数进行估计
        output_yuv = stitch(obj, input_yuv_list,count) % 输入N个YUV进行拼接
    end
    
    methods(Static)
        exit = unit_test();
    end
end

