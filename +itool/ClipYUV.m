function flag = ClipYUV( infile_name, frame_start, frame_count, width, height, chroma, outfile_name)
%CLIPYUV 剪辑一个YUV文件
%   start_frame 起始帧号
%   frame_count 剪辑帧数

    file_out = fopen(outfile_name,'w'); % 打开输出文件
    file_in = fopen(infile_name,'r'); % 打开输入文件
    
    if chroma == 'yuv444p'
        w = width;
        h = height;
    elseif chroma == 'yuv420p'
        w = width/2;
        h = height/2;
    elseif chroma == 'yuv422p'
        w = width/2;
        h = height;
    else
        error('Wrong chroma format');
    end
    
    Y = zeros(width,height);
    U = zeros(w,h);
    V = zeros(w,h);
    
    
    for n = 1:(frame_start-1)    
        Y = fread(file_in,[width height],'uchar');
        U = fread(file_in,[w h],'uchar');
        V = fread(file_in,[w h],'uchar');
    end
    
    for frame = 1:frame_count
        Y = fread(file_in,[width height],'uchar');
        U = fread(file_in,[w h],'uchar');
        V = fread(file_in,[w h],'uchar');
        
        fwrite(file_out,uint8(Y));
        fwrite(file_out,uint8(U));
        fwrite(file_out,uint8(V));
    end
    
    fclose(file_in);
    fclose(file_out);
    flag = true;
end

