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

function distance_map = distance_to_segment(imwidth, imheight, x0, y0, x1, y1)

delta_x = x1 - x0;
delta_y = y1 - y0;

[xx, yy] = meshgrid(1:imwidth, 1:imheight);

% Parameterize all points along the line:
t = ((xx - x0) * delta_x + (yy - y0) * delta_y) / (delta_x ^ 2 + delta_y ^ 2);

% Compute the distance to the line:
dist_line = (x0 + t * delta_x - xx) .^ 2 + (y0 + t * delta_y - yy) .^ 2;

% Clobber portions outside the segment:
dist_line((t < 0) | (t > 1)) = +inf;

% Take the minimum with the distances to the two endpoints:
distance_map = sqrt(min(dist_line, min( ...
	(xx - x0) .^ 2 + (yy - y0) .^ 2, ... % distance to endpoint 0
	(xx - x1) .^ 2 + (yy - y1) .^ 2)));  % distance to endpoint 1
