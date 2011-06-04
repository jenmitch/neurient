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

function [seeds, thresh] = findseeds (im,thresh_factor)


[L,W] = size(im);

g = 20;

flat_im = im(:);
med = median(flat_im);
var_med = 1/ (length(flat_im) - 1) * sum ( (flat_im - med).^2);
std_med = sqrt (var_med);

thresh = med + std_med/thresh_factor;
gaus_kernal = [.25,.5,.25];

extras = mod(W,g);
pad_row = g-extras;
M = (W+pad_row) / g;
N = g;

maxs = [];

for r = 1:g:L
    row = im(r,:);
    filtrow = filter2(gaus_kernal,row);
    filtrowpad = [filtrow,zeros(1,pad_row)];
    filtrowmat = reshape (filtrowpad, N, M);
    [y,i]=max(filtrowmat);
    ind = find(y > thresh);
    maxloc = (ind - 1) * N + i(ind);
    ys = r * ones(1,length(maxloc));
    maxs = [maxs; maxloc', ys'];
end

extras = mod(L,g);
pad_col = g-extras;
M = (L+pad_col) / g;

for c = 1:g:W
    col = im(:,c)';
    filtcol = filter2(gaus_kernal,col);
    filtcolpad = [filtcol,zeros(1,pad_col)];
    filtcolmat = reshape (filtcolpad, N, M);
    [y,i]=max(filtcolmat);
    ind = find(y > thresh);
    maxloc = (ind - 1) * N + i(ind);
    xs = c * ones(1,length(maxloc));
    maxs = [maxs;  xs', maxloc'];
end

seeds = maxs;