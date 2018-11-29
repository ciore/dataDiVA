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

function data=addExtraDiVA(data)

isi=cell(length(data.pid),1);
eid=cell(length(data.pid),1);
keywords=cell(length(data.pid),1);
conference=cell(length(data.pid),1);
for n=1:numel(data.pid)
  
  %% search record for more info
  fullURL=['http://kth.diva-portal.org/smash/record.jsf?dswid=2747&pid=',data.pid{n,1}];
  pageStr=webread(fullURL);
  
  %% read Web of Science ISI
  i=min(strfind(pageStr,'ISI: '))+5;
  if isempty(i)
    isi(n,1)={[]};
  else
    i=min(strfind(pageStr(i:length(pageStr)),'UT='))+2+i;
    i(2)=min(strfind(pageStr(i:length(pageStr)),'" '))-2+i;
    isi(n,1)={pageStr(i(1):i(end))};
  end
  
  %% read Scopus EID
  i=min(strfind(pageStr,'Scopus ID: '))+11;
  if isempty(i)
    eid(n,1)={[]};
  else
    i=min(strfind(pageStr(i:length(pageStr)),'eid='))+3+i;
    i(2)=min(strfind(pageStr(i:length(pageStr)),'" '))-2+i;
    eid(n,1)={pageStr(i(1):i(end))};
  end
  
  %% read keywords
  i=min(strfind(pageStr,'Keywords '));
  if isempty(i)
    conference(n,1)={[]};
  else
    i=min(strfind(pageStr(i:end),'</h5>'))+4+i;
    i(2)=min(strfind(pageStr(i:length(pageStr)),'<span'))-2+i;
    keywords(n,1)={pageStr(i(1):i(2))};
  end
  
  %% read visits
  i=min(strfind(pageStr,'Visits for this pub'));
  if isempty(i)
    visits(n,1)={[]};
  else
    i=min(strfind(pageStr(i:end),'Total: '))+6+i;
    i(2)=min(strfind(pageStr(i:length(pageStr)),' '))-2+i;
    visits(n,1)={pageStr(i(1):i(2))};
  end
  
  
  %% read conference
  i=min(strfind(pageStr,'conference_title" content="'))+27;
  if isempty(i)
    conference(n,1)={[]};
  else
    i(2)=min(strfind(pageStr(i:length(pageStr)),'">'))-2+i;
    conference(n,1)={pageStr(i(1):i(2))};
  end

end
data.isi=isi;
data.eid=eid;
data.keywords=keywords;
data.visits=visits;
data.conference=conference;

