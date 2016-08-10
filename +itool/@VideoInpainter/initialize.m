function obj = initialize(obj,movie,mask)
%INITIALIZE 根据movie和mask对videoinpainter类进行初始化
%   
    [obj.row_num, obj.col_num, obj.channel_num, obj.frame_num] = size(movie);
    
    obj.mask3d = repmat(mask,1,1,obj.frame_num);
    
    obj.movie_Y_Gx = zeros(obj.row_num, obj.col_num, obj.frame_num);
    obj.movie_Y_Gy = zeros(obj.row_num, obj.col_num, obj.frame_num);
    obj.movie_U_Gx = zeros(obj.row_num, obj.col_num, obj.frame_num);
    obj.movie_U_Gy = zeros(obj.row_num, obj.col_num, obj.frame_num);
    obj.movie_V_Gx = zeros(obj.row_num, obj.col_num, obj.frame_num);
    obj.movie_V_Gy = zeros(obj.row_num, obj.col_num, obj.frame_num);
    
    for frame = 1:obj.frame_num
        [obj.movie_Y_Gx(:,:,frame),obj.movie_Y_Gy(:,:,frame)] = gradient(double(movie(:,:,1,frame)));
        [obj.movie_U_Gx(:,:,frame),obj.movie_U_Gy(:,:,frame)] = gradient(double(movie(:,:,2,frame)));
        [obj.movie_V_Gx(:,:,frame),obj.movie_V_Gy(:,:,frame)] = gradient(double(movie(:,:,3,frame)));
    end
end

