classdef VideoStitcher
    %VIDEOSTITCHER 将两个YUV视频逐帧拼接为广角视频
    %   将两个YUV视频逐帧拼接为广角视频
    
    properties
        H; % The 3x3 Homography Matrix
        row_min; % 最小行数 
        row_max; % 最大行数
        col_min; % 最小列数
        col_max; % 最大列数
        width;
        height;
    end
    
    methods
        [yuv, width, height, chroma] = stitch(obj, input_yuv1, width1, height1, input_yuv2, width2, height2, frame_count) % 输入两个YUV文件名，输出拼接后的YUV文件名     
        obj = estimate(obj, input_yuv1, row_num1, col_num1, chroma1, ...
                            input_yuv2, row_num2, col_num2, chroma2) % 输入两个YUV文件名，估计拼接参数
        obj = estimate_homography_matrix( obj, image1, image2 )
        [cw,ch] = chroma(obj,width,height,chroma_format)
        H = DLT(obj, match_points1, match_points2) % 使用Direct Linear Transform算法估计两个幅图之间的透视变换矩阵
    end
    
end

