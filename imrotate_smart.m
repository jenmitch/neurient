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

function imgpost = imrotate_smart(imgpre, theta, method, bbox)

if (nargin < 4)
	bbox = 'crop';
	if (nargin < 3)
		method = 'Fourier';
	end
end

flat = imgpre(:);
minval = min(flat);
maxval = max(flat);
range = (maxval - minval);

% Force the image intensity into the 0..1 range.
% This is required because imrotate behaves differently with values outside this range.
norm_im = (imgpre - minval) / range;

if (strcmp(method, 'Fourier'))
	if (exist('OCTAVE_VERSION'))
		% Use Octave's built-in imrotate function:
		rotated = imrotate(norm_im, theta, method, bbox);
	else
		% Use custom imrotate function (which only accepts two parameters):
		rotated = RotateImage(norm_im, theta);
	end
else
	% For non-Fourier methods, use the built-in imrotate function:
	rotated = imrotate(norm_im, theta, method, bbox);
end

imgpost = rotated * range + minval; % Restore the original image intensity range.
