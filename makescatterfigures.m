%procedure: run [dtstatic, dtpursuit]= NRGAll, save the tables as .csv then
%run this to make the scatter plots

function makescatterfigures(d)
if nargin<1
    try
        d=readtable('LatencyRegressionCalc.csv');
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
    m=grpstats(d,{'Loc','Dir'},{'mean','sem'});
    ml=m(m.Dir=='L',:);
    ms=m(m.Dir=='S',:);
    mr=m(m.Dir=='R',:);

figure
hold on
c1=[0 0.4470 0.7410];
c2=[0.8500 0.3250 0.0980];
c3=[0.9290 0.6940 0.1250];

s1=scatter(ms.mean_H,ms.mean_E,'filled');
s1.CData=c1;
s2=scatter(ml.mean_H,ml.mean_E,'filled');
s2.CData=c2;
s3=scatter(mr.mean_H,mr.mean_E,'filled');
s3.CData=c3;
hlegend=legend('Fixation','Leftward','Rightward');
hlegend.Location='Northwest';


scattererror(ms.mean_H,ms.mean_E,ms.sem_H,ms.sem_E,c1)
scattererror(ml.mean_H,ml.mean_E,ml.sem_H,ml.sem_E,c2)
scattererror(mr.mean_H,mr.mean_E,mr.sem_H,mr.sem_E,c3)

%plot the grouped means
c={c2, c3, c1};
mm=grpstats(d,{'Dir'},{'mean','sem'});
for i = 1:3
    s=scatter(mm.mean_H(i),mm.mean_E(i),200,'sq');
    s.CData=c{i};
    s.LineWidth=2;
end
% scattererror(mm.mean_H,mm.mean_E,mm.sem_H,mm.sem_E,'k')

%set up axes to be even
y=ylim;
x=xlim;
l=max(y(2),x(2))+5;
ylim([0 l])
xlim([0 l])
%draw line y=x
line([0 l],[0 l])

set(gca,'fontsize',18)
xlabel('Head Latency on Stim')
ylabel('Eye Latency on Stim')

title('Movement Latency After Stimulation')
