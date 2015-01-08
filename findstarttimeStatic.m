function o=findstarttimeStatic(head,eye)

    o=substart(head,eye,50,49);


function o=substart(head,eye,stimstart,searchwindow)


if nargin <4
    stimstart=50;
    searchwindow=49;
end

% eyenosac=eye.eastim;
% eyenosac(abs(eyenosac(:))>2000,:)=NaN;


presearch=max(1,stimstart-searchwindow); %search window after stimulation

%find the peak acceleration caused by stimulation
[meye, emax]=max(mean(eye.eastim(stimstart:stimstart+searchwindow,:),2));
[mhead, hmax]=min(mean(head.hastim(stimstart:stimstart+searchwindow,:),2));
%set the treshold to be 2/3 of the peak accel
Ethreshold=meye*(2/3);
Hthreshold=mhead*(2/3);
%find the time when the acceleration crosses the threshold
indstimstartE=find(mean(eye.eastim(stimstart:stimstart+searchwindow,:),2)>Ethreshold);
indstimstartH=find(mean(head.hastim(stimstart:stimstart+searchwindow,:),2)<Hthreshold);
emax=indstimstartE(1)+stimstart;
hmax=indstimstartH(1)+stimstart;

% %Force prestim to be just the zero line
% o.prestimeye=@(a) a*0;
% o.prestimhead=@(a) a*0;
%regress on the "searchwindow" ms period before stimstart
o.prestimeye=regressfit(eye.eastim(:,:),presearch,stimstart);
o.prestimhead=regressfit(head.hastim(:,:),presearch,stimstart);

o.poststimeye=regressfit(eye.eastim(:,:),emax-15,emax+10);
o.poststimhead=regressfit(head.hastim(:,:),hmax-15,hmax+10);


triallength=size(head.hastim,1);
[m, o.eyestart]=min(abs(o.prestimeye(1:triallength)-o.poststimeye(1:triallength)));
[m, o.headstart]=min(abs(o.prestimhead(1:triallength)-o.poststimhead(1:triallength)));
o.difference=o.eyestart-o.headstart;
o.emax=emax;
o.hmax=hmax;



