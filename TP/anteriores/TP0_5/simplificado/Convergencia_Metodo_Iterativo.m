clc;clear all;close all;

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
rho = 1000; % kg/m^3]
L = 3; % [m]
mu = 1.002e-3; % [Pa.s]


%Matriz H para observar convergencia o divergencia
H = zeros(cant-2,cant-2);
H(1,1) = 1-2*mu*deltat/(rho*deltay^2);
H(1,2) = mu*deltat/(rho*deltay^2) ;
H(cant-2,cant-2) = 1-2*mu*deltat/(rho*deltay^2) ;
H(cant-2,cant-3) = mu*deltat/(rho*deltay^2);
for i = 2:cant-3
   H(i,i) = 1-2*mu*deltat/(rho*deltay^2);
   H(i,i+1) = mu*deltat/(rho*deltay^2);
   H(i,i-1) = mu*deltat/(rho*deltay^2);
end

%Radio espectral
radio_esp = max(abs(eig(H)));

%Convergencia del metodo iterativo
if radio_esp<1
    fprintf('El metodo iterativo convergera a la solucion del estacionario \n');
else
    fprintf('El metodo iterativo no convergera a la solucion del estacionario \n');
end


