function obj = bundle_adjust(obj,images) % 
%BUNDLE_ADJUST �������N��image����Ⱥ��΢��
%   �˴���ʾ��ϸ˵��
    number_of_images = length(images);
    
    % ѡ����1��ͼ��Ϊ�������ͼ��
    obj.cameras(1).P = [0 0 0 1]';
    obj.cameras(1).R = expm(zeros(3));
    obj.cameras(1).K = diag([1 1 1]);

    bundle_group = 1;

    for n = 1:number_of_images % ��ȡSURF��������¼�������������������
        yuv_image = images(n).image;
        surf_points = detectSURFFeatures(yuv_image(:,:,1));
        [features, points] = extractFeatures(yuv_image(:,:,1), surf_points);
        [image_row,image_col,~] = size(yuv_image);
        image_midx = (image_row - 1) / 2 + 1; %ȡ��ͼ��X����ֵ��
        image_midy = (image_col - 1) / 2 + 1; %ȡ��ͼ��Y����ֵ��
        images(n).features_points.location(1,:) = double(points.Location(:,2)) - image_midx; % ��¼�������X����
        images(n).features_points.location(2,:) = double(points.Location(:,1)) - image_midy; % ��¼�������Y����
        images(n).features_points.descript = features; % ��¼��������
    end
    
    % ����ͼ������֮���ƥ�����
    [match_count,match_index_pair,inlier_count,inlier_index_pair] = itool.ImageStitcher.neighbour(images);
    
    % ��ͼ��һ��һ���ؼ���bundle_adjuster,����bundle_group�е�ͼ����Ⱥ�����
    while length(bundle_group) < number_of_images
        match_col = inlier_count(bundle_group,:); 
        match_col = sum(match_col,1); match_col(bundle_group) = 0;
        [~,next_image_idx] = max(match_col); % �ҵ�׼������bundle_adjuster����һ��ͼ��
        bundle_group = [bundle_group next_image_idx]; % ��next_image_idx����bundle_group
        
        % ����Ѱ�ŵ���ʼ��
        near = inlier_count(next_image_idx,:); 
        near(setxor(1:number_of_images,bundle_group)) = 0;
        [~,near_image_idx] = max(near);
        
        obj.cameras(next_image_idx).P = obj.cameras(near_image_idx).P;
                
        x_start = []; % ׼����������ʼλ��
        for k = 1:length(bundle_group)
            x_start = cat(2,x_start,obj.cameras(bundle_group(k)).P);
        end
        
        options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt', ...
            'MaxFunEvals',1e6,'TolFun',1e-8,'TolX',1e-8,'MaxIter',1e4,'Display','iter');

        % ��bundle_group�е�ͼ����Ⱥ���������levenberg-marquardt�㷨�������Ż�
        x_solution = lsqnonlin(@error_func,x_start,[],[],options);
        
        % ���������任ΪP,R,K����
        for k = 1:length(bundle_group)
            ss = x_solution(:,k);
            obj.cameras(bundle_group(k)).P = ss;
            obj.cameras(bundle_group(k)).R = expm([0 -ss(3) ss(2); ss(3) 0 -ss(1); -ss(2) ss(1) 0]);
            obj.cameras(bundle_group(k)).K = diag([ss(4) ss(4) 1]);
        end
    end
    
    obj.sequence = bundle_group;
    
    function f = error_func(x) % �ڲ�Ƕ�׺���,��lsqnonlin������������Ž�
        f = [];
        num = length(bundle_group); % ��Ҫλ��Ѱ�ŵ�ͼ�����=bundle_groupԪ�ظ���
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
