function mov = read_yuv(yuv,count)
%read_yuv ��YUV�ļ��ж�������֡�����һ��matlab movie�ṹ��
%   yuv��yuv�ļ�������
%   count����ȡ����֡��
%   mov�������movie

    if nargs == 2
        % do nothing
    else  
        count = min(yuv.frame_num,count);
    end
    
    yuv.fid = fopen(yuv.filename,'r');
    mov = zeros(row_num,col_num,3,count,'uint8');
    
    for frame = 1:count
        image = itool.read_frame(yuv);
        mov(:,:,:,frame) = image;
    end
    
    fclose(yuv.filename);
end

