function obj = initialize(obj,movie,mask)
%INITIALIZE 根据movie和mask对videoinpainter类进行初始化
%   
    [obj.row_num, obj.col_num, obj.channel_num, obj.frame_num] = size(movie);
    
    obj.mask3d = repmat(mask,1,1,obj.frame_num);
    
    obj.movie_Y = zeros(obj.row_num, obj.col_num, obj.frame_num);
    obj.movie_U = zeros(obj.row_num, obj.col_num, obj.frame_num);
    obj.movie_V = zeros(obj.row_num, obj.col_num, obj.frame_num);
    
    for frame = 1:obj.frame_num
        obj.movie_Y(:,:,frame) = double(movie(:,:,1,frame));
        obj.movie_U(:,:,frame) = double(movie(:,:,2,frame));
        obj.movie_V(:,:,frame) = double(movie(:,:,3,frame));
    end
end

