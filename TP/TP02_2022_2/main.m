% TP Solid-deformation
% viga empotrada sujeta a esfuerzo de corte
clear all;close all;clc
warning('off','all'); % disable all warning
addpath('~/Documents/CIMEC/Cursos/FEM/pract/funciones_auxiliares/')
tStart = tic; %timer de multivariables

% Geometrical parameters
Lx = 100; 
Ly = 200;

% Physical parameters
E = 1e6; % Young's Modulus
G = 1e6;% Modulo elasticidad transversal, Shear modulus
nu = 1e-3; % Poisson Coef.
mu = E/(2*(1+nu)); % 1st lamme parameter
lambda = nu*E/((1+nu)*(1-2*nu)); %2 nd lamme parameter

f = [0;-9.81];
fx = f(1);
fy = f(2);

% Discretizacion
nx = 4;
ny = 5;
n = nx*ny;
nint = (ny-2)*(nx-2);

x = linspace(0,Lx,nx);
y = linspace(0,Ly,ny);
dx = x(2)-x(1);
dy = y(2)-y(1);

A = zeros(n*2);
b = zeros(n*2,1);

% Nodos empotrados
% desplazamientos nulos
inf = 1:nx;

% Nodos sup
sup = nx*(ny-1)+1:n;

% Nodos izquierdos
izq = nx+1:nx:n-nx;

% Nodos derechos
der = 2*nx:nx:nx*(ny-1);

% Nodos internos
pp = zeros(ny-2,nx-2);
for i=1:ny-2
  p = i*nx+2:(i+1)*nx-1;
  pp(i,:) = p;
end
int = reshape(pp',nint,1); % se debe hacer transpuesta para que funcione reshape

%-----------------------------------------------
% Boundery conditions
%
%  Complete
%
%-----------------------------------------------

% Nodos internos
for j = 1:length(int)
    i = int(j);
    % Componente ux
    % Aporte term (A)
    A(i,i+1) = (2*mu+lambda)/(dx^2);
    A(i,i) = -2*(2*mu+lambda)/(dx^2);    
    A(i,i-1) = (2*mu+lambda)/(dx^2);
    % Aporte term (B)
    A(i,i+nx) = mu/(dy^2);
    A(i,i) = -2*mu/(dy^2);
    A(i,i-nx) = mu/(dy^2);
    % Aporte term (C)
    A(i,i+nx+1+n) = 1/(4*dx*dy);
    A(i,i+nx-1+n) = -1/(4*dx*dy);
    A(i,i-nx+1+n) = -1/(4*dx*dy);
    A(i,i-nx-1+n) = 1/(4*dx*dy);
    % Componente uy
    % Aporte term (D)
    A(i,i+nx+n) = (2*mu+lambda)/(dy^2);
    A(i,i+n) = -2*(2*mu+lambda)/(dy^2);
    A(i,i-nx+n) = (2*mu+lambda)/(dy^2);
    % Aporte term (E)
    A(i,i+nx+1) = 1/(4*dx*dy);
    A(i,i+nx-1) = -1/(4*dx*dy);
    A(i,i-nx+1) = -1/(4*dx*dy);
    A(i,i-nx-1) = 1/(4*dx*dy);
    % Aporte term (F)
    A(i,i+nx+n) = mu/(dy^2);
    A(i,i+n) = -2*mu/(dy^2);
    A(i,i-nx+n) = mu/(dy^2);
end


%u = linsolve(A,b);
%ux = u[1:n];
%uy = u[n+1:length(u)];



time = toc(tStart);
fprintf('*-----------------------------------------------*\n')
fprintf('\n\nFIN! - OK - time = %d[s].\n',time)
