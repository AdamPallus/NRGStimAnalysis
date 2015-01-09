function output=viewstarttimeStatic(g,tlength)
if nargin<3
    tlength=300;
end

[head, eye]=headeyeStatic(g,300);
% o=findstarttimeStatic(head,eye);
o=findstarttime(head,eye);

%stimulation and gap periods
gap_start=1;
post_stim_dur=200;
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


figure
subplot(1,2,1)
hold on
rectangle('position',box.gap,'facecolor',[.9 .9 .9]);
rectangle('position',box.stim,'facecolor',[.8 .8 .8]);
plot(head.hastim,'k');
y=ylim;
y(y>1e4)=1e4;
y(y<-1e4)=-1e4;
plot(o.prestimhead(1:tlength),'r');
plot(o.poststimhead(1:tlength),'m');
plot(mean(head.hastim,2),'b','linewidth',2)
line([o.headstart o.headstart],[y(1),y(2)])
ylim(y);
xlim([50 200])
t=['Head Start Time: ',num2str(round(o.headstart)),'\pm',num2str(round(o.headstartSTD))];
title(t);

subplot(1,2,2)
hold on
rectangle('position',box.gap,'facecolor',[.9 .9 .9]);
rectangle('position',box.stim,'facecolor',[.8 .8 .8]);
plot(eye.eastim,'k')
y=ylim;
y(y>1e4)=1e4;
y(y<-1e4)=-1e4;
plot(o.prestimeye(1:tlength),'r')
plot(o.poststimeye(1:tlength),'m');
plot(mean(eye.eastim,2),'b','linewidth',2)
t=['Eye Start Time: ',num2str(round(o.eyestart)),'\pm',num2str(round(o.eyestartSTD))];
title(t)
line([o.eyestart o.eyestart],[y(1),y(2)]) 
ylim(y);
xlim([50 200])
if nargout>0
    output=o;
end

