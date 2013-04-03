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

more off; % for Octave.

imname = 'sample-image.pgm'

nthetas       = 36;
thresh_factor =  3

[trace_data, visited, stack] = improcess(imname, thresh_factor);

im = imread(imname);
im = sum(im, 3);     % Convert to grayscale.
[L, W] = size(im);

figure;
imagesc(im);
colormap gray;
axis off;
title('Original Image');

figure;
rgb_im = zeros(L, W, 3);
rgb_im(:,:,1) = min(im / max(im(:)), 1);
rgb_im(:,:,2) = min(visited,         1);
image(rgb_im);
axis off;
title('Coverage');

figure;
hold on;
angles = [];
for n=1:length(trace_data)
	plot(trace_data(n).xs, trace_data(n).ys, 'b.-');
	angles = [angles, trace_data(n).angles];
end
axis image;
axis([0, W, 0, L]);
title('Traced Paths');

figure;
hist(angles, nthetas);
title('Angle Histogram');

figure;
rows = floor(sqrt(nthetas));
cols = ceil(nthetas / rows);
for n=1:nthetas
	subplot(rows, cols, n);
	imagesc(stack(:,:,n));
	colormap gray;
	axis off;
	
	% This looks terrible in Octave:
	title(sprintf('KRLT at %g^\\circ', (n - 1) * 360 / nthetas));
end
