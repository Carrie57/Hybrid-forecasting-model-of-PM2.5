function err=ELMfun(IW1,b1,P,T,hiddennum,IW2,b2)


IW1;
b1;

[LW,TF,TYPE] = elmtrain(P,T,hiddennum,'sig',0,IW1,b1);
T_sim = elmpredict(P,IW1,b1,LW,TF,TYPE);
err=T_sim-T;
