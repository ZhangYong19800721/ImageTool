function obj = estimate(obj, images, row_num, col_num, alfa, warper)
%estimate 估计拼接参数
%   images：需要被拼接的图片数组
    obj = obj.create_canvas(row_num, col_num, alfa, warper); % 创建画布
    obj = obj.bundle_adjust(images); % 对相机参数K,R进行估计
    obj = obj.wave_correct(); % 波浪形修正
    obj = obj.interp_pos(images); % 根据相机参数K,R，计算每个图片对应的蒙板和插值查询点坐标
    obj = obj.gain_compensation(images); % 计算增益补偿权值
    obj = obj.blend_estimate(); % 估计图像融合需要的参数
end

