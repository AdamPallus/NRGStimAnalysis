%This function interacts with the data tables stored in dated .mat files
%corresponding with the NRG microstimulation experiment carried out by Adam
%Pallus working in the laboratory of Ed Freedman.

%The function generates plots for exploratory analysis and publication

function browseStim
[filename, filepath]=uigetfile({'data/*.mat'},'Select File to Analyze',...
    'multiselect','off');
if filename==0
    return
end
b=load([filepath filename]);

s=recalculatevels(b.s);
g=recalculatevels(b.g);
gap=recalculatevels(b.gap);

%stimulation and gap periods
gap_start=500;
post_stim_dur=300;
pre_stim_dur=50;
stim_dur=100;
gap_dur=pre_stim_dur+post_stim_dur+stim_dur;
stim_start=gap_start+pre_stim_dur;
gapend=gap_start+gap_dur+stim_dur+post_stim_dur;

%box y positioning
ymin=-10000;
ymax=10000;
boxheight=ymax-ymin;

box.gap=[gap_start ymin gap_dur boxheight];
box.stim=[stim_start ymin stim_dur boxheight];

triallength=1951;
[d.head,d.eye,d.gaze]=headeyegazeMatrix(g,s,triallength);
d.box=box;


f=figure;
whichplots=ones(3);
%all
b1=uicontrol(f,'string','Plot All','units','normalized',...
    'position',[0.2 0.2 0.1 0.1],...
    'callback',{@plotAll,d,f.Number});
%head
hp=uicontrol(f,'string','Plot HP','units','normalized',...
    'position',[0.1 0.3 0.1 0.1],...
    'callback',{@plotMeanHEG, d,[1 0 0 0 0 0 0 0 0]});
hv=uicontrol(f,'string','Plot HV','units','normalized',...
    'position',[0.2 0.3 0.1 0.1],...
    'callback',{@plotMeanHEG, d,[0 0 0 1 0 0 0 0 0]});
ha=uicontrol(f,'string','Plot HA','units','normalized',...
    'position',[0.3 0.3 0.1 0.1],...
    'callback',{@plotMeanHEG, d,[0 0 0 0 0 0 1 0 0]});
%eye
ep=uicontrol(f,'string','Plot EP','units','normalized',...
    'position',[0.1 0.4 0.1 0.1],...
    'callback',{@plotMeanHEG, d,[0 1 0 0 0 0 0 0 0]});
ev=uicontrol(f,'string','Plot EV','units','normalized',...
    'position',[0.2 0.4 0.1 0.1],...
    'callback',{@plotMeanHEG, d,[0 0 0 0 1 0 0 0 0]});
ea=uicontrol(f,'string','Plot EA','units','normalized',...
    'position',[0.3 0.4 0.1 0.1],...
    'callback',{@plotMeanHEG, d,[0 0 0 0 0 0 0 1 0]});
%gaze
gp=uicontrol(f,'string','Plot GP','units','normalized',...
    'position',[0.1 0.5 0.1 0.1],...
    'callback',{@plotMeanHEG, d,[0 0 1 0 0 0 0 0 0]});
gv=uicontrol(f,'string','Plot GV','units','normalized',...
    'position',[0.2 0.5 0.1 0.1],...
    'callback',{@plotMeanHEG, d,[0 0 0 0 0 1 0 0 0]});
ga=uicontrol(f,'string','Plot GA','units','normalized',...
    'position',[0.3 0.5 0.1 0.1],...
    'callback',{@plotMeanHEG, d,[0 0 0 0 0 0 0 0 1]});

date=s.trialnum{1}(3:9);
day=date(1:2);
month=date(3:5);
year=date(6:7);
date=[month,'-',day,'-20',year];

t=uicontrol('style','text','string',['STIM DATE: ',date],'fontsize',18);
t.Units='normalized';
t.Position=[0.1 0.75 0.75 0.1];

lat=uicontrol(f,'string','Show Latency','units','normalized',...
    'position',[0.5 0.4 0.2 0.1],...
    'callback',{@latencyCB,g,s});

latstat=uicontrol(f,'string','Show Static Latency','units','normalized',...
    'position',[0.5 0.5 0.2 0.1],...
    'callback',{@latencyStaticCB,gap});

newsite=uicontrol(f,'string','Load New Location','units','normalized',...
    'position',[0.5 0.2 0.2 0.1],...
    'callback',@newsite);
end

function newsite(~,~)
browseStim
end

function plotAll(~,~,d,~)

head=d.head;
gaze=d.gaze;
eye=d.eye;
box=d.box;

rightwardS=gaze.gpstim(1600,:)>0;
rightwardG=gaze.gpgap(1600,:)>0;

