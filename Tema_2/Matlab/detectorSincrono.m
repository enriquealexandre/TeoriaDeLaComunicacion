function y = detectorSincrono(x, AOL, fc, deltaF, deltaPhi, Wx, fs)
%function y = detectorSincrono(x, AOL, fc, deltaF, deltaPhi, Wx, fs)
%
% Implementa un detector síncrono, con filtro paso bajo y supresor de continua.
% Entradas:
%   - x: Señal de entrada al detector
%   - AOL: Amplitud del oscilador local (V)
%   - fc: Frecuencia de la portadora (Hz)
%   - deltaF: Error en la frecuencia del O.L. (Hz)
%   - deltaPhi: Error en la fase del O.L. (rad/s)
%   - phiOL: Fase del oscilador local (rad/s)
%   - Wx: Ancho de banda del mensaje (Hz)
%   - fs: Frecuencia de muestreo para trabajar (Hz)
% Salida: 
%   - xr: Señal detectada

%Antes de nada genero el vector de tiempos para poder trabajar
Ts = 1/fs;
t = 0:Ts:(Ts*length(x))-Ts; % Genero el vector de tiempos;

%Genero la señal del oscilador local:
OL = AOL*cos(2*pi*(fc+deltaF).*t + deltaPhi);

%En primer lugar paso la señal recibida por un filtro paso banda
x_bp = bandpass(x, [fc-Wx fc+Wx], fs, 'Steepness', 0.95);

%Ahora multiplico por el oscilador local
x_OL = x_bp.*OL;

%Filtro paso bajo
x_lp = lowpass(x_OL, Wx, fs, 'Steepness', 0.95);

%Y por último elimino la continua
y = x_lp - mean(x_lp);

