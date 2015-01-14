%procedure: run [dtstatic, dtpursuit]= NRGAll, save the tables as .csv then
%run this to make the scatter plots

function peakvelocitiesfigures(d)
if nargin<1
    try
        d=readtable('LatencyAndVelocityAll.csv');
    catch
        [a b]= uigetfile('*.csv','Locate Data Table');
        try
        d=readtable([b a]);
        catch
            error('Incorrect Data File');
        end
    end
end
    d.Dir=char(d.Dir);
    ds=d(d.Dir=='S',:);
    dl=d(d.Dir=='L',:);
    dr=d(d.Dir=='R',:);
    
    
f=figure;
% f.Units='normalized';
% f.Position=[0.15 0.25 0.75 0.5];
a1=subplot(1,2,1);
hold on
boxplot(ds.H,ds.Loc,'plotstyle','compact','labelorientation','horizontal')
set(gca,'fontsize',18)
xlabel('Location')
ylabel('Velocity (deg/s)')

a2=subplot(1,2,2);
hold on
boxplot(ds.E,ds.Loc,'plotstyle','compact','labelorientation','horizontal')
set(gca,'fontsize',18)
xlabel('Location')
% ylabel('Velocity (deg/s)')

%make y-axes the same
y=[min(a1.YLim(1),a2.YLim(1)) max(a1.YLim(2),a2.YLim(2))];
a1.YLim=y;
a2.YLim=y;
%turn off numbers on right plot
a2.YTickLabel=[];
% x=tightfig;

% x=tightfig;

