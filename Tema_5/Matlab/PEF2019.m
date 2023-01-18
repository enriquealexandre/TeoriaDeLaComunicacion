%Problema 2 PEF 2019

%Precisión temporal
deltaT = .1;

%Esta es la secuencia de símbolos que se da en el problema:
a = [-1 -1 3 -1 -1 -3 -1 -1 1]; 

%Esto es una secuencia aleatoria, mucho más larga (N símbolos), para poder
%representar un diagrama de ojo completo
%N = 1000;
%a = (sign(rand(1,N)-0.5)).*(1+2*round(rand(1,N)));

%Genero el pulso h(t) del apartado c
taux = 0:deltaT:1;
x1 = taux;
taux = 1+deltaT:deltaT:2;
x2 = 2-taux;
h = [x1 x2];


%Genero la señal recibida
t = 0:deltaT:(length(a)+1);
y = zeros(size(t));
for n=1:length(a)
    y(((1/deltaT)*(n-1))+1:((1/deltaT)*(n+1))+1) = y(((1/deltaT)*(n-1))+1:((1/deltaT)*(n+1))+1)+a(n).*h;
end

%La represento
figure
plot(t,y,'b','LineWidth',3)
grid

%Ahora represento el diagrama de ojo
figure
t2 = 0:deltaT:2;
for n=1:length(a)-2
    plot(t2,y(1+((1/deltaT)*n):1+((1/deltaT)*(n+2))),'b','LineWidth',3);
    hold on
end
grid

%Repito el proceso para el pulso que se da en el apartado e (modifico
%ligeramente el pulso para evitar discontinuidades, pero a efectos del
%cálculo de la ISI es igual)
taux = 0:deltaT:1;
x1 = taux;
taux = 1+deltaT:deltaT:3;
x2 = 1.5-taux/2;
h = [x1 x2];

%Genero la señal recibida
t = 0:deltaT:(length(a)+2);
y = zeros(size(t));
for n=1:length(a)
    y(((1/deltaT)*(n-1))+1:((1/deltaT)*(n+2))+1) = y(((1/deltaT)*(n-1))+1:((1/deltaT)*(n+2))+1)+a(n).*h;
end

%La represento
figure
plot(t,y,'b','LineWidth',3)
grid

%Y por último, el diagrama de ojo
figure
t2 = 0:deltaT:2;
for n=1:length(a)-2
    plot(t2,y(1+((1/deltaT)*n):1+((1/deltaT)*(n+2))),'b','LineWidth',3);
    hold on
end
grid






