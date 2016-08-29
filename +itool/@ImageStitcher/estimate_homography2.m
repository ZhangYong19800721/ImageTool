function H = estimate_homography2(image1, f1, image2, f2)
%ESTIMATE_HOMOGRAPHY ��������ͼ���������֮���͸�ӱ任����
%   image1����1��ͼ�񣬱����ǻҶ�ͼ��
%   f1: ��1��ͼ��Ľ���
%   image2: ��2��ͼ�񣬱����ǻҶ�ͼ��
%   f2: ��2��ͼ��Ľ���
%   H���ӵ�2��ͼ����1��ͼ��͸�ӱ任����3x3��
    feature_points_group1 = detectSURFFeatures(image1);
    feature_points_group2 = detectSURFFeatures(image2);

    [features1, vpts1] = extractFeatures(image1, feature_points_group1);
    [features2, vpts2] = extractFeatures(image2, feature_points_group2);
    
    index_pairs = matchFeatures(features1, features2);
    number_of_matchpoints = length(index_pairs);
    
    match_points1 = f1 * ones(3,number_of_matchpoints);
    match_points2 = f2 * ones(3,number_of_matchpoints);
    
    delta = 3;

    % �齨����match_points����
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
    
    % RANSAC�㷨
    max_num = 2000; % ����ظ�2000��
    num_inliers = 0; % inliers����Ŀ
    for m = 1:max_num 
        point_index = randperm(number_of_matchpoints,4); % ���ѡ��4��ƥ���
        selected_points1 = match_points1(:,point_index);
        selected_points2 = match_points2(:,point_index);
        CH = itool.VideoStitcher.DLT(selected_points1,selected_points2);
        
        % ����inliers�ĸ���
        x = CH * match_points2; x = f1 * (x ./ repmat(x(3,:),3,1));
        diff = match_points1(1:2,:) - x(1:2,:);
        epsi = sqrt(sum(diff.^2));
        current_inliers = sum(epsi < delta);
        if current_inliers > num_inliers
            num_inliers = current_inliers;
            H = CH;
        end
    end
    
    % �������е�inliers�ٴι���H
    x = H * match_points2; x = f1 * (x ./ repmat(x(3,:),3,1));
    diff = match_points1(1:2,:) - x(1:2,:);
    epsi = sqrt(sum(diff.^2));
    inlier_index = (epsi < delta);
    selected_points1 = match_points1(:,inlier_index);
    selected_points2 = match_points2(:,inlier_index);
    H = itool.VideoStitcher.DLT(selected_points1,selected_points2);
end

