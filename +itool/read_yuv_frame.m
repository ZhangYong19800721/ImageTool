function image = read_yuv_frame(yuv_fid,row_num,col_num,chroma)
%read_yuv_frame ��YUV�ļ��ж�ȡһ֡
%   yuv_fid: YUV�ļ����
%   row_num��֡������
%   col_num��֡������
%   chroma��ɫ�ʸ�ʽ

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

