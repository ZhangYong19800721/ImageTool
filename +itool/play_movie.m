function exit_code = play_movie(movie_data)
%play_movie ²¥·Åmovie_dataÖÐµÄÖ¡
%   
    figure; hold;
    [~,~,~,frame_num] = size(movie_data);
    for frame = 1:frame_num
        imshow(ycbcr2rgb(movie_data(:,:,:,frame)));
    end
    exit_code = 0;
end

