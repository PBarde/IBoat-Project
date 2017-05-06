% [wind,geom,phys,Rconf,conf] = vpp_load()

function [wind,geom,phys,Rconf,conf] = vpp_load()

% vpp.geom

fid = fopen('vpp.geom'); 
fseek(fid,0,'eof'); endstatus = ftell(fid); frewind(fid); position = ftell(fid);
while position < endstatus
    position = ftell(fid);
    entry = fscanf(fid,'%s  ',[1 1]); value = fscanf(fid,'%f\n',[1 1]);
    switch entry
        case 'DIVCAN',      geom.DIVCAN     = value; % Displ vol canoe body [m^3]
        case 'LWL',         geom.LWL        = value; % Length at waterline [m]
        case 'BWL',         geom.BWL        = value; % Beam at waterline [m]
        case 'B',           geom.B          = value; % Beam (max) [m]
        case 'AVGFREB',     geom.AVGFREB    = value; % Avg freeboard [m]
        case 'XFB',         geom.XFB        = value; % Long ctr buoyancy [m] 
        case 'XFF',         geom.XFF        = value; % Long ctf floatation [m]
        case 'CPL',         geom.CPL        = value; % Long prismatic coef [-]
        case 'HULLFF',      geom.HULLFF     = value; % Hull form factor [-] (correction to viscous resitance)
        case 'AW',          geom.AW         = value; % Area of water plane [m^2]
        case 'SC',          geom.SC         = value; % Wet surf area of canoe body [m^2]
        case 'CMS',         geom.CMS        = value; % Midship section coef [-]
        case 'T',           geom.T          = value; % Draft of hull [m]
        case 'TCAN',        geom.TCAN       = value; % Draft of canoe body [m]
        case 'ALT',         geom.ALT        = value; % Total lateral area [m^2]
        case 'KG',          geom.KG         = value; % Center of gravity above keel [m]
        case 'KM',          geom.KM         = value; % Transv metacenter above keel [m]
        case 'DVK',         geom.DVK        = value; % Displ vol of keel [m^3]
        case 'APK',         geom.APK        = value;
        case 'ASK',         geom.ASK        = value; % Area of skeg [m^2]
        case 'SK',          geom.SK         = value; % Wet surf area of keel [m^2]
        case 'ZCBK',        geom.ZCBK       = value;
        case 'CHMEK',       geom.CHMEK      = value; % Mean chord length of keel [m]
        case 'CHRTK',       geom.CHRTK      = value; % Root chord length of keel [m]
        case 'CHTPK',       geom.CHTPK      = value; % Tip chord length of keel [m]
        case 'KEELFF',      geom.KEELFF     = value; % Keel form factor [-]
        case 'DELTTK',      geom.DELTTK     = value; % Thickness ratio of keel [-]
        case 'TAK',         geom.TAK        = value; % Draft @ aft perp of keel [m]
        case 'DVR',         geom.DVR        = value; % Displ vol of rudder [m^3]
        case 'APR',         geom.APR        = value;
        case 'SR',          geom.SR         = value; % Wet surf area of rudder [m^2]
        case 'CHMER',       geom.CHMER      = value; % Mean chord length of rudder [m]
        case 'CHRTR',       geom.CHRTR      = value; % Root chord length of rudder [m]
        case 'CHTPR',       geom.CHTPR      = value; % Tip chord length of rudder [m]
        case 'DELTTR',      geom.DELTTR     = value; % Thickness ratio of rudder [-]
        case 'RUDDFF',      geom.RUDDFF     = value; % Rudder form factor [-]
        case 'SAILSET',     geom.SAILSET    = value; % 3=main+jib; 5=main+spin; 7=main+jib+spin
        case 'P',           geom.P          = value; % Mainsail height [m]
        case 'E',           geom.E          = value; % Mainsail base [m]
        case 'MROACH',	    geom.MROACH     = value; % Correction for mainsail roach [-]
        case 'MFLB',	    geom.MFLB       = value; % Full main battens in main [0/1]
        case 'BAD',         geom.BAD        = value; % Height of main boom above sheer [m]
        case 'I',           geom.I          = value; % Fore-triangle height [m]
        case 'J',           geom.J          = value; % Fore-triangle base [m]
        case 'LPG',         geom.LPG        = value; % Length perpendicular of jib [m]
        case 'SL',          geom.SL         = value; % Spinnaker leech length [m]
        case 'EHM',         geom.EHM        = value; % Mast height above sheer [m]
        case 'EMDC',        geom.EMDC       = value; % Average mast diameter [m]
        case 'MMVBLCRW',    geom.MMVBLCRW   = value; % Mass of moveable crew [kg]
    end
end
fclose(fid);

% vpp.Rconf

fid = fopen('vpp.Rconf');
fseek(fid,0,'eof'); endstatus = ftell(fid); frewind(fid); position = ftell(fid);
while position < endstatus
    position = ftell(fid);
    entry = fscanf(fid,'%s  ',[1 1]); value = fscanf(fid,'%f\n',[1 1]);
    switch entry
        case 'Rvh',     Rconf.Rvh   = value;
        case 'Rrh',     Rconf.Rrh   = value;
        case 'Rvk',     Rconf.Rvk   = value;
        case 'Rvr',     Rconf.Rvr   = value;
        case 'Rrk',     Rconf.Rrk   = value;
        case 'RvhH',    Rconf.RvhH  = value;
        case 'RrhH',    Rconf.RrhH  = value;
        case 'RrkH',    Rconf.RrkH  = value;
        case 'Ri',      Rconf.Ri    = value;
        case 'RrhT',    Rconf.RrhT  = value;
    end
end
fclose(fid);

% vpp.conf

fid = fopen('vpp.conf');
fseek(fid,0,'eof'); endstatus = ftell(fid); frewind(fid); position = ftell(fid);
while position < endstatus
    position = ftell(fid);
    entry = fscanf(fid,'%s  ',[1 1]); value = fscanf(fid,'%f %f\n',[1 2]);
    switch entry
        case 'V',   conf.Vmin   = value(1); conf.Vmax   = value(2);
        case 'phi', conf.phimin = value(1); conf.phimax = value(2);
        case 'b',   conf.bmin   = value(1); conf.bmax   = value(2);
        case 'F',   conf.Fmin   = value(1); conf.Fmax   = value(2);
    end
end
fclose(fid);

% vpp.phys

fid = fopen('vpp.phys');
fseek(fid,0,'eof'); endstatus = ftell(fid); frewind(fid); position = ftell(fid);
while position < endstatus
    position = ftell(fid);
    entry = fscanf(fid,'%s  ',[1 1]); value = fscanf(fid,'%f\n',[1 1]);
    switch entry
        case 'rho_w',   phys.rho_w  = value;
        case 'ni_w',    phys.ni_w   = value;
        case 'rho_a',   phys.rho_a  = value;
        case 'g',       phys.g      = value;
    end
end
fclose(fid);

% vpp.wind

fid = fopen('vpp.wind');
fseek(fid,0,'eof'); endstatus = ftell(fid); frewind(fid); position = ftell(fid);
while position < endstatus
    position = ftell(fid);
    entry = fscanf(fid,'%s  ',[1 1]); value = fscanf(fid,'%f\n',[1 inf]);
    switch entry
        case 'V_tw',
            if      length(value) == 3 && value(2) < value(1),  wind.V_tw = value(1):value(2):value(3);
            else    wind.V_tw = value;
            end
        case 'alfa_tw'
            if      length(value) == 3 && value(2) < value(1),  wind.alfa_tw = value(1):value(2):value(3);
            else    wind.alfa_tw = value;
            end
    end
end
fclose(fid);
