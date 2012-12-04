function stim = loadData()

minTrials = 500;
subjects = {'CS', 'DK', 'VB'};
range = ['2011-11-03'; '2011-11-16'];
base = '~/stimulation';
folders = dir(fullfile(base, '*-*-*_*-*-*'));
dates = arrayfun(@(x) datenum(x.name(1:10)), folders);
folders = folders(dates > datenum(range(1,:)) & dates < datenum(range(2,:)) + 1);
stim = cell(1, numel(subjects));
for folder = folders'
    s = getfield(load(fullfile(base, folder.name, 'WNOriDiscExperimentTue')), 'stim'); %#ok
    subjectIndex = find(strcmp(s.params.constants.subject, subjects));
    if numel(s.events) > minTrials && ~isempty(subjectIndex)
        stim{subjectIndex} = [stim{subjectIndex} s];
        fprintf('rsync -rv --exclude=[0-9]*.mat /Users/localadmin/stimulation/%s %s/\n', folder.name, s.params.constants.subject)
    end
end
