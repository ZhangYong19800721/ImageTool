function priority = compute_priority(obj,confidence,dataterm,boundary)
%COMPUTE_PRIORITY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    priority = confidence.*dataterm;
    % priority(1:obj.deltax,:) = -inf; priority((obj.row_num - obj.deltax + 1):obj.row_num,:) = -inf;
    % priority(:,1:obj.deltay) = -inf; priority(:,(obj.col_num - obj.deltay + 1):obj.col_num) = -inf;
    priority = priority(boundary);
end

