function yuv = stitch(obj, yuvs, count)
% stitch : 对多路YUV视频进行拼接
% yuvs : 输入的N个YUV文件描述
% count ：拼接的帧数

    N = length(yuvs); % 共有N路视频

    for n = 1:N
        yuvs(n).fid = fopen(yuvs(n).filename,'r');
    end
    
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
   
    for frame = 1:count % 逐帧拼接
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
        YR = imresize(Y,[1080 1920]);
        UR = imresize(U,[1080 1920]);
        VR = imresize(V,[1080 1920]);
        imshow(ycbcr2rgb(uint8(cat(3,YR,UR,VR))));
        fwrite(yuv.fid,uint8(YR'));
        fwrite(yuv.fid,uint8(UR'));
        fwrite(yuv.fid,uint8(VR'));
    end
    
    for n = 1:N
        fclose(yuvs(n).fid);
    end
    fclose(yuv.fid);
end