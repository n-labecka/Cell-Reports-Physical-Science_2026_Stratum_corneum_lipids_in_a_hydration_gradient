clear all
close all
clc

set(0, 'DefaultAxesFontSize', 14);


folder = '/Users/labecka/Documents/3.Lab Work/0.LU_Skin Lipids/Data /Scattering/GANSHA/Nikol/Paper';
cd(folder);

% Get list of all CSV files
csvFiles = dir(fullfile(folder, '*.csv'));

% Preallocate cell array
extractedData = cell(length(csvFiles), 1);

% Loop through files
for k = 1:length(csvFiles)
    filePath = fullfile(folder, csvFiles(k).name);
    
    % Clean filename for use in variable names
    [~, baseFileName, ~] = fileparts(csvFiles(k).name);  % Remove path and extension
    baseFileName = matlab.lang.makeValidName(baseFileName);  % Ensure valid variable name

    % Define custom variable names using filename
    varNames = { ...
        char(baseFileName + "_q"), ...
        char(baseFileName + "_Int"), ...
        char(baseFileName + "_dInt") ...
        };    
    % Set import options
    opts = delimitedTextImportOptions("NumVariables", 3);
    opts.DataLines = [7, 406];
    opts.Delimiter = ",";
    opts.VariableNames = varNames;
    opts.VariableTypes = ["double", "double", "double"];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts.ConsecutiveDelimitersRule = "join";

    % Try to import and store data
    try
        tbl = readtable(filePath, opts);
        extractedData{k} = tbl;
        fprintf('Imported: %s\n', csvFiles(k).name);
    catch ME
        warning('Failed to import %s: %s', csvFiles(k).name, ME.message);
        extractedData{k} = [];
    end
end


%% To extract data from table as each column name. 

for i = 1:length(extractedData)
    tbl = extractedData{i};
    varNames = tbl.Properties.VariableNames;

    for j = 1:2 %length(varNames)
        varName = varNames{j};          % Get the column name (char)
        data = tbl.(varName);           % Extract column as a double
        % Multiply first column values by 10
        
        if j == 1
            data = data * 10;
        end
        
        if j == 2
            data = log10(data);
        end
        
        % Assign to base workspace
        assignin('base', varName, data);  % Save to base workspace
    end
end


%% Baseline corrections

s_i =280;
s_f =297; 
w_i =70;
w_f =78;

baseline = 0.5;

%CorrSAXS
x21219_Int = x21219_Int-mean(x21219_Int(s_i:s_f,1))+baseline;
x21221_Int = x21221_Int-mean(x21221_Int(s_i:s_f,1))+baseline;
x21227_Int = x21227_Int-mean(x21227_Int(s_i:s_f,1))+baseline;
x21231_Int = x21231_Int-mean(x21231_Int(s_i:s_f,1))+baseline;
x21233_Int = x21233_Int-mean(x21233_Int(s_i:s_f,1))+baseline;

x21288_Int = x21288_Int-mean(x21288_Int(s_i:s_f,1))+baseline;
x21290_Int = x21290_Int-mean(x21290_Int(s_i:s_f,1))+baseline;
x21296_Int = x21296_Int-mean(x21296_Int(s_i:s_f,1))+baseline;
x21298_Int = x21298_Int-mean(x21298_Int(s_i:s_f,1))+baseline;
x21300_Int = x21300_Int-mean(x21300_Int(s_i:s_f,1))+baseline;


%CorrWAXS
x21220_Int = x21220_Int-mean(x21220_Int(w_i:w_f,1))+baseline;
x21222_Int = x21222_Int-mean(x21222_Int(w_i:w_f,1))+baseline;
x21228_Int = x21228_Int-mean(x21228_Int(w_i:w_f,1))+baseline;
x21232_Int = x21232_Int-mean(x21232_Int(w_i:w_f,1))+baseline;
x21234_Int = x21234_Int-mean(x21234_Int(w_i:w_f,1))+baseline;

