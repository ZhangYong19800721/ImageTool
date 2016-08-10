function mov = read_yuv(yuv_fid,row_num,col_num,chroma,count)
%read_yuv 从YUV文件中读入若干帧，输出一个matlab movie结构体
%   yuv_fid：yuv文件的句柄
%   row_num：视频帧的行数（Height）
%   col_num：视频帧的列书（Width）
%   chroma：色彩格式
%   count：读取的总帧数
%   mov：输出的movie结构体
    
    mov = zeros(row_num,col_num,3,count,'uint8');
    
    for frame = 1:count
        image = itool.read_yuv_frame(yuv_fid,row_num,col_num,chroma);
        mov(:,:,:,frame) = image;
    end
end

