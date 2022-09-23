clc
clear
close all
% preCEEMDAN_NNetEn_STOAVMD_STOAKELM_EC=xlsread('preCEEMDAN_NNetEn_STOAVMD_STOAKELM_EC.xlsx');
load data
load preBP
load preELM
load preRNN
load preKELM
load preSTOAKELM

load preEMD_STOAKELM
load preEEMD_STOAKELM
load preCEEMDAN_STOAKELM
load preCEEMDAN_NNetEn_VMD_STOAKELM
load preCEEMDAN_NNetEn_STOAVMD_STOAKELM
load preCEEMDAN_NNetEn_STOAVMD_STOAKELM_EC


figure(1)

plot(data,'k','linewidth',1.3);hold on;
plot(preBP ,'y--','linewidth',1);hold on;
plot(preELM ,'b--','linewidth',1);hold on;
plot(preRNN, 'g--','linewidth',1);hold on;
plot(preKELM,'r--','linewidth',1);hold on;
plot(preSTOAKELM ,'c--','linewidth',1);hold on;
plot(preEMD_STOAKELM ,'b','linewidth',1);hold on;
plot(preEEMD_STOAKELM ,'y','linewidth',1);hold on;
plot(preCEEMDAN_STOAKELM,'g','linewidth',1);hold on;
plot(preCEEMDAN_NNetEn_VMD_STOAKELM ,'c','linewidth',1);hold on;
plot(preCEEMDAN_NNetEn_STOAVMD_STOAKELM,'m','linewidth',1);hold on;
plot(preCEEMDAN_NNetEn_STOAVMD_STOAKELM_EC,'r','linewidth',1);hold on;
lgd = legend('Actual value ','BP','ELM','RNN','KELM','STOAKELM','EMD-STOAKELM','EEMD-STOAKELM','CEEMDAN-STOAKELM','CEEMDAN-NNetEn-VMD-STOAKELM','CEEMDAN-NNetEn-STOAVMD-STOAKELM');
lgd.NumColumns = 2;
ylim([-0.5,4.5]);
ylabel('Wind power(MWh)');xlabel('Sampling point');set(gca,'fontsize',8.0);set(gca,'fontname','times New Roman');set(gcf,'Position',[347,162,600,250]);
 legend boxoff;
figure(2)

plot(data(150:160),'k','linewidth',1);hold on;
plot(preBP(150:160) ,'y--','linewidth',1);hold on;
plot(preELM(150:160) ,'b--','linewidth',1);hold on;
plot(preRNN(150:160), 'g--','linewidth',1);hold on;
plot(preKELM(150:160),'r--','linewidth',1);hold on;
plot(preSTOAKELM(150:160) ,'c--','linewidth',1);hold on;
plot(preEMD_STOAKELM(150:160) ,'b','linewidth',1);hold on;
plot(preEEMD_STOAKELM(150:160) ,'y','linewidth',1);hold on;
plot(preCEEMDAN_STOAKELM(150:160),'g','linewidth',1);hold on;
plot(preCEEMDAN_NNetEn_VMD_STOAKELM(150:160) ,'c','linewidth',1);hold on;
plot(preCEEMDAN_NNetEn_STOAVMD_STOAKELM(150:160),'m','linewidth',1);hold on;
plot(preCEEMDAN_NNetEn_STOAVMD_STOAKELM_EC(150:160),'r','linewidth',1);hold on;
ylim([-0.5,2]);

lgd = legend('Actual value ','BP','ELM','RNN','KELM','STOAKELM','EMD-STOAKELM','EEMD-STOAKELM','CEEMDAN-STOAKELM','CEEMDAN-NNetEn-VMD-STOAKELM','CEEMDAN-NNetEn-STOAVMD-STOAKELM');
lgd.NumColumns = 2;
ylim([0,1.7]);
ylabel('Wind power(MWh)');xlabel('Sampling point');set(gca,'fontsize',8.0);set(gca,'fontname','times New Roman');set(gcf,'Position',[347,162,600,250]);
 legend boxoff;









