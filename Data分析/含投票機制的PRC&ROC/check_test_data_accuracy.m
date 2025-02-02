%% ������_SCG
clc;clear;
close all;
load('net_1-1-27')
load('testdata')

fid = fopen('result.txt', 'wt');

x_predict = test_input';
y_original = test_output';
y_predict = sim(net,x_predict) ; %�����w����
prediction_correct = 0; %�w�����T��
process_y = [];  %���Y���G��0,1
data_size = length(y_original); %��data�j�p
arr_size = length(y_predict);


for i=1:arr_size
    if y_predict(i) >= 0.5
        process_y(i) = 1;
        if y_original(i)-process_y(i) == 0;
            prediction_correct = prediction_correct+1;
        end
    else
        process_y(i)=0;
        if y_original(i)-process_y(i) == 0;
            prediction_correct = prediction_correct+1;
        end
    end
        
end

dif_y = y_original-process_y; %�������~�t: ���ڭȬ�0, �w���Ȭ�1, �۴��ȷ|��-1, �Y�i�o����FP�F�Ϥ���ڬ�1, �w���Ȭ�0��, �Y�i�o����FN�C
FP = 0; %False Positive(����)
FN = 0; %False Negative(���t)
TN = 0; %True Negative (�u�t)
TP = 0; %True Positive (�u��)

for dif=1:data_size
    if dif_y(dif) == -1
        FP = FP+1;
   
    elseif dif_y(dif) == 1
       FN = FN+1;
    end              
    
    if y_original(dif) == process_y(dif) && y_original(dif) == 0
        TN = TN+1;
    elseif y_original(dif) == process_y(dif) && y_original(dif) == 1
        TP = TP+1;
    end
    
end
figure('name','Receiver Operating Characteristic (ROC) Curve');
[xTr, yTr, TTr, aucTr] = perfcurve(y_original, y_predict, 1); %�p��ROC
plot(xTr, yTr);
xlabel('FPR');
ylabel('TPR');
title(['ROC-Unbalanced-SCG-HD1(AUC: ' num2str(aucTr) ')'])
saveas(gcf,'ROC', 'fig')
saveas(gcf,'ROC', 'jpg')

figure('name','Precision-Recall (PR) Curve');
[X, Y, Tpr, AUCpr] = perfcurve(y_original, y_predict, 1, 'xCrit', 'reca', 'yCrit', 'prec');  %�p��PRC

plot(X, Y);
xlabel('Recall')
ylabel('Precision')
title(['Precision-recall curve (AUC: ' num2str(AUCpr) ')']) 
xlim([0, 1])
ylim([0, 1])
saveas(gcf,'PRC', 'fig')
saveas(gcf,'PRC', 'jpg')


figure; plotconfusion(y_original,y_predict);
saveas(gcf,'Confusion Matrix', 'jpg')

acc = prediction_correct/data_size; % Accuracy �ǽT�v
precision = TP/(TP+FP); % ��T�v
recall = TP/(TP+FN); % �l�^�v
F1_score = 2/((1/precision)+(1/recall));
fprintf(fid, '\n\t Test data�`��: %d, �������T��: %d, �ǽT�v: %.6f \n\t True Positive: %d, True Negative: %d, False Positive: %d, False Negative: %d \n\t ��T�v: %.6f, �l�^�v: %.6f, F1 score: %.6f, ROC-AUC: %.6f, PRC-AUC: %.6f', data_size,  prediction_correct, acc, TP, TN, FP, FN, precision, recall, F1_score, aucTr, AUCpr);

fclose(fid);