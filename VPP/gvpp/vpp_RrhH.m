% [RrhH] = vpp_RrhH(V,phi,geom,phys,Rconf)

function [RrhH] = vpp_RrhH(V,phi,geom,phys,Rconf)

switch Rconf
    case 0
        Rrh = 0;
    case 1
        load in_RrhH;
        V_in    = in_RrhH(2:end,1);
        phi_in  = in_RrhH(1,2:end);
        RrhH_in = in_RrhH(2:end,2:end);
        RrhH    = interp1(V_in,RrhH_in,V);
        %disp('WARNING not yet implemented - function: vpp_Rrh')
    case 2
        Fn = V./sqrt(phys.g*geom.LWL);
        FnD = .1:.05:.6;

        coeff = [0 0 0 0 0 0
            0 0 0 0	0 0
            0 0 0 0	0 0
            -0.0268	-0.0014	-0.0057	0.0016 -0.0070 -0.0017
            0.6628	-0.0632	-0.0699	0.0069  0.0459 -0.0004
            1.6433	-0.2144	-0.1640	0.0199 -0.0540 -0.0268
            -0.8659	-0.0354	 0.2226	0.0188 -0.5800 -0.1133
            -3.2715	 0.1372	 0.5547	0.0268 -1.0064 -0.2026
            -0.1976	-0.1480	-0.6593	0.1862 -0.7489 -0.1648
            1.5873	-0.3749	-0.7105	0.2146 -0.4818 -0.1174
            1.5873	-0.3749	-0.7105	0.2146 -0.4818 -0.1174]./1000;

        vect = [1	geom.LWL./geom.BWL	geom.BWL./geom.TCAN	(geom.BWL./geom.TCAN).^2	geom.XFB./geom.LWL	(geom.XFB./geom.LWL).^2];

        RrhH20D = (geom.DIVCAN.*phys.g.*phys.rho_w) .* coeff*vect';

        if Fn <= max(FnD)
            RrhH20 = interp1(FnD,RrhH20D,Fn,'spline');
        else
            RrhH20 = interp1(FnD,RrhH20D,Fn,'linear','extrap');
            % disp('RrhH has been linearly extrapolated. Results may be incorrect. function: vpp_RrhH')
        end

        RrhH = RrhH20 .* 6 .* (phi*pi/180).^1.7;
end