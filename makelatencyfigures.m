%procedure: run [dtstatic, dtpursuit]= NRGAll, save the tables as .csv then
%run this to make the scatter plots

function makelatencyfigures
static=readtable('StimStaticLatencies.csv');
pursuit=readtable('StimPursuitLatencies.csv');

lx=static.H-static.Hstd;
ux=static.H+static.Hstd;
ly=static.E-static.Estd;
uy=static.E+static.Estd;


figure
hold on
c1=[0 0.4470 0.7410];
c2=[0.8500 0.3250 0.0980];

scatter(static.H,static.E,'filled');
y=ylim;
x=xlim;
l=max(y(2),x(2))+5;
for k =1:height(static)
    l1=line([lx(k) ux(k)],[static.E(k) static.E(k)]);
    l1.Color=c1;
    l4=line([static.H(k) static.H(k)],[ly(k) uy(k)]);
    l4.Color=c1;
end
ylim([0 l])
xlim([0 l])
set(gca,'fontsize',18)
xlabel('Head Latency on Stim')
ylabel('Eye Latency on Stim')
line([0 l],[0 l])
title('Static Stimulation')

figure
hold on
lxL=pursuit.HL-pursuit.HLstd;
uxL=pursuit.HL+pursuit.HLstd;
lyL=pursuit.EL-pursuit.ELstd;
uyL=pursuit.EL+pursuit.ELstd;

lxR=pursuit.HR-pursuit.HRstd;
uxR=pursuit.HR+pursuit.HRstd;
lyR=pursuit.ER-pursuit.ERstd;
uyR=pursuit.ER+pursuit.ERstd;

scatter(pursuit.HL,pursuit.EL,'filled');
scatter(pursuit.HR,pursuit.ER,'filled');
legend({'Stim during Leftward','Stim during Rightward'},'location','southeast')
y=ylim;
x=xlim;
for k =1:height(pursuit)
    l1=line([lxL(k) uxL(k)],[pursuit.EL(k) pursuit.EL(k)]);
    l1.Color=c1;
    l4=line([pursuit.HL(k) pursuit.HL(k)],[lyL(k) uyL(k)]);
    l4.Color=c1;
    
    l1=line([lxR(k) uxR(k)],[pursuit.ER(k) pursuit.ER(k)]);
    l1.Color=c2;
    l4=line([pursuit.HR(k) pursuit.HR(k)],[lyR(k) uyR(k)]);
    l4.Color=c2;
end

l=max(y(2),x(2))+5;
ylim([0 l])
xlim([0 l])
set(gca,'fontsize',18)
xlabel('Head Latency on Stim')
ylabel('Eye Latency on Stim')
line([0 l],[0 l])
title('Mid-Pursuit Stimulation')