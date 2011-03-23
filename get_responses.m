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

%  function responses = get_responses(xy, xc, yc, k)
%  
%  assert(nargin == 4);
%  
%  global thetas;
%  global stack;
%  
%  thetas = thetas * pi/180;
%  nthetas = length(thetas);
%  responses = zeros(k,nthetas);
%  
%  d=size(stack,1);
%  center = [xc;yc];
%  xy = xy-center;
%  
%  ztk = 0:(k-1);
%  
%  for j = 1:nthetas
%      ct = cos(thetas(j));
%      st = sin(thetas(j));
%      
%      xyp = round([ct, st; -st, ct] * xy+ center);
%  
%      responses( : , j ) = stack(xyp(2), min(xyp(1) + ztk, d) ,j );    
%  end 