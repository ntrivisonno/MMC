% trabajo final matematicas - doctorado 2021
clear all; clc; close all
tStart = tic; 

% DATOS
a = 10000; % largo rio
b = 200;   % ancho rio
nx = 41;
ny = 21;
D = 0.015; % difusividad
%D =0

%% Discretizacion
x = linspace(0,a,nx);
y = linspace(0,b,ny);
dx = x(2)-x(1);
dy = y(2)-y(1);

% Funcion Velocidad
Dominio = 0:0.05:b;
v = @(y) -1/20000*y.^2 + 1/100*y;
vx = v(Dominio);

% Funcion Velocidad para el Punto c
% b=0.013
%v = @(y) (-b/200)*y.^2 + b*y;
% vx = v(Dominio);

% Armado A y B
A = zeros(nx*ny);   % A: matriz a coef
B = zeros(nx*ny,1); % B: term independiente

% Nodos izquierdos
for i=1:nx:nx*ny 
    A(i,i)=1;
end

% Nodos Derechos
for i=nx:nx:nx*ny 
    A(i,i)=1/dx;
    A(i,i-1)=-1/dx;
end

% Nodos Inferiores
for i=2:nx-1
    A(i,i)=-1/dy;
    A(i,i+nx)=1/dy;
end

% Nodos Superiores
for i=nx*ny-nx+2:nx*ny-1
    A(i,i)=1/dy;
    A(i,i-nx)=-1/dy;
end

% Nodos Centrales
for j=1:ny-2 %internos
    for i=j*nx+2:(j+1)*nx-1
        A(i,i)=(-2*D/dx^2)-2*D/dy^2;
        A(i,i-1)=(D/dx^2)+v(j*dy)/(2*dx);
        A(i,i+1)=(D/dx^2)-v(j*dy)/(2*dx);
        A(i,i-nx)=D/dy^2;
        A(i,i+nx)=D/dy^2;
    end
end 
delta = 90
while delta <= 110
    for i = nx*round((b/ny)-1)+1:nx:nx*(round(b/ny))+(nx+1)
        B(i ,1) = 1;     
        delta = delta+dy;
    end
 end 
% Vector de resultados
Phi = A\B;

% Matriz de resultados
for i= ny:-1:1 
    PhiM(i,:) = Phi((i-1)*nx+1:i*nx);
end

% Gráfica Distribución de Contaminante
surf(x,y,PhiM)
%surfc(x,y,PhiM) % plotea superficie con linea de contorno 
title('Distribucion de contaminante en el rio')
xlabel('Costa del rio')
ylabel('Ancho del rio')
zlabel('Nivel de concentracion de contaminante')
zlim([-0.5 1]);%view([65 322])
colormap(jet(20));colorbar

figure();
%subplot(2,1,1)
contourf(x,y,PhiM)
colormap(jet(20));colorbar;
title('Distribucion de contaminante en el rio')
xlabel('Costa del rio')
ylabel('Ancho del rio')

if 0
  figure()
  %subplot(2,1,2)
  plot(vx,Dominio,'linewidth',2)
  title('Perfil de velocidad del rio')
  xlabel('Costa del rio')
  ylabel('Ancho del rio')
end

% Nivel de contaminante en la costa
fprintf('Concentracion de contaminante en la costa: %d\n',PhiM(ny*33))

time = toc(tStart);
fprintf('*-----------------------------------------------*\n')
fprintf('\n\nFIN! - OK - time = %d[s].\n',time)
