%%最佳学习率、层数、隐藏层单元数等超参数
function cost = LSTM_MIN(x)
%rng default;%固定随机数
numHiddenUnits = round(x(1)); % 隐含层神经元数量 
options.InitialLearnRate= x(2); % 初始学习率
options.MaxEpochs = round(x(3)); % 最大训练次数 

%options.LearnRateDropFactor=x(5);
%options.LearnRateDropPeriod=round(x(6));
%层数
%load BILSTM
%popsize = 5;  

%% define the Deeper LSTM networks
%% LSTM


%%
load testdata
global input
global  output
n=144;
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
numHiddenUnits =round(x(1));%每一层lstm网络中存在多少神经元
layers = [ ...
    sequenceInputLayer(numFeatures)%输入层，参数是输入特征维数
    lstmLayer(numHiddenUnits)%lstm层，如果想要构建多层lstm，改几个参数就行了
    fullyConnectedLayer(numResponses)%全连接层，也就是输出的维数
    regressionLayer];%该参数说明是在进行回归问题，而不是分类问题
options = trainingOptions('adam', ...%求解器设置为’adam’
    'MaxEpochs',round(x(3)), ...%这个参数是最大迭代次数，即进行200次训练，每次训练后更新神经网络参数
    'MiniBatchSize',16, ...%用于每次训练迭代的最小批次的大小。 
    'InitialLearnRate',x(2), ...%学习率
    'GradientThreshold',1, ...%设置梯度阀值为1 ，防止梯度爆炸
    'Verbose',1);%构建曲线图
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

  
    rmse=sqrt(mean((true_value(1,:)-predict_value(1,:)).^2));


cost = rmse ;%  cost为目标函数 ，目标函数为rmse倒数
end


%rmse 最小  cost=1/rmse   现在 acc 最大 cost


