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

function stack = get_stack(im, basename, ntheta, r, k)
stackname = sprintf('%s-stack-n%d-r%d-k%d.mat', basename, ntheta, r, k);
if (exist(stackname, 'file'))
	data = load(stackname);
	stack = data.stack;
	disp(sprintf('Loaded "%s".', stackname));
else
	disp(sprintf('Generating "%s"....', stackname));
	stack = makestack(im, ntheta, r, k);
%  	save(stackname, 'stack');
end
