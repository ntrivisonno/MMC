%Simulador colisiones en 2D - 27/03/2020
%
%Descripcion: 
%
%Se simulan las colisiones de una particula contra los bordes de un
%contenedor de seccion circular de radio 'r'. Es un caso simplificado en 
%2D en el cual todas las colisiones son perfectamente elasticas y no 
%hay perdida de energia. El modulo de V siempre es cte.

clear all;close all;clc

r = 50;         %Radio de contenedor, origen en [0;0] [m]
   
hh = 0.25;   %paso de t [s]
col = 0;    %contador de colisiones
max = 40;   %tiempo maximo  [s]

%P --> X[m]   Y[m]    V0[m/s]    alfa[rad]     r[m]    m[kg]
p = load('particulas_mp.txt'); %cargo los datos en una matriz p
jj = size(p);
j = jj(1);                  %cantidad de puntos (n� de elementos de p)

%Struct para guardar datos de los puntos
for i = 1:j
    pn = strcat('p_',num2str(i)); 
    puntos.(pn) = p(i,:);
end

%Struct para guardar coordenadas X e Y para ploteo
for i = 1:j
    pplot = strcat('pplot_',num2str(i)); 
    plots.(pplot) = zeros(max/hh,2);
end

pn_c = struct2cell(puntos);     %pn_c{1}(1) = 1 para acceder o imponer valor   
pplot_c = struct2cell(plots);   %pplot_c{1}(1,1) = 1 para acceder o imponer valor

%cargo los primeros valores para ploteo 
for n = 1:j
    pplot_c{n}(1,1) = pn_c{n}(1);
    pplot_c{n}(1,2) = pn_c{n}(2);
end

k = 2;  %posicion de almacenamiento para plot

for t = 0:hh:max    %tiempo
          %posicion de almacenamiento    
    for n = 1:j     % n = numero de particula
        
        %cargo los valores del punto
        p1 = pn_c{n};
                
        %cargo el valor del plot
        %p1_plot = pplot_c{n};
        
        %actualizo posiciones
        p1(1) = p1(1) + p1(3)*cos(p1(4))*hh; % X = X0 + V0*cos(alfa)*dt
        p1(2) = p1(2) + p1(3)*sin(p1(4))*hh; % Y = Y0 + V0*sin(alfa)*dt 
    
        %chequeo colision con bordes
        if sqrt((p1(1))^2+(p1(2))^2) > r
            col = col + 1;   
        
            %Correccion de X e Y al superar el limite de contencion
            p0x = pplot_c{n}(k-1,1);           %x del que esta dentro
            p0y = pplot_c{n}(k-1,2);           %y del que esta dentro
        
            m = (p1(2)-p0y)/(p1(1)-p0x);    %pendiente del segmento que atraviesa el limite
            h = p1(2) - m*p1(1);            %h del segmento que atraviesa el limite
        
            %coef. del polinomio a resolver
            a = 1 + m^2;
            b = 2*m*h;
            c = h^2 - r^2;
        
            px1 = (-b+sqrt(b^2 - 4*a*c))/(2*a); 
            px2 = (-b-sqrt(b^2 - 4*a*c))/(2*a); 
        
            if abs(pplot_c{n}(k-1,1) - px1) < abs(pplot_c{n}(k-1,1) - px2)    %determina que valor de la resolvente elegir
                px = px1;
            else
                px = px2;
            end
             
            py = m*px + h;  %obtengo Py con Px y la ecuacion del segmento
        
            p1(1) = px; %coordenada en x corregida
            p1(2) = py; %coordenada en y corregida        
        
            tita = atan(p1(2)/p1(1));   %angulo del VECTOR POSICION de P1
            gama = tita + (pi/2);       %angulo de la tangente de la circunf
            beta = gama - p1(4);        %angulo entre el vector velocidad y la tangente
            alfa2 = 2*beta + p1(4);     %nuevo angulo de velocidad
            if alfa2 > 2*pi             %si se excede de una vuelta 
                alfa2 = alfa2 - 2*pi;
            end
            p1(4) = alfa2;          
        end
        
        %Actualizo los valores del struct
        pn_c{n}(1) = p1(1);
        pn_c{n}(2) = p1(2);      
        pn_c{n}(4) = p1(4);
        pplot_c{n}(k,1) = p1(1);
        pplot_c{n}(k,2) = p1(2);        
    end
    k = k+1;
