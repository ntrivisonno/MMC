close all ; clc
% solucion viga doblemente empotrada, ver sol analit
% defino inicio y final
xi = 0;
xf = 10000;
h=5;
n =(xf-xi)/h+1 ;
I=(1/32)*pi*200^3;
E=200000;
q=1000;

%% CREAMOS MATRIZ A

%defino matriz
A = zeros (n,n);

%primer nodo
A(1,1)= 1; 
A(2,2)= 1;
if 0
  %segundo nodo
  A(2,2)= 3/h^4;%f
  A(2,3)= -14/h^4;%f+1
  A(2,4)= 26/h^4;%f+2
  A(2,5)= -24/h^4;%f+3
  A(2,6)= 11/h^4;%f+4
  A(2,7)= -2/h^4;%f+5
end
for i= 3:n-2
    A(i,i-2)= 1/h^4;%f-1
    A(i,i-1)= -4/h^4;%f-2
    A(i,i)= 6/h^4;%f
    A(i,i+1)= -4/h^4;%f+2
    A(i,i+2)= 1/h^4;%f+1
end

if 0
  %penultimo nodo
  A(n-1,n-1)= 3/h^4;%f
  A(n-1,n-2)= -14/h^4;%f-1
  A(n-1,n-3)= 26/h^4;%f-2
  A(n-1,n-4)= -24/h^4;%f-3
  A(n-1,n-5)= 11/h^4;%f-4
  A(n-1,n-6)= -2/h^4;%f-5
end
%ultimo nodo
A(n,n)= 1;
A(n-1,n-1) = 1;

%% VECTOR DE RESULTADOS
% defino matriz resultados
B = zeros (n,1);

B(n,1)= 0;

for i= 3:n-2
    B (i,1)= q/(E*I);% N/MPa*mm^3
end

B(n,1)= 0;

% solucion del sistema
sol = A\B;

%% PLOTEO
figure ('Name','Flecha de la viga fuerza puntual','NumberTitle','off')
x = linspace (xi,xf,n);
plot (x,sol)
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin')

%% SOLUCION ANALITICA
u= @(o) (q/(24*E*I)).*o.^4 + (-((q*(xf/2))/(6*E*I))).*o.^3 + ((q*(xf/2)^2)/(6*E*I)).*o.^2;
val = u(x);
figure ('Name','Solucion analitica','NumberTitle','off')
plot (x,val,'r')
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin')

%figure();plot(sol,'b',val,'r');legend('FDM','Exacta')
