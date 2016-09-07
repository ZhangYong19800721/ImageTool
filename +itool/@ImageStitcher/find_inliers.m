function inliers = find_inliers(features_point1, features_point2)
%FIND_INLIERS 计算两组特征之间的inliers
%   此处显示详细说明
    index_pairs = matchFeatures(features_point1.Descript, features_point2.Descript);
    number_of_matchpoints = length(index_pairs);
    delta = 5; % 当匹配点之间的距离小于delta时是一个inlier点
     
    X1 = features_point1.Location(1,index_pairs(:,1));
    Y1 = features_point1.Location(2,index_pairs(:,1));
    X2 = features_point2.Location(1,index_pairs(:,2));
    Y2 = features_point2.Location(2,index_pairs(:,2));
    C1 = cat(1,X1,Y1,ones(1,length(X1)));
    C2 = cat(1,X2,Y2,ones(1,length(X2)));
    
    % RANSAC算法
    max_num = 2000; % 最大重复2000次
    num_inliers = 0; % inliers的数目
    for m = 1:max_num 
        point_index = randperm(number_of_matchpoints,4); % 随机选择4对匹配点
        selected_points1 = C1(:,point_index);
        selected_points2 = C2(:,point_index);
        CurrentH = itool.ImageStitcher.DLT(selected_points1,selected_points2);
        
        % 计算inliers的个数
        x = CurrentH * C2; x = x ./ repmat(x(3,:),3,1);
        diff = C1(1:2,:) - x(1:2,:);
        epsi = sqrt(sum(diff.^2));
        current_inliers = sum(epsi < delta);
        if current_inliers > num_inliers
            num_inliers = current_inliers;
            H = CurrentH;
        end
    end
    
    % 
    x = H * C2; x = x ./ repmat(x(3,:),3,1);
    diff = C1(1:2,:) - x(1:2,:);
    epsi = sqrt(sum(diff.^2));
    inliers(:,1) = index_pairs(epsi < delta,1);
    inliers(:,2) = index_pairs(epsi < delta,2);
end

