

function[Score,Position,Convergence]=CapSA(Search_Agents,Max_iterations,Lba,Uba,Lbb,Ubb,dimension,objective)

Position=zeros(1,dimension);
Score=inf; 

Positions=init(Search_Agents,dimension,Uba,Lba);
n=size(Positions,2);
Positions(:,3:4)=init(Search_Agents,dimension,Ubb,Lbb);
Convergence=zeros(1,Max_iterations);

l=0;

while l<Max_iterations
    
    sprintf('当前第%d代',l);
    for i=1:size(Positions,1)  
       for j=1:n
           Flag4Upperbounda=Positions(i,j)>Uba;
        Flag4Lowerbounda=Positions(i,j)<Lba;
        Positions(i,j)=(Positions(i,j).*(~(Flag4Upperbounda+Flag4Lowerbounda)))+Uba.*Flag4Upperbounda+Lba.*Flag4Lowerbounda;
        
        Flag4Upperboundb=Positions(i,j+n)>Ubb;
        Flag4Lowerboundb=Positions(i,j+n)<Lbb;
        Positions(i,j+n)=(Positions(i,j+n).*(~(Flag4Upperboundb+Flag4Lowerboundb)))+Ubb.*Flag4Upperboundb+Lbb.*Flag4Lowerboundb;
 
         Positions(i,j)=round(Positions(i,j));
        fitness=objective(Positions(i,j),Positions(i,j+n));
        
        if fitness<Score 
            Score=fitness; 
            Position(1)=Positions(i,j);
             Position(2)=Positions(i,j+n);
        end
        

    end
    
    
    Sa=2-l*((2)/Max_iterations); 
    
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)
            if j<=2;
            r1=0.5*rand(); 
            r2=0.5*rand();             
            X1=2*Sa*r1-Sa;  
            b=1;             
            ll=(Sa-1)*rand()+1;         
            D_alphs=Sa*Positions(i,j)+X1*((Position(1)-Positions(i,j)));                   
            res=D_alphs*exp(b.*ll).*cos(ll.*2*pi)+Position(1);
            Positions(i,j)=res;     
            else
              D_alphs=Sa*Positions(i,j)+X1*((Position(2)-Positions(i,j)));                   
            res=D_alphs*exp(b.*ll).*cos(ll.*2*pi)+Position(2);
            Positions(i,j)=res; 
            end
             end
        
    end
    l=l+1;    
    Convergence(l)=Score;
    end
end



