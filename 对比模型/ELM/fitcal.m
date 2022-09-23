function fitval = fitcal(pm,indim,hiddennum,outdim,D,Ptrain,Ttrain,minAllSamOut,maxAllSamOut)
[x,y,z]=size(pm);
for i=1:x
    for j=1:hiddennum
        x2iw(j,:)=pm(i,((j-1)*indim+1):j*indim,z);
    end
    for k=1:outdim
        x2lw(k,:)=pm(i,(indim*hiddennum+1):(indim*hiddennum+hiddennum),z);
    end
    x2b=pm(i,((indim+1)*hiddennum+1):D,z);
    x2b1=x2b(1:hiddennum).';
    x2b2=x2b(hiddennum+1:hiddennum+outdim).';

    IW1=x2iw;  
    IW2=x2lw;  
    b1=x2b1;  
    b2=x2b2;
    
    error=ELMfun(IW1,b1,Ptrain,Ttrain,hiddennum,IW2,b2);
    fitval(i,1,z)=mse(error); 
end