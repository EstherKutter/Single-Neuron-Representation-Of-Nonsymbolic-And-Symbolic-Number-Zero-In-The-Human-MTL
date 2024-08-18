clear, clc

format = 'numeral'; % must be 'numerosity' or 'numeral'

load(['data_tuningCharacteristics_',format,'.mat'])

%%

close all
fig = figure('Units','centimeters', 'Position',[2 2 7 14], 'Color','w');

nums  = 0:9;
nNums = numel(nums);
colors_num = [0.8  0    0;...
              1.0  0.2  0;...
              1.0  0.6  0;...
              0.9  0.9  0;...
              0.5  0.8  0.3;...
              0.6  0.8  0.9;...
              0    0.8  1.0;...
              0    0.4  1.0;...
              0    0    1.0;...
              0    0    0.6];          
stars = {'','*','*','*'};  

% --- preferred numbers ---

axPrefNums = axes('Units','centimeters', 'Position',[1.5 10.5 5 3]);

% .. data ..
b = bar(nums,diag(percent_prefNums), 'stacked');
for n=1:nNums
    set(b(n), 'FaceColor',colors_num(n,:), 'FaceAlpha',1);
end % n nums

% .. axis properties ..
set(axPrefNums,...
    'xTick',nums, 'xTickLabel',nums,...
    'yTick',0:10:22,...
    'FontSize',10)
xlabel(['Preferred ',format], 'FontSize', 12)
ylabel('Frequency (%)',    'FontSize', 12)
axPrefNums.XRuler.TickLabelGapOffset = -2;
axPrefNums.YRuler.TickLabelGapOffset = 0;
axis([nums(1)-.75 nums(end)+.75 , 0 max(percent_prefNums)+1])
box off

% --- tuning curves ---

axTunCurves = axes('Units','centimeters', 'Position',[1.5 6 5 3]);
hold on

% .. data ..
for n=flip(1:nNums)
    plot(nums, tuningCurves(n,:),...
        'LineWidth',1.5, 'Color',colors_num(n,:), 'Marker','o', 'MarkerSize',4, 'MarkerFaceColor','w')
end % n nums

% .. axis properties ..
set(axTunCurves,...
    'xlim',[nums(1)-.25 nums(end)+.25], 'xTick',nums, ...
    'ylim',[0 1],                       'yTick',0:.25:1, ...
    'ticklength',[.03 .01], 'FontSize',10)
xlabel(['Sample ',format],  'FontSize',12)
ylabel('Norm. firing rate', 'FontSize',12)
axTunCurves.XRuler.TickLabelGapOffset = -1;

% --- zero curve ---

axZeroCurve = axes('Units','centimeters', 'Position',[1.5 1.5 5 3]);
hold on

% .. data ..
% delimiter at 0
plot([-1 10],[0 0],'k:')
% curves
tr = errorbar(nums, zeroCurve.mean, zeroCurve.sem,...
    'LineWidth',1.5, 'LineStyle','-', 'Marker','o', 'Color',colors_num(1,:), 'MarkerFaceColor','w', 'MarkerSize',5);
rn = plot(nums, randomCurve,...
    'LineWidth',1.5, 'LineStyle',':', 'Marker','o', 'Color',[.5 .5 .5], 'MarkerFaceColor','w', 'MarkerSize',5);
% .. significance ..
% signtest
for nDist=1:nNums-1
    ys = max(zeroCurve.mean(nDist:nDist+1))+.08;
    if signTest(nDist) < .05
        line([nDist-.9 nDist-.1], [ys ys], 'Color','k', 'LineWidth',1)
        text(nDist-.5, ys+.03,...
            [stars{[10 .05 .01 .001] >= signTest(nDist)}],...
            'Color','k', 'VerticalAlignment','middle', 'HorizontalAlignment','center', 'FontSize',12);
    end
end % nDist
if strcmpi(format,'numerosity')
    ys = max(zeroCurve.mean(2:4))+.08;
    line([1.1 2.9], [ys ys]+.1, 'Color','k', 'LineWidth',1)
    text(2, ys+.13,...
        [stars{[10 .05 .01 .001] >= signTest_1vs3}],...
        'Color','k', 'VerticalAlignment','middle', 'HorizontalAlignment','center', 'FontSize',12);
end
for n=1:nNums
    % rankTest
    if rankTest(n) < .05
        text(nums(n), -.05,...
            [stars{[10 .05 .01 .001] >= rankTest(n)}],...
            'Color','k', 'VerticalAlignment','middle', 'HorizontalAlignment','center', 'FontSize',12);        
    end
end % n nums

% .. axis properties ..
legend([tr,rn],{'True','Random'}, 'Location','NorthEast')
set(axZeroCurve,...
    'xlim',[nums(1)-.25 nums(end)+.25], 'xTick',nums, ...
    'ylim',[-.1 1.1],                       'yTick',0:.25:1, ...
    'ticklength',[.03 .01], 'FontSize',10)
xlabel('Numerical distance', 'FontSize',12)
ylabel('Norm. firing rate',  'FontSize',12)
axTunCurves.XRuler.TickLabelGapOffset = -1;
