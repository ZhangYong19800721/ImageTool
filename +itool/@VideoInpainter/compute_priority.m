function P = compute_priority(obj,confidence,dataterm,energy,front_idx)
%COMPUTE_PRIORITY �������б߽������ȼ�
%   �˴���ʾ��ϸ˵��
    P = confidence .* dataterm .* energy;
    P = P(front_idx);
end

