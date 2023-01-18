%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo de modulación AM en presencia de ruido 
%
% Utilizo como mensaje (señal moduladora) un tono puro
% de frecuencia fx Hz. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Defino algunos parámetros generales
fs = 2000;      %Frecuencia de muestreo (Hz)
Ts = 1/fs;      %Periodo de muestreo (el inverso de fs)
fc = 250;       %Frecuencia de la portadora (Hz)
fx = 25;        %Frecuencia de la moduladora (Hz)
                %¡Ojo! Debe ser mucho menor a fc
T = 2;          %Duración de las señales (s)
Ac = 1;         %Amplitud de la portadora
m = 0.8;       %Índice de modulación
N0 = 1e-4;      %Densidad espectral de potencia del ruido

%Genero la señal moduladora. 
t = 0:Ts:T;
x = cos(2*pi*fx.*t);
%Potencia de la señal moduladora
Sx = meansqr(x);
disp('Potencia de la señal moduladora:');
disp(['  Sx = ' num2str(Sx,3) 'W']);

%Genero la señal modulada
x_n = x/max(abs(x));        % Normalizo la señal de entrada
x_c = cos(2*pi*fc.*t);      % Portadora
x_AM = Ac*(1 + m*x_n).*x_c; % Señal modulada
%Potencia de la señal modulada
Pm = meansqr(x_AM);
disp('Potencia de la señal modulada:');
disp(['  Pm = ' num2str(Pm,3) 'W']);

%Genero el ruido, con densidad espectral de potencia N0/2;
P_N = N0*fs/2;                      %Potencia total del ruido
n = sqrt(P_N)*randn(size(x_AM));

%DETECTOR SÍNCRONO
%Apago la señal y considero que sólo hay ruido
ruido_bp = bandpass(n, [fc-fx fc+fx], fs, 'Steepness',0.95);
NR = meansqr(ruido_bp);
ruido_ol = (2/(Ac*m))*ruido_bp.*x_c;
ruido_lp = lowpass(ruido_ol, fx, fs, 'Steepness',0.95);
ruido_r = ruido_lp - mean(ruido_lp);
ND = meansqr(ruido_r);

%Apago el ruido y considero que sólo hay señal
x_bp = bandpass(x_AM, [fc-fx, fc+fx], fs, 'Steepness',0.95);
SR = meansqr(x_bp);
x_ol = (2/(Ac*m))*x_bp.*x_c;
x_lp = lowpass(x_ol, fx, fs, 'Steepness',0.95);
x_r = x_lp - mean(x_lp);
SD = meansqr(x_r);

snr_r = SR/NR;
SNR_r = 10*log10(snr_r);
disp('Relación señal a ruido en predetección:');
disp(['  (SNR)_R = ' num2str(SNR_r,4) 'dB']);
snr_d = SD/ND;
SNR_d = 10*log10(snr_d);
disp('Relación señal a ruido en postdetección (detector síncrono):');
disp(['  (SNR)_D = ' num2str(SNR_d,4) 'dB']);


%DETECTOR DE ENVOLVENTE
%Apago la señal. Sólo ruido
ruido_bp = bandpass(n, [fc-fx fc+fx], fs, 'Steepness',0.95);
A = abs(hilbert(ruido_bp));
A = lowpass(A, fx, fs, 'Steepness',0.95);
ruido_r = (A - mean(A))/(Ac*m);
ND = meansqr(ruido_r);

%Apago el ruido, solo señal:
x_bp = bandpass(x_AM, [fc-fx, fc+fx], fs, 'Steepness',0.95);
A = abs(hilbert(x_bp)); 
A = lowpass(A, fx, fs, 'Steepness',0.95);
x_r = (A - mean(A))/(Ac*m);
SD = meansqr(x_r);
snr_d = SD/ND;
SNR_d = 10*log10(snr_d);
disp('Relación señal a ruido en postdetección (detector de envolvente):');
disp(['  (SNR)_D = ' num2str(SNR_d,4) 'dB']);



