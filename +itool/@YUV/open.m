function obj = open(obj,option)
%OPEN 此处显示有关此函数的摘要
%   此处显示详细说明
    obj.fid = fopen(obj.filename,option);
end

