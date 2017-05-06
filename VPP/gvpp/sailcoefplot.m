%%
LE_Cl = [
    0  0      0   0
    27  1.725  1.5 0
    50  1.5  0.5 1.5
    80  0.95 0.3 1.0
    100 0.85 0.0 0.85
    180 0    0   0];
LE_Cdp = [
    0   0    0    0
    27  0.02 0.02 0
    50  0.15 0.25 0.25
    80  0.8  0.15 0.9
    100 1.0  0.0  1.2
    180 0.9  0.0  0.66];

alfa_eff = linspace(0,180);

Cl_M = pchip(LE_Cl(:,1),LE_Cl(:,2),alfa_eff);
Cl_J = pchip(LE_Cl(:,1),LE_Cl(:,3),alfa_eff);
Cl_S = pchip(LE_Cl(:,1),LE_Cl(:,4),alfa_eff);

Cdp_M = pchip(LE_Cdp(:,1),LE_Cdp(:,2),alfa_eff);
Cdp_J = pchip(LE_Cdp(:,1),LE_Cdp(:,3),alfa_eff);
Cdp_S = pchip(LE_Cdp(:,1),LE_Cdp(:,4),alfa_eff);

subplot(2,1,1)
plot(alfa_eff,[Cl_M;Cl_J;Cl_S])
legend('Main','Jib','Spin')
ylabel('C_L')
subplot(2,1,2)
plot(alfa_eff,[Cdp_M;Cdp_J;Cdp_S])
ylabel('C_D')
xlabel('\alpha_{eff}')