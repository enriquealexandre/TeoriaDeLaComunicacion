function xr = detectorFM(x, Ac, fc, Wx, fd, Ts)
%function xr = detectorFM(x, Ac, fc, Wx, fd, Ts)
%
% Implementa un detector de FM utilizando el mismo procedimiento que el
% descrito en el problema 2.5 del boletín (derivador seguido de un detector
% de envolvente).
% Entradas:
%   - x: Señal de entrada al detector
%   - Ac: Amplitud de la portadora (para poder normalizar)
%   - fc: Frecuencia de la portadora (Hz)
%   - Wx: Ancho de banda del mensaje (Hz)
%   - fd: Desviación de frecuencia (Hz/V)
%   - Ts: Resolución temporal
% Salida:
%   - xr: Señal detectada

%Calculo la derivada
derivada = diff(x)/Ts;
%Y ahora un detector de envolvente
xr = detectorEnvolvente(derivada, 1, fc, Wx, 1/Ts)/(2*pi*fd*Ac);
