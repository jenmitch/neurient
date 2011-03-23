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

function process_folder (foldername,thresh_factor)

files = dir(foldername);

for i = 1:length(files)
  [path, name, ext] = fileparts(files(i).name);
  if( (files(i).name(1) ~= '.') &  not(strcmp(ext,'.mat')) ) %is an image
    imloc = [foldername filesep files(i).name];
    disp(['sending ' imloc ' to improcess'])
    savename = [foldername filesep name '-trace-data.mat'];	   
    if (exist(savename,'file') )
      disp(['already processed ' imloc])
    else
      tic
      trace_data = improcess(imloc,thresh_factor);
      save(savename, 'trace_data');
      t=toc / 60;
      disp(sprintf('saved %s; processing took %.2f minutes', savename, t))
    end
    
  end
end
