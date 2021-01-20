%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demostración de las regiones de decisión en un caso con N=1
%
% Se visualizan las fdps condicionadas de cada símbolo para los casos de
% símbolos no equiprobables. 
% Se pueden modificar las probabilidades a priori de los símbolos
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Probabilidades de cada uno de los símbolos
p = [0.2 0.8];
mu = [-1 1];
x = -4:0.01:4;
sigma = ones(size(p));

%Genero la fdp normal
y = normpdf(repmat(x,length(p),1)', mu, sigma)*diag(p);

%Dibujo los resultados
plot(x,y);


