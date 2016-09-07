function obj = bundle_adjust(obj,images,radius) % 
%BUNDLE_ADJUST 对输入的N个image，作群体微调
%   此处显示详细说明
    number_of_images = length(images);
    
    % 选定第1个图像为中央对齐图像
    obj.cameras(1).H = eye(3); obj.cameras(1).H(3,3) = 1/2.5; obj.cameras(1).H = obj.cameras(1).H / obj.cameras(1).H(3,3);
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
    [inliers_count,inliers] = itool.ImageStitcher.neighbour(images);
    
    % 将图像一幅一幅地加入bundle_adjuster,并对bundle_group中的图像作群体调整
    while length(bundle_group) < number_of_images
        match_col = inliers_count(bundle_group,:); 
        match_col = sum(match_col,1); match_col(bundle_group) = 0;
        [~,next_image_idx] = max(match_col); % 找到准备加入bundle_adjuster的下一个图像
        bundle_group = [bundle_group next_image_idx]; % 将next_image_idx加入bundle_group
        
        % 构造寻优的起始点
        near = inliers_count(next_image_idx,:); 
        near(setxor(1:number_of_images,bundle_group)) = 0;
        [~,near_image_idx] = max(near);
        
        inlier_index_pairs = inliers(near_image_idx,next_image_idx).inliers;
        X1 = images(near_image_idx).features_points.Location(1,inlier_index_pairs(:,1));
        Y1 = images(near_image_idx).features_points.Location(2,inlier_index_pairs(:,1));
        X2 = images(next_image_idx).features_points.Location(1,inlier_index_pairs(:,2));
        Y2 = images(next_image_idx).features_points.Location(2,inlier_index_pairs(:,2));
        Z1 = radius * ones(1,length(X1)); C1 = cat(1,X1,Y1,Z1);
        Z2 = radius * ones(1,length(X2)); C2 = cat(1,X2,Y2,Z2);
        H12 = itool.ImageStitcher.DLT(C1,C2); H12 = H12 ./ H12(3,3);
        obj.cameras(next_image_idx).H = H12 \ obj.cameras(near_image_idx).H;
        obj.cameras(next_image_idx).H = obj.cameras(next_image_idx).H ./ obj.cameras(next_image_idx).H(3,3);
        
        x_start = [];
        for k = 2:length(bundle_group)
            H_k = obj.cameras(bundle_group(k)).H ./ obj.cameras(bundle_group(k)).H(3,3);
            x_start = cat(2,x_start,H_k(1:8));
        end
        
        % 对bundle_group中的图像作群体调整，用levenberg-marquardt算法进行最优化
        options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt', ...
            'MaxFunEvals',1e5,'TolFun',1e-8,'TolX',1e-8,'MaxIter',1e4,'Display','iter');
        x_solution = lsqnonlin(@optim_func,x_start,[],[],options);
        
        % 将解向量变换为H矩阵
        x_solution = reshape(x_solution,8,length(bundle_group)-1);
        x_solution = cat(1,x_solution,ones(1,length(bundle_group)-1));
        x_solution = reshape(x_solution,3,3,[]);
        for k = 2:length(bundle_group)
            obj.cameras(bundle_group(k)).H = x_solution(:,:,k-1);
        end
    end
    
    function f = optim_func(x) % 内层嵌套函数,和lsqnonlin函数配合求最优解
        f = [];
        num = length(bundle_group); % 需要位置寻优的图像个数=bundle_group元素个数
        H = reshape(x,8,num-1); 
        H = cat(1,H,ones(1,num-1)); 
        H = reshape(H,3,3,num-1); 
        H = cat(3,obj.cameras(1).H,H); % 构造所有的H矩阵 
        for p = 1:num
            % for q = 1:num
            for q = (p+1):num
                if q~=p
                    image_idx1 = bundle_group(p);
                    image_idx2 = bundle_group(q);
                    inliers_pair = inliers(image_idx1,image_idx2).inliers;
                    if ~isempty(inliers_pair)
                        Xp = images(image_idx1).features_points.Location(1,inliers_pair(:,1));
                        Yp = images(image_idx1).features_points.Location(2,inliers_pair(:,1));
                        Xq = images(image_idx2).features_points.Location(1,inliers_pair(:,2));
                        Yq = images(image_idx2).features_points.Location(2,inliers_pair(:,2));
                        Zp = radius * ones(1,length(Xp)); Cp = cat(1,Xp,Yp,Zp);
                        Zq = radius * ones(1,length(Xq)); Cq = cat(1,Xq,Yq,Zq);
                        Cq_predict = H(:,:,p) * (H(:,:,q) \ Cq);
                        Cq_predict = radius * Cq_predict ./ repmat(Cq_predict(3,:),3,1);
                        Dis = Cp - Cq_predict;
                        Dis = sqrt(Dis(1,:).^2 + Dis(2,:).^2);
                        f = cat(2,f,Dis);
                    end
                end
            end
        end
    end
end
