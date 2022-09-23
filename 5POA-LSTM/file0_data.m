%% 第一个运行的文件 。 用来把一列数据进行处理

clc;
clear;
close all
%%
A = xlsread("D组2K中值6H.xlsx"); %XX为文件名，文件放在POA这个文件夹里，注意xlsx格式。 excel打开为一列数据
res=A;
%% 数据重构
[a,b]=size(res);
k=1;
window_size=7;     %滑动窗口为7 ，代表前7天数据预测第8天数据
a1=a-window_size;
for m=1:a1
x(:,m)=res(k:k+7,:);% 若7改动 ，这里也要改
m=m+1;
k=k+1;
end
x=x';
input=x(:,1:end-1)';
output=x(:,end)';
 save testdata