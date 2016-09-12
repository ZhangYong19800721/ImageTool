function obj = gain_compensation(obj,images) % �������油���㷨
%GAIN_COMPENSATION �������油���㷨
%   �˴���ʾ��ϸ˵��
    number_of_images = length(images);
    N_value = zeros(number_of_images); % ��(i,j)��Ԫ�ر�ʾ��i��ͼ��͵�j��ͼ��֮����ص����ظ������ص�����������
    for n = 1:number_of_images
        for m = n:number_of_images
            N_value(n,m) = sum(obj.cameras(n).mask & obj.cameras(m).mask);
        end
    end
    N_value = triu(N_value) + triu(N_value)';
    
    I_value = zeros(number_of_images); % ��(i,j)��Ԫ�ر�ʾ��i��ͼ�������j��ͼ���ص������ƽ������
    for n = 1:number_of_images
        for m = 1:number_of_images
            if m~=n
                overlap_mask = obj.cameras(n).mask & obj.cameras(m).mask; % �ص�������ɰ�
                mask_in_mask = overlap_mask(obj.cameras(n).mask);
                query_x = obj.cameras(n).query_x(mask_in_mask);
                query_y = obj.cameras(n).query_y(mask_in_mask);
    
                gray_image = rgb2gray(images(n).image);
                [image_row_num, image_col_num] = size(gray_image);
                [IX, IY] = meshgrid(1:image_row_num,1:image_col_num);
                Y = interp2(IX,IY,double(gray_image)',query_x,query_y);
                I_value(n,m) = sum(reshape(Y,[],1));
            end
        end
    end
    I_value = I_value ./ N_value;
    I_value(N_value == 0) = 0;
    
    delta_N = 10; delta_g = 0.1;
        
    x_start = ones(1,number_of_images);
    % ��levenberg-marquardt�㷨�������Ż�
    options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt', ...
            'MaxFunEvals',1e6,'TolFun',1e-8,'TolX',1e-8,'MaxIter',1e4,'Display','iter');
    x_solution = lsqnonlin(@error_func,x_start,[],[],options);
        
    % ���������任Ϊgain����
    for k = 1:number_of_images
        obj.cameras(k).gain = x_solution(k);
    end
    
    function f_error = error_func(gain)
        g_i = repmat(reshape(gain,[],1),1,length(gain));
        g_j = repmat(reshape(gain,1,[]),length(gain),1);
        f_error = N_value .* (((g_i .* I_value - g_j .* I_value').^2) ./ (delta_N.^2) + ((1-g_i).^2) ./ (delta_g.^2));
        f_error = reshape(sqrt(f_error),[],1);
    end
end

