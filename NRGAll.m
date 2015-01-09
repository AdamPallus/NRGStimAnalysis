%This function reads multiple .mat files containing data tables from the
%stimulation experiment. gap contains the trials from stimulation during
%a gap in fixation. s contains trials where stimulation occurs during a gap
%in pursuit and g are control trials, which are exactly the same as those
%in s, except no stimulation occurs. By 'a gap,' I mean that the visual
%target is briefly turned off, then 50ms later, stimulation begins. After
%stimulation, the target is turned back on 150-300ms later.

%This function returns two tables: dtstatic, containing the latencies for
%the trials in gap, and dtpursuit, containing the latencies for s. g is not
%currently used in this analysis. Note that dtpursuit separates leftward
%and rightward movements, while dtstatic contains only one column for head
%and eye since no movement is occuring during stimulation.

function [dtstatic, dtpursuit]= NRGAll

[filenames, filepath]=uigetfile({'data\*.mat'},'Select Files to Analyze',...
    'multiselect','on');

%if there is only one file selected, it will be a character array. Convert
%this to a cell array so we don't have to keep checking.
if ~iscell(filenames)
    filenames=filenames{1};
end
%if the user did not select anything (hit cancel), just exit the function
%with no further messaging.
if filenames{1}==0
    return
end
%set up the variable names for the tables, and initialize the tables
vnamesPursuit={'Loc','n','HL','HR','EL','ER','HLstd','HRstd','ELstd','ERstd'};
vnamesStatic={'Loc','n','H','E','Hstd','Estd'};
dtpursuit=table;
dtstatic=table;

%Begin looping throgh the filenames, loading each one, performing the
%analyses and adding to the tables.

for f =1:length(filenames)
    filename=filenames{f};
    b=load([filepath, filename]);
    s=b.s;
    g=b.g;
    gap=b.gap;
    
    tlength=1951; %Only look at trials that are this long (in ms)
    stimstart=550; %time of stimulation onset 
    [head, eye, ~]=headeyegazeMatrix(g,s,tlength); %convert cell2matrix
    %this function is the one that actually performs the analysis
    o=findstarttime(head,eye);
    %set up data row
    p=[o.left.headstart,o.right.headstart,o.left.eyestart,o.right.eyestart];
    p=p-stimstart;
    p=[p o.left.headstartSTD,o.right.headstartSTD,o.left.eyestartSTD,o.right.eyestartSTD];
    n=size(head.hpstim,2);
    
    pursuit=[{filename(1:end-4)},{n},num2cell(p)];
    %add to table
    dtpursuit(f,:)=pursuit;
    
    %repeat above for static trials
    tlength=300;
    stimstart=50;
    [head, eye]=headeyeStatic(gap,tlength);
    o=findstarttime(head,eye);
    static={filename(1:end-4),size(head.hastim,2),o.headstart-stimstart,...
        o.eyestart-stimstart,o.headstartSTD,o.eyestartSTD};
    dtstatic(f,:)=static;
end

%add the variable names to the table. Catch block is here so that if there
%is an error, at least the data tables are returned and the proceedure does
%not need to be rerun
try
    dtpursuit.Properties.VariableNames=vnamesPursuit;
    dtstatic.Properties.VariableNames=vnamesStatic;
catch
    warning('Couldn''t rename columns')
    display(vnamesPursuit)
    display(vnamesStatic)
end

