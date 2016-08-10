function D = update_dataterm(obj,image,mask) % for image
%UPDATE_DATATERM 计算数据项
%   
    [ix(:,:,3), iy(:,:,3)] = gradient(double(image(:,:,3))); % 分别对RGB三个分量求梯度
    [ix(:,:,2), iy(:,:,2)] = gradient(double(image(:,:,2))); % 分别对RGB三个分量求梯度
    [ix(:,:,1), iy(:,:,1)] = gradient(double(image(:,:,1))); % 分别对RGB三个分量求梯度
    ix = sum(ix,3) ./ (1*255); iy = sum(iy,3) ./ (1*255);
    temp = ix; ix = -iy; iy = temp; % 梯度旋转90度即为等照度线方向
    
    [nx,ny] = gradient(double(mask)); % 对蒙板图像求梯度
    nx = nx ./ sqrt(nx.^2+ny.^2); nx(~isfinite(nx)) = 0;
    ny = ny ./ sqrt(nx.^2+ny.^2); ny(~isfinite(ny)) = 0;
    
    D = abs(ix.*nx + iy.*ny);
end

