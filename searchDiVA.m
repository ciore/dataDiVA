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

function data=searchDiVA(searchQuery)

%check input
if numel(searchQuery)~=1
  error('Number of elements in searchQuery must be equal to 1.')
end

%extra search inputs
searchType='SIMPLE';
noOfRows='10000';
% af='["publicationTypeCode:article"]';

%convert string to cell
if isstr(searchQuery)
  searchQuery={searchQuery};
end

%% search
fullURL=['http://kth.diva-portal.org/smash/resultList.jsf?query=',searchQuery{:},'&searchType=',searchType,'&noOfRows=',noOfRows];
pageStr=webread(fullURL);

%% find number of entries
i=min(strfind(pageStr,'current paginInformation">')+26);
i(2)=min(find(double(pageStr(i:end))==10))-2+i;
str=pageStr(i(1):i(end));
nEntries=str2num(str(strfind(str,' - ')+3:strfind(str,' of ')));

data=initData(0);
for n=1:nEntries
  i=min(strfind(pageStr,['resultList:',num2str(n-1),':']));
  i=max(strfind(pageStr(1:i),'<li '));
  i(2)=min(strfind(pageStr(i:end),'</li>'))+i+3;
  str=pageStr(i(1):i(2));
  
  %% collect pid
  i=strfind(str,'pid=')+4;
  i(2)=min(strfind(str(i:length(str)),'&'))-2+i;
  data.pid(n,1)={str(i(1):i(end))};
  
  %% collect DOI
  i=strfind(str,'doi.org/')+8;
  if isempty(i)
    data.doi(n,1)={[]};
  else
    i(2)=min(strfind(str(i:length(str)),'"'))-2+i;
    data.doi(n,1)={str(i(1):i(end))};
  end
  
  %% collect title and year
  i=strfind(str,'titleLink singleRow linkcolor">')+31;
  i(2)=min(strfind(str(i:length(str)),'</a>'))-2+i;
  data.title(n,1)={str(i(1):i(end))};
  i=min(strfind(str(i(end):length(str)),'singleRow">'))+10+i(end);
  if double(str(i))==60
    data.year(n,1)={[]};
  else
    data.year(n,1)={str(i:i+3)};
  end
  
  %% collect type
  i=strfind(str,'noAbstract" class="singleRow">')+30;
  i(2)=min(strfind(str(i:length(str)),'</span>'))-2+i;
  data.type(n,1)={str(i(1):i(end))};
  
  %% collect authors
  i=min(strfind(str,'toggleOrganisation">'))+20;
  if str(i:i+5)=='<input'
    i=min(strfind(str,'<span class="ui-button-text ui-c">'))+34;
  end
  if isempty(i)
    data.authors(n,1)={[]};
  else
    i(2)=min(strfind(str(i:length(str)),'</span>'))-3+i;
    data.authors(n,1)={str(i(1):i(end))};
    i=min(strfind(str(i(end):length(str)),'<div class="singleRow">'))+22+i(end);
    if isempty(i)
      data.affiliations(n,1)={[]};
    else
      i(2)=min(find(double(str(i(end):length(str)))==10))-2+i(end);
      data.affiliations(n,1)={str(i(1):i(end))};
    end
  end
  i=strfind(str,'etAlPanel_content');
  if ~isempty(i)
    i(2)=min(strfind(str(i:end),' />'))+i;
    authorstr=str(i(1):i(2));
    iauthor=[strfind(authorstr,'<div class="singleRow author">')+30 strfind(authorstr,'<span class="singleRow">')+24];
    for ia=1:numel(iauthor)
      i=iauthor(ia);
      i(2)=min([min(find(double(authorstr(i:end))==10))-2+i min(strfind(authorstr(i:end),'</'))-2+i]);
      data.authors(n,ia+1)={authorstr(i(1):i(end))};
      i=min(strfind(authorstr(i(end):end),'singleRow indent">'))+17+i(end);
      if double(authorstr(i))==60
        data.affiliations(n,ia+1)={[]};
      else
        i(2)=min(strfind(authorstr(i:end),'</span>'))-2+i;
        data.affiliations(n,ia+1)={authorstr(i(1):i(2))};
      end
    end
  end
  
  %% collect pubished in
  i=strfind(str,'italicLabel">In: </span>')+24;
  if isempty(i)
    data.volume(n,1)={[]};
    data.number(n,1)={[]};
    data.pages(n,1)={[]};
    data.in(n,1)={[]};
  else
    i(2)=min(strfind(str(i:length(str)),'</span>'))-2+i;
    instr=str(i(1)+min(find(double(str(i(1):i(end)))~=32))-1:i(end));
    i=find(double(instr)==32);
    instr=instr(setdiff(1:end,i(find(i(2:end)-i(1:end-1)==1))));
    if ~isempty(instr)
      if ~strcmp(instr(end-1:end),', ')
        instr=[instr,', '];
      end
    end
    %e-issn
    i=min(strfind(instr,'E-ISSN '))+7;
    if ~isempty(i)
      i(2)=min([length(instr) min(strfind(instr(i:length(instr)),', '))-2+i]);
      eissn=instr(i(1):i(2));
      instr=instr(setdiff(1:length(instr),i(1)-7:i(2)+2));
    end
    %e issn
    i=min(strfind(instr,'E ISSN '))+7;
    if ~isempty(i)
      i(2)=min([length(instr) min(strfind(instr(i:length(instr)),', '))-2+i]);
      eissn=instr(i(1):i(2));
      instr=instr(setdiff(1:length(instr),i(1)-7:i(2)+2));
    end
    %issn
    i=min(strfind(instr,'ISSN '))+5;
    if ~isempty(i)
      i(2)=min([length(instr) min(strfind(instr(i:length(instr)),', '))-2+i]);
      issn=instr(i(1):i(2));
      instr=instr(setdiff(1:length(instr),i(1)-5:i(2)+2));
    end
    %issn duplicate
    i=min(strfind(instr,'ISSN '))+5;
    if ~isempty(i)
      i(2)=min([length(instr) min(strfind(instr(i:length(instr)),', '))-2+i]);
      issn=instr(i(1):i(2));
      instr=instr(setdiff(1:length(instr),i(1)-5:i(2)+2));
    end
    %volume
    i=strfind(instr,'Vol.')+5;
    if isempty(i)
      data.volume(n,1)={[]};
    else
      i(2)=min([length(instr) min(strfind(instr(i:length(instr)),', '))-2+i]);
      data.volume(n,1)={instr(i(1):i(2))};
      instr=instr(setdiff(1:length(instr),i(1)-5:i(2)+2));
    end
    %number
    i=strfind(instr,' no ')+4;
    if isempty(i)
      data.number(n,1)={[]};
    else
      i(2)=min([length(instr) min(strfind(instr(i:length(instr)),', '))-2+i]);
      data.number(n,1)={instr(i(1):i(2))};
      instr=instr(setdiff(1:length(instr),i(1)-3:i(2)+2));
    end
    %pages
    i=strfind(instr,' p. ')+4;
    if isempty(i)
      data.pages(n,1)={[]};
    else
      i(2)=min([length(instr) min(strfind(instr(i:length(instr)),', '))-2+i]);
      data.pages(n,1)={instr(i(1):i(2))};
      instr=instr(setdiff(1:length(instr),i(1)-3:i(2)+2));
    end
    %in
    if isempty(instr)
      data.in(n,1)={[]};
    else
      if double(instr(end))==32
        instr=instr(1:end-1);
      end
      if double(instr(end))==double(',')
        instr=instr(1:end-1);
      end
      if numel(strfind(instr,'<'))>0
        instr=instr(1:strfind(instr,'<')-1);
      end
      data.in(n,1)={instr};
    end
  end
  
end

%% remove entries with no year (not published)
i=find(not(cellfun('isempty',data.year)));
data=subsetData(data,i);

%% remove duplicates
[~,i]=unique(data.pid);
data=subsetData(data,i);

%% sort by year
[~,i]=sort(str2num(cell2mat(data.year)),1,'descend');
data=subsetData(data,i);