x21289_Int = x21289_Int-mean(x21289_Int(w_i:w_f,1))+baseline;
x21291_Int = x21291_Int-mean(x21291_Int(w_i:w_f,1))+baseline;
x21297_Int = x21297_Int-mean(x21297_Int(w_i:w_f,1))+baseline;
x21299_Int = x21299_Int-mean(x21299_Int(w_i:w_f,1))+baseline;
x21301_Int = x21301_Int-mean(x21301_Int(w_i:w_f,1))+baseline;


%% 

%{
colors = [
    0, 0.4470, 0.7410;   % blue
    0.6350, 0.0780, 0.1840;   % red
    0.9000, 0.5500, 0.0000;   % Orange
    0.400, 0.620, 0.130;   % green
    0.4940, 0.1840, 0.5560    % purple
];

%colors = colors.*0.9;
%colors_light = [];
colors_light = min(colors * 1.6, 1); 

%{
colors = [
    0.0000, 0.4470, 0.7410;   % Blue
    0.8500, 0.3250, 0.0980;   % Orange
    0.6350, 0.0780, 0.1840;   % Red
    0.9290, 0.4900, 0.6900;   % Pink
    0.4660, 0.6740, 0.1880    % Green
];
%}
%}

orange_palette = [
    1.0, 0.75, 0.5;   % light peach
    1.0, 0.6, 0.4;  % soft orange
    1.0, 0.5, 0.2;   % bright orange
    0.95, 0.5, 0.1;  % rich orange
    0.8, 0.3, 0.1; % burnt orange
    0.65, 0.25, 0.05    % dark orange/brown
];

blue_palette = [
    0.6, 0.8, 1.0;   % light baby blue
    0.4, 0.7, 1.0;    % soft blue
    0.2, 0.6, 1.0;     % bright blue
    0.1, 0.5, 0.95;    % rich blue
    0.05, 0.3, 0.8;   % deep blue
    0.05, 0.1, 0.5;     % dark blue
];

%% Dry samples 

%%ADD lines
d_Lam1 = 143; %134.6; %d_spac1(1,6);
mm1 = (2.*pi.*10)./d_Lam1;
n_Lam = [1,2,3,4,5,6,7];
x_Lam1 = mm1.*n_Lam; 
%y_Lam = 12.*ones(1,size(n_Lam,2));

d_Lam2 = 144; %134.6; %d_spac1(1,6);
mm2 = (2.*pi.*10)./d_Lam2;
n_Lam2 = [1,2,3,4,5];
x_Lam2 = mm2.*n_Lam2;

d_Lam3 = 49; %134.6; %d_spac1(1,6);
mm2 = (2.*pi.*10)./d_Lam3;
n_Lam3 = [1,2,3,4];
x_Lam3 = mm2.*n_Lam3;


SpacingV = linspace(-0.15,2.65,5);
%SpacingV = linspace(0,0,5);

y_final = 5;
%graph_width = 800;
graph_width = 600;
%graph_hight = 250;
graph_hight = 300;

f2b = figure ;
set(gcf, 'Position', [300, 300, graph_width, graph_hight]);  % [x, y, width, height]

subplot(1,4,1:3);
%p1 = plot(x21219_q(1:end),x21219_Int(1:end)+SpacingV(1,1),'color',orange_palette(1,:),'linewidth',2);
%p2 = plot(x21221_q(1:end),x21221_Int(1:end)+SpacingV(1,2),'color',orange_palette(2,:),'linewidth',2);
p3 = plot(x21227_q(1:end),x21227_Int(1:end)+SpacingV(1,1),'color',orange_palette(3,:),'linewidth',2);
hold on 
p4 = plot(x21231_q(1:end),x21231_Int(1:end)+SpacingV(1,2),'color',orange_palette(4,:),'linewidth',2);
p5 = plot(x21233_q(1:end),x21233_Int(1:end)+SpacingV(1,3),'color',orange_palette(5,:),'linewidth',2);


