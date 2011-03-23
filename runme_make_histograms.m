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

function runme_make_histograms

topdir = ['..' filesep 'Images']; %all images inside the images folder

surf_types = {'C10_5050ortho', 'C10_5050para', 'C10_5050prot', 'C10L50_5050ortho', 'C10L50_5050para','C10L50_5050prot', 'C10L50flat', 'C10L50topo', 'L10_5010para', 'L10_5010ortho', 'L10_5010prot', 'L10_5050ortho�', 'L10_5050para', 'L10_5050prot', 'L10_50050ortho', 'L10_50050para', 'L10_50050prot', 'L10flat', 'L10topo', 'L50_5050ortho', 'L50_5050para', 'L50_5050prot', 'L50flat', 'L50topo'};
%surf_types contains one entry for each condition -- ie "Flat" will combine "Flat1", "Flat2", "Flat3", etc.

surf_names = {'C10_5050ortho', 'C10_5050para', 'C10_5050prot', 'C10L50_5050ortho', 'C10L50_5050para','C10L50_5050prot', 'C10L50flat', 'C10L50topo', 'L10_5010para', 'L10_5010ortho', 'L10_5010prot', 'L10_5050ortho�', 'L10_5050para', 'L10_5050prot', 'L10_50050ortho', 'L10_50050para', 'L10_50050prot', 'L10flat', 'L10topo', 'L50_5050ortho', 'L50_5050para', 'L50_5050prot', 'L50flat', 'L50topo'}; 
%surf_names contains one entry for each title to be used on the final plot, in the same order as surf_types

folders = dir(topdir);

surfaces_to_analyze = 1:length(surf_types);

for s = surfaces_to_analyze 
    surf = surf_types{s};
%    titlename = surf_names{s};
	for n=1:length(folders)
		if(folders(n).isdir & strfind(folders(n).name,surf_types{s}))
		%will pick out each folder that contains the name of the given surface type
		  folder = folders(n).name;
		  disp(['processing folder ' topdir '/' folder]) 
  		  process_folder([topdir '/' folder]);
		  title(folder)
		  saveas(gcf,  ['..' filesep 'Results' filesep folder '-hist.eps'], 'epsc2')
  		  disp(['processed folder ' topdir '/' folder]) 
		  disp(' ')
		end
	end
end


function process_folder (folder)

files = dir(folder);

max_angle = 180;

bins = 0:11.25:(max_angle-11.25);
percents = [];


for i = 1:length(files)
    [p,basename,ext]=fileparts(files(i).name);
    if(strcmpi(ext,'.mat'))
      loadfile = [folder filesep files(i).name];
      load(loadfile);
      angles = [trace_data.angles];
      angles = mod(angles,max_angle);
      [freq,bin_centers]=hist(angles, bins);
      total = length(angles);
      norm_freq = freq/total;
      percents = [percents; norm_freq];
   end
end

figure
means = mean(percents);
[n,nbins]=size(percents);
std_err = std(percents)/sqrt(n);

bar(bins, 100 * means)
hold on
errorbar(bins, 100 * means, 100 * std_err, 'k.', 'linewidth',2)
xlim([floor(0-11.25/2), ceil(max_angle-11.25/2)])

xlabel('Angle','fontsize',16)
ylabel('Percent (%)', 'fontsize',16)

h = findobj(gca,'Type','patch');
set(h,'FaceColor','k')
set(gca,'fontname','arial')
set(gca,'fontsize',16)