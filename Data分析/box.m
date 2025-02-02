clc; clear all;close all;

load('testdata')
figname = 'Test-Number of Age'
rng default  % For reproducibility
x = test_input;
b = x(:,2);

% figure
% subplot(2,1,1)
boxplot(b)
title(figname);

% subplot(2,1,2)
% boxplot(x,'PlotStyle','compact')
% title(figname);

saveas(gcf,figname, 'jpg')