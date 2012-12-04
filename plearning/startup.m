% Add experiment code and folder with config files to the path
folder = fileparts(mfilename('fullpath'));
addpath(folder)
addpath(fullfile(folder, 'config'))

% These are the Tolias lab stimulation library folders
ndx = find(folder == filesep, 1, 'last');
folder = folder(1:ndx);
run(fullfile(folder, 'stimulation/alex/setPath'))
run(fullfile(folder, 'stimulation/library/setPath'))
addpath(fullfile(folder, 'stimulation/matlablib'))

% Bethge-lab-specific tools
addpath(fullfile(folder, 'Equipment'))
