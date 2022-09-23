 % VMD�ֽ� ������������ָ��
% clc;
% close all;
% clear all;
load('beijing.mat')
z=beijing;
% load aqi;
% z=aqi;
t=linspace(1,1461,length(z));

T = 1461;
fs = 1/T;
t = (1:T);
freqs = 2*pi*(t-0.5-1/T)/(fs);

figure(1)
plot(t,z);
set(gca,'FontName','Time New Roman')
ylabel('The concentration of PM2.5');
set(gca,'FontName','Time New Roman')
xlabel('Time/day');
xlim([1 1461]) ;


% some sample parameters for VMD
alpha = 2000;        % moderate bandwidth constraint �ʶȵĴ�������
tau = 0.3;            % noise-tolerance (no strict fidelity enforcement)  �����Ͷȣ�û���ϸ�ı����ִ�У�
K = 8;              % 5 modes 
DC = 0;             % no DC part imposed û��ʩ��DC����
init = 1;           % initialize omegas uniformly ���ȵس�ʼ��omegas
tol = 1e-7;

%--------------- Run actual VMD code

[u, u_hat, omega] = vmdd(z, alpha, tau, K, DC, init, tol);
omega(end,:)

figure(2);
subplot(8,1,1);
plot(t,u(1,:));
set(gca,'FontName','Time New Roman')
ylabel('IMF1');xlim([1 1461])   

subplot(8,1,2);
plot(t,u(2,:));
set(gca,'FontName','Time New Roman')
ylabel('IMF2');xlim([1 1461]) 

subplot(8,1,3);
plot(t,u(3,:));
set(gca,'FontName','Time New Roman')
ylabel('IMF3');xlim([1 1461]) 

subplot(8,1,4);
plot(t,u(4,:));
set(gca,'FontName','Time New Roman')
ylabel('IMF4');xlim([1 1461]) 

subplot(8,1,5);
plot(t,u(5,:));
set(gca,'FontName','Time New Roman')
ylabel('IMF5');xlim([1 1461])

subplot(8,1,6);
plot(t,u(6,:));
set(gca,'FontName','Time New Roman')
ylabel('IMF6');xlim([1 1461])

subplot(8,1,7);
plot(t,u(7,:));
set(gca,'FontName','Time New Roman')
ylabel('IMF7');xlim([1 1461])

subplot(8,1,8);
plot(t,u(8,:));
set(gca,'FontName','Time New Roman')
ylabel('IMF8');xlim([1 1461])

% 
IMF1=[u(1,:)]';
IMF2=[u(2,:)]';
IMF3=[u(3,:)]';
IMF4=[u(4,:)]';
IMF5=[u(5,:)]';
IMF6=[u(6,:)]';
IMF7=[u(7,:)]';
IMF8=[u(8,:)]';
% IMF9=[u(9,:)]';

 c=IMF1+IMF2+IMF3+IMF4+IMF5+IMF6+IMF7+IMF8;
% % % c=IMF1+IMF2+IMF3+IMF4+IMF5+IMF6+IMF7+IMF8+IMF9;
% 
figure(3)
P1=plot(1:1461,z,'r-*',1:1461,c,'b-o')
% MAPE=sum(abs((c-z)./z))./1154

% 
% 