end

fprintf('Colisiones totales: %d\n\n',col)

%Ploteo de recorrido
fprintf('Ploteando recorrido...\n\n')
figure(1)
phi = linspace(0,2*pi); %limites contenedor
axis([-1.2*r 1.2*r -1.2*r 1.2*r])
hold on
axis equal
hold on
plot(r*sin(phi),r*cos(phi),'k','Markersize',1)
hold on
%P1
plot(pplot_c{1}(1,1),pplot_c{1}(1,2),'co')	%Posicion inicial
hold on
plot(pplot_c{1}(:,1),pplot_c{1}(:,2),'')    %Plotea lineas
hold on
plot(pplot_c{1}((max/hh)+2,1),pplot_c{1}((max/hh)+2,2),'ro') %Posicion final
%P2
plot(pplot_c{2}(1,1),pplot_c{2}(1,2),'co')	%Posicion inicial
hold on
plot(pplot_c{2}(:,1),pplot_c{2}(:,2),'g')    %Plotea lineas
hold on
plot(pplot_c{2}((max/hh)+2,1),pplot_c{2}((max/hh)+2,2),'ro') %Posicion final
%P3
plot(pplot_c{3}(1,1),pplot_c{3}(1,2),'co')	%Posicion inicial
hold on
plot(pplot_c{3}(:,1),pplot_c{3}(:,2),'m')    %Plotea lineas
hold on
plot(pplot_c{3}((max/hh)+2,1),pplot_c{3}((max/hh)+2,2),'ro') %Posicion final
%P4
plot(pplot_c{4}(1,1),pplot_c{4}(1,2),'co')	%Posicion inicial
hold on
plot(pplot_c{4}(:,1),pplot_c{4}(:,2),'k')    %Plotea lineas
hold on
plot(pplot_c{4}((max/hh)+2,1),pplot_c{4}((max/hh)+2,2),'ro') %Posicion final
hold on

%Animacion
anim = 1;   % 1 = se genera la animacion. Sino se omite
skip = 1;   %saltea 1 de cada X frames
if anim == 1
    fprintf('Generando animacion...\n\n')
    
    for i = 1:skip:((1/hh)*t)
        for n = 1:j
            figure(2) 
            title({'Tiempo [s]: ',i*hh})  
            hold on
            axis([-1.2*r 1.2*r -1.2*r 1.2*r])
            hold on
            axis equal
            hold on
            plot(r*sin(phi),r*cos(phi),'k','Markersize',1)
            hold on
            
            plot(pplot_c{1}(i,1),pplot_c{1}(i,2),'*')
            plot(pplot_c{2}(i,1),pplot_c{2}(i,2),'g*')
            plot(pplot_c{3}(i,1),pplot_c{3}(i,2),'m*')
            plot(pplot_c{4}(i,1),pplot_c{4}(i,2),'k*')
            pause(0.001)            
            clf
        end
    end
    figure(2) 
    title({'Tiempo [s]: ',i*hh})  
    hold on
    axis([-1.2*r 1.2*r -1.2*r 1.2*r])
    hold on
    axis equal
    hold on
    plot(r*sin(phi),r*cos(phi),'k','Markersize',1)
    hold on
    %Ultimas posiciones (para que queden al final)
    plot(pplot_c{1}(i,1),pplot_c{1}(i,2),'*')
    plot(pplot_c{2}(i,1),pplot_c{2}(i,2),'g*')
    plot(pplot_c{3}(i,1),pplot_c{3}(i,2),'m*')
    plot(pplot_c{4}(i,1),pplot_c{4}(i,2),'k*')
end

fprintf('Listo.\n\n')