tic
clear all
clc
SearchAgents=30; %种群数
Max_iterations=10;%最大迭代次数
lowerbounda=2; 
 upperbounda=9;% K取值范围
 lowerboundb=1500
 upperboundb=4000;% 惩罚因子 取值范围
  dimension=2;%寻优维数
[Best_score,Best_pos,CapSA_curve]=CapSA(SearchAgents,Max_iterations,lowerbounda,upperbounda,lowerboundb,upperboundb,dimension,@DQQ1);
toc
figure(1)
% plots=semilogx(CapSA_curve,'Color','k'); 
plot(CapSA_curve);
xlim=[1,30];
% set(plots,'linewidth',2)
title('Objective space')
xlabel('Iterations');
ylabel('Best score');%适应度值随着迭代次数变化

axis tight
grid on
box on
legend('CapSA')

display(['The best solution obtained by CapSA is : ', num2str(Best_pos)]);%输出分解层数与惩罚因子
display(['The best optimal value of the objective funciton found by CapSA: ', num2str(Best_score)]);