% Quick & dirty plot of performance
% AE 2012-12-03

dates = {'2012-12-03_10-51-37', '2012-12-03_14-08-12'};
% dates = {'2012-12-03_10-51-37'};
% dates = {'2012-12-03_14-08-12'};
dates = {'2012-12-03_16-12-22'};

folder = '/kyb/agmbshare/mpu/BethgePsychophysics/data/wnoridet/AE';
file = 'WNOriDetectExperimentTue';

for i = 1 : numel(dates)
    stims{i} = getfield(load(fullfile(folder, dates{i}, file)), 'stim'); %#ok
    if i == 1
        p = stims{1}.params;
    else
        p.trials = [p.trials, stims{i}.params.trials];
    end
end

c = p.constants;
signals = [c.signals];
nSignals = numel(signals);
coherences = [c.coherences];
nCoherences = numel(coherences);
biases = p.constants.biases;
nBiases = size(biases, 2);

trials = find([p.trials.validTrial] & ~[p.trials.catchTrial]);
nTrials = numel(trials);

cond = [p.trials(trials).condition];

blockSize = c.nRepsPerBlock * numel(c.coherences) * sum(c.biases(:, 1));
nBlocks = nTrials / blockSize;


%% compute number of correct trials
c = p.constants;
signals = [c.signals];
nSignals = numel(signals);
coherences = [c.coherences];
nCoherences = numel(coherences);
biases = p.constants.biases;
biases = biases(1, :) ./ sum(biases, 1);
nBiases = numel(biases);

trials = find([p.trials.validTrial]);
nTrials = numel(trials);

blockSize = c.nRepsPerBlock * numel(c.coherences) * sum(c.biases(:, 1)) + c.nCatchPerBlock;
nBlocks = nTrials / blockSize;

falseAlarms = zeros(1, nBiases);
correctRejections = zeros(1, nBiases);
hits = zeros(nCoherences, nSignals, nBiases);
misses = zeros(nCoherences, nSignals, nBiases);

for iBlock = 1 : nBlocks
    blockTrials = p.trials(trials((iBlock - 1) * blockSize + (1 : blockSize)));
    blockCond = p.conditions([blockTrials.condition]);
    bias = sum([blockCond.signal] == signals(1)) / (blockSize - c.nCatchPerBlock);
    [~, biasNdx] = min(abs(bias - biases));
    for iTrial = 56 : blockSize
        t = blockTrials(iTrial);
        if t.catchTrial
            if t.correctResponse
                correctRejections(biasNdx) = correctRejections(biasNdx) + 1;
            else
                falseAlarms(biasNdx) = falseAlarms(biasNdx) + 1;
            end
        else
            signalNdx = blockCond(iTrial).signal == signals;
            coherenceNdx = blockCond(iTrial).coherence == coherences;
            if t.correctResponse
                hits(coherenceNdx, signalNdx, biasNdx) = hits(coherenceNdx, signalNdx, biasNdx) + 1;
            elseif t.miss
                misses(coherenceNdx, signalNdx, biasNdx) = misses(coherenceNdx, signalNdx, biasNdx) + 1;
            else
                falseAlarms(biasNdx) = falseAlarms(biasNdx) + 1;
            end
        end
    end
end

% average the two signals for corresponding bias blocks
hitsAvg = zeros(nCoherences, nBiases - 1);
missesAvg = hitsAvg;
for iBias = 1 : nBiases - 1
    hitsAvg(:, iBias) = hits(:, 1, iBias + 1) + hits(:, 2, end - iBias);
    missesAvg(:, iBias) = misses(:, 1, iBias + 1) + misses(:, 2, end - iBias);
end

% overall performance for different biases
hitsByBlock = hitsAvg(:, 2 : 4);
hitsByBlock(:, 2) = hitsByBlock(:, 2) + hitsAvg(:, 1);
missesByBlock = missesAvg(:, 2 : 4);
missesByBlock(:, 2) = missesByBlock(:, 2) + missesAvg(:, 1);

counts = hits + misses;
countsAvg = hitsAvg + missesAvg;
countsByBlock = hitsByBlock + missesByBlock;

correct = hits ./ (hits + misses);
correct(hits + misses == 0) = 0;
correctAvg = hitsAvg ./ (hitsAvg + missesAvg);
correctByBlock = hitsByBlock ./ (hitsByBlock + missesByBlock);



%% plot data
off = 0;

figure(off + 1), clf
plot(coherences, correctAvg, 'o-')
axis([5 35 0 1.05])
xlabel('Coherence')
ylabel('Fraction detected')
legend(arrayfun(@(x) sprintf('%d%%', x * 100), biases(2 : end), 'UniformOutput', false), 'Location', 'SouthEast')
set(gca, 'xtick', coherences, 'box', 'off')

figure(off + 2), clf
q = mean(correctAvg, 1);
se = sqrt(q .* (1 - q) ./ sum(countsAvg, 1));
errorbar(100 * biases(2 : end), q, se, 'o-k')
xlabel('Bias (%)')
ylabel('Average fraction detected')
set(gca, 'xlim', [15 110], 'xtick', 100 * biases(2 : end), 'box', 'off')

figure(off + 3), clf
q = mean(correctByBlock, 1);
se = sqrt(q .* (1 - q) ./ sum(countsByBlock, 1));
errorbar(100 * biases((nBiases + 1) / 2 : end), q, se, 'o-k')
xlabel('Bias (%)')
ylabel('Overall fraction detected')
set(gca, 'xlim', [40 110], 'xtick', 100 * biases((nBiases + 1) / 2 : end), 'box', 'off')


