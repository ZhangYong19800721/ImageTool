classdef YUV
    %YUV �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        fid;
        filename;
        row_num;
        col_num;
        frame_num;
        format;
    end
    
    methods
        frame = read_frame(obj)    % ��ȡһ֡
        exit = play(obj,frame_num) % ����frame_num֡
        yuv = clip(obj,frame_start,frame_end,filename) % ����
        obj = open(obj,option)
        obj = close(obj)
    end
    
    methods(Static)
        [rn,cn] = color_space(row_num,col_num,chroma)
    end
    
end

