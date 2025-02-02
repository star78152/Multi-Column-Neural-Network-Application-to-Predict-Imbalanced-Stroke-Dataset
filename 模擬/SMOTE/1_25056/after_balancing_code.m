clc;            clear;

%給定以下程式碼所使用的常數
datasetIndex = 1;               %用來指定不同的資料集, 4為目標
algorithmIndex = 1;           %用來指定不同的演算法, 10為目標
runIndex = 1e+1;                %用來指定跑多少run, 1e+4為目標
epochPerRun = 1e+4;        %用來給定每個run的訓練疊代次數上限
maxFail = 1e+4;                 %用來給定「驗證樣本誤差超出訓練樣本誤差的次數上限」; equal to epochPerRun, 1e+4
minGrad = 1e-40;                %用來給定「單點微分」的最小值, 1e-20
%hiddenLayerSize = 1;            %給定隱藏層的節點個數
hiddenIndex =8;                     %目標9

load ('train_data(25056)')          %載入指定的資料集
x = train_input;         t = train_output;

resultAll = 'resultAll.txt';
fidAll = fopen(resultAll, 'wt');                 fprintf(fidAll, '\n');
perf(1:runIndex)=0;

% Choose a Training Function
for i = 1:algorithmIndex
        if i==2,             trainFcn = 'trainlm';
        elseif i==1,         trainFcn = 'trainscg';
        elseif i==10,         trainFcn = 'traincgb';
        elseif i==4,         trainFcn = 'traincgf';
        elseif i==5,         trainFcn = 'traincgp';
        elseif i==6,         trainFcn = 'trainbfg';
        elseif i==7,         trainFcn = 'traingd';
        elseif i==8,         trainFcn = 'traingda';
        elseif i==9,         trainFcn = 'traingdm';
        elseif i==3,        trainFcn = 'traingdx';
        end
        
        for k = 1:hiddenIndex
                if k==1,        hiddenLayerSize = 1;
                elseif k==2,        hiddenLayerSize = 2;
                elseif k==3,        hiddenLayerSize = 5;
                elseif k==4,        hiddenLayerSize = 10;
                elseif k==5,        hiddenLayerSize = 15;
                elseif k==6,        hiddenLayerSize = 20;
                elseif k==7,        hiddenLayerSize = 25;
                elseif k==8,        hiddenLayerSize = 50;
                elseif k==9,        hiddenLayerSize = 100;
                end
                
                perfAve = 0;       %用以累計各run的模擬結果
                tic  %計時開始
                for j = 1:runIndex  
                        fid = fopen('result.txt', 'at');
                        
                        net = patternnet(hiddenLayerSize, trainFcn);    % Create a Pattern Recognition Network
                        net.layers{2}.transferFcn = 'elliotsig'; %'tansig';                   %'logsig'; %改變patternnet預設的輸出層移轉函數, elliotsig: for GPU computing, a bit better perf cf tansig
                        
                        % Choose Input and Output Pre/Post-Processing Functions
                        net.input.processFcns = {'removeconstantrows','mapminmax'};
                        net.output.processFcns = {'removeconstantrows','mapminmax'};
                        
                        % Setup Division of Data for Training, Validation, Testing
                        net.divideFcn = 'dividerand';  % Divide data randomly
                        net.divideMode = 'sample';  % Divide up every sample
                        net.divideParam.trainRatio = 70/100;    
                        net.divideParam.valRatio = 15/100;
                        net.divideParam.testRatio = 15/100;
                        
                        % Choose a Performance Function
                        net.performFcn = 'mse';
                        
                        % Train the Network
                        net.trainParam.max_fail = maxFail;
                        net.trainParam.epochs = epochPerRun;
                        net.trainParam.min_grad = minGrad;
                        net.trainParam.showWindow= true;
                        %[net,tr] = train(net,x,t);
                                                 [net,tr] = train(net,x,t, 'useParallel', 'yes'); %++++++++++
                        %                        [net,tr] = train(net,x,t, 'useParallel','yes', 'useGPU','yes','showResources','yes');
                        %                         [net,tr] = train(net,x,t, 'useGPU','yes','showResources','yes');
                        %                         [net,tr] = train(net,x,t, 'useGPU','only','showResources','yes'); %some CPU cores are idle!
                        %                         if trainFcn == 'trainlm',               [net,tr] = train(net,x,t);
                        %                         else                                                  [net,tr] = train(net,x,t, 'useGPU','yes');
                        %                         end
                        
                        % Test the Network
                        y = net(x);
                        e = gsubtract(t,y);
                        performance = perform(net,t,y);
                        perf(j) = performance;%for calculation of standard deviation
                        fprintf(fid, '\n\t (algo %d - hidden %d) run_%4d  performance: %.5f',i,  k, j, performance); %+++++++++++++++
                        perfAve = perfAve + performance;              %累加各run的模擬結果
                        
                        % Recalculate Training, Validation and Test Performance
                        trainTargets = t .* tr.trainMask{1};
                        valTargets = t .* tr.valMask{1};
                        testTargets = t .* tr.testMask{1};
                        trainPerformance = perform(net,trainTargets,y);
                        valPerformance = perform(net,valTargets,y);
                        testPerformance = perform(net,testTargets,y);
                        
                        fprintf(fid, '\t\t TR: %.5f, VAL: %5f, TS: %5f', trainPerformance,  valPerformance, testPerformance); 
                        parSave(sprintf('net_%d-%d-%d.mat', i, k, j), net, performance, trainPerformance,  valPerformance, testPerformance);
                        fclose(fid);
                end %給定run個數
                toc
                elapsedTime = toc; %計時結束
                fprintf(fidAll, '\n\n\t Elapsed time is %.4f seconds.', elapsedTime);  %寫入該訓練演算法的執行時間
                perfAve = perfAve/runIndex;                   %計算各訓練演算法的平均效能
                fprintf(fidAll, '\n\t (trained by %s, with %d hidden nodes) averaged performance: %.5f (std %.3f) in total %4d runs', trainFcn, hiddenLayerSize, perfAve, std(perf), runIndex);
        end %hiddenIndex
end % Choose a Training Function

fclose(fidAll);  %關檔
delete(gcp('nocreate'));

