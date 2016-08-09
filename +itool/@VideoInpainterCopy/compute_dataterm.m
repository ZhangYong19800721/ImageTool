function D = compute_dataterm(obj)
%COMPUTE_DATATERM ����������
%   
    D = zeros(size(obj.mask3d));
    for frame = 1:obj.frame_num
        ix1 = obj.movie_Y_Gx(:,:,frame); %ȡY����x������ݶ�
        iy1 = obj.movie_Y_Gy(:,:,frame); %ȡY����y������ݶ�
        
        ix2 = obj.movie_U_Gx(:,:,frame); %ȡU����x������ݶ�
        iy2 = obj.movie_U_Gy(:,:,frame); %ȡU����y������ݶ�
        
        ix3 = obj.movie_V_Gx(:,:,frame); %ȡV����x������ݶ�
        iy3 = obj.movie_V_Gy(:,:,frame); %ȡV����y������ݶ�
                
        ix = (ix1+ix2+ix3)/255; % ��YUV����������x������ݶȺϲ�
        iy = (iy1+iy2+iy3)/255; % ��YUV����������y������ݶȺϲ�
        
        temp = ix; ix = -iy; iy = temp;  % �ݶ���ת90�ȼ�Ϊ���ն��߷���
        
        [nx,ny] = gradient(double(obj.mask3d(:,:,frame)));  % ���ɰ�ͼ�����ݶ�
        nx = nx ./ sqrt(nx.^2 + ny.^2); nx(~isfinite(nx)) = 0; %�õ��߽編��
        ny = ny ./ sqrt(nx.^2 + ny.^2); ny(~isfinite(ny)) = 0; %�õ��߽編��
         
        D(:,:,frame) = abs(ix.*nx+iy.*ny);
    end
end

