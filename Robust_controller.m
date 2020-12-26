function [Sdot del_v1 del_v2]= Robust_controller(t,S,vr,wr,L,Kp,Kd,...
                R,mc,m,I,b,Iwy)
%ROBUST_CONTROLLER Summary of this function goes here
%   Detailed explanation goes here

rhoR=S(1);
rhoL=S(2);
rhoR_dot=S(3);
rhoL_dot=S(4);
rhoR_des=S(5);
rhoL_des=S(6);

rhoR_des_d= vr+wr*L;
rhoL_des_d= vr-wr*L;

e=[rhoR_des-rhoR;...
    rhoL_des-rhoL];

edot=[-rhoR_dot;...
      -rhoL_dot];

E=[e;edot];
rho_dot=[rhoR_dot;rhoL_dot];

V=Kp*e+Kd*edot;

w=(rhoR_dot-rhoL_dot)/(2*L);

C=R*[((R^2/(2*L)))*mc*b*w*rhoL_dot;...
    -((R^2/(2*L)))*mc*b*w*rhoR_dot];

M=R*[2*Iwy+(R^2/(4*L^2))*(m*L^2+I),(R^2/(4*L^2))*(m*L^2-I);...
        (R^2/(4*L^2))*(m*L^2-I),2*Iwy+(R^2/(4*L^2))*(m*L^2+I)]; 

C_cap=0.5*C;

Mcap=R*[Iwy+(R^2/(4*L^2))*(m*L^2+I),(R^2/(4*L^2))*(m*L^2-I);...
        (R^2/(4*L^2))*(m*L^2-I),Iwy+(R^2/(4*L^2))*(m*L^2+I)]; 

K=[Kp Kd];              %Gains  
del_v=Del_v(M,Mcap,V,Iwy,R,m,L,I,K,C_cap,E);
del_v1=del_v(1);
del_v2=del_v(2);

u= (Mcap*(V+del_v)+C_cap);

rho_ddot=inv(M)*(u-C);

rhoR_ddot=rho_ddot(1);
rhoL_ddot=rho_ddot(2);

Sdot=[rhoR_dot ;rhoL_dot ;rhoR_ddot ;rhoL_ddot ;rhoR_des_d ;rhoL_des_d];
end

