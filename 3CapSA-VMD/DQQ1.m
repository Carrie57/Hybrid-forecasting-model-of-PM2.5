function F=DQQ1(K,alpha)
load ceemdan_imf
data=ceemdan_imf(2,:)
f=data'
%% VMD参数
% alpha = 2000;    % moderate(适度的) bandwidth constraint
tau = 0;            % noise-tolerance (no strict fidelity enforcement没有强制严格的精度)0，0.0009
% K = 3;                % 3 modes
DC = 0;             % no DC part imposed
init = 1;             % initialize omegas uniformly
tol = 1e-7;
%% 第三步：运行VMD.m，
[u, u_hat, omega] = VMD_ZHY(f, alpha, tau, K, DC, init, tol);
imf=u';
% 适应度函数(相关系数)建议用相关系数
% CSig_110=sum(imf(:,1:K),2)';
% % 相关系数可以
% RSig_110=abs(corr(f',CSig_110'))
% F=1-RSig_110% 1-相关系数做适应值
% %适应度函数(峭度)
% 提取全部IMF的峭度
 %1、计算全部IMF分量（不包括残余项）的峭度
 QD_2=[];   %各IMF分量的峭度值的保存
 QD_total_2=0;
 for i=1:K %%这里计算IMF和残余项的峭度
 QD_2(i) = kurtosis(imf(:,i));  
 QD_total_2=QD_total_2+QD_2(i);  %这里是全部的峭度值总和
 end
 for i=1:K    %%这里是峭度的归一化，你可以不用
     G_QD_2(i)=QD_2(i)/QD_total_2;
 end 
 disp('IMF分量（不包括残余项）的峭度(未归一化)');
 QD_2
 disp('IMF分量（不包括残余项）的峭度(归一化)');
 G_QD_2
 
   G_QD_4=max(max( QD_2))%取最大值
   F1=G_QD_4
 %% 计算包络谱
 imf=imf'
for i=1:K
   y_ht=hilbert(imf(i,:));%希尔伯特变换
   y_A(i,:)=abs(y_ht);   %包络信号,y_A包络谱对应幅值
end;

for i=1:K
    p2(i,:)=y_A(i,:)./sum(y_A(i,:));  %对包络值进行归一化
    B(i) = -sum(p2(i,:).*log(p2(i,:))); 
    BLS(i)=B(i)./log(length(imf(i,:)));     %计算LCD分解后每个分量的包络熵
end;
   F2=min(min(BLS));%取包络熵最小值
% % %适应度函数
F=F2/F1;
%取包络熵为适应度函数
%F=F2


