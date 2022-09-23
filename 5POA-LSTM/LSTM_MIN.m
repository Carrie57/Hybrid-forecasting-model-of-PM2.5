%%���ѧϰ�ʡ����������ز㵥Ԫ���ȳ�����
function cost = LSTM_MIN(x)
%rng default;%�̶������
numHiddenUnits = round(x(1)); % ��������Ԫ���� 
options.InitialLearnRate= x(2); % ��ʼѧϰ��
options.MaxEpochs = round(x(3)); % ���ѵ������ 

%options.LearnRateDropFactor=x(5);
%options.LearnRateDropPeriod=round(x(6));
%����
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
numFeatures = size(XTrain,1);  %��������ά��
numResponses =  size(YTrain,1);%�������ά��
numHiddenUnits =round(x(1));%ÿһ��lstm�����д��ڶ�����Ԫ
layers = [ ...
    sequenceInputLayer(numFeatures)%����㣬��������������ά��
    lstmLayer(numHiddenUnits)%lstm�㣬�����Ҫ�������lstm���ļ�������������
    fullyConnectedLayer(numResponses)%ȫ���Ӳ㣬Ҳ���������ά��
    regressionLayer];%�ò���˵�����ڽ��лع����⣬�����Ƿ�������
options = trainingOptions('adam', ...%���������Ϊ��adam��
    'MaxEpochs',round(x(3)), ...%���������������������������200��ѵ����ÿ��ѵ����������������
    'MiniBatchSize',16, ...%����ÿ��ѵ����������С���εĴ�С�� 
    'InitialLearnRate',x(2), ...%ѧϰ��
    'GradientThreshold',1, ...%�����ݶȷ�ֵΪ1 ����ֹ�ݶȱ�ը
    'Verbose',1);%��������ͼ
% ��Ҫ����֤���ľ��� �����������
% options = trainingOptions('adam', ...
%     'MaxEpochs',20, ...
%     'MiniBatchSize',16, ...
%     'InitialLearnRate',0.005, ...
%     'GradientThreshold',1, ...
%     'Verbose',false, ...
%     'Plots','training-progress',...
%     'ValidationData',{XTest,YTest});

%��ÿ��ʱ�䲽����Ԥ�⣬����ÿ��Ԥ�⣬ʹ��ǰһʱ�䲽�Ĺ۲�ֵԤ����һ��ʱ�䲽��
%�� predictAndUpdateState �� 'ExecutionEnvironment' ѡ������Ϊ 'cpu'��
net = trainNetwork(XTrain,YTrain,layers,options);

numTimeStepsTest = size(XTest,2);
for i = 1:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,XTest(:,i),'ExecutionEnvironment','cpu');
end

%YPred = predict(net,YTrain);
 
% ���
%YPred=double(YPred');%�����n*1��single�����ݣ�Ҫת��Ϊ1*n��double��������ʽ
%Ypred= double(YPred')
% ����һ��
predict_value=method('reverse',YPred,output_ps);
predict_value=double(predict_value);
true_value=method('reverse',YTest,output_ps);
true_value=double(true_value);

  
    rmse=sqrt(mean((true_value(1,:)-predict_value(1,:)).^2));


cost = rmse ;%  costΪĿ�꺯�� ��Ŀ�꺯��Ϊrmse����
end


%rmse ��С  cost=1/rmse   ���� acc ��� cost


