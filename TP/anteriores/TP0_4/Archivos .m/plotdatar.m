function plotdatar(NODOS,ELEMENTS,DATA,titulo)
%% ************************************************************************
%
%   PLOTDATAR v1.0
%     Plotea la malla 2D de elementos rectangulares coloreada con arcoiris.
%     La data puede ser por nodo o por elemento.
%     
%   ENTRADAS
%     NODOS = vector nx2 de las coordenadas de los nodos.
%     ELEMENTS = vector mx4 de los nodos de cada elemento.
%     DATA = vector nx1 (si es data por nodo) o mx1 (si es data por
%     elemento)
%     titulo = variable de caracteres ('titulo'), es el titulo de la
%     grafica.
%   FUNCIONAMIENTO
%     Crea matrices EX y EY. Son las componentes x e y de los nodos
%     de cada elemento (ejemplo EX(1,1:4) son las componentes x 
%     de los cuatro nodos del elemento 1.
%     Si length(DATA)=length(NODOS) crea un ED, matriz de datos nodales
%     cuya estructura es como la ELEMENTS.
%     Si length(DATA)=length(ELEMENTS) directamente ED=DATA
%     Funcion fill(EX,EY,ED) para crear la malla coloreada.
%     
% *************************************************************************

%% PLOTEOS
set(0,'DefaultFigureColor','w')

EX=[NODOS(ELEMENTS(:,1),1) NODOS(ELEMENTS(:,2),1) NODOS(ELEMENTS(:,3),1) NODOS(ELEMENTS(:,4),1)]';
EY=[NODOS(ELEMENTS(:,1),2) NODOS(ELEMENTS(:,2),2) NODOS(ELEMENTS(:,3),2) NODOS(ELEMENTS(:,4),2)]';

if length(DATA)==length(NODOS)
    ED=[DATA(ELEMENTS(:,1)) DATA(ELEMENTS(:,2)) DATA(ELEMENTS(:,3)) DATA(ELEMENTS(:,4))]';
    else if length(DATA)==length(ELEMENTS)
    ED=DATA';
    end
end

fill(EX,EY,ED);
title(titulo) ; hold on ; %axis equal ; %grid on
colorbar
colormap jet