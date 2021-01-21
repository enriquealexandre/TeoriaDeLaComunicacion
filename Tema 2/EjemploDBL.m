%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo de modulación/demodulación DBL 
%
% Utilizo como mensaje (señal moduladora) un tono puro
% de frecuencia fx Hz. 
% En detección utilizo un detector síncrono
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defino algunos parámetros generales
fs = 2000;      %Frecuencia de muestreo (Hz)
Ts = 1/fs;      %Periodo de muestreo (el inverso de fs)
fc = 250;       %Frecuencia de la portadora (Hz)
fx = 25;        %Frecuencia de la moduladora (Hz)
                %¡Ojo! Debe ser mucho menor a fc
T = 0.2;        %Duración de las señales (s)
df = 0.3;       %Resolución mínima que quiero tener en frecuencia (Hz)
deltaF = 0;     %Error en la frecuencia del OL
deltaPHI = 0;   %Error en la fase del OL

%Genero la señal moduladora. 
t = 0:Ts:T;
x = cos(2*pi*25.*t);

%Por último, la señal DBL:
[xDBL, xc] = moduladorDBL(x, 1, fc, fs);

%Detecto la señal con un detector síncrono
xr = detectorSincrono(xDBL, 2, fc+deltaF, deltaPHI, 2*fx, fs);

%Pinto las cuatro señales en el tiempo, para ver su aspecto
figure
subplot(4,1,1)
plot(t,x)
xlabel('Tiempo (s)');
title('Señal moduladora (mensaje)')
subplot(4,1,2);
plot(t, xc);
xlabel('Tiempo (s)');
title('Portadora')
subplot(4,1,3);
plot(t, xDBL);
xlabel('Tiempo (s)');
title('Señal modulada (DBL)')
subplot(4,1,4);
plot(t, xr);
xlabel('Tiempo (s)');
title('Señal detectada')

%Ahora voy a calcular los espectros de las señales anteriores
N = 2^nextpow2(fs/df);          %Número de muestras de la FFT
f = -fs/2:fs/N:(fs/2)-fs/N;     %Genero el eje de frecuencias

%Calculo todas las FFTs
M = fft(x,N)/(fs*T/(2*pi));
XC = fft(xc,N)/(fs*T/(2*pi));
XDBL = fft(xDBL,N)/(fs*T/(2*pi));
XR = fft(xr,N)/(fs*T/(2*pi));

%Y las represento...
figure
subplot(4,1,1)
plot(f,abs(fftshift(M)))
xlabel('Frequencia (Hz)')
title('Espectro de la señal moduladora')
subplot(4,1,2)
plot(f,abs(fftshift(XC)))
title('Espectro de la portadora')
xlabel('Frequencia (Hz)') 
subplot(4,1,3)
plot(f,abs(fftshift(XDBL)))
title('Espectro de la señal modulada (DBL)')
xlabel('Frequencia (Hz)') 
subplot(4,1,4)
plot(f,abs(fftshift(XR)))
title('Espectro de la señal reconstruida')
xlabel('Frequencia (Hz)') 


