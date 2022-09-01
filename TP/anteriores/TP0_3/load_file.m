% Scrip for loading data from a Text file

%Load File 

displacement = load('testing-Análisis estático 1-Resultados-Tensiones1-3.txt');
displacement1=displacement(:,2);   %Import de 2nd column


% %other example
% %Load File 
% force = load('Forces_SOLU_M5_Re300.dat'); 
% force=force(10000:rows(force),3);
% force=force/(0.5*1.225*0.5^2*pi*0.0147^2);
% 
% %# in matlab for comment script is %, and in octave #
