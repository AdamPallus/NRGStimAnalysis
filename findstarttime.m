function o=findstarttime(head,eye)

if isfield(head,'hpstim')
rightward=head.hpstim(1800,:)>0;

o.right= substart(head,eye,550,200,rightward);
o.left=substart(head,eye,550,200,~rightward);
else
    o=substart(head,eye,50,49);
end

function o=substart(head,eye,stimstart,searchwindow,index)

if nargin<5
    index=head.hastim(100,:)<1e100;
end
if nargin <4
    stimstart=550;
    searchwindow=200;
end

% eyenosac=eye.eastim;
% eyenosac(abs(eyenosac(:))>2000,:)=NaN;


presearch=max(1,stimstart-searchwindow); %search window after stimulation

%find the peak acceleration caused by stimulation
[meye, emax]=max(mean(eye.eastim(stimstart:stimstart+searchwindow,index),2));
[mhead, hmax]=min(mean(head.hastim(stimstart:stimstart+searchwindow,index),2));
%set the treshold to be 2/3 of the peak accel
Ethreshold=meye*(2/3);
Hthreshold=mhead*(2/3);
%find the time when the acceleration crosses the threshold
indstimstartE=find(mean(eye.eastim(stimstart:stimstart+searchwindow,index),2)>Ethreshold);
indstimstartH=find(mean(head.hastim(stimstart:stimstart+searchwindow,index),2)<Hthreshold);
emax=indstimstartE(1)+stimstart;
hmax=indstimstartH(1)+stimstart;

%regress on the "searchwindow" ms period before stimstart
o.prestimeye=regressfit(eye.eastim(:,index),presearch,stimstart);
o.prestimhead=regressfit(head.hastim(:,index),presearch,stimstart);

o.poststimeye=regressfit(eye.eastim(:,index),emax-25,emax);
o.poststimhead=regressfit(head.hastim(:,index),hmax-25,hmax);
%%%%DEBUG
% o.poststimeye=regressfit(eye.eastim(:,index),75,100);
% o.poststimhead=regressfit(head.hastim(:,index),75,100);

triallength=size(head.hastim,1);
[m, o.eyestart]=min(abs(o.prestimeye(1:triallength)-o.poststimeye(1:triallength)));
[m, o.headstart]=min(abs(o.prestimhead(1:triallength)-o.poststimhead(1:triallength)));
o.difference=o.eyestart-o.headstart;
o.emax=emax;
o.hmax=hmax;



