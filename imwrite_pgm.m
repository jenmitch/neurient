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

function imwrite_pgm(img, filename)

%  octave: magick/semaphore.c:525: LockSemaphoreInfo: Assertion `semaphore_info != (SemaphoreInfo *) ((void *)0)' failed.
%  panic: Aborted -- stopping myself...
%  attempting to save variables to `octave-core'...
%  save to `octave-core' complete
%  Aborted

[L,W] = size(img);

img = floor(img);

fid = fopen(filename, 'w');
fprintf(fid, 'P2\n\n%d %d\n%d\n', L, W, 255);
for y=1:L
	for x=1:W
		fprintf(fid, '%d ', img(y, x));
	end
		fprintf(fid, '\n');
end

fclose(fid);
