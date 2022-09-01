function plotnumr(NODOS,ELEMENTS,desp,s,n)
%% ************************************************************************
%
%   PLOTNUMR v1.0
%     Plotea la malla 2D con la numeracion nodal y elemental. Los elementos
%     deben ser rectangulares.
%   ENTRADAS
%     NODOS = vector nx2 de las coordenadas de los nodos.
%     ELEMENTS = vector mx4 de los nodos de cada elemento.
%     desp = distancia del numero al nodo
%     s = tamaño de los nodos [0 a 1000].
%     n = tamaño de los numeros.
%   FUNCIONAMIENTO
%     Los baricentros se calculan como el promedio de las coordenadas
%     nodales de los cuatro nodos.
%     Crea el plot de la misma manera que plotmeshr, con un for y line.
%     Usa text para colocar los numeros en posiciones cercanas a los nodos
%     y a los baricentros de los elementos.
%     
% *************************************************************************

%% BARICENTROS
N1=ELEMENTS(:,1); %columna nodos 1
N2=ELEMENTS(:,2); %columna nodos 2
N3=ELEMENTS(:,3); %columna nodos 3
N4=ELEMENTS(:,4); %columna nodos 4

bar=[NODOS(N1,1)+NODOS(N2,1)+NODOS(N3,1)+NODOS(N4,1) NODOS(N1,2)+NODOS(N2,2)+NODOS(N3,2)+NODOS(N4,2)]/4;

%% PLOTEOS
set(0,'DefaultFigureColor','w')

for i=1:length(ELEMENTS)
X=NODOS(ELEMENTS(i,:),1);
Y=NODOS(ELEMENTS(i,:),2);
line([X;X(1)],[Y;Y(1)],'Color','k')
hold on
end

title('Numeracion de los Nodos y Elementos') ; hold on ; %grid on
scatter(NODOS(:,1),NODOS(:,2),[s],'r','filled')

text(NODOS(:,1)+desp,NODOS(:,2)+desp,int2str((1:length(NODOS))'),'fontsize',n)
text(bar(:,1),bar(:,2),int2str((1:length(ELEMENTS))'),'fontsize',n*1.2,'color','r')
