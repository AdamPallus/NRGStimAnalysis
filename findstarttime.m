function o=findstarttime(head,eye)

if isfield(head,'hpstim')
    
    %Remove trials with saccade like activity right around stim time
    bad=any(eye.eastim(520:580,:)>4000);
    if any(bad)
        
        display(['Removing ', num2str(sum(bad)),' trials'])
        
        eye.eastim=eye.eastim(:,~bad);
        eye.evstim=eye.evstim(:,~bad);
        eye.epstim=eye.epstim(:,~bad);
        
        head.hastim=head.hastim(:,~bad);
        head.hvstim=head.hvstim(:,~bad);
        head.hpstim=head.hpstim(:,~bad);
    end
%     
    rightward=head.hpstim(1800,:)>0;
    o.right= substart(head,eye,550,100,rightward,0);
    o.left=substart(head,eye,550,100,~rightward,0);
else
    index=head.hastim(100,:)<1e100;
    o=substart(head,eye,50,49,index,1);
end

function o=substart(head,eye,stimstart,searchwindow,index,static)

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
[~, o.prestimeye]=regressfit(eye.eastim(:,index),presearch,stimstart);
[~, o.prestimhead]=regressfit(head.hastim(:,index),presearch,stimstart);

if ~static
    [poststimeyeFAM,o.poststimeye]=regressfit(eye.eastim(:,index),emax-25,emax);
    [poststimheadFAM,o.poststimhead]=regressfit(head.hastim(:,index),hmax-25,hmax);
else
    %do it a tiny bit differently for static stimulation
    [poststimeyeFAM, o.poststimeye]=regressfit(eye.eastim(:,:),emax-15,emax+10);
    [poststimheadFAM, o.poststimhead]=regressfit(head.hastim(:,:),hmax-15,hmax+10);
end


triallength=size(head.hastim,1);

%this part is a little bit clunky, but we have a family of functions and we
%are generating the values using a for loop, then comparing each function
%individually. Each function represents the regression from one trial, we
%report the average of all of the trials as the mean latency.

for i =1:triallength
    pse(:,i)=poststimeyeFAM(i);
    psh(:,i)=poststimheadFAM(i);
end

for i =1:size(pse,1)
    [m, es(i)]=min(abs(o.prestimeye(1:triallength)-pse(i,:)));
    [m, hs(i)]=min(abs(o.prestimhead(1:triallength)-psh(i,:)));
end
    [m, meanes]=min(abs(o.prestimeye(1:triallength)-o.poststimeye(1:triallength)));
    [m, meanhs]=min(abs(o.prestimhead(1:triallength)-o.poststimhead(1:triallength)));


%remove failed latency calculations:
o.es(es<550|es>700)=NaN;
o.hs(hs<550|hs>700)=NaN;

o.eyestart=meanes;
o.eyestartSTD=std(o.es);
o.headstart=meanhs;
o.headstartSTD=std(o.hs);

%debug
o.pse=pse;
o.psh=psh;

o.difference=o.eyestart-o.headstart;
o.emax=emax;
o.hmax=hmax;



