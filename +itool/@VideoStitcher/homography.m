function [canvas,mask] = homography(obj,H,canvas_size,image)
%HOMOGRAPHY 将图像image经过透视变换后投影到画布上
%   H：投影变换矩阵
%   canvas_size：画布的大小,canvas_size(1)表示画布的行数,canvas_size(2)表示画布的列数
%   image：做投影变换的图像
    canvas_row = canvas_size(1); canvas_col = canvas_size(2);
    canvas_Y = zeros(canvas_row,canvas_col); % 初始化画布Y分量
    canvas_U = zeros(canvas_row,canvas_col); % 初始化画布U分量
    canvas_V = zeros(canvas_row,canvas_col); % 初始化画布V分量
    
    [image_row, image_col, ~] = size(image); % 获取图像的大小

    [CY,CX] = meshgrid(1:canvas_col,1:canvas_row);
    CX1D = reshape(CX,1,[]); CY1D = reshape(CY,1,[]);
    CC1D = cat(1,CX1D,CY1D,ones(1,length(CX)));
    IC1D = H\CC1D; IC1D = IC1D ./ repmat(IC1D(3,:),3,1);
    IX = reshape(IC1D(1,:),canvas_row,canvas_col);
    IY = reshape(IC1D(2,:),canvas_row,canvas_col);
    
    mask = (IX >= 1) & (IX <= image_row) & (IY >= 1) & (IY <= image_col);
    CQ1D = cat(1,CX(mask)',CY(mask)',ones(1,sum(sum(mask))));  % canvas坐标系下的查询点坐标
    IQ1D = H\CQ1D; IQ1D = IQ1D ./ repmat(IQ1D(3,:),3,1); % image坐标系下的查询点坐标
    
    IQX = IQ1D(1,:);
    IQY = IQ1D(2,:);
    
    [IGY,IGX] = meshgrid(1:image_col,1:image_row);
    IQ_Y = interp2(IGX,IGY,image(:,:,1),IQX,IQY);
    IQ_U = interp2(IGX,IGY,image(:,:,2),IQX,IQY);
    IQ_V = interp2(IGX,IGY,image(:,:,3),IQX,IQY);
    
    canvas_Y(mask) = IQ_Y;
    canvas_U(mask) = IQ_U;
    canvas_V(mask) = IQ_V;
    
    canvas = uint8(cat(3,canvas_Y,canvas_U,canvas_V));
end

