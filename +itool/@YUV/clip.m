function yuv = clip(obj,frame_start,frame_end,filename) % ����
%CLIP ����һ��YUV�ļ�
%   start_frame ��ʼ֡��
%   frame_end   ��ֹ֡��
%   filename    �ļ���

    obj = obj.open('r'); % ��YUV�ļ�
    
    yuv = itool.YUV();
    yuv.filename = filename;
    yuv.row_num = obj.row_num;
    yuv.col_num = obj.col_num;
    yuv.frame_num = length(frame_start:min(frame_end,obj.frame_num));
    yuv.format = obj.format;
    yuv = yuv.open('w'); % ������ļ�
    
    [r,c] = itool.YUV.color_space(obj.row_num,obj.col_num,obj.format);
    
    for frame = 1:(frame_start-1)
        Y = fread(obj.fid,[yuv.col_num yuv.row_num],'uchar');
        U = fread(obj.fid,[c r],'uchar');
        V = fread(obj.fid,[c r],'uchar');
    end

    
    for frame = 1:yuv.frame_num
        Y = fread(obj.fid,[yuv.col_num yuv.row_num],'uchar');
        U = fread(obj.fid,[c r],'uchar');
        V = fread(obj.fid,[c r],'uchar');
        
        fwrite(yuv.fid,uint8(Y));
        fwrite(yuv.fid,uint8(U));
        fwrite(yuv.fid,uint8(V));
    end
    
    obj.close();
    yuv.close();
end

