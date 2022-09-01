%Simulador de colisiones elasticas - 23/03/19
%
%Descripcion: 
%
%Dos bloques se encuentran apoyados sobre una superficie sin rozamiento,
%Uno de masa 1 y otro de masa 100eK ; K = 0,1,2,3... el bloque de menor
%masa se encuentra en reposo, con una pared de masa infinita a su izquierda
%y el bloque de mayor masa a su derecha. Este ultimo tiene una velocidad 
%inicial distinta de 0 en direccion al bloque de menor masa. Todas las 
%colisiones son perfectamente elasticas (sin perdida de energia). Se busca 
%observar que el numero de colisiones tiende a ser n*pi ; n = 1e(K-1).

clear
clc
fprintf ('Simulador de colisiones elasticas - 23/03/19\n\n')

%Parametros
t = 0; %contador de ticks
n = 2; %n° de elemento del vector posicion
col = 0; %cant de colisiones
h = 1e-4; %duracion de un tick en segundos 
max = 4.5; %tiempo maximo en segundos

%Propiedades Bloque A (menor masa)
m1 = 1; %masa
v1 = 0; %velocidad inicial
x1 = zeros(1,(1/h)+1); %vector de posiciones en cada tick
x1(1) = 3; %posicion inicial
w1 = 1; %ancho (propositos graficos)

%Propiedades Bloque B (mayor masa)
m2 = 10;
v2 = -6;
x2 = zeros(1,(1/h)+1);
x2(1) = 7;
w2 = 3;

fprintf('Bloque A:\nM = %d kg\nV0 = %d m/s\nX0 = %d m\n\n',m1,v1,x1(1))
fprintf('Bloque B:\nM = %d kg\nV0 = %d m/s\nX0 = %d m\n\n',m2,v2,x2(1))

%Ecuaciones 
ecin = 0.5*m1*(v1^2) + 0.5*m2*(v2^2); %Energia cinetica
mlin = m1*v1 + m2*v2; %Momento lineal

%Coef. de resolucion
a = (0.5*(m2^2))/m1 + 0.5*m2;
b = -(mlin*m2)/m1;
c = (0.5*(mlin)^2)/m1 - ecin;

fprintf('Iterando...\n')

v1plot(1) = v1;
v2plot(1) = v2;

%Calculos de numero colisiones (experimental)
for t = 0:h:max-h       
    %Colision bloque1-pared
    if(x1(n-1) < w1/2)        
        v1 = -v1;          
        mlin = m1*v1 + m2*v2;
        col = col+1;
        x1(n-1) = w1/2;
    end
    %Colision bloque-bloque
    if (x1(n-1)+w1/2) > (x2(n-1)-w2/2)        
        a = (0.5*(m2^2))/m1 + 0.5*m2;
        b = -(mlin*m2)/m1;
        c = (0.5*(mlin)^2)/m1 - ecin;
        v2 = (-b+sqrt(b^2 - 4*a*c))/(2*a);        
        v1 = (mlin-m2*v2)/m1;        
        col = col+1;
        x1(n-1) = x2(n-1)-w2/2 - w1/2;
    end
    %Sin ninguna colision
    x1(n) = x1(n-1) + v1*h;
    x2(n) = x2(n-1) + v2*h;
    v1plot(n-1) = v1;
    v2plot(n-1) = v2;
    n = n+1;    
end

fprintf('Iteraciones completadas.\n\n')
fprintf('Cantidad de colisiones: %d\n',col)

%Calculo de numero de colisiones (no experimental)
slope = sqrt(m1/m2);
theta = atan(slope);
arcos = fix(pi/theta); %cuenta la cantidad de arcos y trunca los decimales
fprintf('Numero de colisiones esperadas: %d\n\n',arcos)

if col == arcos
    fprintf('Ambos métodos coinciden\n\n')
else
    fprintf(2,'Discrepancia encontrada\n\n')
end

graph = 1 ; %1 = se plotean las graficas
realtime = 1; %1 = se genera la animacion 

%Graficas
if graph == 1
    fprintf('Ploteado...\n\n')
    %Ploteo posiciones de cada bloque (X1 y X2) en funcion del tiempo 
    time = 0:h:max;
    figure(1)
    title({'Posicion de los bloques en funcion del tiempo';'AZUL: Bloque A - ROJO: Bloque B'})  
    xlabel('tiempo [s]')   
    ylabel('Posicion [m]')
    hold on
    axis([0 5 -5 20])
    hold on
    plot(time,x1-w1/2)
    hold on
    plot(time,x2-w1-w2/2,'r')
    hold on
    plot(time,0,'k')
    hold off
    
    %Ploteo de V2 en funcion de V1 
    tt = linspace(0,2*pi); %circulo de contencion - radio = raiz(m2)*v2
    endx = [0 sqrt(m2)*v2 sqrt(m2)*v2 ];
    endy = [0 v2 0];
    figure (2)
    title('Velovcidad bloque B vs Velocidad bloque A')  
    xlabel('Velocidad bloque B [m/s]')   
    ylabel('Velocidad bloque A [m/s]')
    axis([sqrt(m2)*v2*-1.5 sqrt(m2)*v2*1.5 sqrt(m2)*v2*-1.5 sqrt(m2)*v2*1.5])
    hold on
    axis equal
    hold on
    fill(endx,endy,'g') %triangulo verde: zona terminal (si cae un par (V2,V1) ahi, no hay mas colisiones)
    hold on
    plot(sqrt(m2)*v2*sin(tt),sqrt(m2)*v2*cos(tt),'k','Markersize',1) %circunferencia de contencion
    hold on
    plot(sqrt(m2)*v2plot,sqrt(m1)*v1plot)
    plot(sqrt(m2)*v2plot,sqrt(m1)*v1plot,'ro')    
 end

%Animacion de las colisiones
if realtime == 1
    fprintf('Ejecutando animacion...\n\n')
    skip = 1; %saltea de a X frames para no tardar demasiado, al costo de animacion inconclusa o perdida de colisiones visibles
         
    for k = 1:skip:1/h
        figure(3)
        axis([-1 50 0 5])
        axis image
        patch([(-w1/2) 0 0 (-w1/2)], [0 0 5 5],'k')
        patch([(x1(k)-w1/2) (x1(k)+w1/2) (x1(k)+w1/2) (x1(k)-w1/2)], [0 0 w1 w1],'r') 
        patch([(x2(k)-w2/2) (x2(k)+w2/2) (x2(k)+w2/2) (x2(k)-w2/2)], [0 0 w2 w2],'b') 
        pause(0.001) 
        clf        
    end
    %Frame final
    axis([-1 50 0 5])
    axis image
    patch([(-w1/2) 0 0 (-w1/2)], [0 0 5 5],'k')
    patch([(x1(k)-w1/2) (x1(k)+w1/2) (x1(k)+w1/2) (x1(k)-w1/2)], [0 0 w1 w1],'r') 
    patch([(x2(k)-w2/2) (x2(k)+w2/2) (x2(k)+w2/2) (x2(k)-w2/2)], [0 0 w2 w2],'b') 
end
fprintf('Listo.\n\n')

%mejoras:
%*prolongar animacion por unos frames por mas que no haya mas colisiones