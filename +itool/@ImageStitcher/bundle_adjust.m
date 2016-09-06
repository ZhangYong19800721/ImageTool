function obj = bundle_adjust(obj,images,radius) % 
%BUNDLE_ADJUST 对输入的N个image，作群体微调
%   此处显示详细说明

    % 选定第1个图像为中央对齐图像
    cameras(1).focal = 2.5;
    cameras(1).theda = zeros(3,3);

    for n = 1:length(images) % 抽取Surf特征，记录特征点坐标和描述向量
        cameras(n).gray_image = rgb2gray(images(n).image);
        surf_points = detectSURFFeatures(cameras(n).gray_image);
        [features_descript, features_points] = extractFeatures(cameras(n).gray_image, surf_points);
        [image_row,image_col] = size(cameras(n).gray_image);
        image_midx = (image_row - 1) / 2 + 1; image_midy = (image_col - 1) / 2 + 1;
        cameras(n).features_points.Location(1,:) = double(features_points.Location(:,2)) - image_midx;
        cameras(n).features_points.Location(2,:) = double(features_points.Location(:,1)) - image_midy;
        cameras(n).features_points.Descript = features_descript;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    inlier_index_pairs = itool.ImageStitcher.find_inliers(cameras(1).features_points,cameras(2).features_points);
    
    cameras(2).focal = 2.5;
    X1 = cameras(1).features_points.Location(1,inlier_index_pairs(:,1));
    Y1 = cameras(1).features_points.Location(2,inlier_index_pairs(:,1));
    X2 = cameras(2).features_points.Location(1,inlier_index_pairs(:,2));
    Y2 = cameras(2).features_points.Location(2,inlier_index_pairs(:,2));
    Z1 = cameras(1).focal * radius * ones(1,length(X1)); C1 = cat(1,X1,Y1,Z1);
    Z2 = cameras(2).focal * radius * ones(1,length(X2)); C2 = cat(1,X2,Y2,Z2);
    H = itool.ImageStitcher.DLT(C1,C2);
    H = H ./ H(3,3); cameras(2).theda = logm(inv(H));
    
%     function f = fun(x) 
%         Ki = diag([x(4) x(4) 1]);
%         Ri = expm([0 -x(3) x(2); x(3) 0 -x(1); -x(2) x(1) 0]);
%         Rj = expm(cameras(1).theda)';
%         Kj = diag([1/cameras(1).focal 1/cameras(1).focal 1]);
%         Cm = Ki * Ri * Rj * Kj * C1; Cm = radius * Cm ./ repmat(Cm(3,:),3,1);
%         C2 = radius * C2 ./ repmat(C2(3,:),3,1);
%         D = C2 - Cm;
%         f = sqrt(D(1,:).^2 + D(2,:).^2);
%     end
% 
%     x0 = [0 0 0 2.5];
%     options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt', ...
%         'MaxFunEvals',10000,'TolFun',1e-10,'TolX',1e-10,'MaxIter',1000,'Display','iter');
%     xs = lsqnonlin(@fun,x0,[],[],options);
%     cameras(2).focal = xs(4); %xs(1) = -0.45;
%     cameras(2).theda = [0 -xs(3) xs(2); xs(3) 0 -xs(1); -xs(2) xs(1) 0];
%     
%     Ki = diag([cameras(2).focal cameras(2).focal 1]);
%     Ri = expm(cameras(2).theda);
%     Rj = expm(cameras(1).theda)';
%     Kj = diag([1/cameras(1).focal 1/cameras(1).focal 1]);
%     Cm = Ki * Ri * Rj * Kj * C1; Cm = radius * Cm ./ repmat(Cm(3,:),3,1);
%     D = C2 - Cm;
%     f = sqrt(D(1,:).^2 + D(2,:).^2);
%     sumf = sum(f.^2);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % 将计算结果记录到obj对象中  
    for n = 1:length(cameras)
        obj.cameras(n).K = diag([cameras(n).focal cameras(n).focal 1]);
        obj.cameras(n).R = expm(cameras(n).theda);
    end
end
