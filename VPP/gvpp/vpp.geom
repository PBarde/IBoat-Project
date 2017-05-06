% this file contains the geometrical description of the sailing boat
% notations follows the ITTC Symbols 2002, when possible
% all data must be provided at zero speed

% These data are measurements and estimates for a Freedom 25

%%%%%% HULL %%%%%%%
DIVCAN  0.0322  %[m^3] Displaced volume of canoe body - ok : calcule et egal au volume sous leau
LWL     1.8  % [m]  Design waterline?s length - ok : clair sur plans
BWL     0.6  % [m]  Design waterlins?s beam - ok estime a partir de la largeur de la cloison cx172
B       0.8  % [m]  Design maximum beam - ok : largeur de la coque car fond plat
AVGFREB 0.247  % [m]  Average freeboard - ok : clair sur plan
XFB     1.042  % [m]  Longitudinal center of buoyancy LCB from fpp - ok : base de la quille
XFF     1.042  % [m]  Longitudinal center of flotation LCF from fpp - ok : base de la quille
CPL     0.5203  % [-]  Longitudinal prismatic coefficient - ok : par calcul basé sur cx1015
HULLFF  1.0    % [-]  Hull form factor - ok : pas change
AW      1.2151  %[m^2] Design waterplane?s area - ok : a partir du volume sous leau divise par la hauteur de la ligne de flottaison sur deux
SC      1.3105  %[m^2] Wetted surface?s area of canoe body - ok : on ajoute la surface laterale
CMS     0.710  % [-]  Midship section coefficient - ok : laisse idem 
T       0.7  % [m]  Total draft - ok : plans
TCAN    0.053  % [m]  Draft of canoe body - ok : plans
ALT     0.6439  %[m^2] Total lateral area of yacht - ok : plans 
KG      0.383  % [m]  Center of gravity above moulded base or keel - ok : plans
KM      0.5  % [m]  Transverse metacentre above moulded base or keel - attention : mis au bol au dessus du centre de gravite
%%%%%%% KEEL %%%%%%%%
DVK     0.0029  %[m^3] Displaced volume of keel : ok 
APK     0.105  %[m^2] Keel?s planform area : ok
ASK     7.4  % [-]  Keel?s aspect ratio:ok
SK      0.23  %[m^2] Keel?s wetted surface ok
ZCBK    0.55  % [m]  Keel?s vertical center of buoyancy (below free surface) ok
CHMEK   0.135  % [m]  Mean chord length ok
CHRTK   0.163  % [m]  Root chord length ok
CHTPK   0.106  % [m]  Tip chord length ok
KEELFF  1      % [-]  Keel's form factor ok
DELTTK  0      % [-]  Mean thickness ratio of keel section ok
TAK     0.605  % [-]  Taper ratio of keel (CHRTK/CHTPK) ok
%%%%%%% RUDDER %%%%%%%
DVR     0.0009      %[m^3] Rudder?s displaced volume ok
APR     0.025  %[m^2] Rudder?s planform area ok
SR      0.05  %[m^2] Rudder?s wetted surface ok
CHMER   0.09  % [m]  Mean chord length ok
CHRTR   0.1087  % [m]  Root chord length ok 
CHTPR   0.0707  % [m]  Tip chord length ok
DELTTR  0      % [m]  Mean thikness ratio of rudder section ok
RUDDFF  1      % [m]  Rudder?s form factor ok
%%%%%%% SAILS %%%%%%%%    PAS OUF CAR VOILE TRES PARTICULIERE 
%sailset - sails used in THIS calculation
% 3 - main & jib; 5 - main & spi; 7 - main, jib, & spinnaker; 
SAILSET 1
P       1.35  % [m]  Mainsail heigth ok 
E       0.64  % [m]  Mainsail base ok
MROACH  1.4925    % [-]  Correction for mainsail roach [-] ok
MFLB	1      % [0/1] Full main battens in main ok
BAD     0.168  % [m]  Boom heigth above deck ok
I       0  % [m]  Foretriangle heigth
J       0  % [m]  Foretriangle base
LPG     0  % [m]  Perpendicular of longest jib
SL      0  % [m]  Spinnaker length
EHM     1.35  % [m]  Mast?s heigth above deck ok 
EMDC    0.06  % [m]  Mast?s avarage diameter ok 
%%%%%%% CREW %%%%%%%%%%
MMVBLCRW 0   % [kg] Movable Crew Mass
