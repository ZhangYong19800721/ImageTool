function P = compute_priority(obj,confidence,dataterm,front_idx)
%COMPUTE_PRIORITY �������б߽������ȼ�
%   �˴���ʾ��ϸ˵��
    P = confidence .* dataterm;
    P = P(front_idx);
end