%pLam = plot(x_Lam,y_Lam,'r*','MarkerSize',8,'LineWidth',2);
for ci = 1:1:size(n_Lam,2)
    pLam1 = plot([x_Lam1(ci) x_Lam1(ci)],[y_final-5 y_final],'k-','MarkerSize',8,'LineWidth',1);
end

%{
for ci = 1:1:size(n_Lam2,2)
    pLam2 = plot([x_Lam2(ci) x_Lam2(ci)],[y_final-5 y_final],'r-','MarkerSize',8,'LineWidth',2);
end
%}
%{
for ci = 1:1:size(n_Lam3,2)
    pLam3 = plot([x_Lam3(ci) x_Lam3(ci)],[y_final-1 y_final],'g-','MarkerSize',8,'LineWidth',2);
end
%}
%}
%}

hold off

%grid minor 
%legend([p1 p2 p3 p4 p5],'32C','45C','68C','d45C','d32C');
%xlabel('q [1/nm]');
%ylabel('log(I) [a.u] ');
ylim([0 y_final]);
xlim([0 4.4]);   %X and Y-limits of the axes
set(gca,'XMinorTick','on');
%set(gca,'YMinorTick','on');
set(gca,'TickDir','out');

subplot(1,4,4);
%plot(x21220_q(1:end),x21220_Int(1:end)+SpacingV(1,1),'color',orange_palette(1,:),'linewidth',2);
%hold on 
%plot(x21222_q(1:end),x21222_Int(1:end)+SpacingV(1,2),'color',orange_palette(2,:),'linewidth',2);
plot(x21228_q(1:end),x21228_Int(1:end)+SpacingV(1,1),'color',orange_palette(3,:),'linewidth',2);
hold on 
plot(x21232_q(1:end),x21232_Int(1:end)+SpacingV(1,2),'color',orange_palette(4,:),'linewidth',2);
plot(x21234_q(1:end),x21234_Int(1:end)+SpacingV(1,3),'color',orange_palette(5,:),'linewidth',2);
hold off

%grid minor 
%xlabel('q [1/nm]');
%ylabel('log(I)');
ylim([0 y_final]);
xlim([8 22]);
set(gca,'XMinorTick','on');
%set(gca,'YMinorTick','on');
set(gca,'TickDir','out');
%sgtitle('DRY scan');

set(findall(gcf,'-property','FontSize'),'FontSize',14)
%print(f2b,sprintf('SWAXS_2d_DRY_3x'), '-dsvg');
%print(f2b,sprintf('SWAXS_2d_DRY_3x_line'), '-dsvg');



%% WET SAMPLES -----------------------------------

%%ADD lines
d_Lam1 = 136; %134.6; %d_spac1(1,6);
mm1 = (2.*pi.*10)./d_Lam1;
n_Lam = [1,2,3,4,5,6,7];
x_Lam1 = mm1.*n_Lam; 
%y_Lam = 12.*ones(1,size(n_Lam,2));

d_Lam2 = 105; %134.6; %d_spac1(1,6);
mm2 = (2.*pi.*10)./d_Lam2;
n_Lam2 = [1,2,3,4,5];
x_Lam2 = mm2.*n_Lam2;

%{
d_Lam3 = 45; %134.6; %d_spac1(1,6);
mm2 = (2.*pi.*10)./d_Lam3;
n_Lam3 = [1,2];
x_Lam3 = mm2.*n_Lam3;
%}

SpacingV = linspace(0,3,5);
%SpacingV = linspace(0,0,5);
y_final = 5;

f4 = figure ;
set(gcf, 'Position', [300, 300, graph_width, graph_hight]);  % [x, y, width, height]

