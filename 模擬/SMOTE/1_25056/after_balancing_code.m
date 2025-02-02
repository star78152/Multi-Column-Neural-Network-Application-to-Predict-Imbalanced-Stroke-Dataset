clc;            clear;

%���w�H�U�{���X�ҨϥΪ��`��
datasetIndex = 1;               %�Ψӫ��w���P����ƶ�, 4���ؼ�
algorithmIndex = 1;           %�Ψӫ��w���P���t��k, 10���ؼ�
runIndex = 1e+1;                %�Ψӫ��w�]�h��run, 1e+4���ؼ�
epochPerRun = 1e+4;        %�Ψӵ��w�C��run���V�m�|�N���ƤW��
maxFail = 1e+4;                 %�Ψӵ��w�u���Ҽ˥��~�t�W�X�V�m�˥��~�t�����ƤW���v; equal to epochPerRun, 1e+4
minGrad = 1e-40;                %�Ψӵ��w�u���I�L���v���̤p��, 1e-20
%hiddenLayerSize = 1;            %���w���üh���`�I�Ӽ�
hiddenIndex =8;                     %�ؼ�9

load ('train_data(25056)')          %���J���w����ƶ�
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
                
                perfAve = 0;       %�ΥH�֭p�Urun���������G
                tic  %�p�ɶ}�l
                for j = 1:runIndex  
                        fid = fopen('result.txt', 'at');
                        
                        net = patternnet(hiddenLayerSize, trainFcn);    % Create a Pattern Recognition Network
                        net.layers{2}.transferFcn = 'elliotsig'; %'tansig';                   %'logsig'; %����patternnet�w�]����X�h������, elliotsig: for GPU computing, a bit better perf cf tansig
                        
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
                        perfAve = perfAve + performance;              %�֥[�Urun���������G
                        
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
                end %���wrun�Ӽ�
                toc
                elapsedTime = toc; %�p�ɵ���
                fprintf(fidAll, '\n\n\t Elapsed time is %.4f seconds.', elapsedTime);  %�g�J�ӰV�m�t��k������ɶ�
                perfAve = perfAve/runIndex;                   %�p��U�V�m�t��k�������į�
                fprintf(fidAll, '\n\t (trained by %s, with %d hidden nodes) averaged performance: %.5f (std %.3f) in total %4d runs', trainFcn, hiddenLayerSize, perfAve, std(perf), runIndex);
        end %hiddenIndex
end % Choose a Training Function

fclose(fidAll);  %����
delete(gcp('nocreate'));

