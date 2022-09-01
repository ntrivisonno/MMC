function [indCARD]=indcard(NODOS,ELEMENTS)
%% ************************************************************************
%
%   INDCARD v1.1
%     A partir de una malla RECTANGULAR con indice elemental igual para
%     todos los elementos crea el indice cardinal y distingue nodos 
%     internos de los externos
%   ENTRADAS
%     NODOS = vector nx2 de las coordenadas de los nodos.
%     ELEMENTS = vector mx4 de los nodos de cada elemento.
%   FUNCIONAMIENTO
%     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
%     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
%     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
%     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
% *************************************************************************
%% CONSTRUCCION DEL INDICE CARDINAL

nNODOS=length(NODOS(:,1)); %cant. nodos
nELEMENTS=length(ELEMENTS(:,1)); %cant. de elementos
indCARD=zeros(nNODOS,8); %son ocho nodos que rodean al central.

% RELACION INDICE ELEMENTO-CARDINAL
for i=1:nELEMENTS
    n=ELEMENTS(i,:); %tomo los nodos del elemento
    indCARD(n(1),[4 5 6])=[n(2) n(3) n(4)]; %relaciono ind. elementales con
    indCARD(n(2),[8 6 7])=[n(1) n(3) n(4)]; %cardinales, ver notas
    indCARD(n(3),[1 2 8])=[n(1) n(2) n(4)];
    indCARD(n(4),[2 3 4])=[n(1) n(2) n(3)];
end

% RELACION INDICE NODO-CARDINAL (O CARDINAL-CARDINAL)
for i=1:nNODOS
    n=indCARD(i,:); %tomo los nodos del indice elemental
    
    if n(1)~=0
        %indCARD(n(1),[4 5 6])=[n(2) i n(8)];
        indCARD(n(1),5)=i;
        if n(2)~=0 ; indCARD(n(1),4)=n(2); end
        if n(8)~=0 ; indCARD(n(1),6)=n(8); end
    end
    
    if n(2)~=0
        %indCARD(n(2),[4 5 6 7 8])=[n(3) n(4) i n(8) n(1)];
        indCARD(n(2),6)=i;
        if n(3)~=0 ; indCARD(n(2),4)=n(3); end
        if n(4)~=0 ; indCARD(n(2),5)=n(4); end
        if n(8)~=0 ; indCARD(n(2),7)=n(8); end %CAMBIE 7 POR 6
        if n(1)~=0 ; indCARD(n(2),8)=n(1); end
    end
    
    if n(3)~=0
        %indCARD(n(3),[6 7 8])=[n(4) i n(2)];
        indCARD(n(3),7)=i;
        if n(4)~=0 ; indCARD(n(3),6)=n(4); end
        if n(2)~=0 ; indCARD(n(3),8)=n(2); end
    end    

    if n(4)~=0
        %indCARD(n(4),[1 2 6 7 8])=[n(2) n(3) n(5) n(6) i];
        indCARD(n(4),8)=i;
        if n(2)~=0 ; indCARD(n(4),1)=n(2); end
        if n(3)~=0 ; indCARD(n(4),2)=n(3); end
        if n(5)~=0 ; indCARD(n(4),6)=n(5); end
        if n(6)~=0 ; indCARD(n(4),7)=n(6); end
    end        
        
    if n(5)~=0
        %indCARD(n(5),[1 2 8])=[i n(4) n(6)];
        indCARD(n(5),1)=i;
        if n(4)~=0 ; indCARD(n(5),2)=n(4); end
        if n(6)~=0 ; indCARD(n(5),8)=n(6); end
    end         

    if n(6)~=0
        %indCARD(n(6),[1 2 3 4 8])=[n(8) i n(4) n(5) n(7)];
        indCARD(n(6),2)=i;
        if n(8)~=0 ; indCARD(n(6),1)=n(8); end
        if n(4)~=0 ; indCARD(n(6),3)=n(4); end
        if n(5)~=0 ; indCARD(n(6),4)=n(5); end
        if n(7)~=0 ; indCARD(n(6),8)=n(7); end
    end    
        
    if n(7)~=0
        %indCARD(n(7),[2 3 4])=[n(8) i n(6)];
        indCARD(n(7),3)=i;
        if n(8)~=0 ; indCARD(n(7),2)=n(8); end
        if n(6)~=0 ; indCARD(n(7),4)=n(6); end
    end        
        
    if n(8)~=0
        %indCARD(n(8),[2 3 4 5 6])=[n(1) n(2) i n(6) n(7)];
        indCARD(n(8),4)=i;
        if n(1)~=0 ; indCARD(n(8),2)=n(1); end
        if n(2)~=0 ; indCARD(n(8),3)=n(2); end
        if n(6)~=0 ; indCARD(n(8),5)=n(6); end
        if n(7)~=0 ; indCARD(n(8),6)=n(7); end
    end        
        
end

