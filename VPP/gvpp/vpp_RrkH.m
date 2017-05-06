% [RrkH] = vpp_RrkH(V,phi,geom,phys,Rconf)

function [RrkH] = vpp_RrkH(V,phi,geom,phys,Rconf)

switch Rconf
    case 0
        Rrh = 0;
    case 1
        load in_RrkH;
        V_in    = in_RrkH(2:end,1);
        phi_in  = in_RrkH(1,2:end);
        RrkH_in = in_RrkH(2:end,2:end);
        RrkH    = interp1(V_in,RrkH_in,V);
        %disp('WARNING not yet implemented - function: vpp_Rrh')
    case 2
        Fn = V./sqrt(phys.g*geom.LWL);
        coeff = [-3.5837 -0.0518	0.5958	0.2055];
        vect = [geom.TCAN./geom.T	geom.BWL./geom.TCAN	(geom.BWL.*geom.TCAN)./(geom.T.*geom.TCAN)	geom.LWL./geom.DIVCAN.^1/3];
        Ch = coeff*vect';
        RrkH = geom.DVK.*phys.rho_w.*phys.g.*Ch.*Fn.^2.*phi*pi/180;
end