% 
% Copyright (C) 2011 Brown University and Ian Martin
% 
% Authors: Jennifer Mitchel <jenmitch@brown.edu>
%          Ian Martin <martini@alum.mit.edu>
% 
% This file is part of Neurient.
% 
% Neurient is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 2 of the License, or
% (at your option) any later version.
% 
% Neurient is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with Neurient.  If not, see <http://www.gnu.org/licenses/>.
% 

function out = fft_circ_mask(im)

[height, width] = size(im);

% Make sure image is flat:
assert(length(size(im)) == 2);

r = 2;
c = 3;

d = max(size(im));

%d = size(im, 1);

figure
colormap gray;
subplot(r,c,1);
imagesc(im);
axis image;
axis(axis() + [-0.5, 0.5, -0.5, 0.5, 0, 0]);
title('Original Image');


f = fftshift(fft2(im, d, d));

subplot(r,c,2);
imagesc(log(abs(f)));
axis image;
axis(axis() + [-0.5, 0.5, -0.5, 0.5, 0, 0]);
title('FFT');

x = (1:d) - d/2 - 0.5
[xx, yy] = meshgrid(x, x);
mask = (xx .^ 2 + yy .^2) < (d/2)^2;

subplot(r,c,3);
imagesc(mask);
axis image;
axis(axis() + [-0.5, 0.5, -0.5, 0.5, 0, 0]);
title('Mask');

f2 = f .* mask;

subplot(r,c,4);
imagesc(log(abs(f2)));
axis image;
axis(axis() + [-0.5, 0.5, -0.5, 0.5, 0, 0]);
title('Masked FFT');

out = abs(ifft2(fftshift(f2)));

out = out(1:height, 1:width);

subplot(r,c,5);
imagesc(abs(out));
axis image;
axis(axis() + [-0.5, 0.5, -0.5, 0.5, 0, 0]);
title('Filtered Image');

subplot(r,c,6);
imagesc(out - im);
axis image;
axis(axis() + [-0.5, 0.5, -0.5, 0.5, 0, 0]);
title('Difference Image');

%  keyboard
