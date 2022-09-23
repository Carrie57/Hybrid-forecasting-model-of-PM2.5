%% LSTM

clc;clear;close all
%%
%data=xlsread('imf(1).csv');%imf(1).csv   �滻���execl����  ������7200�У�17������1�������
%��ôexcel���棬Ӧ����7200 *18  ���ݾ���
% input=data(:,17)';
% output=data(:,18)';
load testdata
%����������� ������input��12*156 ��12�����������156���������� 
%output��1*156��1�������������156����������
n=1168;% n����ѵ����������
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
numHiddenUnits =200;%ÿһ��lstm�����д��ڶ�����Ԫ
layers = [ ...
    sequenceInputLayer(numFeatures)%����㣬��������������ά��
    lstmLayer(numHiddenUnits)%lstm�㣬�����Ҫ�������lstm���ļ�������������
    fullyConnectedLayer(numResponses)%ȫ���Ӳ㣬Ҳ���������ά��
    regressionLayer];%�ò���˵�����ڽ��лع����⣬�����Ƿ�������
options = trainingOptions('adam', ...%���������Ϊ��adam��
    'MaxEpochs',50, ...%���������������������������200��ѵ����ÿ��ѵ����������������
    'MiniBatchSize',16, ...%����ÿ��ѵ����������С���εĴ�С�� 
    'InitialLearnRate',0.005, ...%ѧϰ��
    'GradientThreshold',1, ...%�����ݶȷ�ֵΪ1 ����ֹ�ݶȱ�ը
    'Verbose',false, ...%�����������Ϊtrue�����й�ѵ�����ȵ���Ϣ������ӡ��������С�
    'Plots','training-progress');%��������ͼ
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

    for i=1
    figure
    plot(true_value(i,:),'-*','linewidth',2)
    hold on
    plot(predict_value(i,:),'-s','linewidth',2)
    legend('ʵ��ֵ','Ԥ��ֵ')
    grid on
    title('LSTMԤ����')
%     ylim([-500 500])
    rmse=sqrt(mean((true_value(i,:)-predict_value(i,:)).^2));

    disp(['-----------',num2str(i),'------------'])
    disp(['���������(RMSE)��',num2str(rmse)])
    mae=mean(abs(true_value(i,:)-predict_value(i,:)));
    disp(['ƽ��������MAE����',num2str(mae)])
    mape=mean(abs((true_value(i,:)-predict_value(i,:))./true_value(i,:)));
    disp(['ƽ����԰ٷ���MAPE����',num2str(mape*100),'%'])
    r2=R2(true_value(i,:),predict_value(i,:));
    disp(['R-square����ϵ����R2����',num2str(r2)])
    end
    
 save file1