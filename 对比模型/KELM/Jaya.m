%% Jaya algorithm
function [ fotp1,x]=Jaya( lb,ub,fobj,pop,var,maxGen )
%Jaya(lb,ub,fobj,SearchAgents_no,dim,Max_iter)
%%
mini=lb*ones(1,var);
maxi=ub*ones(1,var);
x=zeros(pop,var);
f=zeros(1,pop);
xnew=zeros(pop,var);
fnew=zeros(1,pop); 
fotp1=zeros(1,maxGen);
for i=1:var
x(:,i)=mini(i)+(maxi(i)-mini(i))*rand(pop,1);
end
%%
for i=1:pop
f(i)=fobj(x(i,:));
end 
%% main loop
gen=0;
while(gen<maxGen)  
%%
[~,tindex]=min(f);
Best=x(tindex,:);
[~,windex]=max(f);
worst=x(windex,:);
for i=1:pop
for j=1:var
r=rand(1,2);
xnew(i,j)=x(i,j)+r(1)*(Best(j)-abs(x(i,j)))-r(2)*(worst(j)-abs(x(i,j)));
end
end           
%%           
for i=1:var
xnew(xnew(:,i)<mini(i),i)=mini(i);
xnew(xnew(:,i)>maxi(i),i)=maxi(i);
end
%%          
for i=1:pop
fnew(i)=fobj(xnew(i,:));
end
%%
for i=1:pop
if(fnew(i)<f(i))
x(i,:)=xnew(i,:);
f(i)=fnew(i);
end
end
%%
gen=gen+1;
fotp1(gen)=min(f);
end
end
