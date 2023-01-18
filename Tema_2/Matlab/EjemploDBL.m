%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo de modulación/demodulación DBL 
%
% Utilizo como mensaje (señal moduladora) un tono puro
% de frecuencia fx Hz. 
% En detección utilizo un detector síncrono
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defino algunos parámetros generales
fs = 4000;      %Frecuencia de muestreo (Hz)
Ts = 1/fs;      %Periodo de muestreo (el inverso de fs)
fc = 250;       %Frecuencia de la portadora (Hz)
fx = 25;        %Frecuencia de la moduladora (Hz)
                %¡Ojo! Debe ser mucho menor a fc
T = 1;          %Duración de las señales (s)
df = 0.3;       %Resolución mínima que quiero tener en frecuencia (Hz)
deltaF = 0;     %Error en la frecuencia del OL
deltaPHI = 0;   %Error en la fase del OL
Ac = 1;         %Amplitud de la portadora

%Genero la señal moduladora. 
t = 0:Ts:T;
x = cos(2*pi*fx.*t);
%Potencia de la señal moduladora
Sx = meansqr(x);

%Genero la portadora
x_c = Ac*cos(2*pi*fc.*t);

%Ahora genero la señal modulada en DBL:
x_DBL = moduladorDBL(x, x_c);
%Calculo la potencia de la señal modulada
Pm = meansqr(x_DBL);

%Detecto la señal con un detector síncrono
x_r = detectorSincrono(x_DBL, 2/Ac, fc, deltaF, deltaPHI, fx, fs);

%Pinto las cuatro señales en el tiempo, para ver su aspecto
figure
subplot(4,1,1)
plot(t,x)
xlabel('Tiempo (s)');
title(['Señal moduladora (mensaje), Sx=' num2str(Sx,3) 'W'])
subplot(4,1,2);
plot(t, x_c);
xlabel('Tiempo (s)');
title('Portadora')
subplot(4,1,3);
plot(t, x_DBL);
xlabel('Tiempo (s)');
title(['Señal modulada (DBL), Pm=' num2str(Pm,3) 'W'])
subplot(4,1,4);
plot(t, x_r);
xlabel('Tiempo (s)');
title('Señal detectada')

%Ahora voy a calcular los espectros de las señales anteriores
N = 2^nextpow2(fs/df);          %Número de muestras de la FFT
f = -fs/2:fs/N:(fs/2)-fs/N;     %Genero el eje de frecuencias

%Calculo todas las FFTs
M = fft(x,N)/(fs*T/(2*pi));
X_C = fft(x_c,N)/(fs*T/(2*pi));
X_DBL = fft(x_DBL,N)/(fs*T/(2*pi));
X_R = fft(x_r,N)/(fs*T/(2*pi));

%Y las represento...
figure
subplot(4,1,1)
plot(f,abs(fftshift(M)))
xlabel('Frecuencia (Hz)')
title(['Espectro de la señal moduladora, Sx=' num2str(Sx,3) 'W'])
subplot(4,1,2)
plot(f,abs(fftshift(X_C)))
title('Espectro de la portadora')
xlabel('Frecuencia (Hz)') 
subplot(4,1,3)
plot(f,abs(fftshift(X_DBL)))
title(['Espectro de la señal modulada, Pm=' num2str(Pm,3) 'W'])
xlabel('Frecuencia (Hz)') 
subplot(4,1,4)
plot(f,abs(fftshift(X_R)))
title('Espectro de la señal reconstruida')
xlabel('Frecuencia (Hz)') 


