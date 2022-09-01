%TP 02 - 2020 
clear all;close all;clc
tic
warning('off','all');
% par'ametros geom'etricos
lx = 0.1; %[m]
ly = lx/2; %[m]
espesor = 0.3; %[m]
nx = 66; % cant de nodos
ny = nx;
ntot = nx*ny;
nint = ny-2;
x = linspace(0,lx,nx);
y = linspace(0,ly,ny);
dx = x(2)-x(1);
dy = y(2)-y(1);
% par'ametros f'isicos
Tinf = 300; %[K]
h = 30; % [W/m2 K]
a1 = -100; % %[W/m2 K]
b1 = 16; %[W/m K]
b1_vec = ones(length(x),1)*b1;
kk = a1*x+b1_vec';
for o = 1:ny
    k_t(o,:)=kk;
end
k=k_t';
qLeft = 100; %[W]
Area = 2*ly*espesor; 

A = zeros(ntot);
b = zeros(ntot,1);

% boundaries
top = 2:nx-1;
right = nx:ny:nx*ny;
left = 1:nx:nx*(nint+1)+1;
sym = (nx*(nint+1))+2:ntot-1; 
int = zeros(nint*nint,1);

pp = zeros(nint,1)'; % la usamos para representar los nodos internos
% pp = []; % esto es para salvaguardar la linea anterior cuando nx!=ny
for i=1:nint
    p = i*nx+2:(i+1)*nx-1;
    pp(i,:) = p;
end
[a2 b2] = size(pp);
for i = 1:a2*b2
    int(i) = pp(i);
end
% relleno matriz de coeficientes
% nodos internos
for j = 1:length(int)
    i = int(j);
    A(i,i+1) = ((k(i+1)-k(i-1))/(4*dx^2))+(k(i)/(dx^2));
    A(i,i) = -2*k(i)/(dx^2)-2*k(i)/(dy^2);
    A(i,i-1) = -((k(i+1)-k(i-1))/(4*dx^2))+(k(i)/(dx^2));
    A(i,i+nx) = k(i)/(dy^2);
    A(i,i-nx) = k(i)/(dy^2);
    b(i) = 0;
end
% top
for j = 1:length(top)
    i = top(j);
    A(i,i) = 1/dy;
    A(i,i+nx) = -1/dy;
end
% right
for j = 1:length(right)
    i = right(j);
    A(i,i-1) = -1/dx;
    A(i,i) = 1/dx + (h/k(i));
    b(i) = Tinf*h/k(i);
end
% sym
for j = 1:length(sym)
    i = sym(j);
    A(i,i) = 1/dy;
    A(i,i-nx) = -1/dy;
end
% left
for j = 1:length(left)
    i = left(j);
    A(i,i) = -1/dx;
    A(i,i+1) = 1/dx;
    b(i) = -(qLeft/k(i))/Area;
end

T = linsolve(A,b);

% Parte analítica
% a1=0.0001; b1=1.4;
% Area=ly*espesor;
C4=-1/a1*qLeft/Area;
C5=-C4*a1/h-C4*log(a1*lx+b1)+Tinf;
% sol analitica
syms sol
analit = C4*log(a1*sol+b1)+C5;
fprintf('\nLa sol analitica es:\n\n')
pretty(analit)

for i=1:nx
  T_an(i) = C4*log(a1*x(i)+b1)+C5; %log = log en base "e", log10(x) es log en base 10, log2(x) es en abse 2, etc
end

plot(T(1:nx))
hold on
plot(T_an)
title('Temperatura - plot over line')
time1=toc
legend('Temp numerica','Temp analitica')

% ploteo de la funci'on
% hay que hacer un reshape del vector columna T en los nodos de filas y columnas
% pp = reshape(T,nx,ny)
TT = zeros(ny);
j = 1;
for o = 1:ny
    TT(o,:)=T(j:o*ny);
    j = o*ny+1;
end
% plot figure
figure();
% surf(TT) plotea la superficie soluci'on
contourf(TT);colorbar;colormap jet # plotea las superficies a nivel
time2=toc
% plot superficie
figure()
surf(TT)
% conductivity
ksolid=@(x) -100*x+16
ks0 = ksolid(0);
kslx = ksolid(lx);

fprintf('*-----------------------------------------------*\n')
fprintf('\nFIN! - OK - time = %d[s].\n',time1) 

