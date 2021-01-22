function xr = detectorSincrono(x, AOL, fOL, phiOL, fPB, fs)
%function xr = detectorSincrono(x, AOL, fOL, phiOL, fPB, fs)
%
% Implementa un detector síncrono, con filtro paso bajo y supresor de continua.
% Entradas:
%   - x: Señal de entrada al detector
%   - AOL: Amplitud del oscilador local (V)
%   - fOL: Frecuencia del oscilador local (Hz)
%   - phiOL: Fase del oscilador local (rad/s)
%   - fPB: Frecuencia de corte del filtro paso bajo (Hz)
%   - fs: Frecuencia de muestreo para trabajar (Hz)
% Salida: 
%   - xr: Señal detectada



Ts = 1/fs;
t = 0:Ts:(Ts*length(x))-Ts; % Genero el vector de tiempos;

%Genero la señal del oscilador local:
xOL = AOL*cos(2*pi*fOL.*t + phiOL);

%Defino el filtro paso bajo
Lfiltro = 30;   %Longitud del filtro
Rp  = 0.00057565; % Rizado permitido (0.01 dB)
Rst = 1e-4;       % Atenuación de la banda de corte (80 dB)
eqnum = firceqrip(Lfiltro,fPB/(fs/2),[Rp Rst],'passedge'); 

%Ahora  en primer lugar multiplico por el oscilador local
xrOL = x.*xOL;
%Filtro paso bajo
xr = filter(eqnum,1,xrOL);
%Y elimino la continua
xr = xr - mean(xr);

