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
 
clear
clc
fprintf('Generador de imagenes fractal Mandelbrot - 18/04/2019\n\n')
 
%Limites del espacio bidimensional
data = load('pngdata.txt');
data_v = size(data);
total_frames = data_v(1);
ttotal = 0;
 
for frm = data(1,1):data(total_frames,1) %en data(X,1) X es a partir de donde arranca
    
tic     %inicio el timer    
fprintf('Preparando imagen %d de %d.\n',frm,data(total_frames,1))
pos = [data(frm,2) data(frm,3) data(frm,4) data(frm,5) data(frm,6)];
h =  pos(1); %dimension de cada pixel
x0 = pos(2);
xf = pos(3);
y0 = pos(4);
yf = pos(5);
 
x = x0:h:xf;
y = y0:h:yf;
 
tol = 1e-05;    %tolerancia de convergencia
pzero = 0;      %Z0 para Conjunto Mandelbrot
 
maxiter = 2000;  %iteraciones maximas para determinar converg. (250 - 1000)
 
sizex = size(x);
jmax = sizex(2);
sizey = size(y);
kmax = sizey(2);
 
w = jmax*kmax;
 
xplot = zeros([jmax,kmax]);
 
flag = 0;
chk = 0;
 
fprintf('Iterando...')

for j = 1:jmax
%     chk = chk + 1;
%     if chk == 100
%         fprintf('Iter %2.1f %%\n',(j/(jmax-1))*100)
%         chk = 0;
%     end
  for k = 1:kmax
      p0 = pzero;
      iter = 0;
      while flag == 0 && iter < maxiter
          p = p0^2 + x(j)+y(k)*1i;          
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
 
%plot
fprintf(' Listo.\nPloteando...')
% figure(1)
% imagesc(rot90(xplot));     %giro la matriz por cuestiones de almacenamiento
% hold on
% colorbar
% pbaspect([1 1 1])
 
figure(1)
imagesc(rot90(xplot));
corrida = sprintf('Caso Mandelbrot - Resolucion %d - Iteraciones Max = %d - Tolerancia = %d - GDL = %d  \n',h,maxiter,tol,w);
t1 = sprintf('Mandelbrot - Resolucion  %d - GDL = %d  \n',h,w);
t2 = sprintf('Mandelbrot #%d - h = %d - X [%f ; %f] - Y [%f ; %f]\n',frm,h,x0,xf,y0,yf);
title(t2);
colorbar;
colormap ('jet');
hold on
pbaspect([4 3 1]) %Fractal en 4:3
hold on
caxis([1,maxiter]) %limito el colorbar
id = data(frm,1);
 
fprintf(' Listo.\nExportando PNG...')
snam='fractales';
s=hgexport('readstyle',snam);
fig = strcat('img_',num2str(id));
s.Format = 'png'; 
hgexport(gcf,fig,s);
 
fprintf(' Listo.\nExportando workspace...')
wrkspc = strcat('Workspace_',num2str(id));
save(wrkspc);
tiempo = toc;    %finalizo el timer
ttotal = ttotal + tiempo;
fprintf(' Listo. %.3f seg  (%.3f seg)\n\n',tiempo,ttotal) 

 
end
 

