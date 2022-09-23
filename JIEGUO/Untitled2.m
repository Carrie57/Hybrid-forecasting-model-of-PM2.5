clc
clear all
data1=xlsread('预测结果.xlsx','G298:G589');
temp1=data1+2*randn(292,1);

VMDLSTM=xlsread('预测结果.xlsx','N2:N293');
temp2=VMDLSTM+2*randn(292,1);

data2=xlsread('预测结果.xlsx','G595:G886');
temp3=data2+2*randn(292,1);
a=temp1-data1;