function [match_count,match_index_pair,inlier_count,inlier_index_pair] = neighbour(images)
%NEIGHBOUR 计算图像两两之间的匹配点数
%   此处显示详细说明
    number_of_images = length(images);
    match_count = zeros(number_of_images);
    inlier_count = zeros(number_of_images);
    
    for n = 1:number_of_images
        for m = (n+1):number_of_images
            [match_n2m_idx_pair,inlier_n2m_idx_pair] = itool.ImageStitcher.find_match(images(n).features_points,images(m).features_points);
            match_count(n,m) = length(match_n2m_idx_pair);
            inlier_count(n,m) = length(inlier_n2m_idx_pair);
            match_index_pair(n,m).match_idx_pair = match_n2m_idx_pair;
            match_index_pair(m,n).match_idx_pair = match_n2m_idx_pair(:,end:-1:1);
            inlier_index_pair(n,m).inlier_idx_pair = inlier_n2m_idx_pair;
            inlier_index_pair(m,n).inlier_idx_pair = inlier_n2m_idx_pair(:,end:-1:1);
        end
    end
    
    match_count = triu(match_count,1) + triu(match_count,1)';
    inlier_count = triu(inlier_count,1) + triu(inlier_count,1)';
    
    % 滤除所有小于10的元素
    inlier_count(inlier_count<10) = 0;
    match_count(inlier_count==0) = 0;
    
    % 根据inliers_count设定inliers
    for n = 1:number_of_images
        for m = 1:number_of_images
            if inlier_count(n,m) == 0
                inlier_index_pair(n,m).inlier_idx_pair = [];
                match_index_pair(n,m).match_idx_pair = [];
            end
        end
    end
end

