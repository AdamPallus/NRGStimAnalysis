%%REGRESSFIT: This function takes an input of a time slice of a repeated
%%trial and returns a linear fit.
%%The purpose of this function is to use regression analysis to determine
%%the latency of movements. We regress first on a period before movement
%%begins, then regress from some threshold value back in time. The point
%%where the two lines cross is used as the time that the movement began. 
%%USAGE: let HASTIM be the head acceleration from time 1:2000, with 10
%%repetitions. We want to compare the regression from 500:525 and 600:625;
%%call regressfit twice.
%%pre=regressfit(HASTIM,500,525);post=regressfit(HASTIM,600,625) then
%%compare the two regressions. Find where pre=post

function [singler, meanr]=regressfit(a,timestart,timestop)
a=a(timestart:timestop,:);
s=size(a);
x=repmat(timestart:timestop,[s(2),1]);

%can't seem to run robustfit on a multi-trial set, so we're averaging
%manually
warning('off','all')
fit=zeros(s(2),2);
for i =1:s(2)
    fit(i,:)=robustfit(x(i,:),a(:,i));    
end
warning('on','all')
b=mean(fit,1);

%make functions and return
meanr=@(y) y.*b(2)+b(1);
singler=@(y) y*fit(:,2)+fit(:,1);

