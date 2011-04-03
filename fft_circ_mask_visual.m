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

function out = fft_circ_mask_visual(im)

[height, width] = size(im);
assert(length(size(im)) == 2); % Make sure image is flat.
d = max(size(im));

figure
colormap gray;

visualize(1, im, 'Original Image');

f = fftshift(fft2(im, d, d));
visualize(2, log(abs(f)), 'FFT');

x = (1:d) - d/2 - 0.5;
[xx, yy] = meshgrid(x, x);
mask = (xx .^ 2 + yy .^2) < (d/2)^2;
visualize(3, mask, 'Mask');

f2 = f .* mask;
visualize(4, log(abs(f2)), 'Masked FFT');

out = real(ifft2(fftshift(f2)));
out = out(1:height, 1:width); % crop to original size.
visualize(5, out, 'Filtered Image');

visualize(6, out - im, 'Difference Image');


function visualize(sp, im, t)
subplot(2, 3, sp);
imagesc(im);
axis image;

% fix axes in Octave:
a = axis();
axis(a(1:4) + [-0.5, 0.5, -0.5, 0.5]);

title(t);
