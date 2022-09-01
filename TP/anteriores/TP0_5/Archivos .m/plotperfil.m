function plotperfil(H,Vx,p)
%% ************************************************************************
%
%   PLOTPERFIL v1.0
%     A partir de datos 1D de media altura crea un un perfil completo de
%     velocidad que evoluciona con el tiempo
%     
%   ENTRADAS
%     H = distancia completa entre placas planas.
%     Vx = matriz nyxnt de velocidades con su evolucion
%     p = numero real. Tiempo de pausa.
%   FUNCIONAMIENTO
%     De la matriz Vx entrae las longitudes ny y nt
%     Crea longirud nyT que es el total ny*2-1 de todo el perfil
%     Rearma Vx como VxC repitiendo todos los valores de arriba hacia abajo
%     Arma vectores para poder usar la funcion line
%     Plotea dentro de un for nt para crear la animacion
%     
% *************************************************************************

%% PLOTEOS
set(0,'DefaultFigureColor','w')
title('Evolucion del perfil de Velocidad X [m/s]'); xlabel('Velocidad [m/s]'); ylabel('Posición H [m]')
%axis manual

ny=length(Vx(:,1));
nt=length(Vx(1,:));

nyT=ny*2-1;
VxC=[Vx;Vx(ny-1:-1:1,:)];
x=zeros(nyT,1); yT=linspace(0,H,nyT)';
maxV=max(Vx(:)); minV=min(Vx(:)); maxyT=max(yT);
Y=[yT yT];

disp('|| Inicio Animacion')
for j = 1:nt
	drawnow
    pause(p);
    X=[zeros(nyT,1) VxC(:,j)];  
    line(VxC(:,j),yT,'Color','r','LineWidth',1.5);
    line(X',Y','Color','b');
    axis([minV maxV 0 maxyT])
end

disp('|| Fin Animacion')
