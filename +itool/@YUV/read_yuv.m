function mov = read_yuv(yuv,count)
%read_yuv ��YUV�ļ��ж�������֡�����һ��matlab movie�ṹ��
%   yuv��yuv�ļ�������
%   count����ȡ����֡��
%   mov�������movie

    count = min(yuv.frame_num,count);
    
    yuv.fid = fopen(yuv.filename,'r');
    mov = zeros(yuv.row_num,yuv.col_num,3,count,'uint8');
    
    for frame = 1:count
        image = itool.read_frame(yuv);
        mov(:,:,:,frame) = image;
    end
    
    fclose(yuv.fid);
end

