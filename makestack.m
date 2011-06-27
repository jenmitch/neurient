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

function stack = makestack(im, ntheta, r, k)

use_fft = 1;

if (nargin < 4)
	k = 10;
	if (nargin < 3)
		r = 1;
		if (nargin < 2)
			ntheta = 36;
		end
	end
end

assert(size(im, 3) == 1);

[L,W] = size(im);



d = sqrt(L^2 + W^2);

vpad = ceil((d-L)/2);
hpad = ceil((d-W)/2);

impad = [
	zeros(vpad, hpad + W + hpad);
	zeros(L,hpad), im, zeros(L,hpad);
	zeros(vpad, hpad + W + hpad)
];

if use_fft
  impad = fft_circ_mask(impad);
end


step = 360 / ntheta;

%all images rotated: remove bias?
%thetas = thetas + step/2;

kernel = [-1, -2, 0, 2, 1, zeros(1, 1 + 2*r), 1, 2, 0, -2, -1]';
kern_width = length(kernel);

kernel_2d = repmat(kernel / k, [1, k]); % divide by k so we get means instead of sums.

stack = zeros(L, W, ntheta);

crop_rows = vpad + (1:L);
crop_cols = hpad + (1:W);

%         disp('enlarging');
%         impad_2x = imresize (impad, 2, 'nearest');

start_time = double(tic());

for i = 1:ntheta
       theta = (i - 1) * step;
       disp(sprintf('Rotating by %g.', theta));
       rotated = imrotate_smart(impad, theta);
%         disp('reducing');
%         rotated = imresize(rotated, 0.5, 'box');

       disp('Filter2ing.');
	medians = filter2(kernel_2d, rotated);
	
	% Now the 2D kernel is centered around the trace coordinate, but we want
	% to align the "baseline" of the kernel to the trace coordinate instead,
	% so we circshift all of the responses to get the equivalent effect:
	medians = circshift(medians, [0, -floor(k/2)]);

       disp(sprintf('Rotating by %g.', -theta));
       uncropped = imrotate_smart(medians, -theta);
       disp('Cropping');
       stack(:,:,i) = uncropped(crop_rows, crop_cols);

       minutes_elapsed = double( double(tic()) - start_time) / 1e6 / 60;
       time_remaining = minutes_elapsed * (ntheta - i) / i;
       disp(sprintf('Finished angle %d/%d, ETA %.2f minutes.\n', i, ntheta, time_remaining));
end

if 1
  sums = zeros(1,ntheta);
	margin = ceil(norm([k, floor(kern_width/2)])); % Diagonal length from trace coordinate to far corner of the 2D kernel
	rows = ((1:L) > margin) & ((1:L) <= (L-margin));
	cols = ((1:W) > margin) & ((1:W) <= (W-margin));
  for i = 1:ntheta
    sums(i) = sum(sum(stack(rows,cols,i).^2));
  end
  %  
  figure
  plot((0:(ntheta-1)) * 360/ntheta, sums,'o-')
end
%  keyboard

%  stack = stack ./ sum(sum(stack,1),2);


%original:
%  for i = 1:ntheta
%  	theta = (i - 1) * step;
%  	filtered = filter2(kernel, imrotate_smart(impad, theta));
%  
%  	for j = 1:k
%  		shifteds(:,:,j) = circshift(filtered, [0, j]);
%  	end
%  
%  	uncropped = imrotate_smart(median(shifteds, 3), -theta);
%  	stack(:,:,i) = uncropped(crop_rows, crop_cols);
%  	disp(i);
%  end
