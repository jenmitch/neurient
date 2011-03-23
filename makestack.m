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

d = ceil(sqrt(L^2 + W^2));
if (mod(d,2)) %odd
 d=d+1;
end

vpad = ceil((d-L)/2);
hpad = ceil((d-W)/2);

impad = [zeros(vpad,d);
		zeros(L,hpad), im, zeros(L,hpad);
		zeros(vpad,d)];

step = 360 / ntheta;

%all images rotated: remove bias?
%thetas = thetas + step/2;

kernel = [-1, -2, 0, 2, 1, zeros(1, 1 + 2*r), 1, 2, 0, -2, -1]';

stack = zeros(L, W, ntheta);

shifteds = zeros(d, d, k);
crop_rows = vpad + (1:L);
crop_cols = hpad + (1:W);


for i = 1:ntheta
       theta = (i - 1) * step + 0.5;
       disp(sprintf('Rotating by %g.', theta));
       rotated = imrotate_smart(impad, theta);
       
       disp('Filter2ing.');
       filtered = filter2(kernel, rotated);

       disp('Circshifting.');
       for j = 1:k
               shifteds(:,:,j) = circshift(filtered, [0, -(j-1)]);
       end

       disp('Computing medians.');
	%medians = median(shifteds, 3);
	medians = mean(shifteds, 3);
       disp(sprintf('Rotating by %g.', -theta));
       uncropped = imrotate_smart(medians, -theta);
       disp('Cropping');
       stack(:,:,i) = uncropped(crop_rows, crop_cols);
       disp(sprintf('Finished angle %d\n', i));
end

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
