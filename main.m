% This file is part of dataDiVA, a code to assemble the results of 
% multiple searches of the Digitala vetenskapliga arkivet (DiVA) into a 
% database structure, and to write out a htm format List of Publications. 
% 
% Copyright (C) 2018 Ciarán O'Reilly <ciaran@kth.se>
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

%% main

clear
LoPfile='ListofPubs';
outfile='pubsDatabase';

%% inputs
searchQuery={...
  'Ciaran+J+O%27Reilly';...
  '0000-0003-0176-5358';...
  };

%% assemble data
data=initData(0);
for i=1:numel(searchQuery)
  data=appendData(data,searchDiVA(searchQuery(i)));
end

%% remove duplicates
[~,i]=unique(data.pid);
data=subsetData(data,i);

%% from year onwards
i=find(double(cell2sym(data.year)>=2006));
data=subsetData(data,i);

%% remove selected entries
data=subsetData(data,setdiff(1:length(data.title),find(not(cellfun('isempty',strfind(data.pid,'diva2%3A448905'))))));

% %% add extra info (missing conference titles - slow/deep search)
% data=addExtraDiVA(data);

%% write out LoP in KTH format
data=formatData(data);
fprintf(['writing ',LoPfile,'.htm\n'])
writeListOfPubsKTHweb(data,[LoPfile,'.htm'])

%% save
fprintf(['saving ',outfile,'.htm\n'])
save([outfile,'.mat'],'data','searchQuery')
