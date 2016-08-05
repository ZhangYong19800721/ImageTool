function C = compute_confidence(obj,confidence)
%COMPUTE_CONFIDENCE �������߽��ϵ����Ŷ�
%   
    div = (2*obj.delta_x+1)*(2*obj.delta_y+1)*(2*obj.delta_t+1);
    C = confidence;
    for n = 1:length(obj.front_idx) % ����߽��ϵ����Ŷ�
        x = obj.front_x(n); % ȡ�ñ߽������x
        y = obj.front_y(n); % ȡ�ñ߽������y
        t = obj.front_t(n); % ȡ�ñ߽������t
        cube = obj.get_cube(confidence,x,y,t);
        C(x,y,t) = sum(sum(sum(cube))) / div;
    end
end

