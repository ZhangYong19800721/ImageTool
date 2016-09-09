function obj = bundle_adjust(obj,images,radius) % 
%BUNDLE_ADJUST �������N��image����Ⱥ��΢��
%   �˴���ʾ��ϸ˵��
    number_of_images = length(images);
    
    % ѡ����1��ͼ��Ϊ�������ͼ��
    obj.cameras(1).H = eye(3); obj.cameras(1).H(3,3) = 1/2.5;
    bundle_group = 1;

    for n = 1:number_of_images % ��ȡSurf��������¼�������������������
        images(n).gray_image = rgb2gray(images(n).image);
        surf_points = detectSURFFeatures(images(n).gray_image);
        [features_descript, features_points] = extractFeatures(images(n).gray_image, surf_points);
        [image_row,image_col] = size(images(n).gray_image);
        image_midx = (image_row - 1) / 2 + 1; image_midy = (image_col - 1) / 2 + 1;
        images(n).features_points.Location(1,:) = double(features_points.Location(:,2)) - image_midx;
        images(n).features_points.Location(2,:) = double(features_points.Location(:,1)) - image_midy;
        images(n).features_points.Descript = features_descript;
    end
    
    % ����ͼ������֮���ƥ�����
    [inliers_count,inliers] = itool.ImageStitcher.neighbour(images);
    
    % ��ͼ��һ��һ���ؼ���bundle_adjuster,����bundle_group�е�ͼ����Ⱥ�����
    while length(bundle_group) < number_of_images
        match_col = inliers_count(bundle_group,:); 
        match_col = sum(match_col,1); match_col(bundle_group) = 0;
        [~,next_image_idx] = max(match_col); % �ҵ�׼������bundle_adjuster����һ��ͼ��
        bundle_group = [bundle_group next_image_idx]; % ��next_image_idx����bundle_group
        
        % ����Ѱ�ŵ���ʼ��
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
        
        x_start = [];
        for k = 1:length(bundle_group)
            H_K = obj.cameras(bundle_group(k)).H;
            x_start = cat(2,x_start,H_K(1:9));
        end
        
        % ��bundle_group�е�ͼ����Ⱥ���������levenberg-marquardt�㷨�������Ż�
        options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt', ...
            'MaxFunEvals',1e6,'TolFun',1e-8,'TolX',1e-8,'MaxIter',1e4,'Display','iter');
        x_solution = lsqnonlin(@optim_func,x_start,[],[],options);
        
        % ���������任ΪH����
        x_solution = reshape(x_solution,3,3,[]);
        for k = 1:length(bundle_group)
            obj.cameras(bundle_group(k)).H = x_solution(:,:,k);
        end
    end
    
    function f = optim_func(x) % �ڲ�Ƕ�׺���,��lsqnonlin������������Ž�
        f = [];
        num = length(bundle_group); % ��Ҫλ��Ѱ�ŵ�ͼ�����=bundle_groupԪ�ظ���
        H = reshape(x,3,3,num); % �������е�H���� H(1:8) = obj.cameras(1).H(1:8); 
        for p = 1:num
            for q = (p+1):num
                image_idx1 = bundle_group(p);
                image_idx2 = bundle_group(q);
                if inliers_count(image_idx1,image_idx2) ~= 0
                    inliers_pair = inliers(image_idx1,image_idx2).inliers;
                    Xp = images(image_idx1).features_points.Location(1,inliers_pair(:,1));
                    Yp = images(image_idx1).features_points.Location(2,inliers_pair(:,1));
                    Xq = images(image_idx2).features_points.Location(1,inliers_pair(:,2));
                    Yq = images(image_idx2).features_points.Location(2,inliers_pair(:,2));
                    Zp = radius * ones(1,length(Xp)); Cp = cat(1,Xp,Yp,Zp);
                    Zq = radius * ones(1,length(Xq)); Cq = cat(1,Xq,Yq,Zq);
                    Cq_predict = H(:,:,p) * (H(:,:,q) \ Cq);
                    Cq_predict = radius * Cq_predict ./ repmat(Cq_predict(3,:),3,1);
                    Dis = Cp - Cq_predict;
                    Dis = sqrt((Dis(1,:).^2 + Dis(2,:).^2) ./ inliers_count(image_idx1,image_idx2));
                    f = cat(2,f,Dis);
                end
            end
        end
    end
end
