classdef ImageStitcher
    %ImageStitcher 将多幅图像拼接为全景图像
    %   将多幅图像拼接为一个全景图像
    
    properties
        cameras % struct结构体数组，用来记录相机的参数
        canvas_row_num; % 画布的行数 
        canvas_col_num; % 画布的列数 
    end
    
    methods
        canvas = stitch(obj, images) % 输入N个image，输出拼接结果
        obj = estimate(obj, images) % 输入N个image，估计拼接参数
    end
    
    methods(Static)
        H = estimate_homography(image1, image2) % 使用SURF特征估计两幅图之间的透视变换矩阵
        H = DLT(match_points1, match_points2) % 使用DLT算法估计两组匹配点之间的透视变换矩阵
        pos_c = cylindrical(pos_e,s) % 将直角坐标系坐标转换为圆柱坐标系坐标
        XYZ_euclid = inv_cylindrical(XYZ_cylind) % 将圆柱坐标系坐标转换为直角坐标系坐标 
        pos_s = spherical(pos_e,s) % 将直角坐标系坐标转换为球面坐标系坐标
        pos_e = inv_spherical(pos_s) % 将球面坐标系坐标转换为直角坐标系坐标 
        [canvas,mask] = homography(r,R,image) % 将图像使用H矩阵投影变换
    end
    
end

