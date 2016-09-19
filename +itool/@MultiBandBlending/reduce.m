function output = reduce(input)
    [m,n] = size(input);
    a = 0.4; b = 0.25; c = 0.05;
    h  = [c b a b c];
    w = conv2(h,h'); % ��άƽ���˲���
    
    image(m+4,n+4) = 0; % �������Ҹ���չ����
    image(3:m+2,3:n+2) = input; % ��input��������������
    
    image(1,3:n+2) = 2*input(1,:)-input(3,:); % ���ñ߽��ϵ�ֵ
    image(2,3:n+2) = 2*input(1,:)-input(2,:); % ���ñ߽��ϵ�ֵ
    image(m+4,3:n+2) = 2*input(m,:)-input(m-2,:); % ���ñ߽��ϵ�ֵ
    image(m+3,3:n+2) = 2*input(m,:)-input(m-1,:); % ���ñ߽��ϵ�ֵ
    
    image(3:m+2,1) = 2*input(:,1)-input(:,3); % ���ñ߽��ϵ�ֵ
    image(3:m+2,2) = 2*input(:,1)-input(:,2); % ���ñ߽��ϵ�ֵ
    image(3:m+2,n+4) = 2*input(:,n)-input(:,n-2); % ���ñ߽��ϵ�ֵ
    image(3:m+2,n+3) = 2*input(:,n)-input(:,n-1); % ���ñ߽��ϵ�ֵ
    
    output = conv2(image,w,'same');
    output = output(3:2:end-2,3:2:end-2);
end