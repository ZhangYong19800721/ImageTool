function D = update_dataterm(obj,image,mask) % for image
%UPDATE_DATATERM ����������
%   
    [ix(:,:,3), iy(:,:,3)] = gradient(double(image(:,:,3))); % �ֱ��RGB�����������ݶ�
    [ix(:,:,2), iy(:,:,2)] = gradient(double(image(:,:,2))); % �ֱ��RGB�����������ݶ�
    [ix(:,:,1), iy(:,:,1)] = gradient(double(image(:,:,1))); % �ֱ��RGB�����������ݶ�
    ix = sum(ix,3) ./ (1*255); iy = sum(iy,3) ./ (1*255);
    temp = ix; ix = -iy; iy = temp; % �ݶ���ת90�ȼ�Ϊ���ն��߷���
    
    [nx,ny] = gradient(double(mask)); % ���ɰ�ͼ�����ݶ�
    nx = nx ./ sqrt(nx.^2+ny.^2); nx(~isfinite(nx)) = 0;
    ny = ny ./ sqrt(nx.^2+ny.^2); ny(~isfinite(ny)) = 0;
    
    D = abs(ix.*nx + iy.*ny);
end

