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

close all


thresh_factor = 2;
orig_folder = 'random';
toppath = ['..' filesep 'Images' filesep 'random' filesep];
%  toppath2 = ['..' filesep 'Images' filesep 'Rotated' filesep];

files = dir(toppath);

for i=1:length(files)

	[path, name, ext] = fileparts(files(i).name);
	if( (files(i).name(1) ~= '.') &  not(strcmp(ext,'.mat')) ) %is an image

		imname = files(i).name;
		imloc = [toppath imname];


		%Show Test Image
		im=imread(imloc);
		figure
		imagesc(im)
		axis image
		set(gca,'xticklabel',[])
		set(gca,'yticklabel',[])
		colormap gray 
		saveas(gcf,  ['..' filesep 'Results' filesep imname] ,'jpg')

		[p,basename,ext]=fileparts(imname);
		loadfile = [toppath basename '-trace-data.mat'];
%  		loadfile2 = [toppath2 basename '-trace-data.mat'];
		savename = ['..' filesep 'Results' filesep basename];

		
		%Run tracing algorithm on test image, or load the already processed data
		if (exist(loadfile,'file'))
			  disp(['already processed ' imloc])
			  load(loadfile)
			  disp('loaded trace data')
		else
			  disp(['processing' imloc])
			  savename_trace = [toppath basename '-trace-data.mat'];
			  tic
			  trace_data = improcess(imloc,thresh_factor);
			  save(savename_trace, 'trace_data');
			  t=toc / 60;
			  disp(sprintf('saved %s; processing took %.2f minutes', savename, t))
			  load(savename_trace)
			  disp('loaded trace data')
		end


		n = length(trace_data);

%  		figure
%  		hold on
%  		axis ij
%  
%  
%  		hold on
%  		%  color = hsv(n);
%  		%  color = zeros(n,3);
		color = ones(n,3);
%  
%  
		for i=1:n
		  x = trace_data(i).xs;
		  y = trace_data(i).ys;
		  
		  plot(x,y,'color',color(i,:));%,'linewidth',1.5);
		  hold on
		end

		set(gca,'xticklabel',[])
		set(gca,'yticklabel',[])
		set(gca,'color', [0 0 0])
		axis image

		saveas(gcf,[savename 'k2'],'jpg')
		%saveas(gcf,savename,'epsc2')



		%make histogram
		figure
		max_angle = 180;
		bins = 0:11.25:(max_angle-11.25);
		angles = [trace_data.angles];
		angles = angles - 11.25/5;
		angles = mod(angles,max_angle);

		[freq,bin_centers]=hist(angles, bins);
		total = length(angles);
		norm_freq = freq/total;

		bar(bins, 100 * norm_freq)

%  		load(loadfile2)
%  		angles = [];
%  		angles = [trace_data.angles];
%  		angles = angles - 11.25/5;
%  		angles = mod(angles,max_angle);
%  
%  		[freq,bin_centers]=hist(angles, bins);
%  		total = length(angles);
%  		norm_freq = freq/total;
%  
%  		hold on
%  		plot(bins, circshift(100 * norm_freq', 8),'rs-')
%  %  		plot(bins, 100*norm_freq, 'g^-')
%  		legend('original','rotated');

		title(basename,'fontsize',16)


%  		xlim([floor(0-11.25/2), ceil(max_angle-11.25/2)])

%  		ylim([0, 14])

		xlabel('Angle','fontsize',16)
		ylabel('Percent (%)', 'fontsize',16)

		h = findobj(gca,'Type','patch');
		set(h,'FaceColor','k')
		set(gca,'fontname','arial')
		set(gca,'fontsize',16)

		saveas(gcf,savename,'jpg')

	end
end	