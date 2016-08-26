function [canvas,mask] = homography(f,R,image)
%HOMOGRAPHY 将图像image经过透视变换后投影到画布上
%   H：投影变换矩阵
%   image：做投影变换的图像
    focal = 500;
    H = diag([f f 1]) * R;
    [image_row, image_col, ~] = size(image); % 获取图像的大小
    midx = (image_row-1)/2+1; midy = (image_col-1)/2+1;
    [IY,IX] = meshgrid(1:image_col,1:image_row); % image图像的网格坐标点
    IX = reshape(IX,1,[]); IX = IX - midx; % 将图像的中心点移动至坐标原点
    IY = reshape(IY,1,[]); IY = IY - midy; % 将图像的中心点移动至坐标原点
    IP = cat(1,IX,IY,focal*ones(1,length(IX))); % 得到image图像的坐标点
    CP = H * IP; % 变换得到image图像网格坐标点对应的画布坐标点
    CP = focal * (CP ./ repmat(CP(3,:),3,1)); % 得到变换后的画布坐标点
    
    cminx = ceil(min(CP(1,:))); cmaxx = floor(max(CP(1,:))); % 找到画布坐标点的最大值和最小值
    cminy = ceil(min(CP(2,:))); cmaxy = floor(max(CP(2,:))); % 找到画布坐标点的最大值和最小值

    canvas_row = cmaxx - cminx + 1; canvas_col = cmaxy - cminy + 1; % 得到画布的行数和列数
    canvas_Y = zeros(canvas_row,canvas_col); % 初始化画布Y分量
    canvas_U = zeros(canvas_row,canvas_col); % 初始化画布U分量
    canvas_V = zeros(canvas_row,canvas_col); % 初始化画布V分量
    
    [CY,CX] = meshgrid(1:canvas_col,1:canvas_row); % 产生画布的网格坐标点
    CX = reshape(CX,1,[]) + cminx; CY = reshape(CY,1,[]) + cminy; % 移动画布的网格坐标点
    CC = cat(1,CX,CY,focal * ones(1,length(CX))); % 组成画布网格坐标点
    IC = H\CC; IC = focal * (IC ./ repmat(IC(3,:),3,1)); % 变换至图像坐标系

    IIX = IC(1,:); 
    IIY = IC(2,:);
    
    mask = (IIX >= (1-midx)) & (IIX <= (image_row-midx)) & (IIY >= (1-midy)) & (IIY <= (image_col-midy)); % 获得蒙板
    CQ = cat(1,CX(mask),CY(mask),focal * ones(1,sum(sum(mask))));  % canvas坐标系下的查询点坐标
    IQ = H\CQ; IQ = focal * (IQ ./ repmat(IQ(3,:),3,1)); % image坐标系下的查询点坐标
    
    IQX = IQ(1,:); IQY = IQ(2,:);
    
    [IGX,IGY] = meshgrid(1:image_row,1:image_col);
    IGX = IGX - midx; IGY = IGY - midy;
    IQ_Y = interp2(IGX,IGY,double(image(:,:,1))',IQX,IQY);
    IQ_U = interp2(IGX,IGY,double(image(:,:,2))',IQX,IQY);
    IQ_V = interp2(IGX,IGY,double(image(:,:,3))',IQX,IQY);
    
    canvas_Y(mask) = IQ_Y;
    canvas_U(mask) = IQ_U;
    canvas_V(mask) = IQ_V;
    
    canvas = uint8(cat(3,canvas_Y,canvas_U,canvas_V));
end

