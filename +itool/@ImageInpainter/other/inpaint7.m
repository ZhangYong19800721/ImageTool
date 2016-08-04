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
    img = double(img);%ԭͼ���double��
    origImg = img;
    ind = img2ind(img);
    sz = [size(img,1) size(img,2)];
    sourceRegion = ~fillRegion;

    % Initialize isophote values,��ʼ�����ն��߷���
    %�ݶȱ�ʾ��ֵ����һ�����ϵı仯��
    %[FX,FY] = gradient(F)����F��һ������
    %�õ��÷��ض�ά��ֵ�ݶȵ�x��y���֡�FX��Ӧ?F/?x�� FY��Ӧ��?F/?y��
    [Ix(:,:,3) Iy(:,:,3)] = gradient(img(:,:,3));%img(:;:;3)ȡ����λ����img�ĵ�3ҳ,RGBģ��
    [Ix(:,:,2) Iy(:,:,2)] = gradient(img(:,:,2));
    [Ix(:,:,1) Iy(:,:,1)] = gradient(img(:,:,1));
    Ix = sum(Ix,3)/(3*255);%��ҳ���ݶ�ֵ��ӳ���3*255
    Ix(~isfinite(Ix))=0;%isFinite(number) ��� number ���������֣����ת��Ϊ�������֣�����ô���� true��
    %������� number �� NaN�������֣��������������������������򷵻� false��
    Iy = sum(Iy,3)/(3*255);
    Iy(~isfinite(Iy))=0;
    Ix = Ix./(255*sqrt(Ix.^2 + Iy.^2));
    Iy = Iy./(255*sqrt(Ix.^2 + Iy.^2));
    temp = Ix; Ix = -Iy; Iy = temp; % Rotate gradient 90 degrees�ݶ���ת90�ȼ�Ϊ���ն��߷���

    % Initialize confidence and data terms
    C = double(sourceRegion);
    D = repmat(-.1,sz);%szΪ��С�ľ���ÿ��ֵ����-0.1000
    iter = 1;%��������
    %B = repmat(A,m,n)%������ A ���� m��n �飬���� A ��Ϊ B ��Ԫ�أ�B �� m��n �� A ƽ�̶��ɡ�
    %B ��ά���� [size(A,1)*m, size(A,2)*n] ��
    % Visualization stuff

    if nargout==6 %�ں������ڲ��� nargoutָ������������ĸ���
        fillMovie(1).cdata=uint8(img);
        fillMovie(1).colormap=[];
        origImg(1,1,:) = fillColor;
        iter = 2;
    end%?????�ҳ����Ŀ������

    % Seed 'rand' for reproducible results (good for testing)
    rand('state',0);
    %rand('state',0):��������λ����ʼ״̬��rand('state',s)��״̬��ֵΪs��rand('state',j)����������λ����j��״̬��%�Ժ����������������һ�����в�������ͬ

    % Loop until entire fill region has been covered
    %ѭ��ֱ������������򱻸���
    while any(fillRegion(:))
        % Find contour���� & normalized gradients of fill region
        fillRegionD = double(fillRegion); % Marcel 11/30/05
        dR = find(conv2(fillRegionD,[1,1,1;1,-8,1;1,1,1],'same')>0); % find�����ҷ���Ԫ�ص�ֵ���±꣬����һ������
        %%���о�����ҵ��߽磬dRΪһ������������ʾ�߽����ꣻ
        %C =conv2(A,B)���ؾ���A��B�Ķ�ά���C����AΪma��na�ľ���BΪmb��nb�ľ�����C�Ĵ�СΪ(ma+mb+1)��(na+nb+1)��
        [Nx,Ny] = gradient(double(~fillRegion)); % Marcel 11/30/05   %[Nx,Ny] = gradient(~fillRegion);% Original
        N = [Nx(dR(:)) Ny(dR(:))];%�ҳ��߽����ݶȣ��ڶ�ֵͼ������ �ȵ��ڷ��߷���
        N = normr(N);  %����a���������ֵ��A*��A�Ŀ�����ֵ��
        N(~isfinite(N))=0; % handle NaN and Inf
    
        % Compute confidences along the fill front
        for k=dR' %dRΪһ������������ʾ�߽�����
            Hp = getpatch(sz,k); %HpΪһ9*9���󣬾���ֵ�Ǵ��޸�������
            q = Hp(~(fillRegion(Hp)));%qΪһ������������,Ϊ���޸�����֪���ص������
            C(k) = sum(C(q))/numel(Hp);%�������Ŷ�  %n = numel(A) returns the number of elements, n, in array A.��ģ������
        end
    
        % Compute patch priorities = confidence term * data term
        D(dR) = abs(Ix(dR).*N(:,1)+Iy(dR).*N(:,2)) + 0.001;%������
        if C(k)>1.0
            priorities = C(dR)+3*D(dR);
        else
            priorities =0.0001;
        end
        %priorities = C(dR)+3*D(dR); % priorities = C(dR).* D(dR);%����Ȩ  %%�������Ż���Ĺ�ʽ
        
        % Find patch with maximum priority, Hp
        [unused,ndx] = max(priorities(:));%�ҵ�����Ȩ���ĵ㼰��λ�ã�
        p = dR(ndx(1));%pΪ���޸�������������
        [Hp,rows,cols] = getpatch(sz,p);
        toFill = fillRegion(Hp);
        
        % Find exemplar that minimizes error, Hq
        Hq = bestexemplar(img,img(rows,cols,:),toFill',sourceRegion);
    
        % Update fill region
        toFill = logical(toFill); %��ֵת��Ϊ�߼�ֵ��������ʾ1������ʾ�� % Marcel 11/30/05
        fillRegion(Hp(toFill)) = false;
        
        % Propagate confidence & isophote values���������Ŷ�
        C(Hp(toFill))  = C(p);%��ȥ���ǿ���޸�������Ŷȱ����£�C����sourceRegion�����޸���Ϊ0���Ѵ��ڵ�Ϊ1��������Ȩ�����޸�������Ŷ�����������Ȩ���Ŀ�����Ŷ�
        Ix(Hp(toFill)) = Ix(Hq(toFill));%������ƥ���������ݶ�����������Ȩ���Ŀ���ݶ�
        Iy(Hp(toFill)) = Iy(Hq(toFill));
    
        % Copy image data from Hq to Hp
        ind(Hp(toFill)) = ind(Hq(toFill));%����ƥ������������Ϊ���޸��������
        img(rows,cols,:) = ind2img(ind(rows,cols),origImg);%ind(rows,cols)��ʾ���޸�������귶Χ���÷�Χ�ѱ�����ƥ����ֵ�����
        
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
    p=p-1;%pΪ���к�
    y=floor(p/sz(1))+1; %y��ʾp��������,floor������ȡ������
    p=rem(p,sz(1)); %rem�����ຯ��
    x=floor(p)+1;
    rows = max(x-w,1):min(x+w,sz(1));%��rowsΪx-4��x+4,��9����
    cols = (max(y-w,1):min(y+w,sz(2)))';%��colsΪy-4��y+4,��9����
    Hp = sub2ndx(rows,cols,sz(1));
end

%---------------------------------------------------------------------
% Converts the (rows,cols) subscript-style indices to Matlab index-style
% indices.  Unforunately, 'sub2ind' cannot be used for this.
%---------------------------------------------------------------------
function N = sub2ndx(rows,cols,nTotalRows) %Hp = sub2ndx(rows,cols,sz(1))
    X = rows(ones(length(cols),1),:);%����9��rows
    Y = cols(:,ones(1,length(rows)));%����9��cols
    N = X+(Y-1)*nTotalRows;%����N������
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
    ind=reshape(1:s(1)*s(2),s(1),s(2));%�ҳ������ڴ����еõ�������
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