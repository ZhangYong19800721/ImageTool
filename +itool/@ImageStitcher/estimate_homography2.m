function H = estimate_homography2(image1, f1, image2, f2)
%ESTIMATE_HOMOGRAPHY 根据两幅图像估计它们之间的透视变换矩阵
%   image1：第1幅图像，必须是灰度图像
%   f1: 第1幅图像的焦距
%   image2: 第2幅图像，必须是灰度图像
%   f2: 第2幅图像的焦距
%   H：从第2幅图到第1幅图的透视变换矩阵，3x3。
    feature_points_group1 = detectSURFFeatures(image1);
    feature_points_group2 = detectSURFFeatures(image2);

    [features1, vpts1] = extractFeatures(image1, feature_points_group1);
    [features2, vpts2] = extractFeatures(image2, feature_points_group2);
    
    index_pairs = matchFeatures(features1, features2);
    number_of_matchpoints = length(index_pairs);
    
    match_points1 = f1 * ones(3,number_of_matchpoints);
    match_points2 = f2 * ones(3,number_of_matchpoints);
    
    delta = 3;

    % 组建两个match_points的组
    for n = 1:number_of_matchpoints
        pos1 = vpts1(index_pairs(n,1)).Location';
        pos2 = vpts2(index_pairs(n,2)).Location';
        match_points1(1:2,n) = pos1(end:-1:1);
        match_points2(1:2,n) = pos2(end:-1:1);
    end
    
    [image1_row, image1_col] = size(image1);
    [image2_row, image2_col] = size(image2);
    image1_midx = (image1_row - 1)/2 + 1;
    image1_midy = (image1_col - 1)/2 + 1;
    image2_midx = (image2_row - 1)/2 + 1;
    image2_midy = (image2_col - 1)/2 + 1;
    
    match_points1(1,:) = match_points1(1,:) - image1_midx;
    match_points1(2,:) = match_points1(2,:) - image1_midy;
    match_points2(1,:) = match_points2(1,:) - image2_midx;
    match_points2(2,:) = match_points2(2,:) - image2_midy;
    
    % RANSAC算法
    max_num = 2000; % 最大重复2000次
    num_inliers = 0; % inliers的数目
    for m = 1:max_num 
        point_index = randperm(number_of_matchpoints,4); % 随机选择4对匹配点
        selected_points1 = match_points1(:,point_index);
        selected_points2 = match_points2(:,point_index);
        CH = itool.VideoStitcher.DLT(selected_points1,selected_points2);
        
        % 计算inliers的个数
        x = CH * match_points2; x = f1 * (x ./ repmat(x(3,:),3,1));
        diff = match_points1(1:2,:) - x(1:2,:);
        epsi = sqrt(sum(diff.^2));
        current_inliers = sum(epsi < delta);
        if current_inliers > num_inliers
            num_inliers = current_inliers;
            H = CH;
        end
    end
    
    % 根据所有的inliers再次估计H
    x = H * match_points2; x = f1 * (x ./ repmat(x(3,:),3,1));
    diff = match_points1(1:2,:) - x(1:2,:);
    epsi = sqrt(sum(diff.^2));
    inlier_index = (epsi < delta);
    selected_points1 = match_points1(:,inlier_index);
    selected_points2 = match_points2(:,inlier_index);
    H = itool.VideoStitcher.DLT(selected_points1,selected_points2);
end

