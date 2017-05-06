% [AN,Cl,Cd,ZCE] = vpp_sailset(alfa_eff,F,sails,geom)

function [AN,Cl,Cd,ZCE] = vpp_sailset(alfa_eff,F,geom)

alfa_eff = alfa_eff*180/pi;

%calcoluating sails area and ZCE (above waterline)
AM = 0.5 .* geom.P .* geom.E .*geom.MROACH;             %mainsail area
AJ = 0.5 .* sqrt( geom.I.^2 + geom.J.^2) .* geom.LPG;   %jib area
AS = 1.15 .* geom.SL .* geom.J;                         %spi area
AF = 0.5 .* geom.I .* geom.J;                           %foretriangle area
AN = AF + AM;                                           %nominal area

ZCEM = 0.39 .* geom.P + geom.BAD;
ZCEJ = 0.39 .* geom.I;
ZCES = 0.59 .* geom.I;

% calculating Cl and Cd

% LE_Cl-LE_Cd -> Hazer Cl-Cd coefficients, 1999
% [Apparent wind angle, Main, Jib, spi]
if (geom.MFLB == 1)
  % Revision for full-length battens in main; added zeros at alfa = 0
  LE_Cl = [
  0   0      0   0
  27  1.725  1.5 0
  50  1.5  0.5 1.5
  80  0.95   0.3 1.0
  100 0.85   0.0 0.85
  180 0      0   0];
else
  LE_Cl = [
  0   0    0   0
  27  1.5  1.5 0
  50  1.5  0.5 1.5
  80  0.95 0.3 1.0
  100 0.85 0.0 0.85
  180 0    0   0];
end

LE_Cdp = [
0   0    0    0
27  0.02 0.02 0
50  0.15 0.25 0.25
80  0.8  0.15 0.9
100 1.0  0.0  1.2
180 0.9  0.0  0.66];

% Changed from spline to pchip to avoid oscillations that produced negative
% drag and other non-physical behavior.
Cl_M = pchip(LE_Cl(:,1),LE_Cl(:,2),alfa_eff);
Cl_J = pchip(LE_Cl(:,1),LE_Cl(:,3),alfa_eff);
Cl_S = pchip(LE_Cl(:,1),LE_Cl(:,4),alfa_eff);

Cdp_M = pchip(LE_Cdp(:,1),LE_Cdp(:,2),alfa_eff);
Cdp_J = pchip(LE_Cdp(:,1),LE_Cdp(:,3),alfa_eff);
Cdp_S = pchip(LE_Cdp(:,1),LE_Cdp(:,4),alfa_eff);

% ZCE is calculated above the waterline as in the ITTC definition. Please
% note that in Larrson & Elliason is intended over the freeboard

switch geom.SAILSET
case 1    %Main only
	AN = AM;
	Cl = Cl_M;
	Cdp = Cdp_M;
	ZCE = ZCEM;
    case 3    %Main and Jib
	Cl = ( Cl_M .* AM + Cl_J .* AJ ) ./ AN;
	Cdp = ( Cdp_M .* AM + Cdp_J .* AJ ) ./ AN;
	ZCE = (ZCEM .* AM + ZCEJ .* AJ) ./ (AM + AJ);
    case 5    %Main and Spi
	Cl = ( Cl_M .* AM + Cl_S .* AS ) ./ AN;
	Cdp = ( Cdp_M .* AM + Cdp_S .* AS ) ./ AN;
	ZCE = (ZCEM .* AM + ZCES .* AS) ./ (AM + AS);
    case 7    %Main, Jib and Spi
	Cl = ( Cl_M .* AM + Cl_J .* AJ + Cl_S .* AS ) ./ AN;
	Cdp = ( Cdp_M .* AM + Cl_J .* AJ + Cdp_S .* AS ) ./ AN;
	ZCE = (ZCEM .* AM + ZCEJ .* AJ + ZCES .* AS) ./ (AM + AJ + AS);
end

Cl = Cl.*F;     %flattening factor

if alfa_eff < 45
    AR = (1.1*( geom.EHM + geom.AVGFREB)).^2./AN;
else
    AR = (1.1*( geom.EHM )).^2./AN;
end

CdI = Cl^2 .* ( 1/(pi*AR) + 0.005); %induced resistance
Cd0 = 1.13 .* ( (geom.B*geom.AVGFREB) + (geom.EHM*geom.EMDC) ) ./ AN;

Cd = Cdp + Cd0 + CdI;
