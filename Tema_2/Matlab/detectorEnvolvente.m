function y = detectorEnvolvente(x, G, fc, Wx, fs)
%function y = detectorEnvolvente(x, G, fc, Wx, fs)
%
%
% Implementa un detector de envolvente. Incluye supresor de continua. 
% Entradas:
%   - x: Señal de entrada al detector
%   - G: Ganancia del detector
%   - fc: Frecuencia de la portadora (Hz)
%   - Wx: Ancho de banda del mensaje (Hz)
%   - fs: Frecuencia de muestreo (Hz)
% Salida:
%   - y: Señal detectada

%Comienzo filtrando paso banda la señal recibida
x_bp = bandpass(x, [fc-Wx, fc+Wx], fs, 'Steepness', 0.95);

%Calculo la envolvente de la señal
envolvente = abs(hilbert(x_bp));

%Filtro paso bajoo
x_lp = lowpass(envolvente, Wx, fs, 'Steepness', 0.95);

%Y le quito la continua
y = G*(x_lp - mean(x_lp));

