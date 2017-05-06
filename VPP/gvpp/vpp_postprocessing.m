% [] = vpp_postprocessing(x)

function [] = vpp_postprocessing(x)

[wind,geom,phys,Rconf,conf] = vpp_load;

k = 0;
for i = 1:length(wind.V_tw)
    for j = 1:length(wind.alfa_tw)
        
        k = k+1;
        
        V_tw = wind.V_tw(i);
        alfa_tw = wind.alfa_tw(j);

        V   = x(1,i,j);
        phi = x(2,i,j);
        b   = x(3,i,j);
        F   = x(4,i,j);
        
        VMG = V * cos(alfa_tw*pi/180);
        
        if isnan(V)
            
            [Fdrive,Fside,Mheel,Ri,Rrh,RrhH,Rrk,RrkH,Rvh,RvhH,Rvk,Rvr] = ...
                deal(NaN);
            
        else
            
            %aero calculation
            [Fdrive,Fside,Mheel] = vpp_aero(x(:,i,j),geom,phys,V_tw,alfa_tw);
            
            %hydro calculation
            Ri      = vpp_Ri(V,phi,Fside,geom,phys,Rconf.Ri);
            Rrh     = vpp_Rrh(V,geom,phys,Rconf.Rrh);
            RrhH    = vpp_RrhH(V,phi,geom,phys,Rconf.RrhH);
            Rrk     = vpp_Rrk(V,geom,phys,Rconf.Rrk);
            RrkH    = vpp_RrkH(V,phi,geom,phys,Rconf.RrkH);
            Rvh     = vpp_Rvh(V,geom,phys,Rconf.Rvh);
            RvhH    = vpp_RvhH(V,phi,geom,phys,Rconf.RvhH);
            Rvk     = vpp_Rvk(V,geom,phys,Rconf.Rvk);
            Rvr     = vpp_Rvr(V,geom,phys,Rconf.Rvr);
        end
        
        Rtot = Ri + Rrh + RrhH + Rrk + RrkH + Rvh + RvhH + Rvk + Rvr;

        Rall(k,:) = real([Rrh+RrhH Rvh+RvhH Rrk+RrkH Rvk Ri Rvr]);
        Rperc(k,:) = Rall(k,:)./Rtot;
        data(k,:) = real([V_tw alfa_tw V VMG phi b F Fdrive Fside Mheel Rtot Rrh+RrhH Rvh+RvhH Rrk+RrkH Rvk Ri Rvr]);
    end
end

%selecting best VMG
for ii = i:-1:1
    [~,Iup(ii)] = max(data(j*ii-(j-1):j*ii,4));
    [~,Idn(ii)] = min(data(j*ii-(j-1):j*ii,4));
    Iup(ii) = Iup(ii) + j*(ii-1);
    Idn(ii) = Idn(ii) + j*(ii-1);
    tupwind(ii)   =  100./data(Iup(ii)  ,4);
    tdnwind(ii) = -100./data(Idn(ii),4);
    tcourse(ii)   = tupwind(ii) + tdnwind(ii);
    
    V1 = data(Iup(ii),3) + data(Iup(ii),1) .* cos(data(Iup(ii),2)*pi/180);
    V2 = data(Iup(ii),1) .* sin(data(Iup(ii),2)*pi/180) .* cos(data(Iup(ii),5)*pi/180);  
    alfa_eff(Iup(ii)) = atan2(V2,V1)*180/pi;
    
    V1 = data(Idn(ii),3) + data(Idn(ii),1) .* cos(data(Idn(ii),2)*pi/180);
    V2 = data(Idn(ii),1) .* sin(data(Idn(ii),2)*pi/180) .* cos(data(Idn(ii),5)*pi/180);  
    alfa_eff(Idn(ii)) = atan2(V2,V1)*180/pi;
end


