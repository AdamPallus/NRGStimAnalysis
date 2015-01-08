function [head, eye]=headeyeStatic(g,triallength)
if nargin<2
    triallength=300;
end
    g=recalculatevels(g);
    x=cellfun(@(a) a(1:triallength),g.headaccelerations,'uniformoutput',0);
    x=cell2mat(x);
    head.hastim=x';
    
    x=cellfun(@(a) a(1:triallength),g.eyeaccelerations,'uniformoutput',0);
    x=cell2mat(x);
    eye.eastim=x';
end
    