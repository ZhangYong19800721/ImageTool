function confidence = update_confidence(obj,conf)
%UPDATE_CONFIDENCE �������б߽���Ӧ�����Ŷ�
%  
    confidence = conf;
    div = (2*obj.gapx+1)*(2*obj.gapy+1)*(2*obj.gapf+1);
    for n = 1:length(obj.boundary_x)  % ���±߽������Ŷ�
        nx=obj.boundary_x(n); ny=obj.boundary_y(n); nf=obj.boundary_f(n);
        cubic = obj.get_patch(conf,nx,ny,nf);
        confidence(nx,ny,nf) = sum(sum(sum(cubic)))/div;
    end
end

