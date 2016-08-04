function confidence = update_confidence(obj,conf)
%UPDATE_CONFIDENCE 更新所有边界点对应的自信度
%  
    confidence = conf;
    div = (2*obj.gapx+1)*(2*obj.gapy+1)*(2*obj.gapf+1);
    for n = 1:length(obj.boundary_x)  % 更新边界点的自信度
        nx=obj.boundary_x(n); ny=obj.boundary_y(n); nf=obj.boundary_f(n);
        cubic = obj.get_patch(conf,nx,ny,nf);
        confidence(nx,ny,nf) = sum(sum(sum(cubic)))/div;
    end
end

