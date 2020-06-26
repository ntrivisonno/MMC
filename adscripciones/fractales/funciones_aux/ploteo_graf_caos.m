function [] = ploteo_graf_caos(hc,x0,xf,nc,tolc,maxitc)
  % funcion que plotea la grafica del caos, la misma se calcula a partir de los valores a los cuales converge la serie en cada punto
  % hc: resoluci'on de los ejes en la graf del caos
  % xc: intervalo para graficar 
  % nc: cantidad de iteraciones
  % tolc: tolerancia para la graf del caos
  % maxitc: maxima iteraciones a realizar
  % ---
  % yc: valor al cual converge la iteraci'on, ser'a lo que plotearemos
  xc = x0:hc:xf; 
  yc = zeros(nc,1);
  flag = 0;
  cont = 0;
  
  for c = 1:nc
    pc0 = 0;
    itc = 0;
    if cont == 64
      cont = 0;
    else
      cont = cont + 1;
    end
    while flag == 0 && itc < (maxitc-cont)
      pc = pc0^2 + xc(c);         
      deltac = pc - pc0;
      if abs(deltac) < tolc %conv por tol
	yc(c) = pc;
	flag = 1;
      end
      pc0 = pc;
      itc = itc+1;
    end
    if flag == 0
      yc(c) = pc;
    end
    flag = 0;
  end
  
  fprintf('\nPloteando valores de convergencia en eje real...\n')
  figure()
  plot(-xc,-yc,'k.','MarkerSize',0.75) %sacarla en 1200 DPI
  t1 = sprintf('Valores de Convergencia - Resolucion  %d - GDL = %d  \n',hc,nc);
  title(t1)
  %print(3,'Graf_caos.png','-dpng','-r1200')
  %print(fullfile('Figs',[t1,'.png']),'-dpng')% guarda imagen dentro de folder Figs
  pbaspect([1 1 1])
  
end