subplot(1,4,1:3);
%p1 = plot(x21288_q(1:end),x21288_Int(1:end)+SpacingV(1,1),'color',blue_palette(1,:),'linewidth',2);
%hold on 
%p2 = plot(x21290_q(1:end),x21290_Int(1:end)+SpacingV(1,2),'color',blue_palette(2,:),'linewidth',2);
p3 = plot(x21296_q(1:end),x21296_Int(1:end)+SpacingV(1,1),'color',blue_palette(3,:),'linewidth',2);
hold on 
p4 = plot(x21298_q(1:end),x21298_Int(1:end)+SpacingV(1,2),'color',blue_palette(4,:),'linewidth',2);
p5 = plot(x21300_q(1:end),x21300_Int(1:end)+SpacingV(1,3),'color',blue_palette(5,:),'linewidth',2);


%pLam = plot(x_Lam,y_Lam,'r*','MarkerSize',8,'LineWidth',2);
for ci = 1:1:size(n_Lam,2)
    pLam1 = plot([x_Lam1(ci) x_Lam1(ci)],[y_final-5 y_final],'k-','MarkerSize',8,'LineWidth',1);
end
%{
for ci = 1:1:size(n_Lam2,2)
    pLam2 = plot([x_Lam2(ci) x_Lam2(ci)],[y_final-3 y_final],'r-','MarkerSize',8,'LineWidth',2);
end
%}
%{
for ci = 1:1:size(n_Lam3,2)
    pLam3 = plot([x_Lam3(ci) x_Lam3(ci)],[y_final-1 y_final],'g-','MarkerSize',8,'LineWidth',2);
end
%}
%}
hold off

%grid minor 

%legend([p1 p2 p3 p4 p5],'32C','45C','68C','d45C','d32C');
%xlabel('q [1/nm]');
%ylabel('log(I) [a.u] ');
%ylim([0 y_final]);
ylim([0 y_final]);
xlim([0 4.4]);   %X and Y-limits of the axes

set(gca,'XMinorTick','on');
%set(gca,'YMinorTick','on');
set(gca,'TickDir','out');


subplot(1,4,4);
%p1 = plot(x21289_q(1:end),x21289_Int(1:end)+SpacingV(1,1),'color',blue_palette(1,:),'linewidth',2);
%hold on 
%p2 = plot(x21291_q(1:end),x21291_Int(1:end)+SpacingV(1,2),'color',blue_palette(2,:),'linewidth',2);
p3 = plot(x21297_q(1:end),x21297_Int(1:end)+SpacingV(1,1),'color',blue_palette(3,:),'linewidth',2);
hold on 
p4 = plot(x21299_q(1:end),x21299_Int(1:end)+SpacingV(1,2),'color',blue_palette(4,:),'linewidth',2);
p5 = plot(x21301_q(1:end),x21301_Int(1:end)+SpacingV(1,3),'color',blue_palette(5,:),'linewidth',2);
hold off

%grid minor 

%xlabel('q [1/nm]');
%ylabel('log(I)');
%ylim([0 y_final]);
ylim([0 y_final]);
xlim([8 22]);
set(gca,'XMinorTick','on');
%set(gca,'YMinorTick','on');
set(gca,'TickDir','out');
%sgtitle('WET scan');

set(findall(gcf,'-property','FontSize'),'FontSize',14)
%print(f4,sprintf('SWAXS_2d_WET_3x'), '-dsvg');
%print(f4,sprintf('SWAXS_2d_WET_3x_line'), '-dsvg');

%%  LOG SCALE  Dry 

%%ADD lines
d_Lam1 = 143; %134.6; %d_spac1(1,6);
mm1 = (2.*pi.*10)./d_Lam1;
n_Lam = [1,2,3,4,5,6,7];
x_Lam1 = mm1.*n_Lam; 
%y_Lam = 12.*ones(1,size(n_Lam,2));

d_Lam2 = 144; %134.6; %d_spac1(1,6);
mm2 = (2.*pi.*10)./d_Lam2;
n_Lam2 = [1,2,3,4,5];
x_Lam2 = mm2.*n_Lam2;

d_Lam3 = 49; %134.6; %d_spac1(1,6);
mm2 = (2.*pi.*10)./d_Lam3;
n_Lam3 = [1,2,3,4];
x_Lam3 = mm2.*n_Lam3;


