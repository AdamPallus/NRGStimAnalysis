%This is a rewrite of the findstatttime function. This function returns a
%table where each row is the latency calculated for a single trial.

%output: table with Head and Eye Latency and Peak Velocity: Hs, Es, Hv, Ev
%and direction of motion Left, Right or Static.

function t=findstarttimeTABLE(head,eye)

if isfield(head,'hpstim')
    
    rightward=head.hpstim(1800,:)>0;
    
    tright= substart(head,eye,550,100,rightward,0);
    tright.Dir=repmat('R',[height(tright),1]);

    tleft=substart(head,eye,550,100,~rightward,0);
    tleft.Dir=repmat('L',[height(tleft),1]);
    
    t=vertcat(tleft,tright);
    
else
    index=head.hastim(100,:)<1e100;
    t=substart(head,eye,50,49,index,1);
    t.Dir=repmat('S',[height(t),1]);
end

function t=substart(head,eye,stimstart,searchwindow,index,static)

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


%remove failed latency calcs
es(es<stimstart|es>stimstart+150)=NaN;
hs(hs<stimstart|hs>stimstart+150)=NaN;

%calculate vor gain using regression slope
for i =1:length(es)
    if ~isnan(es(i)) && ~isnan(hs(i))
        h=head.hvstim(hs(i):hs(i)+150,i);
        e=eye.evstim(es(i):es(i)+150,i);
        p=polyfit(h(:),e(:),1);
        vor(i)=p(1);
    else
        vor(i)=NaN;
    end
end
%subtract stimstart to get latency estimate
hs=hs'-stimstart;
es=es'-stimstart;

%find extreme values of velocity
%note that this analysis only works for leftward evoked movements
meye=max(eye.evstim(stimstart:stimstart+200,index));
mhead=min(head.hvstim(stimstart:stimstart+200,index));

% %this code makes things not stacked
% t=table(hs,es,mhead',meye',vor','VariableNames',{'Hs','Es','Hv','Ev','VOR'});

%The code below stacks the table so eye and head velocity and latency fit
%in one column. It adds a column specifying head or eye. VOR is duplicated,
%and the rows are in order, so you can unstack the table and regain pairs
%if necessary.
typeH=repmat('H',[length(hs),1]);
typeE=repmat('E',[length(es),1]);
t=table([hs;es],[mhead';meye'],[vor';vor'],[typeH;typeE],'VariableNames',{'Lat','Vel','VOR','Type'});




