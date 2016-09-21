classdef YUV
    %YUV 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        fid;
        filename;
        row_num;
        col_num;
        frame_num;
        format;
    end
    
    methods
        frame = read_frame(obj)    % 读取一帧
        exit = play(obj,frame_num) % 播放frame_num帧
        yuv = clip(obj,frame_start,frame_end,filename) % 剪切
        obj = open(obj,option)
        obj = close(obj)
    end
    
    methods(Static)
        [rn,cn] = color_space(row_num,col_num,chroma)
    end
    
end

