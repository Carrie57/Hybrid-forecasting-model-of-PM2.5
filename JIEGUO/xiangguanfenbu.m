clc;
close all;
clear all;
% %% 加载数据
% load('CSA-LSSVM_SSC_China_VMD_sum_realdata.mat')
% load('China_compare.mat')

% load('CPA-KELM_SSC_US_VMD_sum_realdata.mat')
% load('US_compare.mat')
data1=xlsread('预测结果.xlsx','G298:G589');
LSTM1=xlsread('预测结果.xlsx','H298:H589');
ELM1=xlsread('预测结果.xlsx','I298:I589');
KELM1=xlsread('预测结果.xlsx','J298:J589');
PSOLSTM1=xlsread('预测结果.xlsx','L298:L589');
POALSTM1=xlsread('预测结果.xlsx','K298:K589');
CEEMDANLSTM1=xlsread('预测结果.xlsx','M298:M589');
VMDLSTM1=xlsread('预测结果.xlsx','N298:N589');
VMDPOALSTM1=xlsread('预测结果.xlsx','O298:O589');
CapSAVMDLSTM1=xlsread('预测结果.xlsx','P298:P589');
CEEMDANCapSAVMDLSTM1=xlsread('预测结果.xlsx','Q298:Q589');
CEEMDANCapSAVMDPOALSTM1=xlsread('预测结果.xlsx','R298:R589');
CEEMDANCapSAVMDPOALSTMEC1=xlsread('预测结果.xlsx','S298:S589');
%% 相关分布图
figure(6)
n=3;
CData = 0:1/(length(data1)-1):1;% 保持数据长度一致
CData=CData';
subplot(3,4,1)
scatter(LSTM1,data1,n,CData,'filled');colorbar;
ylabel('True Data');
xlabel('Predicted Data');
title('M1');
set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
set(gca,'LooseInset',get(gca,'TightInset'))

