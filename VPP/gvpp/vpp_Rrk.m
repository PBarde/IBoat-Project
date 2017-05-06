% [Rrk] = vpp_Rrk(V,geom,phys,Rconf)

function [Rrk] = vpp_Rrk(V,geom,phys,Rconf)

switch Rconf
    case 0  %this resistance component is not considered
        Rvh = 0;
    case 1  %this resistance component is obtained by a user provided file
        load in_Rrk
        V_in    = in_Rrk(:,1);
        Rrk_in  = in_Rrk(:,2);
        Rrk     = interp1(V_in,Rrk_in,V);
        %disp('WARNING not yet implemented - function: vpp_Rvh')
    case 2  %this resistance component is calculated from the DSYHS99
        Fn = V./sqrt(phys.g*geom.LWL);
        FnD = .1:.05:.6;
        %%%% Is not guaranteed that putting zeros in the first line 
        %%%% is correct. But this is necessary to avoid the final spline
        %%%% interpolation to mess it up
        coeff = [0  0   0   0
            0   0   0   0
            -0.00104 0.00172 0.00117 -0.00008
            -0.00550 0.00597  0.00390 -0.00009
            -0.01110 0.01421  0.00069  0.00021
            -0.00713 0.02632 -0.00232  0.00039
            -0.03581 0.08649  0.00999  0.00017
            -0.00470 0.11592 -0.00064  0.00035
            0.00553 0.07371  0.05991 -0.00114
            0.04822 0.00660  0.07048 -0.00035
            0.01021 0.14173  0.06409 -0.00192];

        vect = [1 geom.T./geom.BWL (geom.T-geom.ZCBK)./geom.DVK.^(1/3) geom.DIVCAN./geom.DVK];

        RrkD = (geom.DVK.*phys.rho_w.*phys.g).* coeff*vect';

        if Fn <= max(FnD)
            Rrk = interp1(FnD,RrkD,Fn,'spline');
        else
            Rrk = interp1(FnD,RrkD,Fn,'linear','extrap');
            % disp('Rrk has been linearly extrapolated. Results may be incorrect')
        end
end
