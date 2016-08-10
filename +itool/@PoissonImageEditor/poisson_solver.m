function result_image = poisson_solver(obj, image, mask, adjacent)
%POISSONSOLVER ���ɷ��̽�����
%   image: ��Ҫ���۸ĵ�ͼƬ��image����Ҫ���۸��������ֵ������ʸ������ɢ�ȣ���div��v��������v������ʸ������
%   mask����ֵͼ�����С��image��ͬ��1-��ʾ��Ҫ���۸ĵ�����0-��ʾ��֪����
%   adjacent���ڽӾ��󣬱�ʾmask����Ҫ���۸������Ԫ�ص�4-connect���ڹ�ϵ
%   boundry����Ҫ���۸�����ı߽�
    result_image = image;
    [row_num,~] = size(adjacent);
    A = -4 * eye(row_num) + adjacent;
    F = double(image) .* double(~mask);
    F = conv2(F,[0 1 0; 1 0 1; 0 1 0],'same');
    b = -1 * double(image(logical(mask))) - F(logical(mask)); 
    x = cgs(A,b,1e-3,100); % ʹ�ù����ݶȷ������Է�����Ax=b
    result_image(logical(mask)) = uint8(x);
end

