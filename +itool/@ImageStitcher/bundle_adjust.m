function obj = bundle_adjust(obj,images) % 
%BUNDLE_ADJUST 对输入的N个image，作群体微调
%   此处显示详细说明
    number_of_images = length(images);
    
    % 选定第1个图像为中央对齐图像
    obj.cameras(1).H = eye(3); obj.cameras(1).H(3,3) = 1/2;
    bundle_group = 1;

    for n = 1:number_of_images % 抽取SURF特征，记录特征点坐标和描述向量
        yuv_image = rgb2ycbcr(images(n).image);
        surf_points = detectSURFFeatures(yuv_image(:,:,1));
        [features, points] = extractFeatures(yuv_image(:,:,1), surf_points);
        [image_row,image_col,~] = size(yuv_image);
        image_midx = (image_row - 1) / 2 + 1; %取得图像X轴中值点
        image_midy = (image_col - 1) / 2 + 1; %取得图像Y轴中值点
        images(n).features_points.location(1,:) = double(points.Location(:,2)) - image_midx; % 记录特征点的X坐标
        images(n).features_points.location(2,:) = double(points.Location(:,1)) - image_midy; % 记录特征点的Y坐标
        images(n).features_points.descript = features; % 记录特征向量
    end
    
    % 计算图像两两之间的匹配点数
    [match_count,match_index_pair,inlier_count,inlier_index_pair] = itool.ImageStitcher.neighbour(images);
    
    % 将图像一幅一幅地加入bundle_adjuster,并对bundle_group中的图像作群体调整
    while length(bundle_group) < number_of_images
        match_col = inlier_count(bundle_group,:); 
        match_col = sum(match_col,1); match_col(bundle_group) = 0;
        [~,next_image_idx] = max(match_col); % 找到准备加入bundle_adjuster的下一个图像
        bundle_group = [bundle_group next_image_idx]; % 将next_image_idx加入bundle_group
        
        % 构造寻优的起始点
        near = inlier_count(next_image_idx,:); 
        near(setxor(1:number_of_images,bundle_group)) = 0;
        [~,near_image_idx] = max(near);
        
        inlier_pair = inlier_index_pair(near_image_idx,next_image_idx).inlier_idx_pair;
        X1 = images(near_image_idx).features_points.location(1,inlier_pair(:,1));
        Y1 = images(near_image_idx).features_points.location(2,inlier_pair(:,1));
        X2 = images(next_image_idx).features_points.location(1,inlier_pair(:,2));
        Y2 = images(next_image_idx).features_points.location(2,inlier_pair(:,2));
        Z1 = 1000 * ones(1,length(X1)); 
        Z2 = 1000 * ones(1,length(X2)); 
        C1 = cat(1,X1,Y1,Z1);
        C2 = cat(1,X2,Y2,Z2);
        H12 = itool.ImageStitcher.DLT(C1,C2); 
        H12 = H12 ./ H12(3,3); % 很重要，用来确保做柱面投射时得到正确的结果
        obj.cameras(next_image_idx).H = H12 \ obj.cameras(near_image_idx).H;
        
%         obj.cameras(next_image_idx).H = obj.cameras(near_image_idx).H;
                
        x_start = []; % 准备搜索的起始位置
        for k = 1:length(bundle_group)
            x_start = cat(3,x_start,obj.cameras(bundle_group(k)).H);
        end
        
        options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt', ...
            'MaxFunEvals',1e6,'TolFun',1e-8,'TolX',1e-8,'MaxIter',1e4,'Display','iter');
        
        delta = 4096;
        x_solution = x_start;
        while delta ~= 2
            delta = max(2, delta / 2);
            % 对bundle_group中的图像作群体调整，用levenberg-marquardt算法进行最优化
            x_solution = lsqnonlin(@error_func,x_solution,[],[],options);
        end
        
        % 将解向量变换为H矩阵
        for k = 1:length(bundle_group)
            obj.cameras(bundle_group(k)).H = x_solution(:,:,k);
        end
    end
    
    function f = error_func(H) % 内层嵌套函数,和lsqnonlin函数配合求最优解
        f = [];
        num = length(bundle_group); % 需要位置寻优的图像个数=bundle_group元素个数
        % H = reshape(H,3,3,num); % 构造所有的H矩阵 
        H(1:9) = [1 0 0 0 1 0 0 0 1/2];
        for p = 1:num
            for q = (p+1):num
                image_idx1 = bundle_group(p);
                image_idx2 = bundle_group(q);
                if match_count(image_idx1,image_idx2) ~= 0
                    match_pair = match_index_pair(image_idx1,image_idx2).match_idx_pair;
                    Xp = images(image_idx1).features_points.location(1,match_pair(:,1));
                    Yp = images(image_idx1).features_points.location(2,match_pair(:,1));
                    Xq = images(image_idx2).features_points.location(1,match_pair(:,2));
                    Yq = images(image_idx2).features_points.location(2,match_pair(:,2));
                    Zp = 1000 * ones(1,length(Xp)); 
                    Zq = 1000 * ones(1,length(Xq)); 
                    Cp = cat(1,Xp,Yp,Zp);
                    Cq = cat(1,Xq,Yq,Zq);
                    Cq_predict = H(:,:,p) * (H(:,:,q) \ Cq);
                    Cq_predict = 1000 * Cq_predict ./ repmat(Cq_predict(3,:),3,1);
                    error_value = Cp(1:2,:) - Cq_predict(1:2,:);
                    distance = sqrt(sum(error_value.^2));
                    distance(distance > delta) = sqrt(delta * distance(distance > delta) - delta.^2);
                    % distance = distance ./ match_count(image_idx1,image_idx2);
                    f = cat(2,f,distance);
                end
            end
        end
    end
end