%saving data
fid = fopen('results.dat','w');
fprintf(fid,' :::: VPP results :::: \n');
fprintf(fid,'      V_tw   alfa_tw         V       VMG       phi         b         F    Fdrive     Fside     Mheel      Rtot  Rrh+RrhH  Rvh+RvhH  Rrk+RrkH       Rvk        Ri       Rvr\n');
fprintf(fid,'     [m/s]     [deg]     [m/s]     [m/s]     [deg]       [m]       [-]       [N]       [N]      [Nm]       [N]       [N]       [N]       [N]       [N]       [N]       [N]\n');
fprintf(fid,' %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f \n',data');
for ii = 1:i
    fprintf(fid,'\n\n :::: Best VMG :::: \n');
    fprintf(fid,'      V_tw   alfa_tw         V       VMG       phi         b         F    Fdrive     Fside     Mheel      Rtot  Rrh+RrhH  Rvh+RvhH  Rrk+RrkH       Rvk        Ri       Rvr\n');
    fprintf(fid,'     [m/s]     [deg]     [m/s]     [m/s]     [deg]       [m]       [-]       [N]       [N]      [Nm]       [N]       [N]       [N]       [N]       [N]       [N]       [N]\n');
    fprintf(fid,' %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f \n',data(Iup(ii),  :)');
    fprintf(fid,' %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f %9.2f \n',data(Idn(ii),:)');
    fprintf(fid,'\n\n :::: Course Time (100 m) :::: \n');
    fprintf(fid,'     upwind    %.2f [s]\n',tupwind(ii));
    fprintf(fid,'     downwind  %.2f [s]\n',tdnwind(ii));
    fprintf(fid,'     total     %.2f [s]\n',tcourse(ii));
end
fclose(fid);

save data
csvwrite('results.csv',data)

edit results.dat;

%% plotting data
close all
%%
ms2kt = 3600/1852;
n2lbf = 2.2/32.2/.3048;
figure('Name','V vs. alfa_tw')   
for ii = i:-1:1
    plot3(repmat(wind.V_tw(ii),1,j)*ms2kt,data(j*ii-(j-1):j*ii,2),...
        data(j*ii-(j-1):j*ii,3:4)*ms2kt)
    if ii == i
        hold on
    elseif ii == 1
        hold off
    end     
end
grid on
set(gca,'YDir','Reverse')
legend('V','VMG')
xlabel('V_{tw}[kts]')
ylabel('\alpha_{tw}[deg]')
zlabel('kts')
%%
figure('Name','R vs. alfa_tw')  
for ii = i:-1:1
    plot3(repmat(wind.V_tw(ii),1,j)*ms2kt,data(j*ii-(j-1):j*ii,2),...
        cumsum(Rall(j*ii-(j-1):j*ii,:)*n2lbf,2))
    %100*Rperc(j*ii-(j-1):j*ii,:))
    if ii == i
        hold on
    elseif ii == 1
        hold off
    end     
end
grid on
set(gca,'YDir','Reverse')
legend('Hull - residuary','Hull - viscuos','Keel - residuary','Keel - viscous','Induced','Rudder - viscous')
xlabel('V_{tw}[kts]')
ylabel('\alpha_{tw}[deg]')
%zlabel('%')
zlabel('lbf')
%%
figure('Name','F vs. alfa_tw')
for ii = i:-1:1
    plot3(repmat(wind.V_tw(ii),1,j)*ms2kt,data(j*ii-(j-1):j*ii,2),...
        data(j*ii-(j-1):j*ii,8:9)*n2lbf)
    if ii == i
        hold on
    elseif ii == 1
        hold off
    end     
end
grid on
set(gca,'YDir','Reverse')
legend('Fdrive','Fside')
xlabel('V_{tw}[kt]')
ylabel('\alpha_{tw}[deg]')
zlabel('lbf')
%%
figure('Name','Polar')
polar(reshape(data(:,2),j,[])*pi/180,reshape(data(:,3),j,[])*ms2kt)
hold on
polar(reshape(data([Iup Idn],2),i,[])'*pi/180,...
   reshape(data([Iup Idn],3),i,[])'*ms2kt,'*')
hold off
view(90,-90)
% legend(num2str(wind.V_tw'*ms2kt))
% h = legend(char(num2str(wind.V_tw'*ms2kt,'V_{tw} = %2.0f kts'),...
%     num2str([alfa_eff(Iup);alfa_eff(Idn)]','alfa_{eff}=(%3.0f^o,%3.0f^o)')));
% set(h,'position',[0.05 .33 .4 .4])
legend(char(num2str(wind.V_tw'*ms2kt,'V_{tw} = %2.0f kts')),'Location','West')
for ii = 1:i
    [tx,ty] = pol2cart(data(Iup(ii),2)*pi/180,data(Iup(ii),3)*ms2kt);
    text(tx,ty,num2str([alfa_eff(Iup(ii)),data(Iup(ii),3)*ms2kt],'(%3.0f^o,%2.1f kt)'),...
        'VerticalAlignment','Bottom','HorizontalAlign','Left','Fontsize',6)
    [tx,ty] = pol2cart(data(Idn(ii),2)*pi/180,data(Idn(ii),3)*ms2kt);
    text(tx,ty,num2str([alfa_eff(Idn(ii)),data(Idn(ii),3)*ms2kt],'(%3.0f^o,%2.1f kt)'),...
        'VerticalAlignment','Top','HorizontalAlign','Left','Fontsize',6)
end
figure(5)
for ii = i:-1:1
    subplot(3,1,4-ii)
    aii = data(j*ii-(j-1):j*ii,2);
    vii = data(j*ii-(j-1):j*ii,3);
    Rii = Rall(j*ii-(j-1):j*ii,:)*n2lbf;
    nn = ~isnan(vii);
    h = area(aii(nn),Rii(nn,:));
    set(h,'linestyle','none')
    if ii == 1
        xlabel('\alpha_{tw}[deg]')
    end
    if ii == 1
        legend('Hull - residuary','Hull - viscuos','Keel - residuary','Keel - viscous','Induced','Rudder - viscous')
    end
    title(['V_{tw} = ', num2str(wind.V_tw(ii)*ms2kt), ' kts'])
    ylabel('lbf')
end
figure(6)
sailcoefplot
