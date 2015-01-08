

function [dtstatic, dtpursuit]= NRGAll

[filenames filepath]=uigetfile({'*.mat'},'Select Files to Analyze',...
    'multiselect','on');

if ~iscell(filenames)
    filenames=filenames{1};
end

if filenames{1}==0
    return
end
x=filenames;


    vnamesPursuit={'Loc','n','HL','HR','EL','ER'};
    vnamesStatic={'Loc','n','H','E'};
    %dt=table([],[],[],[],[],'variablenames',vnames);
    dtpursuit=table;
    dtstatic=table;
    
    
for f =1:length(x)
    filename=x{f};
    try
        if ~strcmp(filename(end-3:end),'.mat')
            continue %don't try to load anything that isnt a mat
        end
    catch
        continue;
    end
    b=load([filepath,'\\', filename]);
    s=b.s;
    g=b.g;
    gap=b.gap;
    tlength=1951;
    [head, eye, gaze]=headeyegazeMatrix(g,s,tlength);
    o=findstarttime(head,eye);
    pursuit={filename(1:end-4),size(head.hpstim,2),o.left.headstart-550,o.right.headstart-550,o.left.eyestart-550,o.right.eyestart-550};
    dtpursuit(f,:)=pursuit;
    
    [head, eye]=headeyeStatic(gap,300);
    o=findstarttimeStatic(head,eye);
    static={filename(1:end-4),size(head.hastim,2),o.headstart-50,o.eyestart-50};
    dtstatic(f,:)=static;
end
try
dtpursuit.Properties.VariableNames=vnamesPursuit;
dtstatic.Properties.VariableNames=vnamesStatic;
end

