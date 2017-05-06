function []=vpp_geomtest(geom)

if geom.LWL/geom.BWL  <= 2.73 | geom.LWL/geom.BWL >=  5.00,                    Warning('LWL/BWL  is out of valuable interval'),          pause, end
if geom.BWL/geom.TCAN <= 2.46 | geom.LWL/geom.BWL >= 19.38,                    Warning('BWL/TCAN is out of valuable interval'),          pause, end
if geom.LWL/geom.DIVCAN^(1/3) <= 4.34 | geom.LWL/geom.DIVCAN^(1/3) >= 8.50,    Warning('LWL/DIVCAN^(1/3) is out of valuable interval'),  pause, end
%if geom.XFB < 0 
%if geom.XFF
if geom.CPL <= 0.52 | geom.CPL >= 0.6,                                         Warning('CPL is out of valuable interval'),               pause, end
if geom.CMS <= 0.65 | geom.CMS >= 0.78,                                        Warning('CMS is out of valuable interval'),               pause, end
if geom.AW/geom.DIVCAN^(2/3) <= 3.78 | geom.AW/geom.DIVCAN^(2/3) >= 12.67      Warning('Loading Factor is out of valuable data'),        pause, end