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

function data=initData(N)

data.title(1:N,1)={''};
data.year(1:N,1)={''};
data.in(1:N,1)={''};
data.volume(1:N,1)={''};
data.number(1:N,1)={''};
data.pages(1:N,1)={''};
data.type(1:N,1)={''};
data.authors(1:N,1)={''};
data.affiliations(1:N,1)={''};
data.pid(1:N,1)={''};
data.doi(1:N,1)={''};