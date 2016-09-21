function exit = play(obj,frame_num)
    obj = obj.open('r');
    [r, c] = itool.YUV.color_space(obj.row_num,obj.col_num,obj.format);
    
    for f = 1:frame_num
        Y = fread(obj.fid,[obj.col_num obj.row_num],'uchar')';
        U = fread(obj.fid,[c r],'uchar')';
        V = fread(obj.fid,[c r],'uchar')';
        
        U = imresize(U,[obj.row_num obj.col_num]);
        V = imresize(V,[obj.row_num obj.col_num]);
        imshow(ycbcr2rgb(uint8(cat(3,Y,U,V))));
    end
    
    obj.close();
    exit = 0;
end

