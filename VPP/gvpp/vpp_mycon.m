% [c,ceq] = mycon(X)

function [c,ceq] = vpp_mycon(X,V_tw,alfa_tw,geom,phys,Rconf)

[Fdrive,Fside,Mheel] = vpp_aero(X,geom,phys,V_tw,alfa_tw);
[Rtot,Mright] = vpp_hydro(X,Fside,geom,phys,Rconf);

%if Mheel == 0; Mheel = 1e-12; end %this is to avoid that deltaM becomes inf if Mheel is equal to 0

deltaF = (Fdrive - Rtot);%./ Rtot;
deltaM = (Mheel  - Mright);%./ Mheel;

c = [];

ceq = [deltaF
    deltaM] ;

% Uncomment the following lines if you want a graphic representation of the variables. 
%subplot(1,2,1), plot([1 2 3 4],[X(1) X(2) X(3) X(4)],'*'), axis ([0 5 -50 50]), drawnow
%subplot(1,2,2), plot([1 2 3 4 5 6],[deltaF*5000 deltaM*5000 Fdrive Rtot Mheel Mright],'*'), axis([0 7 -10000 10000]), drawnow

%subplot(1,2,1), plot([1 2] , [deltaF deltaM],'*'),  axis([  0  3   0  1]),  drawnow
%subplot(1,2,2), plot(X(1),X(2),'*'),                axis([-10 10 -80 80]),  drawnow
