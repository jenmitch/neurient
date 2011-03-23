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


thresh_factor = 2;
topdir = ['..' filesep 'Images']; %all images inside the images folder

surf_types = {'random'};
%surf_types contains one entry for each condition -- ie "Flat" will combine "Flat1", "Flat2", "Flat3", etc.

surf_names = {'random'}; 
%surf_names contains one entry for each title to be used on the final plot, in the same order as surf_types

folders = dir(topdir);

surfaces_to_analyze = 1:length(surf_types);

for s = surfaces_to_analyze 
    surf = surf_types{s};
    titlename = surf_names{s};
	for n=1:length(folders)
		if(folders(n).isdir & strfind(folders(n).name,surf_types{s}))
		%will pick out each folder that contains the name of the given surface type
		  folder = folders(n).name;
		  disp(['processing folder ' topdir filesep folder]) 
  		  process_folder([topdir filesep folder],thresh_factor);
  		  disp(['processed folder ' topdir filesep folder]) 
		end
	end
end



