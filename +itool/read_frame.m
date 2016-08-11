function image = read_frame(yuv)
%read_frame 从YUV文件中读取一帧
%   yuv: YUV文件描述

    [rn, cn] = itool.color_space(yuv.row_num, yuv.col_num, yuv.format);
    image = zeros([yuv.row_num yuv.col_num 3]);
    
    Y = fread(yuv.fid,[yuv.col_num yuv.row_num],'uchar')';
    U = fread(yuv.fid,[cn rn],'uchar')';
    V = fread(yuv.fid,[cn rn],'uchar')';
        
    U = imresize(U,[yuv.row_num yuv.col_num]);
    V = imresize(V,[yuv.row_num yuv.col_num]);
    
    image(:,:,1) = Y;
    image(:,:,2) = U;
    image(:,:,3) = V;
    
    image = uint8(image);
end

