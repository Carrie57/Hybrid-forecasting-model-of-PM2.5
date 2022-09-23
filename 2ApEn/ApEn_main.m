clc
clear
load ceemdan_imf.mat;
data=ceemdan_imf;
[m,n]=size(data);
apen=[];

for i=1:m
   biaozhun=std2(data(i,:)); 
    apen1 = ApEn( 2,  0.2* biaozhun, data(i,:), 1 );
    apen=[apen  apen1];
end
figure 
plot(1:m,apen,'*-')
xlabel ('IMF');
ylabel (['ApEn value']);
set(get(gca,'XLabel'),'FontName','Times New Roman');
set(get(gca,'YLabel'),'FontName','Times New Roman');