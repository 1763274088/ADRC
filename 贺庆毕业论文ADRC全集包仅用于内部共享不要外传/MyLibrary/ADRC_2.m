function [sys,x0,str,ts]=ADRC_2(t,x,u,flag,h,TD,ESO,NLSEF,b0)

switch flag
    case 0
        [sys,x0,str,ts]=mdlInitializeSizes(h);
    case 2
        sys=mdlUpdate(x,u,h,TD,ESO,b0);
    case 3
        sys=mdlOutputs(x,NLSEF,b0);
    case 4,
        sys=mdlGetTimeOfNextVarHit(t,h);
    case {1,9}
        sys=[];
    otherwise 
        error(['Unhandled flag=',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes(h)
    sizes=simsizes;
    sizes.NumContStates=0;
    sizes.NumDiscStates=5;
    sizes.NumOutputs=2;
    sizes.NumInputs=3;
    sizes.DirFeedthrough=1;
    sizes.NumSampleTimes=1;
    sys=simsizes(sizes);
    x0=[0;0;0;0;0];
    str=[];
    ts=[h 0];
function sys=mdlUpdate(x,u,h,TD,ESO,b0)
    e1=x(1)-u(1);
    fh=fhan(e1,x(2),TD(1),TD(2));
    sys(1)=x(1)+h*x(2);
    sys(2)=x(2)+h*fh;
    e2=x(3)-u(2);
    sys(3)=x(3)+h*(x(4)-ESO(1)*e2);
    sys(4)=x(4)+h*(x(5)-ESO(2)*fal(e2,0.5,ESO(4))+b0*u(3));
    sys(5)=x(5)+h*(-ESO(3)*fal(e2,0.25,ESO(4)));
%     fe=fal(e,0.5,Delta);
%     fe1=fal(e,0.25,Delta);
%     sys(1,1)=x(1)+h2*(x(2)-BB(1)*e);
%     sys(2,1)=x(2)+h2*(x(3)-BB(2)*fe+u(1));
%     sys(3,1)=x(3)+h2*(-BB(3)*fe1);
function sys=mdlOutputs(x,NLSEF,b0)
    e3=x(1)-x(3);
    e4=x(2)-x(4);
    sys(1)=-fhan(e3,NLSEF(1)*e4,NLSEF(2),NLSEF(3))-x(5)/b0;
    sys(2)=x(1);
function sys=mdlGetTimeOfNextVarHit(t,h)
    sys=t+h;
        
function y=fhan(x1,x2,r,h)
d=r*h;
d0=h*d;
y=x1+h*x2;
a0=sqrt(d^2+8*r*abs(y));
if abs(y)>d0
    a=x2+(a0-d)*sign(y)/2;
else
    a=x2+y/h;
end

if abs(a)>d
    y=-r*sign(a);
else 
    y=-r*a/d;
end

function f=fal(e,a,d)
    if abs(e)<d
        f=e*d^(a-1);
    else f=(abs(e))^a*sign(e);
    end