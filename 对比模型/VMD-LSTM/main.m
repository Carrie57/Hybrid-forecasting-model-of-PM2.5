clc
clear all
true_value=xlsread('预测真实vmd.xlsx','B14:B305');
data_sum=xlsread('预测真实vmd.xlsx','A14:A305');

figure(1)
xx=292;
plot(1:xx,true_value,'r-*',1:xx,data_sum,'b-o');
hold on
set(gca,'FontName','Time New Roman');
legend('PM2.5真实值','CEEMDAN-LSTM PM2.5预测值')
set(gca,'FontName','Time New Roman');xlabel('时间/天');
set(gca,'FontName','Time New Roman');ylabel('PM2.5浓度')

%% 评价指标
N = max(length(true_value));
RMSE=sqrt(mse(true_value - data_sum));
disp(['根均方差(RMSE)：',num2str(RMSE)])

MAE=sum(abs(true_value - data_sum))/N; %   Calculate testing accuracy (RMSE) for regression case
disp(['平均绝对误差（MAE）：',num2str(MAE)])

MAPE1=abs(true_value-data_sum)./true_value;
MAPE=mean(MAPE1,'all');
disp(['平均相对百分误差（MAPE）：',num2str(MAPE*100),'%'])

l=regstats(true_value,data_sum,'quadratic','rsquare');
R = getfield(l,'rsquare');
disp(['决定系数（R2）：',num2str(R)])