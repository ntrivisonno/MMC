%Generacion fractal Mandelbrot - 18/04/2019
%
%Descripcion: 
%
%Se obtiene una aproximacion al fractal del Conjunto de Mandelbrot mediante
%una matriz de puntos bidimensional. Un punto de dicha matriz pertenece a
%dicho conjunto si la sucesion {Zn+1} = {(Zn)^2 + C ; Z0 = 0} en el plano 
%complejo queda acotada. El numero C es un numero complejo a + bi ; siendo
% -2 <= a <= 2 ; -2 <= b <= 2.
%Para determinar si para un numero C la susecion es acotada, se realiza una
%cierta cantidad de iteraciones. Si luego de dichas iteraciones, Zn se
%encuentra contenido dentro de un circulo de radio 2, dicho punto C se
%considera parte del Conjunto de Mandelbrot. 

clear all;close all;clc
fprintf('Generacion fractal Mandelbrot - 18/04/2019\n\n')
tic     %inicio el timer
%Modo:
% 1 - Manual: grafica un fractal con un x0,xf,y0,yf,h determinados por el
% usuario.
% 2 - Video: genera imagenes sucesivas para elaborar un video a partir de
% los datos de 'pngdata.txt'.
% 3 - Frame: calcula un frame individual de 'pngdata.txt'.
addpath('funciones_aux/')
modo = 1;

%Limites del espacio bidimensional
data = load('/home/zeeburg/Documents/CIMEC/Cursos/MMC/adscripciones/fractales/Video - Zoom Fractal /pngdata.txt');

n = 1;   %elegir frame a graficar

pos = [data(n,2) data(n,3) data(n,4) data(n,5) data(n,6)];
%h =  pos(1);  %resolucion ejes (0.0100 - 0.0005) 0.0025
%x0 = pos(2);
%xf = pos(3);
%y0 = pos(4);
%yf = pos(5);

h =  pos(1);
x0 = -2;
xf = 0.5;
y0 = -1.25;
yf = 1.25;

x = x0:h:xf;
y = y0:h:yf;

tol = 1e-05;    % tolerancia de convergencia (0.001)
pzero = 0;      % Z0 para Conjunto Mandelbrot

maxiter = 2000; % iteraciones maximas para determinar converg. (250 - 1000)

[pp jmax] = size(x);
[pp kmax] = size(y);  

w = jmax*kmax;

xplot = zeros([jmax,kmax]);

[xmesh,ymesh,meshplot] = ndgrid(x,y,ones(jmax,1)*3);
flag = 0;
chk = 0;
cont2 = 0;

% for principal
fprintf('Iterando...\n')
for j = 1:jmax
  for k = 1:kmax
    p0 = pzero;
    iter = 0;
    if cont2 == 256
      cont2 = 0;
    else
      cont2 = cont2+1;
    end
    while flag == 0 && iter < maxiter-cont2
      p = p0^2 + x(j)+y(k)*1i;          
      delta = p - p0;
      if abs(real(delta)) < tol && abs(imag(delta)) < tol %conv por tol
        xplot(j,k) = maxiter;            
        meshplot(k,j) = -1*real(p);
        flag = 1;              
      end
      if iter == maxiter - cont2 - 1 %conv. por depasado de iterac.
        xplot(j,k) = maxiter;   
        meshplot(k,j) = -1*real(p);        
        flag = 1;
      end
      if abs(real(p)) > 2 || abs(imag(p)) > 2   %divergencia por horizonte de eventos
        flag = 1;              
        xplot(j,k) = iter; 
        meshplot(k,j) = 3;
      end
      if isnan(p) == 1 || isnan(p0) == 1    %divergencia por overflow
        flag = 1;
        xplot(j,k) = 0;         
        meshplot(k,j) = 3;
      end
      p0 = p;
      iter = iter + 1;
    end 
    flag = 0;
  end
  flag = 0;
end

%calculo grafica caos (mas fina)
if 1
  ploteo_graf_caos(1e-05,-2,0.25,225001,1e-4,2000)
end

%Ploteo fractal - cardioide
if 1
  ploteo_cardioide(x,y,xplot,h,maxiter,tol,w,n,x0,xf,y0,yf)
end

%Ploteo nube 3D
if 0
  ploteo_nube3D(xmesh,ymesh,meshplot)
end

time = toc; % ponerle el tiempo para guardarlo en una variable time
corrida = sprintf('Caso Mandelbrot - Resolucion %d - Iteraciones Max = %d - Tolerancia = %d - GDL = %d - t=%d[s] \n',h,maxiter,tol,w,time)

%Exportar Workspace
expwrkspc = 1;
if expwrkspc == 1
  fprintf('\Exportando Workspace...\n')
  wrkspc = strcat('Wrkspc_',num2str(corrida));
  save(wrkspc);
end

fprintf('*-----------------------------------------------*\n')
fprintf('\n\nFIN! - OK - time = %d[s].\n',time)
fprintf('Resolusion: %1.8f\n',h)
fprintf('Limite de iteraciones por punto: %d\n',maxiter)
fprintf('Tolerancia de convergencia: %1.3f\n\n',tol)



