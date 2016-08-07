function P = compute_priority(obj,confidence,dataterm,energy,front_idx)
%COMPUTE_PRIORITY 计算所有边界点的优先级
%   此处显示详细说明
    P = confidence .* dataterm .* energy;
    P = P(front_idx);
end

