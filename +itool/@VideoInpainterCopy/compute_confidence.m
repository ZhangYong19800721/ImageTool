function C = compute_confidence(obj,confidence)
%COMPUTE_CONFIDENCE 计算填充边界上的自信度
%   
    div = (2*obj.delta_x+1)*(2*obj.delta_y+1)*(2*obj.delta_t+1);
    C = confidence;
    for n = 1:length(obj.front_idx) % 计算边界上的自信度
        x = obj.front_x(n); % 取得边界点坐标x
        y = obj.front_y(n); % 取得边界点坐标y
        t = obj.front_t(n); % 取得边界点坐标t
        cube = obj.get_cube(confidence,x,y,t);
        C(x,y,t) = sum(sum(sum(cube))) / div;
    end
end

