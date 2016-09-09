function obj = gain_compensation(obj,images) % 亮度增益补偿算法
%GAIN_COMPENSATION 亮度增益补偿算法
%   此处显示详细说明
    number_of_images = length(images);
    N = zeros(number_of_images); % 第(i,j)个元素表示第i个图像和第j个图像之间的重叠像素个数（重叠区域的面积）
    for n = 1:number_of_images
        for m = (n+1):number_of_images
            N(n,m) = sum(obj.cameras(n).mask & obj.cameras(m).mask);
        end
    end
    N = triu(N) + triu(N)';
    
    I = zeros(number_of_images); % 第(i,j)个元素表示第i个图像中与第j个图像重叠区域的平均亮度
    
    function f_error = error_func(gain)
        
    end
end

