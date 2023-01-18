%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo de modulación AM 
%
% Utilizo como mensaje (señal moduladora) un tono puro
% de frecuencia fx Hz. 
% En detección utilizo un detector síncrono y un 
% detector de envolvente
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Defino algunos parámetros generales
fs = 4000;  %Frecuencia de muestreo (Hz)
Ts = 1/fs;  %Periodo de muestreo (el inverso de fs)
mu = 0.8;   %Índice de modulación
fc = 250;   %Frecuencia de la portadora (Hz)
fx = 25;    %Frecuencia de la moduladora (Hz)
            %¡Ojo! Debe ser mucho menor a fc
T = 0.2;    %Duración de las señales (s)
df = 0.3;   %Resolución mínima que quiero tener en frecuencia (Hz)
fd = 75;    %Desviación de frecuencia (Hz/V)
Ac = 1;     %Amplitud de la portadora


%Genero la señal moduladora. 
t = 0:Ts:T;
x = cos(2*pi*25.*t);

%Modulo la señal en FM
[xFM, xc] = moduladorFM(x,Ac,fc,fd,fs);

%Para la detección, utilizo el procedimiento del problema 2.5 del boletín
xr = detectorFM(xFM, Ac, fc, fx, fd, Ts);


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
plot(t, xFM);
xlabel('Tiempo (s)');
title('Señal modulada (FM)')
subplot(4,1,4);
plot(t(1:end-1), xr);
xlabel('Tiempo (s)');
title('Señal detectada')


%Ahora voy a calcular los espectros de las señales anteriores
N = 2^nextpow2(fs/df);          %Número de muestras de la FFT
f = -fs/2:fs/N:(fs/2)-fs/N;     %Genero el eje de frecuencias

%Calculo todas las FFTs
M = fft(x,N)/(fs*T/(2*pi));
XC = fft(xc,N)/(fs*T/(2*pi));
XFM = fft(xFM,N)/(fs*T/(2*pi));
XR = fft(xr,N)/(fs*T/(2*pi));


%Y las represento...
figure
subplot(4,1,1)
plot(f,abs(fftshift(M)))
xlabel('Frecuencia (Hz)')
title('Espectro de la señal moduladora')
subplot(4,1,2)
plot(f,abs(fftshift(XC)))
title('Espectro de la portadora')
xlabel('Frecuencia (Hz)') 
subplot(4,1,3)
plot(f,abs(fftshift(XFM)))
title('Espectro de la señal modulada (FM)')
xlabel('Frecuencia (Hz)') 
subplot(4,1,4)
plot(f,abs(fftshift(XR)))
title('Espectro de la señal reconstruida')
xlabel('Frecuencia (Hz)') 


