function obj = initialize(obj,movie,mask)
%INITIALIZE 根据movie和mask对videoinpainter类进行初始化
%   
    [obj.row_num, obj.col_num, obj.channel_num, obj.frame_num] = size(movie);
    obj.mask = repmat(mask,1,1,obj.frame_num);
    obj.movie_gradient_x = zeros(obj.row_num, obj.col_num, obj.channel_num, obj.frame_num);
    obj.movie_gradient_y = zeros(obj.row_num, obj.col_num, obj.channel_num, obj.frame_num);
    
    for frame = 1:obj.frame_num
        for color = 1:obj.channel_num
            [obj.movie_gradient_x(:,:,color,frame),obj.movie_gradient_y(:,:,color,frame)] = ...
                gradient(double(movie(:,:,color,frame)));
        end
    end
end

