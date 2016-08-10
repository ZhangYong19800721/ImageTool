function obj = initialize(obj,movie,mask)
%INITIALIZE 根据movie和mask对videoinpainter类进行初始化
%   
    obj.movie = movie;
    [obj.row_num, obj.col_num, obj.channel_num, obj.frame_num] = size(movie);
    
    obj.mask3d = repmat(mask,1,1,obj.frame_num);
    
    obj.movie_DIV_Y = zeros(obj.row_num, obj.col_num, obj.frame_num);
    obj.movie_DIV_U = zeros(obj.row_num, obj.col_num, obj.frame_num);
    obj.movie_DIV_V = zeros(obj.row_num, obj.col_num, obj.frame_num);
    
    for frame = 1:obj.frame_num
        [X,Y] = gradient(double(movie(:,:,1,frame)));
        obj.movie_DIV_Y(:,:,frame) = divergence(X,Y);
        
        [X,Y] = gradient(double(movie(:,:,2,frame)));
        obj.movie_DIV_U(:,:,frame) = divergence(X,Y);

        [X,Y] = gradient(double(movie(:,:,3,frame)));
        obj.movie_DIV_V(:,:,frame) = divergence(X,Y);
    end
end

