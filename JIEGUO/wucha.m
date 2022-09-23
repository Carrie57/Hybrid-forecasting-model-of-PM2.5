%% xian误差图
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
figure
box on;
hold on;
% for i=2:A-3
%      plot(all_res(i,:)-all_res(1,:),'--','color',color(i+3,:),'LineWidth',2);
%      hold on;
% end
plot(LSTM-data,'-- ','LineWidth',1,'Color','#63B2EE');
plot(ELM-data,'-- ','LineWidth',1,'Color','#76da91 ');
plot(KELM-data,'-- ','LineWidth',1,'Color','#f8cb7f ');
plot(PSOLSTM-data,'-- ','LineWidth',1,'Color','#f89588 ');
plot(POALSTM-data,'- ','LineWidth',1,'Color','#7cd6cf');
plot(CEEMDANLSTM-data,'LineWidth',1,'Color','#ffcccc ');
plot(VMDLSTM-data,'y-','LineWidth',1);
plot(VMDPOALSTM-data,'m-','LineWidth',1);
plot(CapSAVMDLSTM-data,'c-','LineWidth',1);
 plot(CEEMDANCapSAVMDLSTM-data,'g-','LineWidth',1);
 plot(CEEMDANCapSAVMDPOALSTM-data,'b-','LineWidth',1);
 plot(CEEMDANCapSAVMDPOALSTMEC-data,'r-','LineWidth',1);
% set(gca,'FontName','Times New Roman','FontSize',24)
% set(gca,'xtick',[0:20:140])

% ylim([-3 3])
% ylim([-50 80])
xlabel('Sample points','FontName','Times New Roman','FontSize',15)
ylabel('Amplitude','FontName','Times New Roman','FontSize',15);
lgd = legend('LSTM','ELM','KELM','PSO-LSTM','POA-LSTM','CEEMDAN-LSTM','VMD-LSTM','VMD-POA-LSTM','CVMD-LSTM','CEEMDAN-ApEn-CVMD-LSTM','CEEMDAN-ApEn-CVMD-POA-LSTM','CEEMDAN-ApEn-CVMD-POA-LSTM-EC');
lgd.NumColumns = 2;
% set(hl,'Box','off');
% set(gca,'looseInset',[0 0 0 0])
set(gca,'fontsize',15.0);set(gca,'fontname','times New Roman');
set(gcf,'Position',[347,162,600,250]);
legend boxoff;

%%beijing 
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
figure
box on;
hold on;
% for i=2:A-3
%      plot(all_res(i,:)-all_res(1,:),'--','color',color(i+3,:),'LineWidth',2);
%      hold on;
% end
temp1=CEEMDANCapSAVMDPOALSTMEC1-data1;
plot(LSTM1-data1,'-- ','LineWidth',1,'Color','#63B2EE');
plot(ELM1-data1,'-- ','LineWidth',1,'Color','#76da91 ');
plot(KELM1-data1,'-- ','LineWidth',1,'Color','#f8cb7f ');
plot(PSOLSTM1-data1,'-- ','LineWidth',1,'Color','#f89588 ');
plot(POALSTM1-data1,'- ','LineWidth',1,'Color','#7cd6cf');
plot(CEEMDANLSTM1-data1,'LineWidth',1,'Color','#ffcccc ');
plot(VMDLSTM1-data1,'y-','LineWidth',1);
plot(VMDPOALSTM1-data1,'m-','LineWidth',1);
plot(CapSAVMDLSTM1-data1,'c-','LineWidth',1);
 plot(CEEMDANCapSAVMDLSTM1-data1,'g-','LineWidth',1);
 plot(CEEMDANCapSAVMDPOALSTM1-data1,'b-','LineWidth',1);
 plot(CEEMDANCapSAVMDPOALSTMEC1-data1,'r-','LineWidth',1);
% set(gca,'FontName','Times New Roman','FontSize',24)
% set(gca,'xtick',[0:20:140])

% ylim([-3 3])
% ylim([-50 80])
xlabel('Sample points','FontName','Times New Roman','FontSize',15)
ylabel('Amplitude','FontName','Times New Roman','FontSize',15);
lgd = legend('LSTM','ELM','KELM','PSO-LSTM','POA-LSTM','CEEMDAN-LSTM','VMD-LSTM','VMD-POA-LSTM','CVMD-LSTM','CEEMDAN-ApEn-CVMD-LSTM','CEEMDAN-ApEn-CVMD-POA-LSTM','CEEMDAN-ApEn-CVMD-POA-LSTM-EC');
lgd.NumColumns = 2;
% set(hl,'Box','off');
% set(gca,'looseInset',[0 0 0 0])
set(gca,'fontsize',15.0);set(gca,'fontname','times New Roman');
set(gcf,'Position',[347,162,600,250]);
legend boxoff;

%%shanghai
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

figure
box on;
hold on;
% for i=2:A-3
%      plot(all_res(i,:)-all_res(1,:),'--','color',color(i+3,:),'LineWidth',2);
%      hold on;
% end
plot(LSTM2-data2,'-- ','LineWidth',1,'Color','#63B2EE');
plot(ELM2-data2,'-- ','LineWidth',1,'Color','#76da91 ');
plot(KELM2-data2,'-- ','LineWidth',1,'Color','#f8cb7f ');
plot(PSOLSTM2-data2,'-- ','LineWidth',1,'Color','#f89588 ');
plot(POALSTM2-data2,'- ','LineWidth',1,'Color','#7cd6cf');
plot(CEEMDANLSTM2-data2,'LineWidth',1,'Color','#ffcccc ');
plot(VMDLSTM2-data2,'y-','LineWidth',1);
plot(VMDPOALSTM2-data2,'m-','LineWidth',1);
plot(CapSAVMDLSTM2-data2,'c-','LineWidth',1);
 plot(CEEMDANCapSAVMDLSTM2-data2,'g-','LineWidth',1);
 plot(CEEMDANCapSAVMDPOALSTM2-data2,'b-','LineWidth',1);
 plot(CEEMDANCapSAVMDPOALSTMEC2-data2,'r-','LineWidth',1);
% set(gca,'FontName','Times New Roman','FontSize',24)
% set(gca,'xtick',[0:20:140])

% ylim([-3 3])
% ylim([-50 80])
xlabel('Sample points','FontName','Times New Roman','FontSize',15)
ylabel('Amplitude','FontName','Times New Roman','FontSize',15);
lgd = legend('LSTM','ELM','KELM','PSO-LSTM','POA-LSTM','CEEMDAN-LSTM','VMD-LSTM','VMD-POA-LSTM','CVMD-LSTM','CEEMDAN-ApEn-CVMD-LSTM','CEEMDAN-ApEn-CVMD-POA-LSTM','CEEMDAN-ApEn-CVMD-POA-LSTM-EC');
lgd.NumColumns = 2;
% set(hl,'Box','off');
% set(gca,'looseInset',[0 0 0 0])
set(gca,'fontsize',15.0);set(gca,'fontname','times New Roman');
set(gcf,'Position',[347,162,600,250]);
legend boxoff;