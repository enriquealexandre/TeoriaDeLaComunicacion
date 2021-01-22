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
m = 0.8;   %Índice de modulación
fc = 250;   %Frecuencia de la portadora (Hz)
fx = 25;    %Frecuencia de la moduladora (Hz)
            %¡Ojo! Debe ser mucho menor a fc
T = 1;    %Duración de las señales (s)
df = 0.3;   %Resolución mínima que quiero tener en frecuencia (Hz)
Ac = 1;     %Amplitud de la portadora

%Genero la señal moduladora. 
t = -T/2:Ts:T/2;
x = cos(2*pi*fx.*t);
%Potencia de la señal moduladora
Sx = meansqr(x);

%Genero la portadora
x_c = Ac*cos(2*pi*fc.*t);

%Modulo en AM
x_AM = moduladorAM(x, x_c, m);
%Potencia de la señal modulada
Pm = meansqr(x_AM);

%Como es AM, tengo dos opciones de detector: envolvente o síncrono
%Primero pruebo con un síncrono:
x_r_sinc = detectorSincrono(x_AM, 2/(Ac*m), fc, 0, 0, fx, fs);
%Ahora un detector de envolvente:
x_r_env = detectorEnvolvente(x_AM, 1/(Ac*m), fc, fx, fs);

%Pinto las cuatro señales en el tiempo, para ver su aspecto
figure
subplot(5,1,1)
plot(t,x)
xlabel('Tiempo (s)');
title('Señal moduladora (mensaje)')
subplot(5,1,2);
plot(t, x_c);
xlabel('Tiempo (s)');
title('Portadora')
subplot(5,1,3);
plot(t, x_AM);
xlabel('Tiempo (s)');
title('Señal modulada (AM)')
subplot(5,1,4);
plot(t, x_r_sinc);
xlabel('Tiempo (s)');
title('Señal detectada (detector síncrono)')
subplot(5,1,5);
plot(t, x_r_env);
xlabel('Tiempo (s)');
title('Señal detectada (detector de envolvente)')

%Ahora voy a calcular los espectros de las señales anteriores
N = 2^nextpow2(fs/df);          %Número de muestras de la FFT
f = -fs/2:fs/N:(fs/2)-fs/N;     %Genero el eje de frecuencias

%Calculo todas las FFTs
M = fft(x,N)/(fs*T/(2*pi));
X_C = fft(x_c,N)/(fs*T/(2*pi));
X_AM = fft(x_AM,N)/(fs*T/(2*pi));
X_R_sinc = fft(x_r_sinc,N)/(fs*T/(2*pi));
X_R_env = fft(x_r_env,N)/(fs*T/(2*pi));

%Y las represento...
figure
subplot(5,1,1)
plot(f,abs(fftshift(M)))
xlabel('Frequencia (Hz)')
title('Espectro de la señal moduladora')
subplot(5,1,2)
plot(f,abs(fftshift(X_C)))
title('Espectro de la portadora')
xlabel('Frequencia (Hz)') 
subplot(5,1,3)
plot(f,abs(fftshift(X_AM)))
title('Espectro de la señal modulada (AM)')
xlabel('Frequencia (Hz)') 
subplot(5,1,4)
plot(f,abs(fftshift(X_R_sinc)))
title('Espectro de la señal reconstruida (detector síncrono)')
xlabel('Frequencia (Hz)') 
subplot(5,1,5)
plot(f,abs(fftshift(X_R_env)))
title('Espectro de la señal reconstruida (detector de envolvente)')
xlabel('Frequencia (Hz)') 

