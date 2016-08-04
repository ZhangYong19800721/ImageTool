function d_term = update_dataterm(obj,data)
%UPDATE_DATATERM ����ȷ����߷���ͱ߽編����ڻ�
%
    d_term = data;
    
    for frame = 1:obj.frame_num
        [ix1,iy1] = gradient(double(obj.movie_area(:,:,1,frame))); %����Y����x����y������ݶ�
        [ix2,iy2] = gradient(double(obj.movie_area(:,:,2,frame))); %����U����x����y������ݶ�
        [ix3,iy3] = gradient(double(obj.movie_area(:,:,3,frame))); %����V����x����y������ݶ�
        
        ix = (ix1+ix2+ix3)/255; % ��YUV����������x������ݶȺϲ�
        iy = (iy1+iy2+iy3)/255; % ��YUV����������y������ݶȺϲ�
        
        % ix = ix ./ sqrt(ix.^2+iy.^2); % ��һ��Ϊ��λ����
        % iy = iy ./ sqrt(ix.^2+iy.^2); % ��һ��Ϊ��λ����
        
        temp = ix; ix = -iy; iy = temp;  % �ݶ���ת90�ȼ�Ϊ���ն��߷���
        
        [ngx,ngy] = gradient(double(obj.mask_area(:,:,frame)));
        ngx = ngx ./ sqrt(ngx.^2 + ngy.^2); %�õ��߽編��
        ngy = ngy ./ sqrt(ngx.^2 + ngy.^2); %�õ��߽編��
        ngx(~isfinite(ngx)) = 0; ngy(~isfinite(ngy)) = 0;
        d_term(:,:,frame) = abs(ix.*ngx+iy.*ngy);
    end
end

