function xr = detectorEnvolvente(x)
%
%
% Implementa un detector de envolvente. Incluye supresor de continua. 
% Entrada:
%   - x: Señal de entrada al detector
% Salida:
%   - xr: Señal detectada

%Calculo la envolvente
A = abs(hilbert(x));   
%Y le quito la continua
xr = (A - mean(A));

