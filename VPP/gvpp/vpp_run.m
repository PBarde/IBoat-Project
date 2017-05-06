% [V_tw,alfa_tw,x] = vpp(V_tw,alfa_tw)
%
% [x] = [ V phi b f ]

function [V_tw,alfa_tw,x] = vpp_run
clc
%loading data
[wind,geom,phys,Rconf,conf] = vpp_load;

V_tw = wind.V_tw;
alfa_tw = wind.alfa_tw;

%testing data
vpp_geomtest(geom)

%starting guess
V_hs = 1.25*sqrt(geom.LWL); % 1.25 is hull speed coeff for m/s

%fmincon constrains
A = []; b = []; Aeq = []; beq = [];

lb = [conf.Vmin conf.phimin conf.bmin conf.Fmin];
ub = [conf.Vmax conf.phimax conf.bmax conf.Fmax];

%fmincon options
%options = optimset('FunValCheck','on','Diagnostics','on','Display','iter','DiffMinChange',1e-6,'MaxFunEvals',10000);
%options = optimset('DiffMinChange',1e-12,'LargeScale','off');
options = optimset('UseParallel','always','Algorithm','sqp');%,'active-set');
options = optimset(options,'Display','notify-detailed');
%options = optimset(options,'MaxFunEvals',1000);
%options = optimset(options,'TolCon',1e-1);

%solving the problem
tic
for i = length(V_tw):-1:1
    if V_tw(i) > V_hs,
        x0 = [V_hs; 0; 0; 1];
    else
        x0 = [V_tw(i); 0; 0; 1];
    end
    for j = length(alfa_tw):-1:1
        [x(:,i,j),fval(i,j),exitflag(i,j)] = fmincon(...
            @(X)vpp_myfun(X),x0,A,b,Aeq,beq,lb,ub,...
            @(X)vpp_mycon(X,V_tw(i),alfa_tw(j),geom,phys,Rconf),options);
        if exitflag(i,j) > 0, 
            x0 = x(:,i,j);
        else
            % No feasible solution
            x(:,i,j) = NaN(size(x(:,i,j)));
        end
    end
end
toc
save results x fval exitflag;

vpp_postprocessing(x);
