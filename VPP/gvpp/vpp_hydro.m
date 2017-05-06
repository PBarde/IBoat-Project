% [Rtot,Mright] = vpp_hydro(V,phi,b,Fheel,geom,phys,Rconf)

function [Rtot,Mright] = vpp_hydro(X,Fside,geom,phys,Rconf)

V = X(1);
phi = X(2);
b = X(3);
F = X(4);

V = abs(V); 
phi = abs(phi);

Ri      = vpp_Ri(V,phi,Fside,geom,phys,Rconf.Ri);
Rrh     = vpp_Rrh(V,geom,phys,Rconf.Rrh);
RrhH    = vpp_RrhH(V,phi,geom,phys,Rconf.RrhH);
Rrk     = vpp_Rrk(V,geom,phys,Rconf.Rrk);
RrkH    = vpp_RrkH(V,phi,geom,phys,Rconf.RrkH);
Rvh     = vpp_Rvh(V,geom,phys,Rconf.Rvh);
RvhH    = vpp_RvhH(V,phi,geom,phys,Rconf.RvhH);
Rvk     = vpp_Rvk(V,geom,phys,Rconf.Rvk);
Rvr     = vpp_Rvr(V,geom,phys,Rconf.Rvr);

% check that computed values are not complex. 
if imag(Ri)~=0,     error('Ri is complex'),    end
if imag(Rrh)~=0,    error('Rrh is complex'),   end
if imag(RrhH)~=0,   error('RrhH is complex'),  end
if imag(Rrk)~=0,    error('Rrk is complex'),   end
if imag(RrkH)~=0,   error('RrkH is complex'),  end
if imag(Rvh)~=0,    error('Rvh is complex'),   end
if imag(RvhH)~=0,   error('RvhH is complex'),  end
if imag(Rvk)~=0,    error('Rvk is complex'),   end
if imag(Rvr)~=0,    error('Rvr is complex'),   end

Rtot = Ri + Rrh + RrhH + Rrk + RrkH + Rvh + RvhH + Rvk + Rvr;

[Mright] = vpp_Mright(X,geom,phys);
