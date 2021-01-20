%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demostración de las regiones de decisión en un caso con N=2 y M=4
%
% Se visualizan las fdps condicionadas de cada símbolo para los casos de
% símbolos equiprobables y de símbolos no equiprobables. 
% Podéis modificar las coordenadas y el número de los símbolos, las
% probabilidades a priori de los símbolos, o la potencia del ruido
%
% El punto de vista de las gráficas está fijado a un azimut de 90º porque
% así se ven muy claras las fronteras de decisión, aunque se puede
% rotar la figura para ver las gaussianas en 3D.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


p = [0.1 0.3 0.3 0.3];          % Probabilidad de cada símbolo
mu = [1 1; -1 1; 1 -1; -1 -1];  % Valores de los símbolos

%Algunos cálculos previos
M = length(p);  
rejilla =-3:.1:3;     % Rejilla para representar los gráficos (la supongo simétrica)
sigma = eye(2);       % Matriz con la varianza del ruido (lo supongo a 1)

%Doy el formato adecuado a todas las matrices
coordenadas = repmat([repelem(rejilla,length(rejilla)); repmat(rejilla,1,length(rejilla))]',4,1);
mu = repelem(mu,length(rejilla)*length(rejilla),1);

%Genero una fdp normal para cada símbolo
normal = mvnpdf(coordenadas, mu,sigma);

%Hora de pintar
figure
hold on
for i=1:M
    surf(rejilla,rejilla,p(i)*reshape(normal(1+(numel(normal)/M)*(i-1):(numel(normal)/M)*i),length(rejilla),[]))
end
view(0,90)