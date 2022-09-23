%%%%%%清除上一步的数据缓存，避免影响下一步运行的结果。一般加不加都可以。
clear all
close all
clc
warning('off');
load data_PM25
data_PM25=data_PM25';
load imf
[m,~]=size(imf);%%%%求imf的行数，即m的值(m=8)
pe=zeros(1,m);%%%%定义一个零矩阵pe，1行m列
figure(1)
for i=1:m   %%%%循环，代表i从1到m,每次增加1
    subplot(m,1,i)%%%%将画布分成m行，1列，表示画第i个图
    plot(imf(i,:))%%%%%画第i个imf(i,:)的第i行的数据（imf(i,:)表时imf的第i行数据）
end
load IMF1_VMD  %%%%加载IMF1_VMD文件(5行366列)
% IMF1_VMD=SAM_VMD(imf(1,:),1,5000,0.3,5,0,1,1e-7);
%% IMF1经过VMD分解的结果
figure(2)
for i=1:5    %%%%循环，代表i从1到5,每次增加1
    subplot(5,1,i)%%%%将画布分成5行，1列，表示画第i个图
    plot(IMF1_VMD(i,:))%%%%%画第i个IMF1_VMD(i,:)的第i行的数据
end
%%  使用DE-ELM进行预测
load DE_ELM  %%%%加载DE_ELM文件(12行66列)
% DE_ELM=zeros(m+4,66);
    figure(3) %低频预测对比
for i=1:m-1  %低频分量预测  %%%%循环，代表i从1到7,每次增加1
  %  DE_ELM(i,:)= ML_DE_ELM(imf(i+1,:),66,20,1);    
    subplot(7,1,i)%%%%将画布分成7行，1列，表示画第i个图
    plot(1:66,DE_ELM(i,:),'*-b')
    %%%%1：66表示横轴的数据范围是1：66，每次增加1；
    %%%DE_ELM(i,:)表示纵轴的数据值是DE_ELM(i,:)中的第i行的数据
    hold on
    plot(1:66,imf(i+1,end-66+1:end),'o-r')
    legend('预测值','实际值')
end

 figure(4) %低频预测对比
for i=1:5
%     DE_ELM(m-1+i,:)= ML_DE_ELM(IMF1_VMD(i,:),66,20,1);
    subplot(5,1,i)
    plot(1:66,DE_ELM(m-1+i,:),'*-b')
    hold on
    plot(1:66,IMF1_VMD(i,end-66+1:end),'o-r')
    legend('预测值','实际值')
end


%% 与ELM进行对比，对比DE-ELM和ELM
delay=5;
test_num=66;
load ELMs
% ELMs=zeros(m+4,66);
    figure(5) %低频预测对比
for i=1:m-1  %低频分量预测
%     test_data=imf(i+1,end-test_num-delay+1:end); %测试集
%     train_data=imf(i+1,1:end-test_num);%训练集
%     %% 数据扩充
%     for j=1:delay
%         train_input(j,:)=train_data(j:end-delay-1+j);
%         test_input(j,:)=test_data(j:end-delay-1+j);
%     end
%     train_output=train_data(delay+1:end);
%     test_output=test_data(delay+1:end);
% %% ELM创建/训练
% 
% [IW,B,LW,TF,TYPE] = elmtrain(train_input,train_output,16,'sig',0);
% 
% %% ELM仿真测试
% tn_sim = elmpredict(test_input,IW,B,LW,TF,TYPE);
%     ELMs(i,:)= tn_sim;    
    subplot(7,1,i)
    plot(1:66,ELMs(i,:),'*-b')
    hold on
    plot(1:66,imf(i+1,end-66+1:end),'o-r')
    legend('预测值','实际值')
end

 figure %低频预测对比
for i=1:5
%         test_data=IMF1_VMD(i,end-test_num-delay+1:end); %测试集
%     train_data=IMF1_VMD(i,1:end-test_num);%训练集
%     %% 数据扩充
%     for j=1:delay
%         train_input(j,:)=train_data(j:end-delay-1+j);
%         test_input(j,:)=test_data(j:end-delay-1+j);
%     end
%     train_output=train_data(delay+1:end);
%     test_output=test_data(delay+1:end);
% %% ELM创建/训练
% 
% [IW,B,LW,TF,TYPE] = elmtrain(train_input,train_output,16,'sig',0);
% 
% %% ELM仿真测试
% tn_sim = elmpredict(test_input,IW,B,LW,TF,TYPE);
%     ELMs(m-1+i,:)= tn_sim;    
    subplot(5,1,i)
    plot(1:66,ELMs(m-1+i,:),'*-b')
    hold on
    plot(1:66,IMF1_VMD(i,end-66+1:end),'o-r')
    legend('预测值','实际值')
end

%% 对IMF1不进行二次分解，直接使用DE-ELM进行预测  并进行对比
IMF1_DE_ELM= ML_DE_ELM(imf(1,:),66,20,1);   

figure
plot(1:66,imf(1,end-66+1:end),'ko-')
hold on
plot(1:66,sum(DE_ELM(m:end,:),1),'b*-')
hold on
plot(1:66,IMF1_DE_ELM,'r^-')
legend('IMF1的图像','先使用VMD分解IMF1，再预测','直接使用DE-ELM对IMF预测')
figure
plot(1:66,(imf(1,end-66+1:end)-sum(DE_ELM(m:end,:),1)).^2/66,'bo-')
hold on
plot(1:66,(imf(1,end-66+1:end)-IMF1_DE_ELM).^2/66,'r*-')
legend('先使用VMD分解IMF1，再预测的预测误差','直接使用DE-ELM对IMF预测的预测误差')





%% 计算误差
figure
plot(1:66,((sum(DE_ELM,1)-sum(imf(:,end-66+1:end),1)).^2)/66,'b*-')
hold on
plot(1:66,((sum(ELMs,1)-sum(imf(:,end-66+1:end),1)).^2)/66,'ro-')
legend('FEEMD-DE-ELM的预测误差','FEEMD-ELM的预测误差')

%% 进行重构     MAE(平均绝对误差)
FEEMD_DE_ELM_CG=abs(sum((sum(DE_ELM,1)-sum(imf(:,end-66+1:end),1))))/66 %DE-ELM的预测误差
FEEMD_ELM_CG=abs(sum((sum(ELMs,1)-sum(imf(:,end-66+1:end),1))))/66%ELM的预测误差

% RMSE（均方根误差）
FEEMD_DE_ELM_CG=abs(sqrt(sum((sum(DE_ELM,1)-sum(imf(:,end-66+1:end),1)).^2)/700))
FEEMD_ELM_CG=abs(sqrt(sum((sum(ELMs,1)-sum(imf(:,end-66+1:end),1)).^2)/700))

