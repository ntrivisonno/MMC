%% Transporte de un contaminante en el río

clear all;close all;clc
tStart = tic; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial setting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nx=25; % nro de nodos en x
%Nx=5;
%Ny=3; % nro de nodos en y
Ny = 10
Lx=10000; % largo en x
Ly=200; % largo en y
Lh=1;
dx=Lx/(Nx-1); 
dy=Ly/(Ny-1);
N=Nx*Ny;
Umax=0.5;
%D=1.5e-3; 
D=1.5e-2;
phi_In=1;
phi0=0;

M=zeros(N,N);
b=zeros(N,1);
vx=zeros(N);

for j=1:Ny
  for i=1:Nx
    k=(j-1)*Nx+i;
    y(k)=(j-1)*dy
  end  
end

vx=4*Umax*(y/Ly.*(1-y/Ly));


for i=(Nx+2):(N-Nx-1)  
  M(i,i) = -2/(dx^2)-2/(dy^2); % center -2/((ap(i)/w)*h);
  M(i,i-1) = 1/(dx^2)+vx(i)/(2*D*dx); % west 1/((ap(i)/w)*h);
  M(i,i+1) = 1/(dx^2)-vx(i)/(2*D*dx); % east 1/((ap(i)/w)*h);
  M(i,i-Nx) = 1/(dy^2); % south
  M(i,i+Nx) = 1/(dy^2); % north
end

for i=1:Nx % CB south
  M(i,:)=0;
  M(i,i)=1;
  M(i,i+Nx)=-1; 
  b(i)=0;     
end  
for i=(N-Nx+1):N % CB north
  M(i,:)=0;      
  M(i,i)=1;
  M(i,i-Nx)=-1; 
  b(i)=0;     
end  
for i=Nx+1:Nx:(N-2*Nx+1) % CB west
  M(i,:)=0;      
  M(i,i)=1;
  b(i)=phi0;    
end 
NIn=((Ny-1)/2)*Nx+1; 
nN=floor(Ny/10);
Nin_start=floor(NIn-nN/2*Nx);
for i=Nin_start:Nx:(Nin_start+Nx*nN)
  M(i,i)=1;
  b(i)=phi_In;
end  
for i=(2*Nx):Nx:(N-Nx) % CB east
  M(i,:)=0;      
  M(i,i)=1;
  M(i,i-1)=-1; 
  b(i)=0;    
end  


phi=inv(M)*b;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
Phi=zeros(Ny,Nx);
U=zeros(Ny,Nx);
V=zeros(Ny,Nx);

for j=1:Ny
  for i=1:Nx
    k=(j-1)*Nx+i;
    Phi(j,i)=phi(k);    
  end  
end

[X,Y] = meshgrid(0:dx:Lx,0:dy:Ly);
%R = sqrt(X.^2 + Y.^2) + eps;
%Z = sin(R)./R;

% surface in 3D
figure(1);
surf(X,Y,Phi);
title('Phi')
xlabel('X')
ylabel('Y')
view(2);

time = toc(tStart);
fprintf('*-----------------------------------------------*\n')
fprintf('\n\nFIN! - OK - time = %d[s].\n',time)
