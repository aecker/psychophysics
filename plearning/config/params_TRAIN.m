function constants = params_TRAIN()
% Training parameters for white noise orientation discrimination experiment

constants.subject = 'Training';   % subject identifier
constants.blockTime = 3     ;     % minutes until subject gets a break
constants.numBlocks = 2;          % number of blocks the subject runs
constants.fixationRadius = 33;    % pixels (51px is 1deg) ### HG new config (33/51) = (40/62) of old config
constants.intertrialTime = 1000;  % time between trials (ms)
constants.stimulusLocation = [76;76];%[95; 95]; % (x,y) relative to fixation spot (px) ### HG: 76/1280 = 95/1600


% DO NOT CHANGE ANYTHING BELOW HERE
constants.driftCorrectRate = 0.08;
constants.date = datestr(now,'YYYY-mm-dd_HH-MM-SS');
constants.responseButtons = [3; 1];  % red & green

% fixation spot and background
constants.fixSpotColor = 0;
constants.fixSpotLocation = [0; 0];
constants.fixSpotSize = 13;
constants.bgColor = 0.5;

% monitor information
constants.monitorSize = [40; 30]; 
constants.monitorDistance = 90;
%constants.monitorCenter = [800; 600]; % ### HG
constants.monitorCenter = [1280; 960]./2; % ### HG

% stimulus location and size
constants.diskSize = 100; %126; ### recalculated by HG, (126/1600) = (100/1280)

% grating parameters
constants.contrast = 1;
constants.spatialFreq = 3;
constants.color = [1 1 1]';
constants.isMask = 1;

% randomization and blocking of conditions
constants.signalBlockSize = 1;
constants.stimFrames = 1;
constants.orientations = 0:5:175;
constants.oriBlockSize = 2;
constants.phases = [0 45 90 135 180 225 270 315];
constants.signals = [45 135];
constants.randSeedNum = 10;
constants.fixedSeedNum = 10;

% staircase settings
constants.stepCorrect = -0.1;
constants.stepWrong = 0.3;
constants.stepSize = 0.25;
constants.initialThreshold = 5;
constants.distribution = '@(x) round((rand(1) - 0.5) * 5 + x)';
constants.poolSize = 10;
constants.maxLevel = 5;

% timing
constants.fixationTime = 300;
constants.acquireFixationTime = 3000;
constants.stimulusTime = 2000;

% Irrelevant but need to be set (don't change anything)
constants.centerOrientation = 0;
constants.targetAngle = 0;
constants.targetDistance = 0;
constants.rewardProb = 1;
constants.joystickThreshold = 200;
constants.passive = 0;
constants.acquireFixation = 1;
constants.allowSaccades = 0;
constants.rewardAmount = 0;
