function [head, eye, gaze] = headeyegazeMatrix(g,s,triallength)

s=recalculatevels(s);
g=recalculatevels(g);

if nargin<3
    triallength=1951;
    %trial length of step ramp gap stim trials at 40 deg/s is 1951
end

%only consider trials with the correct length
sgood=s.triallength==triallength;
ggood=g.triallength==triallength;

[h.hpgap, h.hpstim]=extractFromCell(g.headpositions(ggood),...
    s.headpositions(sgood),triallength);
[e.epgap, e.epstim]=extractFromCell(g.eyepositions(ggood),...
    s.eyepositions(sgood),triallength);
[gaze.gpgap, gaze.gpstim]=extractFromCell(g.gazepositions(ggood),...
    s.gazepositions(sgood),triallength);
[h.hvgap, h.hvstim]=extractFromCell(g.headvelocities(ggood),...
    s.headvelocities(sgood),triallength);
[e.evgap, e.evstim]=extractFromCell(g.eyevelocities(ggood),...
    s.eyevelocities(sgood),triallength);
[gaze.gvgap, gaze.gvstim]=extractFromCell(g.gazevelocities(ggood),...
    s.gazevelocities(sgood),triallength);
[h.hagap, h.hastim]=extractFromCell(g.headaccelerations(ggood),...
    s.headaccelerations(sgood),triallength);
[e.eagap, e.eastim]=extractFromCell(g.eyeaccelerations(ggood),...
    s.eyeaccelerations(sgood),triallength);
[gaze.gagap, gaze.gastim]=extractFromCell(g.gazeaccelerations(ggood),...
    s.gazeaccelerations(sgood),triallength);
head=h;eye=e;
end

function [gap, stim]=extractFromCell(gapcell,stimcell,triallength)
    x=cell2mat(gapcell);
    gap=x';
    x=cell2mat(stimcell);
    stim=x';
end

