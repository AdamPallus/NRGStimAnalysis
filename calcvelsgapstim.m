%%This function recalculates the velocitiy and acceleration using the newer
%%parabolic diff function.This is necessary for older .mat files, or files
%%that have had the velocity and acceleration data removed to save space.

function [s]=recalculatevels(s)
for i =1:length(s)
s.headvelocities{i}=parabolicdiff(s.headpositions{i});
s.headaccelerations{i}=parabolicdiff(s.headvelocities{i});
s.eyevelocities{i}=parabolicdiff(s.eyepositions{i});
s.eyeaccelerations{i}=parabolicdiff(s.eyevelocities{i});
s.gazevelocities{i}=parabolicdiff(s.gazepositions{i});
s.gazeaccelerations{i}=parabolicdiff(s.gazevelocities{i});
end

end