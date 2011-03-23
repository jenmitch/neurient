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


n = 10^5;
repeats = 10;

data = zeros(repeats,2);

for i=1:repeats
  angles = 360 * rand(1,n);
  thresh_angle = 11.25;
  total = length(angles);
  
  pa1 = length(find( (angles>=0) & (angles <= 0+thresh_angle) )); %finds angles a satisfying  0<=a<=theta  
  pa2 = length(find( (angles>=180-thresh_angle) & (angles <= 180+thresh_angle) )); %finds angles a satisfying 180-thetha<=a<=180+theta
  pa3 = length(find( (angles>=360-thresh_angle) & (angles <= 360) )); %finds angles a satisfying 360-theta<=a<=360

  pa = 100* (pa1 + pa2 + pa3) / total ; 
  data(i,1) = pa;

  pa2 = length(find( (angles>=90-thresh_angle) & (angles <= 90+thresh_angle) )); %finds angles a satisfying 90-thetha<=a<=90+theta	
  pa3 = length(find( (angles>=270-thresh_angle) & (angles <= 270+thresh_angle) )); %finds angles a satisfying 360-theta<=a<=360

  pa = 100* (pa2 + pa3) / total ;
  data(i,2) = pa;
end

bar(mean(data))
hold on
errorbar(mean(data),std(data),'.')