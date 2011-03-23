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

function runme_compare_alignment

topdir = ['..' filesep 'Images']; %all images inside the images folder
savename = ['..' filesep 'Results' filesep 'perpendicular-alignment.xls'];

surf_types = {'C10_5050ortho', 'C10_5050para', 'C10_5050prot', 'C10L50_5050ortho', 'C10L50_5050para','C10L50_5050prot', 'C10L50flat', 'C10L50topo', 'L10_5010para', 'L10_5010ortho', 'L10_5010prot', 'L10_5050ortho', 'L10_5050para', 'L10_5050prot', 'L10_50050ortho', 'L10_50050para', 'L10_50050prot', 'L10flat', 'L10topo', 'L50_5050ortho', 'L50_5050para', 'L50_5050prot', 'L50flat', 'L50topo'};
%surf_types contains one entry for each condition -- ie "Flat" will combine "Flat1", "Flat2", "Flat3", etc.

surf_names = {'C10_5050ortho', 'C10_5050para', 'C10_5050prot', 'C10L50_5050ortho', 'C10L50_5050para','C10L50_5050prot', 'C10L50flat', 'C10L50topo', 'L10_5010para', 'L10_5010ortho', 'L10_5010prot', 'L10_5050ortho', 'L10_5050para', 'L10_5050prot', 'L10_50050ortho', 'L10_50050para', 'L10_50050prot', 'L10flat', 'L10topo', 'L50_5050ortho', 'L50_5050para', 'L50_5050prot', 'L50flat', 'L50topo'}; 
%surf_names contains one entry for each title to be used on the final plot, in the same order as surf_types

thresh_angle = 22.5;

num_conditions = length(surf_types);

surfaces_to_analyze = 1:num_conditions;
num_wells = zeros(1,num_conditions);
aligned = [];
groups = {};
data_cell = cell(1, num_conditions);

for s = surfaces_to_analyze 
    surf = surf_types{s};
    titlename = surf_names{s};
	folders = dir([topdir filesep surf '*'])
	for n=1:length(folders)
		if(folders(n).isdir)
		%will pick out each folder that contains the name of the given surface type
		  folder = folders(n).name;
		  num_wells(s) = num_wells(s) + 1;
		  disp(['processing folder ' topdir filesep folder]) 
  		  angles = analyze_folder([topdir filesep folder]);
		  percent_aligned = find_alignment(angles, thresh_angle);
		  aligned = [aligned; percent_aligned];  		  
		  groups = [groups; surf_types{s}];
		  data_cell{s} = [data_cell{s}; percent_aligned];
  		  disp(['processed folder ' topdir filesep folder]) 
		  disp(' ')
		end
	end
end

data_mat = cell2mat(data_cell);


figure
g = unique(groups);
means = zeros (1, length(g));
std_err = zeros (1, length(g));
for i=1:length(g)
	ind = find (strcmp(g{i},groups) );
	data = aligned(ind);
	means(i) = mean(data);
	std_err(i) = std(data) / sqrt(length(data)) ;
end

xlswrite(savename,surf_types,'conditions')
xlswrite(savename, data_mat,'data')

bar(means, .75, 'w', 'linewidth', 2)
hold on
errorbar (means, std_err, 'k.', 'linewidth', 2)
set(gca,'xticklabel',g)
set(gca,'fontsize',16)
ylabel('Alignment (%)','fontsize',16)
saveas(gcf, ['..' filesep 'Results' filesep 'percent-aligned-perp.eps'], 'epsc2')



function data = analyze_folder(foldername)
files = dir(foldername);

angles = [];

for i = 1:length(files)
    [path, name, ext] = fileparts(files(i).name);
    if(strcmpi(ext, '.mat')) %is a .mat file
	imloc = [foldername filesep name ext];
	load(imloc);
	results = [trace_data.angles];
	angles = [angles, results];
	disp(sprintf('added %s to angles variable',name))
    end
 end

%  wrapped_angles = mod(angles,180);
%  mirrored_angles = wrapped_angles + 180;
%  data = [wrapped_angles, mirrored_angles];

data = angles;


function pa = find_alignment(angles, thresh_angle);

total = length(angles);

pa2 = length(find( (angles>=90-thresh_angle) & (angles <= 90+thresh_angle) )); %finds angles a satisfying 90-thetha<=a<=90+theta
pa3 = length(find( (angles>=270-thresh_angle) & (angles <= 270+thresh_angle) )); %finds angles a satisfying 360-theta<=a<=360

pa = 100* ( pa2 + pa3) / total ; 