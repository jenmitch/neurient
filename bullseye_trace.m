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

function out = bullseye(skip, thickness, d)
% e.g. im = bullseye(3, 6, 256);

r = 0;
k = 15;
kern_width = 11 + 2 * r;
margin = ceil(norm([k, floor(kern_width/2)]));

coords = (1:d) - d/2 - 0.5;
[xx, yy] = meshgrid(coords, coords);
r = sqrt(xx.^2 + yy.^2);
period = thickness + skip;
out = and(mod(r, period) > skip, r < (d/2 - margin));