whichplots=[1 1 1 1 1 1 1 1 1];
figure
if whichplots(1)
plotstimSUB(mean(head.hpgap(:,rightwardG)'),mean(head.hpstim(:,rightwardS)'),box,'Head Position','Position (degrees)',1,1);
plotstimSUB(mean(head.hpgap(:,~rightwardG)'),mean(head.hpstim(:,~rightwardS)'),box,'Head Position','Position (degrees)',0,1);
legend(gca,'location','east')
plotribbonMulti(head.hpgap,head.hpstim,rightwardG,rightwardS);

end
if whichplots(2)
plotstimSUB(mean(eye.epgap(:,rightwardG)'),mean(eye.epstim(:,rightwardS)'),box,'Eye Position','Position (degrees)',1,2);
plotstimSUB(mean(eye.epgap(:,~rightwardG)'),mean(eye.epstim(:,~rightwardS)'),box,'Eye Position','Position (degrees)',0,2);
plotribbonMulti(eye.epgap,eye.epstim,rightwardG,rightwardS);
end
if whichplots(3)
plotstimSUB(mean(gaze.gpgap(:,rightwardG)'),mean(gaze.gpstim(:,rightwardS)'),box,'Gaze Position','Position (degrees)',1,3);
plotstimSUB(mean(gaze.gpgap(:,~rightwardG)'),mean(gaze.gpstim(:,~rightwardS)'),box,'Gaze Position','Position (degrees)',0,3);
plotribbonMulti(gaze.gpgap,gaze.gpstim,rightwardG,rightwardS);
end
%velocity figures
if whichplots(4)
plotstimSUB(mean(head.hvgap(:,rightwardG)'),mean(head.hvstim(:,rightwardS)'),box,'Head Velocity','Velocity (degrees/s)',1,4);
plotstimSUB(mean(head.hvgap(:,~rightwardG)'),mean(head.hvstim(:,~rightwardS)'),box,'Head Velocity','Velocity (degrees/s)',0,4);

plotribbonMulti(head.hvgap,head.hvstim,rightwardG,rightwardS);
end
if whichplots(5)
plotstimSUB(mean(eye.evgap(:,rightwardG)'),mean(eye.evstim(:,rightwardS)'),box,'Eye Velocity','Velocity (degrees/s)',1,5);
plotstimSUB(mean(eye.evgap(:,~rightwardG)'),mean(eye.evstim(:,~rightwardS)'),box,'Eye Velocity','Velocity (degrees/s)',0,5);

plotribbonMulti(eye.evgap,eye.evstim,rightwardG,rightwardS);
end
if whichplots(6)
plotstimSUB(mean(gaze.gvgap(:,rightwardG)'),mean(gaze.gvstim(:,rightwardS)'),box,'Gaze Velocity','Velocity (degrees/s)',1,6);
plotstimSUB(mean(gaze.gvgap(:,~rightwardG)'),mean(gaze.gvstim(:,~rightwardS)'),box,'Gaze Velocity','Velocity (degrees/s)',0,6);

plotribbonMulti(gaze.gvgap,gaze.gvstim,rightwardG,rightwardS);
end
%acceleration figures
if whichplots(7)
plotstimSUB(mean(head.hagap(:,rightwardG)'),mean(head.hastim(:,rightwardS)'),box,'Head Acceleration','Acceleration (degrees/s/s)',1,7);
plotstimSUB(mean(head.hagap(:,~rightwardG)'),mean(head.hastim(:,~rightwardS)'),box,'Head Acceleration','Acceleration (degrees/s/s)',0,7);

plotribbonMulti(head.hagap,head.hastim,rightwardG,rightwardS);
end
if whichplots(8)
plotstimSUB(mean(eye.eagap(:,rightwardG)'),mean(eye.eastim(:,rightwardS)'),box,'Eye Acceleration','Acceleration (degrees/s/s)',1,8);
plotstimSUB(mean(eye.eagap(:,~rightwardG)'),mean(eye.eastim(:,~rightwardS)'),box,'Eye Acceleration','Acceleration (degrees/s/s)',0,8);

plotribbonMulti(eye.eagap,eye.eastim,rightwardG,rightwardS);
end
if whichplots(9)
plotstimSUB(mean(gaze.gagap(:,rightwardG)'),mean(gaze.gastim(:,rightwardS)'),box,'Gaze Acceleration','Acceleration (degrees/s/s)',1,9);
plotstimSUB(mean(gaze.gagap(:,~rightwardG)'),mean(gaze.gastim(:,~rightwardS)'),box,'Gaze Acceleration','Acceleration (degrees/s/s)',0,9);

