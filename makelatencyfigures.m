%procedure: run [dtstatic, dtpursuit]= NRGAll, save the tables as .csv then
%run this to make the scatter plots

function makelatencyfigures
static=readtable('StimStaticLatencies.csv');
pursuit=readtable('StimPursuitLatencies.csv');

figure
hold on
scatter(static.H,static.E,'filled');
y=ylim;
x=xlim;
l=max(y(2),x(2))+5;
ylim([0 l])
xlim([0 l])
set(gca,'fontsize',18)
xlabel('Head Latency on Stim')
ylabel('Eye Latency on Stim')
line([0 l],[0 l])
title('Static Stimulation')

figure
hold on
scatter(pursuit.HL,pursuit.EL,'filled');
scatter(pursuit.HR,pursuit.ER,'filled');
y=ylim;
x=xlim;
l=max(y(2),x(2))+5;
ylim([0 l])
xlim([0 l])
set(gca,'fontsize',18)
xlabel('Head Latency on Stim')
ylabel('Eye Latency on Stim')
line([0 l],[0 l])
title('Mid-Pursuit Stimulation')
legend({'Stim during Leftward','Stim during Rightward'},'location','southeast')