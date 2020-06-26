function []=ploteo_nube3D(xmesh,ymesh,meshplot)
% ploteo nube 3D de fractal
% xmesh: vector de x0:h:xf
% ymesh: vector de y0:h:yf
% meshplot: grilla rectangular de xmesh*ymesh

  figure()
  fprintf('\nPloteando nube de puntos 3D...\n')
  scatter3(xmesh(:),ymesh(:),rot90(meshplot(:)),'.')
  set(gca,'XLim',[-2 0.5],'YLim',[-1.25 1.25],'ZLim',[-2 2])
  daspect([1 1 1])

end
