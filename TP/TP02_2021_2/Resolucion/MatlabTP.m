clear all
clc
close all

tStart = tic; % son timer de multivariables, para cuando hay muchos timers en el prog

%% Discretización de dominio

nx=50;
X0=0;
Xf=3e-1;
Dx=Xf/(nx-1);

domx=linspace(X0,Xf,nx);

ny=50;
Y0=0;
Yf=4.7e-1;
Dy=Yf/(ny-1);

domy=linspace(Y0,Yf,ny);

n_total=nx*ny;

%% Definición de constantes

h=5;     %W/m2K
k=390;   %W/m2K cobre
% k=47;    %W/m2K acero
e=1.5e-3;%espesor (VER SI VA EN METROS)
Tamb=22; %T ambiente

%% Definición de matriz y vector
i=1:n_total;
A(i,i)=0;
b(i,1)=0;

%% Nodos internos
for j=2:ny-1
    for i=2:nx-1
        
        A(i+(j-1)*nx,i+(j-1)*nx-nx)= k/(Dy^2);%nodo inferior
        
        A(i+(j-1)*nx,i+(j-1)*nx-1)= k/(Dx^2);%nodo izq.
        A(i+(j-1)*nx,i+(j-1)*nx)=(-2*k)*(Dx^(-2)+Dy^(-2))-2*h/e;%nodo central
        A(i+(j-1)*nx,i+(j-1)*nx+1)= k/(Dx^2);%nodo der.
        
        A(i+(j-1)*nx,i+(j-1)*nx+nx)= k/(Dy^2);%nodo superior
        
        b(i+(j-1)*nx)=-2*h*Tamb/e;
    end
end

%% Nodos internos por partes
% for i=2:nx-1
%         x=(i-1)*Dx;
%     if (x >= 0) && (x <=20)
%         for j=2:ny-1
%             A(i+(j-1)*nx,i+(j-1)*nx-nx)= 1/(Dy^2);%nodo inferior
%             
%             A(i+(j-1)*nx,i+(j-1)*nx-1)= 1/(Dx^2);%nodo izq.
%             A(i+(j-1)*nx,i+(j-1)*nx)=(-2)*(Dx^(-2)+Dy^(-2));%nodo central
%             A(i+(j-1)*nx,i+(j-1)*nx+1)= 1/(Dx^2);%nodo der.
%             
%             A(i+(j-1)*nx,i+(j-1)*nx+nx)= 1/(Dy^2);%nodo superior
%             
%             b(i+(j-1)*nx)=0;
%         end
%     else
%         for j=2:ny-1
%             A(i+(j-1)*nx,i+(j-1)*nx-nx)= k/(Dy^2);%nodo inferior
%             
%             A(i+(j-1)*nx,i+(j-1)*nx-1)= k/(Dx^2);%nodo izq.
%             A(i+(j-1)*nx,i+(j-1)*nx)=(-2*k)*(Dx^(-2)+Dy^(-2))-2*h/e;%nodo central
%             A(i+(j-1)*nx,i+(j-1)*nx+1)= k/(Dx^2);%nodo der.
%             
%             A(i+(j-1)*nx,i+(j-1)*nx+nx)= k/(Dy^2);%nodo superior
%             
%             b(i+(j-1)*nx)=-2*h*Tamb/e;
%         end
%     end
% end

%% CB para bordes horizontales
for i=2:nx-1
    %ABAJO
%NEUMANN
%     A(i,i)=-1; %nodo central
%     A(i,i+nx)=1;%nodo superior
%     b(i)=0;
%DIRICHLET
    A(i,i)=1;%nodo central
    b(i)=  0.0245*(Dx*(i-1))^2-1.1826*(Dx*(i-1)) + 100;
    
    %ARRIBA
%NEUMANN
    A(i+nx*(ny-1),i+nx*(ny-1))=1;%nodo central
    A(i+nx*(ny-1),i+nx*(ny-2))=-1;%nodo inferior
    b(i+nx*(ny-1))=0;
%DIRICHLET
%     A(i+nx*(ny-1),i+nx*(ny-1))=1;%nodo central
%     b(i+nx*(ny-1))=;
end

%% PARA CONDICIONES POR PARTES
%     x=(i-1)*Dx;
%     if (x >= 0) && (x <= 20)
%         %arriba
%         A(i+nx*(ny-1),i+nx*(ny-1))=1;%nodo central
%         b(i+nx*(ny-1))=350;
%         %abajo
%         A(i,i)=1;%nodo central
%         b(i)=350;
%     else
%         %arriba
%         A(i+nx*(ny-1),i+nx*(ny-1))=1;%nodo central
%         A(i+nx*(ny-1),i+nx*(ny-2))=-1;%nodo inferior
%         b(i+nx*(ny-1))=0;
%         %abajo
%         A(i,i)=-1; %nodo central
%         A(i,i+nx)=1;%nodo superior
%         b(i)=0;
%     end

%% CB para bordes verticales
for i=1:ny
    %DERECHA
%NEUMANN
    A(i*nx,i*nx)=1; %central
    A(i*nx,i*nx-1)=-1; %anterior
    b(i*nx)=0;
    
    %IZQUIERDA
    %DIRICHLET
    A(1+nx*(i-1),1+nx*(i-1))=1;
    b(1+nx*(i-1))= 0.0098*(Dy*(i-1))^2  - 0.8078*(Dy*(i-1)) + 100;
%NEUMANN
%     A(1+nx*(i-1),1+nx*(i-1))=1; %izq
%     A(1+nx*(i-1),1+nx*(i-1)+1)=1; %siguiente

end

%% Resolver sistema matriz-vector
phi = linsolve(A,b);

%% Gráfico de solución

for j=ny:-1:1
    for i=1:nx
        msol(j,i)=phi(i+(ny-j)*nx,1);
    end
end

surf(domx,domy,msol);

time = toc(tStart);
fprintf('*-----------------------------------------------*\n')
fprintf('\n\nFIN! - OK - time = %d[s].\n',time)
