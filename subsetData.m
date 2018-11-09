% This file is part of dataDiVA, a code to assemble the results of 
% multiple searches of the Digitala vetenskapliga arkivet (DiVA) into a 
% database structure, and to write out a htm format List of Publications. 
% 
% Copyright (C) 2018 Ciaran O'Reilly <ciaran@kth.se>
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function data=subsetData(data,field,value)

if isstr(field)==1
  i=find(not(cellfun('isempty',strfind(eval(['data.',field]),value))));
else
  i=field;
end
fnames=fieldnames(data);
for f=1:numel(fnames)
  eval(['data.',fnames{f},'=data.',fnames{f},'(i,:);']);
end