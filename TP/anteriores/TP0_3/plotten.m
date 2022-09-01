function plotten(x,y,H,sigma,m)
%% ************************************************************************
%
%     
% *************************************************************************

%% CONSTRUCCION DE VECTORES
n=length(x);
ang=atan(y./x);
ang(1)=0;
Ps=[x' H'];
Pi=[x' -H'];

PsR=zeros(n,2);
PiR=zeros(n,2);
PsR(1,:)=Ps(1,:);
PiR(1,:)=Pi(1,:);
ang=ang*m;

eX=zeros(n-1,6);
eY=zeros(n-1,6);
eXR=zeros(n-1,6);
eYR=zeros(n-1,6);
SIGMA=zeros(n-1,6);

for i=2:n
eX(i-1,:)=[x(i-1) Pi(i-1,1) Pi(i,1) x(i) Ps(i,1) Ps(i-1,1)];
eY(i-1,:)=[0 Pi(i-1,2) Pi(i,2) 0 Ps(i,2) Ps(i-1,2)];
    MR=[cos(ang(i)) -sin(ang(i)) ; sin(ang(i)) cos(ang(i))];
    PsR(i,:)=[MR*Ps(i,:)']';
    PiR(i,:)=[MR*Pi(i,:)']';
    PR1=MR*[x(i-1);y(i-1)];
    PR2=MR*[x(i);y(i)];
eXR(i-1,:)=[PR1(1) PiR(i-1,1) PiR(i,1) PR2(1) PsR(i,1) PsR(i-1,1)];
eYR(i-1,:)=[PR1(2) PiR(i-1,2) PiR(i,2) PR2(2) PsR(i,2) PsR(i-1,2)];
SIGMA(i-1,:)=abs([0 sigma(i-1) sigma(i) 0 sigma(i) sigma(i-1)]);
end

%% PLOTEOS
set(0,'DefaultFigureColor','w')

fill(eXR',eYR',SIGMA')
title('Tensiones');
colorbar
colormap jet
