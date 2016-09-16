classdef ImageStitcher
    %ImageStitcher 将多幅图像拼接为全景图像
    %   将多幅图像拼接为一个全景图像
    
    properties
        cameras % struct结构体数组，用来记录相机的参数
        canvas_row_num; % 画布的行数 
        canvas_col_num; % 画布的列数 
    end
    
    methods
        % canvas = stitch_test(obj, images, sequence)
        canvas = stitch(obj, images, isline) % 输入N个image，输出拼接结果
        obj = estimate(obj, images, row_num, col_num) % 输入N个image，估计拼接参数
        obj = bundle_adjust(obj,images,radius) % 对输入的N个image，作群体微调
        obj = gain_compensation(obj,images) % 亮度增益补偿算法
        obj = wave_correct(obj) % 波浪修正算法
    end
    
    methods(Static)
        % H = estimate_homography(image1, image2) % 使用SURF特征估计两幅图之间的透视变换矩阵
        % H = estimate_homography2(image1, f1, image2, f2) % 使用SURF特征估计两幅图之间的透视变换矩阵
        % pos_c = cylindrical(pos_e,s) % 将直角坐标系坐标转换为圆柱坐标系坐标
        % pos_s = spherical(pos_e,s) % 将直角坐标系坐标转换为球面坐标系坐标
        % [canvas,mask] = homography(r,R,image) % 将图像使用H矩阵投影变换
        
        [match_index_pairs,inlier_index_pairs] = find_match(features_point1, features_point2) % 寻找两组特征之间的匹配点
        H = DLT(match_points1, match_points2) % 使用DLT算法估计两组匹配点之间的透视变换矩阵
        XYZ_euclid = inv_cylindrical(XYZ_cylind) % 将圆柱坐标系坐标转换为直角坐标系坐标 
        pos_e = inv_spherical(pos_s) % 将球面坐标系坐标转换为直角坐标系坐标
        [match_count,match_index_pair,inlier_count,inlier_index_pair] = neighbour(images) % 计算图像两两之间的匹配点数
        exit = unit_test1();
    end
    
end

