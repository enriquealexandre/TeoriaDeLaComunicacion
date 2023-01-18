
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Relación entre la SNR y la eficiencia espectral para
% varias modulaciones digitales en relación con el límite
% de Shannon-Hartley
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Fijo una probabilidad de error de bit dada
Pb = 1e-5;

% Dibujo en primer lugar el límite de Shannon-Hartley
rho = 0:0.01:16;
SNR=(2.^rho-1)./rho;
semilogy(10*log10(SNR), rho, 'LineWidth',2)
hold on

%Modulación PSK (el caso M=2 lo hago aparte porque es un caso particular)
k = [2:5];
M = 2.^k;
Eb_PSK = [10.*log10(0.5*qfuncinv(Pb)^2) 10.*log10((qfuncinv(k.*Pb/2).^2)./(2.*k.*(sin(pi./M)).^2))];
k = [1:5];
scatter(Eb_PSK, k, 'LineWidth',2)

%Modulación M-FSK (M=4,8,16,32,64) 
k = [3:6];
M = 2.^k;
Eb_FSK = 10.*log10(((qfuncinv((((2.^k)-1)*(Pb))./((2.^(k-1)).*(M-1)))).^2)./(k));
scatter(Eb_FSK,2.*k./(M+1),'s', 'LineWidth',2);

%Modulación M-QAM (M=16,32,64)
k = [4:6];
M = 2.^k;
Eb_QAM = 10*log10(((M-1)./(3.*k)).*(qfuncinv((k.*Pb)./(4*(1-(1./sqrt(M)))))).^2);
scatter(Eb_QAM, k, 'd', 'LineWidth',2);


yline(1)
xlabel('E_b/N_0')
ylabel('R/W');
legend('Límite Shannon-Hartley','M-PSK','M-FSK','M-QAM');
grid
