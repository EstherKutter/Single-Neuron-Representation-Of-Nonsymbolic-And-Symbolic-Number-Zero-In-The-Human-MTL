% clear, clc

format = 'numerosity'; % must be 'numerosity' or 'numeral'

load(['data_stateSpace_2D_',format,'.mat'])

%%

close all
fig = figure('Units','centimeters', 'Position',[2 2 7 24], 'Color','w');

nums     = 0:4;
nums_all = 0:9;
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

if strcmpi(format,'numerosity')
    class = {'empty set','countable number'};
    ylimEval = [.4 .6];
    viw = [-90 -90]; xlimSpace = [-33 26]; ylimSpace = [-23 39];
else
    class = {'zero','countable number'};
    ylimEval = [.6 .8];
    viw = [0 -90]; xlimSpace = [-9 17]; ylimSpace = [-9 12];
end
colors_class = [0 0 0 ; 1 1 1];

colors_two = [0      0.4470 0.7410;... % reddish
              0.8500 0.3250 0.0980];   % blueish

% --- 2D neural states : small numbers ---

axSpace2D_all = axes('Units','centimeters', 'Position',[1 18 5.5 5.5], 'Color',[.7 .7 .7]);
hold on

% .. data ..
% average
for n=1:numel(nums_all)
    % cluster mean
     plot(neuralStates_2D.clusterMean(n).X,neuralStates_2D.clusterMean(n).Y,...
        'LineStyle', 'none', 'Marker', 's', ...
        'MarkerFaceColor', colors_num(n,:), 'MarkerEdgeColor', [.9 .9 .9], ...
        'MarkerSize', 8);
    % ellipse
    plot(neuralStates_2D.ellipse(n).X,neuralStates_2D.ellipse(n).Y,...
        'Color', colors_num(n,:));    
end % n nums
% per trial
for n=1:numel(nums_all)
    for t=1:16
        plot(neuralStates_2D.trials(n).X(t),neuralStates_2D.trials(n).Y(t),...
            'LineStyle','none',...
            'Marker','o', 'MarkerSize',4, ...
            'MarkerFaceColor',colors_num(n,:), 'MarkerEdgeColor',colors_num(n,:))
    end
end
% cutout
rectangle('Position',neuralStates_2D.cutout,'LineStyle','--')

% .. axis properties ..
set(axSpace2D_all, 'xlim',xlimSpace, 'ylim',ylimSpace, 'xtick',[], 'ytick',[])
xlabel('Dimension 1', 'FontSize',12);
ylabel('Dimension 2', 'FontSize',12)
view(viw)

% --- legend ---

axLegend = axes('Units','centimeters', 'Position',[.25 16 6.5 1]);
hold on

% prefNum
text(axLegend,...
    1.4,.3, 'Number:',...
    'HorizontalAlignment','right', 'VerticalAlignment','middle', 'FontSize',8)
for n=1:numel(nums_all)
    rectangle(axLegend,...
        'Position',[1.5*n 0 .6 .5], 'FaceColor',colors_num(n,:))
    text(axLegend,...
        1.5*n+.7,.3, num2str(nums_all(n)),...
        'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize',8)
end % f factors

% class labels
text(axLegend,...
    1.4,-.4, 'Label:',...
    'HorizontalAlignment','right', 'VerticalAlignment','middle', 'FontSize',8)
for c=1:2
    rectangle(axLegend,...
        'Position',[1.5*(4*c-3) -.7 .6 .5], 'FaceColor',colors_class(c,:))
    text(axLegend,...
        1.5*(4*c-3)+.7,-.4, class{c},...
        'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize',8)
end

% axis properties
set(axLegend, 'xtick',[], 'ytick',[])
box on
axis(axLegend, [-2 1.5*(numel(nums_all)+.9) , -.85 .65]) % with class

% --- 2D neural states : small numbers ---

axSpace2D = axes('Units','centimeters', 'Position',[1 10 5.5 5.5], 'Color',[.7 .7 .7]);
hold on

% average
for n=1:nNums
    % cluster mean
     plot(neuralStates_2D.clusterMean(n).X,neuralStates_2D.clusterMean(n).Y,...
        'LineStyle', 'none', 'Marker', 's', ...
        'MarkerFaceColor', colors_num(n,:), 'MarkerEdgeColor', [.9 .9 .9], ...
        'MarkerSize', 8);
    % ellipse
    plot(neuralStates_2D.ellipse(n).X,neuralStates_2D.ellipse(n).Y,...
        'Color', colors_num(n,:));    
end % n nums

