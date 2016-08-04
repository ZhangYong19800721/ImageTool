function obj = estimate( obj, input_yuv1, width1, height1, input_yuv2, width2, height2)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    fid_yuv1 = fopen(input_yuv1,'r');
    fid_yuv2 = fopen(input_yuv2,'r');
    
    [cw1 ch1] = obj.chroma(width1,height1,'yuv420p');
    [cw2 ch2] = obj.chroma(width2,height2,'yuv420p');
    
    image1 = uint8(fread(fid_yuv1,[width1 height1],'uchar'))';
    image2 = uint8(fread(fid_yuv2,[width2 height2],'uchar'))';
    
    obj = obj.estimate_homography_matrix(image1,image2);
    
    image1_size = size(image1);
    image2_size = size(image2);
    
    image1_corner = [1 1 1;1 image1_size(2) 1;image1_size(1) 1 1;image1_size(1) image1_size(2) 1]';
    image2_corner = [1 1 1;1 image2_size(2) 1;image2_size(1) 1 1;image2_size(1) image2_size(2) 1]';
    
    image2_transform_corner = obj.H * image2_corner;
    image2_transform_corner = image2_transform_corner ./ repmat(image2_transform_corner(3,:),3,1);
    
    canvas_corner = [image1_corner image2_transform_corner];
    s_side = min(canvas_corner(1,:));
    n_side = max(canvas_corner(1,:));
    w_side = min(canvas_corner(2,:));
    e_side = max(canvas_corner(2,:));
    
    obj.row_min = floor(s_side);
    obj.row_max = ceil(n_side);
    obj.col_min = floor(w_side);
    obj.col_max = ceil(e_side);
    
    obj.width = obj.col_max - obj.col_min + 1;
    obj.height = obj.row_max - obj.row_min + 1;
    
    fclose(fid_yuv1);
    fclose(fid_yuv2);
end

