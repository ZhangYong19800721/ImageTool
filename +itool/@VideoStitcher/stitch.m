function yuv = stitch(obj, yuvs, count)
% stitch : �Զ�·YUV��Ƶ����ƴ��
% yuvs : �����N��YUV�ļ�����
% count ��ƴ�ӵ�֡��

    N = length(yuvs); % ����N·��Ƶ

    yuvs(1).fid = fopen(yuvs(1).filename,'r');
    yuvs(2).fid = fopen(yuvs(2).filename,'r');
    yuv  = itool.YUV();
    yuv.filename = 'result.yuv';
    yuv.row_num = obj.canvas_row_num;
    yuv.col_num = obj.canvas_col_num;
    yuv.frame_num = count;
    yuv.format = 'yuv444p';
    yuv.fid = fopen(yuv.filename,'w');
    
    Y = zeros(obj.canvas_row_num,obj.canvas_col_num);
    U = zeros(obj.canvas_row_num,obj.canvas_col_num);
    V = zeros(obj.canvas_row_num,obj.canvas_col_num);
   
    for frame = 1:count % ��֡ƴ��
        frame
        for n = N:-1:1
            image = itool.read_frame(yuvs(n));
            [image_row_num, image_col_num, ~] = size(image);
            [x_g_i, y_g_i] = meshgrid(1:image_row_num,1:image_col_num);
            image_mask = logical(obj.mask(:,:,n));
            Y(image_mask) = interp2(x_g_i,y_g_i,double(image(:,:,1))',obj.interp_pos(n).x,obj.interp_pos(n).y);
            U(image_mask) = interp2(x_g_i,y_g_i,double(image(:,:,2))',obj.interp_pos(n).x,obj.interp_pos(n).y);
            V(image_mask) = interp2(x_g_i,y_g_i,double(image(:,:,3))',obj.interp_pos(n).x,obj.interp_pos(n).y);
        end
       
        warning off;
        imshow(ycbcr2rgb(uint8(cat(3,Y,U,V))));
        fwrite(yuv.fid,uint8(Y'));
        fwrite(yuv.fid,uint8(U'));
        fwrite(yuv.fid,uint8(V'));
    end
    
    fclose(yuvs(1).fid);
    fclose(yuvs(2).fid);
    fclose(yuv.fid);
end