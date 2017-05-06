clear all
close all
%% Import results
filename = './resultsPolaire.dat';
importResults
%% Restructuration of results

n_data=length(alfa_tw);
n_alfa = alfa_tw(end)-alfa_tw(1)+1;
n_Vw = (V_tw(end)-V_tw(1))/0.5+1;
alfaMat=zeros(n_alfa,n_Vw);
VwMat=alfaMat;
phiMat=alfaMat;
VMat=alfaMat;
i=1;
j=1;
for l=1:n_data
    modu=mod(l,n_alfa);
    if modu==0 
        modu=n_alfa;
    end
alfaMat(modu,ceil(l/n_alfa))=alfa_tw(l);
VwMat(modu,ceil(l/n_alfa))=V_tw(l);
phiMat(modu,ceil(l/n_alfa))=phi(l);
VMat(modu,ceil(l/n_alfa))=V(l);
end
%% Ploting the polar
legends=cell(1,n_Vw); 
for ii=1:n_Vw
legends{ii}=['V_tw = ', num2str(VwMat(1,ii)),' m/s'];
end 
figure
polar(alfaMat*pi/180,VMat)
legend(legends)
view(90,-90)
grid on

figure 
surf(alfaMat,VwMat,VMat)
hold on 
%% Fitting the surface 
[alfaS,VwS,VS]=prepareSurfaceData(alfaMat, VwMat, VMat);
fs1 = fit([alfaS,VwS],VS,'cubicinterp');
fs2 = fit([alfaS,VwS],VS,'poly55');

figure
plot(fs1,[alfaS,VwS],VS)

figure
plot(fs2,[alfaS,VwS],VS)

err_poly=norm(fs2(alfaS,VwS)-VS)/norm(VS)
err_interp=norm(fs1(alfaS,VwS)-VS)/norm(VS)
