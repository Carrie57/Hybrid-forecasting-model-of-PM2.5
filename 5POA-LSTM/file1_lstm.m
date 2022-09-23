%% LSTM

clc;clear;close all
%%
%data=xlsread('imf(1).csv');%imf(1).csv   替换你的execl数据  加入是7200行，17变量，1个因变量
%那么excel里面，应该是7200 *18  数据矩阵
% input=data(:,17)';
% output=data(:,18)';
load testdata
%导入测试数据 ，其中input是12*156 ，12代表变量数，156代表样本数 
%output是1*156，1代表因变量数，156代表样本数
n=1168;% n代表训练样本数量
train_x=input(:,1:n);
train_y=output(:,1:n);
test_x=input(:,n+1:end);
test_y=output(:,n+1:end);
method=@mapminmax;
% method=@mapstd;
[train_x,train_ps]=method(train_x);
test_x=method('apply',test_x,train_ps);
[train_y,output_ps]=method(train_y);
test_y=method('apply',test_y,output_ps);
XTrain = double(train_x) ;
XTest  = double(test_x) ;
YTrain = double(train_y);
YTest  = double(test_y);
numFeatures = size(XTrain,1);  %输入特征维数
numResponses =  size(YTrain,1);%输出特征维数
numHiddenUnits =200;%每一层lstm网络中存在多少神经元
layers = [ ...
    sequenceInputLayer(numFeatures)%输入层，参数是输入特征维数
    lstmLayer(numHiddenUnits)%lstm层，如果想要构建多层lstm，改几个参数就行了
    fullyConnectedLayer(numResponses)%全连接层，也就是输出的维数
    regressionLayer];%该参数说明是在进行回归问题，而不是分类问题
options = trainingOptions('adam', ...%求解器设置为’adam’
    'MaxEpochs',50, ...%这个参数是最大迭代次数，即进行200次训练，每次训练后更新神经网络参数
    'MiniBatchSize',16, ...%用于每次训练迭代的最小批次的大小。 
    'InitialLearnRate',0.005, ...%学习率
    'GradientThreshold',1, ...%设置梯度阀值为1 ，防止梯度爆炸
    'Verbose',false, ...%如果将其设置为true，则有关训练进度的信息将被打印到命令窗口中。
    'Plots','training-progress');%构建曲线图
% 需要看验证集的精度 就用下面这个
% options = trainingOptions('adam', ...
%     'MaxEpochs',20, ...
%     'MiniBatchSize',16, ...
%     'InitialLearnRate',0.005, ...
%     'GradientThreshold',1, ...
%     'Verbose',false, ...
%     'Plots','training-progress',...
%     'ValidationData',{XTest,YTest});

%对每个时间步进行预测，对于每次预测，使用前一时间步的观测值预测下一个时间步。
%将 predictAndUpdateState 的 'ExecutionEnvironment' 选项设置为 'cpu'。
net = trainNetwork(XTrain,YTrain,layers,options);

numTimeStepsTest = size(XTest,2);
for i = 1:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,XTest(:,i),'ExecutionEnvironment','cpu');
end

%YPred = predict(net,YTrain);
 
% 结果
%YPred=double(YPred');%输出是n*1的single型数据，要转换为1*n的double是数据形式
%Ypred= double(YPred')
% 反归一化
predict_value=method('reverse',YPred,output_ps);
predict_value=double(predict_value);
true_value=method('reverse',YTest,output_ps);
true_value=double(true_value);

    for i=1
    figure
    plot(true_value(i,:),'-*','linewidth',2)
    hold on
    plot(predict_value(i,:),'-s','linewidth',2)
    legend('实际值','预测值')
    grid on
    title('LSTM预测结果')
%     ylim([-500 500])
    rmse=sqrt(mean((true_value(i,:)-predict_value(i,:)).^2));

    disp(['-----------',num2str(i),'------------'])
    disp(['均方根误差(RMSE)：',num2str(rmse)])
    mae=mean(abs(true_value(i,:)-predict_value(i,:)));
    disp(['平均绝对误差（MAE）：',num2str(mae)])
    mape=mean(abs((true_value(i,:)-predict_value(i,:))./true_value(i,:)));
    disp(['平均相对百分误差（MAPE）：',num2str(mape*100),'%'])
    r2=R2(true_value(i,:),predict_value(i,:));
    disp(['R-square决定系数（R2）：',num2str(r2)])
    end
    
 save file1