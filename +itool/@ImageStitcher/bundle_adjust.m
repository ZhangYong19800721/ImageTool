function obj = bundle_adjust(obj,images) % 
%BUNDLE_ADJUST 对输入的N个image，作群体微调
%   此处显示详细说明
    number_of_images = length(images);
    
    % 选定第1个图像为中央对齐图像
    obj.cameras(1).P = [0 0 0 1]';
    obj.cameras(1).R = expm(zeros(3));
    obj.cameras(1).K = diag([1 1 1]);

    bundle_group = 1;

    for n = 1:number_of_images % 抽取SURF特征，记录特征点坐标和描述向量
        yuv_image = images(n).image;
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
        
        obj.cameras(next_image_idx).P = obj.cameras(near_image_idx).P;
                
        x_start = []; % 准备搜索的起始位置
        for k = 1:length(bundle_group)
            x_start = cat(2,x_start,obj.cameras(bundle_group(k)).P);
        end
        
        options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt', ...
            'MaxFunEvals',1e6,'TolFun',1e-8,'TolX',1e-8,'MaxIter',1e4,'Display','iter');

        % 对bundle_group中的图像作群体调整，用levenberg-marquardt算法进行最优化
        x_solution = lsqnonlin(@error_func,x_start,[],[],options);
        
        % 将解向量变换为P,R,K矩阵
        for k = 1:length(bundle_group)
            ss = x_solution(:,k);
            obj.cameras(bundle_group(k)).P = ss;
            obj.cameras(bundle_group(k)).R = expm([0 -ss(3) ss(2); ss(3) 0 -ss(1); -ss(2) ss(1) 0]);
            obj.cameras(bundle_group(k)).K = diag([ss(4) ss(4) 1]);
        end
    end
    
    obj.sequence = bundle_group;
    
    function f = error_func(x) % 内层嵌套函数,和lsqnonlin函数配合求最优解
        f = [];
        num = length(bundle_group); % 需要位置寻优的图像个数=bundle_group元素个数
        R = zeros(3,3,num);
        K = zeros(3,3,num);
        
        for p = 1:num
            R(:,:,p) = expm([0 -x(3,p) x(2,p); x(3,p) 0 -x(1,p); -x(2,p) x(1,p) 0]);
            K(:,:,p) = diag([x(4,p) x(4,p) 1]);
        end
        
        for p = 1:num
            for q = (p+1):num
                image_idx1 = bundle_group(p);
                image_idx2 = bundle_group(q);
                if match_count(image_idx1,image_idx2) ~= 0
                    inlier_pair = inlier_index_pair(image_idx1,image_idx2).inlier_idx_pair;
                    Xp = images(image_idx1).features_points.location(1,inlier_pair(:,1));
                    Yp = images(image_idx1).features_points.location(2,inlier_pair(:,1));
                    Xq = images(image_idx2).features_points.location(1,inlier_pair(:,2));
                    Yq = images(image_idx2).features_points.location(2,inlier_pair(:,2));
                    Zp = 1000 * ones(1,length(Xp)); 
                    Zq = 1000 * ones(1,length(Xq)); 
                    Cp = cat(1,Xp,Yp,Zp);
                    Cq = cat(1,Xq,Yq,Zq);
                    Cp_predict = K(:,:,p) * R(:,:,p) * R(:,:,q)' * diag(1./diag(K(:,:,q))) * Cq;
                    Cp_predict = 1000 * Cp_predict ./ repmat(Cp_predict(3,:),3,1);
                    error_value = Cp(1:2,:) - Cp_predict(1:2,:);
                    distance = sqrt(sum(error_value.^2));
                    % distance(distance > delta) = sqrt(delta * distance(distance > delta) - delta.^2);
                    % distance = distance ./ match_count(image_idx1,image_idx2);
                    f = cat(2,f,distance);
                end
            end
        end
    end
end
