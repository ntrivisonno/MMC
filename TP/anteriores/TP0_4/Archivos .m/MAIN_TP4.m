%cargar nodos y elem manualmente
NODOS=[
    0   0
    10  0
    20  0
    60  0
    70  0
    80  0
    90  0
    100 0
    0   10
    10  10
    20  10
    60  10
    70  10
    80  10
    90  10
    100 10
    0   20
    10  20
    20  20
    30  20
    40  20
    50  20
    60  20
    70  20
    80  20
    90  20
    100 20
    0   30
    10  30
    20  30
    30  30
    40  30
    50  30
    60  30
    70  30
    80  30
    90  30
    100 30
    0   40
    10  40
    20  40
    30  40
    40  40
    50  40
    60  40
    70  40
    80  40
    90  40
    100 40 
    0   50
    10  50
    20  50
    30  50
    40  50
    50  50
    60  50
    70  50
    80  50
    90  50
    100 50
    ];

ELEMENTS=[
    1 2 10 9
    2 3 11 10
    4 5 13 12
    5 6 14 13
    6 7 15 14
    7 8 16 15
    9 10 18 17
    10 11 19 18
    12 13 24 23
    13 14 25 24
    14 15 26 25
    15 16 27 26
    17 18 29 28
    18 19 30 29
    19 20 31 30
    20 21 32 31
    21 22 33 32
    22 23 34 33
    23 24 35 34
    24 25 36 35
    25 26 37 36
    26 27 38 37
    28 29 40 39
    29 30 41 40
    30 31 42 41
    31 32 43 42
    32 33 44 43
    33 34 45 44
    34 35 46 45
    35 36 47 46
    36 37 48 47
    37 38 49 48
    39 40 51 50
    40 41 52 51
    41 42 53 52
    42 43 54 53
    43 44 55 54
    44 45 56 55
    45 46 57 56
    46 47 58 57
    47 48 59 58
    48 49 60 59
    ];
%path('/home/zeeburg/Documents/CIMEC/Cursos/MMC/TP04/Archivos .m')
figure(1)
plotnumr(NODOS,ELEMENTS,0.5,20,10)

[INDCARD]=indcard(NODOS,ELEMENTS);
%plotind(NODOS,ELEMENTS,indCARD,0.5,20,10) %patalea la funcion, debuggearla

NODOS=NODOS/1000; % pasamos a metros las locations de los nodos !!!!!
q1=100/(500/1000*100/1000); %W/m2 calculamos energ'ia espec'ifica
h=30; % [W/m2K]
k=1.4; % [W/mK]
d=10/1000; %[m]
Text=35+273.15; %[K]

nINT=[ 10 13:15 18 24:26 29:37 40:48]; %vector con nodo interiores

nEXT0sup=[ 51:59 ];
nEXT0inf=[ 2 3 19:23 4:7];
nEXT0der=[ 11 ];
nEXT0izq=[ 12 ];

nQflujo=[1 9 17 28 39 50]; 
nQconv=[8 16 27 38 49 60];

nNODOS=length(NODOS);
K=zeros(nNODOS);
Q=zeros(nNODOS,1);

for j=1:length(nINT)  %nodos internos
    i=nINT(j);
    K(i,i)=-4;
    K(i,INDCARD(i,8))=1;
    K(i,INDCARD(i,4))=1;
    K(i,INDCARD(i,2))=1;
    K(i,INDCARD(i,6))=1;
end

for j=1:length(nEXT0sup)
    i=nEXT0sup(j);
    K(i,i)=1;
    K(i,INDCARD(i,2))=-1;
end

for j=1:length(nEXT0inf)
    i=nEXT0inf(j);
    K(i,i)=-1;
    K(i,INDCARD(i,6))=1;
end

for j=1:length(nEXT0der)
    i=nEXT0der(j);
    K(i,i)=1;
    K(i,INDCARD(i,8))=-1;
end

for j=1:length(nEXT0izq)
    i=nEXT0izq(j);
    K(i,i)=-1;
    K(i,INDCARD(i,4))=1;
end

for j=1:length(nQflujo)
    i=nQflujo(j);
    K(i,i)=-1;
    K(i,INDCARD(i,4))=1;
    Q(i)=q1*d/-k;
end

for j=1:length(nQconv)
    i=nQconv(j);
    K(i,i)=(1+h*d/k);
    K(i,INDCARD(i,8))=-1;
    Q(i)=Text*h*d/k;
end

T=linsolve(K,Q);
T=T-273.15;  %paso la temp a cent'igrados

figure(2)
plotdatar(1000*NODOS,ELEMENTS,T,'Temperatura')
