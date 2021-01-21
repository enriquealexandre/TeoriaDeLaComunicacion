%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo de modulación DBL 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%Antes de nada defino la frecuencia de muestreo (Hz);
fs = 1000;
Ts = 1/fs;  %Periodo de muestreo (el inverso de fs)

%Genero la señal moduladora. Es una sinc entre -T/2 y T/2.
T = 0.2;
t = [-T/2:Ts:T/2];
m = sinc(100*t);

%Ahora genero la portadora. Un coseno de frecuencia fc de la misma duración
%que la señal moduladora
fc = 250;   %Frecuencia de la portadora (Hz)
xc = cos(2*pi*fc.*t);

%Por último, la señal DBL:
xDBL = m.*xc;

%Pinto las tres señales en el tiempo, para ver su aspecto
subplot(3,1,1)
plot(t,m)
xlabel('Tiempo (s)');
title('Señal moduladora (mensaje)')
subplot(3,1,2);
plot(t, xc);
xlabel('Tiempo (s)');
title('Portadora')
subplot(3,1,3);
plot(t, xDBL);
xlabel('Tiempo (s)');
title('Señal modulada (DBL)')

%Ahora voy a calcular los espectros de las señales anteriores
df = 0.3;                       %Marco la resolución mínima que quiero en frecuencia
N = 2^nextpow2(fs/df);          %Número de muestras de la FFT
f = -fs/2:fs/N:(fs/2)-fs/N;     %Genero el eje de frecuencias

%Calculo todas las FFTs
M = fft(m,N)/fs;
XC = fft(xc,N)/fs;
XDBL = fft(xDBL,N)/fs;

%Y las represento...
figure
subplot(3,1,1)
plot(f,abs(fftshift(M)))
xlabel('Frequencia (Hz)')
title('Espectro de la señal moduladora')
subplot(3,1,2)
plot(f,abs(fftshift(XC)))
title('Espectro de la portadora')
xlabel('Frequencia (Hz)') 
subplot(3,1,3)
plot(f,abs(fftshift(XDBL)))
title('Espectro de la señal modulada (DBL)')
xlabel('Frequencia (Hz)') 


