function priority = compute_priority(obj,confidence,dataterm,boundary)
%COMPUTE_PRIORITY 此处显示有关此函数的摘要
%   此处显示详细说明
    priority = confidence.*dataterm;
    priority = priority(boundary);
end

