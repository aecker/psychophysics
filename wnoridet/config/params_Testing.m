function constants = params_Testing()
% Training parameters for white noise orientation discrimination experiment

constants.subject = 'Testing';              % first/last
constants.fixationRadius = 1;               % in degrees
constants.stimulusLocation = 1.5 * [1; 1];  % in degrees
constants.coherences = [8 12 16 24 32];     % # frames during the coherent period
constants.coherences = 8;
constants.intertrialTime = 1000;            % time between trials (ms)
constants.waitTime = 200;                   % min response time (ms)
constants.responseTime = 200;               % max respomse time (ms)

% monitor information
constants.monitorSize = [40; 30]; 
constants.monitorDistance = 87;
constants.monitorResolution = [1400; 1050];
constants.monitorCenter = constants.monitorResolution / 2;

% for conversion to pixels
u = UnitConverter(constants.monitorSize, constants.monitorResolution, ...
                  constants.monitorDistance, constants.monitorCenter);
pxPerDeg = mean(getPxPerDeg(u));
constants.fixationRadius = constants.fixationRadius * pxPerDeg;
constants.stimulusLocation = constants.stimulusLocation * pxPerDeg;

% DO NOT CHANGE ANYTHING BELOW HERE
constants.driftCorrectRate = 0.08;
constants.date = datestr(now,'YYYY-mm-dd_HH-MM-SS');
constants.responseButton = 2;

% fixation spot and background
constants.fixSpotColor = 0;
constants.fixSpotLocation = [0; 0];
constants.fixSpotSize = 0.25 * pxPerDeg;
constants.bgColor = 0.5 * ones(3, 1);

% EXPERIMENT SPECIFIC PARAMETERS
constants.isMask = 1;
constants.contrast = 1;
constants.spatialFreq = 4;
constants.diskSize = 2.5 * pxPerDeg;
constants.color = [1 1 1]';

constants.phase = 0;
constants.orientations = 0 : 5 : 175;

constants.biases = [0 : 4; 4 : -1 : 0];
constants.signals = [45 135];
constants.nSeeds = 5;
constants.nCatchPerBlock = 0;
constants.nRepsPerBlock = 5;
constants.subBlockSize = 10;

constants.nFramesPreMin = 30;
constants.nFramesPreMean = 150;
constants.nFramesPreMax = 400;
constants.nFramesCoh = 48;

% timing
constants.fixationTime = 300;
constants.acquireFixationTime = 3000;

% Irrelevant but need to be set (don't change anything)
constants.rewardProb = 1;
constants.joystickThreshold = 200;
constants.passive = 0;
constants.acquireFixation = 1;
constants.allowSaccades = 0;
constants.rewardAmount = 0;
