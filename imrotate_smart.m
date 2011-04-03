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
		method = 'bilinear';
	end
end

flat = imgpre(:);
minval = min(flat);
maxval = max(flat);
range = (maxval - minval);
imgpost = (imrotate((imgpre - minval) / range, theta, method, bbox) * range) + minval;
