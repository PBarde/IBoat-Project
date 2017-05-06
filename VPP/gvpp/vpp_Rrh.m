% function [Rrh] = vpp_Rrh(V,geom,phys,Rconf)

function [Rrh] = vpp_Rrh(V,geom,phys,Rconf)

switch Rconf
    case 0
        Rrh = 0;
    case 1
        load in_Rrh
        V_in = in_Rrh(:,1);
        Rrh_in = in_Rrh(:,2);
        Rrh    = interp1(V_in,Rrh_in,V);
        %disp('WARNING not yet implemented - function: vpp_Rrh')
    case 2
        Fn = V./sqrt(phys.g*geom.LWL);
        FnD = .1:.05:.6;

        coeff = [-0.0014  0.0403  0.0470 -0.0227 -0.0119  0.0061 -0.0086 -0.0307 -0.0553
                  0.0004 -0.1808  0.1793 -0.0004  0.0097  0.0118 -0.0055  0.1721 -0.1728
                  0.0014 -0.1071  0.0637  0.0090  0.0153  0.0011  0.0012  0.1021 -0.0648
                  0.0027  0.0463 -0.1263  0.0150  0.0274 -0.0299  0.0110 -0.0595  0.1220
                  0.0056 -0.8005  0.4891  0.0269  0.0519 -0.0313  0.0292  0.7314 -0.3619
                  0.0032 -0.1011 -0.0813 -0.0382  0.0320 -0.1481  0.0837  0.0223  0.1587
                 -0.0064  2.3095 -1.5152  0.0751 -0.0858 -0.5349  0.1715 -2.4550  1.1865
                 -0.0171  3.4017 -1.9862  0.3242 -0.1450 -0.8043  0.2952 -3.5284  1.3575
                 -0.0201  7.1576 -6.3304  0.5829  0.1630 -0.3966  0.5023 -7.1579  5.2534
                  0.0495  1.5618 -6.0661  0.8641  1.1702  1.7610  0.9176 -2.1191  5.4281
                  0.0808 -5.3233 -1.1513  0.9663  1.6084  2.7459  0.8491  4.7129  1.1089];

        vect = [geom.LWL./geom.DIVCAN^(1/3), geom.XFB./geom.LWL,	geom.CPL,	geom.DIVCAN.^(2/3)./geom.AW,	geom.BWL./geom.LWL,	geom.DIVCAN.^(2/3)./geom.SC,	geom.XFB./geom.XFF,	(geom.XFB./geom.LWL).^2,	geom.CPL.^2]';

        RrhD = (geom.DIVCAN.*phys.g.*phys.rho_w) .* ( coeff * vect ) .* (geom.DIVCAN.^(1/3)./geom.LWL);

        if Fn <= max(FnD)
            Rrh = interp1(FnD,RrhD,Fn,'spline');
        else
            Rrh = interp1(FnD,RrhD,Fn,'linear','extrap');
            % disp('Rrh has been linearly extrapolated. Results may be incorrect. function: vpp_Rrh')
        end
        % WARNING: THIS CORRECTION COULD BE WRONG 
        if Rrh<0
            Rrh = 0;
        end
end
