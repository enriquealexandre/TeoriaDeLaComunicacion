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
t = [0:Ts:T];
m = cos(2*pi*25.*t);
m = m/max(abs(m));  %Sé que lo está, pero me aseguro de que esté normalizada porque es AM

%Ahora genero la portadora. Un coseno de frecuencia fc de la misma duración
%que la señal moduladora
xc = cos(2*pi*fc.*t);

%Por último, la señal AM:
xAM = (1+mu*m).*xc;

%Como es AM, tengo dos opciones de detector: envolvente o síncrono
%Empiezo con un síncrono, igual que el visto en clase
%Genero antes de nada un filtro paso bajo
Lfiltro = 25;   %Longitud del filtro
fpb = 2*fx;       %Frecuencia de corte del filtro paso bajo
Rp  = 0.00057565; % Rizado permitido (0.01 dB)
Rst = 1e-4;       % Atenuación de la banda de corte (80 dB)
eqnum = firceqrip(Lfiltro,fpb/(fs/2),[Rp Rst],'passedge'); 

%Ahora multiplico por el oscilador local, y filtro la señal
%a la salida del oscilador local con el filtro paso bajo
xr_sinc = filter(eqnum,1,2*xAM.*xc);
%Le quito la componente continua
xr_sinc = (xr_sinc-mean(xr_sinc))/mu;

%Pruebo también con un detector de envolvente:
A=abs(hilbert(xAM));    %Esta es la envolvente de la señal
xr_env = (A - mean(A))/mu;

%Pinto las cuatro señales en el tiempo, para ver su aspecto
figure
subplot(5,1,1)
plot(t,m)
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
M = fft(m,N)/(fs*T/(2*pi));
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

