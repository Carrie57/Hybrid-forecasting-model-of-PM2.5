%% ��һ�����е��ļ� �� ������һ�����ݽ��д���

clc;
clear;
close all
%%
A = xlsread("D��2K��ֵ6H.xlsx"); %XXΪ�ļ������ļ�����POA����ļ����ע��xlsx��ʽ�� excel��Ϊһ������
res=A;
%% �����ع�
[a,b]=size(res);
k=1;
window_size=7;     %��������Ϊ7 ������ǰ7������Ԥ���8������
a1=a-window_size;
for m=1:a1
x(:,m)=res(k:k+7,:);% ��7�Ķ� ������ҲҪ��
m=m+1;
k=k+1;
end
x=x';
input=x(:,1:end-1)';
output=x(:,end)';
 save testdata