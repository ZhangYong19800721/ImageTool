function mov = read_yuv(yuv_fid,row_num,col_num,chroma,count)
%read_yuv ��YUV�ļ��ж�������֡�����һ��matlab movie�ṹ��
%   yuv_fid��yuv�ļ��ľ��
%   row_num����Ƶ֡��������Height��
%   col_num����Ƶ֡�����飨Width��
%   chroma��ɫ�ʸ�ʽ
%   count����ȡ����֡��
%   mov�������movie�ṹ��
    
    mov = zeros(row_num,col_num,3,count,'uint8');
    
    for frame = 1:count
        image = itool.read_yuv_frame(yuv_fid,row_num,col_num,chroma);
        mov(:,:,:,frame) = image;
    end
end

