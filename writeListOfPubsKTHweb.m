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

function writeListOfPubsKTHweb(data,ofile)

%sort by year
[~,i]=sort(data.year);
data=subsetData(data,flipud(i));

% create .txt file
fid=fopen(ofile,'w','n','utf-8');
count=1;

%----------------------
%Articles
space=[3 1 0 0];
dataType=subsetData(data,'type','Article');
fprintf(fid, '%-s\n',['<h2>Papers</h2><h3>Journal articles</h3><hr>']);
for i=1:length(dataType.title)
  fprintf(fid, '%-s\n',['<p class=MsoNormal style=''margin-top:0cm;margin-bottom:10.0pt;margin-right:0cm;margin-left:36.0pt;text-indent:-24.0pt;font-size:10.5pt;font-family:Arial;color:#262626''>']);
  fprintf(fid, '%-s\n',['[',num2str(count),']	<span>',repmat('&nbsp;',1,space(length(num2str(count)))),'</span>']);
  fprintf(fid, '%-s\n',[dataType.authors{i},'. ']);
  fprintf(fid, '%-s\n',['<a href="http://kth.diva-portal.org/smash/record.jsf?dswid=3396&pid=',dataType.pid{i},'">']);
  fprintf(fid, '%-s\n',['<span style=''color:#009fdb''>&quot;',dataType.title{i},',&quot;']);
  fprintf(fid, '%-s\n',['</span>']);
  fprintf(fid, '%-s\n',['</a>']);
  fprintf(fid, '%-s\n',['<i> ',dataType.in{i},', </i> ',dataType.info{i},dataType.year{i},'.']);
  fprintf(fid, '%-s\n',['</p>']);
  fprintf(fid, '%-s\n',['']);
  count=count+1;
end
% fprintf(fid, '%-s\n',['<span>&nbsp;</span>']);

%----------------------
%Conference
dataType=subsetData(data,'type','Conference');
fprintf(fid, '%-s\n',['<h3>Conference papers</h3><hr>']);
for i=1:length(dataType.title)
  fprintf(fid, '%-s\n',['<p class=MsoNormal style=''margin-top:0cm;margin-bottom:10.0pt;margin-right:0cm;margin-left:36.0pt;text-indent:-24.0pt;font-size:10.5pt;font-family:Arial;color:#262626''>']);
  fprintf(fid, '%-s\n',['[',num2str(count),']	<span>',repmat('&nbsp;',1,space(length(num2str(count)))),'</span>']);
  fprintf(fid, '%-s\n',[dataType.authors{i},'. ']);
  fprintf(fid, '%-s\n',['<a href="http://kth.diva-portal.org/smash/record.jsf?dswid=3396&pid=',dataType.pid{i},'">']);
  fprintf(fid, '%-s\n',['<span style=''color:#009fdb''>&quot;',dataType.title{i},',&quot;']);
  fprintf(fid, '%-s\n',['</span>']);
  fprintf(fid, '%-s\n',['</a>']);
  fprintf(fid, '%-s\n',['<i> ',dataType.in{i},'.']);%', </i> ',dataType.info{i},dataType.year{i},
  fprintf(fid, '%-s\n',['</p>']);
  fprintf(fid, '%-s\n',['']);
  count=count+1;
end
fprintf(fid, '%-s\n',['<span>&nbsp;</span>']);

%----------------------
%Doctoral
dataType=subsetData(data,'type','Doctoral');
fprintf(fid, '%-s\n',['<h2>Theses</h2><h3>Doctoral</h3><hr>']);
for i=1:length(dataType.title)
  fprintf(fid, '%-s\n',['<p class=MsoNormal style=''margin-top:0cm;margin-bottom:10.0pt;margin-right:0cm;margin-left:36.0pt;text-indent:-24.0pt;font-size:10.5pt;font-family:Arial;color:#262626''>']);
  fprintf(fid, '%-s\n',['[',num2str(count),']	<span>',repmat('&nbsp;',1,space(length(num2str(count)))),'</span>']);
  fprintf(fid, '%-s\n',[dataType.authors{i},'. ']);
  fprintf(fid, '%-s\n',['<a href="http://kth.diva-portal.org/smash/record.jsf?dswid=3396&pid=',dataType.pid{i},'">']);
  fprintf(fid, '%-s\n',['<span style=''color:#009fdb''>&quot;',dataType.title{i},',&quot;']);
  fprintf(fid, '%-s\n',['</span>']);
  fprintf(fid, '%-s\n',['</a>']);
  fprintf(fid, '%-s\n',['<i> ',dataType.in{i},', </i> ',dataType.info{i},dataType.year{i},'.']);
  fprintf(fid, '%-s\n',['</p>']);
  fprintf(fid, '%-s\n',['']);
  count=count+1;
