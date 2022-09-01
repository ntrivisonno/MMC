clc
close all
clear all

%% carga de datos mediante el menu 

%carga de datos de dominio y cantidad de nodos
m=0;
while m == 0
    g = inputdlg({'Dominio eje x','Dominio eje y','separaci�n entre nodos en x','separaci�n nodos en y'});
    j = str2double(g);
    X = j(1); y = j(2);
    Dx = j(3);
    Dy = j(4);
    nx = X/Dx+1;
    ny = y/Dy+1;
    if (mod(nx,1) == 0) && (mod(ny,1)== 0)
            m=1;
        else
           uiwait(msgbox ('El n�mero de nodos en x e y debe ser entero','�Ingrese valores v�lidos!','modal'));
    end
end
%carga de valores de condiciones de borde izq y superior
cond = inputdlg({'Valor condici�n de borde izquierda de tipo Dirichlet','Valor condici�n de borde derecho de tipo Dirichlet','Valor condici�n de borde inferior de tipo Dirichlet','Valor condici�n de borde superior de tipo Neumann'});
S = str2double(cond);
CBIZQ = S(1); CBDER = S(2); CBINF = S(3); CBSUP = S(4);

%% Carga de la matriz A y b

%Nodos internos
n_total=nx*ny;
A = zeros (n_total);
b = zeros (n_total,1);

for i=2:nx-1
    for j=2:ny-1
        A(j+(i-1)*ny,j+(i-1)*ny-ny)= 1/(Dx^2);%nodo superior

        A(j+(i-1)*ny,j+(i-1)*ny-1)= 1/(Dy^2);%nodo izq.
        A(j+(i-1)*ny,j+(i-1)*ny)=(-2)*(Dx^(-2)+Dy^(-2));%nodo central
        A(j+(i-1)*ny,j+(i-1)*ny+1)= 1/(Dy^2);%nodo der.

        A(j+(i-1)*ny,j+(i-1)*ny+ny)= 1/(Dx^2);%nodo inferior
    end
end

%Condici�n borde derecho
for i=2:nx-1
    A(i*ny,i*ny) = 1;
    b(i*ny,1) = CBDER;
end

%Condici�n borde izquierdo
for i=2:nx-1
    A(1+ny*(i-1),1+ny*(i-1)) = 1;
    b(1+ny*(i-1),1) = CBIZQ;
end

%Condici�n borde superior
for j=1:ny
    A(j,j) = -1; %nodo central
    A(j,j+ny) = 1; %nodo inferior
    b(j,1)=CBSUP*Dx; %valor de t.i.
end

%Condici�n borde inferior
for j=1:ny
    A(j+ny*(nx-1),j+ny*(nx-1)) = 1; %nodo central
%     A(j+ny*(nx-1),j+ny*(nx-2)) = -1; %nodo superior
    b(j+ny*(nx-1),1) = CBINF; %valor de t.i.
end

%Resoluci�n de sistema lineal
Temp = A\b;

%% Gr�fico de soluci�n
msol = zeros(ny,nx);
for i=1:nx
    for j=ny:-1:1
        msol(j,i)=Temp(j+(i-1)*ny,1);
    end
end

domx=linspace(0,X,nx);
domy=linspace(0,y,ny);

subplot(1,2,1)
surf(domx,domy,msol) %gr�fica superficie
xlabel('Eje x'), ylabel('Eje y'), zlabel('Temperatura [�]')
title('Superficie de temperaturas');

subplot(1,2,2)
contour(domx,domy,msol) %gr�fica curvas de nivel
xlabel('Eje x'), ylabel('Eje y'), title('Curvas de nivel');

%matriz de valores trasnpuesta para visualizar bien los resultados, ya que
%msol est� adaptada para ver bien el gr�fico desde arriba
tmsol = msol';

%% Soluci�n anal�tica