subplot(342)
scatter(data1,ELM1,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M2');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(343)
scatter(KELM1,data1,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M3');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(344)
scatter(PSOLSTM1,data1,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M4');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(345)
scatter(data1,POALSTM1,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M5');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(346)
scatter(CEEMDANLSTM1,data1,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M6');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(347)
scatter(VMDLSTM1,data1,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M7');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(348)
scatter(VMDPOALSTM1,data1,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M8');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(349)
scatter(CapSAVMDLSTM1,data1,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M9');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(3,4,10)
scatter(CEEMDANCapSAVMDLSTM1,data1,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M10');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(3,4,11)
scatter(CEEMDANCapSAVMDPOALSTM1,data1,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M11');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(3,4,12)
scatter(CEEMDANCapSAVMDPOALSTMEC1,data1,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M12');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
set(gcf,'Position',[1,1,500,700]);
 set(gca,'LooseInset',get(gca,'TightInset'))
%  set(gca,'looseInset',[0 0 0 0])
% %计算相关系数
a=corrcoef(data1,LSTM1');zipreBp=a(1,2)
a=corrcoef(data1,ELM1');zipreELM=a(1,2)
a=corrcoef(data1,KELM1');zipreKELM=a(1,2)
a=corrcoef(data1,PSOLSTM1);zipreGKELM=a(1,2)
a=corrcoef(data1,POALSTM1');zipre_EMD_GKELM=a(1,2)
a=corrcoef(data1,CEEMDANLSTM1');zipre_CEEMDAN_GKELM=a(1,2)
a=corrcoef(data1,VMDLSTM1);zipre_VMD_GKELM=a(1,2)
a=corrcoef(data1,VMDPOALSTM1);zipre_2VMD_GKELM=a(1,2)
a=corrcoef(data1,CapSAVMDLSTM1);zipreGKELM=a(1,2)
a=corrcoef(data1,CEEMDANCapSAVMDLSTM1');zipre_EMD_GKELM=a(1,2)
a=corrcoef(data1,CEEMDANCapSAVMDPOALSTM1');zipre_CEEMDAN_GKELM=a(1,2)
a=corrcoef(data1,CEEMDANCapSAVMDPOALSTMEC1);zipre_VMD_GKELM=a(1,2)
 

data2=xlsread('预测结果.xlsx','G595:G886');
LSTM2=xlsread('预测结果.xlsx','H595:H886');
ELM2=xlsread('预测结果.xlsx','I595:I886');
KELM2=xlsread('预测结果.xlsx','J595:J886');
PSOLSTM2=xlsread('预测结果.xlsx','L595:L886');
POALSTM2=xlsread('预测结果.xlsx','K595:K886');
CEEMDANLSTM2=xlsread('预测结果.xlsx','M595:M886');
VMDLSTM2=xlsread('预测结果.xlsx','N595:N886');
VMDPOALSTM2=xlsread('预测结果.xlsx','O595:O886');
CapSAVMDLSTM2=xlsread('预测结果.xlsx','P595:P886');
CEEMDANCapSAVMDLSTM2=xlsread('预测结果.xlsx','Q595:Q886');
CEEMDANCapSAVMDPOALSTM2=xlsread('预测结果.xlsx','R595:R886');
CEEMDANCapSAVMDPOALSTMEC2=xlsread('预测结果.xlsx','S595:S886');

figure(7)
n=3;
CData = 0:1/(length(data1)-1):1;% 保持数据长度一致
CData=CData';
subplot(3,4,1)
scatter(LSTM2,data2,n,CData,'filled');colorbar;
ylabel('True Data');
xlabel('Predicted Data');
title('M1');
set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
set(gca,'LooseInset',get(gca,'TightInset'))

subplot(342)
scatter(ELM2,data2,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M2');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(343)
scatter(KELM2,data2,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M3');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(344)
scatter(PSOLSTM2,data2,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M4');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(345)
scatter(POALSTM2,data2,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M5');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(346)
scatter(CEEMDANLSTM2,data2,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M6');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(347)
scatter(VMDLSTM2,data2,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M7');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(348)
scatter(VMDPOALSTM2,data2,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M8');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(349)
scatter(CapSAVMDLSTM2,data2,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M9');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(3,4,10)
scatter(CEEMDANCapSAVMDLSTM2,data2,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M10');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(3,4,11)
scatter(CEEMDANCapSAVMDPOALSTM2,data2,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M11');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(3,4,12)
scatter(CEEMDANCapSAVMDPOALSTMEC2,data2,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M12');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
set(gcf,'Position',[1,1,500,700]);
 set(gca,'LooseInset',get(gca,'TightInset'))
 a=corrcoef(data2,LSTM2');zipreBp=a(1,2)
a=corrcoef(data2,ELM2');zipreELM=a(1,2)
a=corrcoef(data2,KELM2');zipreKELM=a(1,2)
a=corrcoef(data2,PSOLSTM2);zipreGKELM=a(1,2)
a=corrcoef(data2,POALSTM2');zipre_EMD_GKELM=a(1,2)
a=corrcoef(data2,CEEMDANLSTM2');zipre_CEEMDAN_GKELM=a(1,2)
a=corrcoef(data2,VMDLSTM2);zipre_VMD_GKELM=a(1,2)
a=corrcoef(data2,VMDPOALSTM2);zipre_2VMD_GKELM=a(1,2)
a=corrcoef(data2,CapSAVMDLSTM2);zipreGKELM=a(1,2)
a=corrcoef(data2,CEEMDANCapSAVMDLSTM2');zipre_EMD_GKELM=a(1,2)
a=corrcoef(data2,CEEMDANCapSAVMDPOALSTM2');zipre_CEEMDAN_GKELM=a(1,2)
a=corrcoef(data2,CEEMDANCapSAVMDPOALSTMEC2);zipre_VMD_GKELM=a(1,2)
 
 
 data=xlsread('预测结果.xlsx','G2:G293');
LSTM=xlsread('预测结果.xlsx','H2:H293');
ELM=xlsread('预测结果.xlsx','I2:I293');
KELM=xlsread('预测结果.xlsx','J2:J293');
PSOLSTM=xlsread('预测结果.xlsx','L2:L293');
POALSTM=xlsread('预测结果.xlsx','K2:K293');
CEEMDANLSTM=xlsread('预测结果.xlsx','M2:M293');
VMDLSTM=xlsread('预测结果.xlsx','N2:N293');
VMDPOALSTM=xlsread('预测结果.xlsx','O2:O293');
CapSAVMDLSTM=xlsread('预测结果.xlsx','P2:P293');
CEEMDANCapSAVMDLSTM=xlsread('预测结果.xlsx','Q2:Q293');
CEEMDANCapSAVMDPOALSTM=xlsread('预测结果.xlsx','R2:R293');
CEEMDANCapSAVMDPOALSTMEC=xlsread('预测结果.xlsx','S2:S293');

figure(8)
n=3;
CData = 0:1/(length(data1)-1):1;% 保持数据长度一致
CData=CData';
subplot(3,4,1)
scatter(LSTM,data,n,CData,'filled');colorbar;
ylabel('True Data');
xlabel('Predicted Data');
title('M1');
set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
set(gca,'LooseInset',get(gca,'TightInset'))

subplot(342)
scatter(ELM,data,n,CData,'filled');colorbar;ylabel('True data');xlabel('Predicted data');title('M2');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(343)
scatter(KELM,data,n,CData,'filled');colorbar;ylabel('True data');xlabel('Predicted data');title('M3');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(344)
scatter(PSOLSTM,data,n,CData,'filled');colorbar;ylabel('True data');xlabel('Predicted data');title('M4');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(345)
scatter(POALSTM,data,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M5');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(346)
scatter(CEEMDANLSTM,data,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M6');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(347)
scatter(VMDLSTM,data,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M7');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(348)
scatter(VMDPOALSTM,data,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M8');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(349)
scatter(CapSAVMDLSTM,data,n,CData,'filled');colorbar;ylabel('True data');xlabel('Predicted data');title('M9');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(3,4,10)
scatter(CEEMDANCapSAVMDLSTM,data,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M10');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(3,4,11)
scatter(CEEMDANCapSAVMDPOALSTM,data,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M11');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
subplot(3,4,12)
scatter(CEEMDANCapSAVMDPOALSTMEC,data,n,CData,'filled');colorbar;ylabel('True Data');xlabel('Predicted Data');title('M12');set(gca,'fontname','times New Roman');
set(gca,'fontsize',12.0)
set(gcf,'Position',[1,1,500,700]);
 set(gca,'LooseInset',get(gca,'TightInset'))
 
  a=corrcoef(data,LSTM');zipreBp=a(1,2)
a=corrcoef(data,ELM');zipreELM=a(1,2)
a=corrcoef(data,KELM');zipreKELM=a(1,2)
a=corrcoef(data,PSOLSTM);zipreGKELM=a(1,2)
a=corrcoef(data,POALSTM');zipre_EMD_GKELM=a(1,2)
a=corrcoef(data,CEEMDANLSTM');zipre_CEEMDAN_GKELM=a(1,2)
a=corrcoef(data,VMDLSTM);zipre_VMD_GKELM=a(1,2)
a=corrcoef(data,VMDPOALSTM);zipre_2VMD_GKELM=a(1,2)
a=corrcoef(data,CapSAVMDLSTM);zipreGKELM=a(1,2)
a=corrcoef(data,CEEMDANCapSAVMDLSTM');zipre_EMD_GKELM=a(1,2)
a=corrcoef(data,CEEMDANCapSAVMDPOALSTM');zipre_CEEMDAN_GKELM=a(1,2)
a=corrcoef(data,CEEMDANCapSAVMDPOALSTMEC);zipre_VMD_GKELM=a(1,2)