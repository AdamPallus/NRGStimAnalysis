%%This function recalculates the velocitiy and acceleration using the newer
%%parabolic diff function.This is necessary for older .mat files, or files
%%that have had the velocity and acceleration data removed to save space.

function [s]=recalculatevels(s)


    s.headvelocities=cellfun(@(a) parabolicdiff(a),s.headpositions,'uniformoutput',0);
    s.headaccelerations=cellfun(@(a) parabolicdiff(a), s.headvelocities,'uniformoutput',0);
    s.eyevelocities=cellfun(@(a) parabolicdiff(a), s.eyepositions,'uniformoutput',0);
    s.eyeaccelerations=cellfun(@(a) parabolicdiff(a), s.eyevelocities,'uniformoutput',0);
    s.gazevelocities=cellfun(@(a) parabolicdiff(a), s.gazepositions,'uniformoutput',0);
    s.gazeaccelerations=cellfun(@(a) parabolicdiff(a), s.gazevelocities,'uniformoutput',0);


end