%TP 4 cátedra
close all;clear;clc

L=3000/1000; %longitud m
rho=1000; %kg/m3
u=1.0020*1e-3; %Pa.s viscocidad dinamica
tf=3000; %tiempo total s
nt=50; %divisiones temporales
H=50/1000; %distancia entre placas
ny=20; %divisiones longitudinales
vm=8; %velocidad promedio m/s 

%vmax_mod=5*1.5;
%deltaP=vmax_mod*16*u*L/H^2

dP=1.5*vm*8*u*L/H^2; %Pa
dP=19.24;
v=u/rho; %viscocidad cinematica
y=linspace(0,H/2,ny);
dy=H/2/(ny-1);
t=linspace(0,tf,nt);
dt=tf/(nt-1);

B=-1/rho*-dP/L; %coeficiente B
C=v*dt/dy^2; %coeficiente C

Vx=zeros(ny,nt); %matriz de velocidades
Vx(:,1)=0; %condicion inicial sobre todos los nodos
K=zeros(ny);
N=zeros(ny,1);

Vx0=Vx(:,1);
for k=2:nt

    for i=2:ny-1    
        K(i,i)=1+2*C;
        K(i,i-1)=-C;
        K(i,i+1)=-C;
        N(i)=Vx0(i)+B*dt;
    end

        K(1,1)=1;
        N(1)=0;     
        
        K(ny,ny)=3;
        K(ny,ny-1)=-4;
        K(ny,ny-2)=1;
        N(ny)=0;               

Vxf=linsolve(K,N);
Vx(:,k)=Vxf;
Vx0=Vxf;
end

%veo el elemento 20 como la zona donde ya se estabiliza.
Vx_MAX=max(Vx);
T_EST=t(25);
VMAX_MDF=Vx_MAX(25)
VMAX_POI=1/u*dP/L*H^2/8
%Vmed=trapz(Vx(:,nt))*dy/(H/2)

figure(1)
set(0,'DefaultFigureColor','w')
plot(t,Vx_MAX)
title('Velocidad X [m/s]'); xlabel('Tiempo [s]'); ylabel('Velocidad [m/s]')
grid on

figure(2)
plotperfil(H,Vx,0)

figure(3)
plotvel(H,L,Vx,0)

%clearvars -except dP VMAX_MDF VMAX_POI T_EST Vx