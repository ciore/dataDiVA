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

function data=formatData(data)

for i=1:length(data.title)
  
  %----------------------
  %authors
  na=length(find(not(cellfun('isempty',data.authors(i,:)))));
  authors=[];
  for j=1:na
    name=data.authors{i,j};
    firstname=name(strfind(name,',')+1:end);
    firstname=firstname(strfind(firstname,' ')+1);
    firstname=reshape([firstname;repmat('.',1,length(firstname));repmat(' ',1,length(firstname))],1,length(firstname)*3);
    lastname=name(1:strfind(name,',')-1);
    if j==1
      authors=[authors,firstname,lastname];
    elseif j==na
      authors=[authors,' and ',firstname,lastname];
    else
      authors=[authors,', ',firstname,lastname];
    end
  end
  rchar=find(double(authors)>127);
  for ir=1:length(rchar)
    plus=length(num2str(double(authors(rchar(ir)))))+2;
    authors=[authors(1:rchar(ir)-1),'&#',num2str(double(authors(rchar(ir)))),';',authors(rchar(ir)+1:end)];
    rchar=rchar+plus;
  end
  
  %----------------------
  %title
  title=data.title{i};
  rchar=find(double(title)==58);
  for ir=1:length(rchar)
    plus=length(num2str(double(title(rchar(ir)))))+2;
    title=[title(1:rchar(ir)-1),'&#',num2str(double(title(rchar(ir)))),';',title(rchar(ir)+1:end)];
    rchar=rchar+plus;
  end
  rchar=find(double(title)>127);
  for ir=1:length(rchar)
    plus=length(num2str(double(title(rchar(ir)))))+2;
    title=[title(1:rchar(ir)-1),'&#',num2str(double(title(rchar(ir)))),';',title(rchar(ir)+1:end)];
    rchar=rchar+plus;
  end
  
    %----------------------
    %in
    in=data.in{i};
    rchar=find(double(in)>127);
    for ir=1:length(rchar)
      plus=length(num2str(double(in(rchar(ir)))))+2;
      in=[in(1:rchar(ir)-1),'&#',num2str(double(in(rchar(ir)))),';',in(rchar(ir)+1:end)];
      rchar=rchar+plus;
    end
  
    %----------------------
    %pubinfo
    if isempty(data.volume{i})
      volume='';
    else
      volume=['vol. ',data.volume{i},', '];
    end
    if isempty(data.number{i})
      number='';
    else
      number=['no. ',data.number{i},', '];
    end
    if isempty(data.pages{i})
      pages='';
    else
      pages=['pp. ',data.pages{i},', '];
    end
    info=[volume,number,pages];

    data.title(i)={title};
    data.in(i,1)={in};
    data.info(i,1)={info};
    data.authors(i,1)={authors};
    
end
data.authors=data.authors(:,1);
data=rmfield(data,'volume');
data=rmfield(data,'number');
data=rmfield(data,'pages');
data=rmfield(data,'affiliations');