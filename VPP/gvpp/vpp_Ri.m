% [Ri] = vpp_Ri(V,phi,Fside,geom,phys,Rconf)

function [Ri] = vpp_Ri(V,phi,Fside,geom,phys,Rconf)

switch Rconf
    case 0
        Rrh = 0;
    case 1
        load('in_Ri');
        cl_in  = in_Ri(2:end,1);
        phi_in = in_Ri(1,2:end);
        cd_in  = in_Ri(2:end,2:end);
        
        cl = Fside./(0.5.*phys.rho_w.*V.^2);
        cd = interp2(cl_in,phi_in,cd_in,cl,phi);
        Ri = Fside*cd/cl;
        %disp('WARNING not yet implemented - function: vpp_Rrh')
    case 2
        %calcutating Te, the effective span of the keel
        Fn = V./sqrt(phys.g*geom.LWL);
        if Fn > 0.6, Fn = 0.6; end %this is quite a rough approssimation, but over Fn 0.6 everything is roughly approssimated... and this prevent Te to become negative! quite good indeed.. ok, it's late, time to sleep!
        phiD = [0 10 20 30];
        
        coeffA = [3.7455	-3.6246	0.0589	-0.0296
            4.4892	-4.8454	0.0294	-0.0176
            3.9592	-3.9804	0.0283	-0.0075
            3.4891	-2.9577	0.0250	-0.0272];

        vectA = [ geom.TCAN./geom.T (geom.TCAN./geom.T).^2 geom.BWL./geom.TCAN geom.CHTPK./geom.CHRTK];

        coeffB = [1.2306	-0.7256
            1.4231	-1.2971
            1.545	-1.5622
            1.4744	-1.3499];

        vectB = [1 Fn];

        Tegeo = coeffA*vectA';
        TeFn  = coeffB*vectB';

        TeD = geom.T .*  Tegeo .* TeFn;

        if phi <= max(phiD)
            Te = interp1(phiD,TeD,phi,'spline');
        else
            Te = interp1(phiD,TeD,phi,'nearest','extrap');
        end
        
        Fheel = Fside./cos(phi*pi/180);
        %calculating Ri, the induced resistance
        Ri = Fheel.^2 ./ (pi .* Te.^2 .* 0.5 .* phys.rho_w .* V.^2);
end