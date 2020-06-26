%Generacion fractal Julia - 07/04/2020
%
%Descripcion: 
%
%Se obtiene una aproximacion al fractal del Conjunto de Julia  mediante
%una matriz de puntos bidimensional. Un punto de dicha matriz pertenece a
%dicho conjunto si la sucesion {Zn+1} = {(Zn)^2 + C ; Z0 = Z}
%queda acotada. El numero C es un numero complejo a + bi ; siendo
% -2 <= a <= 2 ; -2 <= b <= 2.
%Para determinar si para un numero Z la susecion es acotada, se realiza una
%cierta cantidad de iteraciones. Si luego de dichas iteraciones, Zn se
%encuentra contenido dentro de un circulo de radio 2, dicho punto C se
%considera parte de dicho Conjunto Julia en particular.

clear all;clc;close all;

tic
fprintf('Generacion fractal Julia - 07/04/2020\n\n')

%Limites del espacio bidimensional
x0 = -2;    
xf = 2;     
y0 = -2;    
yf = 2;     

h = 0.0005;  %resolucion ejes (0.010 - 0.001) 0.0025

x = x0:h:xf;
y = y0:h:yf;

tol = 0.001;  %tolerancia de convergencia (0.001)
c =  -0.8 + 0.156*1i;     %Coef. de fractal 
maxiter = 500; %iteraciones maximas para determinar converg. (250 - 1000)

[pp jmax] = size(x);
[pp kmax] = size(y);  

w = jmax*kmax;

xplot = zeros([jmax,kmax]);

flag = 0;
chk = 0;

fprintf('Iterando...\n')

for j = 1:jmax
  chk = chk + 1;
  if chk == 100
    fprintf('Iter %2.1f %%\n',(j/(jmax-1))*100)
    chk = 0;
  end
  for k = 1:kmax
    p = x(j) + y(k)*1i;
    iter = 0;
    while flag == 0 && iter < maxiter
      p0 = p;
      p = p0^2 + c;          
      delta = p - p0;
      if abs(real(delta)) < tol && abs(imag(delta)) < tol %conv por tol
	xplot(j,k) = maxiter;            
        flag = 1; 
      end
      if iter == maxiter - 1 %conv. por depasado de iterac.
        xplot(j,k) = maxiter;             
        flag = 1;
      end
      if abs(real(p)) > 2 || abs(imag(p)) > 2   %divergencia por horizonte de eventos        
        flag = 1;
        xplot(j,k) = iter;
      end
      if isnan(p) == 1 || isnan(p0) == 1    %divergencia por overflow
        flag = 1;
        xplot(j,k) = 0;                 
      end
      p0 = p;
      iter = iter + 1;
    end 
    flag = 0;
  end
  flag = 0;
end
 
%Plot
fprintf('\nPloteando...\n')
figure(1)
imagesc(x,y,rot90(xplot));  %giro la matriz por cuestiones de almacenamiento
t1 = sprintf('Julia - Resolucion  %d - GDL = %d  \n',h,w);
t2 = sprintf('Julia #%d - h = %f - X [%f ; %f] - Y [%f ; %f]\n',n,h,x0,xf,y0,yf); %n: frame a graficar
title(t2);
colormap ('jet');
hold on
colorbar
pbaspect([1 1 1])

%exportar en .PNG (600 dpi)
%fprintf('\nExportando PNG...\n\n')
%print(1,'Julia.png','-dpng','-r600');

time = toc;
corrida = sprintf('Caso Julia - Resolucion %d - Iteraciones Max = %d - Tolerancia = %d - GDL = %d - t=%d[s] \n',h,maxiter,tol,w,time)
fprintf('*-----------------------------------------------*\n')
fprintf('\n\nFIN! - OK - time = %d[s].\n',time)
fprintf('Resolusion: %1.4f\n',h)
fprintf('C: %1.4f + %1.4fi\n',real(c),imag(c))
fprintf('Limite de iteraciones por punto: %d\n',maxiter)
fprintf('Tolerancia de convergencia: %1.3f\n',tol)
           
