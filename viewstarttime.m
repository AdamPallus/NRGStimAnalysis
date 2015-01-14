function output=viewstarttime(g,s,tlength)
if nargin<3
    tlength=1951;
end

useSubplots=1;

[head, eye, gaze]=headeyegazeMatrix(g,s,tlength);
x=findstarttime(head,eye);
o=x.left;
rightward=head.hpstim(1800,:)>0;

%stimulation and gap periods
gap_start=500;
post_stim_dur=300;
pre_stim_dur=50;
stim_dur=100;
gap_dur=pre_stim_dur+post_stim_dur+stim_dur;
stim_start=gap_start+pre_stim_dur;

%box y positioning
ymin=-10000;
ymax=10000;
boxheight=ymax-ymin;

box.gap=[gap_start ymin gap_dur boxheight];
box.stim=[stim_start ymin stim_dur boxheight];


figure;hold on
if useSubplots
    subplot(2,2,1)
    hold on
end
rectangle('position',box.gap,'facecolor',[.9 .9 .9]);
rectangle('position',box.stim,'facecolor',[.8 .8 .8]);
plot(head.hastim(:,~rightward),'k');
y=ylim;
y(y>1e4)=1e4;
y(y<-1e4)=-1e4;
plot(o.prestimhead(1:tlength),'r');
plot(o.poststimhead(1:tlength),'m','linewidth',2);
%DEBUG
plot(o.psh','m');

plot(mean(head.hastim(:,~rightward),2),'b','linewidth',2)
line([o.headstart o.headstart],[y(1),y(2)])
% line([o.hmax o.hmax],[y(1),y(2)])
ylim(y);
xlim([500 800])
t=['Leftward Head Start Time: ',num2str(round(o.headstart)),'\pm',num2str(round(o.headstartSTD))];
title(t);
if useSubplots
    subplot(2,2,2)
    hold on
else
    figure;hold on
end
rectangle('position',box.gap,'facecolor',[.9 .9 .9]);
rectangle('position',box.stim,'facecolor',[.8 .8 .8]);
plot(eye.eastim(:,~rightward),'k')
y=ylim;
y(y>1e4)=1e4;
y(y<-1e4)=-1e4;
plot(o.prestimeye(1:tlength),'r')
plot(o.poststimeye(1:tlength),'m','linewidth',2);
%DEBUG
plot(o.pse','m');
plot(mean(eye.eastim(:,~rightward),2),'b','linewidth',2)
t=['Leftward Eye Start Time: ',num2str(round(o.eyestart)),'\pm',num2str(round(o.eyestartSTD))];
title(t);
line([o.eyestart o.eyestart],[y(1),y(2)]) 
% line([o.emax o.emax],[y(1),y(2)])
ylim(y);
xlim([500 800])

o=x.right;

if useSubplots
    subplot(2,2,3)
    hold on
else
    figure;hold on
end
rectangle('position',box.gap,'facecolor',[.9 .9 .9]);
rectangle('position',box.stim,'facecolor',[.8 .8 .8]);
plot(head.hastim(:,rightward),'k');
y=ylim;
y(y>1e4)=1e4;
y(y<-1e4)=-1e4;
plot(o.prestimhead(1:tlength),'r');
plot(o.poststimhead(1:tlength),'m','linewidth',2);
%DEBUG
plot(o.psh','m');
t=['Rightward Head Start Time: ',num2str(round(o.headstart)),'\pm',num2str(round(o.headstartSTD))];
title(t);
plot(mean(head.hastim(:,rightward),2),'b','linewidth',2)
line([o.headstart o.headstart],[y(1),y(2)]) 
% line([o.hmax o.hmax],[y(1),y(2)])
ylim(y);
xlim([500 800])

if useSubplots
    subplot(2,2,4)
    hold on
else
    figure;hold on
end
rectangle('position',box.gap,'facecolor',[.9 .9 .9]);
rectangle('position',box.stim,'facecolor',[.8 .8 .8]);
plot(eye.eastim(:,rightward),'k')
y=ylim;
y(y>1e4)=1e4;
y(y<-1e4)=-1e4;
plot(o.prestimeye(1:tlength),'r')
plot(o.poststimeye(1:tlength),'m','linewidth',2);
%DEBUG
plot(o.pse','m');
t=['Rightward Eye Start Time: ',num2str(round(o.eyestart)),'\pm',num2str(round(o.eyestartSTD))];
title(t);
plot(mean(eye.eastim(:,rightward),2),'b','linewidth',2)
line([o.eyestart o.eyestart],[y(1),y(2)]) 
% line([o.emax o.emax],[y(1),y(2)])
ylim(y);
xlim([500 800])
if nargout>0
    output=x;
end

