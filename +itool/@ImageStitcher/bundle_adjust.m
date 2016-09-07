function obj = bundle_adjust(obj,images,radius) % 
%BUNDLE_ADJUST 对输入的N个image，作群体微调
%   此处显示详细说明
    number_of_images = length(images);
    
    % 选定第1个图像为中央对齐图像
    obj.cameras(1).H = eye(3); obj.cameras(1).H(3,3) = 1/2.5;
    bundle_group = 1;

    for n = 1:number_of_images % 抽取Surf特征，记录特征点坐标和描述向量
        images(n).gray_image = rgb2gray(images(n).image);
        surf_points = detectSURFFeatures(images(n).gray_image);
        [features_descript, features_points] = extractFeatures(images(n).gray_image, surf_points);
        [image_row,image_col] = size(images(n).gray_image);
        image_midx = (image_row - 1) / 2 + 1; image_midy = (image_col - 1) / 2 + 1;
        images(n).features_points.Location(1,:) = double(features_points.Location(:,2)) - image_midx;
        images(n).features_points.Location(2,:) = double(features_points.Location(:,1)) - image_midy;
        images(n).features_points.Descript = features_descript;
    end
    
    % 计算图像两两之间的匹配点数
    match_count = itool.ImageStitcher.neighbour(images);
    
    while length(bundle_group) < number_of_images
        match_col = match_count(bundle_group,:); 
        match_col = sum(match_col,1);
        [~,next_image_index] = max(match_col); % 找到准备加入bundle_adjuster的下一个图像
        bundle_group = [bundle_group next_image_index]; % 将next_image_index加入bundle_adjuster
        %%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    inlier_index_pairs = itool.ImageStitcher.find_inliers(images(1).features_points,images(2).features_points);
    
    X1 = images(1).features_points.Location(1,inlier_index_pairs(:,1));
    Y1 = images(1).features_points.Location(2,inlier_index_pairs(:,1));
    X2 = images(2).features_points.Location(1,inlier_index_pairs(:,2));
    Y2 = images(2).features_points.Location(2,inlier_index_pairs(:,2));
    Z1 = radius * ones(1,length(X1)); C1 = cat(1,X1,Y1,Z1);
    Z2 = radius * ones(1,length(X2)); C2 = cat(1,X2,Y2,Z2);
    H12 = itool.ImageStitcher.DLT(C1,C2); H12 = H12 ./ H12(3,3);

    x_start = H12 \ obj.cameras(1).H; x_start = x_start / x_start(3,3); x_start = x_start(1:8);
    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt', ...
        'MaxFunEvals',1e5,'TolFun',1e-13,'TolX',1e-13,'MaxIter',1e5,'Display','iter');
    x_solution = lsqnonlin(@fun,x_start,[],[],options);
    x_solution = reshape(x_solution,8,[]);
    obj.cameras(2).H = reshape([x_solution(:,1)' 1],3,3);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function f = fun(x) % 内层嵌套函数,用来和lsqnonlin函数配合求最优解
        HA = reshape(x,8,[]); 
        [~,num] = size(HA); 
        HA = cat(1,HA,ones(1,num)); 
        HA = reshape(HA,3,3,[]);
        C1_predict = HA * (obj.cameras(1).H \ C1); C1_predict = radius * C1_predict ./ repmat(C1_predict(3,:),3,1);
        C2 = radius * C2 ./ repmat(C2(3,:),3,1);
        D = C2 - C1_predict;
        f = sqrt(D(1,:).^2 + D(2,:).^2);
    end
end