SpacingV = linspace(-0.15,2.65,5);
%SpacingV = linspace(0,0,5);

y_final = 5;
%graph_width = 800;
graph_width = 600;
%graph_hight = 250;
graph_hight = 300;

f2b = figure ;
set(gcf, 'Position', [300, 300, graph_width, graph_hight]);  % [x, y, width, height]

subplot(1,4,1:3);
%p1 = plot(x21219_q(1:end),x21219_Int(1:end)+SpacingV(1,1),'color',orange_palette(1,:),'linewidth',2);
%p2 = plot(x21221_q(1:end),x21221_Int(1:end)+SpacingV(1,2),'color',orange_palette(2,:),'linewidth',2);
p3 = semilogy(x21227_q(1:end),10.^(x21227_Int(1:end)+SpacingV(1,1)),'color',orange_palette(3,:),'linewidth',2);
hold on 
p4 = semilogy(x21231_q(1:end),10.^(x21231_Int(1:end)+SpacingV(1,2)),'color',orange_palette(4,:),'linewidth',2);
p5 = semilogy(x21233_q(1:end),10.^(x21233_Int(1:end)+SpacingV(1,3)),'color',orange_palette(5,:),'linewidth',2);

%{
%pLam = plot(x_Lam,y_Lam,'r*','MarkerSize',8,'LineWidth',2);
for ci = 1:1:size(n_Lam,2)
    pLam1 = plot([x_Lam1(ci) x_Lam1(ci)],[y_final-5 y_final],'k-','MarkerSize',8,'LineWidth',1);
end

%{
for ci = 1:1:size(n_Lam2,2)
    pLam2 = plot([x_Lam2(ci) x_Lam2(ci)],[y_final-5 y_final],'r-','MarkerSize',8,'LineWidth',2);
end
%}
%{
for ci = 1:1:size(n_Lam3,2)
    pLam3 = plot([x_Lam3(ci) x_Lam3(ci)],[y_final-1 y_final],'g-','MarkerSize',8,'LineWidth',2);
end
%}
%}
%}

hold off

%grid minor 
%legend([p1 p2 p3 p4 p5],'32C','45C','68C','d45C','d32C');
%xlabel('q [1/nm]');
%ylabel('log(I) [a.u] ');
ylim([10.^0 10.^y_final]);
xlim([0 4.4]);   %X and Y-limits of the axes
set(gca,'XMinorTick','on');
%set(gca,'YMinorTick','on');
set(gca,'TickDir','out');

subplot(1,4,4);
%plot(x21220_q(1:end),x21220_Int(1:end)+SpacingV(1,1),'color',orange_palette(1,:),'linewidth',2);
%hold on 
%plot(x21222_q(1:end),x21222_Int(1:end)+SpacingV(1,2),'color',orange_palette(2,:),'linewidth',2);
semilogy(x21228_q(1:end),10.^(x21228_Int(1:end)+SpacingV(1,1)),'color',orange_palette(3,:),'linewidth',2);
hold on 
semilogy(x21232_q(1:end),10.^(x21232_Int(1:end)+SpacingV(1,2)),'color',orange_palette(4,:),'linewidth',2);
semilogy(x21234_q(1:end),10.^(x21234_Int(1:end)+SpacingV(1,3)),'color',orange_palette(5,:),'linewidth',2);
hold off

%grid minor 
%xlabel('q [1/nm]');
%ylabel('log(I)');
ylim([10.^0 10.^y_final]);
xlim([8 22]);
set(gca,'XMinorTick','on');
%set(gca,'YMinorTick','on');
set(gca,'TickDir','out');
%sgtitle('DRY scan');

set(findall(gcf,'-property','FontSize'),'FontSize',14)
%print(f2b,sprintf('SWAXS_2d_DRY_3x'), '-dsvg');
%print(f2b,sprintf('SWAXS_2d_DRY_3x_line_Log'), '-dsvg');


%% LOG WET SAMPLES -----------------------------------

