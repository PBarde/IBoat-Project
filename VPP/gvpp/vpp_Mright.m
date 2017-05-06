% [wind,geom,phys,Rconf,conf] = vpp_load()

function [Mright] = vpp_Mright(X,geom,phys)

V = X(1);
phi = X(2);
b = X(3);
F = X(4);

M1 = (geom.KM - geom.KG) * sin(phi*pi/180) * phys.g * phys.rho_w * (geom.DIVCAN + geom.DVK);
M2 = geom.MMVBLCRW .* phys.g .* b .* cos(phi*pi/180);
Mright = M1+M2;

