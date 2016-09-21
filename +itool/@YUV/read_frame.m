function frame = read_frame(obj)
%read_frame ��YUV�ļ��ж�ȡһ֡
%   yuv: YUV�ļ�����

    [rn, cn] = itool.YUV.color_space(obj.row_num, obj.col_num, obj.format);
    frame = zeros([obj.row_num obj.col_num 3]);
    
    Y = fread(obj.fid,[obj.col_num obj.row_num],'uchar')';
    U = fread(obj.fid,[cn rn],'uchar')';
    V = fread(obj.fid,[cn rn],'uchar')';
        
    U = imresize(U,[obj.row_num obj.col_num]);
    V = imresize(V,[obj.row_num obj.col_num]);
    
    frame(:,:,1) = Y;
    frame(:,:,2) = U;
    frame(:,:,3) = V;
    
    frame = uint8(frame);
end

