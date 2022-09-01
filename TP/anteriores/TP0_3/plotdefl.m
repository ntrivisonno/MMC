function plotdefl(x,y,H,grad_def)
%% ************************************************************************
%           Función para graficar la deformada de la viga
% *************************************************************************

%----
% IMP=>todo los vectores son de orden size(vector)=(1,:) horizontales (vector filas)
%---
% x=vector fila puntos del dominio [mm]
% y=vector fila deflexión [mm]
% H= altura en [mm]
% m=grado de deformación, a poner por el usuario. suj. 250

%% CONSTRUCCION DE VECTORES
n=length(x);
ang=atan(y./x);
ang(1)=0;

Ps=[x' H'];             %Punto superior
Pi=[x' -H'];            %Punto inferior

eX=zeros(n-1,4);
eY=zeros(n-1,4);
eXR=zeros(n-1,4);
eYR=zeros(n-1,4);

PsR=zeros(n,2);
PiR=zeros(n,2);
PsR(1,:)=Ps(1,:);
PiR(1,:)=Pi(1,:);
ang=ang*grad_def ;

for i=2:n
eX(i-1,:)=[Pi(i-1,1) Pi(i,1) Ps(i,1) Ps(i-1,1)];
eY(i-1,:)=[Pi(i-1,2) Pi(i,2) Ps(i,2) Ps(i-1,2)];
    MR=[cos(ang(i)) -sin(ang(i)) ; sin(ang(i)) cos(ang(i))];
    PsR(i,:)=[MR*Ps(i,:)']';
    PiR(i,:)=[MR*Pi(i,:)']';
eXR(i-1,:)=[PiR(i-1,1) PiR(i,1) PsR(i,1) PsR(i-1,1)];
eYR(i-1,:)=[PiR(i-1,2) PiR(i,2) PsR(i,2) PsR(i-1,2)];
end
DATA=abs(y(2:n));

%% PLOTEOS
set(0,'DefaultFigureColor','w')

fill(eXR',eYR',DATA)
title('Desplazamientos');
colorbar
colormap jet
