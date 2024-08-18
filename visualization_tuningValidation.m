clear, clc

format = 'numerosity'; % must be 'numerosity' or 'numeral'

load(['data_tuningValidation_',format,'.mat'])

%%

close all
fig = figure('Units','centimeters', 'Position',[2 2 7 13.5], 'Color','w');

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
          
% --- tuning curves ---

axTunCurves = axes('Units','centimeters', 'Position',[1.5 10 5 3]);
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

% --- cross-validation matrix ---

axMatrix = axes('Units','centimeters', 'Position',[1.5 3 5 5]);
hold on

% .. data ..
for r=1:numel(nums)
    for c=1:numel(nums)
        if matrix(r,c) ~= 0
            plot(r,c, 'Marker','o', 'MarkerSize', 1.2*matrix(r,c), 'MarkerFaceColor','b', 'MarkerEdgeColor','b')
        end
    end
end

% .. axis properties ..
set(axMatrix,...
    'xlim',[0 10.5], 'xtick',1:10, 'xticklabel',0:9,...
    'ylim',[0 10.5], 'ytick',1:10, 'yticklabel',0:9,...
    'ticklength',[.03 .01], 'FontSize',10)
xlabel('1st Half of data', 'FontSize',12)
ylabel('2nd Half of data', 'FontSize',12)
title(['Preferred ',format], 'FontSize',12)

% .. legend ..
axLegend = axes('Units','centimeters', 'Position',[.25 .5 6.5 1]);
hold on, box on
sizes = [1 2 5 10 15];
for x=1:5
    text(x-sizes(x)*.026,0,num2str(sizes(x)),'HorizontalAlignment','right');
    plot(x,0,'Marker','o', 'MarkerSize',1.2*sizes(x), 'MarkerFaceColor','b', 'MarkerEdgeColor','b');
end
text(.6,1,'Number of units:');
set(axLegend,'xtick','','ytick','')
axis([0.5 5.4 -1.3 1.5])