%%ADD lines
d_Lam1 = 136; %134.6; %d_spac1(1,6);
mm1 = (2.*pi.*10)./d_Lam1;
n_Lam = [1,2,3,4,5,6,7];
x_Lam1 = mm1.*n_Lam; 
%y_Lam = 12.*ones(1,size(n_Lam,2));

d_Lam2 = 105; %134.6; %d_spac1(1,6);
mm2 = (2.*pi.*10)./d_Lam2;
n_Lam2 = [1,2,3,4,5];
x_Lam2 = mm2.*n_Lam2;

%{
d_Lam3 = 45; %134.6; %d_spac1(1,6);
mm2 = (2.*pi.*10)./d_Lam3;
n_Lam3 = [1,2];
x_Lam3 = mm2.*n_Lam3;
%}

SpacingV = linspace(0,3,5);
%SpacingV = linspace(0,0,5);
y_final = 5;

f4 = figure ;
set(gcf, 'Position', [300, 300, graph_width, graph_hight]);  % [x, y, width, height]

subplot(1,4,1:3);
%p1 = plot(x21288_q(1:end),x21288_Int(1:end)+SpacingV(1,1),'color',blue_palette(1,:),'linewidth',2);
%hold on 
%p2 = plot(x21290_q(1:end),x21290_Int(1:end)+SpacingV(1,2),'color',blue_palette(2,:),'linewidth',2);
p3 = semilogy(x21296_q(1:end),10.^(x21296_Int(1:end)+SpacingV(1,1)),'color',blue_palette(3,:),'linewidth',2);
hold on 
p4 = semilogy(x21298_q(1:end),10.^(x21298_Int(1:end)+SpacingV(1,2)),'color',blue_palette(4,:),'linewidth',2);
p5 = semilogy(x21300_q(1:end),10.^(x21300_Int(1:end)+SpacingV(1,3)),'color',blue_palette(5,:),'linewidth',2);

%{
%pLam = plot(x_Lam,y_Lam,'r*','MarkerSize',8,'LineWidth',2);
for ci = 1:1:size(n_Lam,2)
    pLam1 = plot([x_Lam1(ci) x_Lam1(ci)],[y_final-5 y_final],'k-','MarkerSize',8,'LineWidth',1);
end
%{
for ci = 1:1:size(n_Lam2,2)
    pLam2 = plot([x_Lam2(ci) x_Lam2(ci)],[y_final-3 y_final],'r-','MarkerSize',8,'LineWidth',2);
end
%}
%{
for ci = 1:1:size(n_Lam3,2)
    pLam3 = plot([x_Lam3(ci) x_Lam3(ci)],[y_final-1 y_final],'g-','MarkerSize',8,'LineWidth',2);
end
%}
%}
hold off

%grid minor 

%legend([p1 p2 p3 p4 p5],'32C','45C','68C','d45C','d32C');
%xlabel('q [1/nm]');
%ylabel('log(I) [a.u] ');
%ylim([0 y_final]);
ylim([10.^0 10.^y_final]);
xlim([0 4.4]);   %X and Y-limits of the axes

set(gca,'XMinorTick','on');
%set(gca,'YMinorTick','on');
set(gca,'TickDir','out');


subplot(1,4,4);
%p1 = plot(x21289_q(1:end),x21289_Int(1:end)+SpacingV(1,1),'color',blue_palette(1,:),'linewidth',2);
%hold on 
%p2 = plot(x21291_q(1:end),x21291_Int(1:end)+SpacingV(1,2),'color',blue_palette(2,:),'linewidth',2);
p3 = semilogy(x21297_q(1:end),10.^(x21297_Int(1:end)+SpacingV(1,1)),'color',blue_palette(3,:),'linewidth',2);
hold on 
p4 = semilogy(x21299_q(1:end),10.^(x21299_Int(1:end)+SpacingV(1,2)),'color',blue_palette(4,:),'linewidth',2);
p5 = semilogy(x21301_q(1:end),10.^(x21301_Int(1:end)+SpacingV(1,3)),'color',blue_palette(5,:),'linewidth',2);
hold off

