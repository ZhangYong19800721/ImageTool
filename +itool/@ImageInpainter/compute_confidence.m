function C = compute_confidence(obj,confidence)
%COMPUTE_CONFIDENCE 计算填充边界上的自信度
%   
    div = (2*obj.deltax+1)*(2*obj.deltay+1);
    C = confidence;
    for n = 1:length(obj.boundx) % 计算边界上的自信度
        x = obj.boundx(n); % 取得边界点坐标x
        y = obj.boundy(n); % 取得边界点坐标y
        patch_c = obj.get_patch(confidence,x,y);
        C(x,y) = sum(sum(patch_c)) / div;
    end
end

