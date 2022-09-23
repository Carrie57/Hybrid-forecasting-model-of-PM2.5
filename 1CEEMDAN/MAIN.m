clear
close all

% load('water.mat')
% data_ori = water;
load beijing.mat
data_ori=beijing';

figure(1);%原始图像
x=1:1461
plot(x,data_ori,'b');
xlabel('时间/天');
ylabel('PM2.5浓度');
xlim([0 1461])

Nstd = 0.01;
NR =500;
MaxIter = 5000;
% [a,b]=size(ship1);    
[ceemdan_imf,its] = ceemdan(data_ori,Nstd,NR,MaxIter);
save('ceemdan_imf.mat', 'ceemdan_imf') 

%% 锟斤拷示锟街斤拷锟斤拷

imf=ceemdan_imf;
[a, b]=size(imf);
figure(2);
for i=1:1:a-1
    subplot(a,1,i);
    plot(imf(i,:));
    ylabel (['IMF ' num2str(i)]);
    xlim([0 1461])
    %set(gca,'xtick',[])
    set(get(gca,'YLabel'),'FontName','Times New Roman');
    set(gca,'FontName','Times New Roman');%锟教度的达拷小
end
subplot(a,1,a)
set(gcf,'color','w')
plot(imf(a,:));
% xlabel('n')
ylabel (['IMF ' num2str(a)]);
xlabel('Time(day)')
xlim([0 1461]);
set(get(gca,'xlabel'),'FontName','Times New Roman');
set(get(gca,'ylabel'),'FontName','Times New Roman');
set(gca,'fontsize',12.0)
%set(gca,'FontName','Times New Roman');%锟教度的达拷小

% figure();%锟饺斤拷锟截癸拷锟斤拷锟轿的诧拷锟?
% plot(data_ori,'r','linewidth',1.5);
% hold on
% ceemdan_lorenz_sum = sum( ceemdan_imf,1);
% plot(ceemdan_lorenz_sum,'b','linewidth',1);
% legend('原始锟脚猴拷','锟截癸拷锟脚猴拷');
% xlim([0 2048])


