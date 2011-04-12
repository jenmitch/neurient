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

function trace_data = improcess(imname, thresh_factor)

modseed = 500;
s=3;
r=0;
k=15;
nthetas = 36;
maxcount=100;

kern_width = 1 + 2 * (r + 5);
b = max(kern_width, k); % boundary size

[path,basename,ext] = fileparts(imname);
%  stackname = [basename '-stack.mat'];

[im,map] = imread(imname);

if(length(map)==0)
	im = double(im);
else
	im = double(map(im+1));
end

[L,W,depth]=size(im);

if (depth > 1)
  im = mean(im,3);
end

disp('loading/creating stack...')
stack = get_stack(im, basename, nthetas, r, k);
disp('loaded stack')

[L,W,nthetas] = size(stack);

indices = (1:nthetas)';
thetas = (indices - 1) * 360 / nthetas;

[seeds, thresh] = findseeds(im, thresh_factor) ;
nseeds = size(seeds,1);
disp(sprintf('found %d seeds',nseeds))


trace_data = struct('seed', [ ], 'init_dir', [ ], 'xs', [], 'ys', [], 'angles', []);
%initialize trace_data structure to have nseeds members
trace_data(nseeds).seed = [0;0];

shift_range = round(nthetas / 4); %look only at +/- 90 degrees
if (shift_range < 1), shift_range = 1; end

window_size = 1 + 2*shift_range;
window_ind  = 1:window_size;

% Create step vector lookup table:
step_cache_u = round(s * cos(thetas * pi /180));
step_cache_v = round(s * sin(thetas * pi /180));

% Create boundary-checking lookup table:
[xx,yy] = meshgrid(1:W, 1:L);
boundary_check = (xx < b) | (xx > W-b) | (yy < b) | (yy > L-b);
clear xx yy b;

% Initialize buffers:
xs = zeros(1,maxcount);
ys = zeros(1,maxcount);
angles = zeros(1,maxcount);

visited = zeros(L, W); % keeps track of which coordinates we've already visited.

% Generate stamps for all possible line segments:
thickness = 2 * r + 3;                     % Check this.
dim = ceil(s + thickness) + 2;             % Add a one-pixel margin to each side.
if (mod(dim, 2) == 0), dim = dim + 1; end; % force an odd number.
segment_stamps = zeros(dim, dim, nthetas);
center = ceil(dim / 2);
for i=1:nthetas
	theta = 2 * pi * (i - 1) / nthetas;
	segment_stamps(:,:,i) = draw_line_segment(dim, dim, center, center, center + s * cos(theta), center + s * sin(theta), thickness);
end
stamp_offsets = (1:dim) - center;

for i = 1:nseeds

	xi=seeds(i,1);
	yi=seeds(i,2);
	trace_data(i).seed = [xi, yi];
	violations = 0;

	for count=1:maxcount
		visited(yi, xi) = 1;

	   xs(count) = xi;
	   ys(count) = yi;    
	   
		meds = stack(yi, xi, :);
		meds = meds(:);

		if(count > 1)
			%ind_top = find_max(meds, shift_range + 1 - ind_top, window_size);
			
			shift_ind = circshift(indices, shift_range + 1 - ind_top);
			[y, index] = max(meds(shift_ind(window_ind)));
			ind_top = shift_ind(index);
			
			direction = thetas(ind_top);
		else %initial direction -- no restriction
			[y, ind_top] = max(meds);
			direction =  thetas(ind_top);
			trace_data(i).init_dir = direction;
		end
	  
		angles(count) = direction;
	  
		x0 = xi;
		y0 = yi;

		xi = xi + step_cache_u(ind_top);
		yi = yi + step_cache_v(ind_top); 
	  
		xi = min(max(xi, 1), W);
		yi = min(max(yi, 1), L);

		thresh_violation   = (im(yi, xi) < thresh) / 4;
		boundary_violation = boundary_check(yi, xi);
%  		retrace_violation = 0;
		retrace_violation  = min(visited(yi, xi), 1) * 4;
		this_violation     = thresh_violation +  boundary_violation + retrace_violation;

		if (this_violation)
			violations = violations + this_violation;
			if (violations >= 4), break; end
		else
			violations = 0;
		end

		rows = y0 + stamp_offsets;
		cols = x0 + stamp_offsets;
		if (all((rows >= 1) & (rows <= L)) & all((cols >= 1) & (cols <= W))) % Not sure if this condition is necessary.
			visited(rows, cols) = visited(rows, cols) + segment_stamps(:,:,ind_top);
		end

	end %ends while(violations < 4) -- all steps along ith seed line

	trace_data(i).xs     = xs(1:count); 
	trace_data(i).ys     = ys(1:count);
	trace_data(i).angles = angles(1:count);

if(mod(i,modseed)==0)
disp(sprintf('finished seed number %d of %d',i, nseeds))
end


end

if 1
figure
rgb_im = zeros(L, W, 3);
mx = max(max(im));
%  im(im>thresh) = mx;
%  rgb_im(:,:,1) = im/mx;
rgb_im(:,:,1) = min(im * 3, 1);
%  visted(visited>1) = 1;
rgb_im(:,:,2) = min(visited,1);
image(rgb_im)
%  keyboard;

%  imagesc(visited)
axis image
%  axis ij
%  colormap gray
axis equal
title(basename)
end

%  function ind = find_max(values, shift, width)
%  	shift_ind = circshift((1:length(values))', shift);
%  	[y, i] = max(values(shift_ind(1:width)));
%  	ind = shift_ind(i);