end
% fprintf(fid, '%-s\n',['<span>&nbsp;</span>']);

%----------------------
%Licentiate
dataType=subsetData(data,'type','Licentiate');
fprintf(fid, '%-s\n',['<h3>Licentiate</h3><hr>']);
for i=1:length(dataType.title)
  fprintf(fid, '%-s\n',['<p class=MsoNormal style=''margin-top:0cm;margin-bottom:10.0pt;margin-right:0cm;margin-left:36.0pt;text-indent:-24.0pt;font-size:10.5pt;font-family:Arial;color:#262626''>']);
  fprintf(fid, '%-s\n',['[',num2str(count),']	<span>',repmat('&nbsp;',1,space(length(num2str(count)))),'</span>']);
  fprintf(fid, '%-s\n',[dataType.authors{i},'. ']);
  fprintf(fid, '%-s\n',['<a href="http://kth.diva-portal.org/smash/record.jsf?dswid=3396&pid=',dataType.pid{i},'">']);
  fprintf(fid, '%-s\n',['<span style=''color:#009fdb''>&quot;',dataType.title{i},',&quot;']);
  fprintf(fid, '%-s\n',['</span>']);
  fprintf(fid, '%-s\n',['</a>']);
  fprintf(fid, '%-s\n',['<i> ',dataType.in{i},', </i> ',dataType.info{i},dataType.year{i},'.']);
  fprintf(fid, '%-s\n',['</p>']);
  fprintf(fid, '%-s\n',['']);
  count=count+1;
end
% fprintf(fid, '%-s\n',['<span>&nbsp;</span>']);

%----------------------
%Student
dataType=subsetData(data,'type','Student');
fprintf(fid, '%-s\n',['<h3>Master</h3><hr>']);
for i=1:length(dataType.title)
  fprintf(fid, '%-s\n',['<p class=MsoNormal style=''margin-top:0cm;margin-bottom:10.0pt;margin-right:0cm;margin-left:36.0pt;text-indent:-24.0pt;font-size:10.5pt;font-family:Arial;color:#262626''>']);
  fprintf(fid, '%-s\n',['[',num2str(count),']	<span>',repmat('&nbsp;',1,space(length(num2str(count)))),'</span>']);
  fprintf(fid, '%-s\n',[dataType.authors{i},'. ']);
  fprintf(fid, '%-s\n',['<a href="http://kth.diva-portal.org/smash/record.jsf?dswid=3396&pid=',dataType.pid{i},'">']);
  fprintf(fid, '%-s\n',['<span style=''color:#009fdb''>&quot;',dataType.title{i},',&quot;']);
  fprintf(fid, '%-s\n',['</span>']);
  fprintf(fid, '%-s\n',['</a>']);
  fprintf(fid, '%-s\n',['<i> ',dataType.in{i},', </i> ',dataType.info{i},dataType.year{i},'.']);
  fprintf(fid, '%-s\n',['</p>']);
  fprintf(fid, '%-s\n',['']);
  count=count+1;
end
fprintf(fid, '%-s\n',['<span>&nbsp;</span>']);

%----------------------
%Reports
dataType=subsetData(data,'type','Report');
fprintf(fid, '%-s\n',['<h2>Reports</h2><hr>']);
for i=1:length(dataType.title)
  fprintf(fid, '%-s\n',['<p class=MsoNormal style=''margin-top:0cm;margin-bottom:10.0pt;margin-right:0cm;margin-left:36.0pt;text-indent:-24.0pt;font-size:10.5pt;font-family:Arial;color:#262626''>']);
  fprintf(fid, '%-s\n',['[',num2str(count),']	<span>',repmat('&nbsp;',1,space(length(num2str(count)))),'</span>']);
  fprintf(fid, '%-s\n',[dataType.authors{i},'. ']);
  fprintf(fid, '%-s\n',['<a href="http://kth.diva-portal.org/smash/record.jsf?dswid=3396&pid=',dataType.pid{i},'">']);
  fprintf(fid, '%-s\n',['<span style=''color:#009fdb''>&quot;',dataType.title{i},',&quot;']);
  fprintf(fid, '%-s\n',['</span>']);
  fprintf(fid, '%-s\n',['</a>']);
  fprintf(fid, '%-s\n',['<i> ',dataType.in{i},', </i> ',dataType.info{i},dataType.year{i},'.']);
  fprintf(fid, '%-s\n',['</p>']);
  fprintf(fid, '%-s\n',['']);
  count=count+1;
end
fprintf(fid, '%-s\n',['<span>&nbsp;</span>']);

fclose(fid);

