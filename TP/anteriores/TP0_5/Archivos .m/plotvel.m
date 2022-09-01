function plotvel(H,L,Vx,p)
%% ************************************************************************
%
%   PLOTPERFIL v1.0
%     A partir de datos 1D de media altura crea un un perfil completo de
%     velocidad que evoluciona con el tiempo
%     
%   ENTRADAS
%     H = distancia completa entre placas planas.
%     L = longitud x completa.
%     Vx = matriz nyxnt de velocidades con su evolucion
%     p = numero real. Tiempo de pausa.
%   FUNCIONAMIENTO
%     Crea los NODOS y ELEMENTS virtuales.
%     Crea matrices EX y EY. Son las componentes x e y de los nodos
%     de cada elemento (ejemplo EX(1,1:4) son las componentes x 
%     de los cuatro nodos del elemento 1.
%     Si length(DATA)=length(NODOS) crea un ED, matriz de datos nodales
%     cuya estructura es como la ELEMENTS.
%     Si length(DATA)=length(ELEMENTS) directamente ED=DATA
%     Funcion fill(EX,EY,ED) para crear la malla coloreada.
%     
% *************************************************************************

%% CALCULOS

ny=length(Vx(:,1));
nt=length(Vx(1,:));
nyT=ny*2-1;
VxC=[Vx;Vx(ny-1:-1:1,:)];
x=zeros(nyT,1); yT=linspace(0,H,nyT)';

NODOS=[zeros(nyT,1) yT;L*ones(nyT,1) yT];
ELEMENTS=zeros(nyT-1,4);
for i=1:length(ELEMENTS)
    ELEMENTS(i,:)=[i nyT+i nyT+i+1 i+1];    
end

VxC_2D=[VxC; VxC];
DATA=VxC_2D(:,nt);
EX=[NODOS(ELEMENTS(:,1),1) NODOS(ELEMENTS(:,2),1) NODOS(ELEMENTS(:,3),1) NODOS(ELEMENTS(:,4),1)]';
EY=[NODOS(ELEMENTS(:,1),2) NODOS(ELEMENTS(:,2),2) NODOS(ELEMENTS(:,3),2) NODOS(ELEMENTS(:,4),2)]';
ED=[DATA(ELEMENTS(:,1)) DATA(ELEMENTS(:,2)) DATA(ELEMENTS(:,3)) DATA(ELEMENTS(:,4))]';

%% PLOTEOS

disp('|| Inicio Animacion')

set(0,'DefaultFigureColor','w')
fill(EX,EY,ED);
colormap jet; caxis manual; caxis([min(Vx(:)) max(Vx(:))]);  
title('Velocidad X [m/s]'); xlabel('Longitud [m]'); ylabel('Altura [m]')
%axis tight manual
ax = gca; ax.NextPlot = 'replaceChildren';

F(nt) = struct('cdata',[],'colormap',[]);
for j = 1:nt
    DATA=VxC_2D(:,j);
    ED=[DATA(ELEMENTS(:,1)) DATA(ELEMENTS(:,2)) DATA(ELEMENTS(:,3)) DATA(ELEMENTS(:,4))]';
    fill(EX,EY,ED);
    colorbar
    drawnow
    F(j) = getframe;
    pause(p)
end

disp('|| Fin Animacion')
