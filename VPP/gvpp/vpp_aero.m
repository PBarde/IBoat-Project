% [Fdrive,Fside,Mheel] = vpp_aero(X,geom,phys,V_tw,alfa_tw)
% 
% X = [V,phi,b,F]
% geom = boat geometry struct
% V_tw = true wind velocity
% alfa = true wind angle

function [Fdrive,Fside,Mheel] = vpp_aero(X,geom,phys,V_tw,alfa_tw)

V = X(1);
phi = X(2);
b = X(3);
F = X(4);

% rotating the wind vector in the mast's perpendicular plane
V1 = V + V_tw .* cos(alfa_tw*pi/180);
V2 = V_tw .* sin(alfa_tw*pi/180) .* cos(phi*pi/180);

V_eff = sqrt( V1.^2 + V2.^2 );
alfa_eff = atan2(V2,V1);

[AN,Cl,Cd,ZCE] = vpp_sailset(alfa_eff,F,geom);

L = 0.5 * phys.rho_a * V_eff.^2 .* AN .* Cl;
D = 0.5 * phys.rho_a * V_eff.^2 .* AN .* Cd;

Fdrive = L * sin(alfa_eff) - D * cos(alfa_eff);
Fheel = L * cos(alfa_eff) + D * sin(alfa_eff);
%if Fdrive < 0; Fdrive = 0; end
%if Fheel < 0; Fheel = 0; end
Mheel = Fheel*(ZCE + geom.T - geom.ZCBK);    % attenzione: il centro di spinta della deriva è stato messo nel centro di galleggiamento. l'ipotesi è corretta?
Fside = Fheel*cos(phi*pi/180);
