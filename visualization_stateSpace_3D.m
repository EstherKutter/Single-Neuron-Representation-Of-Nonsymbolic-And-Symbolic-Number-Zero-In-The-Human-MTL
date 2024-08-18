clear, clc

format = 'numerosity'; % must be 'numerosity' or 'numeral'

load(['data_stateSpace_3D_',format,'.mat'])

%%

close all
fig = figure('Units','centimeters', 'Position',[.3 2 7 18.2], 'Color','w');

nums     = 0:9;
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

phaseNames_3D = {'Fix.','Smpl.','Del.','Resp.'};
phaseIdx      = [ 1      16      41     71    81];
          
phaseNames            = {'Fix.','Sample','Delay'};
phaseIntervals        = [10 25 50 80];
phaseIntervalLabels   = phaseIntervals - 15;
phaseNamePositions    = phaseIntervals(1:end-1)+diff(phaseIntervals)/2;
color_phaseBoundaries = repmat(.75,1,3);

if strcmpi(format,'numerosity')
    ylimEval = [.4 .6];
    ylimDists = [0 1150];
    viw = [-15 77]; xlimSpace = [-480 880]; ylimSpace = [-430 300]; zlimSpace = [-330 160]; dr = [12 -73]; do = [1 2 3];
    pos_phaseLabels = ...
        [-383.041  66.703    108.860; ...
         -227.851  173.171   8.310;...
         690.937   1.022     101.800;...
         22.325    -317.183  17.842];
else
    ylimEval = [.6 .8];
    ylimDists = [0 450];
    viw = [-165 61]; xlimSpace = [-109 224]; ylimSpace = [-314 113]; zlimSpace = [-232 53]; dr = [-11 71]; do = [2 1 3];
    pos_phaseLabels = ...
        [-14.986  -5.407    -148.319;...
         95.789   18.192    -143.151;...
         78.684   -115.131  171.058;...
         -36.193  -137.064  -103.873];
end

% --- 3D trajectories ---

axSpace3D = axes('Units','centimeters', 'Position',[1 12.2 5.5 5.5], 'Color',[.7 .7 .7]);
hold on

% .. data ..
% trajectories + phaseBoundaries
for n=1:numel(nums)
    for p=1:numel(phaseNames_3D)
        % phaseBoundary
        plot3(trajectories_3D(n).X(phaseIdx(p)),trajectories_3D(n).Y(phaseIdx(p)),trajectories_3D(n).Z(phaseIdx(p)),...
            'Marker','o', 'MarkerSize',5, 'Color','k', 'MarkerFaceColor',colors_num(n,:))
        % trajectory
        plot3(trajectories_3D(n).X(phaseIdx(p):phaseIdx(p+1)),trajectories_3D(n).Y(phaseIdx(p):phaseIdx(p+1)),trajectories_3D(n).Z(phaseIdx(p):phaseIdx(p+1)),...
            'LineStyle','-', 'LineWidth',1.5, 'Color',colors_num(n,:));
    end
end
% phase labels
for p=1:numel(phaseNames_3D)
    text(pos_phaseLabels(p,1),pos_phaseLabels(p,2),pos_phaseLabels(p,3),...
        ['    ',phaseNames_3D{p}],...
        'FontSize',10, 'FontAngle','Italic')
end

% .. axis properties ..
view(viw)
set(axSpace3D,...
    'xlim',xlimSpace, 'ylim',ylimSpace, 'zlim',zlimSpace,...
    'xticklabel',[], 'yticklabel',[], 'zticklabel',[],...
    'ticklength',[.03 .01], 'FontSize',10)
grid on
xlabel(['Dimension ',num2str(do(1))], 'FontSize',12, 'VerticalAlignment','bottom', 'Rotation',dr(1))
ylabel(['Dimension ',num2str(do(2))], 'FontSize',12, 'VerticalAlignment','bottom', 'Rotation',dr(2))
zlabel(['Dim.',num2str(do(3))],       'FontSize',12)

% --- legend ---

