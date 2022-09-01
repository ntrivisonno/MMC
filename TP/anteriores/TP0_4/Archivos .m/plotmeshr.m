function plotmeshr(NODOS,ELEMENTS,s)
%% ************************************************************************
%
%   PLOTMESHR v1.0
%     Plotea una malla 2D de elementos rectangulares. Util para FDM.
%   ENTRADAS
%     NODOS = vector nx2 de las coordenadas de los nodos.
%     ELEMENTS = vector mx4 de los nodos de cada elemento.
%     s = tamaño de los nodos [0 a 1000]
%   FUNCIONAMIENTO
%     Usa un for donde grafica un elemento a la ves. Extrae las coordenadas
%     de los nodos del elemento y luego grafica las lineas con un line,
%     terminando en el nodo de inicio para cerrar el rectangulo.
%   EJEMPLO
%     [NODOS,ELEMENTS] = rectmesh(25,10,15,5);
%     plotmeshr(NODOS,ELEMENTS,50)
%     
% *************************************************************************

%% PLOTEOS
set(0,'DefaultFigureColor','w')

for i=1:length(ELEMENTS)
    X=NODOS(ELEMENTS(i,:),1);
    Y=NODOS(ELEMENTS(i,:),2);
    line([X;X(1)],[[Y;Y(1)]],'Color','k','LineWidth',2)
    hold on
end

title('Malla') ; hold on ; %grid on
scatter(NODOS(:,1),NODOS(:,2),[s],'r','filled')
