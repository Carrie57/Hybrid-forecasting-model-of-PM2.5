%% ��������,Ԥ��,������
% %ѵ����������������32 ��135������
clc;
close all;
clear 

load shanghai.mat
data=shanghai;
z=data
test=z(1170:end,:);%Ԥ���?80������
t=linspace(1,1461,length(z));

T = 1461;
fs = 1/T;
t = (1:1:T);
freqs = 2*pi*(t-0.5-1/T)/(fs);

% figure(1)
% plot(t,z);
% set(gca,'FontName','Time New Roman')
% ylabel('��������ָ��');
% set(gca,'FontName','Time New Roman')
% xlabel('ʱ��/��');
% xlim([1 600]) ;

Z=[z];
d=[];
for j=1
  b=Z(:,j);  
k=b(:);
h=5;
n=length(k);

a_n=zeros(h+1,n-h);
for i=1:n-h
    a_n(:,i)=k(i:i+h);
end
input=a_n(1:5,:);
output=a_n(6,:);
AllSamIn = input(:,1:1164);%ѵ������531��  7:3
AllSamOut = output(:,1:1164);
AllTestIn=input(:,1165:end);%��������53-5��indim=5��=48�� 135-32-5
AllTestOut=output(:,1165:end);%2480,80

%% ѵ��������һ��
global minAllSamOut;  
global maxAllSamOut; 
[AllSamInn,minAllSamIn,maxAllSamIn,AllSamOutn,minAllSamOut,maxAllSamOut] = premnmx(AllSamIn,AllSamOut);
TrainSamIn=AllSamInn; 
TrainSamOut=AllSamOutn;
global Ptrain;
Ptrain = TrainSamIn;   
global Ttrain;
Ttrain = TrainSamOut;  

%% ����������һ��
global minAllTestOut;  
global maxAllTestOut; 
[AllTestInn,minAllTestIn,maxAllTestIn,AllTestOutn,minAllTestOut,maxAllTestOut] = premnmx(AllTestIn,AllTestOut);
TestIn=AllTestInn; 
TestOut=AllTestOutn;
global Ptest;
Ptest = TestIn; 
global Ttest;
Ttest = TestOut; 

%% ��������ĳ�ʼ����?
global indim; 
indim=5;
global hiddennum;
hiddennum=14;
global outdim;
outdim=1;


%% ����PSOģ�͵���ز���?
vmax=1; 
minerr=0.0001; 
wmax=0.50; 
wmin=0.10; 
global itmax; 
itmax=50;
c1=2.8; 
c2=1.5; 
for iter=1:itmax
    W(iter)=wmax-((wmax-wmin)/itmax)*iter; 
end
a=-1;
b=1;
m=-1;
n=1;
global N; 
N=100;
global D; 
D=(indim+1)*hiddennum+(hiddennum+1)*outdim; 
rand('state',sum(100*clock));
X=a+(b-a)*rand(N,D,1);
V=m+(n-m)*rand(N,D,1);
global fvrec;
MinFit=[];
BestFit=[];


%%  ��ʹ��PSO�Ż�ELM�㷨
[IW,B,LW,TF,TYPE] = elmtrain2(Ptrain,Ttrain,14,'sig',0);
T_sim_test = elmpredict(Ptest,IW,B,LW,TF,TYPE);
testsamout2 = postmnmx(T_sim_test,minAllTestOut,maxAllTestOut);
realtesterr2=mse(testsamout2-AllTestOut);
err2=norm(testsamout2-AllTestOut);  
R2 = (N*sum(T_sim_test.*Ttest)-sum(T_sim_test)*sum(Ttest))^2/((N*sum((T_sim_test).^2)-(sum(T_sim_test))^2)*(N*sum((Ttest).^2)-(sum(Ttest))^2)); 
disp(['ԭʼģ�Ͳ��������ķ������?:',num2str(err2)])
d=[d,testsamout2];
end
%% ELM����?
xx=length(d);
d2=reshape(d,[xx,1]);

e2=sum(d2,2);
figure(4)
P1=plot(1:xx,test,'r-*',1:xx,d2,'b-o');
hold on
set(gca,'FontName','Time New Roman');
legend('PM2.5��ʵֵ','ELMPM2.5Ԥ��ֵ')
set(gca,'FontName','Time New Roman');xlabel('ʱ��/��');
set(gca,'FontName','Time New Roman');ylabel('PM2.5Ũ��')
RMSe1=sqrt(sum((test-d2).^2)/292)
MAE1=sum(abs(test-d2))./292
MAPE1=sum(abs((test-d2)./test))./292
l=regstats(test,d2,'quadratic','rsquare');
R = getfield(l,'rsquare');
disp(['����ϵ����R2����',num2str(R)])
realtesterr=mse(test-d2);
err1=norm(test-d2) ;


