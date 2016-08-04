function distance = match_distance(obj,patch,exampler,patch_mask)
%MATCH_DISTANCE ����patch���exampler֮��ľ���
%   
    [~,~,z] = size(patch);
    mask = repmat(double(~patch_mask),1,1,z);
    v1 = double(patch) .* mask;
    v2 = double(exampler) .* mask;
    distance = sqrt(sum((reshape(v1,1,[])-reshape(v2,1,[])).^2)) / numel(v1);
end

