function frame = read_frame(obj)
%read_frame 从YUV文件中读取一帧
%   yuv: YUV文件描述

    [rn, cn] = itool.color_space(obj.row_num, obj.col_num, obj.format);
    frame = zeros([yuv.row_num yuv.col_num 3]);
    
    Y = fread(yuv.fid,[yuv.col_num yuv.row_num],'uchar')';
    U = fread(yuv.fid,[cn rn],'uchar')';
    V = fread(yuv.fid,[cn rn],'uchar')';
        
    U = imresize(U,[yuv.row_num yuv.col_num]);
    V = imresize(V,[yuv.row_num yuv.col_num]);
    
    frame(:,:,1) = Y;
    frame(:,:,2) = U;
    frame(:,:,3) = V;
    
    frame = uint8(frame);
end