plotribbonMulti(gaze.gagap,gaze.gastim,rightwardG,rightwardS);
end
x=tightfig;

end

function latencyCB(~,~,g,s)
    viewstarttime(g,s)
end

function latencyStaticCB(~,~,gap)
    viewstarttimeStatic(gap)
end

function plotribbon(m,fstr,a)
if nargin<2
    fstr='k';
end
if nargin<3
    a=1;
end
x=1:length(m);
y=[mean(m')-std(m');mean(m')+std(m')];

px=[x,fliplr(x)]; % make closed patch
py=[y(1,:), fliplr(y(2,:))];
patch(px,py,1,'FaceColor',fstr,'EdgeColor','none','facealpha',a);

end
function plotribbonMulti(g,s,rg,rs)

plotribbon(g(:,rg),'k',0.2);
plotribbon(s(:,rs),'r',0.2);
plotribbon(g(:,~rg),'b',0.2);
plotribbon(s(:,~rs),'m',0.2);

end

function plotMeanHEG(~,~,d,whichplots)
head=d.head;
gaze=d.gaze;
eye=d.eye;
box=d.box;

rightwardS=gaze.gpstim(1600,:)>0;
rightwardG=gaze.gpgap(1600,:)>0;

whichplots=whichplots(:);
if whichplots(1)
plotstim(mean(head.hpgap(:,rightwardG)'),mean(head.hpstim(:,rightwardS)'),box,'Head Position','Position (degrees)');
plotstim(mean(head.hpgap(:,~rightwardG)'),mean(head.hpstim(:,~rightwardS)'),box,'Head Position','Position (degrees)',0);
legend(gca,'location','eastoutside')
plotribbonMulti(head.hpgap,head.hpstim,rightwardG,rightwardS);

end
if whichplots(2)
plotstim(mean(eye.epgap(:,rightwardG)'),mean(eye.epstim(:,rightwardS)'),box,'Eye Position','Position (degrees)');
plotstim(mean(eye.epgap(:,~rightwardG)'),mean(eye.epstim(:,~rightwardS)'),box,'Eye Position','Position (degrees)',0);
legend(gca,'location','eastoutside')
plotribbonMulti(eye.epgap,eye.epstim,rightwardG,rightwardS);
end
if whichplots(3)
plotstim(mean(gaze.gpgap(:,rightwardG)'),mean(gaze.gpstim(:,rightwardS)'),box,'Gaze Position','Position (degrees)');
plotstim(mean(gaze.gpgap(:,~rightwardG)'),mean(gaze.gpstim(:,~rightwardS)'),box,'Gaze Position','Position (degrees)',0);
legend(gca,'location','eastoutside')
plotribbonMulti(gaze.gpgap,gaze.gpstim,rightwardG,rightwardS);
end
%velocity figures
if whichplots(4)
plotstim(mean(head.hvgap(:,rightwardG)'),mean(head.hvstim(:,rightwardS)'),box,'Head Velocity','Velocity (degrees/s)');
plotstim(mean(head.hvgap(:,~rightwardG)'),mean(head.hvstim(:,~rightwardS)'),box,'Head Velocity','Velocity (degrees/s)',0);
legend(gca,'location','eastoutside')
plotribbonMulti(head.hvgap,head.hvstim,rightwardG,rightwardS);
end
if whichplots(5)
plotstim(mean(eye.evgap(:,rightwardG)'),mean(eye.evstim(:,rightwardS)'),box,'Eye Velocity','Velocity (degrees/s)');
plotstim(mean(eye.evgap(:,~rightwardG)'),mean(eye.evstim(:,~rightwardS)'),box,'Eye Velocity','Velocity (degrees/s)',0);
legend(gca,'location','eastoutside')
plotribbonMulti(eye.evgap,eye.evstim,rightwardG,rightwardS);
end
if whichplots(6)
plotstim(mean(gaze.gvgap(:,rightwardG)'),mean(gaze.gvstim(:,rightwardS)'),box,'Gaze Velocity','Velocity (degrees/s)');
plotstim(mean(gaze.gvgap(:,~rightwardG)'),mean(gaze.gvstim(:,~rightwardS)'),box,'Gaze Velocity','Velocity (degrees/s)',0);
legend(gca,'location','eastoutside')
plotribbonMulti(gaze.gvgap,gaze.gvstim,rightwardG,rightwardS);
end
%acceleration figures
if whichplots(7)
plotstim(mean(head.hagap(:,rightwardG)'),mean(head.hastim(:,rightwardS)'),box,'Head Acceleration','Acceleration (degrees/s/s)');
plotstim(mean(head.hagap(:,~rightwardG)'),mean(head.hastim(:,~rightwardS)'),box,'Head Acceleration','Acceleration (degrees/s/s)',0);
legend(gca,'location','eastoutside')
plotribbonMulti(head.hagap,head.hastim,rightwardG,rightwardS);
end
if whichplots(8)
plotstim(mean(eye.eagap(:,rightwardG)'),mean(eye.eastim(:,rightwardS)'),box,'Eye Acceleration','Acceleration (degrees/s/s)');
plotstim(mean(eye.eagap(:,~rightwardG)'),mean(eye.eastim(:,~rightwardS)'),box,'Eye Acceleration','Acceleration (degrees/s/s)',0);
legend(gca,'location','eastoutside')
plotribbonMulti(eye.eagap,eye.eastim,rightwardG,rightwardS);
end
if whichplots(9)
plotstim(mean(gaze.gagap(:,rightwardG)'),mean(gaze.gastim(:,rightwardS)'),box,'Gaze Acceleration','Acceleration (degrees/s/s)');
plotstim(mean(gaze.gagap(:,~rightwardG)'),mean(gaze.gastim(:,~rightwardS)'),box,'Gaze Acceleration','Acceleration (degrees/s/s)',0);
legend(gca,'location','eastoutside')
plotribbonMulti(gaze.gagap,gaze.gastim,rightwardG,rightwardS);
end

