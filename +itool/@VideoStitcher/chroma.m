function [cw,ch] = chroma( obj,width,height,chroma_format )
%CHROMA �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    if strcmp(chroma_format, 'yuv444p')
        cw = width;
        ch = height;
    elseif strcmp(chroma_format, 'yuv420p')
        cw = width/2;
        ch = height/2;
    elseif strcmp(chroma_format, 'yuv422p')
        cw = width/2;
        ch = height;
    else
        error('Wrong chroma format');
    end
end

