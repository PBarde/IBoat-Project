% [Rvr] = vpp_Rvr (V,geom,phys,Rconf)

function [Rvr] = vpp_Rvr (V,geom,phys,Rconf)

switch Rconf
    case 0  %this resistance component is not considered
        Rvr = 0;
    case 1  %this resistance component is obtained by a user provided file
        load in_Rvr
        V_in    = in_Rvr(:,1);
        Rvr_in  = in_Rvr(:,2);
        Rvr     = interp1(V_in,Rvr_in,V);
        %disp('WARNING not yet implemented - function: vpp_Rvk')
    case 2  %this resistance component is calculated from the DSYHS99
        Rn = geom.CHMER .* V ./ phys.ni_w;
        Cf = 0.075 ./ ( log10(Rn) - 2 ).^2;
        Rfr = 1/2 .* phys.rho_w .* V.^2 .* geom.SR .* Cf;
        Rvr = Rfr .* geom.RUDDFF;
end