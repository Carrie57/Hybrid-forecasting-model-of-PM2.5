%%%%%%�����һ�������ݻ��棬����Ӱ����һ�����еĽ����һ��Ӳ��Ӷ����ԡ�
clear all
close all
clc
warning('off');
load data_PM25
data_PM25=data_PM25';
load imf
[m,~]=size(imf);%%%%��imf����������m��ֵ(m=8)
pe=zeros(1,m);%%%%����һ�������pe��1��m��
figure(1)
for i=1:m   %%%%ѭ��������i��1��m,ÿ������1
    subplot(m,1,i)%%%%�������ֳ�m�У�1�У���ʾ����i��ͼ
    plot(imf(i,:))%%%%%����i��imf(i,:)�ĵ�i�е����ݣ�imf(i,:)��ʱimf�ĵ�i�����ݣ�
end
load IMF1_VMD  %%%%����IMF1_VMD�ļ�(5��366��)
% IMF1_VMD=SAM_VMD(imf(1,:),1,5000,0.3,5,0,1,1e-7);
%% IMF1����VMD�ֽ�Ľ��
figure(2)
for i=1:5    %%%%ѭ��������i��1��5,ÿ������1
    subplot(5,1,i)%%%%�������ֳ�5�У�1�У���ʾ����i��ͼ
    plot(IMF1_VMD(i,:))%%%%%����i��IMF1_VMD(i,:)�ĵ�i�е�����
end
%%  ʹ��DE-ELM����Ԥ��
load DE_ELM  %%%%����DE_ELM�ļ�(12��66��)
% DE_ELM=zeros(m+4,66);
    figure(3) %��ƵԤ��Ա�
for i=1:m-1  %��Ƶ����Ԥ��  %%%%ѭ��������i��1��7,ÿ������1
  %  DE_ELM(i,:)= ML_DE_ELM(imf(i+1,:),66,20,1);    
    subplot(7,1,i)%%%%�������ֳ�7�У�1�У���ʾ����i��ͼ
    plot(1:66,DE_ELM(i,:),'*-b')
    %%%%1��66��ʾ��������ݷ�Χ��1��66��ÿ������1��
    %%%DE_ELM(i,:)��ʾ���������ֵ��DE_ELM(i,:)�еĵ�i�е�����
    hold on
    plot(1:66,imf(i+1,end-66+1:end),'o-r')
    legend('Ԥ��ֵ','ʵ��ֵ')
end

 figure(4) %��ƵԤ��Ա�
for i=1:5
%     DE_ELM(m-1+i,:)= ML_DE_ELM(IMF1_VMD(i,:),66,20,1);
    subplot(5,1,i)
    plot(1:66,DE_ELM(m-1+i,:),'*-b')
    hold on
    plot(1:66,IMF1_VMD(i,end-66+1:end),'o-r')
    legend('Ԥ��ֵ','ʵ��ֵ')
end


%% ��ELM���жԱȣ��Ա�DE-ELM��ELM
delay=5;
test_num=66;
load ELMs
% ELMs=zeros(m+4,66);
    figure(5) %��ƵԤ��Ա�
for i=1:m-1  %��Ƶ����Ԥ��
%     test_data=imf(i+1,end-test_num-delay+1:end); %���Լ�
%     train_data=imf(i+1,1:end-test_num);%ѵ����
%     %% ��������
%     for j=1:delay
%         train_input(j,:)=train_data(j:end-delay-1+j);
%         test_input(j,:)=test_data(j:end-delay-1+j);
%     end
%     train_output=train_data(delay+1:end);
%     test_output=test_data(delay+1:end);
% %% ELM����/ѵ��
% 
% [IW,B,LW,TF,TYPE] = elmtrain(train_input,train_output,16,'sig',0);
% 
% %% ELM�������
% tn_sim = elmpredict(test_input,IW,B,LW,TF,TYPE);
%     ELMs(i,:)= tn_sim;    
    subplot(7,1,i)
    plot(1:66,ELMs(i,:),'*-b')
    hold on
    plot(1:66,imf(i+1,end-66+1:end),'o-r')
    legend('Ԥ��ֵ','ʵ��ֵ')
end

 figure %��ƵԤ��Ա�
for i=1:5
%         test_data=IMF1_VMD(i,end-test_num-delay+1:end); %���Լ�
%     train_data=IMF1_VMD(i,1:end-test_num);%ѵ����
%     %% ��������
%     for j=1:delay
%         train_input(j,:)=train_data(j:end-delay-1+j);
%         test_input(j,:)=test_data(j:end-delay-1+j);
%     end
%     train_output=train_data(delay+1:end);
%     test_output=test_data(delay+1:end);
% %% ELM����/ѵ��
% 
% [IW,B,LW,TF,TYPE] = elmtrain(train_input,train_output,16,'sig',0);
% 
% %% ELM�������
% tn_sim = elmpredict(test_input,IW,B,LW,TF,TYPE);
%     ELMs(m-1+i,:)= tn_sim;    
    subplot(5,1,i)
    plot(1:66,ELMs(m-1+i,:),'*-b')
    hold on
    plot(1:66,IMF1_VMD(i,end-66+1:end),'o-r')
    legend('Ԥ��ֵ','ʵ��ֵ')
end

%% ��IMF1�����ж��ηֽ⣬ֱ��ʹ��DE-ELM����Ԥ��  �����жԱ�
IMF1_DE_ELM= ML_DE_ELM(imf(1,:),66,20,1);   

figure
plot(1:66,imf(1,end-66+1:end),'ko-')
hold on
plot(1:66,sum(DE_ELM(m:end,:),1),'b*-')
hold on
plot(1:66,IMF1_DE_ELM,'r^-')
legend('IMF1��ͼ��','��ʹ��VMD�ֽ�IMF1����Ԥ��','ֱ��ʹ��DE-ELM��IMFԤ��')
figure
plot(1:66,(imf(1,end-66+1:end)-sum(DE_ELM(m:end,:),1)).^2/66,'bo-')
hold on
plot(1:66,(imf(1,end-66+1:end)-IMF1_DE_ELM).^2/66,'r*-')
legend('��ʹ��VMD�ֽ�IMF1����Ԥ���Ԥ�����','ֱ��ʹ��DE-ELM��IMFԤ���Ԥ�����')





%% �������
figure
plot(1:66,((sum(DE_ELM,1)-sum(imf(:,end-66+1:end),1)).^2)/66,'b*-')
hold on
plot(1:66,((sum(ELMs,1)-sum(imf(:,end-66+1:end),1)).^2)/66,'ro-')
legend('FEEMD-DE-ELM��Ԥ�����','FEEMD-ELM��Ԥ�����')

%% �����ع�     MAE(ƽ���������)
FEEMD_DE_ELM_CG=abs(sum((sum(DE_ELM,1)-sum(imf(:,end-66+1:end),1))))/66 %DE-ELM��Ԥ�����
FEEMD_ELM_CG=abs(sum((sum(ELMs,1)-sum(imf(:,end-66+1:end),1))))/66%ELM��Ԥ�����

% RMSE����������
FEEMD_DE_ELM_CG=abs(sqrt(sum((sum(DE_ELM,1)-sum(imf(:,end-66+1:end),1)).^2)/700))
FEEMD_ELM_CG=abs(sqrt(sum((sum(ELMs,1)-sum(imf(:,end-66+1:end),1)).^2)/700))

