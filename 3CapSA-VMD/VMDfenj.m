
clear
close all
clc
% load data
% f=data'
load ceemdan_imf
data=ceemdan_imf(2,:)
f=data;
figure(1)
plot(f,'k')
%% 第二步：6个参数设�?
%% 可改2：不断调�?2-3个参数，以期得到满意结果，如MSE更小，R更接近于1.
alpha = 1500;    % moderate(适度�?) bandwidth constraint
tau = 0;            % noise-tolerance (no strict fidelity enforcement没有强制严格的精�?)0�?0.0009
K = 7;                % 3 modes
DC = 0;             % no DC part imposed
init = 1;             % initialize omegas uniformly
tol = 1e-7;

%% 第三步：运行VMD.m，得到本证模态函数及其谱与中心频�?
%% 可改3：换成自带函数vmd.m，用其语法�??
[u, u_hat, omega] = VMD_ZHY(f, alpha, tau, K, DC, init, tol);
%omega = omega/Fs;
%按照频率由高到底排序
u=u';
for i=1:K
    y=u(:,i);
    z(:,K-i+1)=y;
end
u=z;
u=u';
res = f-sum(u,1);
% imf=u'
fIMFr = [f; u; res];  %�?1行是原始信号，最�?1行是余项
figure(3)
for i=1:K
    subplot(K,1,i);
    plot(fIMFr(i+1,:));
    ylabel (['IMF ' num2str(i)]);
    xlim([0 1461])
    %set(gca,'xtick',[])
    set(get(gca,'YLabel'),'FontName','Times New Roman');
    set(gca,'FontName','Times New Roman');
    
%     subplot(K,1,i);
%     set(gcf,'color','w')
%     plot(fIMFr(i+1,:),'k')
%     set(gca,'fontsize',13.0)
%     axis tight;
%     ylabel(['imf',int2str(i)])
end
% 
