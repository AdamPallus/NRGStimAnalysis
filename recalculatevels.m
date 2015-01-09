%%This function recalculates the velocitiy and acceleration using the newer
%%parabolic diff function.This is necessary for older .mat files, or files
%%that have had the velocity and acceleration data removed to save space.

function [s]=recalculatevels(s)

    psize=7;
    s.headvelocities=cellfun(@(a) parabolicdiff(a,psize),s.headpositions,'uniformoutput',0);
    s.headaccelerations=cellfun(@(a) parabolicdiff(a,psize), s.headvelocities,'uniformoutput',0);
    s.eyevelocities=cellfun(@(a) parabolicdiff(a,psize), s.eyepositions,'uniformoutput',0);
    s.eyeaccelerations=cellfun(@(a) parabolicdiff(a,psize), s.eyevelocities,'uniformoutput',0);
    s.gazevelocities=cellfun(@(a) parabolicdiff(a,psize), s.gazepositions,'uniformoutput',0);
    s.gazeaccelerations=cellfun(@(a) parabolicdiff(a,psize), s.gazevelocities,'uniformoutput',0);

end


function vels=parabolicdiff(pos,n)
if nargin<2
    n=9;
end

q = sum(2*((1:n).^2));

vels=zeros(size(pos));
c=-conv(pos,[-n:-1 1:n],'valid');
vels(1:n)=ones(n,1)*c(1);
vels(end-n+1:end)=ones(n,1)*c(end);
vels(n:end-n)=c;
vels=vels/q*1000;

end
