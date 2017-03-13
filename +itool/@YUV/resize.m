function yuv = resize(obj,frame_start,frame_end,filename,row_num,col_num)
%RESIZE 扩大或缩小每一帧的分辨率
%   start_frame 起始帧号
%   frame_end   终止帧数
%   filename    文件名
%   row_num     新分辨率的行数
%   col_num     新分辨率的列数

    obj = obj.open('r'); % 打开YUV文件
    
    yuv = itool.YUV();
    yuv.filename = filename;
    yuv.row_num = row_num;
    yuv.col_num = col_num;
    yuv.frame_num = length(frame_start:min(frame_end,obj.frame_num));
    yuv.format = obj.format;
    yuv = yuv.open('w'); % 打开输出文件
    
    [r,c] = itool.YUV.color_space(obj.row_num,obj.col_num,obj.format);
    
    for frame = 1:(frame_start-1)
        Y = fread(obj.fid,[obj.col_num obj.row_num],'uchar');
        U = fread(obj.fid,[c r],'uchar');
        V = fread(obj.fid,[c r],'uchar');
    end

    [rx,cx] = itool.YUV.color_space(yuv.row_num,yuv.col_num,yuv.format);
    
    for frame = 1:yuv.frame_num
        Y = fread(obj.fid,[obj.col_num obj.row_num],'uchar');
        U = fread(obj.fid,[c r],'uchar');
        V = fread(obj.fid,[c r],'uchar');
        
        Y = imresize(Y,[yuv.col_num,yuv.row_num]);
        U = imresize(U,[cx,rx]);
        V = imresize(V,[cx,rx]);
        
        fwrite(yuv.fid,uint8(Y));
        fwrite(yuv.fid,uint8(U));
        fwrite(yuv.fid,uint8(V));
    end
    
    obj.close();
    yuv.close();
end

