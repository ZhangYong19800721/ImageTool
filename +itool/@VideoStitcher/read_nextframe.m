function image = read_nextframe( obj,fid,width,height,chroma_format )
%READ_NEXTFRAME 此处显示有关此函数的摘要
%   此处显示详细说明
    [cw, ch] = obj.chroma(width,height,chroma_format);
    image = zeros([height width 3]);
    
    Y = fread(fid,[width height],'uchar')';
    U = fread(fid,[cw ch],'uchar')';
    V = fread(fid,[cw ch],'uchar')';
        
    U = imresize(U,2);
    V = imresize(V,2);
    
    image(:,:,1) = Y;
    image(:,:,2) = U;
    image(:,:,3) = V;
    
    image = uint8(image);
end

