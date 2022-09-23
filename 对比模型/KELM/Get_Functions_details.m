
function [lb,ub,dim,fobj] = Get_Functions_details(F,input0,output0)

switch F
    case 'F2'
        fobj = @F2;
        lb=[1,1];  
        ub=[800,70];
        dim=2;
%         lb=1;  
%         ub=700;
%         dim=1;
                    
end


function o = F2(x)
%%
%在此处调用KELM，返回RMSE均方根误差
[TY,TV1]= KELM(input0, output0, x(1), 'RBF_kernel',x(2));
o=sqrt(mse(TV1 - TY)); 

end
end
