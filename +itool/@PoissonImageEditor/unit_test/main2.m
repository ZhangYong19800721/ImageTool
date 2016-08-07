clear all;
close all;

TargetImg   = imread('pool-target.jpg');  
SourceImg   = imread('bear.jpg');  
SourceMask  = im2bw(imread('bear-mask.jpg'));  

SrcBoundry = bwboundaries(SourceMask, 8);  

figure, imshow(SourceImg), axis image  
hold on  
for k = 1:length(SrcBoundry)  
    boundary = SrcBoundry{k};  
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)  
end  
title('Source image intended area for cutting from');  

position_in_target = [10, 225];%xy  
[TargetRows, TargetCols, ~] = size(TargetImg);  

[row, col] = find(SourceMask);  

start_pos = [min(col), min(row)];  
end_pos   = [max(col), max(row)];  
frame_size  = end_pos - start_pos;  

if (frame_size(1) + position_in_target(1) > TargetCols)  
    position_in_target(1) = TargetCols - frame_size(1);  
end  
  
if (frame_size(2) + position_in_target(2) > TargetRows)  
    position_in_target(2) = TargetRows - frame_size(2);  
end  

MaskTarget = zeros(TargetRows, TargetCols);  
MaskTarget(sub2ind([TargetRows, TargetCols], row - start_pos(2) + position_in_target(2), ...  
 col - start_pos(1) + position_in_target(1))) = 1;  

TargBoundry = bwboundaries(MaskTarget, 8);  
figure, imshow(TargetImg), axis image  
hold on  
for k = 1:length(TargBoundry)  
    boundary = TargBoundry{k};  
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)  
end  
title('Target Image with intended place for pasting Source');  

templt = [0 -1 0; -1 4 -1; 0 -1 0];  
LaplacianSource = imfilter(double(SourceImg), templt, 'replicate');  
VR = LaplacianSource(:, :, 1);  
VG = LaplacianSource(:, :, 2);  
VB = LaplacianSource(:, :, 3);  

TargetImgR = double(TargetImg(:, :, 1));  
TargetImgG = double(TargetImg(:, :, 2));  
TargetImgB = double(TargetImg(:, :, 3));  
  
TargetImgR(logical(MaskTarget(:))) = VR(SourceMask(:));  
TargetImgG(logical(MaskTarget(:))) = VG(SourceMask(:));  
TargetImgB(logical(MaskTarget(:))) = VB(SourceMask(:));  
  
TargetImgNew = cat(3, TargetImgR, TargetImgG, TargetImgB);  
figure, imagesc(uint8(TargetImgNew)), axis image, title('Target image with laplacian of source inserted');  

AdjacencyMat = itool.calcAdjancency( MaskTarget );  

ResultImgR = itool.PoissonSolver(TargetImgR, MaskTarget, AdjacencyMat);  
ResultImgG = itool.PoissonSolver(TargetImgG, MaskTarget, AdjacencyMat);  
ResultImgB = itool.PoissonSolver(TargetImgB, MaskTarget, AdjacencyMat); 

ResultImg = cat(3, ResultImgR, ResultImgG, ResultImgB);  

figure;  
imshow(uint8(ResultImg));  