function del_v = Del_v(M,Mcap,v,Iwy,R,m,L,I,K,C_cap,e)
%DEL_V Summary of this function goes here
%   Detailed explanation goes here


% Upper limit of ||E|| 
alpha=norm(inv(M)*Mcap-eye(2,2));   

v_mag=norm(v);

% Upper limit for || inv(M)|| ==> M_bar
M_bar=R*[0.5*Iwy/(R^2)+(1/(4*L^2))*(m*L^2+I),(1/(4*L^2))*(m*L^2-I);...
        (1/(4*L^2))*(m*L^2-I),0.5*Iwy/(R^2)+(1/(4*L^2))*(m*L^2+I)]; 

M_bar=norm(M_bar);

%Limit function for del_v and eta_bar
%Upper bound for ||del_v|| & ||eta_bar||
rhof=(alpha/(1-alpha))* v_mag +(1/(1-alpha))*M_bar*C_cap; 

B= [0,0;...
    0,0;...
    1,0;...
    0,1];       %Input Matrix 
Q=eye(4,4);
A=[0,0,1,0;...
    0,0,0,1;...
    0,0,0,0;...
    0,0,0,0];       %System Matrix

A_bar=A-B*K;        %Hertwitz
P=lyap(A_bar,Q);

w=B'*P*e;
w_mag=norm(w);

eps=0.1;       % To avoid chattering
if(w_mag>eps)
    del_v= -rhof.*w/w_mag;
elseif(w_mag<eps)
    del_v=-rhof.*w/eps;
end


end

