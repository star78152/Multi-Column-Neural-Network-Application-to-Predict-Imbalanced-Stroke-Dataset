clc;clear;

dirs=dir('.\OtherNet\*.mat');   % �ΧA�ݭn���ؿ��H�ΰ��ɦW�����CŪ���Y�ӥؿ������w���O�ɮצC��A��^���c�}�C�C
dircell=struct2cell(dirs)' ;    % ���c��(struct)�ഫ�����M���O(cell)�A��m�@�U�O���ɦW���C�ƦC�C
filenames=dircell(:,1);   % �Ĥ@�C�O�ɦW
num_data = dir('*.mat');
num = length(num_data)
str_filenames = string(filenames);

load('testdata')

x_predict = test_input';
y_original = test_output';

all_str_filenames = [];
for i=1:4
conv_name = char(filenames(i))
all_str_filenames = [all_str_filenames;cellstr(conv_name(1:end-4))];
all_str_filenames = string(all_str_filenames);
load (char(filenames(i)));%a

y_predict = sim(net,x_predict) ; %�����w����
prediction_correct = 0; %�w�����T��
process_y = [];  %���Y���G��0,1

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

[X, Y, Tpr, AUCpr] = perfcurve(y_original, y_predict, 1, 'xCrit', 'reca', 'yCrit', 'prec');  
plot(X, Y);
xlabel('Recall')
ylabel('Precision')
title('Best-PRC')

hold on 

end
hold on
load('Oversam_SCG_net_1-2-614','Oversam_SCG_net3');
load('SMOTE_LM_net_1-1-42','SMOTE_LM_net4');
load('Undersampling_SCG_net_1-1-16','Undersam_SCG_net7');

%net3
net3_y_predict = sim(Oversam_SCG_net3,x_predict) ; %����3�w����
%net4
net4_y_predict = sim(SMOTE_LM_net4,x_predict) ; %����4�w����
%net7
net7_y_predict = sim(Undersam_SCG_net7,x_predict) ; %����7�w����

y_predict = ((net3_y_predict*1.095) + (net4_y_predict*1.095) + (net7_y_predict*1.09))/3 ; %- �վ�L�v��6 �������T��: 17564    %%�D��F1���Ƴ̨Ϊ�����


%�p��PRC
% figure('name','Precision-Recall (PR) Curve');
[X, Y, Tpr, AUCpr] = perfcurve(y_original, y_predict, 1, 'xCrit', 'reca', 'yCrit', 'prec');  
plot(X, Y);

hold on
% legStr = {all_str_filenames(1,1),all_str_filenames(2,1),all_str_filenames(3,1),all_str_filenames(4,1),all_str_filenames(5,1),all_str_filenames(6,1),all_str_filenames(7,1),all_str_filenames(8,1)};
legStr = {'Best-Oversampling','Best-Undersampling','Best-SMOTE','Best-Unbalanced','Best-Vote'};
legend(legStr, 'location', 'southeast' );

saveas(gcf,'PRC', 'jpg')