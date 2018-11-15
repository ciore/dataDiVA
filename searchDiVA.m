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

%extra search inputs
searchType='SIMPLE';
noOfRows='10000';
% af='["publicationTypeCode:article"]';

%convert string to cell
if isstr(searchQuery)
  searchQuery={searchQuery};
end

%search
data=[];
for s=1:length(searchQuery)
  
  %----------------------
  %search
  fullURL=['http://kth.diva-portal.org/smash/resultList.jsf?query=',searchQuery{s},'&searchType=',searchType,'&noOfRows=',noOfRows];
  pageStr=webread(fullURL);
  
  %----------------------
  %find number of entries
  i=min(strfind(pageStr,'current paginInformation">')+26);
  i(2)=min(find(double(pageStr(i:end))==10))-2+i;
  str=pageStr(i(1):i(end));
  nEntries=str2num(str(strfind(str,' - ')+3:strfind(str,' of ')));
  
  %----------------------
  %collect info entries
  title={};
  year={};
  in={};
  volume={};
  number={};
  pages={};
  type={};
  authors={};
  affiliations={};
  pid={};
  doi={};
  for n=1:nEntries
    i=strfind(pageStr,['resultList:',num2str(n-1),':']);
    i(end+1)=min(find(double(pageStr(i(end):end))==10))-2+i(end);
    str=pageStr(i(1):i(end));
    
    %----------------------
    %collect title info
    i=strfind(str,'titleLink singleRow linkcolor">')+31;
    i(2)=min(strfind(str(i:length(str)),'</a>'))-2+i;
    title(n,1)={str(i(1):i(end))};
    i=min(strfind(str(i(end):length(str)),'singleRow">'))+10+i(end);
    if double(str(i))==60
      year(n,1)={[]};
    else
      year(n,1)={str(i:i+3)};
    end
        
    %----------------------
    %collect publication info
    i=strfind(str,'italicLabel">In: </span>')+24;
    if isempty(i)
      volume(n,1)={[]};
      number(n,1)={[]};
      pages(n,1)={[]};
      in(n,1)={[]};
    else
      i(2)=min(strfind(str(i:length(str)),'</span>'))-2+i;
      instr=str(i(1)+min(find(double(str(i(1):i(end)))~=32))-1:i(end));
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
      if isempty(instr)
        in(n,1)={[]};
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
        in(n,1)={instr};
      end
    end
    %type
    i=strfind(str,'noAbstract" class="singleRow">')+30;
    i(2)=min(strfind(str(i:length(str)),'</span>'))-2+i;
    type(n,1)={str(i(1):i(end))};
    
    %----------------------
    %collect authors info
    i=min(strfind(str,'toggleOrganisation">'))+20;
    if str(i:i+5)=='<input'
      i=min(strfind(str,'<span class="ui-button-text ui-c">'))+34;
    end
    if isempty(i)
      authors(n,1)={[]};
    else
      i(2)=min(strfind(str(i:length(str)),'</span>'))-3+i;
      authors(n,1)={str(i(1):i(end))};
      i=min(strfind(str(i(end):length(str)),'<div class="singleRow">'))+22+i(end);
      if isempty(i)
        affiliations(n,1)={[]};
      else
        i(2)=min(find(double(str(i(end):length(str)))==10))-2+i(end);
        affiliations(n,1)={str(i(1):i(end))};
      end
    end
    iauthor=strfind(str,'author">')+8;
    if isempty(iauthor)
      authors(n,2)={[]};
      affiliations(n,2)={[]};
    else
      na=length(iauthor);
      for ia=1:na
        i=iauthor(ia);
        i(2)=min(find(double(str(i:end))==10))-2+i;
        authors(n,ia+1)={str(i(1):i(end))};
        i=min(strfind(str(i(end):length(str)),'singleRow indent">'))+17+i(end);
        if double(str(i))==60
          affiliations(n,ia+1)={[]};
        else
          i(2)=min(strfind(str(i:length(str)),'</span>'))-2+i;
          affiliations(n,ia+1)={str(i(1):i(end))};
        end
      end
    end
  
    %----------------------
    %collect pid info
    i=strfind(str,'pid=')+4;
    if isempty(i)
      pid(n,1)={[]};
    else
      i(2)=min(strfind(str(i:length(str)),'&'))-2+i;
      pid(n,1)={str(i(1):i(end))};
    end
    
    %----------------------
    %collect DOI info
    i=strfind(str,'http://dx.doi.org/')+18;
    if isempty(i)
      doi(n,1)={[]};
    else
      i(2)=min(strfind(str(i:length(str)),'"'))-2+i;
      doi(n,1)={str(i(1):i(end))};
    end
    
  end
  
  %----------------------
  %assemble data
  data=[data,struct('title',{title},'year',{year},'in',{in},'volume',{volume},'number',{number},'pages',{pages},'type',{type},'authors',{authors},'affiliations',{affiliations},'pid',{pid},'doi',{doi})];
  
end

%----------------------
%concatenate search data
fnames=fieldnames(data);
for i=2:numel(searchQuery)
  for f=1:numel(fnames)
    eval(['data(1).',fnames{f},'((1:size(data(i).',fnames{f},',1))+size(data(1).',fnames{f},',1),1:size(data(i).',fnames{f},',2))=data(i).',fnames{f},';']);
  end
end
data=data(1);
 
%----------------------
%remove duplicates
[~,i]=unique(data.pid);
data=subsetData(data,i);

%----------------------
%remove empty author, e.g. proceeding editor
i=find(not(cellfun('isempty',data.authors(:,1))));
data=subsetData(data,i);

%----------------------
%remove preprints
i=intersect(find(cellfun('isempty',strfind(data.type,'preprint'))),find(not(cellfun('isempty',data.year))));
data=subsetData(data,i);

%----------------------
%sort by year
[~,i]=sort(str2num(cell2mat(data.year)),1,'descend');
data=subsetData(data,i);
