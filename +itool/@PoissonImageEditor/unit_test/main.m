clear all;
close all;

movie = load('E:\WorkSpace\itool\+itool\@VideoInpainter\unit_test\movie.mat');
mask = load('E:\WorkSpace\itool\+itool\@VideoInpainter\unit_test\mask.mat');

movie = movie.mov(:,:,:,1:100);
mask = mask.image(1:237,(1920-576+1):1920);
% itool.play_movie(movie);

movie_image = double(movie(:,:,:,1));

laplace = [0 -1 0; -1 4 -1; 0 -1 0];  
laplace_image = imfilter(movie_image, laplace, 'replicate');  

Y = movie_image(:,:,1);
U = movie_image(:,:,2);
V = movie_image(:,:,3);

laplace_Y = laplace_image(:,:,1);
laplace_U = laplace_image(:,:,2);
laplace_V = laplace_image(:,:,3);

pie = itool.PoissonImageEditor();
adjacent = pie.compute_adjacent(mask);

Y(mask) = laplace_Y(mask);
U(mask) = laplace_U(mask);
V(mask) = laplace_V(mask);

NY = pie.poisson_solver(Y,mask,adjacent);
NU = pie.poisson_solver(U,mask,adjacent);
NV = pie.poisson_solver(V,mask,adjacent);

recover = cat(3,NY,NU,NV);
imshow(ycbcr2rgb(uint8(recover)));

% vi = itool.VideoInpainter(4,4,2);
% vi = vi.inpaint(movie,mask);
