function C = update_confidence(obj,confidence,range_x,range_y)
%UPDATE_CONFIDENCE 更新自信度
%   
    C = confidence;
    div = (2*obj.deltax+1)*(2*obj.deltay+1);
    for x = range_x
        for y = range_y
            if confidence(x,y) == 0
                patch = obj.get_patch(confidence,x,y);
                C(x,y) = sum(sum(patch)) / div;
            end
        end
    end
end

