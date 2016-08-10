function [yuv, width, height, chroma] = stitch(obj, input_yuv1, width1, height1, input_yuv2, width2, height2, frame_count)
% stitch : 
% input_yuv1 : 输入的第1个YUV文件名
% input_yuv2 : 输入的第2个YUV文件名
% output_yuv ：输出的YUV文件名

    fid_yuv1 = fopen(input_yuv1,'r');
    fid_yuv2 = fopen(input_yuv2,'r');
    fid_yuv  = fopen('result.yuv','w');
    
    canvas = zeros(obj.height,obj.width,3);
    iH = inv(obj.H);
    
    for frame = 1:frame_count % 逐帧拼接
        frame
        image1 = obj.read_nextframe(fid_yuv1,width1,height1,'yuv420p');
        image2 = obj.read_nextframe(fid_yuv2,width2,height2,'yuv420p');
        image1_size = size(image1);
        image2_size = size(image2);
        
        for r = obj.row_min:obj.row_max
            row = r - obj.row_min + 1;
            for c = obj.col_min:obj.col_max
                col = c - obj.col_min + 1;
                if r >=1 && r <= image1_size(1) && c >=1 && c <= image1_size(2)
                    canvas(row,col,:) = image1(r,c,:);
                else
                    xyz = iH * [r c 1]';
                    xyz = xyz ./ xyz(3);
                    if xyz(1) >= 1 && xyz(1) <= image2_size(1) && xyz(2) >= 1 && xyz(2) <= image2_size(2)
                        x = xyz(1);
                        y = xyz(2);
                        x_f = floor(x);
                        x_c = ceil(x);
                        y_f = floor(y);
                        y_c = ceil(y);
                        
                        value = double([image2(x_f,y_f,:); image2(x_c,y_f,:); image2(x_f,y_c,:); image2(x_c,y_c,:)]);
                        d = [sqrt((x_f-x)^2 + (y_f-y)^2); sqrt((x_c-x)^2 + (y_f-y)^2); sqrt((x_f-x)^2 + (y_c-y)^2); sqrt((x_c-x)^2 + (y_c-y)^2)];
                        alfa = exp(-6 * d);
                        alfa = alfa / sum(alfa);
                        
                        canvas(row,col,1) =  alfa' * value(:,:,1);
                        canvas(row,col,2) =  alfa' * value(:,:,2);
                        canvas(row,col,3) =  alfa' * value(:,:,3);
                    end
                end
            end
        end
        
        % imshow(ycbcr2rgb(uint8(canvas)));
        
        Y = canvas(:,:,1)';
        U = canvas(:,:,2)';
        V = canvas(:,:,3)';
        fwrite(fid_yuv,uint8(Y));
        fwrite(fid_yuv,uint8(U));
        fwrite(fid_yuv,uint8(V));
    end
    
    fclose(fid_yuv1);
    fclose(fid_yuv2);
    fclose(fid_yuv);
    
    yuv = 'result.yuv'; 
    width = obj.width; 
    height = obj.height; 
    chroma = 'yuv444p';
end