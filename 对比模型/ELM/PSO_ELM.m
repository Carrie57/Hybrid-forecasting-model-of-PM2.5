% 延安温度月均值PSO-ELM预测模型

clc
clear all

load shanghai
yb=shanghai;
n=length(yb);
a=yb(:);
h=5;
a_n=zeros(h+1,n-h);
for i=1:n-h
    a_n(:,i)=a(i:i+h);
end
input=a_n(1:5,:);
output=a_n(6,:);

P_train=a_n(1:5,1:1165);
P_test=a_n(1:5,1165:end);

T_train=a_n(6,1:1165);
T_test=a_n(6,1165:end);
%% 载入数据
AllSamIn = P_train;
AllSamOut =T_train;
AllTestIn=P_test;
AllTestOut=T_test;


%% 训练样本归一化
global minAllSamOut;  
global maxAllSamOut; 
[AllSamInn,minAllSamIn,maxAllSamIn,AllSamOutn,minAllSamOut,maxAllSamOut] = premnmx(AllSamIn,AllSamOut);
TrainSamIn=AllSamInn; 
TrainSamOut=AllSamOutn;
global Ptrain;
Ptrain = TrainSamIn;   
global Ttrain;
Ttrain = TrainSamOut;  

%% 测试样本归一化
global minAllTestOut;  
global maxAllTestOut; 
[AllTestInn,minAllTestIn,maxAllTestIn,AllTestOutn,minAllTestOut,maxAllTestOut] = premnmx(AllTestIn,AllTestOut);
TestIn=AllTestInn; 
TestOut=AllTestOutn;
global Ptest;
Ptest = TestIn; 
global Ttest;
Ttest = TestOut; 

%% 加载网络的初始变量
global indim; 
indim=5;
global hiddennum;
hiddennum=14;
global outdim;
outdim=1;


%% 加载PSO模型的相关参数
vmax=1; 
minerr=0.001; 
wmax=0.50; 
wmin=0.30; 
global itmax; 
itmax=100;
c1=2; 
c2=2; 
for iter=1:itmax
    W(iter)=wmax-((wmax-wmin)/itmax)*iter; 
end
a=-1;
b=1;
m=-1;
n=1;
global N; 
N=30;
global D; 
D=(indim+1)*hiddennum+(hiddennum+1)*outdim; 
rand('state',sum(100*clock));
X=a+(b-a)*rand(N,D,1);
V=m+(n-m)*rand(N,D,1);
global fvrec;
MinFit=[];
BestFit=[];

%% PSO优化ELM模型 过程 1
fitness=fitcal(X,indim,hiddennum,outdim,D,Ptrain,Ttrain,minAllSamOut,maxAllSamOut); 
fvrec(:,1,1)=fitness(:,1,1);
[C,I]=min(fitness(:,1,1)); 
MinFit=[MinFit C];  
BestFit=[BestFit C]; 
L(:,1,1)=fitness(:,1,1); 
B(1,1,1)=C; 
gbest(1,:,1)=X(I,:,1); 

for p=1:N
    G(p,:,1)=gbest(1,:,1); 
end

for i=1:N;
    pbest(i,:,1)=X(i,:,1); 
end
V(:,:,2)=W(1)*V(:,:,1)+c1*rand*(pbest(:,:,1)-X(:,:,1))+c2*rand*(G(:,:,1)-X(:,:,1));

for ni=1:N
    for di=1:D
        if V(ni,di,2) > vmax
            V(ni,di,2) = vmax;
        elseif V(ni,di,2) < -vmax
            V(ni,di,2) = -vmax;
        else
            V(ni,di,2) = V(ni,di,2);
        end
    end
end

X(:,:,2)=X(:,:,1)+V(:,:,2);

for ni=1:N
    for di=1:D
        if X(ni,di,2) > 1
            X(ni,di,2) = 1;
        elseif V(ni,di,2) < -1
            X(ni,di,2) = -1;
        else
            X(ni,di,2) = X(ni,di,2);
        end
    end
end


