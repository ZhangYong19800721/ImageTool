function output = reduce(input)
    [m,n] = size(input);
    a = 0.4; b = 0.25; c = 0.05;
    h  = [c b a b c];
    w = conv2(h,h'); % 二维平滑滤波器
    
    image(m+4,n+4) = 0; % 上下左右各扩展两行
    image(3:m+2,3:n+2) = input; % 将input拷贝到中央区域
    
    image(1,3:n+2) = 2*input(1,:)-input(3,:); % 设置边界上的值
    image(2,3:n+2) = 2*input(1,:)-input(2,:); % 设置边界上的值
    image(m+4,3:n+2) = 2*input(m,:)-input(m-2,:); % 设置边界上的值
    image(m+3,3:n+2) = 2*input(m,:)-input(m-1,:); % 设置边界上的值
    
    image(3:m+2,1) = 2*input(:,1)-input(:,3); % 设置边界上的值
    image(3:m+2,2) = 2*input(:,1)-input(:,2); % 设置边界上的值
    image(3:m+2,n+4) = 2*input(:,n)-input(:,n-2); % 设置边界上的值
    image(3:m+2,n+3) = 2*input(:,n)-input(:,n-1); % 设置边界上的值
    
    output = conv2(image,w,'same');
    output = output(3:2:end-2,3:2:end-2);
end