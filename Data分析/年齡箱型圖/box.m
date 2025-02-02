clc; clear all;close all;

load('traindata')
titlename = 'Age Distribution of Training Dataset'
rng default  % For reproducibility
x = train_input;
b = x(:,2);

figure
subplot(1,2,1)
boxplot(b)
title(titlename);

subplot(1,2,2)
load('testdata')
titlename = 'Age Distribution of Test Dataset'
rng default  % For reproducibility
xx = test_input;
c = xx(:,2);
boxplot(c)
title(titlename);

saveas(gcf,'Age distribution of data sets', 'jpg')