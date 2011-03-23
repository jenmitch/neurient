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

function runme_compare_alignment_images
%gets parallel and perpendicular alignment for each image in a folder

topdir = ['..' filesep 'Images']; %all images inside the images folder
savename = ['..' filesep 'Results' filesep 'alignment.xls'];

surf_types = {'random3'};
%surf_types contains one entry for each condition -- ie "Flat" will combine "Flat1", "Flat2", "Flat3", etc.

surf_names = {'random'}; 
%surf_names contains one entry for each title to be used on the final plot, in the same order as surf_types

%  thresh_angle = 22.5;
step = 10;
thresh_angle = step*2; 
num_conditions = length(surf_types);

surfaces_to_analyze = 1:num_conditions;
num_wells = zeros(1,num_conditions);
aligned = [];
groups = {};
data_pa = cell(1, num_conditions);
data_pp = cell(1, num_conditions);

max_angle = 360;
bins = 0:step:(max_angle-step);

for s = surfaces_to_analyze 
    surf = surf_types{s};
    titlename = surf_names{s};
	folders = dir([topdir filesep surf '*']);
	for n=1:length(folders)
	    if(folders(n).isdir)%will pick out each folder that contains the name of the given surface type
		  folder = folders(n).name;
		  disp(['processing folder ' topdir filesep folder]) 
		  files = dir([topdir filesep folder]);
	      for i=1:length(files)
		[path, name, ext] = fileparts(files(i).name);
			if( strcmpi (ext,'.mat') ) %is a trace file
			  load([topdir filesep folder filesep name ext]);
			  angles = [trace_data.angles];
%  			  angles = angles - step/2;

			  [parallel, perpendicular] = find_alignment(angles,thresh_angle);
			  data_pa{s} = [data_pa{s}; parallel];
			  data_pp{s} = [data_pp{s}; perpendicular];

			  %[freq,bin_centers]=hist(angles, 36);
			  [freq,bin_centers]=hist(angles, bins);
			  total = length(angles);
			  norm_freq = freq/total;

			  figure
			  bar(bin_centers, 100 * norm_freq)
			  %plot(sort(angles),'bo-');
			  title([folder filesep name])
			end
	      end
	    end	
%  			keyboard
	end
end


data_mat_pa = cell2mat(data_pa);
data_mat_pp = cell2mat(data_pp);

figure
boxplot([data_mat_pa,data_mat_pp]);
[h,p]=ttest2(data_mat_pa,data_mat_pp)


keyboard

%  xlswrite(savename,surf_types,'conditions')
%  xlswrite(savename, data_mat_pa,'parallel')
%  xlswrite(savename, data_mat_pp,'perpendicular')



function [pa, pp] = find_alignment(angles, thresh_angle);

total = length(angles);


pa1 = length(find( (angles>=0) & (angles <= 0+thresh_angle) )); %finds angles a satisfying  0<=a<=theta  
pa2 = length(find( (angles>=180-thresh_angle) & (angles <= 180+thresh_angle) )); %finds angles a satisfying 180-thetha<=a<=180+theta
pa3 = length(find( (angles>=360-thresh_angle) & (angles <= 360) )); %finds angles a satisfying 360-theta<=a<=360

pa = 100* (pa1 + pa2 + pa3) / total ; 


pa4 = length(find( (angles>=90-thresh_angle) & (angles <= 90+thresh_angle) )); %finds angles a satisfying 90-thetha<=a<=90+theta
pa5 = length(find( (angles>=270-thresh_angle) & (angles <= 270+thresh_angle) )); %finds angles a satisfying 270-theta<=a<=270+theta

pp = 100* ( pa4 + pa5) / total ; 

%  angles = angles + 360;
%  pa = 100 * ( nnz((angles >= 360+0-thresh_angle) & (angles < 360+0+thresh_angle)) ...
%    + nnz((angles >= 360+180-thresh_angle) & (angles < 360+180+thresh_angle)) ) / total;
%  
%  pp = 100 * ( nnz((angles >= 360+90-thresh_angle) & (angles < 360+90+thresh_angle)) ...
%    + nnz((angles >= 360+270-thresh_angle) & (angles < 360+270+thresh_angle)) ) / total;

