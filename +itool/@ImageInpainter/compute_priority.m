function priority = compute_priority(obj,confidence,dataterm,boundary)
%COMPUTE_PRIORITY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    priority = confidence.*dataterm;
    priority = priority(boundary);
end

