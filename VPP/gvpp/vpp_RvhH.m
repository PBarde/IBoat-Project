% [RvhH] = vpp_RvhH(V,phi,geom,phys,Rconf)

function [RvhH] = vpp_RvhH(V,phi,geom,phys,Rconf)

switch Rconf
    case 0
        RvhH = 0;
    case 1
        load in_RvhH;
        V_in    = in_RvhH(2:end,1);
        phi_in  = in_RvhH(1,2:end);
        RvhH_in = in_RvhH(2:end,2:end);
        RvhH    = interp1(V_in,RvhH_in,V);
        %disp('WARNING not yet implemented - function: vpp_Rrh')
    case 2
        phiD = [0 5 10 15 20 25 30 35];

        coeff = [0.000	0.000	0.000	0.000
            -4.112	0.054	-0.027	6.329
            -4.522	-0.132	-0.077	8.738
            -3.291	-0.389	-0.118	8.949
            1.850	-1.200	-0.109	5.364
            6.510	-2.305	-0.066	3.443
            12.334	-3.911	0.024	1.767
            14.648	-5.182	0.102	3.497];

        vect = [1 geom.BWL./geom.TCAN (geom.BWL./geom.TCAN).^2 geom.CMS];

        SCphiD = geom.SC .* ( 1 + 1/100.*coeff*vect');

        if phi <= max(phiD)
            SCphi = interp1(phiD,SCphiD,phi,'spline');
        else
            SCphi = interp1(phiD,SCphiD,phi,'linear','extrap');
            % disp('SCphi has been extrapolated. Results may be incorrect. function: vpp_RvhH')
        end

        Rn = geom.LWL .* 0.7 .* V ./ phys.ni_w;
        Cf = 0.075 ./ ( log10(Rn) - 2 ).^2;
        RfhH = 1/2 .* phys.rho_w .* V.^2 .* Cf.* (SCphi - geom.SC);
        RvhH = RfhH.* geom.HULLFF;  %does it make sense to use the same hull form factor both for the upright and the heeled hull?
end