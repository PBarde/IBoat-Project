% [Rvh] = vpp_Rvh (V,geom,phys,Rconf)

function [Rvh] = vpp_Rvh(V,geom,phys,Rconf)

switch Rconf
    case 0  %this resistance component is not considered
        Rvh = 0;
    case 1  %this resistance component is obtained by a user provided file
        load in_Rvh
        V_in    = in_Rvh(:,1);
        Rvh_in  = in_Rvh(:,2);
        Rvh     = interp1(V_in,Rvh_in,V);
        %disp('WARNING not yet implemented - function: vpp_Rvh')
    case 2  %this resistance component is calculated from the DSYHS99
        Rn = geom.LWL .* 0.7 .* V ./ phys.ni_w;
        Cf = 0.075 ./ ( log10(Rn) - 2 ).^2;
        Rfh = 1/2 .* phys.rho_w .* V.^2 .* geom.SC .* Cf;
        Rvh = Rfh .* geom.HULLFF;
end