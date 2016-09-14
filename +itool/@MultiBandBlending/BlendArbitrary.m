function C = BlendArbitrary(A, B, R, level)

% Blends two images with arbitrary shape.
% R is the region of blending. For the regions to be blended it is 1 and
% elsewhere it is 0
% A and B are the two images to be blended and level is the maximum level
% of the multiresolution pyramid to be used.
% The sizes of the input images are assumed to be same and they are at
% least 2^level x 2^level

if sum(sum(R)) == 0
    C = A;
    return;
end

[ma, na] = size(A);

[LA, GA]= itool.MultiBandBlending.LaplacianPyramid(A,level);
[LB, GB]= itool.MultiBandBlending.LaplacianPyramid(B,level);

GR  = itool.MultiBandBlending.GaussianPyramid(R,level);
GRN = 1 - GR;

LC(ma,na,level) = 0;

for i = 1:level
    LC(:,:,i) = GR(:,:,i) .* LA(:,:,i) + GRN(:,:,i) .* LB(:,:,i);
end

C = itool.MultiBandBlending.reconstruct(LC);

% figure;imshow(uint8(A));title('image 1');
% figure;imshow(uint8(B));title('image 2');
% figure;imshow(uint8(itool.MultiBandBlending.stretchImage(R)));title('region');
% figure;imshow(uint8(C));title('result');

% D = B .*(1-R) + A .* R;
% figure;imshow(uint8(D));title('direct insertion');