%grid minor 

%xlabel('q [1/nm]');
%ylabel('log(I)');
%ylim([0 y_final]);
ylim([10.^0 10.^y_final]);
xlim([8 22]);
set(gca,'XMinorTick','on');
%set(gca,'YMinorTick','on');
set(gca,'TickDir','out');
%sgtitle('WET scan');

set(findall(gcf,'-property','FontSize'),'FontSize',14)
%print(f4,sprintf('SWAXS_2d_WET_3x'), '-dsvg');
print(f4,sprintf('SWAXS_2d_WET_3x_line_log'), '-dsvg');

%% LOG SCALE Zoom in 

%%ADD lines
d_Lam1 = 143; %134.6; %d_spac1(1,6);
mm1 = (2.*pi.*10)./d_Lam1;
n_Lam = [1,2,3,4,5,6];
x_Lam1 = mm1.*n_Lam; 
%y_Lam = 12.*ones(1,size(n_Lam,2));

d_Lam2 = 136; %134.6; %d_spac1(1,6);
%d_Lam2 = 48; %134.6; %d_spac1(1,6);
mm2 = (2.*pi.*10)./d_Lam2;
n_Lam2 = [1,2,3,4,5,6];
x_Lam2 = mm2.*n_Lam2;

%{
d_Lam3 = 143; %134.6; %d_spac1(1,6);
mm2 = (2.*pi.*10)./d_Lam3;
n_Lam3 = [1,2,3,4,5];
x_Lam3 = mm2.*n_Lam3;
%}


SpacingV_norm = linspace(2.5,3,2);

SpacingV_norm = linspace(0,0,2);


f10B = figure ;
set(gcf, 'Position', [300, 300, 320, 250]);  % [x, y, width, height]

%p1 = plot(x21231_q(1:end),x21231_Int_Max_N(1:end)+SpacingV_norm(1,1),'color',orange_palette(4,:),'linewidth',2);
p1 = semilogy(x21233_q(1:end),10.^(x21231_Int(1:end)+SpacingV_norm(1,1)),'color',orange_palette(4,:),'linewidth',2);
hold on 
%p3 = plot(x21298_q(1:end),x21298_Int_Max_N(1:end)+SpacingV_norm(1,1),'color',blue_palette(4,:),'linewidth',2);
p3 = semilogy(x21300_q(1:end),10.^(x21298_Int(1:end)+SpacingV_norm(1,1)),'color',blue_palette(4,:),'linewidth',2);

%{
for ci = 1:1:size(n_Lam,2)
    pLam1 = plot([x_Lam1(ci) x_Lam1(ci)],[0 3],'k-','MarkerSize',8,'LineWidth',1);
end

for ci = 1:1:size(n_Lam2,2)
    pLam2 = plot([x_Lam2(ci) x_Lam2(ci)],[0 3],'r-','MarkerSize',8,'LineWidth',1);
end
%}
%{
for ci = 1:1:size(n_Lam3,2)
    pLam3 = plot([x_Lam3(ci) x_Lam3(ci)],[2.2 5],'g-','MarkerSize',8,'LineWidth',2);
end
%}

hold off

%grid on 
xlabel('q [1/nm]');
ylabel('log(I) [A.U]');
%ylim([0 4]);
xlim([0 2.5]);
%xlim([0 5]);

legend([p1 p3],"45°C Dry","45°C Hydrated");

set(gca,'XMinorTick','on');
%set(gca,'YMinorTick','on');
set(gca,'TickDir','out');
%title('DRY scan');
%sgtitle('DRY scan');

%print(f10B,sprintf('SWAXS_OVERLAP_zoomin_45C_C_noNorm_peak1'), '-dsvg');
%print(f10B,sprintf('SWAXS_OVERLAP_zoomin_45C_C_noNorm_LOG'), '-dsvg');

%% 

