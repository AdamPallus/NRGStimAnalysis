

function [dtgap, dtpursuit]= NRGAll

try
    cd 'C:\Users\adam2\Documents\MATLAB\NRG stim workspaces'
end
x=dir;
x=x(~[x.isdir]);


    vnames={'Loc','n','HL','HR','EL','ER'};
    %dt=table([],[],[],[],[],'variablenames',vnames);
    dt=table;
    
    
for f =1:length(x)
    filename=x(f).name;
    try
        if ~strcmp(filename(end-3:end),'.mat')
            continue %don't try to load anything that isnt a mat
        end
    catch
        continue;
    end
    b=load(filename);
    s=b.s;
    g=b.g;
    tlength=1951;
    [head, eye, gaze]=headeyegazeMatrix(g,s,tlength);
    o=findstarttime(head,eye);
    xxx={filename(10:end-4),size(head.hpstim,2),o.left.headstart,o.left.eyestart,o.right.headstart,o.right.eyestart};
    dt(f,:)=xxx;
end
try
dt.Properties.VariableNames=vnames;
end

