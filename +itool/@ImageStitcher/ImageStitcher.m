classdef ImageStitcher
    %ImageStitcher 将多幅图像拼接为全景图像
    %   将多幅图像拼接为一个全景图像
    
    properties
        cameras % struct结构体数组，用来记录相机的参数
        % H; % 3x3xN透视变换矩阵，第i页表示第i路视频到画布的透视变换矩阵
        % mask; % 画布的行数x画布的列数xN的逻辑矩阵，第i页代表第i路视频的蒙板
        % interp_pos; % 用于插值的查询点位置坐标
        canvas_row_num; % 画布的行数 
        canvas_col_num; % 画布的列数 
    end
    
    methods
        canvas = stitch(obj, images) % 输入N个image,输出拼接结果
        obj = estimate(obj, images) % 输入N个image，估计拼接参数
        % [canvas,mask] = homography(obj,H,canvas_size,image) % 将图像投影到画布上，并给出其在画布上的蒙板
    end
    
    methods(Static)
        H = estimate_homography(image1, image2) % 使用SURF特征估计两幅图之间的透视变换矩阵
        H = DLT(match_points1, match_points2) % 使用DLT算法估计两组匹配点之间的透视变换矩阵
    end
    
end

