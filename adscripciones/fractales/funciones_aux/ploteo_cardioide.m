function []=ploteo_cardioide(x,y,xplot,h,maxiter,tol,w,n,x0,xf,y0,yf)
% funcion que plotea el fractal de en forma de cardioide
% x: intervalo desde x0 a xf
% y: intervalo desde y0 a yf
% xplot: matriz que contiene max iteraciones de convergencia de la serie
% h: resoluci'on de los ejes
% maxiter: iteraciones m'aximas para determinar converg
% tol: tolerancia de convergencia
% w: cantidad totales de GDL . long"x"xlong"y"
% n: elige el frame a graficar del archivo pngdata.txt
% x0: inicio intervalo x
% xf: final intervalo y
% y0: inicio intervalo y
% yf: final intervalo y

  fprintf('\nPloteando fractal...\n')
  figure()
  imagesc(x,y,rot90(xplot));
  corrida = sprintf('Caso Mandelbrot - Resolucion %d - Iteraciones Max = %d - Tolerancia = %d - GDL = %d  \n',h,maxiter,tol,w);
  t1 = sprintf('Mandelbrot - Resolucion  %d - GDL = %d  \n',h,w);
  t2 = sprintf('Mandelbrot #%d - h = %f - X [%f ; %f] - Y [%f ; %f]\n',n,h,x0,xf,y0,yf);
  title(t2);
  colorbar;
  colormap ('jet');
  hold on
  pbaspect([1 1 1])

end
