%% щ布诀
clc;clear;
close all;

load('Oversam_SCG_net_1-2-614','Oversam_SCG_net3');
load('SMOTE_LM_net_1-1-42','SMOTE_LM_net4');
load('Undersampling_SCG_net_1-1-16','Undersam_SCG_net7');
load('testdata')

fid = fopen('result.txt', 'wt');
x_predict = test_input';
y_original = test_output';
prediction_correct = 0; %箇代タ絋计
data_size = length(y_original); %data
process_y = [];  %盢挡狦罽0,1


process_net3_y_predict = [];
process_net4_y_predict = [];
process_net7_y_predict = [];

%net3
net3_y_predict = sim(Oversam_SCG_net3,x_predict) ; %呼隔3箇代
% net3_prediction_correct = 0; %箇代タ絋计
for net3 = 1:data_size
    if net3_y_predict(net3) >=0.5
        process_net3_y_predict(net3) = 1;
    else
        process_net3_y_predict(net3) = 0 ;
    end
end
%net4
net4_y_predict = sim(SMOTE_LM_net4,x_predict) ; %呼隔4箇代
% net4_prediction_correct = 0; %箇代タ絋计
for net4 = 1:data_size
    if net4_y_predict(net4) >=0.5
        process_net4_y_predict(net4) = 1;
    else
        process_net4_y_predict(net4) = 0 ;
    end
end
%net7
net7_y_predict = sim(Undersam_SCG_net7,x_predict) ; %呼隔7箇代
% net7_prediction_correct = 0; %箇代タ絋计
for net7 = 1:data_size
    if net7_y_predict(net7) >=0.5
        process_net7_y_predict(net7) = 1;
    else
        process_net7_y_predict(net7) = 0 ;
    end
end

y_predict = ((net3_y_predict*1.095) + (net4_y_predict*1.095) + (net7_y_predict*1.09))/3 ; %- 秸俱筁舦6 だ摸タ絋计: 17564    %%珼匡F1だ计程ㄎ呼隔


%璸衡ROC
figure('name','Receiver Operating Characteristic (ROC) Curve');
[xTr, yTr, TTr, aucTr] = perfcurve(y_original, y_predict, 1); 
plot(xTr, yTr);
xlabel('FPR');
ylabel('TPR');
title(['ROC-Vote (AUC: ' num2str(aucTr) ')'])
xlim([0, 1])
ylim([0, 1])
saveas(gcf,'ROC', 'fig')
saveas(gcf,'ROC', 'jpg')

%璸衡PRC
figure('name','Precision-Recall (PR) Curve');
[X, Y, Tpr, AUCpr] = perfcurve(y_original, y_predict, 1, 'xCrit', 'reca', 'yCrit', 'prec');  
plot(X, Y);
xlabel('Recall')
ylabel('Precision')
title(['PRC-Vote (AUC: ' num2str(AUCpr) ')']) 
xlim([0, 1])
ylim([0, 1])
saveas(gcf,'PRC', 'fig')
saveas(gcf,'PRC', 'jpg')

close all;