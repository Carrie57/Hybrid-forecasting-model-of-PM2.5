clc
clear all

true2=xlsread('预测结果.xlsx','G298:G589');
pre2=xlsread('预测结果.xlsx','S298:S589');%beijing

true3=xlsread('预测结果.xlsx','G595:G886');
pre3=xlsread('预测结果.xlsx','R595:R886');%shanghai

true1=xlsread('预测结果.xlsx','G2:G293');
pre1=xlsread('预测结果.xlsx','S2:S293');%xian



figure(1)
plot(true2,'b-o','linewidth',1.3);hold on;
plot(pre2,'r-*','linewidth',1);hold on;
lgd = legend('Actual value ','CEEMDAN-ApEn-CVMD-POA-LSTM-EC');
lgd.NumColumns = 1;
ylabel('PM2.5 concentration value(μg/m3)');xlabel('Sampling point');
set(gca,'fontsize',15.0);set(gca,'fontname','times New Roman');
set(gcf,'Position',[347,162,600,250]);
legend boxoff;


figure(2)
plot(true3,'b-o','linewidth',1.3);hold on;
plot(pre3,'r-*','linewidth',1);hold on;
lgd = legend('Actual value ','CEEMDAN-ApEn-CVMD-POA-LSTM-EC');
lgd.NumColumns = 1;
ylabel('PM2.5 concentration value(μg/m3)');xlabel('Sampling point');
set(gca,'fontsize',15.0);set(gca,'fontname','times New Roman');
set(gcf,'Position',[347,162,600,250]);
legend boxoff;

figure(3)
plot(true1,'b-o','linewidth',1.3);hold on;
plot(pre1,'r-*','linewidth',1);hold on;
lgd = legend('Actual value ','CEEMDAN-ApEn-CVMD-POA-LSTM-EC');
lgd.NumColumns = 1;
ylabel('PM2.5 concentration value(μg/m3)');xlabel('Sampling point');
set(gca,'fontsize',15.0);set(gca,'fontname','times New Roman');
set(gcf,'Position',[347,162,600,250]);
legend boxoff;