end

function plotHeadEyeGaze(head,eye,gaze,box)

plotstim(head.hpgap,head.hpstim,box,'Head Position','Position (degrees)');
ylim([-100 100])
plotstim(eye.epgap,eye.epstim,box,'Eye Position','Position (degrees)');
ylim([-100 100])
plotstim(gaze.gpgap,gaze.gpstim,box,'Gaze Position','Position (degrees)');
ylim([-100 100])

%velocity figures
plotstim(head.hvgap,head.hvstim,box,'Head Velocity','Velocity (degrees/s)');
ylim([-1000 1000])
plotstim(eye.evgap,eye.evstim,box,'Eye Velocity','Velocity (degrees/s)');
ylim([-1000 1000])
plotstim(gaze.gvgap,gaze.gvstim,box,'Gaze Velocity','Velocity (degrees/s)');
ylim([-1000 1000])

%acceleration figures
plotstim(head.hagap,head.hastim,box,'Head Acceleration','Acceleration (degrees/s/s)');
plotstim(eye.eagap,eye.eastim,box,'Eye Acceleration','Acceleration (degrees/s/s)');
plotstim(gaze.gagap,gaze.gastim,box,'Gaze Acceleration','Acceleration (degrees/s/s)');

end

function plotstim(agap,bstim,box,titletext,ytitle,newplot)
    if nargin<6
        newplot=1;
    end
    if newplot
        figure;hold on
        colors = {'k','r'};
        d={'Rightward Gap','Rightward Stim'};
        rectangle('position',box.gap,...
            'facecolor',[.9 .9 .9]);
        rectangle('position',box.stim,...
            'facecolor',[.8 .8 .8]);
        y=[0 1];
    else
        colors = {'b','m'};
        y=ylim;
        d={'Leftward Gap','Leftward Stim'};
    end
    
    if size(agap,1)==1
        lw=2;
    else
        lw=1;
    end

    plot(agap,colors{1},'displayname',d{1},'linewidth',lw)
    plot(bstim,colors{2},'displayname',d{2},'linewidth',lw)
    title(titletext)
    xlabel('Time (ms)')
    ylabel(ytitle);
    ylim([min(min(bstim(:)),y(1)),max(max(bstim(:)),y(2))])
end

function plotstimSUB(agap,bstim,box,titletext,ytitle,newplot,subnum)
    if nargin<6
        newplot=1;
    end
    if newplot
        subplot(3,3,subnum)
        hold on
        colors = {'k','r'};
        d={'Rightward Gap','Rightward Stim'};
        rectangle('position',box.gap,...
            'facecolor',[.9 .9 .9]);
        rectangle('position',box.stim,...
            'facecolor',[.8 .8 .8]);
        y=[0 1];
    else
        colors = {'b','m'};
        y=ylim;
        d={'Leftward Gap','Leftward Stim'};
    end
    
    if size(agap,1)==1
        lw=2;
    else
        lw=1;
    end

    plot(agap,colors{1},'displayname',d{1},'linewidth',lw)
    plot(bstim,colors{2},'displayname',d{2},'linewidth',lw)
    title(titletext)
    xlabel('Time (ms)')
    ylabel(ytitle);
    ylim([min(min(bstim(:)),y(1)),max(max(bstim(:)),y(2))])
end

