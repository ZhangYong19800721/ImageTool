function z = frdescp(s)
%FRDESCP Computes Fourier descriptors.
%   Z = FRDESCP(S) computes the Fourier descriptors of S, which is an
%   np-by-2 sequence of ordered coordinates describing a boundary.  
%
%   Due to symmetry considerations when working with inverse Fourier
%   descriptors based on fewer than np terms, the number of points in
%   S when computing the descriptors must be even.  If the number of
%   points is odd, FRDESCP duplicates the end point and adds it at
%   the end of the sequence. If a different treatment is desired, the
%   sequence must be processed externally so that it has an even
%   number of points.
%
%   See function IFRDESCP for computing the inverse descriptors. 

%   Copyright 2002-2009 R. C. Gonzalez, R. E. Woods, and S. L. Eddins
%   From the book Digital Image Processing Using MATLAB, 2nd ed.,
%   Gatesmark Publishing, 2009.
%
%   Book web site: http://www.imageprocessingplace.com
%   Publisher web site: http://www.gatesmark.com/DIPUM2e.htm

% Preliminaries.
[np, nc] = size(s);
if nc ~= 2 
   error('S must be of size np-by-2.'); 
end
if np/2 ~= round(np/2);
   s(end + 1, :) = s(end, :);
   np = np + 1;
end

% Create an alternating sequence of 1s and -1s for use in centering
% the transform.
x = 0:(np - 1);
m = ((-1) .^ x)';
 
% Multiply the input sequence by alternating 1s and -1s to center
% the transform.
s(:, 1) = m .* s(:, 1);
s(:, 2) = m .* s(:, 2);
% Convert coordinates to complex numbers.
s = s(:, 1) + i*s(:, 2);
% Compute the descriptors.
z = fft(s);
