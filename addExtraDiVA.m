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

function pubs=addExtraDiVA(pubs)

conference=cell(length(pubs.pid),1);
in=cell(length(pubs.pid),1);
volume=cell(length(pubs.pid),1);
number=cell(length(pubs.pid),1);
pages=cell(length(pubs.pid),1);
isi=cell(length(pubs.pid),1);
scopus=cell(length(pubs.pid),1);
for n=1:length(pubs.pid)
  
  %----------------------
  %search record for more info
  fullURL=['http://kth.diva-portal.org/smash/record.jsf?dswid=2747&pid=',pubs.pid{n,1}];
  str=urlread(fullURL);
  
  %read conference
  i=min(strfind(str,'conference_title" content="'))+27;
  if isempty(i)
    conference(n,1)={[]};
  else
    i(2)=min(strfind(str(i:length(str)),'">'))-2+i;
    conference(n,1)={str(i(1):i(2))};
  end
  
  %add info
  i=min(strfind(str,'Place, publisher, year, edition, pages</h5>'))+43;
  if ~isempty(i)
    i(2)=min(strfind(str(i:length(str)),'<'))-2+i;
    instr=str(i(1):i(2));
    %year
    i=max([1 min(strfind(instr,pubs.year{n}))-2]);
    i(2)=min([length(instr) i+5]);
    instr=instr(setdiff(1:length(instr),i(1):i(2)));
    %e-issn
    i=min(strfind(instr,'E-ISSN '))+7;
    if ~isempty(i)
      i(2)=min([length(instr) min(strfind(instr(i:length(instr)),', '))-2+i]);
      eissn=instr(i(1):i(2));
      instr=instr(setdiff(1:length(instr),i(1)-8:i(2)+1));
    end
    %e issn
    i=min(strfind(instr,'E ISSN '))+7;
    if ~isempty(i)
      i(2)=min([length(instr) min(strfind(instr(i:length(instr)),', '))-2+i]);
      eissn=instr(i(1):i(2));
      instr=instr(setdiff(1:length(instr),i(1)-8:i(2)+1));
    end
    %issn
    i=min(strfind(instr,'ISSN '))+5;
    if ~isempty(i)
      i(2)=min([length(instr) min(strfind(instr(i:length(instr)),', '))-2+i]);
      issn=instr(i(1):i(2));
      instr=instr(setdiff(1:length(instr),i(1)-6:i(2)+1));
    end
    %issn duplicate
    i=min(strfind(instr,'ISSN '))+5;
    if ~isempty(i)
      i(2)=min([length(instr) min(strfind(instr(i:length(instr)),', '))-2+i]);
      issn=instr(i(1):i(2));
      instr=instr(setdiff(1:length(instr),i(1)-6:i(2)+1));
    end
    %volume
    i=strfind(instr,'Vol.')+5;
    if isempty(i)
      volume(n,1)={[]};
    else
      i(2)=min([min(strfind(instr(i:end),','))-2+i length(instr)]);
      volume(n,1)={instr(i(1):i(2))};
      instr=instr(setdiff(1:length(instr),i(1)-6:i(2)+1));
    end
    %number
    i=strfind(instr,' no ')+4;
    if isempty(i)
      number(n,1)={[]};
    else
      i(2)=min([min(strfind(instr(i:end),','))-2+i length(instr)]);
      number(n,1)={instr(i(1):i(2))};
      instr=instr(setdiff(1:length(instr),i(1)-4:i(2)+1));
    end
    %pages
    i=strfind(instr,' p.')-1;
    if isempty(i)
      pages(n,1)={[]};
    else
      i(2)=max([1 max(strfind(instr(1:i),' '))+1]);
      pages(n,1)={instr(i(2):i(1))};
      instr=instr(setdiff(1:length(instr),i(2)-1:i(1)+3));
    end
    %in
    i=strfind(instr,'.')-1;
    instr=instr(1:i);
    if isempty(instr)
      instr=[];
    else
      if double(instr(end))==32
        instr=instr(1:end-1);
      end
      i=strfind(instr,':');
      if ~isempty(i)
        instr=[instr(i+2:end),', ',instr(1:i-1)];
      end
    end
    in(n,1)={instr};
  end
  
  %read ISI
  i=min(strfind(str,'ISI: '))+5;
  if isempty(i)
    isi(n,1)={[]};
  else
    i=min(strfind(str(i:length(str)),'UT='))+2+i;
    i(2)=min(strfind(str(i:length(str)),'" '))-2+i;
    isi(n,1)={str(i(1):i(end))};
  end
  
  %read scopus
  i=min(strfind(str,'ScopusID: '))+10;
  if isempty(i)
    scopus(n,1)={[]};
  else
    i=min(strfind(str(i:length(str)),'eid='))+3+i;
    i(2)=min(strfind(str(i:length(str)),'" '))-2+i;
    scopus(n,1)={str(i(1):i(end))};
  end
  
end
pubs.in(not(cellfun('isempty',conference)))=conference(not(cellfun('isempty',conference)));
pubs.in(cellfun('isempty',pubs.in))=in(cellfun('isempty',pubs.in));
pubs.isi=isi;
pubs.scopus=scopus;
