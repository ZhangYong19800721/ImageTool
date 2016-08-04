function C = compute_confidence(obj,confidence)
%COMPUTE_CONFIDENCE �������߽��ϵ����Ŷ�
%   
    div = (2*obj.deltax+1)*(2*obj.deltay+1);
    C = confidence;
    for n = 1:length(obj.boundx) % ����߽��ϵ����Ŷ�
        x = obj.boundx(n); % ȡ�ñ߽������x
        y = obj.boundy(n); % ȡ�ñ߽������y
        patch_c = obj.get_patch(confidence,x,y);
        C(x,y) = sum(sum(patch_c)) / div;
    end
end

