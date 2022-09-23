
clear all 
clc

SearchAgents_no=10; % Number of search agents

Function_name='F2'; % Name of the test function that can be from F1 to F23 (Table 1,2,3 in the paper)

Max_iteration=50; % Maximum numbef of iterations

load beijing
z=beijing;
% z=IMF1;
% z=water(1:1048,1);
%划分训练样本和测试样本
n=length(z);
a=z(:);
L=6;%用6个预测一个
a_n=zeros(L+1,n-L);  %L+1行，L个预测一个，最后一行是待预测样本，共形成n-L个样本
for i=1:n-L
    a_n(:,i)=a(i:i+L);%产生n-L个样本
end

input0=a_n(1:L,:);%输入样本
output0=a_n(L+1,:); %输出

%产生的n-L个样本，
%（n-L）*80%作为训练样本  
%（n-L）*20%作为预测样本 
%-------------------------------------------------------------------------
% 加载所选基准函数的详细信息
[lb,ub,dim,fobj]=Get_Functions_details('F2',input0,output0);

%[Best_score,Best_pos,WOA_cg_curve]=WOA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
 [score,Best_pos]=Jaya(lb',ub',fobj,SearchAgents_no,dim,Max_iteration);
%Draw objective space
Best_pos(end,:)
score(1,end)

[test_simu,output_test]= KELM(input0, output0, Best_pos(end,1), 'RBF_kernel',Best_pos(end,2));

Jaya_kelm = test_simu;
save Java_kelm.mat;

RMSE=sqrt(mse(output_test - test_simu))
N = max(length(output_test));
MAE=sum(abs(output_test - test_simu))/N %   Calculate testing accuracy (RMSE) for regression case
mape=mean(abs((output_test - test_simu)./output_test));
l=regstats(output_test,test_simu,'quadratic','rsquare');
R = getfield(l,'rsquare')
sprintf('KELM:RMSE=%d,MAE=%d,R=%d',RMSE,MAE,R)

figure(3)
plot(output_test,'b-d')
hold on
plot(test_simu,'r:*')
legend('真实值','预测值')
xlabel('时间')
ylabel('幅值')

        



