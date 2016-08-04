function d_term = update_dataterm(obj,data)
%UPDATE_DATATERM 计算等辐照线方向和边界法向的内积
%
    d_term = data;
    
    for frame = 1:obj.frame_num
        [ix1,iy1] = gradient(double(obj.movie_area(:,:,1,frame))); %计算Y分量x方向y方向的梯度
        [ix2,iy2] = gradient(double(obj.movie_area(:,:,2,frame))); %计算U分量x方向y方向的梯度
        [ix3,iy3] = gradient(double(obj.movie_area(:,:,3,frame))); %计算V分量x方向y方向的梯度
        
        ix = (ix1+ix2+ix3)/255; % 将YUV三个分量在x方向的梯度合并
        iy = (iy1+iy2+iy3)/255; % 将YUV三个分量在y方向的梯度合并
        
        % ix = ix ./ sqrt(ix.^2+iy.^2); % 归一化为单位向量
        % iy = iy ./ sqrt(ix.^2+iy.^2); % 归一化为单位向量
        
        temp = ix; ix = -iy; iy = temp;  % 梯度旋转90度即为等照度线方向
        
        [ngx,ngy] = gradient(double(obj.mask_area(:,:,frame)));
        ngx = ngx ./ sqrt(ngx.^2 + ngy.^2); %得到边界法向
        ngy = ngy ./ sqrt(ngx.^2 + ngy.^2); %得到边界法向
        ngx(~isfinite(ngx)) = 0; ngy(~isfinite(ngy)) = 0;
        d_term(:,:,frame) = abs(ix.*ngx+iy.*ngy);
    end
end

