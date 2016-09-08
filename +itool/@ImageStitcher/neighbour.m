function [inliers_count,inliers] = neighbour(images)
%NEIGHBOUR 计算图像两两之间的匹配点数
%   此处显示详细说明
    number_of_images = length(images);
    inliers_count = zeros(number_of_images);
    for n = 1:number_of_images
        for m = (n+1):number_of_images
            inlier_index_pairs = itool.ImageStitcher.find_inliers(images(n).features_points,images(m).features_points);
            [count, ~] = size(inlier_index_pairs);
            inliers(n,m).inliers = inlier_index_pairs;
            inliers(m,n).inliers = inlier_index_pairs(:,end:-1:1);
            inliers_count(n,m) = count;
        end
    end
    
    inliers_count = triu(inliers_count,1) + triu(inliers_count,1)';
%     % 每一行中只取最大的两个元素
%     for n = 1:number_of_images
%         [~,sort_idx] = sort(inliers_count(n,:),'descend');
%         inliers_count(n,sort_idx(3:length(sort_idx))) = 0;
%     end
    
    % 滤除所有小于10的元素
    inliers_count(inliers_count<10) = 0;
    % 根据inliers_count设定inliers
    for n = 1:number_of_images
        for m = 1:number_of_images
            if inliers_count(n,m) == 0
                inliers(n,m).inliers = [];
            end
        end
    end
end

