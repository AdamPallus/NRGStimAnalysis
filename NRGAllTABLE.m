%This is a rewrite of the NRGAll function. This version of the function is
%intended to return the results as a vertical table where each row is a
%single trial. We can then use grpstats to evaluate metrics about each
%stimulus location.

%We will write this function to use the 2x standard deviation method to
%determine latency. We will need to rewrite the regression-latency-function
%to return the individual trial data to use in this analysis.

%This function returns two tables: dtstatic, containing the latencies for
%the trials in gap, and dtpursuit, containing the latencies for s. g is not
%currently used in this analysis. Note that dtpursuit separates leftward
%and rightward movements, while dtstatic contains only one column for head
%and eye since no movement is occuring during stimulation.

function [d c]= NRGAllTABLE

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

dtpursuit=table;
dtstatic=table;


%Begin looping throgh the filenames, loading each one, performing the
%analyses and adding to the tables.
    tlengthP=1951; 
    tlengthS=300;
for f =1:length(filenames)
    filename=filenames{f};
    b=load([filepath, filename]);
    s=b.s;
    g=b.g;
    gap=b.gap;
    
    [head, eye, gaze]=headeyegazeMatrix(g,s,tlengthP); %convert cell2matrix
    %this function is the one that actually performs the analysis
    t=findstarttimeTABLE(head,eye);
    
    %set up data row
    t.Loc=repmat(f,[height(t),1]);
   
    %add to table
    dtpursuit=vertcat(dtpursuit,t);
    
    %control trials
    rightward=gaze.gpgap(1000,:)>0;
    hcontrolR(f)=mean(head.hvgap(650,rightward));
    econtrolR(f)=mean(eye.evgap(650,rightward));
    hcontrolL(f)=mean(head.hvgap(650,~rightward));
    econtrolL(f)=mean(eye.evgap(650,~rightward));
    location(f)=f;
    
    %repeat above for static trials
    [head, eye]=headeyeStatic(gap,tlengthS);
    t=findstarttimeTABLE(head,eye);
    t.Loc=repmat(f,[height(t),1]);
    dtstatic=vertcat(dtstatic,t);
    
end
d=vertcat(dtpursuit,dtstatic);
c=table(location',hcontrolR',econtrolR',hcontrolL',econtrolL','variablenames',{'Loc','HcR','EcR','HcL','EcL'});
d.cVel=nan(height(d),1);
d.cVel(d.Dir=='R'&d.Type=='H')=c.HcR(d.Loc(d.Dir=='R'&d.Type=='H'));
d.cVel(d.Dir=='R'&d.Type=='E')=c.EcR(d.Loc(d.Dir=='R'&d.Type=='H'));
d.cVel(d.Dir=='L'&d.Type=='H')=c.HcL(d.Loc(d.Dir=='L'&d.Type=='H'));
d.cVel(d.Dir=='L'&d.Type=='E')=c.EcL(d.Loc(d.Dir=='L'&d.Type=='E'));