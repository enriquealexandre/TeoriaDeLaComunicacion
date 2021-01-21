%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo de modulación AM 
%
% Utilizo como mensaje (señal moduladora) un tono puro
% de frecuencia fx Hz. 
% En detección utilizo un detector síncrono y un 
% detector de envolvente
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Defino algunos parámetros generales
fs = 2000;  %Frecuencia de muestreo (Hz)
Ts = 1/fs;  %Periodo de muestreo (el inverso de fs)
mu = 0.8;   %Índice de modulación
fc = 250;   %Frecuencia de la portadora (Hz)
fx = 25;    %Frecuencia de la moduladora (Hz)
            %¡Ojo! Debe ser mucho menor a fc
T = 0.2;    %Duración de las señales (s)
df = 0.3;   %Resolución mínima que quiero tener en frecuencia (Hz)

%Genero la señal moduladora. 
t = 0:Ts:T;
x = cos(2*pi*25.*t);

%Modulo en AM
[xAM, xc] = moduladorAM(x, 1, fc, mu, fs);

%Como es AM, tengo dos opciones de detector: envolvente o síncrono
%Primero pruebo con un síncrono:
xr_sinc = detectorSincrono(xAM, 2/mu, fc, 0, 2*fx, fs);

%Ahora un detector de envolvente:
xr_env = detectorEnvolvente(xAM);

%Pinto las cuatro señales en el tiempo, para ver su aspecto
figure
subplot(5,1,1)
plot(t,x)
xlabel('Tiempo (s)');
title('Señal moduladora (mensaje)')
subplot(5,1,2);
plot(t, xc);
xlabel('Tiempo (s)');
title('Portadora')
subplot(5,1,3);
plot(t, xAM);
xlabel('Tiempo (s)');
title('Señal modulada (AM)')
subplot(5,1,4);
plot(t, xr_sinc);
xlabel('Tiempo (s)');
title('Señal detectada (detector síncrono)')
subplot(5,1,5);
plot(t, xr_env);
xlabel('Tiempo (s)');
title('Señal detectada (detector de envolvente)')

%Ahora voy a calcular los espectros de las señales anteriores
N = 2^nextpow2(fs/df);          %Número de muestras de la FFT
f = -fs/2:fs/N:(fs/2)-fs/N;     %Genero el eje de frecuencias

%Calculo todas las FFTs
M = fft(x,N)/(fs*T/(2*pi));
XC = fft(xc,N)/(fs*T/(2*pi));
XAM = fft(xAM,N)/(fs*T/(2*pi));
XR_sinc = fft(xr_sinc,N)/(fs*T/(2*pi));
XR_env = fft(xr_env,N)/(fs*T/(2*pi));

%Y las represento...
figure
subplot(5,1,1)
plot(f,abs(fftshift(M)))
xlabel('Frequencia (Hz)')
title('Espectro de la señal moduladora')
subplot(5,1,2)
plot(f,abs(fftshift(XC)))
title('Espectro de la portadora')
xlabel('Frequencia (Hz)') 
subplot(5,1,3)
plot(f,abs(fftshift(XAM)))
title('Espectro de la señal modulada (AM)')
xlabel('Frequencia (Hz)') 
subplot(5,1,4)
plot(f,abs(fftshift(XR_sinc)))
title('Espectro de la señal reconstruida (detector síncrono)')
xlabel('Frequencia (Hz)') 
subplot(5,1,5)
plot(f,abs(fftshift(XR_env)))
title('Espectro de la señal reconstruida (detector de envolvente)')
xlabel('Frequencia (Hz)') 

