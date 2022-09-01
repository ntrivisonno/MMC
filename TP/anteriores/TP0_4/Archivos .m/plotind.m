function plotind(NODOS,ELEMENTS,INDCARD,desp,s,n)
%% ************************************************************************
%
%   PLOTIND v1.0
%     Plotea los indices de cada nodo, nodo a nodo, para verificar que el
%     indice cardinal es correcto. Es una herramienta de verificacion
%     para mallas 2D de elementos rectangulares
%   ENTRADAS
%     NODOS = vector nx2 de las coordenadas de los nodos.
%     ELEMENTS = vector mx4 de los nodos de cada elemento.
%     INDCARD = vector nx8 de los indices cardinales de cada nodo.
%     desp = distancia del numero al nodo.
%     s = tamaño de los nodos [0 a 1000].
%     n = tamaño de los numeros.
%   FUNCIONAMIENTO
%     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
%   EJEMPLO
%     [NODOS,ELEMENTS] = rectmesh(25,10,15,5);
%     plotind(NODOS,ELEMENTS,indCARD,0.2,25,10);
%
% *************************************************************************
%% PLOTEO DEL INDICE CARDINAL

%saveas(gcf,'mesh.fig')
%open('test.fig')
for i=1:length(NODOS)
clf
    
for k=1:length(ELEMENTS)
X=NODOS(ELEMENTS(k,:),1);
Y=NODOS(ELEMENTS(k,:),2);
line([X;X(1)],[[Y;Y(1)]],'color','k');
hold on
end 
    
    h=plot(NODOS(i,1),NODOS(i,2),'r.');
    set(h,'Markersize',s);
    hold on

    P=[];
    N=[2 4 6 8];
    for j=1:4
        if INDCARD(i,N(j))~=0
            nx=NODOS(INDCARD(i,N(j)),1);
            ny=NODOS(INDCARD(i,N(j)),2);
            X=[NODOS(i,1);nx];
            Y=[NODOS(i,2);ny];
            P=[P;NODOS(INDCARD(i,N(j)),:)];
            %num=[int2str(N(j)) '=' int2str(INDCARD(i,N(j)))];
            num=int2str(INDCARD(i,N(j)));
            text(nx+desp,ny+desp,num,'fontsize',n)
            line(X,Y,'LineWidth',4)
            hold on
        end
    end
    h=plot(P(:,1),P(:,2),'r.');
    set(h,'Markersize',s*0.75);
    hold on
    
    P=[];
    N=[1 3 5 7];
    for j=1:4
        if INDCARD(i,N(j))~=0
            nx=NODOS(INDCARD(i,N(j)),1);
            ny=NODOS(INDCARD(i,N(j)),2);
            X=[NODOS(i,1);NODOS(INDCARD(i,N(j)),1)];
            Y=[NODOS(i,2);NODOS(INDCARD(i,N(j)),2)];
            P=[P;NODOS(INDCARD(i,N(j)),:)];
            num=int2str(INDCARD(i,N(j)));
            text(nx+desp,ny+desp,num,'fontsize',n)
            line(X,Y)
        end
        hold on
    end
    h=plot(P(:,1),P(:,2),'r.');
    set(h,'Markersize',s*0.5);
    hold on
    axis('equal');
    
    or=input('� Continuar ?');
    if or==0
        break
    end
    hold off
    
end
