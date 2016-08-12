classdef YUV
    %YUV 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        fid;
        filename;
        row_num;
        col_num;
        frame_num;
        format;
    end
    
    methods(Static)
        function exit = play(filename,row,col,frame_num,format)
            fid = fopen(filename,'r');
            [cr, cc] = itool.color_space(row,col,format);
            
            for f = 1:frame_num
                f
                Y = fread(fid,[col row],'uchar')';
                U = fread(fid,[cc cr],'uchar')';
                V = fread(fid,[cc cr],'uchar')';
            
                U = imresize(U,[row col]);
                V = imresize(V,[row col]);
                warning off;
                imshow(ycbcr2rgb(uint8(cat(3,Y,U,V))));
            end
            
            fclose(fid);
            exit = 0;
        end
    end
    
end

