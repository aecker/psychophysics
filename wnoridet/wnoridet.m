function E = wnoridet(subject, simulateEyeLink)
% Run white noise orientation discrimination experiment.
% This script runs the experiment using the Bethge lab hardware.
%
% AE 2011-09-13

if ~nargin || isempty(subject)
    subject = 'TEST';
end
if nargin < 2
    simulateEyeLink = false;
end

% turn off annnoying warnings
warning off StimulationData:setTrialParam

% setup experiment object
E = WNOriDetectExperimentTue;
E = set(E, 'local', true);  % run without proper state system
E = set(E, 'debug', true'); % TEMP to turn of audio

% parameters
constants = feval(sprintf('params_%s', subject));
constants.eyeControl = ~simulateEyeLink;

try
    
    % open psychtoolbox window
    E = openWindow(E);
    win = get(E, 'win');
    
    % turn off photodiode pixel
    E = set(E, 'photoDiodeTimer', PhotoDiodeTimer(300, [0.5 0.5], 0));
    
    % initialize responsepixx (expects a flip to have occurred)
    Screen('Flip', win);
    ResponsePixx('Open');
    
    % setup eye tracker
    eyeTracker = EyeTracker(win, constants.fixationRadius, constants.driftCorrectRate, simulateEyeLink);
    eyeTracker = init(eyeTracker);
    eyeTracker = calibrate(eyeTracker);
    
    % initialize experiment class
    E = netStartSession(E, constants);
    
    % display instructions & wait for button press to proceed
    % E = showInsitructions(E);
    
    % start the experiment
    nBlocks = size(constants.biases, 2);
    blockSize = constants.nRepsPerBlock * numel(constants.coherences) * sum(constants.biases(:, 1)) + constants.nCatchPerBlock;
    nTrials = nBlocks * blockSize;
    
    trialNumber = 0;
    interrupted = false;
    while trialNumber < nTrials && ~interrupted
        
        % ctr = getCenter(eyeTracker);
        % fprintf('Eye tracker: (%.1f, %.1f)\n', ctr(1), ctr(2))
        
        E = netStartTrial(E, struct);
        E = netSync(E, struct('counter', 0));
        E = netSync(E, struct('counter', 1));
        
        % start eye tracker
        [eyeTracker, t] = startTrial(eyeTracker, trialNumber);
        E = addEvent(E, 'eyeTrackerStart', t);
        
        % keep track of drift correction
        E = setTrialParam(E, 'eyeTrackerCenter', getCenter(eyeTracker));
        
        % show fixation spot and wait until subject fixates
        E = netShowFixSpot(E, struct);
        [eyeTracker, acqTime] = waitForFixation(eyeTracker, getLastSwap(E), ...
            constants.fixationTime / 1000, constants.acquireFixationTime / 1000);
        
        % timeout?
        if acqTime < 0
            par.behaviorTimestamp = NaN;
            par.abortType = 'eyeAbort';
            E = netAbortTrial(E, par);
        else
            [E, eyeTracker] = netShowStimulus(E, eyeTracker);
        end
        
        if getParam(E, 'validTrial')
            trialNumber = trialNumber + 1;
        end
        
        E = netEndTrial(E);
        
        % intertrial time
        t = GetSecs + constants.intertrialTime / 1000;
        while GetSecs < t && ~interrupted
            [~, ~, keyCode] = KbCheck();
            if any(keyCode)
                KbReleaseWait();
                switch find(keyCode, 1)
                    case KbName('Escape')
                        fprintf('Are you sure you want to interrupt? [y/n] ')
                        [~, keyCode] = KbWait();
                        fprintf('\n')
                        if KbName('y') == find(keyCode, 1)
                            interrupted = true;
                        end
                    case KbName('c')
                        fprintf('Recalibrate? [y/n] ')
                        [~, keyCode] = KbWait();
                        fprintf('\n')
                        if KbName('y') == find(keyCode, 1)
                            eyeTracker = calibrate(eyeTracker);
                            t = GetSecs;
                        end
                end
            end
        end
    end
    
    % write data
    date = getSessionParam(E, 'date');
    targetFolder = sprintf('~/stimulation/%s/', date);
    receiveFile(eyeTracker, targetFolder, 'eyes.edf');
    E = netEndSession(E);
    
    % clean up
    E = cleanUp(E);
    ResponsePixx('Close');
    
catch err
    sca
    ResponsePixx('Close');
    rethrow(err)
end