axLegend = axes('Units','centimeters', 'Position',[.25 11 6.5 .8]);
hold on

% data
text(axLegend,...
    1.5,.6, 'Number:',...
    'HorizontalAlignment','left', 'VerticalAlignment','bottom', 'FontSize',8)
for n=1:numel(nums)
    rectangle(axLegend,...
        'Position',[1.5*n 0 .6 .5], 'FaceColor',colors_num(n,:))
    text(axLegend,...
        1.5*n+.7,.3, num2str(nums(n)),...
        'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize',8)
end % n numbers

% axis properties
set(axLegend, 'xtick',[], 'ytick',[])
box on
axis(axLegend, [1.3 1.5*(numel(nums)+.9) , -.2 1.3]) % with class

% --- Euclidean distances: countable numbers ---

axDistsCount = axes('Units','centimeters', 'Position',[1.5 7.5 5 3]);
hold on

% .. data ..
for n=1:nNums-2
    plot(euclDists_count(n,:),'Color',colors_num(n+1,:), 'LineWidth',2)
end
% phase boundaries & labels
plot(axDistsCount,...
    repmat(phaseIntervals(2:end),2,1), repmat([0 1200],numel(phaseIntervals)-1,1)',...
    'LineStyle',':', 'LineWidth',1.5, 'Color',color_phaseBoundaries)
for lp=1:3
    text(axDistsCount,...
        phaseNamePositions(lp),-.02, phaseNames{lp},...
        'HorizontalAlignment','center', 'VerticalAlignment','top', 'FontSize',8, 'FontAngle','Italic');
end

% axis properties
set(axDistsCount,...
    'xlim',[10 85], 'xtick',phaseIntervals, 'xticklabel',{'-300','  0','500','1100'}, ...
    'ylim',ylimDists,...
    'ticklength',[.03 .01], 'FontSize',10)
xtickangle(90)
xlabel('Time (ms)',      'FontSize',12)
ylabel('Eucl. Distance', 'FontSize',12)

% --- Euclidean distances: zero ---

axDistsZero = axes('Units','centimeters', 'Position',[1.5 2.75 5 3]);
hold on

% .. data ..
for n=1:nNums-1
    plot(euclDists_zero(n,:),'Color',colors_num(n+1,:), 'LineWidth',2)
end
% phase boundaries & labels
plot(axDistsZero,...
    repmat(phaseIntervals(2:end),2,1), repmat([0 1200],numel(phaseIntervals)-1,1)',...
    'LineStyle',':', 'LineWidth',1.5, 'Color',color_phaseBoundaries)
for lp=1:3
    text(axDistsZero,...
        phaseNamePositions(lp),-.02, phaseNames{lp},...
        'HorizontalAlignment','center', 'VerticalAlignment','top', 'FontSize',8, 'FontAngle','Italic');
end

% axis properties
set(axDistsZero,...
    'xlim',[10 85], 'xtick',phaseIntervals, 'xticklabel',{'-300','  0','500','1100'}, ...
    'ylim',ylimDists,...
    'ticklength',[.03 .01], 'FontSize',10)
xtickangle(90)
xlabel('Time (ms)',      'FontSize',12)
ylabel('Eucl. Distance', 'FontSize',12)

% --- legend ---

axLegend = axes('Units','centimeters', 'Position',[.25 .25 6.5 .8]);
hold on

% data
text(axLegend,...
    1.5,.6, 'Numerical distance:',...
    'HorizontalAlignment','left', 'VerticalAlignment','bottom', 'FontSize',8)
for n=1:numel(nums)
    line(axLegend,...
        [1.5*n 1.5*n+.6],[.25 .25], 'Color',colors_num(n,:), 'LineWidth',2)
    text(axLegend,...
        1.5*n+.7,.3, num2str(nums(n)),...
        'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize',8)
end % n numbers

% axis properties
set(axLegend, 'xtick',[], 'ytick',[])
box on
axis(axLegend, [1.3 1.5*(numel(nums)+.9) , -.2 1.3]) % with class
