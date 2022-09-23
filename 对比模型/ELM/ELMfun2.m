function T_sim=ELMfun2(IW1,b1,P,T,hiddennum,IW2,b2)

inputnum=size(P,1);       
outputnum=size(T,1);     

IW1;
b1;

[LW,TF,TYPE] = elmtrain(P,T,hiddennum,'sig',0,IW1,b1);
T_sim = elmpredict(P,IW1,b1,LW,TF,TYPE);
