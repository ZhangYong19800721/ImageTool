function [inpaintedImg,origImg,fillImg,C,D,fillMovie] = inpaint7(imgFilename,fillFilename,fillColor)
%INPAINT  Exemplar-based inpainting.
%
% Usage:   [inpaintedImg,origImg,fillImg,C,D,fillMovie] ...
%                = inpaint(imgFilename,fillFilename,fillColor)
% Inputs:
%   imgFilename    Filename of the original image.
%   fillFilename   Filename of the image specifying the fill region.
%   fillColor      1x3 RGB vector specifying the color used to specify
%                  the fill region.
% Outputs:
%   inpaintedImg   The inpainted image; an MxNx3 matrix of doubles.
%   origImg        The original image; an MxNx3 matrix of doubles.
%   fillImg        The fill region image; an MxNx3 matrix of doubles.
%   C              MxN matrix of confidence values accumulated over all iterations.
%   D              MxN matrix of data term values accumulated over all iterations.
%   fillMovie      A Matlab movie struct depicting the fill region over time.
%
% Example:
%   [i1,i2,i3,c,d,mov] = inpaint7('bungee0.png','bungee1.png',[0 255 0]);
%   plotall;           % quick and dirty plotting script
%   close; movie(mov); % grab some popcorn

    tic;
    warning off MATLAB:divideByZero
    [img,fillImg,fillRegion] = loadimgs(imgFilename,fillFilename,fillColor);%img = imread(imgFilename); fillImg = imread(fillFilename);
    %fillRegion = fillImg(:,:,1)==fillColor(1) & ...
    %fillImg(:,:,2)==fillColor(2) & fillImg(:,:,3)==fillColor(3);
    img = double(img);%原图变成double型
    origImg = img;
    ind = img2ind(img);
    sz = [size(img,1) size(img,2)];
    sourceRegion = ~fillRegion;

    % Initialize isophote values,初始化等照度线方向
    %梯度表示数值在这一方向上的变化率
    %[FX,FY] = gradient(F)其中F是一个矩阵。
    %该调用返回二维数值梯度的x、y部分。FX对应?F/?x， FY对应于?F/?y。
    [Ix(:,:,3) Iy(:,:,3)] = gradient(img(:,:,3));%img(:;:;3)取出三位阵列img的第3页,RGB模型
    [Ix(:,:,2) Iy(:,:,2)] = gradient(img(:,:,2));
    [Ix(:,:,1) Iy(:,:,1)] = gradient(img(:,:,1));
    Ix = sum(Ix,3)/(3*255);%三页的梯度值相加除以3*255
    Ix(~isfinite(Ix))=0;%isFinite(number) 如果 number 是有限数字（或可转换为有限数字），那么返回 true。
    %否则，如果 number 是 NaN（非数字），或者是正、负无穷大的数，则返回 false。
    Iy = sum(Iy,3)/(3*255);
    Iy(~isfinite(Iy))=0;
    Ix = Ix./(255*sqrt(Ix.^2 + Iy.^2));
    Iy = Iy./(255*sqrt(Ix.^2 + Iy.^2));
    temp = Ix; Ix = -Iy; Iy = temp; % Rotate gradient 90 degrees梯度旋转90度即为等照度线方向

    % Initialize confidence and data terms
    C = double(sourceRegion);
    D = repmat(-.1,sz);%sz为大小的矩阵，每个值都是-0.1000
    iter = 1;%迭代次数
    %B = repmat(A,m,n)%将矩阵 A 复制 m×n 块，即把 A 作为 B 的元素，B 由 m×n 个 A 平铺而成。
    %B 的维数是 [size(A,1)*m, size(A,2)*n] 。
    % Visualization stuff

    if nargout==6 %在函数体内部， nargout指出了输出参数的个数
        fillMovie(1).cdata=uint8(img);
        fillMovie(1).colormap=[];
        origImg(1,1,:) = fillColor;
        iter = 2;
    end%?????找出填充目标区域

    % Seed 'rand' for reproducible results (good for testing)
    rand('state',0);
    %rand('state',0):产生器复位到初始状态。rand('state',s)：状态充值为s。rand('state',j)：产生器复位到第j个状态。%以后产生的随机数都与第一次运行产生的相同

    % Loop until entire fill region has been covered
    %循环直到整个填充区域被覆盖
    while any(fillRegion(:))
        % Find contour轮廓 & normalized gradients of fill region
        fillRegionD = double(fillRegion); % Marcel 11/30/05
        dR = find(conv2(fillRegionD,[1,1,1;1,-8,1;1,1,1],'same')>0); % find：查找非零元素的值和下标，生成一个矩阵
        %%进行卷积以找到边界，dR为一组列向量，表示边界坐标；
        %C =conv2(A,B)返回矩阵A和B的二维卷积C。若A为ma×na的矩阵，B为mb×nb的矩阵，则C的大小为(ma+mb+1)×(na+nb+1)。
        [Nx,Ny] = gradient(double(~fillRegion)); % Marcel 11/30/05   %[Nx,Ny] = gradient(~fillRegion);% Original
        N = [Nx(dR(:)) Ny(dR(:))];%找出边界点的梯度，在二值图像中梯 度等于法线方向
        N = normr(N);  %矩阵a的最大奇异值（A*·A的开根号值）
        N(~isfinite(N))=0; % handle NaN and Inf
    
        % Compute confidences along the fill front
        for k=dR' %dR为一组列向量，表示边界坐标
            Hp = getpatch(sz,k); %Hp为一9*9矩阵，矩阵值是待修复块坐标
            q = Hp(~(fillRegion(Hp)));%q为一个列向量矩阵,为该修复块已知像素点的坐标
            C(k) = sum(C(q))/numel(Hp);%计算置信度  %n = numel(A) returns the number of elements, n, in array A.即模板的面积
        end
    
        % Compute patch priorities = confidence term * data term
        D(dR) = abs(Ix(dR).*N(:,1)+Iy(dR).*N(:,2)) + 0.001;%数据项
        if C(k)>1.0
            priorities = C(dR)+3*D(dR);
        else
            priorities =0.0001;
        end
        %priorities = C(dR)+3*D(dR); % priorities = C(dR).* D(dR);%优先权  %%后者是优化后的公式
        
        % Find patch with maximum priority, Hp
        [unused,ndx] = max(priorities(:));%找到优先权最大的点及其位置；
        p = dR(ndx(1));%p为待修复块的中心坐标点
        [Hp,rows,cols] = getpatch(sz,p);
        toFill = fillRegion(Hp);
        
        % Find exemplar that minimizes error, Hq
        Hq = bestexemplar(img,img(rows,cols,:),toFill',sourceRegion);
    
        % Update fill region
        toFill = logical(toFill); %数值转换为逻辑值，非零显示1，零显示零 % Marcel 11/30/05
        fillRegion(Hp(toFill)) = false;
        
        % Propagate confidence & isophote values，更新置信度
        C(Hp(toFill))  = C(p);%被去掉那块的修复块的置信度被更新，C代表sourceRegion，待修复点为0，已存在点为1；用优先权最大的修复点的置信度来代替优先权最大的块的置信度
        Ix(Hp(toFill)) = Ix(Hq(toFill));%用最优匹配块的向量梯度来更新优先权最大的块的梯度
        Iy(Hp(toFill)) = Iy(Hq(toFill));
    
        % Copy image data from Hq to Hp
        ind(Hp(toFill)) = ind(Hq(toFill));%最优匹配块的坐标来作为待修复块的坐标
        img(rows,cols,:) = ind2img(ind(rows,cols),origImg);%ind(rows,cols)表示待修复块的坐标范围，该范围已被最优匹配块的值所替代
        
        % Visualization stuff
        if nargout==6
            ind2 = ind;
            ind2(logical(fillRegion)) = 1;          % Marcel 11/30/05
            %ind2(fillRegion) = 1;                  % Original
            fillMovie(iter).cdata=uint8(ind2img(ind2,origImg));
            fillMovie(iter).colormap=[];
        end
        iter = iter+1;
    end
    
    inpaintedImg=img;
    toc;
end

%---------------------------------------------------------------------
% Scans over the entire image (with a sliding window)
% for the exemplar with the lowest error. Calls a MEX function.
%---------------------------------------------------------------------
function Hq = bestexemplar(img,Ip,toFill,sourceRegion)
    m=size(Ip,1); mm=size(img,1); n=size(Ip,2); nn=size(img,2);
    best = bestexemplarhelper(mm,nn,m,n,img,Ip,toFill,sourceRegion);
    Hq = sub2ndx(best(1):best(2),(best(3):best(4))',mm);
end

%---------------------------------------------------------------------
% Returns the indices for a 9x9 patch centered at pixel p.
%---------------------------------------------------------------------
function [Hp,rows,cols] = getpatch(sz,p)
    % [x,y] = ind2sub(sz,p);  % 2*w+1 == the patch size
    w=4;
    p=p-1;%p为序列号
    y=floor(p/sz(1))+1; %y表示p的列坐标,floor是向下取整函数
    p=rem(p,sz(1)); %rem是求余函数
    x=floor(p)+1;
    rows = max(x-w,1):min(x+w,sz(1));%即rows为x-4到x+4,共9个点
    cols = (max(y-w,1):min(y+w,sz(2)))';%即cols为y-4到y+4,共9个点
    Hp = sub2ndx(rows,cols,sz(1));
end

%---------------------------------------------------------------------
% Converts the (rows,cols) subscript-style indices to Matlab index-style
% indices.  Unforunately, 'sub2ind' cannot be used for this.
%---------------------------------------------------------------------
function N = sub2ndx(rows,cols,nTotalRows) %Hp = sub2ndx(rows,cols,sz(1))
    X = rows(ones(length(cols),1),:);%生成9行rows
    Y = cols(:,ones(1,length(rows)));%生成9列cols
    N = X+(Y-1)*nTotalRows;%计算N的坐标
end

%---------------------------------------------------------------------
% Converts an indexed image into an RGB image, using 'img' as a colormap
%---------------------------------------------------------------------
function img2 = ind2img(ind,img)
    for i=3:-1:1
        temp=img(:,:,i);
        img2(:,:,i)=temp(ind);
    end;
end

%---------------------------------------------------------------------
% Converts an RGB image into a indexed image, using the image itself as
% the colormap.
%---------------------------------------------------------------------
function ind = img2ind(img)
    s=size(img);
    ind=reshape(1:s(1)*s(2),s(1),s(2));%找出各点在从列中得到的坐标
end

%---------------------------------------------------------------------
% Loads the an image and it's fill region, using 'fillColor' as a marker
% value for knowing which pixels are to be filled.
%---------------------------------------------------------------------
function [img,fillImg,fillRegion] = loadimgs(imgFilename,fillFilename,fillColor)
    img = imread(imgFilename);
    fillImg = imread(fillFilename);
    fillRegion = fillImg(:,:,1)==fillColor(1) & ...
        fillImg(:,:,2)==fillColor(2) & fillImg(:,:,3)==fillColor(3);
% fillRegion = fillImg(:,:,1)==fillColor(1) & ...
%     fillImg(:,:,2)==fillColor(2) & fillImg(:,:,3)==fillColor(3);
end

function [A] = normr(N)
    for ii=1:size(N,1)
        A(ii,:) = N(ii,:)/norm(N(ii,:));
    end
end