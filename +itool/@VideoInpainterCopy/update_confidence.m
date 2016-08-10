function C = update_confidence(obj,confidence,ran_x,ran_y,ran_t)
%UPDATE_CONFIDENCE 更新所有边界点对应的自信度
%  
    C = confidence;
    div = (2*obj.delta_x+1)*(2*obj.delta_y+1)*(2*obj.delta_t+1);
    for x = ran_x
        for y = ran_y
            for t = ran_t
                [cube_c,valid] = obj.get_cube(confidence,x,y,t);
                C(x,y,t) = sum(sum(sum(cube_c.*valid)))/div;
            end
        end
    end
end

