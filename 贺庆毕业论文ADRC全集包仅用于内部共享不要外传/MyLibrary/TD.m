function [sys,x0,str,ts] = TD(t,x,u,flag,r0,h)
%��������,��TD��ΪS-���������ƣ��ɻ��������ĺ�����
%tΪ��ǰ����ʱ�䣬xΪ״̬������uΪ����������flag���Ա�ʾS-������ǰ�����ķ��沽�裬�Ա�ִ����Ӧ�Ļص�
switch flag,
  case 0 % ��ʼ��
    [sys,x0,str,ts] = mdlInitializeSizes(h);
  case 2 % ��ɢ״̬�ĸ���
    sys = mdlUpdates( x,u,r0,h);
  case 3 % ��������ź�
    sys = mdlOutputs(x);
  case {1,4,9} % ����Ҫ��ֵ
    sys = [];
otherwise % ������
    error( ['unhandled flag = ',num2str( flag) ]) ;
end;
% ������������������flag = 0�� ����ϵͳ�ĳ�ʼ��������������������
function [sys,x0,str,ts] = mdlInitializeSizes(h)
    sizes = simsizes; % �����ṹ sizes
% �ó�ʼ����Ϣ���ṹ sizes
    sizes.NumContStates = 0; % ����״̬���� 0 ��
    sizes.NumDiscStates = 2; % ��ɢ״̬���� 2 ��
    sizes.NumOutputs = 2; % ������� 2 ��
    sizes.NumInputs = 1; % ������� 1 ��
    sizes.DirFeedthrough = 0; % ����в���������
    sizes.NumSampleTimes = 1; % ģ��������ڵĸ���
    sys = simsizes( sizes) ; % ��ϵͳ������ʼ��
    x0 = [0; 0]; % ���ó�ʼ״̬
    str = []; % ���ñ�������Ϊ�վ���
    ts = [h 0]; % �̳�����Ĳ�������
% ��������������flag = 2�� ������ɢϵͳ״̬���� ������������
function sys = mdlUpdates( x,u,r0,h)
    sys(1,1) = x(1) + h* x(2) ;
    sys(2,1) = x(2) + h* fhan(x(1)-u,x(2),r0,h);
% ����������������������flag = 3�� ��������� ����������������������
function sys = mdlOutputs( x)
    sys = x;
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