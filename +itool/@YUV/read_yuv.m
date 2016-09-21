function mov = read_yuv(yuv,count)
%read_yuv 从YUV文件中读入若干帧，输出一个matlab movie结构体
%   yuv：yuv文件描述类
%   count：读取的总帧数
%   mov：输出的movie

    count = min(yuv.frame_num,count);
    
    yuv.fid = fopen(yuv.filename,'r');
    mov = zeros(yuv.row_num,yuv.col_num,3,count,'uint8');
    
    for frame = 1:count
        image = itool.read_frame(yuv);
        mov(:,:,:,frame) = image;
    end
    
    fclose(yuv.fid);
end

