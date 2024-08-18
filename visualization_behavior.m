clear, clc

task = 'main'; % must be 'main' or 'control'

load(['data_behavior_',task,'.mat'])

%%

% close all
fig = figure('Units','centimeters', 'Position',[2 2 7 12.5], 'Color','w');

nums  = 0:9;
nNums = numel(nums);
colors_two = [0 0.4470 0.7410;... % blueish
              0 0.5961 0.2745];   % greenish
      
% --- error rates ---

axErrorRates = axes('Units','centimeters', 'Position',[1.5 7 5 5]);
hold on

% .. data ..
plot([-1 10],[50 50],'k:')
for m=1:2
    er(m) = plot(nums,correctResponses.mean(:,m),...
        'Marker','o', 'Color',colors_two(m,:), 'MarkerFaceColor',colors_two(m,:));
    errorbar(nums,correctResponses.mean(:,m),correctResponses.sem(:,m),...
        'LineStyle','none', 'Color',colors_two(m,:))    
end

% .. axis properties ..
set(axErrorRates,...
    'xlim',[-.5 9.5], 'xtick',0:10,...
    'ylim',[0 100],'ytick',0:20:100, 'FontSize',10)
ylabel('Correct responses (%)', 'FontSize',12)
xlabel('Sample number',  'FontSize',12)

legend(er,{'Nonsymbolic','Numeral'}, 'Orientation','Horizontal', 'Location','NorthOutside')

% --- reaction times ---

axReactionTimes = axes('Units','centimeters', 'Position',[1.5 1.5 5 4]);
hold on

% .. data ..
for m=1:2
    plot(nums,reactionTimes.median(:,m),...
        'Marker','o', 'Color',colors_two(m,:), 'MarkerFaceColor',colors_two(m,:), 'LineStyle','-');
    errorbar(nums,reactionTimes.median(:,m),reactionTimes.sem(:,m),...
        'LineStyle','none', 'Color',colors_two(m,:))
end

% .. axis properties ..
set(axReactionTimes,...
    'xlim',[-.5 9.5], 'xtick',0:10,...
    'ylim',[300 1700],'ytick',0:300:1800, 'FontSize',10)
ylabel('Reaction times (ms)', 'FontSize',12)
xlabel('Sample number',       'FontSize',12)

