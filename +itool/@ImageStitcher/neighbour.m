function match_count = neighbour(images)
%NEIGHBOUR ����ͼ������֮���ƥ�����
%   �˴���ʾ��ϸ˵��
    number_of_images = length(images);
    match_count = zeros(number_of_images);
    for n = 1:number_of_images
        for m = (n+1):number_of_images
            index_pairs = matchFeatures(images(n).features_points.Descript, ...
                                        images(m).features_points.Descript);
            [mc, ~] = size(index_pairs);
            match_count(n,m) = mc;
        end
    end
    match_count = triu(match_count,1) + triu(match_count,1)'; 
end

