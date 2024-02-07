clc;clear all;close all;
tStart = tic; % timer de multivariables

%Cantidad de nodos
cant = 11;

%Cantidad de Iteraciones (contando la inicial)
f = 120;

%Inicio y final del Perfil 
yi = 0; % [m]
yf = 0.05;% [m]

%Espacio entre nodo y nodo
deltay = (yf-yi)/(cant-1); % [m]

%Tiempo entre cada iteracion
deltat = 10; % [s]

%Constantes del problema
deltap = 115.43; % [Pa]
rho = 1000; % [kg/m^3]
L = 3; % [m]
mu = 1.002e-3; % [Pa.s]


%Armado de la matriz A de iteracion y el vector B

A = zeros(cant,cant);
A(1,1) = 1;
A(cant,cant) = 1;
B = zeros(cant,1);
B(1) = 0;
B(cant) = 0;

for i = 2:(cant-1)
   A(i,i) = 1-2*mu*deltat/(rho*deltay^2);
   A(i,i+1) = mu*deltat/(rho*deltay^2);
   A(i,i-1) = mu*deltat/(rho*deltay^2);
   B(i) = deltat*deltap/(rho*L);
end



%Armado de matriz V donde se guarda el resultado de cada iteracion
Vt = zeros(cant,1);
V = zeros(cant,f);

for i=2:f
    Vt = A*Vt + B;
    V(:,i)=Vt;
end

%Subgrafica de los Perfiles de velocidades

subplot(1,2,1);

y=linspace(yi,yf,cant);
plot(V(:,103),y,'o-','LineWidth',1.5);
hold on; 
plot(V(:,55),y,'o-','LineWidth',1.5);
hold on; 
plot(V(:,37),y,'o-','LineWidth',1.5);
hold on; 
plot(V(:,19),y,'o-','LineWidth',1.5);
hold on; 
plot(V(:,7),y,'o-','LineWidth',1.5);
hold on; 
plot(V(:,1),y,'o-','LineWidth',1.5);
hold on; 

yy = 0:0.001:0.05;
f_an =  -19200.*yy.^2 + 960.*yy;
hold on;
plot(f_an,yy,'k','LineWidth',1.5);
title('Perfil de Velocidades en Regimen Transitorio');
ylabel('y [m]');
xlabel('Velocidad [m/s]');
xlim([-0.5 12.5]);
ylim([0 0.05]);
legend('t= 1020 s', 't= 540 s','t= 360 s','t= 180 s','t= 60 s','t= 0 s','Estacionario');

%Las Leyendas y graficas son para un f=120 y deltat=10


%Subgrafica de Velocidad maxima vs Tiempo

subplot(1,2,2);

tt=0:10:10*(f-1);
plot(tt,V(ceil(cant/2),:)', 'r','LineWidth',1.5);
ylim([-0.5 12.5]);
xlim([0 1250]);
xlabel('Tiempo [s]');
ylabel('Velocidad maxima [m/s]');
title('Grafica Velocidad Maxima vs. Tiempo' );


%Velocidad Maxima obtenida
vmax = max(Vt) ;


ee = linspace(yi,yf,cant);
ee_an = -19200.*ee.^2 + 960.*ee;

%Error en norma 1 del ultimo vector iterado y el estacionario
error = norm(Vt-ee_an',1);

time = toc(tStart);


fprintf('Se obtuvo una velocidad maxima de %2.2f metros sobre segundo.\n',vmax);
fprintf('El error normado del ultimo vector iterado respecto al estacionario es de %2.2f metros sobre segundo. \n',error);
fprintf('*-----------------------------------------------*\n')
fprintf('\nFIN! - OK - time = %d[s].\n',time)

