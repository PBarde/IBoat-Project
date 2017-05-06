% [Rvk] = vpp_Rvk (V,geom,phys,Rconf)

function [Rvk] = vpp_Rvk (V,geom,phys,Rconf)

switch Rconf
    case 0  %this resistance component is not considered
        Rvh = 0;
    case 1  %this resistance component is obtained by a user provided file
        load in_Rvk
        V_in    = in_Rvk(:,1);
        Rvk_in  = in_Rvk(:,2);
        Rvk     = interp1(V_in,Rvk_in,V);
        %disp('WARNING not yet implemented - function: vpp_Rvk')
    case 2  %this resistance component is calculated from the DSYHS99
        Rn = geom.CHMEK .* V ./ phys.ni_w;
        Cf = 0.075 ./ ( log10(Rn) - 2 ).^2;
        Rfk = 1/2 .* phys.rho_w .* V.^2 .* geom.SK .* Cf;
        Rvk = Rfk .* geom.KEELFF;
end