%%ADD lines
d_Lam1 = 143; %134.6; %d_spac1(1,6);
mm1 = (2.*pi.*10)./d_Lam1;
n_Lam = [1,2,3,4,5];
x_Lam1 = mm1.*n_Lam; 
%y_Lam = 12.*ones(1,size(n_Lam,2));

d_Lam2 = 45; %134.6; %d_spac1(1,6);
mm2 = (2.*pi.*10)./d_Lam2;
n_Lam2 = [1,2,3,4];
x_Lam2 = mm2.*n_Lam2;

d_Lam3 = 142; %134.6; %d_spac1(1,6);
mm2 = (2.*pi.*10)./d_Lam3;
n_Lam3 = [1,2,3,4,5];
x_Lam3 = mm2.*n_Lam3;


SpacingV_norm = linspace(0,2.5,2);
SpacingV_norm = linspace(0,0,2);

Max_i = 21; Max_f = 23;

x21231_Int_Max_N = x21231_Int - mean(x21231_Int(Max_i:Max_f,1));
x21233_Int_Max_N = x21233_Int - mean(x21233_Int(Max_i:Max_f,1));
x21298_Int_Max_N = x21298_Int - mean(x21298_Int(Max_i:Max_f,1));
x21300_Int_Max_N = x21300_Int - mean(x21300_Int(Max_i:Max_f,1));


f10A = figure ;
set(gcf, 'Position', [300, 300, 320, 250]);  % [x, y, width, height]

%p1 = plot(x21231_q(1:end),x21231_Int_Max_N(1:end)+SpacingV_norm(1,1),'color',orange_palette(4,:),'linewidth',2);
%p2 = plot(x21233_q(1:end),x21233_Int_Max_N(1:end)+SpacingV_norm(1,2),'color',orange_palette(5,:),'linewidth',2);
p2 = semilogy(x21233_q(1:end),10.^(x21233_Int(1:end)+SpacingV_norm(1,2)),'color',orange_palette(5,:),'linewidth',2);
hold on 
%p3 = plot(x21298_q(1:end),x21298_Int_Max_N(1:end)+SpacingV_norm(1,1),'color',blue_palette(4,:),'linewidth',2);
%p4 = plot(x21300_q(1:end),x21300_Int_Max_N(1:end)+SpacingV_norm(1,2),'color',blue_palette(5,:),'linewidth',2);
p4 = semilogy(x21300_q(1:end),10.^(x21300_Int(1:end)+SpacingV_norm(1,2)),'color',blue_palette(5,:),'linewidth',2);

%{
%pLam = plot(x_Lam,y_Lam,'r*','MarkerSize',8,'LineWidth',2);
for ci = 1:1:size(n_Lam,2)
    pLam1 = plot([x_Lam1(ci) x_Lam1(ci)],[0 3],'k-','MarkerSize',8,'LineWidth',1);
end

for ci = 1:1:size(n_Lam2,2)
    pLam2 = plot([x_Lam2(ci) x_Lam2(ci)],[0 3],'r-','MarkerSize',8,'LineWidth',1);
end
%}
%{
for ci = 1:1:size(n_Lam3,2)
    pLam3 = plot([x_Lam3(ci) x_Lam3(ci)],[2.5 5],'g-','MarkerSize',8,'LineWidth',2);
end
%}


hold off



%grid on 
xlabel('q [1/nm]');
ylabel('log(I) [A.U]');
%ylim([0 4]);
%ylim([0 4]);
xlim([0 2.5]);
legend([p2 p4],"32°C Dry","32°C Hydrated");
%legend([p1 p3],"Wet","45'°C Dry","45'°C Wet");

set(gca,'XMinorTick','on');
%set(gca,'YMinorTick','on');
set(gca,'TickDir','out');
%title('DRY scan');
%sgtitle('DRY scan');

%print(f10A,sprintf('SWAXS_OVERLAP_zoomin_32C_C_noNorm_peak1'), '-dsvg');
%print(f10A,sprintf('SWAXS_OVERLAP_zoomin_32C_C_noNorm_LOG'), '-dsvg');
