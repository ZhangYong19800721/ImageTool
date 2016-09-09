function obj = gain_compensation(obj,images) % �������油���㷨
%GAIN_COMPENSATION �������油���㷨
%   �˴���ʾ��ϸ˵��
    number_of_images = length(images);
    N = zeros(number_of_images); % ��(i,j)��Ԫ�ر�ʾ��i��ͼ��͵�j��ͼ��֮����ص����ظ������ص�����������
    for n = 1:number_of_images
        for m = (n+1):number_of_images
            N(n,m) = sum(obj.cameras(n).mask & obj.cameras(m).mask);
        end
    end
    N = triu(N) + triu(N)';
    
    I = zeros(number_of_images); % ��(i,j)��Ԫ�ر�ʾ��i��ͼ�������j��ͼ���ص������ƽ������
    
    function f_error = error_func(gain)
        
    end
end