%%  PSO优化ELM模型 过程 2
for j=2:itmax
    disp('Iteration and Current Best Fitness')
    disp(j-1)
    disp(B(1,1,j-1))
    fitness=fitcal(X,indim,hiddennum,outdim,D,Ptrain,Ttrain,minAllSamOut,maxAllSamOut); 
    fvrec(:,1,j)=fitness(:,1,j); 
    [C,I]=min(fitness(:,1,j));
    MinFit=[MinFit C]; 
    BestFit=[BestFit min(MinFit)]; 
    L(:,1,j)=fitness(:,1,j); 
    B(1,1,j)=C; 
    gbest(1,:,j)=X(I,:,j);
    [C,I]=min(B(1,1,:));
    
    if B(1,1,j)<=C
        gbest(1,:,j)=gbest(1,:,j);
    else
        gbest(1,:,j)=gbest(1,:,I);
    end
    if C<=minerr, break, end

    if j>=itmax, break, end
    for p=1:N
        G(p,:,j)=gbest(1,:,j);
    end
    for i=1:N;
        [C,I]=min(L(i,1,:));
        if L(i,1,j)<=C
            pbest(i,:,j)=X(i,:,j);
        else
            pbest(i,:,j)=X(i,:,I);
        end
    end
    
    V(:,:,j+1)=W(j)*V(:,:,j)+c1*rand*(pbest(:,:,j)-X(:,:,j))+c2*rand*(G(:,:,j)-X(:,:,j));
    
    for ni=1:N
        for di=1:D
            if V(ni,di,j+1)>vmax
                V(ni,di,j+1)=vmax;
            elseif V(ni,di,j+1)<-vmax
                V(ni,di,j+1)=-vmax;
            else
                V(ni,di,j+1)=V(ni,di,j+1);
            end
        end
    end
    X(:,:,j+1)=X(:,:,j)+V(:,:,j+1);
    
    for ni=1:N
        for di=1:D
            if X(ni,di,j+1) > 1
                X(ni,di,j+1) = 1;
            elseif V(ni,di,j+1) < -1
                X(ni,di,j+1) = -1;
            else
                X(ni,di,j+1) = X(ni,di,j+1);
            end
        end
    end 
end

disp('Iteration and Current Best Fitness')
disp(j)
disp(B(1,1,j))
disp('Global Best Fitness and Occurred Iteration')
[C,I] = min(B(1,1,:))

for t=1:hiddennum
    x2iw(t,:)=gbest(1,((t-1)*indim+1):t*indim,j);
end
for r=1:outdim
    x2lw(r,:)=gbest(1,(indim*hiddennum+1):(indim*hiddennum+hiddennum),j);
end
x2b=gbest(1,((indim+1)*hiddennum+1):D,j);
x2b1=x2b(1:hiddennum).';
x2b2=x2b(hiddennum+1:hiddennum+outdim).';

IWbest1=x2iw;
IWbest2=x2lw;
IBbest1=x2b1;
IBbest2=x2b2;

T_sim_test = ELMfun2(IWbest1,IBbest1,Ptest,Ttest,hiddennum,IWbest2,IBbest2);

testsamout = postmnmx(T_sim_test,minAllTestOut,maxAllTestOut); 
realtesterr=mse(testsamout-AllTestOut);
err1=norm(testsamout-AllTestOut); 
disp(['优化模型测试样本的仿真误差:',num2str(err1)])
N = length(Ttest);
R1 = (N*sum(T_sim_test.*Ttest)-sum(T_sim_test)*sum(Ttest))^2/((N*sum((T_sim_test).^2)-(sum(T_sim_test))^2)*(N*sum((Ttest).^2)-(sum(Ttest))^2)); 
RMSe=sqrt(sum((testsamout-AllTestOut).^2)/231)
MAE=sum(abs(testsamout-AllTestOut))./231
MAPE=sum(abs((testsamout-AllTestOut)./AllTestOut))./231
%% 不使用PSO优化ELM算法
[IW,B,LW,TF,TYPE] = elmtrain2(Ptrain,Ttrain,14,'sig',0);
T_sim_test1 = elmpredict(Ptest,IW,B,LW,TF,TYPE);
testsamout2 = postmnmx(T_sim_test1,minAllTestOut,maxAllTestOut);
realtesterr2=mse(testsamout2-AllTestOut);
err2=norm(testsamout2-AllTestOut);  
R2 = (N*sum(T_sim_test1.*Ttest)-sum(T_sim_test1)*sum(Ttest))^2/((N*sum((T_sim_test1).^2)-(sum(T_sim_test1))^2)*(N*sum((Ttest).^2)-(sum(Ttest))^2)); 
disp(['原始模型测试样本的仿真误差:',num2str(err2)])
RMSe2=sqrt(sum((testsamout2-AllTestOut).^2)/231)
MAE2=sum(abs(testsamout2-AllTestOut))./231
MAPE2=sum(abs((testsamout2-AllTestOut)./AllTestOut))./231
l=regstats(testsamout2,AllTestOut,'quadratic','rsquare');
R = getfield(l,'rsquare');
disp(['决定系数（R2）：',num2str(R)])

%% 输出参数图
% PSO 优化迭代图
% figure(1);
% P0 = plot(1:itmax,BestFit);
% 
% xlabel('PSO迭代次数');
% ylabel('适应度值');

bestErr=min(BestFit);
% fprintf(['PSO-ELM模型:\n决定系数R^2=',num2str(R1),'\n模型仿真均方误差:mse=',num2str(realtesterr),'\n'])
% set(P0,'LineWidth',1.5);    
% PSO与ELM结果比较图
figure(2)
P1=plot(1:292,AllTestOut,'r-*',1:292,testsamout,'b:o')

legend('真实值','PSO-ELM预测值')
xlabel('时间/月')
ylabel('温度 ℃')
ylim([-10,30])
