%===========================================%
%               TP03 20171018               %
%===========================================%
clc;clear all;
%Datos

E=2e11;
f=-20*9.81;               %[N]
e1=2/1000;                     %espesor 1
e2=4/1000;                     %espesor 2
B=40/1000;                     %Base [m]
%%      
dx=5/1000;                %incremento delta x
L=(80+30+100+10+90)/1000; %longitud total, se pasa a [mm]
n=(L/dx)+1;               %cantidad de nodos

x=linspace(0,L,63);       %Discretización del medio
M=f*(L-x);                %Momento [N*m]

%calculamos los nodos donde varían las secciones
%H=zeros(n);
n1=(80/dx)/1000+1
n2=(30/dx)/1000+n1
n3=n2+(100/dx)/1000
n4=n3+(10/dx)/1000
n5=n4+90/(dx)/1000


%creamos la matriz de alturas 
H=zeros(63);                %creamos una matrix size(H)=63*63
H=H(1,1:63);                %la llevamos a vector

H(1:n1)=30;                 %Relleno de la matriz
%----------------------      Cálculo de la pendiente entre n1 y n2
m=(20-30)/((x(n2)-x(n1))*1000) %pendiente
H(n1:n2)=[m*(x(n1)*1000-80)+30 m*(85-80)+30 m*(90-80)+30 m*(95-80)+30 m*(100-80)+30 m*(105-80)+30 m*(110-80)+30 ];
%----------------
H(n2:n3)=20;
H(n3:n4)=20;
H(n4:n5)=25/2;

%Cálculo del momento de Inercia 
I=zeros(63);               %Creamos una matriz size(I)=63
I=I(1,:);                 %la reducimos a vector

I(1:n1)=((B*H(2).^3)/12)-((B*(H(2)-2*e1).^3)/12);     %Inercia sección 1
I(n1+1:n2-1)=B*H(n1+1:n2-1).^3/12-(B-2*e1)*(H(n1+1:n2-1)-2*e1).^3/12;   %inercia seccion 2
I(n2:n3)=B*((H(n3).^3)/12)-B*(((H(n3)-2*e1).^3)/12);  %Inercia seccion 3
I(n3:n4)=B*(H(n3+1).^3)/12;                                
I(n4:n5)= pi*(H(n4)^4-(H(n4)-2*e2)^4)/64;             %Inercia sección 5, circular

%Construimos la matriz Ax=b para MDF
K=zeros(n);
f=zeros(1,n);
K(1,1)=1;           %va a ser la cond de borde =0
K(n,n-1:n)=[-1 1];  %la cond Noiman en el último renglón

for i=2:n-1
    K(i,i-1)=1; %componente de la deriv. segunda por MDF
    K(i,i)=-2;  %componente de la deriv. segunda por MDF
    K(i,i+1)=1; %componente de la deriv. segunda por MDF
    f(i)=M(i)/E/I(i)*dx^2; %término independiente (sumado el dx^2 de la dif finita)
end

Q=trapz(M./I)*dx;  %calculo distorsión angular para la cond de contorno   
f(n)=Q/E*dx;        %evalúo el term. ind con esa cond.

y=linsolve(K,f')    %calculo solucion
y=y*1000;           %calculo deflexión
sigma=(M.*H/2)./I ;  %calculo tensión

%------------------- Figure 1 -----------------------
figure(1)
plot(x,H)
title('Desplazamiento en función de x')
ylim([0 35])
xlabel('Longitud [m]')
ylabel('Altura [mm]')

%------------------- Figure 2 -----------------------
figure(2)
plotdefl(1000*x,y',1000*H,500)   %Ploteo función. plotdefl(x,y,H,grado_def)

%------------------- Figure 3 -----------------------
figure(3)
plot((1:n),H)
title('Desplazamiento en función de los nodos')
ylim([0 35])
%xlim([15 25])
xlabel('Nodo]')
ylabel('Altura [mm]')

%---agregado ultimamente

%valores de deflexión obtenidos por solidWorks
y_SW=[
1.00000000e-030  
2.13386695e-004  
4.83282405e-004  
8.03419505e-004  
1.15103764e-003  
1.53436256e-003  
1.94512110e-003  
2.40495265e-003  
2.90667871e-003  
3.48557252e-003  
4.12792200e-003  
4.88563441e-003  
5.73526602e-003  
6.71109557e-003  
7.76015874e-003  
8.65617953e-003  
9.24902409e-003  
9.01313964e-003  
8.44000932e-003  
7.79307727e-003  
7.17669493e-003  
6.88217068e-003  
7.27002509e-003  
8.56435671e-003  
1.03009669e-002  
1.21919466e-002  
1.40141221e-002  
1.58727914e-002  
1.76371019e-002  
1.94306746e-002  
2.11986098e-002  
2.29718834e-002  
2.47589741e-002  
2.65744124e-002  
2.84243636e-002  
3.03120036e-002  
3.22451517e-002  
3.42212468e-002  
3.62498686e-002  
3.83192040e-002  
4.04097475e-002  
4.24636938e-002  
4.44035865e-002  
4.63276766e-002  
4.79780510e-002  
5.04893772e-002  
5.31101190e-002  
5.58236837e-002  
5.86331859e-002  
6.15385883e-002  
6.45471364e-002  
6.76447079e-002  
7.08300471e-002  
7.40884170e-002  
7.74184987e-002  
8.08067694e-002  
8.42507109e-002  
8.77370387e-002  
9.12628099e-002  
9.48166028e-002  
9.83996987e-002  
1.02025688e-001  
1.05717964e-001  ]';

ten_SW=[
5.788e+006  
8.891e+006  
8.709e+006  
8.709e+006  
8.769e+006  
8.869e+006  
8.708e+006  
8.652e+006  
8.496e+006  
8.282e+006  
8.171e+006  
7.787e+006  
7.594e+006  
7.161e+006  
6.632e+006  
7.212e+006  
1.130e+007  
5.863e+006  
5.084e+006  
5.476e+006  
5.872e+006  
9.770e+006  
1.442e+007  
1.067e+007  
6.524e+006  
6.358e+006  
7.390e+006  
6.644e+006  
7.395e+006  
7.515e+006  
7.734e+006  
7.631e+006  
7.720e+006  
7.528e+006  
7.478e+006  
7.275e+006  
7.240e+006  
7.174e+006  
7.319e+006  
7.343e+006  
7.428e+006  
7.401e+006  
7.488e+006  
3.811e+006  
7.188e+006  
1.614e+007  
1.282e+007  
1.246e+007  
1.159e+007  
1.112e+007  
1.002e+007  
9.400e+006  
8.333e+006  
7.701e+006  
6.668e+006  
6.006e+006  
4.996e+006  
4.295e+006  
3.323e+006  
2.664e+006  
2.079e+006  
1.732e+006  
2.490e+006  ]';

figure(4)
plot(x,abs(y),x,abs(y_SW)); %ploteo comparando deflexiones
grid on
leg1 = legend('y_MDF','y_SOLID');
figure(5)
plot(x,abs(sigma),x,abs(ten_SW)); %ploteo comparando tensiones
leg2 = legend('sigma_MDF','sigma_SOLID');
grid on

