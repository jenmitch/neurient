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

function distance_to_segment_tester(dim)

if (nargin < 1)
	dim = 500;
end

figure;
while 1
	s = ceil(rand(1,4) * dim)
	distance_map = distance_to_segment(dim, dim, s(1), s(2), s(3), s(4));
	imagesc(distance_map);
	hold on;
	plot(s([1,3]), s([2,4]), 'wo-');
	axis image;
	disp('Press any key for another segment or Ctrl+C to quit.');
	pause;
end
