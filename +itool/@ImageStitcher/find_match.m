function [match_index_pairs,inlier_index_pairs] = find_match(features_point1, features_point2)
%FIND_INLIERS ������������֮���inliers
%   �˴���ʾ��ϸ˵��
    match_index_pairs = matchFeatures(features_point1.descript, features_point2.descript);
    match_count = length(match_index_pairs);
    delta = 2; % ��ƥ���֮��ľ���С��deltaʱ��һ��inlier��
     
    X1 = features_point1.location(1,match_index_pairs(:,1));
    Y1 = features_point1.location(2,match_index_pairs(:,1));
    X2 = features_point2.location(1,match_index_pairs(:,2));
    Y2 = features_point2.location(2,match_index_pairs(:,2));
    Z1 = ones(1,length(X1));
    Z2 = ones(1,length(X2));
    C1 = cat(1,X1,Y1,Z1);
    C2 = cat(1,X2,Y2,Z2);
    
    % RANSAC�㷨
    repeat_num = 2000; % ����ظ�2000��
    max_inlier_count = 0; % inliers����Ŀ
    for m = 1:repeat_num 
        selected_points_index = randperm(match_count,4); % ���ѡ��4��ƥ���
        selected_points_group1 = C1(:,selected_points_index);
        selected_points_group2 = C2(:,selected_points_index);
        current_H = itool.ImageStitcher.DLT(selected_points_group1,selected_points_group2);
        
        % ����inliers�ĸ���
        predict_C1 = current_H * C2; 
        predict_C1 = predict_C1 ./ repmat(predict_C1(3,:),3,1);
        error_value = C1(1:2,:) - predict_C1(1:2,:);
        distance = sqrt(sum(error_value.^2));
        inlier_count = sum(distance < delta);
        if inlier_count > max_inlier_count
            max_inlier_count = inlier_count;
            H = current_H;
        end
    end
    
    % 
    predict_C1 = H * C2; 
    predict_C1 = predict_C1 ./ repmat(predict_C1(3,:),3,1);
    error_value = C1(1:2,:) - predict_C1(1:2,:);
    distance = sqrt(sum(error_value.^2));
    inlier_index_pairs(:,1) = match_index_pairs(distance < delta,1);
    inlier_index_pairs(:,2) = match_index_pairs(distance < delta,2);
end

