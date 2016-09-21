function [rn,cn] = color_space(row_num,col_num,chroma)
%color_space 此处显示有关此函数的摘要
%   此处显示详细说明
    if strcmp(chroma,'yuv444p')
        cn = col_num;
        rn = row_num;
    elseif strcmp(chroma,'yuv420p')
        cn = col_num/2;
        rn = row_num/2;
    elseif strcmp(chroma,'yuv422p')
        cn = col_num/2;
        rn = row_num;
    else
        error('Wrong chroma format');
    end
end