% per trial
for n=1:nNums
    for t=1:16
        plot(neuralStates_2D.trials(n).X(t),neuralStates_2D.trials(n).Y(t),...
            'LineStyle','none',...
            'Marker','o', 'MarkerSize',4, ...
            'MarkerFaceColor',colors_num(n,:), 'MarkerEdgeColor',colors_class(neuralStates_2D.trials(n).labels(t),:))
    end
end
% centroids
for c=1:2
    plot(neuralStates_2D.classCentroids(c).X,neuralStates_2D.classCentroids(c).Y,...
        'LineWidth',3, 'LineStyle','none', 'Marker','x', 'MarkerSize',10, 'MarkerEdgeColor',colors_class(c,:), 'MarkerFaceColor','k')
end

% .. axis properties ..
set(axSpace2D,...
    'xlim',[neuralStates_2D.cutout(1) neuralStates_2D.cutout(1)+neuralStates_2D.cutout(3)], 'xtick',[], ...
    'ylim',[neuralStates_2D.cutout(2) neuralStates_2D.cutout(2)+neuralStates_2D.cutout(4)], 'ytick',[])
xlabel('Dimension 1', 'FontSize',12);
ylabel('Dimension 2', 'FontSize',12)
view(viw)

% --- evaluation criterion ---

axClusEval = axes('Units','centimeters', 'Position',[2 6 3.5 3]);

% (1) calinskiHarabasz criterion

yyaxis left
hold on
axClusEval.YAxis(1).Color = colors_two(1,:);

% .. data ..
errorbar(1:nNums, clusterEvaluation.calinskiHarabasz.mean, clusterEvaluation.calinskiHarabasz.sem,...
    'LineWidth',1.5, 'Color',colors_two(1,:))
plot(clusterEvaluation.calinskiHarabasz.bestClass,clusterEvaluation.calinskiHarabasz.mean(clusterEvaluation.calinskiHarabasz.bestClass),...
    'Marker','*', 'MarkerSize',10, 'LineWidth',1.5, 'Color',colors_two(1,:))

% .. axis properties ..
set(axClusEval,...
    'ylim',[floor(min(clusterEvaluation.calinskiHarabasz.mean)) , ceil(max(clusterEvaluation.calinskiHarabasz.mean))],...
    'ticklength',[.03 .01], 'FontSize',10)
ylabel({'Calinski-Harabasz','index'}, 'FontSize',12)

% (2) gap criterion

yyaxis right
hold on
axClusEval.YAxis(2).Color = colors_two(2,:);

% .. data ..
errorbar(1:nNums, clusterEvaluation.gap.mean,clusterEvaluation.gap.sem,...
    'LineWidth',1.5, 'Color',colors_two(2,:))
plot(clusterEvaluation.gap.bestClass,clusterEvaluation.gap.mean(clusterEvaluation.gap.bestClass),...
    'Marker','*', 'MarkerSize',10, 'LineWidth',1.5, 'Color',colors_two(2,:))

% .. axis properties ..
set(axClusEval,...
    'xlim',[.5 nNums+.5], 'xtick',1:nNums, ...
    'ylim',ylimEval,...
    'ticklength',[.03 .01], 'FontSize',10);
ylabel('Gap value',       'FontSize',12)
axClusEval.XRuler.TickLabelGapOffset = -1;
xlabel('No. of clusters', 'FontSize',12)

% --- clustering ---

axClass = axes('Units','centimeters', 'Position',[2 1.5 4.5 3]);
hold on

% .. data ..
% class 
b = bar(axClass, nums, proportionClassA.mean,'stacked');
for c=1:2
    set(b(c), 'FaceColor',colors_class(c,:), 'BarWidth',.6);
end
% error bar from cross-validation
errorbar(axClass, nums, proportionClassA.mean(:,1),proportionClassA.std(:,2),zeros(nNums,1),...
    'LineStyle','none', 'LineWidth',1.5, 'Color',colors_class(2,:));
errorbar(axClass, nums, proportionClassA.mean(:,1),zeros(nNums,1),proportionClassA.std(:,1),...
    'LineStyle','none', 'LineWidth',1.5, 'Color',colors_class(1,:));
% boundary in num-color
% boundary in num-color
for n=1:nNums
    bar(axClass, nums(n), 1, 'EdgeColor',colors_num(n,:), 'FaceColor','none', 'Linewidth',1.5, 'BarWidth',.65);
end

% .. axis properties ..
set(axClass,...
    'xlim',[nums(1)-.75 nums(end)+.75], 'xtick',0:10,...
    'ylim',[0 1],                       'ytick',0:.25:1, 'yticklabel',0:25:100,...
    'ticklength',[.03 .01], 'FontSize',10)
ylabel({'Trials (%)','assigned to class'}, 'FontSize',12)
xlabel('Sample number',                    'FontSize',12)
axClass.XRuler.TickLabelGapOffset = -2;