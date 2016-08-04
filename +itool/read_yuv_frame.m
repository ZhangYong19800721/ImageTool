function image = read_yuv_frame(yuv_fid,row_num,col_num,chroma)
%read_yuv_frame 从YUV文件中读取一帧
%   yuv_fid: YUV文件句柄
%   row_num：帧的行数
%   col_num：帧的列数
%   chroma：色彩格式

    [rn, cn] = itool.color_space(row_num, col_num, chroma);
    image = zeros([row_num col_num 3]);
    
    Y = fread(yuv_fid,[col_num row_num],'uchar')';
    U = fread(yuv_fid,[cn rn],'uchar')';
    V = fread(yuv_fid,[cn rn],'uchar')';
        
    U = imresize(U,[row_num col_num]);
    V = imresize(V,[row_num col_num]);
    
    image(:,:,1) = Y;
    image(:,:,2) = U;
    image(:,:,3) = V;
    
    image = uint8(image);
end

