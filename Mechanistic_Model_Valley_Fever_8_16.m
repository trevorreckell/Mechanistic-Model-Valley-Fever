%% Mechanistic Models of Valley Fever
% This script outlines various models that are too be applied to Valley
% Fever (Coccidioidomycosis). Each successive model adds in new elements to
% better understand the dynamics of the disease
% Model 0 -[Sec:0] Population model

% Model 1 -[Sec:1] Ultra Simple Fungal Growth Model 

% Model 2 -[Sec:2] Simple Fungal Growth Model dependent on Food 

% Model 3 -[Sec:3] Vector and Fungal Model dependent on Food and Environment 

% Model 4 -[Sec:4] Human, Vector and Fungal Model dependent on Food and Environment 

% Model 4 -[Sec:5] Iterative fitting of model 4

% Model 4 -[Sec:6] simplified version of model 4

% Model 5 -[Sec:7]  Human, Vector and Fungal Model dependent on Food and Environment  
% more mechanistic using structure of model 4 simplified

% Model 6 -  Human, Vector and Fungal Model dependent on Food and Environment with 
% spreading across patches

% Plotting fittings -[Sec:9]  plotting fittings of models for each region

%SELECT THE MODEL YOU INTEND TO RUN
choose_model=3;

%IF DOING A SINGLE RUN PUT 1, IF DOING A FITTING PUT 2, Forecasting put 3
single_run_or_fitting=2;
% 
% 
% y_inf_data=y_inf_data_Maricopa;
% 
% 
% alpha_h_maricopa= 0.000035386745035+0.049996054144265;
% omega_maricopa= 0.049996054144265;
% 
% alpha_h_pinal= 0.000054197479825+0.049562154054803; %*use looser bounds
% omega_pinal= 0.049562154054803; %*use looser bounds
% 
% alpha_h_pima= 0.000010637066754+0.050079359342677;
% omega_pima= 0.050079359342677;
% 
% alpha_h_AZ= 0.002876562772732+0.058375000164113;
% omega_AZ= 0.058375000164113;
% %Initial Conditions
% ic_O=40;
% ic_D=70;
% ic_H=100;%
% ic_A=50;%100
% ic_C=10;
% ic_I=y_inf_data(1)/1;
% ic_E=ic_I*1.5;%y_inf_data(1);
% ic_R=ic_I/2;
% ic_S=(y_pop_data(1)-ic_I-ic_E-ic_R);
% y0_1=[ic_D;ic_H;ic_S;ic_I;ic_R];
% y0_2=[ic_O;ic_D;ic_H;ic_A;ic_C;ic_S;ic_E;ic_I;ic_R];
% y0_3=[ic_O;ic_D;ic_H;ic_A;ic_C;ic_S;ic_E;ic_I;ic_R];
% ic_V=5000;
% ic_O=40;
% ic_D=70;
% ic_H=100;%
% ic_A=50;%100
% ic_C=10;
% ic_I=y_inf_data(1)/1;
% ic_E=ic_I/2;%y_inf_data(1);
% ic_R=ic_I/2;
% ic_S=(y_pop_data(1)-ic_I-ic_E-ic_R);
% y0_4=[ic_V;ic_O;ic_D;ic_H;ic_A;ic_C;ic_S;ic_E;ic_I;ic_R];
% 
% params_m1pswarm_Maricopa=[10.398835685380881; 0.000000100000000; 0.000000100000000; 370.344034993766343;...
%     0.000235549206439; 0.050031440889300; 0.000000000000000; 0.000000023008496; 0.049996059143727;...
%     0.003154029486167; 0.000000027768000; 0.000000027768000];
% [t, ypswarm_m1_Mar] = ode15s(@(t, y) M1_SF_T(t, y, params_m1pswarm_Maricopa), t_inf_data, y0_1);
% err_pswarm_m1_Maricopa = (rmse(ypswarm_m1_Mar(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
% 
% 
% params_m2pswarm_Maricopa=[10.0422771941711; 0.498694650020813; 1e-07; 1e-08; 251.693077370578; 1e-06; 0.0140932827253313;...
%     0.0543238809453377; 1e-10; 0.000420421938608973; 0.0500314408893; 1.22234840424577e-06; 0.0499960591438704;...
%     0.0539005151267871; 0.000359; 0.0166666666666667];
% [t, ypswarm_m2_Mar] = ode15s(@(t, y) M2_SF(t, y, params_m2pswarm_Maricopa), t_inf_data, y0_2);
% err_pswarm_m2_Maricopa = (rmse(ypswarm_m2_Mar(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
% 
% params_m3pswarm_Maricopa=[1000; 0.1945561100332; 0.1; 0.0088109715500486; 328.400733100386; 0.0146664577603797;...
%     0.00925296790976682; 0.00188911310023338; 1e-08; 1e-07; 70.1928311610478; 90; 11.7815475109342; 7; 63.8091936150225;...
%     333.491813715222; 30; 579.076935447301; 100; 12.1047035027643; 5.08577518979687; 1; 4.44203800161786; 0.0500314408893;...
%     2.29938769844477e-07; 0.049996014923555; 0.0175208447272361; 0.000359; 0.0357142857142857; 31; 4.43818349092801; 0.1; 0;...
%     5.57149614193524e-05; 0.0999644523082336; 0.0714285714285714; 0.000191325147250823; 0.135739418597056];
% 
% % params_m3pswarm_Maricopa=[118.12883041045; 0.3; 1e-06; 0.00227049827601987; 296.697270119107; 0.08; 0.00398549600914066;...
% %     0.00245896552226033; 4.91265554155143e-05; 6.8987741387213e-05; 83.9786413968147; 87.7803579350254; 12.9999399407838;...
% %     7.82764007485932; 64.8298725860338; 398.933555376063; 88.9636262907421; 700; 99.6294244183083; 5.73427325017808;...
% %     6.78389716328693; 1.41196160851437; 7; 0.0500314408893; 2.25677852009263e-07; 0.0499960065953919; 0.00273972602739726;...
% %     0.000358746631563014; 0.0357203806230862; 31; 7.1966260681596; 0.1; 0; 5.30384182808193e-05; 0.0999645685568934;...
% %     0.00273972602739726; 2.26742981462613e-05 ;0.0891169992220687];
%  options = odeset('RelTol', 1e-1,'AbsTol', 1e-2);, ...
%                 % 'MaxStep', 0.5, ...
%                 % 'InitialStep', 1e-6);
% [t, ypswarm_m3_Mar] = ode15s(@(t, y) M3_SF(t, y, params_m3pswarm_Maricopa), t_inf_data, y0_3,options);
% % [numRowsM,numCols] =size(ypswarm_m3_Mar);
% %         ycomp=y_inf_data(1:numRowsM,:);
% %         error_pswarm_m3_Maricopa = max((rmse(ypswarm_m3_Mar(:,8),  ycomp)/sqrt(sumsqr( ycomp'))));
%  err_pswarm_m3_Maricopa = (rmse(ypswarm_m3_Mar(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
% 
%  params_m4pswarm_Maricopa=[0.014964628356240; 0.045876847010734; 0.005387792143370; 252.733543234581219; 0.006462605655229;...
%      0.008817176561336; 0.003100671042591; 0.000000174286152; 0.000000221461174; 79.990177233561297; 88.646152658522098;...
%      12.997223474560007; 7.007980069995158; 64.991005593714064; 680.267735378204179; 30.000000000000000; 200.000000000000000;...
%      99.984958044777869; 2.102946856281385; 6.921855980804210; 3.931056760970143; 7.000000000000000; 84.779404769611958;...
%      0.000100000000000; 0.000172446262367; 0.000000000010000; 71.637654691850656; 0.000001142393013; 7.315955895972640;...
%      31.000000000000000; 10.000000000000000; 0.100000000000000; 0.000000000000000; 0.000000779510491; 0.099964447873567;...
%      0.002739726027397; 0.000004355767986; 0.035714285714286];
% [t, ypswarm_m4_Mar] = ode15s(@(t, y) M4_SF_S(t, y, params_m4pswarm_Maricopa), t_inf_data, y0_4);
%  err_pswarm_m4_Maricopa = (rmse(ypswarm_m4_Mar(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;

%  params_m5pswarm_Maricopa=
% [t, ypswarm_m5_Mar] = ode15s(@(t, y) M5_SF(t, y, params_m5pswarm_Maricopa), t_inf_data, y0_5);
%  err_pswarm_m5_Maricopa = (rmse(ypswarm(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;

%  county_M3=["Maricopa"];
% figure
% scatter(t_inf_data,y_inf_data, 'k','LineWidth',1)
% hold on
% plot(t,ypswarm_m1_Mar(:,4),'c','LineWidth',4.5)
% plot(t,ypswarm_m2_Mar(:,8),'r','LineWidth',3.5)
% plot(t,ypswarm_m3_Mar(:,8),'color',[0 0.5 0],'LineWidth',2.5)
% plot(t,ypswarm_m4_Mar(:,9),'b','LineWidth',1.5)
% %plot(t,ypswarm_m5_Mar(:,7),'c','LineWidth',2.5)
% legend('Maricopa Infected','Model 1 fit','Model 2 fit','Model 3 fit','Model 4 fit','Location','best');
% title("Model Comparison "+county_M3, 'FontSize', 22)
% xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
% xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
% subtitle("Model 1 RRMSE="+err_pswarm_m1_Maricopa+", Model 2 RRMSE="+err_pswarm_m2_Maricopa+...
%     ", Model 3 RRMSE="+err_pswarm_m3_Maricopa+", Model 4 RRMSE="+err_pswarm_m4_Maricopa, 'FontSize', 14)
% %subtitle("Infected Fmin M2 RRMSE="+err_fmin_m3+", Infected Pswarm M2 RRMSE="+err_pswarm_m3, 'FontSize', 14)
% xlabel('Year', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
% hold off

if choose_model==0
%% Model 0 - Population Model
% Function for Model 0 the population model used in all other models
%Population Model :used in all other models

if single_run_or_fitting==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %SINGLE RUN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 0 single parameter run')
% Define the initial condition and time span
    y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];

    y_pop_data_Pinal=[394200;425264;484239;513862];

    y_pop_data_Pima=[1024000;1043433;1063162;1080149];

    y_pop_data_AZ=[6849647;7151502;7431344;7582384];


    t_pop_data=[1006-1006,3653-1006,4839-1006,5205-1006];
    y_pop_data=y_pop_data_Pima;
    y0 = y_pop_data(1);
    tspan = t_pop_data;
alpha=0.00001;
omega=0.09;

params=[alpha;omega];

[t, yp] = ode23s(@(t, Y) pop_fit(t, Y, params),t_pop_data, y0);
g_poprrmse=(rmse(yp , y_pop_data)/sqrt(sumsqr(y_pop_data')))*100
figure
scatter(t_pop_data,y_pop_data, 'b','LineWidth',2)
hold on
plot(t,yp,'k','LineWidth',2)
legend('True','guess','Location','best');
title("Human growth Model", 'FontSize', 24)
subtitle("FMin RRMSE="+g_poprrmse, 'FontSize', 14)
%xticks([0,365,365*2,365*3])%,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
ylim([min(y_pop_data)-1000 max(y_pop_data)+1000])
hold off

elseif single_run_or_fitting==2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %FITTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 0 fitting')
%loaded data for fitting (if applicable)
%data for fitting Pop model
    
    % Define the initial condition and time span
    y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];

    y_pop_data_Pinal=[394200;425264;484239;513862];

    y_pop_data_Pima=[1024000;1043433;1063162;1080149];

    y_pop_data_AZ=[6849647;7151502;7431344;7582384];


    t_pop_data=[1006-1006,3653-1006,4839-1006,5205-1006];
    y_pop_data=y_pop_data_Maricopa;
    y0 = y_pop_data(1);
    tspan = t_pop_data;  % Time points for ODE solution

    % Optimization options
    %options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
    options = optimset('Algorithm','interior-point','TolX',1e-20,'TolFun',1e-20,'TolCon'...
    ,1e-20,'MaxIter',200000,'MaxFunEvals',100000);
    % Set bounds for p (e.g., must be positive)
     % Alpha_h            % Omega         % Alpha_h             % Omega
    LB(1) = 0;      LB(2) = 0;    % LB(1) = 0.011;       LB(2) = 0.0075;        
    UB(1) = 0.01;            UB(2) = 0.1;    %UB(1) = 0.15;     UB(2) = 0.1;

    % Initial guess for parameter p
    p0 = [UB'];
    %p0 = [LB(1);LB(2);UB(3)];

    % Run optimization
    disp('fmincon')
    p_opt = fmincon(@(p) objective_functionM0(p, tspan, y0, y_pop_data), p0, [], [], [], [], LB, UB, [], options);
    params_Fmin=p_opt 
    disp('pswarm')
     options = optimoptions('particleswarm', ...
    'SwarmSize', 1000, ......
    'MaxIterations', 1000, ...
    'InertiaRange', [0.3, 1.2], ...
    'SelfAdjustmentWeight', 1.5, ...
    'SocialAdjustmentWeight', 2.0, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-10, ...
    'Display', 'iter');

     options = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'SwarmSize', 5000, ... % 'SwarmSize', numWorkers*8, ...
    'MaxIterations', 1000, ...
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.7, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-20, ...
    'Display', 'iter');
    p_opt_psw= particleswarm(@(p) objective_functionM0(p, tspan, y0, y_pop_data),length(LB),LB,UB,options);
    % Display optimized parameters
    %fprintf('Optimized alpha_h: %.8f, omega: %.8f\n, N_max: %.8f\n', p_opt(1), p_opt(2),p_opt(3));
    fprintf('Optimized alpha_h: %.15f, omega: %.15f\n', p_opt(1), p_opt(2));
 
p_opt_psw
 %params_M_pswarm_large=[0.450004027248630;0.449968571859412];
 
%p_opt_psw_small=[0.0000354564009408334   0.0000000010000000000]
%0.0001   0.000064544
y0 = y_pop_data(1);

[t, yfmincon] = ode23s(@(t, Y) pop_fit(t, Y, params_Fmin),t_pop_data, y0);
[t, ypswarm] = ode23s(@(t, Y) pop_fit(t, Y, p_opt_psw),t_pop_data, y0);
fmincon_poprmse=rmse(y_pop_data,yfmincon);
fmincon_poprrmse=(rmse(yfmincon , y_pop_data)/sqrt(sumsqr(y_pop_data')))*100
fpswarm_poprmse=rmse(y_pop_data,ypswarm);
fpswarm_poprrmse=(rmse(ypswarm , y_pop_data)/sqrt(sumsqr(y_pop_data')))*100


[t, yf] = ode23s(@(t, Y) pop_fit(t, Y, params_Fmin),t_pop_data, y0);
[t, yp] = ode23s(@(t, Y) pop_fit(t, Y, p_opt_psw),t_pop_data, y0);
figure
scatter(t_pop_data,y_pop_data, 'b','LineWidth',2)
hold on
plot(t,yf,'c','LineWidth',3)
plot(t,yp,'k','LineWidth',2)
legend('True','predicted f','predicted ps','Location','best');
title("Human growth Model", 'FontSize', 24)
subtitle("FMin RRMSE="+fmincon_poprrmse+", PSwarm="+fpswarm_poprrmse, 'FontSize', 14)
%xticks([0,365,365*2,365*3])%,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
ylim([min(y_pop_data)-1000 max(y_pop_data)+1000])
hold off


global alpha_h_maricopa omega_maricopa alpha_h_pinal omega_pinal alpha_h_pima omega_pima alpha_h_AZ omega_AZ
alpha_h_maricopa= 0.000035386745035+0.049996054144265;
omega_maricopa= 0.049996054144265;

alpha_h_pinal= 0.000054197479825+0.049562154054803; %*use looser bounds
omega_pinal= 0.049562154054803; %*use looser bounds

alpha_h_pima= 0.000010637066754+0.050079359342677;
omega_pima= 0.050079359342677;

alpha_h_AZ= 0.002876562772732+0.058375000164113;
omega_AZ= 0.058375000164113;
end













elseif choose_model==1
%% Model 1 - Simple Fungal Growth Model dependent on Food
% Function for Model 1 and and of section
% what percentage of fungal body is arthroconidia compared to mycelium in
% peak arthroconidia growth conditions?

if single_run_or_fitting==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %SINGLE RUN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 1 single parameter run')
%Initial Conditions
ic_D=10;
ic_H=10;
ic_I=5;
ic_S=10000;
ic_R=1;
y0 = [ic_D;ic_H;ic_S;ic_I;ic_R];

%parameter values%0.13439455934;gamma_h,  1.02307436898;O
O=10;           delta_O=0.12610676729*1;    mu_H=0.40051211092*1;       
gamma_H=0.53439455934*1;    H_max=100006.97596747541*10;  
delta_H=0.5476287413*1;    alpha_h=0.1;    delta_R=0.02;    epsilon=0.3;    omega=0.0999;  
rho=0.001;        kappa=0.001;
m1_paramlist=[O;delta_O;mu_H;gamma_H;H_max;delta_H;alpha_h;delta_R;epsilon;...
    omega;rho;kappa];
%m1_paramlist=[999.99936900;0.89569197;0.07582730;0.99887148;3297852.415833710;...
 %   0.31571905;0.45000403;0.00000005;0.000000005;0.44979571;0.00381912; 0.00803077];

%ode run
[t, y] = ode78(@M1_SF_T,[0 365*10],y0,[],m1_paramlist);

%plotting results
figure
plot(t,y(:,1),'c','LineWidth',2)
hold on
plot(t,y(:,2),'k','LineWidth',2)
legend('Decayed Organic Matter','Hyphae','Location','best');
title("Valley Fever Model 1 - Simple Fungal Growth Model", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); %ylabel('Infected Humans', 'FontSize', 18)
hold off

figure
plot(t,y(:,3),'r','LineWidth',2)
hold on
plot(t,y(:,4),'g','LineWidth',2)
plot(t,y(:,5),'b','LineWidth',2)
legend('Susceptible','Infected','Recovered','Location','best');
title("Valley Fever Model 1 - Simple Fungal Growth Model", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); ylabel('Humans', 'FontSize', 18)
hold off

elseif single_run_or_fitting==2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FITTING Model 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 1 fitting')
%TEST
%  O=10; delta_O=0.000000004; mu_H=0.07;
% gamma_H=0.00009; H_max=1000000; delta_H=0.0000000001;
% C=1;
% 
% ic_D=20;
% ic_H=10;
%  y0_T=[ic_D;ic_H];
%  params_T=[O; delta_O; mu_H; gamma_H; H_max; delta_H; C];
%  [t_T,y_T]=ode78(@M1_SF_T,[0 365*3],y0_T,[],params_T);
% figure
% plot(t_T,y_T(:,1), 'b','LineWidth',2)
% hold on
% plot(t_T,y_T(:,2),'c','LineWidth',2)
% legend('Decomposed Organic Matter','Hyphae Structure','Location','best');
% title("Model 1 - Simple Fungal Growth Model dependent on Food", 'FontSize', 24)
% xticks([0,365,365*2,365*3])%,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
% hold off

%import/load infected valley fever data
y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
    y_pop_data_Pinal=[394200;425264;484239;513862];
    y_pop_data_Pima=[1024000;1043433;1063162;1080149];
    y_pop_data_AZ=[6849647;7151502;7431344;7582384];
    t_pop_data=[1006-1006,3653-1006,4839-1006,5205-1006];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data_Pinal=[53.74285714;48.85714286;36.28571429;15.42857143;17.71428571;...
    34.14285714;33.57142857;30.57142857;35.42857143;25.42857143;34.14285714;...
    41.42857143;61;38.85714286;35.14285714;54.85714286;43.71428571;57.42857143;...
    40.14285714;27.42857143;33.42857143;28.14285714;22.28571429;30;33.57142857;...
    37;32;37.57142857;48.28571429;42.14285714;48.71428571;60.42857143;...
    68.71428571;71.28571429;78.85714286;73.14285714;56.85714286;47.85714286;...
    42.14285714;42.14285714;57.85714286;32.71428571;28.42857143;50.85714286;...
    30.71428571;26.42857143;42.71428571;47.85714286;49.28571429;47.42857143;...
    24.57142857;42;36.57142857;39.28571429;33.57142857;33.85714286;46.71428571;...
    26;46.85714286;64.71428571;85.42857143;65.57142857;34.85714286;36.57142857;...
    47.42857143;56.57142857;43;52.85714286;37.57142857;32;51.85714286;42.14285714;...
    63.57142857;52.14285714;57.57142857;66.57142857;56.71428571;75.71428571;...
    77.71428571;81.57142857;80;65.28571429;91.85714286;121.8571429;118;...
    83.28571429;71.71428571;36.28571429;45.85714286;71.42857143;77.57142857;...
    87.85714286;99.85714286;118;112.1428571;121.7142857;162.2857143;117.1428571;...
    99;105.8571429;76.57142857;62.57142857;58.14285714;73.71428571;62.42857143;...
    61.28571429;65.85714286;78.57142857;133.8571429;99.85714286;66.42857143;74;...
    69.71428571;79.28571429;73.85714286;95.28571429;49.28571429;50.85714286;...
    50.71428571;61.14285714;70.57142857;56.57142857;49;62.57142857;49.71428571;...
    57.57142857;59.57142857;100.5714286;93.85714286;77.57142857;106.4285714;...
    131.4285714;141.1428571];

y_inf_data_Pima=[128.0714286;116.4285714;70.57142857;42.28571429;62.57142857;...
    71.71428571;88.28571429;71.28571429;88.85714286;72.28571429;80.28571429;...
    106.4285714;137;82.28571429;91.85714286;77.28571429;81.57142857;82;80.42857143;...
    46.57142857;62;52.28571429;61;57.14285714;58.57142857;96;66;58.57142857;...
    71.28571429;75;148.1428571;115.7142857;112.8571429;146.2857143;114.1428571;...
    109.1428571;86.85714286;80.28571429;64.71428571;79.42857143;73.57142857;...
    79.57142857;73.28571429;75.85714286;55.71428571;68.14285714;60.71428571;...
    90;95.71428571;83.85714286;64.14285714;74.28571429;87.42857143;67;63.85714286;...
    105.4285714;75.85714286;58.14285714;82.42857143;128.5714286;146;90.42857143;...
    83.85714286;71.71428571;59.42857143;83.28571429;97.28571429;103.2857143;...
    87.71428571;76.28571429;76;75;62.71428571;85.71428571;111.8571429;127.5714286;...
    115.7142857;115.5714286;122;146.5714286;143;100.1428571;118.4285714;123.4285714;...
    131;101;110;92.57142857;82.57142857;102.8571429;122.2857143;125.2857143;...
    164.5714286;143.1428571;127.7142857;162.4285714;165.5714286;138.5714286;...
    138.2857143;140.7142857;88.14285714;110;104.5714286;117.7142857;84.28571429;...
    80.14285714;92.14285714;98.85714286;123.5714286;95.42857143;57.14285714;...
    83.85714286;83.57142857;112.2857143;113.8571429;139.7142857;100.5714286;...
    81.71428571;89.14285714;79;93.71428571;103.4285714;87.57142857;89;87.28571429;...
    100.5714286;104;109.4285714;115.2857143;93.42857143;113.4285714;132;134.5714286];

y_inf_data_AZ=[798.9142857;726.2857143;461.5714286;326;356.4285714;425;431.5714286;...
    431.4285714;463.7142857;401.1428571;489.7142857;682.1428571;696;564.8571429;...
    591.8571429;574;529.2857143;595;505.1428571;319.5714286;347.8571429;352.2857143;...
    325.7142857;338.8571429;435.5714286;410;380;432.5714286;517.4285714;471.7142857;...
    700.1428571;727.7142857;778.7142857;944.5714286;786.1428571;800;684;581.2857143;...
    464.1428571;574.4285714;529.1428571;459;454.8571429;483.2857143;495.4285714;...
    392.4285714;553;590;577;532.1428571;416;408.7142857;457.1428571;442.7142857;...
    417.2857143;522.8571429;522.2857143;444.8571429;643.4285714;953.8571429;...
    1184.714286;898.2857143;584.4285714;564.2857143;552;663;611;689.5714286;...
    609.8571429;538;622.7142857;523.4285714;630.4285714;745.5714286;658;811.4285714;...
    749.7142857;797.7142857;818.2857143;943.2857143;971;798.2857143;902.4285714;...
    1115.285714;1059;930;830;635.2857143;475.7142857;630.5714286;747.1428571;...
    800.2857143;1067.142857;1188.285714;1175.571429;1382.857143;1560.142857;...
    1323.285714;1113.428571;1147.285714;863.1428571;854.4285714;809;814.4285714;...
    810.7142857;736.7142857;842;1009.857143;1223.714286;952.8571429;673.5714286;...
    704.5714286;787;948.1428571;911.2857143;1072.571429;715.7142857;625.8571429;...
    617.1428571;691.2857143;759;704.4285714;615.2857143;773.5714286;702.4285714;...
    750.7142857;706;869.2857143;974.4285714;929.8571429;1126;1335;1417];

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];




alpha_h_maricopa= 0.000035386745035+0.049996054144265;
omega_maricopa= 0.049996054144265;

alpha_h_pinal= 0.000054197479825+0.049562154054803; %*use looser bounds
omega_pinal= 0.049562154054803; %*use looser bounds

alpha_h_pima= 0.000010637066754+0.050079359342677;
omega_pima= 0.050079359342677;

alpha_h_AZ= 0.002876562772732+0.058375000164113;
omega_AZ= 0.058375000164113;

y_pop_data=y_pop_data_Pinal;
y_inf_data=y_inf_data_Pinal;
alpha_h_b=alpha_h_pinal;
omega_b=omega_pinal;

%Initial Conditions
ic_D=70;
ic_H=200;%
ic_I=y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_R);
y0=[ic_D;ic_H;ic_S;ic_I;ic_R];

%parameter values (and constant values if applicable)
% m1_paramlist=[O;delta_O;mu_H;gamma_H;H_max;delta_H;alpha_h;delta_R;epsilon;...
%    omega;rho;kappa];

%O                    %mu_H                     %delta_D
LB(1) = 10;           LB(2) = 0.00000001;      LB(12) = 0.0000001; 
UB(1) = 1000;         UB(2) = 0.09;             UB(12) = 0.05;   

% gamma_h            % H_max                %delta_H
LB(3) = 0.00000001;    LB(4) = 250;       LB(5) = 0.000001;        
UB(3) = 0.01;          UB(4) = 450;         UB(5) = 0.1;

% alpha_h                       % delta_R                %epsilon
LB(6) = alpha_h_b*0.999999;    LB(7) = 0;          LB(8) = 0.000000001;
UB(6) = alpha_h_b*1.0000001;    UB(7) = 0;          UB(8) = 0.00001;

% omega                             % rho                %kappa
LB(9) = omega_b*0.999999;    LB(10) = 1/365;    LB(11) = 0.000000027768;
UB(9) = omega_b*1.0000001;    UB(10) = 1/14;    UB(11) = 0.000359;
  


% % delta_O             %mu_H
% LB(1) = 0.0003;      LB(2) = 0.000001;        
% UB(1) = 0.1;           UB(2) = 0.09;
% 
% % gamma_h            % H_max                %delta_H
% LB(3) = 0.000001;    LB(4) = 250;       LB(5) = 0.000001;        
% UB(3) = 0.01;          UB(4) = 450;   UB(5) = 0.06;
% 
% % alpha_h            % delta_R                %epsilon
% LB(32) = alpha_h_b;    LB(33) = 0;          LB(34) = 0.00000001;
% UB(32) = alpha_h_b;    UB(33) = 0;          UB(34) = 0.0001;
% 
% % omega                             % rho                %kappa
% LB(35) = omega_b*0.999999;    LB(36) = 1/365;    LB(37) = 0.000000027768;
% UB(35) = omega_b*1.000001;    UB(36) = 1/14;    UB(37) = 0.000359;

options = optimset('Algorithm','interior-point','TolX',1e-20,'TolFun',1e-20,'TolCon'...
    ,1e-20,'MaxIter',200000,'MaxFunEvals',100000);

%ODE Run
 % y0=[ic_D;ic_H;ic_S;ic_I;ic_R];
 % params=[PI; delta_O; mu_H; gamma_H; H_max; delta_H; gamma_A; delta_A; phi_A; delta_C];
 % [t,y]=ode23s(@M1_SF,[0 365*10],y0,[],params);

 %FITTING OF MODEL 1
pool = gcp; % Will create a pool if none exists
numWorkers = pool.NumWorkers;
disp(numWorkers);
format long

 tspan=t_inf_data;
% Parameters initial guess 
    p0 = [LB'];
    %p0 = [LB(1);LB(2);UB(3)];

    % Run optimization
   % p_opt = fmincon(@(p) objective_functionM1(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);
% 
%     % Display optimized parameters
%     %fprintf('Optimized alpha_h: %.8f, omega: %.8f\n, N_max: %.8f\n', p_opt(1), p_opt(2),p_opt(3));
%     %fprintf('Optimized alpha_h: %.8f, omega: %.8f\n', p_opt(1), p_opt(2));
% params_m1fmin=p_opt;

options = optimoptions('particleswarm', ...
    'SwarmSize', length(LB)*10, ...
    'MaxIterations', 1000, ...
    'InertiaRange', [0.3, 1.2], ...
    'SelfAdjustmentWeight', 1.5, ...
    'SocialAdjustmentWeight', 2.0, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-10, ...
    'Display', 'iter');

options = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*100, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 120, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-15, ...
    'Display', 'iter');
%p_opt = particleswarm(@(p) objective_functionM1(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);
 [params_m1pswarm, errorOBJ]= particleswarm(@(p) objective_functionM1(p, tspan, y0, y_inf_data),length(LB),LB,UB,options);
 fprintf('params_m1pswarm = [%s%.15f];\n', sprintf('%.15f; ', params_m1pswarm(1:end-1),params_m1pswarm(end)));
[params_m1pswarm_rss, rss]= particleswarm(@(p) objective_functionM1_RSS(p, tspan, y0, y_inf_data),length(LB),LB,UB,options);
soundsc([chirp(0:1/8192:2.5-1/8192, 500, 2.5, 1200), chirp(0:1/8192:2.5-1/8192, 1200, 2.5, 500)], 8192); %noise to alert when done
 fprintf('params_m1pswarm = [%s%.15f];\n', sprintf('%.15f; ', params_m1pswarm(1:end-1),params_m1pswarm(end)),'\n',' ');
fprintf('params_m1pswarm_rss = [%s%.15f];\n', sprintf('%.15f; ', params_m1pswarm_rss(1:end-1),params_m1pswarm_rss(end)),'\n',' ');
num_data_points = numel(y_inf_data);    % n
k = numel(LB);               % k

% Calculate AIC, AICc, BIC (same formulas)
aic = num_data_points * log(rss / num_data_points) + 2 * k;
aicc = aic + (2 * k * (k + 1)) / (num_data_points - k - 1);
bic = num_data_points * log(rss / num_data_points) + k * log(num_data_points);

%Display Results
fprintf('Model 1 Information Criteria Results ---\n');
fprintf('RSS: %.2f\n', rss);
fprintf('AIC: %.2f\n', aic);
fprintf('AICc: %.2f\n', aicc);
fprintf('BIC: %.2f\n', bic);
errorOBJ

[~, yfmin] = ode23s(@M1_SF_T,t_inf_data,y0,[],params_m1fmin);
[t, ypswarm] = ode23s(@M1_SF_T,t_inf_data,y0,[],params_m1pswarm);
err_fmin_m1 = (rmse(yfmin(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
err_pswarm_m1 = (rmse(ypswarm(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
figure
scatter(t_inf_data,y_inf_data, 'b','LineWidth',1)
hold on
plot(t,yfmin(:,4),'c','LineWidth',2.5)
plot(t,ypswarm(:,4),'k','LineWidth',2)
legend('Maricopa Infected','FMin Model 1 fit','Pswarm Model 1 fit','Location','best');
title("Valley Fever Model 1 - Simple Fungal Growth Model - Maricopa County", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
subtitle("Infected Fmin M1 RRMSE="+err_fmin_m1+", Infected Pswarm M1 RRMSE="+err_pswarm_m1, 'FontSize', 14)
xlabel('Year', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
ylim([0,max(y_inf_data)+200])
hold off

if err_fmin_m1<err_pswarm_m1
    y=yfmin;
else
    y=ypswarm;
end

%plotting of results
figure
plot(t,y(:,1), 'b','LineWidth',2)
hold on
plot(t,y(:,2),'c','LineWidth',2)
plot(t,y(:,3), 'r','LineWidth',2);
plot(t,y(:,4),'g','LineWidth',2)
plot(t,y(:,5), 'k','LineWidth',2);
legend('Decomposed Organic Matter','Hyphae Structure','Susceptible','Infected','Recovered','Location','best');
title("Model 1 - Simple Fungal Growth Model dependent on Food", 'FontSize', 24)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
hold off

figure
plot(t,y(:,1), 'b','LineWidth',2)
hold on
plot(t,y(:,2),'c','LineWidth',2)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
hold off


elseif single_run_or_fitting==3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Forecasting Model 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 1 Forecasting')

%import/load infected valley fever data
y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
    y_pop_data_Pinal=[394200;425264;484239;513862];
    y_pop_data_Pima=[1024000;1043433;1063162;1080149];
    y_pop_data_AZ=[6849647;7151502;7431344;7582384];
    t_pop_data=[1006-1006,3653-1006,4839-1006,5205-1006];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data_Pinal=[53.74285714;48.85714286;36.28571429;15.42857143;17.71428571;...
    34.14285714;33.57142857;30.57142857;35.42857143;25.42857143;34.14285714;...
    41.42857143;61;38.85714286;35.14285714;54.85714286;43.71428571;57.42857143;...
    40.14285714;27.42857143;33.42857143;28.14285714;22.28571429;30;33.57142857;...
    37;32;37.57142857;48.28571429;42.14285714;48.71428571;60.42857143;...
    68.71428571;71.28571429;78.85714286;73.14285714;56.85714286;47.85714286;...
    42.14285714;42.14285714;57.85714286;32.71428571;28.42857143;50.85714286;...
    30.71428571;26.42857143;42.71428571;47.85714286;49.28571429;47.42857143;...
    24.57142857;42;36.57142857;39.28571429;33.57142857;33.85714286;46.71428571;...
    26;46.85714286;64.71428571;85.42857143;65.57142857;34.85714286;36.57142857;...
    47.42857143;56.57142857;43;52.85714286;37.57142857;32;51.85714286;42.14285714;...
    63.57142857;52.14285714;57.57142857;66.57142857;56.71428571;75.71428571;...
    77.71428571;81.57142857;80;65.28571429;91.85714286;121.8571429;118;...
    83.28571429;71.71428571;36.28571429;45.85714286;71.42857143;77.57142857;...
    87.85714286;99.85714286;118;112.1428571;121.7142857;162.2857143;117.1428571;...
    99;105.8571429;76.57142857;62.57142857;58.14285714;73.71428571;62.42857143;...
    61.28571429;65.85714286;78.57142857;133.8571429;99.85714286;66.42857143;74;...
    69.71428571;79.28571429;73.85714286;95.28571429;49.28571429;50.85714286;...
    50.71428571;61.14285714;70.57142857;56.57142857;49;62.57142857;49.71428571;...
    57.57142857;59.57142857;100.5714286;93.85714286;77.57142857;106.4285714;...
    131.4285714;141.1428571];

y_inf_data_Pima=[128.0714286;116.4285714;70.57142857;42.28571429;62.57142857;...
    71.71428571;88.28571429;71.28571429;88.85714286;72.28571429;80.28571429;...
    106.4285714;137;82.28571429;91.85714286;77.28571429;81.57142857;82;80.42857143;...
    46.57142857;62;52.28571429;61;57.14285714;58.57142857;96;66;58.57142857;...
    71.28571429;75;148.1428571;115.7142857;112.8571429;146.2857143;114.1428571;...
    109.1428571;86.85714286;80.28571429;64.71428571;79.42857143;73.57142857;...
    79.57142857;73.28571429;75.85714286;55.71428571;68.14285714;60.71428571;...
    90;95.71428571;83.85714286;64.14285714;74.28571429;87.42857143;67;63.85714286;...
    105.4285714;75.85714286;58.14285714;82.42857143;128.5714286;146;90.42857143;...
    83.85714286;71.71428571;59.42857143;83.28571429;97.28571429;103.2857143;...
    87.71428571;76.28571429;76;75;62.71428571;85.71428571;111.8571429;127.5714286;...
    115.7142857;115.5714286;122;146.5714286;143;100.1428571;118.4285714;123.4285714;...
    131;101;110;92.57142857;82.57142857;102.8571429;122.2857143;125.2857143;...
    164.5714286;143.1428571;127.7142857;162.4285714;165.5714286;138.5714286;...
    138.2857143;140.7142857;88.14285714;110;104.5714286;117.7142857;84.28571429;...
    80.14285714;92.14285714;98.85714286;123.5714286;95.42857143;57.14285714;...
    83.85714286;83.57142857;112.2857143;113.8571429;139.7142857;100.5714286;...
    81.71428571;89.14285714;79;93.71428571;103.4285714;87.57142857;89;87.28571429;...
    100.5714286;104;109.4285714;115.2857143;93.42857143;113.4285714;132;134.5714286];

y_inf_data_AZ=[798.9142857;726.2857143;461.5714286;326;356.4285714;425;431.5714286;...
    431.4285714;463.7142857;401.1428571;489.7142857;682.1428571;696;564.8571429;...
    591.8571429;574;529.2857143;595;505.1428571;319.5714286;347.8571429;352.2857143;...
    325.7142857;338.8571429;435.5714286;410;380;432.5714286;517.4285714;471.7142857;...
    700.1428571;727.7142857;778.7142857;944.5714286;786.1428571;800;684;581.2857143;...
    464.1428571;574.4285714;529.1428571;459;454.8571429;483.2857143;495.4285714;...
    392.4285714;553;590;577;532.1428571;416;408.7142857;457.1428571;442.7142857;...
    417.2857143;522.8571429;522.2857143;444.8571429;643.4285714;953.8571429;...
    1184.714286;898.2857143;584.4285714;564.2857143;552;663;611;689.5714286;...
    609.8571429;538;622.7142857;523.4285714;630.4285714;745.5714286;658;811.4285714;...
    749.7142857;797.7142857;818.2857143;943.2857143;971;798.2857143;902.4285714;...
    1115.285714;1059;930;830;635.2857143;475.7142857;630.5714286;747.1428571;...
    800.2857143;1067.142857;1188.285714;1175.571429;1382.857143;1560.142857;...
    1323.285714;1113.428571;1147.285714;863.1428571;854.4285714;809;814.4285714;...
    810.7142857;736.7142857;842;1009.857143;1223.714286;952.8571429;673.5714286;...
    704.5714286;787;948.1428571;911.2857143;1072.571429;715.7142857;625.8571429;...
    617.1428571;691.2857143;759;704.4285714;615.2857143;773.5714286;702.4285714;...
    750.7142857;706;869.2857143;974.4285714;929.8571429;1126;1335;1417];

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];


alpha_h_maricopa= 0.000035386745035+0.049996054144265;
omega_maricopa= 0.049996054144265;

alpha_h_pinal= 0.000054197479825+0.049562154054803; %*use looser bounds
omega_pinal= 0.049562154054803; %*use looser bounds

alpha_h_pima= 0.000010637066754+0.050079359342677;
omega_pima= 0.050079359342677;

alpha_h_AZ= 0.002876562772732+0.058375000164113;
omega_AZ= 0.058375000164113;

y_pop_data=y_pop_data_Pinal;
y_inf_data=y_inf_data_Pinal;
alpha_h_b=alpha_h_pinal;
omega_b=omega_pinal;
county_M1=["Pinal"];
tspan_8_1=t_inf_data(1:97,1);
tspan_8_1_F=t_inf_data(1:109,1);
tspan_8_2=t_inf_data(13:109,1);
tspan_8_2_F=t_inf_data(13:121,1);
tspan_8_3=t_inf_data(25:121,1);
tspan_8_3_F=t_inf_data(25:133,1);
tspan_11_years=t_inf_data;
y_inf_data_8_1=y_inf_data(1:97,1);
y_inf_data_8_2=y_inf_data(13:109,1);
y_inf_data_8_3=y_inf_data(25:121,1);
y_inf_data_8_4=y_inf_data(25:133,1);

%Initial Conditions
ic_D=70;
ic_H=200;%
ic_I=y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_R);
y0=[ic_D;ic_H;ic_S;ic_I;ic_R];

%O                              %mu_H                 
LB(1) = 10;             LB(2) = 0.00000001;       
UB(1) = 1000;                   UB(2) = 0.09;       

% gamma_h            % H_max                %delta_H
LB(3) = 0.00000001;    LB(4) = 250;       LB(5) = 0.000001;        
UB(3) = 0.01;          UB(4) = 450;   UB(5) = 0.1;

% alpha_h            % delta_R                %epsilon
LB(6) = alpha_h_b;    LB(7) = 0;          LB(8) = 0.000000001;
UB(6) = alpha_h_b;    UB(7) = 0;          UB(8) = 0.00001;

% omega                             % rho                %kappa
LB(9) = omega_b*0.999999;    LB(10) = 1/365;    LB(11) = 0.000000027768;
UB(9) = omega_b*1.0000001;    UB(10) = 1/14;    UB(11) = 0.000359;
  

% % delta_O             %mu_H
% LB(1) = 0.0003;      LB(2) = 0.000001;        
% UB(1) = 0.1;           UB(2) = 0.09;
% 
% % gamma_h            % H_max                %delta_H
% LB(3) = 0.000001;    LB(4) = 250;       LB(5) = 0.000001;        
% UB(3) = 0.01;          UB(4) = 450;   UB(5) = 0.06;
% 
% % alpha_h            % delta_R                %epsilon
% LB(32) = alpha_h_b;    LB(33) = 0;          LB(34) = 0.00000001;
% UB(32) = alpha_h_b;    UB(33) = 0;          UB(34) = 0.0001;
% 
% % omega                             % rho                %kappa
% LB(35) = omega_b*0.999999;    LB(36) = 1/365;    LB(37) = 0.000000027768;
% UB(35) = omega_b*1.000001;    UB(36) = 1/14;    UB(37) = 0.000359;

options = optimset('Algorithm','interior-point','TolX',1e-20,'TolFun',1e-20,'TolCon'...
    ,1e-20,'MaxIter',200000,'MaxFunEvals',100000);


 %FITTING OF MODEL 1 first 8 years
pool = gcp; % Will create a pool if none exists
numWorkers = pool.NumWorkers;
disp(numWorkers);
format long


% Parameters initial guess 
    p0 = [LB'];
    %p0 = [LB(1);LB(2);UB(3)];

   % p_opt = fmincon(@(p) objective_functionM1(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);
%     % Display optimized parameters
%     %fprintf('Optimized alpha_h: %.8f, omega: %.8f\n, N_max: %.8f\n', p_opt(1), p_opt(2),p_opt(3));
%     %fprintf('Optimized alpha_h: %.8f, omega: %.8f\n', p_opt(1), p_opt(2));
% params_m1fmin=p_opt;

options = optimoptions('particleswarm', ...
    'SwarmSize', length(LB)*10, ...
    'MaxIterations', 1000, ...
    'InertiaRange', [0.3, 1.2], ...
    'SelfAdjustmentWeight', 1.5, ...
    'SocialAdjustmentWeight', 2.0, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-10, ...
    'Display', 'iter');

options = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*100, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-15, ...
    'Display', 'iter');
%p_opt = particleswarm(@(p) objective_functionM1(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);
[params_m1pswarm_8_1, errorOBJ8_1]= particleswarm(@(p) objective_functionM1(p, tspan_8_1, y0, y_inf_data_8_1),length(LB),LB,UB,options);
[t8_1, ypswarm_fit8_1] = ode23s(@M1_SF_T,tspan_8_1_F,y0,[],params_m1pswarm_8_1);
frst_year_forecast_rrmse=(rmse(ypswarm_fit8_1(98:109,4) , y_inf_data(98:109,1))/sqrt(sumsqr(y_inf_data(98:109,1)')))*100;
 
[params_m1pswarm_8_2, errorOBJ8_2]= particleswarm(@(p) objective_functionM1(p, tspan_8_2, y0, y_inf_data_8_2),length(LB),LB,UB,options);
[t8_2, ypswarm_fit8_2] = ode23s(@M1_SF_T,tspan_8_2_F,y0,[],params_m1pswarm_8_2);
scnd_year_forecast_rrmse=(rmse(ypswarm_fit8_2(98:109,4) , y_inf_data(110:121,1))/sqrt(sumsqr(y_inf_data(110:121,1)')))*100;
%scnd_year_forecast_rrmse=(rmse(ypswarm_fit8_2(110:121,4) , y_inf_data(110:121,1))/sqrt(sumsqr(y_inf_data(110:121,1)')))*100;
size(ypswarm_fit8_2)
[params_m1pswarm_8_3, errorOBJ8_3]= particleswarm(@(p) objective_functionM1(p, tspan_8_3, y0, y_inf_data_8_3),length(LB),LB,UB,options);
[t8_3, ypswarm_fit8_3] = ode23s(@M1_SF_T,tspan_8_3_F,y0,[],params_m1pswarm_8_3);
thrd_year_forecast_rrmse=(rmse(ypswarm_fit8_3(98:109,4) , y_inf_data(122:133,1))/sqrt(sumsqr(y_inf_data(122:133,1)')))*100;
%thrd_year_forecast_rrmse=(rmse(ypswarm_fit_8_3(122:133,4) , y_inf_data(122:133,1))/sqrt(sumsqr(y_inf_data(122:133,1)')))*100;
 size(ypswarm_fit8_3)

fprintf('params_m1pswarm_8_1 = [%s%.15f];\n', sprintf('%.15f; ', params_m1pswarm_8_1(1:end-1),params_m1pswarm_8_1(end)));
fprintf('params_m1pswarm_8_2 = [%s%.15f];\n', sprintf('%.15f; ', params_m1pswarm_8_2(1:end-1),params_m1pswarm_8_2(end)));
fprintf('params_m1pswarm_8_3 = [%s%.15f];\n', sprintf('%.15f; ', params_m1pswarm_8_3(1:end-1),params_m1pswarm_8_3(end)));
frst_year_forecast_rrmse
scnd_year_forecast_rrmse
thrd_year_forecast_rrmse

%Display
figure
scatter(t_inf_data,y_inf_data, 'k','LineWidth',2)
hold on
plot(t8_1(1:97,1),ypswarm_fit8_1(1:97,4), 'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
plot(t8_1(97:109,1),ypswarm_fit8_1(97:109,4), 'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
plot(t8_2(97:109,1),ypswarm_fit8_2(97:109,4), 'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
plot(t8_3(97:109,1),ypswarm_fit8_3(97:109,4),'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
xline(2922, 'k','LineWidth',2)
xline(3287, 'k','LineWidth',2)
xline(3652, 'k','LineWidth',2)
legend(county_M1+' Infected','Model 1 fit first 8 years', '2022 forecast','2023 forecast','2024 forecast','Location','best');
title(county_M1+" Valley Fever Model 1 Forecast ", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
subtitle("Forecasted 2022 RRMSE="+frst_year_forecast_rrmse+"%, Forecasted 2023 RRMSE="+scnd_year_forecast_rrmse...
    +"%, Forecasted 2024 RRMSE="+thrd_year_forecast_rrmse+"%", 'FontSize', 14)
xlabel('Year', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
ylim([0,max(y_inf_data)+200])
hold off
end





































elseif choose_model==2
%% Model 2 - Fungal Growth Model dependent on Foood
% Function for Model 2 and and of section
if single_run_or_fitting==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %SINGLE RUN Model 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 2 single parameter run')
%Initial Conditions
ic_O=100;
ic_D=50;
ic_H=5;
ic_A=5;
ic_C=1;
ic_I=5;
ic_S=1000;
ic_R=5;
ic_E=5;
y0=[ic_O;ic_D;ic_H;ic_A;ic_C;ic_S;ic_E;ic_I;ic_R];

%Parameters
PI=2; delta_O=0.00022610676729*1;    mu_H=0.0090051211092*1;       
gamma_H=0.001439455934*1;    H_max=10006.97596747541*10;  
delta_H=0.029476287413*1;
gamma_A=0.01; delta_A=0.03; phi_A=0.00025;
delta_C=0.0004; alpha_h=0.01;    delta_R=0.00002;    epsilon=0.01;    omega=0.0090;  
rho=0.001;        kappa=0.001; psi=0.02;

 params=[PI; delta_O; mu_H; gamma_H; H_max; delta_H; gamma_A; delta_A; ...
     phi_A; delta_C; alpha_h; delta_R; epsilon; omega; rho; kappa; psi];

 %ode run
[t, y] = ode23s(@M2_SF,[0 365*5],y0,[],params);

 %plotting results
figure
plot(t,y(:,1),'b','LineWidth',2)
hold on
plot(t,y(:,2),'c','LineWidth',2)
legend('Organic Matter','Decayed Organic Matter', 'FontSize', 16,'Location','best');
title("Valley Fever Model 2 - Fungal Growth dependent on Food", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); %ylabel('Infected Humans', 'FontSize', 18)
hold off

figure
plot(t,y(:,3),'r','LineWidth',2)
hold on
plot(t,y(:,4),'g','LineWidth',2)
plot(t,y(:,5),'k','LineWidth',2)
legend('Hyphae','Arthroconidia','Colonies', 'FontSize', 16,'Location','best');
title("Valley Fever Model 2 - Fungal Growth dependent on Food", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); %ylabel('Infected Humans', 'FontSize', 18)
hold off

figure
plot(t,y(:,6),'r','LineWidth',2)
hold on
plot(t,y(:,7),'g','LineWidth',2)
plot(t,y(:,8),'color','[0.9290 0.4940 0.0250]','LineWidth',2)
plot(t,y(:,9),'color','[0.5 0 0.5]','LineWidth',2)
legend('Susceptible','Exposed','Infected','Recovered', 'FontSize', 16,'Location','best');
title("Valley Fever Model 2 - Fungal Growth dependent on Food", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); ylabel('Humans', 'FontSize', 18)
hold off


elseif single_run_or_fitting==2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FITTING Model 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 2 fitting')
%Load population model parameters
global alpha_h_maricopa omega_maricopa alpha_h_pinal omega_pinal alpha_h_pima omega_pima alpha_h_AZ omega_AZ
alpha_h_maricopa= 0.000035386745035+0.049996054144265;
omega_maricopa= 0.049996054144265;

alpha_h_pinal= 0.000054197479825+0.049562154054803; %*use looser bounds
omega_pinal= 0.049562154054803; %*use looser bounds

alpha_h_pima= 0.000010637066754+0.050079359342677;
omega_pima= 0.050079359342677;

alpha_h_AZ= 0.002876562772732+0.058375000164113;
omega_AZ= 0.058375000164113;


%import/load data
y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
y_pop_data_Pinal=[394200;425264;484239;513862];
y_pop_data_Pima=[1024000;1043433;1063162;1080149];
y_pop_data_AZ=[6849647;7151502;7431344;7582384];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data_Pinal=[53.74285714;48.85714286;36.28571429;15.42857143;17.71428571;...
    34.14285714;33.57142857;30.57142857;35.42857143;25.42857143;34.14285714;...
    41.42857143;61;38.85714286;35.14285714;54.85714286;43.71428571;57.42857143;...
    40.14285714;27.42857143;33.42857143;28.14285714;22.28571429;30;33.57142857;...
    37;32;37.57142857;48.28571429;42.14285714;48.71428571;60.42857143;...
    68.71428571;71.28571429;78.85714286;73.14285714;56.85714286;47.85714286;...
    42.14285714;42.14285714;57.85714286;32.71428571;28.42857143;50.85714286;...
    30.71428571;26.42857143;42.71428571;47.85714286;49.28571429;47.42857143;...
    24.57142857;42;36.57142857;39.28571429;33.57142857;33.85714286;46.71428571;...
    26;46.85714286;64.71428571;85.42857143;65.57142857;34.85714286;36.57142857;...
    47.42857143;56.57142857;43;52.85714286;37.57142857;32;51.85714286;42.14285714;...
    63.57142857;52.14285714;57.57142857;66.57142857;56.71428571;75.71428571;...
    77.71428571;81.57142857;80;65.28571429;91.85714286;121.8571429;118;...
    83.28571429;71.71428571;36.28571429;45.85714286;71.42857143;77.57142857;...
    87.85714286;99.85714286;118;112.1428571;121.7142857;162.2857143;117.1428571;...
    99;105.8571429;76.57142857;62.57142857;58.14285714;73.71428571;62.42857143;...
    61.28571429;65.85714286;78.57142857;133.8571429;99.85714286;66.42857143;74;...
    69.71428571;79.28571429;73.85714286;95.28571429;49.28571429;50.85714286;...
    50.71428571;61.14285714;70.57142857;56.57142857;49;62.57142857;49.71428571;...
    57.57142857;59.57142857;100.5714286;93.85714286;77.57142857;106.4285714;...
    131.4285714;141.1428571];

y_inf_data_Pima=[128.0714286;116.4285714;70.57142857;42.28571429;62.57142857;...
    71.71428571;88.28571429;71.28571429;88.85714286;72.28571429;80.28571429;...
    106.4285714;137;82.28571429;91.85714286;77.28571429;81.57142857;82;80.42857143;...
    46.57142857;62;52.28571429;61;57.14285714;58.57142857;96;66;58.57142857;...
    71.28571429;75;148.1428571;115.7142857;112.8571429;146.2857143;114.1428571;...
    109.1428571;86.85714286;80.28571429;64.71428571;79.42857143;73.57142857;...
    79.57142857;73.28571429;75.85714286;55.71428571;68.14285714;60.71428571;...
    90;95.71428571;83.85714286;64.14285714;74.28571429;87.42857143;67;63.85714286;...
    105.4285714;75.85714286;58.14285714;82.42857143;128.5714286;146;90.42857143;...
    83.85714286;71.71428571;59.42857143;83.28571429;97.28571429;103.2857143;...
    87.71428571;76.28571429;76;75;62.71428571;85.71428571;111.8571429;127.5714286;...
    115.7142857;115.5714286;122;146.5714286;143;100.1428571;118.4285714;123.4285714;...
    131;101;110;92.57142857;82.57142857;102.8571429;122.2857143;125.2857143;...
    164.5714286;143.1428571;127.7142857;162.4285714;165.5714286;138.5714286;...
    138.2857143;140.7142857;88.14285714;110;104.5714286;117.7142857;84.28571429;...
    80.14285714;92.14285714;98.85714286;123.5714286;95.42857143;57.14285714;...
    83.85714286;83.57142857;112.2857143;113.8571429;139.7142857;100.5714286;...
    81.71428571;89.14285714;79;93.71428571;103.4285714;87.57142857;89;87.28571429;...
    100.5714286;104;109.4285714;115.2857143;93.42857143;113.4285714;132;134.5714286];

y_inf_data_AZ=[798.9142857;726.2857143;461.5714286;326;356.4285714;425;431.5714286;...
    431.4285714;463.7142857;401.1428571;489.7142857;682.1428571;696;564.8571429;...
    591.8571429;574;529.2857143;595;505.1428571;319.5714286;347.8571429;352.2857143;...
    325.7142857;338.8571429;435.5714286;410;380;432.5714286;517.4285714;471.7142857;...
    700.1428571;727.7142857;778.7142857;944.5714286;786.1428571;800;684;581.2857143;...
    464.1428571;574.4285714;529.1428571;459;454.8571429;483.2857143;495.4285714;...
    392.4285714;553;590;577;532.1428571;416;408.7142857;457.1428571;442.7142857;...
    417.2857143;522.8571429;522.2857143;444.8571429;643.4285714;953.8571429;...
    1184.714286;898.2857143;584.4285714;564.2857143;552;663;611;689.5714286;...
    609.8571429;538;622.7142857;523.4285714;630.4285714;745.5714286;658;811.4285714;...
    749.7142857;797.7142857;818.2857143;943.2857143;971;798.2857143;902.4285714;...
    1115.285714;1059;930;830;635.2857143;475.7142857;630.5714286;747.1428571;...
    800.2857143;1067.142857;1188.285714;1175.571429;1382.857143;1560.142857;...
    1323.285714;1113.428571;1147.285714;863.1428571;854.4285714;809;814.4285714;...
    810.7142857;736.7142857;842;1009.857143;1223.714286;952.8571429;673.5714286;...
    704.5714286;787;948.1428571;911.2857143;1072.571429;715.7142857;625.8571429;...
    617.1428571;691.2857143;759;704.4285714;615.2857143;773.5714286;702.4285714;...
    750.7142857;706;869.2857143;974.4285714;929.8571429;1126;1335;1417];

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];

y_inf_data=y_inf_data_Maricopa;
y_pop_data=y_pop_data_Maricopa;
county_M2=["MARICOPA"];
alpha_h_b=alpha_h_maricopa;
omega_b=omega_maricopa;

%Initial Conditions
ic_O=40;
ic_D=70;
ic_H=100;%
ic_A=50;%100
ic_I=y_inf_data(1)/1;
ic_E=ic_I*1.5;%y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_E-ic_R);

y0=[ic_O;ic_D;ic_H;ic_A;ic_S;ic_E;ic_I;ic_R];

% PI                   % delta_O             %mu_H
LB(1) = 5;           LB(2) = 0.000000001;   LB(3) = 0.0000001;        
UB(1) = 2000;        UB(2) = 0.5;           UB(3) = 0.1;

% gamma_h            % H_max                %delta_H
LB(4) = 0.00000001;    LB(5) = 210;       LB(6) = 0.000001;        
UB(4) = 0.06;            UB(5) = 450;   UB(6) = 0.2;

% gamma_A            % delta_A              %phi_A
LB(7) = 0.0000001;   LB(8) = 0.00000001;    LB(9) = 0.0000000001;        
UB(7) = 0.1;           UB(8) = 0.2;       UB(9) = 0.00001;

% alpha_h                        %epsilon
LB(10) = alpha_h_b*0.999999;     LB(11) = 0.0000000001;       
UB(10) = alpha_h_b*1.0000001;     UB(11) = 0.00001;

% omega                     % rho                %kappa
LB(12) = omega_b*0.999999;   LB(13) = 1/(2*365);   LB(14) = 0.000000027768;        
UB(12) = omega_b*1.0000001;    UB(13) = 1/14;      UB(14) = 0.000359; 

% psi                %delta_D          
LB(15) = 1/60;      LB(16) = 0.0000001;      
UB(15) = 1/5;       UB(16) = 0.06;      
  

%FITTING
pool = gcp; % Will create a pool if none exists
numWorkers = pool.NumWorkers;
disp(numWorkers);
format long
tspan=t_inf_data;
  % options = optimoptions('fmincon','Algorithm','interior-point','EnableFeasibilityMode', true,...
  %     "SubproblemAlgorithm","cg",'TolX',1e-200,'TolFun',1e-200,'TolCon',1e-200,...
  %     'MaxIter',20000000,'MaxFunEvals',1000000);

  options = optimset('Algorithm','interior-point','TolX',1e-20,'TolFun',1e-20,'TolCon'...
    ,1e-20,'MaxIter',200000,'MaxFunEvals',100000);
 % options = optimoptions("fmincon",...
 %    Algorithm="interior-point",...
 %    EnableFeasibilityMode=true,...
 %    SubproblemAlgorithm="cg");
 options = optimoptions('fmincon', ...
    'UseParallel', true, ...
    'Algorithm','interior-point',...
    'TolX',1e-20,...
    'TolFun',1e-20,...
    'TolCon',1e-20,...
    'MaxIter',200000,...
    'MaxFunEvals',100000,...
    'Display', 'iter');
% Parameters initial guess 
    p0 = [((LB + UB) / 2)'];

% Run optimization
%without options
%p_opt = fmincon(@(p) objective_functionM2(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, []);
%with options    
% [params_m2fmin, errorOBJ] = fmincon(@(p) objective_functionM2(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);
% params_m2fmin
% errorOBJ

optionsfast = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*5, ...
    'MaxIterations', 2000, ...
    'MaxStallIterations', 10, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-5, ... %1e-15
    'Display', 'iter');

optionsmedium = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*50, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-12, ... %1e-15
    'Display', 'iter');

optionsslow = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*100, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 120, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 0.8, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-15, ... %1e-15
    'Display', 'iter');
options=optionsslow;
[params_m2pswarm, errorOBJ]= particleswarm(@(p) objective_functionM2(p, tspan, y0, y_inf_data),length(LB),LB,UB,options);
[params_m2pswarm_RSS, rss]= particleswarm(@(p) objective_functionM2_RSS(p, tspan, y0, y_inf_data),length(LB),LB,UB,options);

fprintf('params_m2pswarm = [%s%.15f];\n', sprintf('%.15f; ', params_m2pswarm(1:end-1),params_m2pswarm(end)),'\n',' ');
fprintf('params_m2pswarm_RSS = [%s%.15f];\n', sprintf('%.15f; ', params_m2pswarm_RSS(1:end-1),params_m2pswarm_RSS(end)),'\n',' ');
county_M2
errorOBJ
num_data_points = numel(y_inf_data);    % n
k = numel(LB);               % k

% Calculate AIC, AICc, BIC (same formulas)
aic = num_data_points * log(rss / num_data_points) + 2 * k;
aicc = aic + (2 * k * (k + 1)) / (num_data_points - k - 1);
bic = num_data_points * log(rss / num_data_points) + k * log(num_data_points);

%Display Results
county_M2
fprintf('Model 2 Information Criteria Results \n');
fprintf('RSS: %.4f\n', rss);
fprintf('AIC: %.4f\n', aic);
fprintf('AICc: %.4f\n', aicc);
fprintf('BIC: %.4f\n', bic);

%[t, yfmin] = ode15s(@M2_SF,t_inf_data,y0,[],params_m2fmin);
[t, ypswarm] = ode15s(@M2_SF,t_inf_data,y0,[],params_m2pswarm);
%err_fmin_m2 = (rmse(yfmin(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
err_pswarm_m2 = (rmse(ypswarm(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
y=ypswarm;
% if err_fmin_m2<err_pswarm_m2
%     y=yfmin;
% else
%     y=ypswarm;
% end

figure
scatter(t_inf_data,y_inf_data, 'b','LineWidth',1)
hold on
plot(t,yfmin(:,7),'c','LineWidth',2.5)
plot(t,ypswarm(:,7),'k','LineWidth',2)
legend('Maricopa Infected','FMin Model 2 fit','Pswarm Model 2 fit','Location','best');
title("Valley Fever Model 2 - Simple Fungal Growth Model -"+county_M2, 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
subtitle("Infected Fmin M2 RRMSE="+err_fmin_m2+", Infected Pswarm M2 RRMSE="+err_pswarm_m2, 'FontSize', 14)
xlabel('Year', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
hold off


%plotting of results for specific params
 figure
plot(t,y(:,1), 'b','LineWidth',2)
hold on
plot(t,y(:,2),'c','LineWidth',2)
legend('Organic Matter','Decomposed Organic Matter','Location','best');
title("Valley Fever Model 2 - Simple Fungal Growth Model -"+county_M2, 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); ylabel('Mass', 'FontSize', 18)
hold off

figure
plot(t,ypswarm(:,3), 'r','LineWidth',2);
hold on
plot(t,ypswarm(:,4),'g','LineWidth',2)
plot(t,y(:,5), 'k','LineWidth',2);
legend('Hyphae Structure','Arthroconidia','Colonies','Location','best');
title("Valley Fever Model 2 - Simple Fungal Growth Model -"+county_M2, 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); ylabel('PPM', 'FontSize', 18)
hold off

figure
plot(t,y(:,6), 'color',[0.4660 0.6740 0.1880],'LineWidth',2);
hold on
plot(t,y(:,7),'color',[0.9290 0.4940 0.0250],'LineWidth',2);
plot(t,y(:,8), 'color',[.5 0 .5],'LineWidth',2);
legend('Susceptible','Infected','Recovered','Location','best');
title("Valley Fever Model 2 - Simple Fungal Growth Model -"+county_M2, 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); ylabel('Humans', 'FontSize', 18)
hold off



elseif single_run_or_fitting==3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Forecasting Model 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 2 Forecasting')

%import/load infected valley fever data
y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
    y_pop_data_Pinal=[394200;425264;484239;513862];
    y_pop_data_Pima=[1024000;1043433;1063162;1080149];
    y_pop_data_AZ=[6849647;7151502;7431344;7582384];
    t_pop_data=[1006-1006,3653-1006,4839-1006,5205-1006];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data_Pinal=[53.74285714;48.85714286;36.28571429;15.42857143;17.71428571;...
    34.14285714;33.57142857;30.57142857;35.42857143;25.42857143;34.14285714;...
    41.42857143;61;38.85714286;35.14285714;54.85714286;43.71428571;57.42857143;...
    40.14285714;27.42857143;33.42857143;28.14285714;22.28571429;30;33.57142857;...
    37;32;37.57142857;48.28571429;42.14285714;48.71428571;60.42857143;...
    68.71428571;71.28571429;78.85714286;73.14285714;56.85714286;47.85714286;...
    42.14285714;42.14285714;57.85714286;32.71428571;28.42857143;50.85714286;...
    30.71428571;26.42857143;42.71428571;47.85714286;49.28571429;47.42857143;...
    24.57142857;42;36.57142857;39.28571429;33.57142857;33.85714286;46.71428571;...
    26;46.85714286;64.71428571;85.42857143;65.57142857;34.85714286;36.57142857;...
    47.42857143;56.57142857;43;52.85714286;37.57142857;32;51.85714286;42.14285714;...
    63.57142857;52.14285714;57.57142857;66.57142857;56.71428571;75.71428571;...
    77.71428571;81.57142857;80;65.28571429;91.85714286;121.8571429;118;...
    83.28571429;71.71428571;36.28571429;45.85714286;71.42857143;77.57142857;...
    87.85714286;99.85714286;118;112.1428571;121.7142857;162.2857143;117.1428571;...
    99;105.8571429;76.57142857;62.57142857;58.14285714;73.71428571;62.42857143;...
    61.28571429;65.85714286;78.57142857;133.8571429;99.85714286;66.42857143;74;...
    69.71428571;79.28571429;73.85714286;95.28571429;49.28571429;50.85714286;...
    50.71428571;61.14285714;70.57142857;56.57142857;49;62.57142857;49.71428571;...
    57.57142857;59.57142857;100.5714286;93.85714286;77.57142857;106.4285714;...
    131.4285714;141.1428571];

y_inf_data_Pima=[128.0714286;116.4285714;70.57142857;42.28571429;62.57142857;...
    71.71428571;88.28571429;71.28571429;88.85714286;72.28571429;80.28571429;...
    106.4285714;137;82.28571429;91.85714286;77.28571429;81.57142857;82;80.42857143;...
    46.57142857;62;52.28571429;61;57.14285714;58.57142857;96;66;58.57142857;...
    71.28571429;75;148.1428571;115.7142857;112.8571429;146.2857143;114.1428571;...
    109.1428571;86.85714286;80.28571429;64.71428571;79.42857143;73.57142857;...
    79.57142857;73.28571429;75.85714286;55.71428571;68.14285714;60.71428571;...
    90;95.71428571;83.85714286;64.14285714;74.28571429;87.42857143;67;63.85714286;...
    105.4285714;75.85714286;58.14285714;82.42857143;128.5714286;146;90.42857143;...
    83.85714286;71.71428571;59.42857143;83.28571429;97.28571429;103.2857143;...
    87.71428571;76.28571429;76;75;62.71428571;85.71428571;111.8571429;127.5714286;...
    115.7142857;115.5714286;122;146.5714286;143;100.1428571;118.4285714;123.4285714;...
    131;101;110;92.57142857;82.57142857;102.8571429;122.2857143;125.2857143;...
    164.5714286;143.1428571;127.7142857;162.4285714;165.5714286;138.5714286;...
    138.2857143;140.7142857;88.14285714;110;104.5714286;117.7142857;84.28571429;...
    80.14285714;92.14285714;98.85714286;123.5714286;95.42857143;57.14285714;...
    83.85714286;83.57142857;112.2857143;113.8571429;139.7142857;100.5714286;...
    81.71428571;89.14285714;79;93.71428571;103.4285714;87.57142857;89;87.28571429;...
    100.5714286;104;109.4285714;115.2857143;93.42857143;113.4285714;132;134.5714286];

y_inf_data_AZ=[798.9142857;726.2857143;461.5714286;326;356.4285714;425;431.5714286;...
    431.4285714;463.7142857;401.1428571;489.7142857;682.1428571;696;564.8571429;...
    591.8571429;574;529.2857143;595;505.1428571;319.5714286;347.8571429;352.2857143;...
    325.7142857;338.8571429;435.5714286;410;380;432.5714286;517.4285714;471.7142857;...
    700.1428571;727.7142857;778.7142857;944.5714286;786.1428571;800;684;581.2857143;...
    464.1428571;574.4285714;529.1428571;459;454.8571429;483.2857143;495.4285714;...
    392.4285714;553;590;577;532.1428571;416;408.7142857;457.1428571;442.7142857;...
    417.2857143;522.8571429;522.2857143;444.8571429;643.4285714;953.8571429;...
    1184.714286;898.2857143;584.4285714;564.2857143;552;663;611;689.5714286;...
    609.8571429;538;622.7142857;523.4285714;630.4285714;745.5714286;658;811.4285714;...
    749.7142857;797.7142857;818.2857143;943.2857143;971;798.2857143;902.4285714;...
    1115.285714;1059;930;830;635.2857143;475.7142857;630.5714286;747.1428571;...
    800.2857143;1067.142857;1188.285714;1175.571429;1382.857143;1560.142857;...
    1323.285714;1113.428571;1147.285714;863.1428571;854.4285714;809;814.4285714;...
    810.7142857;736.7142857;842;1009.857143;1223.714286;952.8571429;673.5714286;...
    704.5714286;787;948.1428571;911.2857143;1072.571429;715.7142857;625.8571429;...
    617.1428571;691.2857143;759;704.4285714;615.2857143;773.5714286;702.4285714;...
    750.7142857;706;869.2857143;974.4285714;929.8571429;1126;1335;1417];

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];


alpha_h_maricopa= 0.000035386745035+0.049996054144265;
omega_maricopa= 0.049996054144265;

alpha_h_pinal= 0.000054197479825+0.049562154054803; %*use looser bounds
omega_pinal= 0.049562154054803; %*use looser bounds

alpha_h_pima= 0.000010637066754+0.050079359342677;
omega_pima= 0.050079359342677;

alpha_h_AZ= 0.002876562772732+0.058375000164113;
omega_AZ= 0.058375000164113;

y_pop_data=y_pop_data_Pinal;
y_inf_data=y_inf_data_Pinal;
alpha_h_b=alpha_h_pinal;
omega_b=omega_pinal;
county_M2=["Pinal"];
tspan_8_1=t_inf_data(1:97,1);
tspan_8_1_F=t_inf_data(1:109,1);
tspan_8_2=t_inf_data(13:109,1);
tspan_8_2_F=t_inf_data(13:121,1);
tspan_8_3=t_inf_data(25:121,1);
tspan_8_3_F=t_inf_data(25:133,1);
tspan_11_years=t_inf_data;
y_inf_data_8_1=y_inf_data(1:97,1);
y_inf_data_8_2=y_inf_data(13:109,1);
y_inf_data_8_3=y_inf_data(25:121,1);
y_inf_data_8_4=y_inf_data(25:133,1);

%Initial Conditions
ic_O=40;
ic_D=70;
ic_H=100;%
ic_A=50;%100
ic_C=10;
ic_I=y_inf_data(1)/1;
ic_E=ic_I*1.5;%y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_E-ic_R);
y0=[ic_O;ic_D;ic_H;ic_A;ic_C;ic_S;ic_E;ic_I;ic_R];

% PI                   % delta_O             %mu_H
LB(1) = 2;           LB(2) = 0.000000001;   LB(3) = 0.0000001;        
UB(1) = 2000;        UB(2) = 0.5;           UB(3) = 0.09;

% gamma_h            % H_max                %delta_H
LB(4) = 0.00000001;    LB(5) = 250;       LB(6) = 0.000001;        
UB(4) = 0.06;            UB(5) = 450;   UB(6) = 0.2;

% gamma_A            % delta_A              %phi_A
LB(7) = 0.0000001;   LB(8) = 0.00000001;    LB(9) = 0.0000000001;        
UB(7) = 0.05;           UB(8) = 0.06;       UB(9) = 0.000001;

% delta_C            
LB(10) = 0.0000001;          
UB(10) = 0.001;           

% alpha_h                       %epsilon
LB(11) = alpha_h_b*0.999999;     LB(12) = 0.0000000001;
UB(11) = alpha_h_b*1.0000001;     UB(12) = 0.00001;

% omega                     % rho                %kappa
LB(13) = omega_b*0.999999;   LB(14) = 1/(2*365);   LB(15) = 0.000000027768;        
UB(13) = omega_b*1.00001;    UB(14) = 1/14;      UB(15) = 0.000359; 

% psi                
LB(16) = 1/60;      
UB(16) = 1/7;

%FITTING OF MODEL 2 
pool = gcp; %create a pool if none exists
numWorkers = pool.NumWorkers;
disp(numWorkers);
format long

% Parameters initial guess 
    p0 = [LB'];
   
   % p_opt = fmincon(@(p) objective_functionM1(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);

options = optimoptions('particleswarm', ...
    'SwarmSize', length(LB)*10, ...
    'MaxIterations', 1000, ...
    'InertiaRange', [0.3, 1.2], ...
    'SelfAdjustmentWeight', 1.5, ...
    'SocialAdjustmentWeight', 2.0, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-10, ...
    'Display', 'iter');

options = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*20, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-15, ...
    'Display', 'iter');
%p_opt = particleswarm(@(p) objective_functionM1(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);
[params_m2pswarm_8_1, errorOBJ8_1]= particleswarm(@(p) objective_functionM2(p, tspan_8_1, y0, y_inf_data_8_1),length(LB),LB,UB,options);

[params_m2pswarm_8_2, errorOBJ8_2]= particleswarm(@(p) objective_functionM2(p, tspan_8_2, y0, y_inf_data_8_2),length(LB),LB,UB,options);
%scnd_year_forecast_rrmse=(rmse(ypswarm_fit8_2(110:121,4) , y_inf_data(110:121,1))/sqrt(sumsqr(y_inf_data(110:121,1)')))*100;

[params_m2pswarm_8_3, errorOBJ8_3]= particleswarm(@(p) objective_functionM2(p, tspan_8_3, y0, y_inf_data_8_3),length(LB),LB,UB,options);
%thrd_year_forecast_rrmse=(rmse(ypswarm_fit_8_3(122:133,4) , y_inf_data(122:133,1))/sqrt(sumsqr(y_inf_data(122:133,1)')))*100;

county_M2
fprintf('params_m2pswarm_8_1 = [%s%.15f];\n', sprintf('%.15f; ', params_m2pswarm_8_1(1:end-1),params_m2pswarm_8_1(end)));
fprintf('params_m2pswarm_8_2 = [%s%.15f];\n', sprintf('%.15f; ', params_m2pswarm_8_2(1:end-1),params_m2pswarm_8_2(end)));
fprintf('params_m2pswarm_8_3 = [%s%.15f];\n', sprintf('%.15f; ', params_m2pswarm_8_3(1:end-1),params_m2pswarm_8_3(end)));

[t8_1, ypswarm_fit8_1] = ode23s(@M2_SF,tspan_8_1_F,y0,[],params_m2pswarm_8_1);
frst_year_forecast_rrmse=(rmse(ypswarm_fit8_1(98:109,4) , y_inf_data(98:109,1))/sqrt(sumsqr(y_inf_data(98:109,1)')))*100;
[t8_1_15, ypswarm_fit8_1_15] = ode15s(@M2_SF,tspan_8_1_F,y0,[],params_m2pswarm_8_1);
frst_year_forecast_rrmse_15=(rmse(ypswarm_fit8_1_15(98:109,4) , y_inf_data(98:109,1))/sqrt(sumsqr(y_inf_data(98:109,1)')))*100;
[t8_1_45, ypswarm_fit8_1_45] = ode45(@M2_SF,tspan_8_1_F,y0,[],params_m2pswarm_8_1);
frst_year_forecast_rrmse_45=(rmse(ypswarm_fit8_1_45(98:109,4) , y_inf_data(98:109,1))/sqrt(sumsqr(y_inf_data(98:109,1)')))*100;
if frst_year_forecast_rrmse_15<frst_year_forecast_rrmse
    frst_year_forecast_rrmse=frst_year_forecast_rrmse_15;
    ypswarm_fit8_1=ypswarm_fit8_1_15;
elseif frst_year_forecast_rrmse_45<frst_year_forecast_rrmse
    frst_year_forecast_rrmse=frst_year_forecast_rrmse_45;
    ypswarm_fit8_1=ypswarm_fit8_1_45;
end
try
[t8_2, ypswarm_fit8_2] = ode23s(@M2_SF,tspan_8_2_F,y0,[],params_m2pswarm_8_2);
scnd_year_forecast_rrmse=(rmse(ypswarm_fit8_2(98:109,4) , y_inf_data(110:121,1))/sqrt(sumsqr(y_inf_data(110:121,1)')))*100;
catch
    scnd_year_forecast_rrmse=1e10;
end
try
[t8_2_15, ypswarm_fit8_2_15] = ode15s(@M2_SF,tspan_8_2_F,y0,[],params_m2pswarm_8_2);
scnd_year_forecast_rrmse_15=(rmse(ypswarm_fit8_2_15(98:109,4) , y_inf_data(110:121,1))/sqrt(sumsqr(y_inf_data(110:121,1)')))*100;
catch
end
try
[t8_2_45, ypswarm_fit8_2_45] = ode45(@M2_SF,tspan_8_2_F,y0,[],params_m2pswarm_8_2);
scnd_year_forecast_rrmse_45=(rmse(ypswarm_fit8_2_45(98:109,4) , y_inf_data(110:121,1))/sqrt(sumsqr(y_inf_data(110:121,1)')))*100;
catch
end
if scnd_year_forecast_rrmse_15<scnd_year_forecast_rrmse
    scnd_year_forecast_rrmse=scnd_year_forecast_rrmse_15;
    ypswarm_fit8_2=ypswarm_fit8_2_15;
elseif scnd_year_forecast_rrmse_45<scnd_year_forecast_rrmse
    scnd_year_forecast_rrmse=scnd_year_forecast_rrmse_45;
    ypswarm_fit8_2=ypswarm_fit8_2_45;
end

[t8_3, ypswarm_fit8_3] = ode23s(@M2_SF,tspan_8_3_F,y0,[],params_m2pswarm_8_3);
thrd_year_forecast_rrmse=(rmse(ypswarm_fit8_3(98:109,4) , y_inf_data(122:133,1))/sqrt(sumsqr(y_inf_data(122:133,1)')))*100;
[t8_3_15, ypswarm_fit8_3_15] = ode15s(@M2_SF,tspan_8_3_F,y0,[],params_m2pswarm_8_3);
thrd_year_forecast_rrmse_15=(rmse(ypswarm_fit8_3_15(98:109,4) , y_inf_data(122:133,1))/sqrt(sumsqr(y_inf_data(122:133,1)')))*100;
[t8_3_45, ypswarm_fit8_3_45] = ode45(@M2_SF,tspan_8_3_F,y0,[],params_m2pswarm_8_3);
thrd_year_forecast_rrmse_45=(rmse(ypswarm_fit8_3_45(98:109,4) , y_inf_data(122:133,1))/sqrt(sumsqr(y_inf_data(122:133,1)')))*100;
if thrd_year_forecast_rrmse_15<thrd_year_forecast_rrmse
    thrd_year_forecast_rrmse=thrd_year_forecast_rrmse_15;
    ypswarm_fit8_3=ypswarm_fit8_3_15;
elseif thrd_year_forecast_rrmse_45<thrd_year_forecast_rrmse
    thrd_year_forecast_rrmse=thrd_year_forecast_rrmse_45;
    ypswarm_fit8_3=ypswarm_fit8_3_45;
end

county_M2
fprintf('params_m2pswarm_8_1 = [%s%.15f];\n', sprintf('%.15f; ', params_m2pswarm_8_1(1:end-1),params_m2pswarm_8_1(end)));
fprintf('params_m2pswarm_8_2 = [%s%.15f];\n', sprintf('%.15f; ', params_m2pswarm_8_2(1:end-1),params_m2pswarm_8_2(end)));
fprintf('params_m2pswarm_8_3 = [%s%.15f];\n', sprintf('%.15f; ', params_m2pswarm_8_3(1:end-1),params_m2pswarm_8_3(end)));
frst_year_forecast_rrmse
scnd_year_forecast_rrmse
thrd_year_forecast_rrmse

%Display
figure
scatter(t_inf_data,y_inf_data, 'k','LineWidth',2)
hold on
plot(t8_1(1:97,1),ypswarm_fit8_1(1:97,4), 'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
plot(t8_1(97:109,1),ypswarm_fit8_1(97:109,4), 'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
plot(t8_2(97:109,1),ypswarm_fit8_2(97:109,4), 'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
plot(t8_3(97:109,1),ypswarm_fit8_3(97:109,4),'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
xline(2922, 'k','LineWidth',2)
xline(3287, 'k','LineWidth',2)
xline(3652, 'k','LineWidth',2)
legend(county_M2+' Infected','Model 2 fit first 8 years', '2022 forecast','2023 forecast','2024 forecast','Location','best');
title(county_M2+" Valley Fever Model 2 Forecast ", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
subtitle("Forecasted 2022 RRMSE="+frst_year_forecast_rrmse+"%, Forecasted 2023 RRMSE="+scnd_year_forecast_rrmse...
    +"%, Forecasted 2024 RRMSE="+thrd_year_forecast_rrmse+"%", 'FontSize', 14)
xlabel('Year', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
ylim([0,max(y_inf_data)+200])
hold off
end










































elseif choose_model==3
%% Model 3 - Fungal Growth Model dependent on Food and Enviroment
% Function for Model 2 and and of section
if single_run_or_fitting==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %SINGLE RUN Model 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 3 single parameter run')
t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];

y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
y_pop_data_Pinal=[394200;425264;484239;513862];
y_pop_data_Pima=[1024000;1043433;1063162;1080149];
y_pop_data_AZ=[6849647;7151502;7431344;7582384];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data=y_inf_data_Maricopa;
y_pop_data=y_pop_data_Maricopa;

%Initial Conditions
ic_O=100;
ic_D=50;
ic_H=100;
ic_A=100;%100
ic_C=5;
ic_I=y_inf_data(1);
ic_S=(y_pop_data(1)-ic_I)*0.999;
ic_E=y_inf_data(1);
ic_R=y_inf_data(1);
y0=[ic_O;ic_D;ic_H;ic_A;ic_C;ic_S;ic_E;ic_I;ic_R];

%Parameters
PI=10; delta_O=0.04; mu_H=0.0001;
gamma_H=0.0001; H_max=1000; delta_H=0.02;
gamma_A=0.09; delta_A=0.07; phi_A=0.000029;
delta_C=0.001; T_opt_H=80; T_opt_A=80;
S_opt_H=80; S_opt_A=80; T_decay=50;
bl_Topt_A=2000; ab_Topt_A=500; bl_Topt_H=2000; 
ab_Topt_H=500; bl_Sopt_A=2000; ab_Sopt_A=500; 
bl_Sopt_H=2000; ab_Sopt_H=500; alpha_h=0.44; delta_R=0.0005; 
epsilon=0.0007; omega=0.4385; rho=0.0002; kappa=0.01; psi=0.3;

alpha_h_maricopa= 0.000035386745035+0.049996054144265;
omega_maricopa= 0.049996054144265;

alpha_h_pinal= 0.000054197479825+0.049562154054803; %*use looser bounds
omega_pinal= 0.049562154054803; %*use looser bounds

alpha_h_pima= 0.000010637066754+0.050079359342677;
omega_pima= 0.050079359342677;

alpha_h_AZ= 0.002876562772732+0.058375000164113;
omega_AZ= 0.058375000164113;

% alpha_h_maricopa= 0.450004027248630;
% omega_maricopa= 0.449968571859412;
PI=10; delta_O=0.04; mu_H=0.0001;
gamma_H=0.0000005; H_max=350; delta_H=0.004;
gamma_A=0.013; delta_A=0.007; phi_A=0.00014;
delta_C=0.00001; T_opt_H=75; T_opt_A=80;
%S_opt_H=80; S_opt_A=80; T_decay=60;
S_opt_H=13; S_opt_A=9; T_decay=60;
bl_Topt_A=500; ab_Topt_A=70; bl_Topt_H=500; 
ab_Topt_H=70; bl_Sopt_A=2000; ab_Sopt_A=500; 
bl_Sopt_H=2000; ab_Sopt_H=500; T_hs=78;
beta=0.009; mu_V=0.005; delta_V_j=0.003;
delta_V_a=0.001; sigma=0.00000000007; T_cs=68;
alpha=0.000004;  S_d_s=20; T_d_s=90; 
bl_S_H_s=2; ab_T_H_s=1; xtr_c_s=10; delta_R=0; 
epsilon=0.0000008; rho=0.04; kappa=0.0003; psi=0.035;
%
alpha_h=alpha_h_maricopa;
omega=omega_maricopa;
% 
Parameters_M3_infdata = [10; 0.04; 0.0001; 0.00001; 350; 0.00002; 0.2; 0.007; 0.000001;...
    0.002; 80; 80; 80; 80; 60; 500; 70; 500; 70; 2000; 500; 2000; 500; 0.10; 0; 0.0000004;...
    0.099964544636; 0.04; 0.0003; 0.04];

paramsm3=[PI; delta_O; mu_H; gamma_H; H_max; delta_H; gamma_A; delta_A; ...
     phi_A; delta_C; T_opt_H; T_opt_A; S_opt_H; S_opt_A; T_decay; bl_Topt_A; ...
     ab_Topt_A; bl_Topt_H; ab_Topt_H; bl_Sopt_A; ab_Sopt_A; bl_Sopt_H; ab_Sopt_H;...
     alpha_h; delta_R; epsilon; omega; rho; kappa; psi];


 %ode run
 options = odeset(...
                'RelTol', 1e-2, ...
                'AbsTol', 1e-4, ...
                'MaxStep', 0.5, ...
                'InitialStep', 1e-6);
 try
     [t, y] = ode15s(@(t, y) M3_SF(t, y, paramsm3), t_inf_data, y0, options);
     err_m3 = (rmse(y(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    catch 
     try
         disp('ode15s safe failed')
         [t, y] =ode15s(@(t, y) M3_SF(t, y, paramsm3), t_inf_data, y0);
         err_m3 = (rmse(y(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
     catch
         try
              disp('ode15s 2 safe failed')
            [t, y] = ode23s(@M3_SF,t_inf_data,y0,[],paramsm3);
            err_m3 = (rmse(y(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
         catch
             try
                  disp('ode23s safe failed')
                 [t, y] =ode45(@(t, y) M3_SF(t, y, paramsm3), t_inf_data, y0);
                 err_m3 = (rmse(y(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
             catch
                 try
                      disp('ode45 safe failed')
                     [t, y] =ode78(@(t, y) M3_SF(t, y, paramsm3), t_inf_data, y0);
                     err_m3 = (rmse(y(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
                 catch
                     disp('ode78 safe failed')
                     disp('nothing worked')
                 end
             end
         end
     end
 end
  [t, y] =ode78(@(t, y) M3_SF(t, y, paramsm3), t_inf_data, y0);
                     err_m3 = (rmse(y(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
disp('space')
fprintf('y_inf_data_M3 = [%s%.4f];\n', sprintf('%.4f; ', y(1:end-1,8),y(end,8)));
disp('space')
fprintf('Parameters_M3_infdata = [%s%.7f];\n', sprintf('%.7f; ', paramsm3(1:end-1),paramsm3(end)));
disp('space')
y_inf_data_M3 = [565.4000; 519.8575; 485.2660; 465.8198; 487.7699; 525.5188;...
    516.7577; 446.5856; 382.6769; 361.0844; 370.0199; 356.7920; 318.1038; 279.9563;...
    260.5350; 255.4542; 270.6854; 308.5878; 327.5052; 291.9672; 265.5735; 263.8109;...
    283.6015; 292.1168; 270.3663; 245.6302; 239.1856; 262.2852; 305.5375; 371.3543;...
    416.5866; 389.5976; 339.3500; 316.6599; 356.8109; 368.4380; 332.4096; 293.4082;...
    283.6469; 309.8186; 359.7507; 441.4611; 475.8249; 411.5339; 362.0929; 380.2990;...
    440.8480; 475.1749; 450.5188; 403.3595; 376.4233; 399.0404; 465.1526; 567.6683;...
    601.8666; 528.5114; 458.0475; 457.1492; 522.2826; 571.3812; 559.2320; 527.2236;...
    500.5032; 492.8898; 560.5447; 683.5938; 743.4060; 663.4207; 571.8429; 524.2526;...
    562.9474; 561.8674; 515.3480; 460.9592; 414.4991; 397.1376; 463.6695; 574.7818;...
    684.1510; 630.2470; 534.9803; 512.3557; 590.4420; 626.4037; 585.7906; 529.8379;...
    494.4158; 487.6633; 550.9907; 694.8114; 768.8444; 681.7101; 564.2825; 505.6323;...
    573.3197; 633.3811; 601.6797; 545.2988; 514.0832; 515.3228; 598.2248; 769.2416;...
    821.1038; 736.3914; 661.1709; 660.5151; 742.0320; 800.2969; 782.0300; 712.9837;...
    660.1282; 655.3970; 750.3268; 930.0272; 991.0247; 870.7617; 764.5449; 737.7196; ...
    815.8845; 812.5960; 727.6840; 637.3708; 572.7986; 538.5345; 598.7061; 778.1068;...
    980.6339; 922.6798; 773.2168; 754.6097; 878.1268; 953.2340; 914.9414];
Parameters_M3_infdata = [10; 0.04; 0.0001; 0.0000005; 350; 0.004; 0.013; 0.007; 0.00014;...
    0.00001; 75; 80; 13; 9; 60; 500; 70; 500; 70; 2000; 500; 2000; 500; 0.1; 0; 0.0000008;...
    0.0999645; 0.04; 0.0003; 0.0350000];


%plotting results
%  plot(t,40*sin(((2*pi)/365)*t)+70,'color', [.55 .55 .55],'LineWidth',2);
% hold on
% plot(t,49*sin(((2*pi)/365)*t-(pi/8))+50,'color', [.85 .85 .85],'LineWidth',2);
figure
plot(t,y(:,1),'b','LineWidth',2)
hold on
plot(t,y(:,2),'c','LineWidth',2)
legend('Organic Matter','Decayed Organic Matter','FontSize', 16,'Location','best');
title("Valley Fever Model 3 - Fungal Growth Model dependent on Food & Env.", 'FontSize', 22)
xticks(t_inf_data)
%subtitle("Infected Manual M4 RRMSE="+err_m4, 'FontSize', 14)
xlabel('Day (Day 0 corresponds to Jan. 1 2013)', 'FontSize', 18); %ylabel('Humans', 'FontSize', 18)
hold off

figure
plot(t,y(:,3),'r','LineWidth',2)
hold on
plot(t,y(:,4),'g','LineWidth',2)
plot(t,y(:,5),'k','LineWidth',2)
legend('Hyphae','Arthroconidia','Colonies', 'FontSize', 16,'Location','best');
title("Valley Fever Model 3 - ungal Growth Model dependent on Food & Env.", 'FontSize', 22)
xticks(t_inf_data)
%subtitle("Infected Manual M4 RRMSE="+err_m4, 'FontSize', 14)
xlabel('Day (Day 0 corresponds to Jan. 1 2013)', 'FontSize', 18); %ylabel('Humans', 'FontSize', 18)
hold off

figure
scatter(t_inf_data,y_inf_data,'k','LineWidth',4)
hold on
plot(t,y(:,6),'r','LineWidth',2)
plot(t,y(:,7),'g','LineWidth',2)
plot(t,y(:,8),'color','[0.9290 0.4940 0.0250]','LineWidth',2)
plot(t,y(:,9),'color','[0.5 0 0.5]','LineWidth',2)
legend('INF Data','Susceptible','Exposed','Infected','Recovered', 'FontSize', 16,'Location','best');
title("Valley Fever Model 3 - Fungal Growth Model dependent on Food & Env.", 'FontSize', 22)
xticks(t_inf_data)
ylim([0,max(y_inf_data)+200])
subtitle("Infected Manual M3 RRMSE="+err_m3, 'FontSize', 14)
xlabel('Day (Day 0 corresponds to Jan. 1 2013)', 'FontSize', 18); %ylabel('Humans', 'FontSize', 18)
hold off



elseif single_run_or_fitting==2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %FITTING MODEL 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 3 fitting')
%Load population model parameters
global alpha_h_maricopa omega_maricopa alpha_h_pinal omega_pinal alpha_h_pima omega_pima alpha_h_AZ omega_AZ
alpha_h_maricopa= 0.000035386745035+0.049996054144265;
omega_maricopa= 0.049996054144265;

alpha_h_pinal= 0.000054197479825+0.049562154054803; %*use looser bounds
omega_pinal= 0.049562154054803; %*use looser bounds

alpha_h_pima= 0.000010637066754+0.050079359342677;
omega_pima= 0.050079359342677;

alpha_h_AZ= 0.002876562772732+0.058375000164113;
omega_AZ= 0.058375000164113;


%import/load data
y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
y_pop_data_Pinal=[394200;425264;484239;513862];
y_pop_data_Pima=[1024000;1043433;1063162;1080149];
y_pop_data_AZ=[6849647;7151502;7431344;7582384];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data_Pinal=[53.74285714;48.85714286;36.28571429;15.42857143;17.71428571;...
    34.14285714;33.57142857;30.57142857;35.42857143;25.42857143;34.14285714;...
    41.42857143;61;38.85714286;35.14285714;54.85714286;43.71428571;57.42857143;...
    40.14285714;27.42857143;33.42857143;28.14285714;22.28571429;30;33.57142857;...
    37;32;37.57142857;48.28571429;42.14285714;48.71428571;60.42857143;...
    68.71428571;71.28571429;78.85714286;73.14285714;56.85714286;47.85714286;...
    42.14285714;42.14285714;57.85714286;32.71428571;28.42857143;50.85714286;...
    30.71428571;26.42857143;42.71428571;47.85714286;49.28571429;47.42857143;...
    24.57142857;42;36.57142857;39.28571429;33.57142857;33.85714286;46.71428571;...
    26;46.85714286;64.71428571;85.42857143;65.57142857;34.85714286;36.57142857;...
    47.42857143;56.57142857;43;52.85714286;37.57142857;32;51.85714286;42.14285714;...
    63.57142857;52.14285714;57.57142857;66.57142857;56.71428571;75.71428571;...
    77.71428571;81.57142857;80;65.28571429;91.85714286;121.8571429;118;...
    83.28571429;71.71428571;36.28571429;45.85714286;71.42857143;77.57142857;...
    87.85714286;99.85714286;118;112.1428571;121.7142857;162.2857143;117.1428571;...
    99;105.8571429;76.57142857;62.57142857;58.14285714;73.71428571;62.42857143;...
    61.28571429;65.85714286;78.57142857;133.8571429;99.85714286;66.42857143;74;...
    69.71428571;79.28571429;73.85714286;95.28571429;49.28571429;50.85714286;...
    50.71428571;61.14285714;70.57142857;56.57142857;49;62.57142857;49.71428571;...
    57.57142857;59.57142857;100.5714286;93.85714286;77.57142857;106.4285714;...
    131.4285714;141.1428571];

y_inf_data_Pima=[128.0714286;116.4285714;70.57142857;42.28571429;62.57142857;...
    71.71428571;88.28571429;71.28571429;88.85714286;72.28571429;80.28571429;...
    106.4285714;137;82.28571429;91.85714286;77.28571429;81.57142857;82;80.42857143;...
    46.57142857;62;52.28571429;61;57.14285714;58.57142857;96;66;58.57142857;...
    71.28571429;75;148.1428571;115.7142857;112.8571429;146.2857143;114.1428571;...
    109.1428571;86.85714286;80.28571429;64.71428571;79.42857143;73.57142857;...
    79.57142857;73.28571429;75.85714286;55.71428571;68.14285714;60.71428571;...
    90;95.71428571;83.85714286;64.14285714;74.28571429;87.42857143;67;63.85714286;...
    105.4285714;75.85714286;58.14285714;82.42857143;128.5714286;146;90.42857143;...
    83.85714286;71.71428571;59.42857143;83.28571429;97.28571429;103.2857143;...
    87.71428571;76.28571429;76;75;62.71428571;85.71428571;111.8571429;127.5714286;...
    115.7142857;115.5714286;122;146.5714286;143;100.1428571;118.4285714;123.4285714;...
    131;101;110;92.57142857;82.57142857;102.8571429;122.2857143;125.2857143;...
    164.5714286;143.1428571;127.7142857;162.4285714;165.5714286;138.5714286;...
    138.2857143;140.7142857;88.14285714;110;104.5714286;117.7142857;84.28571429;...
    80.14285714;92.14285714;98.85714286;123.5714286;95.42857143;57.14285714;...
    83.85714286;83.57142857;112.2857143;113.8571429;139.7142857;100.5714286;...
    81.71428571;89.14285714;79;93.71428571;103.4285714;87.57142857;89;87.28571429;...
    100.5714286;104;109.4285714;115.2857143;93.42857143;113.4285714;132;134.5714286];

y_inf_data_AZ=[798.9142857;726.2857143;461.5714286;326;356.4285714;425;431.5714286;...
    431.4285714;463.7142857;401.1428571;489.7142857;682.1428571;696;564.8571429;...
    591.8571429;574;529.2857143;595;505.1428571;319.5714286;347.8571429;352.2857143;...
    325.7142857;338.8571429;435.5714286;410;380;432.5714286;517.4285714;471.7142857;...
    700.1428571;727.7142857;778.7142857;944.5714286;786.1428571;800;684;581.2857143;...
    464.1428571;574.4285714;529.1428571;459;454.8571429;483.2857143;495.4285714;...
    392.4285714;553;590;577;532.1428571;416;408.7142857;457.1428571;442.7142857;...
    417.2857143;522.8571429;522.2857143;444.8571429;643.4285714;953.8571429;...
    1184.714286;898.2857143;584.4285714;564.2857143;552;663;611;689.5714286;...
    609.8571429;538;622.7142857;523.4285714;630.4285714;745.5714286;658;811.4285714;...
    749.7142857;797.7142857;818.2857143;943.2857143;971;798.2857143;902.4285714;...
    1115.285714;1059;930;830;635.2857143;475.7142857;630.5714286;747.1428571;...
    800.2857143;1067.142857;1188.285714;1175.571429;1382.857143;1560.142857;...
    1323.285714;1113.428571;1147.285714;863.1428571;854.4285714;809;814.4285714;...
    810.7142857;736.7142857;842;1009.857143;1223.714286;952.8571429;673.5714286;...
    704.5714286;787;948.1428571;911.2857143;1072.571429;715.7142857;625.8571429;...
    617.1428571;691.2857143;759;704.4285714;615.2857143;773.5714286;702.4285714;...
    750.7142857;706;869.2857143;974.4285714;929.8571429;1126;1335;1417];

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];


%y_inf_data=y_inf_data_Maricopa;
y_inf_data=y_inf_data_AZ;
y_pop_data=y_pop_data_AZ;
county_M3=["AZ"];
alpha_h_b=alpha_h_AZ;
omega_b=omega_AZ;
county=1; %1=AZ, 2=Maricopa, 3=Pima, 4=Pinal

%Initial Conditions
ic_O=40;
ic_D=70;
ic_H=100;%
ic_A=50;%100
ic_I=y_inf_data(1)/1;
ic_E=ic_I*1.5;%y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_E-ic_R);
y0=[ic_O;ic_D;ic_H;ic_A;ic_S;ic_E;ic_I;ic_R];


% PI                   % delta_O             %mu_H
LB(1) = 1;           LB(2) = 0.00001;      LB(3) = 0.000001;         
UB(1) = 1000;        UB(2) = 0.3;           UB(3) = 0.1;

% gamma_h            % H_max                %delta_H
LB(4) =  0.00000001;    LB(5) = 210;       LB(6) = 0.000001;        
UB(4) = 0.06;        UB(5) = 450;       UB(6) = 0.2;

% gamma_A            % delta_A              %phi_A
LB(7) = 0.000001;   LB(8) = 0.000001;    LB(9) =0.000000001;        
UB(7) = 0.1;           UB(8) = 0.2;          UB(9) = 0.0001;

%T_opt_Hold 70-85       %T_opt_A
LB(10) = 65;         LB(11) = 77;      
UB(10) = 85;        UB(11) = 90; 

% S_opt_H            %S_opt_A                  %T_decay
LB(12) = 10;       LB(13) = 6;      LB(14) = 55;      
UB(12) = 14;          UB(13) = 10;        UB(14) = 65;

% bl_Topt_A            %ab_Topt_A                  %bl_Topt_H
LB(15) = 200;         LB(16) = 30;      LB(17) = 200;      
UB(15) = 700;        UB(16) = 100;        UB(17) = 700;

% ab_Topt_H            %bl_Sopt_A                  %ab_Sopt_A
LB(18) = 30;         LB(19) = 1;      LB(20) = 0.1;      
UB(18) = 100;           UB(19) = 20;        UB(20) = 7;

% bl_Sopt_H           %ab_Sopt_H                  
LB(22) = 1;           LB(23) = 0.1;      
UB(22) = 20;           UB(23) = 7;        

% alpha_h                       %epsilon
LB(23) = alpha_h_b*0.999999;    LB(24) = 0.000000001;        
UB(23) = alpha_h_b*1.000001;    UB(24) = 0.0001;

% omega                         % rho                %kappa
LB(25) = omega_b*0.999999;      LB(26) = 1/365;   LB(27) = 0.000000027768;         
UB(25) = omega_b*1.000001;      UB(26) = 1/14;      UB(27) = 0.000359; 

% psi                   %delta_D                 
LB(28) = 1/60;          LB(29) = 0.0000001;      
UB(28) = 1/5;           UB(29) = 0.06;           
    

%FITTING
tspan=t_inf_data;
pool = gcp; % Will create a pool if none exists
numWorkers = pool.NumWorkers;
disp(numWorkers);
format long

  % options = optimoptions('fmincon','Algorithm','interior-point','EnableFeasibilityMode', true,...
  %     "SubproblemAlgorithm","cg",'TolX',1e-200,'TolFun',1e-200,'TolCon',1e-200,...
  %     'MaxIter',20000000,'MaxFunEvals',1000000);

  options = optimset('Algorithm','interior-point','TolX',1e-20,'TolFun',1e-20,'TolCon'...
    ,1e-20,'MaxIter',200000,'MaxFunEvals',100000);
 % options = optimoptions("fmincon",...
 %    Algorithm="interior-point",...
 %    EnableFeasibilityMode=true,...
 %    SubproblemAlgorithm="cg");

% Parameters initial guess 
    p0 = [LB'];

% Run optimization
% params_m3fmin=[];

options = optimset('Algorithm','interior-point','TolX',1e-13,'TolFun',1e-13,'TolCon'...
    ,1e-13,'MaxIter',2000,'MaxFunEvals',3000);
 % Parameters initial guess 
    %p0 = [((LB + UB) / 2)'];
    p0=LB;

%without options
%p_opt = fmincon(@(p) objective_functionM3(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, []);
%with options    
% [params_m3fmin, errorOBJ] = fmincon(@(p) objective_functionM3(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);
% fprintf('params_m3fmin = [%s%.15f];\n', sprintf('%.15f; ', params_m3fmin(1:end-1),params_m3fmin(end)));

optionsfast = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*5, ...
    'MaxIterations', 2000, ...
    'MaxStallIterations', 10, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-5, ... %1e-15
    'Display', 'iter');

optionsmedium = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*50, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-12, ... %1e-15
    'Display', 'iter');

optionsslow = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*100, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 120, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 0.8, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-15, ... %1e-15
    'Display', 'iter');
options=optionsslow;
[params_m3pswarm, errorOBJ]= particleswarm(@(p) objective_functionM3(p, tspan, y0, y_inf_data,county),length(LB),LB,UB,options);
county_M3
errorOBJ
filename = "params_m3pswarm_" + county_M3 + ".mat";
save(filename, 'params_m3pswarm');
filename = "m3_RRMSE_" + county_M3 + ".mat";
save(filename, 'errorOBJ');

[params_m3pswarm_rss, rss]= particleswarm(@(p) objective_functionM3_RSS(p, tspan, y0, y_inf_data,county),length(LB),LB,UB,options);
fprintf('params_m3pswarm = [%s%.15f];\n', sprintf('%.15f; ', params_m3pswarm(1:end-1),params_m3pswarm(end)));
fprintf('params_m3pswarm_rss = [%s%.15f];\n', sprintf('%.15f; ', params_m3pswarm_rss(1:end-1),params_m3pswarm_rss(end)));
filename = "params_m3pswarm_rss_" + county_M3 + ".mat";
save(filename, 'params_m3pswarm_rss');
filename = "m3_RSS_" + county_M3 + ".mat";
save(filename, 'rss');

county_M3
errorOBJ
num_data_points = numel(y_inf_data);    % n
k = numel(LB);               % k

% Calculate AIC, AICc, BIC 
aic = num_data_points * log(rss / num_data_points) + 2 * k;
aicc = aic + (2 * k * (k + 1)) / (num_data_points - k - 1);
bic = num_data_points * log(rss / num_data_points) + k * log(num_data_points);

%Display Results
fprintf('Model 3 Information Criteria Results \n');
fprintf('RSS: %.4f\n', rss);
fprintf('AIC: %.4f\n', aic);
fprintf('AICc: %.4f\n', aicc);
fprintf('BIC: %.4f\n', bic);

options = odeset(...
                'RelTol', 1e-2, ...
                'AbsTol', 1e-4, ...
                'MaxStep', 1e-4, ...
                'InitialStep', 1e-3);

[t, ypswarm] = ode15s(@(t, y) M3_SF(t, y, params_m3pswarm), t_inf_data, y0, options);
 err_pswarm_m3 = (rmse(ypswarm(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;

% [t, yfmin] = ode15s(@(t, y) M3_SF(t, y, params_m3fmin), t_inf_data, y0, options);
% err_fmin_m3 = (rmse(yfmin(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;

y=ypswarm;
% if err_fmin_m3<err_pswarm_m3
%     y=yfmin;
% else
%     y=ypswarm;
% end

figure
scatter(t_inf_data,y_inf_data, 'b','LineWidth',1)
hold on
plot(t,y(:,7),'c','LineWidth',2.5)
%plot(t,ypswarm(:,7),'k','LineWidth',2)
legend('Maricopa Infected','FMin Model 2 fit','Pswarm Model 2 fit','Location','best');
title("Valley Fever Model 3 - Simple Fungal Growth Model -"+county_M3, 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
subtitle("Infected Fmin M2 RRMSE="+err_fmin_m3, 'FontSize', 14)
%subtitle("Infected Fmin M2 RRMSE="+err_fmin_m3+", Infected Pswarm M2 RRMSE="+err_pswarm_m3, 'FontSize', 14)
xlabel('Year', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
hold off


%plotting of results for specific params
 figure
plot(t,y(:,1), 'b','LineWidth',2)
hold on
plot(t,y(:,2),'c','LineWidth',2)
legend('Organic Matter','Decomposed Organic Matter','Location','best');
title("Valley Fever Model 3 - Simple Fungal Growth Model -"+county_M3, 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); ylabel('Mass', 'FontSize', 18)
hold off

figure
plot(t,ypswarm(:,3), 'r','LineWidth',2);
hold on
plot(t,ypswarm(:,4),'g','LineWidth',2)
plot(t,y(:,5), 'k','LineWidth',2);
legend('Hyphae Structure','Arthroconidia','Colonies','Location','best');
title("Valley Fever Model 3 - Simple Fungal Growth Model -"+county_M3, 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); ylabel('PPM', 'FontSize', 18)
hold off

figure
plot(t,y(:,6), 'color',[0.4660 0.6740 0.1880],'LineWidth',2);
hold on
plot(t,y(:,7),'color',[0.9290 0.4940 0.0250],'LineWidth',2);
plot(t,y(:,8), 'color',[.5 0 .5],'LineWidth',2);
legend('Susceptible','Infected','Recovered','Location','best');
title("Valley Fever Model 3 - Simple Fungal Growth Model -"+county_M3, 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); ylabel('Humans', 'FontSize', 18)
hold off

% figure
% plot(t_inf_data,y_inf_data_Maricopa,'color', [.55 .55 .55],'LineWidth',2);
% hold on
% plot(t_inf_data,80*[1;soil_mstr_data_Maricopa],'color', [.85 .85 .85],'LineWidth',2);
% plot(t_inf_data,8*[1;temp_data_Maricopa], 'b','LineWidth',2)
% legend('infected','Soil Moisture level','temp','Location','best');
% hold off


elseif single_run_or_fitting==3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Forecasting Model 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 3 Forecasting')

%import/load infected valley fever data
y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
    y_pop_data_Pinal=[394200;425264;484239;513862];
    y_pop_data_Pima=[1024000;1043433;1063162;1080149];
    y_pop_data_AZ=[6849647;7151502;7431344;7582384];
    t_pop_data=[1006-1006,3653-1006,4839-1006,5205-1006];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data_Pinal=[53.74285714;48.85714286;36.28571429;15.42857143;17.71428571;...
    34.14285714;33.57142857;30.57142857;35.42857143;25.42857143;34.14285714;...
    41.42857143;61;38.85714286;35.14285714;54.85714286;43.71428571;57.42857143;...
    40.14285714;27.42857143;33.42857143;28.14285714;22.28571429;30;33.57142857;...
    37;32;37.57142857;48.28571429;42.14285714;48.71428571;60.42857143;...
    68.71428571;71.28571429;78.85714286;73.14285714;56.85714286;47.85714286;...
    42.14285714;42.14285714;57.85714286;32.71428571;28.42857143;50.85714286;...
    30.71428571;26.42857143;42.71428571;47.85714286;49.28571429;47.42857143;...
    24.57142857;42;36.57142857;39.28571429;33.57142857;33.85714286;46.71428571;...
    26;46.85714286;64.71428571;85.42857143;65.57142857;34.85714286;36.57142857;...
    47.42857143;56.57142857;43;52.85714286;37.57142857;32;51.85714286;42.14285714;...
    63.57142857;52.14285714;57.57142857;66.57142857;56.71428571;75.71428571;...
    77.71428571;81.57142857;80;65.28571429;91.85714286;121.8571429;118;...
    83.28571429;71.71428571;36.28571429;45.85714286;71.42857143;77.57142857;...
    87.85714286;99.85714286;118;112.1428571;121.7142857;162.2857143;117.1428571;...
    99;105.8571429;76.57142857;62.57142857;58.14285714;73.71428571;62.42857143;...
    61.28571429;65.85714286;78.57142857;133.8571429;99.85714286;66.42857143;74;...
    69.71428571;79.28571429;73.85714286;95.28571429;49.28571429;50.85714286;...
    50.71428571;61.14285714;70.57142857;56.57142857;49;62.57142857;49.71428571;...
    57.57142857;59.57142857;100.5714286;93.85714286;77.57142857;106.4285714;...
    131.4285714;141.1428571];

y_inf_data_Pima=[128.0714286;116.4285714;70.57142857;42.28571429;62.57142857;...
    71.71428571;88.28571429;71.28571429;88.85714286;72.28571429;80.28571429;...
    106.4285714;137;82.28571429;91.85714286;77.28571429;81.57142857;82;80.42857143;...
    46.57142857;62;52.28571429;61;57.14285714;58.57142857;96;66;58.57142857;...
    71.28571429;75;148.1428571;115.7142857;112.8571429;146.2857143;114.1428571;...
    109.1428571;86.85714286;80.28571429;64.71428571;79.42857143;73.57142857;...
    79.57142857;73.28571429;75.85714286;55.71428571;68.14285714;60.71428571;...
    90;95.71428571;83.85714286;64.14285714;74.28571429;87.42857143;67;63.85714286;...
    105.4285714;75.85714286;58.14285714;82.42857143;128.5714286;146;90.42857143;...
    83.85714286;71.71428571;59.42857143;83.28571429;97.28571429;103.2857143;...
    87.71428571;76.28571429;76;75;62.71428571;85.71428571;111.8571429;127.5714286;...
    115.7142857;115.5714286;122;146.5714286;143;100.1428571;118.4285714;123.4285714;...
    131;101;110;92.57142857;82.57142857;102.8571429;122.2857143;125.2857143;...
    164.5714286;143.1428571;127.7142857;162.4285714;165.5714286;138.5714286;...
    138.2857143;140.7142857;88.14285714;110;104.5714286;117.7142857;84.28571429;...
    80.14285714;92.14285714;98.85714286;123.5714286;95.42857143;57.14285714;...
    83.85714286;83.57142857;112.2857143;113.8571429;139.7142857;100.5714286;...
    81.71428571;89.14285714;79;93.71428571;103.4285714;87.57142857;89;87.28571429;...
    100.5714286;104;109.4285714;115.2857143;93.42857143;113.4285714;132;134.5714286];

y_inf_data_AZ=[798.9142857;726.2857143;461.5714286;326;356.4285714;425;431.5714286;...
    431.4285714;463.7142857;401.1428571;489.7142857;682.1428571;696;564.8571429;...
    591.8571429;574;529.2857143;595;505.1428571;319.5714286;347.8571429;352.2857143;...
    325.7142857;338.8571429;435.5714286;410;380;432.5714286;517.4285714;471.7142857;...
    700.1428571;727.7142857;778.7142857;944.5714286;786.1428571;800;684;581.2857143;...
    464.1428571;574.4285714;529.1428571;459;454.8571429;483.2857143;495.4285714;...
    392.4285714;553;590;577;532.1428571;416;408.7142857;457.1428571;442.7142857;...
    417.2857143;522.8571429;522.2857143;444.8571429;643.4285714;953.8571429;...
    1184.714286;898.2857143;584.4285714;564.2857143;552;663;611;689.5714286;...
    609.8571429;538;622.7142857;523.4285714;630.4285714;745.5714286;658;811.4285714;...
    749.7142857;797.7142857;818.2857143;943.2857143;971;798.2857143;902.4285714;...
    1115.285714;1059;930;830;635.2857143;475.7142857;630.5714286;747.1428571;...
    800.2857143;1067.142857;1188.285714;1175.571429;1382.857143;1560.142857;...
    1323.285714;1113.428571;1147.285714;863.1428571;854.4285714;809;814.4285714;...
    810.7142857;736.7142857;842;1009.857143;1223.714286;952.8571429;673.5714286;...
    704.5714286;787;948.1428571;911.2857143;1072.571429;715.7142857;625.8571429;...
    617.1428571;691.2857143;759;704.4285714;615.2857143;773.5714286;702.4285714;...
    750.7142857;706;869.2857143;974.4285714;929.8571429;1126;1335;1417];

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];

alpha_h_maricopa= 0.000035386745035+0.049996054144265;
omega_maricopa= 0.049996054144265;

alpha_h_pinal= 0.000054197479825+0.049562154054803; %*use looser bounds
omega_pinal= 0.049562154054803; %*use looser bounds

alpha_h_pima= 0.000010637066754+0.050079359342677;
omega_pima= 0.050079359342677;

alpha_h_AZ= 0.002876562772732+0.058375000164113;
omega_AZ= 0.058375000164113;

y_pop_data=y_pop_data_Maricopa;
y_inf_data=y_inf_data_Maricopa;
county_M3=["Maricopa"];
alpha_h_b=alpha_h_maricopa;
omega_b=omega_maricopa;
tspan_8_1=t_inf_data(1:97,1);
tspan_8_1_F=t_inf_data(1:109,1);
tspan_8_2=t_inf_data(13:109,1);
tspan_8_2_F=t_inf_data(13:121,1);
tspan_8_3=t_inf_data(25:121,1);
tspan_8_3_F=t_inf_data(25:133,1);
tspan_11_years=t_inf_data;
y_inf_data_8_1=y_inf_data(1:97,1);
y_inf_data_8_2=y_inf_data(13:109,1);
y_inf_data_8_3=y_inf_data(25:121,1);
y_inf_data_8_4=y_inf_data(25:133,1);

%Initial Conditions
ic_O=40;
ic_D=70;
ic_H=100;%
ic_A=50;%100
ic_I=y_inf_data(1)/1;
ic_E=ic_I*1.5;%y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_E-ic_R);
y0=[ic_O;ic_D;ic_H;ic_A;ic_S;ic_E;ic_I;ic_R];

%Parameters
%NEED TO FILL IN

options = optimset('Algorithm','interior-point','TolX',1e-20,'TolFun',1e-20,'TolCon'...
    ,1e-20,'MaxIter',200000,'MaxFunEvals',100000);


 %FITTING OF MODEL 1 first 8 years
pool = gcp; % Will create a pool if none exists
numWorkers = pool.NumWorkers;
disp(numWorkers);
format long


% Parameters initial guess 
    p0 = [LB'];
    %p0 = [LB(1);LB(2);UB(3)];

   % p_opt = fmincon(@(p) objective_functionM1(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);
%     % Display optimized parameters
%     %fprintf('Optimized alpha_h: %.8f, omega: %.8f\n, N_max: %.8f\n', p_opt(1), p_opt(2),p_opt(3));
%     %fprintf('Optimized alpha_h: %.8f, omega: %.8f\n', p_opt(1), p_opt(2));
% params_m1fmin=p_opt;

options = optimoptions('particleswarm', ...
    'SwarmSize', length(LB)*10, ...
    'MaxIterations', 1000, ...
    'InertiaRange', [0.3, 1.2], ...
    'SelfAdjustmentWeight', 1.5, ...
    'SocialAdjustmentWeight', 2.0, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-10, ...
    'Display', 'iter');

options = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*3, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-15, ...
    'Display', 'iter');

[params_m3pswarm_8_1, errorOBJ8_1]= particleswarm(@(p) objective_functionM3(p, tspan_8_1, y0, y_inf_data_8_1),length(LB),LB,UB,options);
[t8_1, ypswarm_fit8_1] = ode23s(@M3_SF,tspan_8_1_F,y0,[],params_m3pswarm_8_1);
frst_year_forecast_rrmse=(rmse(ypswarm_fit8_1(98:109,4) , y_inf_data(98:109,1))/sqrt(sumsqr(y_inf_data(98:109,1)')))*100;
 
[params_m3pswarm_8_2, errorOBJ8_2]= particleswarm(@(p) objective_functionM3(p, tspan_8_2, y0, y_inf_data_8_2),length(LB),LB,UB,options);
[t8_2, ypswarm_fit8_2] = ode23s(@M3_SF,tspan_8_2_F,y0,[],params_m3pswarm_8_2);
scnd_year_forecast_rrmse=(rmse(ypswarm_fit8_2(98:109,4) , y_inf_data(110:121,1))/sqrt(sumsqr(y_inf_data(110:121,1)')))*100;
%scnd_year_forecast_rrmse=(rmse(ypswarm_fit8_2(110:121,4) , y_inf_data(110:121,1))/sqrt(sumsqr(y_inf_data(110:121,1)')))*100;

[params_m3pswarm_8_3, errorOBJ8_3]= particleswarm(@(p) objective_functionM3(p, tspan_8_3, y0, y_inf_data_8_3),length(LB),LB,UB,options);
[t8_3, ypswarm_fit8_3] = ode23s(@M3_SF,tspan_8_3_F,y0,[],params_m3pswarm_8_3);
thrd_year_forecast_rrmse=(rmse(ypswarm_fit8_3(98:109,4) , y_inf_data(122:133,1))/sqrt(sumsqr(y_inf_data(122:133,1)')))*100;
%thrd_year_forecast_rrmse=(rmse(ypswarm_fit_8_3(122:133,4) , y_inf_data(122:133,1))/sqrt(sumsqr(y_inf_data(122:133,1)')))*100;
size(ypswarm_fit8_2)
size(ypswarm_fit8_3)

fprintf('params_m1pswarm_8_1 = [%s%.15f];\n', sprintf('%.15f; ', params_m1pswarm_8_1(1:end-1),params_m1pswarm_8_1(end)));
fprintf('params_m1pswarm_8_2 = [%s%.15f];\n', sprintf('%.15f; ', params_m1pswarm_8_2(1:end-1),params_m1pswarm_8_2(end)));
fprintf('params_m1pswarm_8_3 = [%s%.15f];\n', sprintf('%.15f; ', params_m1pswarm_8_3(1:end-1),params_m1pswarm_8_3(end)));
frst_year_forecast_rrmse
scnd_year_forecast_rrmse
thrd_year_forecast_rrmse

%Display
figure
scatter(t_inf_data,y_inf_data, 'k','LineWidth',2)
hold on
plot(t8_1(1:97,1),ypswarm_fit8_1(1:97,4), 'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
plot(t8_1(97:109,1),ypswarm_fit8_1(97:109,4), 'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
plot(t8_2(97:109,1),ypswarm_fit8_2(97:109,4), 'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
plot(t8_3(97:109,1),ypswarm_fit8_3(97:109,4),'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
xline(2922, 'k','LineWidth',2)
xline(3287, 'k','LineWidth',2)
xline(3652, 'k','LineWidth',2)
legend(county_M3+' Infected','Model 3 fit', '2022 forecast','2023 forecast','2024 forecast','Location','best');
title(county_M3+" Valley Fever Model 3 Forecast", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
subtitle("Forecasted 2022 RRMSE="+frst_year_forecast_rrmse+"%, Forecasted 2023 RRMSE="+scnd_year_forecast_rrmse...
    +"%, Forecasted 2024 RRMSE="+thrd_year_forecast_rrmse+"%", 'FontSize', 14)
xlabel('Year', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
ylim([0,max(y_inf_data)+200])
hold off
end











































































elseif choose_model==4
%% Model 4 - Vector and Fungal Model dependent on Food and Environment
if single_run_or_fitting==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %SINGLE RUN Model 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 4 single parameter run')
t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];

y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
y_pop_data_Pinal=[394200;425264;484239;513862];
y_pop_data_Pima=[1024000;1043433;1063162;1080149];
y_pop_data_AZ=[6849647;7151502;7431344;7582384];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data=y_inf_data_Maricopa;
y_pop_data=y_pop_data_Maricopa;

%Initial Conditions
ic_V_j=50;
ic_V_a=100;
ic_O=100;
ic_D=50;
ic_H=100;%
ic_A=50;%100
ic_C=5;
ic_I=y_inf_data(1)/1;
ic_E=ic_I/2;%y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_E-ic_R);

y0=[ic_V_j;ic_V_a;ic_O;ic_D;ic_H;ic_A;ic_C;ic_S;ic_E;ic_I;ic_R];

%Parameters
% alpha_h_maricopa= 0.450004027248630;
% omega_maricopa= 0.449968571859412;
PI=10; delta_O=0.04; mu_H=0.0001;
gamma_H=0.0000005; H_max=300; delta_H=0.000004;
gamma_A=0.009; delta_A=0.006; phi_A=0.0000005;
delta_C=0.00002; T_opt_H=75; T_opt_A=86;
%S_opt_H=80; S_opt_A=80; T_decay=60;
S_opt_H=13; S_opt_A=9; T_decay=60;
bl_Topt_A=500; ab_Topt_A=70; bl_Topt_H=500; 
ab_Topt_H=70; bl_Sopt_A=15; ab_Sopt_A=4; 
bl_Sopt_H=15; ab_Sopt_H=4; T_hs=78.989;
beta=0.0123; mu_V=0.005; delta_V_j=0.0021;
delta_V_a=0.0015; sigma=0.00000000007; T_cs=68.989;

alpha=0.000002;  S_d_s=20; T_d_s=90; 
bl_S_H_s=2; ab_T_H_s=1; xtr_c_s=10; delta_R=0; 
epsilon=0.0000067; rho=0.008; kappa=0.00003; psi=0.0035;%psi=0.00033;
epsilon=0.0000097; rho=0.01; kappa=0.0001;
%epsilon=0.00000085;
alpha_h=alpha_h_maricopa;
omega=omega_maricopa;
%below for low vector input option
  % alpha=0.000004;
  % phi_A=0.000016;
 
paramsm4=[PI; delta_O; mu_H; gamma_H; H_max; delta_H; gamma_A; delta_A; ...
    phi_A; delta_C; T_opt_H; T_opt_A; S_opt_H; S_opt_A; T_decay; bl_Topt_A; ...
    ab_Topt_A; bl_Topt_H; ab_Topt_H; bl_Sopt_A; ab_Sopt_A; bl_Sopt_H; ...
    ab_Sopt_H; T_hs; beta; mu_V; delta_V_j; delta_V_a; sigma; T_cs; alpha; ...
    S_d_s; T_d_s; xtr_c_s; alpha_h; delta_R; epsilon; omega; rho; kappa; psi];

%paramsm4 = [10.0000000; 0.0400000; 0.0001000; 0.0000005; 350.0000000; 0.0000040; 0.0100000; 0.0040000; 0.0000005; 0.0000200; 75.0000000; 90.0000000; 13.0000000; 8.0000000; 60.0000000; 500.0000000; 70.0000000; 500.0000000; 70.0000000; 15.0000000; 4.0000000; 15.0000000; 4.0000000; 78.0000000; 0.0123000; 0.0050000; 0.0150000; 0.0010000; 0.0000000; 68.0000000; 0.0000020; 20.0000000; 90.0000000; 10.0000000; 0.1000000; 0.0000000; 0.0000050; 0.0999645; 0.0040000; 0.0000300; 0.0035000];
paramsm4 = [10.000000000000000; 0.040000000000000; 0.045000550000000; 0.000022555000000; 300.990000000000009; 0.000180550000000; 0.009000000000000; 0.006000000000000; 0.000004555000000; 0.001350550000000; 75.000000000000000; 86.000000000000000; 12.010000000000000; 9.000000000000000; 60.000000000000000; 500.000000000000000; 70.000000000000000; 500.000000000000000; 70.000000000000000; 15.000000000000000; 4.000000000000000; 15.000000000000000; 4.000000000000000; 78.989000000000004; 0.034485000000000; 0.005000000000000; 0.002100000000000; 0.001500000000000; 0.000000342500000; 68.989000000000004; 0.000005050000000; 20.000000000000000; 95.000000000000000; 2.000000000000000; 0.100000000000000; 0.000000000000000; 0.000006700000000; 0.099964544635737; 0.008000000000000; 0.000030000000000; 0.003500000000000]; 
paramsm4 = [10; 0.0399; 0.0734704723261341; 1.6297462413376e-05; 300; 1e-06; 0.00233980915614813; 0.0031515394555909; 1.31931673796826e-05; 0.000906357944535358; 77; 90; 13; 8.01604347403556; 59; 500; 80; 500; 80; 20; 4; 16; 5; 78; 0.0616; 0.0109865428702115; 0.0100571260997864; 0.00142639789896519; 7e-11; 70; 3e-05; 20; 95; 2;alpha_h; delta_R; epsilon; omega; rho; kappa; psi];
 %ode run

 options = odeset(...
                'RelTol', 1e-2, ...
                'AbsTol', 1e-5, ...
                'MaxStep', 0.5, ...
                'InitialStep', 1e-6);
 try
     [t, y] = ode15s(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0, options);
     err_m4 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
     err_m4_A = (rmse(y(:,6) , y_inf_data/11.308)/sqrt(sumsqr(y_inf_data/11.308')))*100;
    catch 
     try
         [t, y] =ode15s(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
         err_m4 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
         err_m4_A = (rmse(y(:,6) , y_inf_data/11.308)/sqrt(sumsqr(y_inf_data/11.308')))*100;
     catch
         try
            [t, y] = ode23s(@M4_SF,t_inf_data,y0,[],paramsm4);
            err_m4 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
            err_m4_A = (rmse(y(:,6) , y_inf_data/11.308)/sqrt(sumsqr(y_inf_data/11.308')))*100;
         catch
             try
                 [t, y] =ode45(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
                 err_m4 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
                 err_m4_A = (rmse(y(:,6) , y_inf_data/11.308)/sqrt(sumsqr(y_inf_data/11.308')))*100;
             catch
                 try
                     [t, y] =ode78(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
                     err_m4 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
                     err_m4_A = (rmse(y(:,6) , y_inf_data/11.308)/sqrt(sumsqr(y_inf_data/11.308')))*100;
                 catch
                     disp('nothing worked')
                 end
             end
         end
     end
 end
 [t, y] =ode15s(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
                     err_m4 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
                     err_m4_A = (rmse(y(:,6) , y_inf_data/11.308)/sqrt(sumsqr(y_inf_data/11.308')))*100;
%[t, y] =ode15s(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
%[t, y] = ode23s(@M4_SF,t_inf_data,y0,[],paramsm4);
%[t, y] =ode45(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
%[t, y] =ode78(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
%err_m4 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;


fprintf('y_inf_data_M4_L = [%s%.4f];\n', sprintf('%.4f; ', y(1:end-1,10),y(end,10)));
disp('space')
fprintf('Parameters_M4_L_infdata = [%s%.7f];\n', sprintf('%.7f; ', paramsm4(1:end-1),paramsm4(end)));
disp('space')
 %plotting results

%  plot(t,40*sin(((2*pi)/365)*t)+70,'color', [.55 .55 .55],'LineWidth',2);
% hold on
% plot(t,49*sin(((2*pi)/365)*t-(pi/8))+50,'color', [.85 .85 .85],'LineWidth',2);

figure
plot(t,y(:,1),'color', [0.4940 0.1840 0.5560],'LineWidth',2)
hold on
plot(t,y(:,2),'color', [0.9290 0.6940 0.1250],'LineWidth',2)
legend('Juvenile vector','Adult vector','FontSize', 16,'Location','best');
title("Valley Fever Model 4 - Vector and Fungal Model dependent on Food and Environmentn Food & Env.", 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); %ylabel('Infected Humans', 'FontSize', 18)
hold off

figure
plot(t,y(:,3),'b','LineWidth',2)
hold on
plot(t,y(:,4),'c','LineWidth',2)
legend('Organic Matter','Decayed Organic Matter','FontSize', 16,'Location','best');
title("Valley Fever Model 4 - Vector and Fungal Model dependent on Food and Environmentn Food & Env.", 'FontSize', 22)
xticks(t_inf_data)
% xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
% xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); %ylabel('Infected Humans', 'FontSize', 18)
hold off

% plot(t,40*sin(((2*pi)/365)*t)+70,'color', [.55 .55 .55],'LineWidth',2);
% hold on
% plot(t,49*sin(((2*pi)/365)*t-(pi/8))+50,'color', [.85 .85 .85],'LineWidth',2);
figure
plot(t,y(:,5),'r','LineWidth',2)
hold on
scatter(t_inf_data,y_inf_data/11.308,'k','LineWidth',4)
plot(t,y(:,6),'g','LineWidth',2)
plot(t,y(:,7),'k','LineWidth',2)
legend('Hyphae','INF DATA S','Arthroconidia','Colonies', 'FontSize', 16,'Location','best');
title("Valley Fever Model 4 - Vector and Fungal Model dependent on Food & Environment", 'FontSize', 22)
subtitle("A to Infected Manual M4 RRMSE="+err_m4_A, 'FontSize', 14)
xticks(t_inf_data)
 %xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
 %xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); %ylabel('Infected Humans', 'FontSize', 18)
hold off

figure
plot(t,y(:,8),'r','LineWidth',8)
hold on
scatter(t_inf_data,y_inf_data,'k','LineWidth',4)
plot(t,y(:,9),'g','LineWidth',2)
plot(t,y(:,10),'color','[0.9290 0.4940 0.0250]','LineWidth',4)
plot(t,y(:,11),'color','[0.5 0 0.5]','LineWidth',2)
legend('Susceptible','INF DATA','Exposed','Infected','Recovered', 'FontSize', 16,'Location','best');
title("Valley Fever Model 4 - Vector and Fungal Model dependent on Food & Environment", 'FontSize', 24)
%xticks(t_inf_data)
subtitle("Infected Manual M4 RRMSE="+err_m4, 'FontSize', 14)
 xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
 xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 corresponds to Jan. 1 2013)', 'FontSize', 18); ylabel('Humans', 'FontSize', 18)
ylim([0,max(y_inf_data)+200])
hold off

elseif single_run_or_fitting==2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %FITTING Model 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 4 fitting')


%FITTING Rest of model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global alpha_h_maricopa omega_maricopa alpha_h_pinal omega_pinal alpha_h_pima omega_pima alpha_h_AZ omega_AZ
alpha_h_maricopa= 0.100000000000000;
omega_maricopa= 0.099964544635737;

alpha_h_pinal= 0.523722881592193;
omega_pinal= 0.523668500791642;

alpha_h_pima= 0.549960930484127;
omega_pima= 0.549950278540836;

alpha_h_AZ= 0.450001858189107;
omega_AZ= 0.449980082263301;

%import/load data
y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
y_pop_data_Pinal=[394200;425264;484239;513862];
y_pop_data_Pima=[1024000;1043433;1063162;1080149];
y_pop_data_AZ=[6849647;7151502;7431344;7582384];

y_inf_data_M3 = [565.4000; 519.8575; 485.2660; 465.8198; 487.7699; 525.5188;...
    516.7577; 446.5856; 382.6769; 361.0844; 370.0199; 356.7920; 318.1038; 279.9563;...
    260.5350; 255.4542; 270.6854; 308.5878; 327.5052; 291.9672; 265.5735; 263.8109;...
    283.6015; 292.1168; 270.3663; 245.6302; 239.1856; 262.2852; 305.5375; 371.3543;...
    416.5866; 389.5976; 339.3500; 316.6599; 356.8109; 368.4380; 332.4096; 293.4082;...
    283.6469; 309.8186; 359.7507; 441.4611; 475.8249; 411.5339; 362.0929; 380.2990;...
    440.8480; 475.1749; 450.5188; 403.3595; 376.4233; 399.0404; 465.1526; 567.6683;...
    601.8666; 528.5114; 458.0475; 457.1492; 522.2826; 571.3812; 559.2320; 527.2236;...
    500.5032; 492.8898; 560.5447; 683.5938; 743.4060; 663.4207; 571.8429; 524.2526;...
    562.9474; 561.8674; 515.3480; 460.9592; 414.4991; 397.1376; 463.6695; 574.7818;...
    684.1510; 630.2470; 534.9803; 512.3557; 590.4420; 626.4037; 585.7906; 529.8379;...
    494.4158; 487.6633; 550.9907; 694.8114; 768.8444; 681.7101; 564.2825; 505.6323;...
    573.3197; 633.3811; 601.6797; 545.2988; 514.0832; 515.3228; 598.2248; 769.2416;...
    821.1038; 736.3914; 661.1709; 660.5151; 742.0320; 800.2969; 782.0300; 712.9837;...
    660.1282; 655.3970; 750.3268; 930.0272; 991.0247; 870.7617; 764.5449; 737.7196; ...
    815.8845; 812.5960; 727.6840; 637.3708; 572.7986; 538.5345; 598.7061; 778.1068;...
    980.6339; 922.6798; 773.2168; 754.6097; 878.1268; 953.2340; 914.9414];
Parameters_M3_infdata = [10; 0.04; 0.0001; 0.0000005; 350; 0.004; 0.013; 0.007; 0.00014;...
    0.00001; 75; 80; 13; 9; 60; 500; 70; 500; 70; 2000; 500; 2000; 500; 0.1; 0; 0.0000008;...
    0.0999645; 0.04; 0.0003; 0.0350000];

y_inf_data_M4_H = [565.4000; 484.6776; 379.9193; 323.7861; 337.3630; 388.8590;...
    375.1688; 274.3422; 199.7913; 193.0827; 274.7701; 359.5176; 360.4418; 330.0110;...
    311.9625; 309.4805; 363.9974; 472.7156; 496.1758; 374.6108; 302.1442; 320.3797;...
    462.8382; 556.1419; 490.4002; 419.6715; 420.9039; 485.8640; 563.6198; 691.6560;...
    769.8842; 624.0656; 447.9058; 352.5659; 415.8092; 475.3897; 403.5080; 326.8699;...
    339.7929; 394.4852; 442.7271; 582.2806; 618.2799; 440.4189; 317.0404; 320.5114;...
    425.7579; 533.1254; 519.3265; 447.7100; 440.4594; 578.1206; 729.9124; 891.4659;...
    867.0022; 627.5326; 456.4217; 430.7258; 506.1453; 572.6615; 519.9117; 441.7858;...
    388.9673; 382.2385; 486.3850; 657.4191; 706.9669; 537.2639; 396.4226; 347.6900;...
    455.0813; 561.0610; 514.2553; 427.1838; 360.2147; 392.6405; 619.4749; 885.2239;...
    1073.1803; 843.0006; 573.1635; 454.2075; 549.9162; 637.3437; 591.9634; 510.8235;...
    467.5357; 501.8890; 706.8268; 1068.3942; 1154.1828; 848.7328; 549.3736; 373.6261;...
    308.9066; 333.6196; 320.9004; 291.3489; 300.6668; 343.7304; 479.8184; 688.2458;...
    683.3137; 514.9529; 414.0102; 439.8631; 620.3536; 752.1163; 699.1893; 580.8283;...
    496.2474; 483.6609; 581.3708; 759.2098; 757.1273; 553.7932; 419.2136; 411.6657;...
    580.3953; 633.2957; 533.5933; 434.7644; 386.8536; 407.2316; 614.9031; 1000.9729;...
    1302.1827; 1045.0138; 688.6289; 517.9942; 527.0878; 579.1234; 547.1715]; 
Parameters_M4_H_infdata = [10; 0.04; 0.0001; 0.000005; 350; 0.00004; 0.015; 0.015;...
    0.000001; 0.002; 75; 80; 13; 9; 60; 500; 70; 500; 70; 2000; 500; 2000; 500;...
    78; 0.009; 0.005; 0.003; 0.001; 0.00000000007; 68; 0.000004; 20; 90; 10; 0.1;...
    0; 0.0000009; 0.0999645; 0.04; 0.0003; 0.035];   

y_inf_data_M4_L = [565.4000; 484.6778; 379.9237; 323.8714; 337.8525; 390.4854; 377.4997;...
    276.2456; 201.3889; 195.2182; 278.7260; 365.6431; 366.1778; 334.9245; 317.0433;...
    314.1613; 368.5771; 481.7026; 506.0950; 381.9997; 308.4561; 327.5171; 473.8632;...
    569.1278; 500.9063; 428.5060; 428.5738; 494.1927; 573.9778; 704.9031; 782.1617;...
    633.0728; 455.3144; 356.7378; 424.0729; 485.9384; 413.4151; 334.9955; 346.8472;...
    402.9362; 452.3563; 595.5478; 632.4874; 451.2280; 324.3932; 327.8136; 436.4143;...
    547.4870; 532.2415; 458.2093; 449.4405; 588.3086; 742.0425; 907.3434; 882.5552;...
    638.3317; 462.8608; 438.0646; 516.9367; 585.0903; 531.8608; 453.0883; 398.4078;...
    392.1901; 498.0413; 670.1566; 722.0980; 548.4279; 404.4533; 354.4614; 464.2854;...
    573.8986; 524.2910; 434.4626; 365.8617; 399.5863; 628.5858; 894.6879; 1085.5108;...
    853.2617; 580.1164; 461.9835; 556.2147; 645.9654; 599.6342; 517.7825; 473.1477;...
    506.7621; 714.6979; 1078.5300; 1160.3908; 856.1288; 553.7944; 376.5206; 312.1468;...
    341.1071; 329.8913; 300.4139; 309.1720; 350.9038; 488.7515; 698.8364; 693.1135;...
    522.1668; 418.5632; 445.6494; 629.4382; 765.9487; 708.9598; 587.7889; 502.1103;...
    489.7641; 590.3310; 770.2052; 769.2848; 562.9029; 426.0917; 418.5113; 590.6432;...
    644.0543; 542.1916; 441.4040; 392.4104; 412.0749; 621.7799; 1007.9473; 1315.8626;...
    1053.8878; 693.0149; 523.1043; 533.6717; 588.7009; 557.3218]; 
Parameters_M4_L_infdata = [10; 0.04; 0.0001; 0.000005; 350; 0.00004; 0.015; 0.015;...
    0.000016; 0.002; 75; 80; 13; 9; 60; 500; 70; 500; 70; 2000; 500; 2000; 500; 78;...
    0.009; 0.005; 0.003; 0.001; 0.00000000007; 68; 0.000004; 20; 90; 10; 0.1; 0;...
    0.0000009; 0.0999645; 0.04; 0.0003; 0.035]; 

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data_Pinal=[53.74285714;48.85714286;36.28571429;15.42857143;17.71428571;...
    34.14285714;33.57142857;30.57142857;35.42857143;25.42857143;34.14285714;...
    41.42857143;61;38.85714286;35.14285714;54.85714286;43.71428571;57.42857143;...
    40.14285714;27.42857143;33.42857143;28.14285714;22.28571429;30;33.57142857;...
    37;32;37.57142857;48.28571429;42.14285714;48.71428571;60.42857143;...
    68.71428571;71.28571429;78.85714286;73.14285714;56.85714286;47.85714286;...
    42.14285714;42.14285714;57.85714286;32.71428571;28.42857143;50.85714286;...
    30.71428571;26.42857143;42.71428571;47.85714286;49.28571429;47.42857143;...
    24.57142857;42;36.57142857;39.28571429;33.57142857;33.85714286;46.71428571;...
    26;46.85714286;64.71428571;85.42857143;65.57142857;34.85714286;36.57142857;...
    47.42857143;56.57142857;43;52.85714286;37.57142857;32;51.85714286;42.14285714;...
    63.57142857;52.14285714;57.57142857;66.57142857;56.71428571;75.71428571;...
    77.71428571;81.57142857;80;65.28571429;91.85714286;121.8571429;118;...
    83.28571429;71.71428571;36.28571429;45.85714286;71.42857143;77.57142857;...
    87.85714286;99.85714286;118;112.1428571;121.7142857;162.2857143;117.1428571;...
    99;105.8571429;76.57142857;62.57142857;58.14285714;73.71428571;62.42857143;...
    61.28571429;65.85714286;78.57142857;133.8571429;99.85714286;66.42857143;74;...
    69.71428571;79.28571429;73.85714286;95.28571429;49.28571429;50.85714286;...
    50.71428571;61.14285714;70.57142857;56.57142857;49;62.57142857;49.71428571;...
    57.57142857;59.57142857;100.5714286;93.85714286;77.57142857;106.4285714;...
    131.4285714;141.1428571];

y_inf_data_Pima=[128.0714286;116.4285714;70.57142857;42.28571429;62.57142857;...
    71.71428571;88.28571429;71.28571429;88.85714286;72.28571429;80.28571429;...
    106.4285714;137;82.28571429;91.85714286;77.28571429;81.57142857;82;80.42857143;...
    46.57142857;62;52.28571429;61;57.14285714;58.57142857;96;66;58.57142857;...
    71.28571429;75;148.1428571;115.7142857;112.8571429;146.2857143;114.1428571;...
    109.1428571;86.85714286;80.28571429;64.71428571;79.42857143;73.57142857;...
    79.57142857;73.28571429;75.85714286;55.71428571;68.14285714;60.71428571;...
    90;95.71428571;83.85714286;64.14285714;74.28571429;87.42857143;67;63.85714286;...
    105.4285714;75.85714286;58.14285714;82.42857143;128.5714286;146;90.42857143;...
    83.85714286;71.71428571;59.42857143;83.28571429;97.28571429;103.2857143;...
    87.71428571;76.28571429;76;75;62.71428571;85.71428571;111.8571429;127.5714286;...
    115.7142857;115.5714286;122;146.5714286;143;100.1428571;118.4285714;123.4285714;...
    131;101;110;92.57142857;82.57142857;102.8571429;122.2857143;125.2857143;...
    164.5714286;143.1428571;127.7142857;162.4285714;165.5714286;138.5714286;...
    138.2857143;140.7142857;88.14285714;110;104.5714286;117.7142857;84.28571429;...
    80.14285714;92.14285714;98.85714286;123.5714286;95.42857143;57.14285714;...
    83.85714286;83.57142857;112.2857143;113.8571429;139.7142857;100.5714286;...
    81.71428571;89.14285714;79;93.71428571;103.4285714;87.57142857;89;87.28571429;...
    100.5714286;104;109.4285714;115.2857143;93.42857143;113.4285714;132;134.5714286];

y_inf_data_AZ=[798.9142857;726.2857143;461.5714286;326;356.4285714;425;431.5714286;...
    431.4285714;463.7142857;401.1428571;489.7142857;682.1428571;696;564.8571429;...
    591.8571429;574;529.2857143;595;505.1428571;319.5714286;347.8571429;352.2857143;...
    325.7142857;338.8571429;435.5714286;410;380;432.5714286;517.4285714;471.7142857;...
    700.1428571;727.7142857;778.7142857;944.5714286;786.1428571;800;684;581.2857143;...
    464.1428571;574.4285714;529.1428571;459;454.8571429;483.2857143;495.4285714;...
    392.4285714;553;590;577;532.1428571;416;408.7142857;457.1428571;442.7142857;...
    417.2857143;522.8571429;522.2857143;444.8571429;643.4285714;953.8571429;...
    1184.714286;898.2857143;584.4285714;564.2857143;552;663;611;689.5714286;...
    609.8571429;538;622.7142857;523.4285714;630.4285714;745.5714286;658;811.4285714;...
    749.7142857;797.7142857;818.2857143;943.2857143;971;798.2857143;902.4285714;...
    1115.285714;1059;930;830;635.2857143;475.7142857;630.5714286;747.1428571;...
    800.2857143;1067.142857;1188.285714;1175.571429;1382.857143;1560.142857;...
    1323.285714;1113.428571;1147.285714;863.1428571;854.4285714;809;814.4285714;...
    810.7142857;736.7142857;842;1009.857143;1223.714286;952.8571429;673.5714286;...
    704.5714286;787;948.1428571;911.2857143;1072.571429;715.7142857;625.8571429;...
    617.1428571;691.2857143;759;704.4285714;615.2857143;773.5714286;702.4285714;...
    750.7142857;706;869.2857143;974.4285714;929.8571429;1126;1335;1417];

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];

y_inf_data=y_inf_data_Maricopa;
y_pop_data=y_pop_data_Maricopa;

%Initial Conditions
ic_V_j=50;
ic_V_a=100;
ic_O=100;
ic_D=50;
ic_H=100;
ic_A=100;%100
ic_C=5;
ic_I=y_inf_data(1);
ic_S=(y_pop_data(1)-ic_I)*0.999;
ic_E=y_inf_data(1);
ic_R=y_inf_data(1);
y0=[ic_V_j;ic_V_a;ic_O;ic_D;ic_H;ic_A;ic_C;ic_S;ic_E;ic_I;ic_R];

% params2=[PI;           delta_O;      mu_H;
% gamma_H;      H_max;        delta_H;
% gamma_A;      delta_A;      phi_A;
% delta_C;     T_opt_H;     T_opt_A;
% S_opt_H;     S_opt_A;     T_decay;
% bl_Topt_A;   ab_Topt_A;   bl_Topt_H; 
% ab_Topt_H;   bl_Sopt_A;   ab_Sopt_A; 
% bl_Sopt_H;   ab_Sopt_H;   T_hs;
% beta;        mu_V;        delta_V_j;
% delta_V_a;   sigma;       T_cs; 
% alpha;       S_d_s;       T_d_s; 
% xtr_c_s;
% alpha_h;      delta_R;  epsilon;     
% omega=params(38);        rho;     kappa;
% psi];

%Parameter Ranges
alpha_h_b=alpha_h_maricopa;
omega_b=omega_maricopa;

% PI                   % delta_O             %mu_H
LB(1) = 2;           LB(2) = 0.0003;      LB(3) = 0.000001;        
UB(1) = 20;        UB(2) = 0.3;           UB(3) = 0.1;

% gamma_h            % H_max                %delta_H
LB(4) =  0.00000001;    LB(5) = 200;       LB(6) = 0.000001;        
UB(4) = 0.06;          UB(5) = 600;   UB(6) = 0.06;

% gamma_A            % delta_A              %phi_A
LB(7) = 0.000001;   LB(8) = 0.000001;    LB(9) = 0.0000001;        
UB(7) = 0.05;           UB(8) = 0.06;          UB(9) = 0.00001;

% delta_C            %T_opt_H                  %T_opt_A
LB(10) = 0.0000001;    LB(11) = 77;      LB(12) = 77;      
UB(10) = 0.001;           UB(11) = 90;        UB(12) = 90; 

% S_opt_H            %S_opt_A                  %T_decay
LB(13) = 10;       LB(14) = 7;      LB(15) = 60;      
UB(13) = 13;          UB(14) = 10;        UB(15) = 80; 

% bl_Topt_A            %ab_Topt_A                  %bl_Topt_H
LB(16) = 10;         LB(17) = 4;      LB(18) = 10;      
UB(16) = 500;        UB(17) = 70;        UB(18) = 500;

% ab_Topt_H            %bl_Sopt_A                  %ab_Sopt_A
LB(19) = 4;         LB(20) = 0.1;      LB(21) = 0.1;      
UB(19) = 70;           UB(20) = 8;        UB(21) = 7;

% bl_Sopt_H           %ab_Sopt_H           %T_hs       
LB(22) = 0.1;       LB(23) = 0.1;       LB(24) = 75;
UB(22) = 8;           UB(23) = 7;         UB(24) = 85;

% beta;                 %mu_V;              %delta_V_j;      
LB(25) = 0.0123;       LB(26) = 0.001;       LB(27) = 0.00015;
UB(25) = 0.0616;           UB(26) = 0.8;         UB(27) = 0.015;

% delta_V_a;            %sigma;                     %T_cs;        
LB(28) = 0.00008;       LB(29) = 0.00000000001;       LB(30) = 55;
UB(28) = 0.008;         UB(29) = 0.00000000007;        UB(30) = 75;

% alpha;                %S_d_s;%Fit later          T_d_s; %Fit later     
LB(31) = 0.0000001;       LB(32) = 10;       LB(33) = 95;
                         %20up/down for %32 when fit to synth data
UB(31) = 0.0001;           UB(32) = 14;         UB(33) = 95;

% xtr_c_s;               
LB(34) = 0;     
UB(34) = 8;           


% alpha_h            % delta_R                %epsilon
LB(35) = alpha_h_b;    LB(36) = 0;          LB(37) = 0.0000001;        
UB(35) = alpha_h_b;    UB(36) = 0;          UB(37) = 0.00001;

% omega                             % rho                %kappa
LB(38) = omega_b*0.999999;          LB(39) = 1/365;    LB(40) = 0.000000027768;        
UB(38) = omega_b*1.000001;    UB(39) = 1/14;    UB(40) = 0.000359; 

% psi          
LB(41) = 1/28;       
UB(41) = 1/7;     

%FITTING
tspan=t_inf_data;
% pool = gcp; % Will create a pool if none exists
% numWorkers = pool.NumWorkers;
% disp(numWorkers);
format long
'OutputFcn', @myOutputFcn, ...

  options = optimset('Algorithm','interior-point','TolX',1e-20,'TolFun',1e-20,'TolCon'...
    ,1e-20,'MaxIter',200000,'MaxFunEvals',100000);
 % options = optimoptions("fmincon",...
 %    Algorithm="interior-point",...
 %    EnableFeasibilityMode=true,...
 %    SubproblemAlgorithm="cg");

 options = optimoptions('fmincon', ...
    'UseParallel', true, ...
    'Algorithm','interior-point',...
    'TolX',1e-20,...
    'TolFun',1e-20,...
    'TolCon',1e-20,...
    'MaxIter',200000,...
    'MaxFunEvals',100000,...
    'Display', 'iter');

 options = optimoptions('fmincon', ...
    'UseParallel', true, ...
    'Algorithm', 'interior-point', ...
    'Display', 'iter-detailed', ...
    'MaxFunctionEvaluations', 1e5, ...
    'StepTolerance', 1e-8);
  
 options = optimoptions('fmincon', ...
    'Algorithm', 'interior-point', ...
    'Display', 'iter-detailed', ...
    'MaxFunctionEvaluations', 1e5, ...
    'StepTolerance', 1e-8);

 options = optimset('Algorithm','interior-point','TolX',1e-13,'TolFun',1e-13,'TolCon'...
    ,1e-13,'MaxIter',2000,'MaxFunEvals',3000);
 % Parameters initial guess 
    %p0 = [((LB + UB) / 2)'];
    p0=[(LB+Parameters_M4_H_infdata+Parameters_M4_H_infdata)/3];

%without options
%p_opt = fmincon(@(p) objective_functionM4(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, []);
%with options    
p_opt = fmincon(@(p) objective_functionM4(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);
% 
%     % Display optimized parameters
params_m4fmin=p_opt
fprintf('params_m4fmin = [%s%.15f];\n', sprintf('%.15f; ', params_m4fmin(1:end-1),params_m4fmin(end)));


% options = optimoptions('particleswarm', ...
%     'UseParallel', true, ... 
%     'OutputFcn', @myOutputFcn, ...
%     'SwarmSize', numWorkers*6, ...
%     'MaxIterations', 1000, ...
%     'InertiaRange', [0.3, 1.2], ...
%     'SelfAdjustmentWeight', 1.5, ...
%     'SocialAdjustmentWeight', 2.0, ...
%     'HybridFcn', @fmincon, ...
%     'FunctionTolerance', 1e-10, ...
%     'Display', 'iter');
% % options = optimoptions('particleswarm', ...
% %     'UseParallel', true, ... 
% %     'OutputFcn', @myOutputFcn, ...
% %     'SwarmSize', numWorkers*6, ...
% %     'MaxIterations', 1000, ...
% %     'Display', 'iter');

%options = optimoptions('particleswarm','Display', 'iter');
%p_opt= particleswarm(@(p) objective_functionM4(p, tspan, y0, y_inf_data),length(LB),LB,UB,options);
%params_m4pswarm=p_opt
%fprintf('params_m4pswarm = [%s%.15f];\n', sprintf('%.15f; ', params_m4pswarm(1:end-1),params_m4pswarm(end)));

options = odeset(...
                'RelTol', 1e-2, ...
                'AbsTol', 1e-4, ...
                'MaxStep', 1e-4, ...
                'InitialStep', 1e-3);


% [t, ypswarm] = ode15s(@(t, y) M4_SF(t, y, params_m4pswarm), t_inf_data, y0, options);
%  err_pswarm_m4 = (rmse(ypswarm(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;

[t, yfmin] = ode15s(@(t, y) M4_SF(t, y, params_m4fmin), t_inf_data, y0, options);
err_fmin_m4 = (rmse(yfmin(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;

county_M4=["Maricopa"];
figure
scatter(t_inf_data,y_inf_data, 'b','LineWidth',1)
hold on
plot(t,yfmin(:,10),'c','LineWidth',2.5)
%plot(t,ypswarm(:,10),'k','LineWidth',2)
legend('Maricopa Infected','FMin Model 4 fit','Location','best');
legend('Maricopa Infected','FMin Model 4 fit','Pswarm Model 4 fit','Location','best');
title("Valley Fever Model 4  -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
subtitle("Infected Fmin M4 RRMSE="+err_fmin_m4, 'FontSize', 14)
%subtitle("Infected Fmin M4 RRMSE="+err_fmin_m4+", Infected Pswarm M4 RRMSE="+err_pswarm_m4, 'FontSize', 14)
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
ylim([0 max(y_inf_data)+200])
hold off

y=yfmin;
% if err_fmin_m4<err_pswarm_m4
%     y=yfmin;
% else
%     y=ypswarm;
% end

%plotting of results for specific params 
 figure
plot(t,y(:,1), 'b','LineWidth',2)
hold on
plot(t,y(:,2),'c','LineWidth',2)
legend('Juvenile Vector','Adult Vector','Location','best');
title("Valley Fever Model 4 - Vector/Fungal Model dependent on Food & Env. -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('Mass', 'FontSize', 18)
hold off

figure
plot(t,y(:,3), 'b','LineWidth',2)
hold on
plot(t,y(:,4),'c','LineWidth',2)
legend('Organic Matter','Decomposed Organic Matter','Location','best');
title("Valley Fever Model 4 - Vector/Fungal Model dependent on Food & Env. -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('Mass', 'FontSize', 18)
hold off

figure
plot(t,ypswarm(:,5), 'r','LineWidth',2);
hold on
plot(t,ypswarm(:,6),'g','LineWidth',2)
plot(t,y(:,7), 'k','LineWidth',2);
legend('Hyphae Structure','Arthroconidia','Colonies','Location','best');
title("Valley Fever Model 4 - Vector/Fungal Model dependent on Food & Env. -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('PPM', 'FontSize', 18)
hold off

figure
plot(t,y(:,8), 'color',[0.4660 0.6740 0.1880],'LineWidth',2);
hold on
plot(t,y(:,9),'color',[0.9290 0.4940 0.0250],'LineWidth',2);
plot(t,y(:,10), 'color',[.5 0 .5],'LineWidth',2);
plot(t,y(:,11), 'k','LineWidth',2);
legend('Susceptible','Exposed','Infected','Recovered','Location','best');
title("Valley Fever Model 4 - Vector/Fungal Model dependent on Food & Env. -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('Humans', 'FontSize', 18)
hold off

end































elseif choose_model==5
    if single_run_or_fitting==1 || single_run_or_fitting==2
%% Running iterative fitting for model 4

disp('Running Model 4 ITERATIVE FITTING')
t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];

y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
y_pop_data_Pinal=[394200;425264;484239;513862];
y_pop_data_Pima=[1024000;1043433;1063162;1080149];
y_pop_data_AZ=[6849647;7151502;7431344;7582384];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data=y_inf_data_Maricopa;
y_pop_data=y_pop_data_Maricopa;
tspan=t_inf_data;

%Initial Conditions
ic_V_j=50;
ic_V_a=100;
ic_O=100;
ic_D=50;
ic_H=100;%
ic_A=50;%100
ic_C=5;
ic_I=y_inf_data(1)/1;
ic_E=ic_I/2;%y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_E-ic_R);

y0=[ic_V_j;ic_V_a;ic_O;ic_D;ic_H;ic_A;ic_C;ic_S;ic_E;ic_I;ic_R];

%Parameter Ranges

%initial guess
alpha_h_maricopa= 0.100000000000000;
omega_maricopa= 0.099964544635737;
PI=10; delta_O=0.04; mu_H=0.0001;
gamma_H=0.0000005; H_max=300; delta_H=0.000004;
gamma_A=0.009; delta_A=0.006; phi_A=0.0000005;
delta_C=0.00002; T_opt_H=75; T_opt_A=86;
S_opt_H=13; S_opt_A=9; T_decay=60;
bl_Topt_A=500; ab_Topt_A=70; bl_Topt_H=500; 
ab_Topt_H=70; bl_Sopt_A=15; ab_Sopt_A=4; 
bl_Sopt_H=15; ab_Sopt_H=4; T_hs=78.989;
beta=0.0123; mu_V=0.005; delta_V_j=0.0021;
delta_V_a=0.0015; sigma=0.00000000007; T_cs=68.989;
alpha=0.000002;  S_d_s=0; T_d_s=90; 
bl_S_H_s=2; ab_T_H_s=1; xtr_c_s=10; delta_R=0; 
epsilon=0.0000067; rho=0.008; kappa=0.00003; psi=0.0035;%psi=0.00033;
alpha_h=alpha_h_maricopa;
omega=omega_maricopa;

p0=[PI; delta_O; mu_H; gamma_H; H_max; delta_H; gamma_A; delta_A; ...
    phi_A; delta_C; T_opt_H; T_opt_A; S_opt_H; S_opt_A; T_decay; bl_Topt_A; ...
    ab_Topt_A; bl_Topt_H; ab_Topt_H; bl_Sopt_A; ab_Sopt_A; bl_Sopt_H; ...
    ab_Sopt_H; T_hs; beta; mu_V; delta_V_j; delta_V_a; sigma; T_cs; alpha; ...
    S_d_s; T_d_s; xtr_c_s; alpha_h; delta_R; epsilon; omega; rho; kappa; psi];

parswarmorfmincon=2; % 1= fmincon, anything else = parswarm

run=1;%could add a loop starting here for multiple iterations

pool = gcp; % Will create a pool if none exists
numWorkers = pool.NumWorkers;
disp(numWorkers);
format long

if run==1
    for i=1:1:41
        LB(i)=p0(i);
        UB(i)=p0(i);
    end
else
    if parswarmorfmincon==1
        for i=1:1:41
            LB(i)=params_m4fminHumanfit(i);
            UB(i)=params_m4fminHumanfit(i);
        end
    else
        for i=1:1:41
            LB(i)=params_m4pswarmHumanfit(i);
            UB(i)=params_m4pswarmHumanfit(i);
        end
    end
end

%FAST OPTIONS Objective function fmin
optionsOFfmin = optimoptions('fmincon', ...
    'Algorithm', 'interior-point', ...       % Fast and robust for large-scale problems
    'MaxIterations', 100, ...                % Limit number of iterations
    'MaxFunctionEvaluations', 1e4, ...       % Limit function calls
    'OptimalityTolerance', 1e-3, ...         % Loosen stopping criteria
    'StepTolerance', 1e-6, ...
    'Display', 'off', ...                    % Turn off verbose output
    'UseParallel', true, ...                 % Use parallel computing if available
    'FiniteDifferenceType', 'forward', ...   % Faster gradient approximation
    'FiniteDifferenceStepSize', 1e-4); 

%FAST OPTIONS Objective function pswarm
optionsOFpswarm = optimoptions('particleswarm', ...
    'UseParallel', true, ...                % Use all available workers
    'SwarmSize', numWorkers*5, ...          % Smaller swarm = fewer evaluations
    'MaxIterations', 20, ...                % Fewer generations
    'MaxStallIterations', 5, ...           % Quit early if no progress
    'FunctionTolerance', 1e-2, ...          % Looser convergence
    'OutputFcn', @myOutputFcn, ...
    'HybridFcn', []);                       % Avoid slow hybrid optimization

optionsOFpswarm = optimoptions('particleswarm', ...
    'UseParallel', true, ...
    'SwarmSize', numWorkers*5, ...          % KEY SETTING: Use a very small swarm. Default is 10*n_vars.
    'MaxIterations', 20, ...      % KEY SETTING: Limit the number of iterations. Default is 200*n_vars.
    'MaxStallIterations', 5, ...
    'FunctionTolerance', 1e-2, ... % KEY SETTING: Loosen the termination tolerance. Default is 1e-6. 
    'UseVectorized', true, ...    % KEY SETTING: Enable vectorized computation. This is crucial for speed.
    'OutputFcn', @myOutputFcn, ...                         % Your objective function must be written to handle matrix inputs.
    'Display', 'iter');   

%FAST OPTIONS ODE
optionsODE = odeset(...
                'RelTol', 1e-2, ...
                'AbsTol', 1e-4, ...
                'MaxStep', 1e-4, ...
                'InitialStep', 1e-3);

%remain constant for now
% xtr_c_s;      %S_d_s;%Fit later  T_d_s;
LB(34) = 2;     LB(32) = 0;       LB(33) = 95;
UB(34) = 2;     UB(32) = 0;       UB(33) = 95;
%LB(34) = 0;    LB(32) = 10;       LB(33) = 95;
%UB(34) = 8;    UB(32) = 14;       UB(33) = 100;

%VECTOR SECTION
%beta;                 %mu_V;                   %delta_V_j;      
LB(25) = 0.0123;       LB(26) = 0.001;          LB(27) = 0.0015;
UB(25) = 0.0616;       UB(26) = 0.08;           UB(27) = 0.015;
%delta_V_a;            %sigma;                  %T_cs;        
LB(28) = 0.00008;      LB(29) = 0.00000005;  LB(30) = 65;
UB(28) = 0.01;         UB(29) = 0.0000007;  UB(30) = 75;

disp('Running Model 4 Vector Section of ITERATIVE FITTING')
if parswarmorfmincon==1
    params_m4fminVectorfit = fmincon(@(p) objective_functionM4(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], optionsOFfmin);
    fprintf('params_m4fminVectorfit = [%s%.15f];\n', sprintf('%.15f; ', params_m4fminVectorfit(1:end-1),params_m4fminVectorfit(end)));
    [t, yfminVectorfit] = ode15s(@(t, y) M4_SF(t, y, params_m4fminVectorfit), t_inf_data, y0, optionsODE);
    err_fmin_m4_Vectorfit = (rmse(yfminVectorfit(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100
else
    params_m4pswarmVectorfit= particleswarm(@(p) objective_functionM4(p, tspan, y0, y_inf_data),length(LB),LB,UB,optionsOFpswarm);
    fprintf('params_m4pswarmVectorfit = [%s%.15f];\n', sprintf('%.15f; ', params_m4pswarmVectorfit(1:end-1),params_m4pswarmVectorfit(end)));
    [t, ypswarmVectorfit] = ode15s(@(t, y) M4_SF(t, y, params_m4pswarmVectorfit), t_inf_data, y0, optionsODE);
    err_pswarm_m4_Vectorfit = (rmse(ypswarmVectorfit(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100
end


%ORGANIC MATERIALS SECTION
if parswarmorfmincon==1
    for i=1:1:41
        LB(i)=params_m4fminVectorfit(i);
        UB(i)=params_m4fminVectorfit(i);
    end
else
    for i=1:1:41
        LB(i)=params_m4pswarmVectorfit(i);
        UB(i)=params_m4pswarmVectorfit(i);
    end
end
%PI                   % delta_O             %mu_H
 LB(1) = 2;           LB(2) = 0.0003;      LB(3) = 0.000001;        
 UB(1) = 15;        UB(2) = 0.1;           UB(3) = 0.1;
 %T_decay
LB(15) = 55;      
UB(15) = 65; 
disp('Running Model 4 ORGANIC MAT Section of ITERATIVE FITTING')
if parswarmorfmincon==1
    params_m4fminOrgMfit = fmincon(@(p) objective_functionM4(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], optionsOFfmin);
    fprintf('params_m4fminEnvfit = [%s%.15f];\n', sprintf('%.15f; ', params_m4fminOrgMfit(1:end-1),params_m4fminOrgMfit(end)));
    [t, yfminOrgMfit] = ode15s(@(t, y) M4_SF(t, y, params_m4fminOrgMfit), t_inf_data, y0, optionsODE);
    err_fmin_m4_OrgMfit = (rmse(yfminOrgMfit(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100
else
    params_m4pswarmOrgMfit= particleswarm(@(p) objective_functionM4(p, tspan, y0, y_inf_data),length(LB),LB,UB,optionsOFpswarm);
    fprintf('params_m4pswarmOrgMfit = [%s%.15f];\n', sprintf('%.15f; ', params_m4pswarmOrgMfit(1:end-1),params_m4pswarmOrgMfit(end)));
    [t, ypswarmOrgMfit] = ode15s(@(t, y) M4_SF(t, y, params_m4pswarmOrgMfit), t_inf_data, y0, optionsODE);
    err_pswarm_m4_OrgMfit = (rmse(ypswarmOrgMfit(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100
end


%FUNGUS SECTION
if parswarmorfmincon==1
    for i=1:1:41
        LB(i)=params_m4fminOrgMfit(i);
        UB(i)=params_m4fminOrgMfit(i);
    end
else
    for i=1:1:41
        LB(i)=params_m4pswarmOrgMfit(i);
        UB(i)=params_m4pswarmOrgMfit(i);
    end
end
% gamma_h            %H_max             %delta_H
LB(4) = 0.0000001;   LB(5) = 300;       LB(6) = 0.000001;        
UB(4) = 0.00005;     UB(5) = 600;       UB(6) = 0.0004;
% gamma_A            % delta_A          %phi_A
LB(7) = 0.00001;     LB(8) = 0.000001;  LB(9) = 0.0000001;      
UB(7) = 0.05;        UB(8) = 0.05;      UB(9) = 0.00001;
% delta_C            %T_opt_H           %T_opt_A
LB(10) = 0.000001;   LB(11) = 74;       LB(12) = 82;      
UB(10) = 0.003;      UB(11) = 82;       UB(12) = 92; 
% S_opt_H            %S_opt_A           %T_decay
LB(13) = 10;         LB(14) = 7;        LB(15) = 55;      
UB(13) = 13;         UB(14) = 10;       UB(15) = 65; 
% bl_Topt_A          %ab_Topt_A         %bl_Topt_H
LB(16) = 300;        LB(17) = 50;       LB(18) = 300;      
UB(16) = 600;        UB(17) = 80;       UB(18) = 600;
% ab_Topt_H          %bl_Sopt_A         %ab_Sopt_A
LB(19) = 50;         LB(20) = 5;        LB(21) = 0.1;      
UB(19) = 80;         UB(20) = 16;       UB(21) = 7;
% bl_Sopt_H          %ab_Sopt_H         %T_hs       
LB(22) = 5;          LB(23) = 0.1;      LB(24) = 78;
UB(22) = 16;         UB(23) = 7;        UB(24) = 83;
% alpha;                  
LB(31) = 0.000001;                 
UB(31) = 0.00001;
disp('Running Model 4 Fungal Section of ITERATIVE FITTING')
if parswarmorfmincon==1
    params_m4fminFungfit = fmincon(@(p) objective_functionM4(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], optionsOFfmin);
    fprintf('params_m4fminFungfit = [%s%.15f];\n', sprintf('%.15f; ', params_m4fminFungfit(1:end-1),params_m4fminFungfit(end)));
    [t, yfminFungfit] = ode15s(@(t, y) M4_SF(t, y, params_m4fminFungfit), t_inf_data, y0, optionsODE);
    err_fmin_m4_Fungfit = (rmse(yfminFungfit(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100
else
    params_m4pswarmFungfit= particleswarm(@(p) objective_functionM4(p, tspan, y0, y_inf_data),length(LB),LB,UB,optionsOFpswarm);
    fprintf('params_m4pswarmFungfit = [%s%.15f];\n', sprintf('%.15f; ', params_m4pswarmFungfit(1:end-1),params_m4pswarmFungfit(end)));
    [t, ypswarmFungfit] = ode15s(@(t, y) M4_SF(t, y, params_m4pswarmOrgMfit), t_inf_data, y0, optionsODE);
    err_pswarm_m4_Fungfit = (rmse(ypswarmFungfit(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100
end


%HUMAN SECTION
if parswarmorfmincon==1
    for i=1:1:41
        LB(i)=params_m4fminFungfit(i);
        UB(i)=params_m4fminFungfit(i);
    end
else
    for i=1:1:41
        LB(i)=params_m4pswarmFungfit(i);
        UB(i)=params_m4pswarmFungfit(i);
    end
end
alpha_h_b=alpha_h_maricopa;
omega_b=omega_maricopa;
% alpha_h               % delta_R       %epsilon
LB(35) = alpha_h_b;     LB(36) = 0;    LB(37) = 0.0000001;        
UB(35) = alpha_h_b;     UB(36) = 0;    UB(37) = 0.00001;
% omega                       % rho             %kappa
LB(38) = omega_b*0.999999;    LB(39) = 1/365;   LB(40) = 0.000000027768;        
UB(38) = omega_b*1.000001;    UB(39) = 1/14;    UB(40) = 0.000359; 
% psi          
LB(41) = 1/28;       
UB(41) = 1/7; 

disp('Running Model 4 Human Section of ITERATIVE FITTING')
if parswarmorfmincon==1
    params_m4fminHumanfit = fmincon(@(p) objective_functionM4(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], optionsOFfmin);
    fprintf('params_m4fminHumanfit = [%s%.15f];\n', sprintf('%.15f; ', params_m4fminHumanfit(1:end-1),params_m4fminHumanfit(end)));
    [t, yfminHumanfit] = ode15s(@(t, y) M4_SF(t, y, params_m4fminHumanfit), t_inf_data, y0, optionsODE);
    err_fmin_m4_Humanfit = (rmse(yfminHumanfit(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100
else
    params_m4pswarmHumanfit= particleswarm(@(p) objective_functionM4(p, tspan, y0, y_inf_data),length(LB),LB,UB,optionsOFpswarm);
    fprintf('params_m4pswarmHumanfit = [%s%.15f];\n', sprintf('%.15f; ', params_m4pswarmHumanfit(1:end-1),params_m4pswarmHumanfit(end)));
    [t, ypswarmHumanfit] = ode15s(@(t, y) M4_SF(t, y, params_m4pswarmOrgMfit), t_inf_data, y0, optionsODE);
    err_pswarm_m4_Humanfit = (rmse(ypswarmHumanfit(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100
end


    end















































elseif choose_model==6
%% Model 4 SIMPLIFIED - Vector and Fungal Model dependent on Food and Environment
if single_run_or_fitting==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %SINGLE RUN Model 4 SIMPLIFIED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 4 SIMPLIFIED single parameter run')
t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];

y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
y_pop_data_Pinal=[394200;425264;484239;513862];
y_pop_data_Pima=[1024000;1043433;1063162;1080149];
y_pop_data_AZ=[6849647;7151502;7431344;7582384];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data=y_inf_data_Maricopa;
y_pop_data=y_pop_data_Maricopa;

%Initial Conditions
ic_V=5000;
ic_O=40;
ic_D=70;
ic_H=100;%
ic_A=50;%100
ic_C=10;
ic_I=y_inf_data(1)/1;
ic_E=ic_I/2;%y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_E-ic_R);

y0=[ic_V;ic_O;ic_D;ic_H;ic_A;ic_C;ic_S;ic_E;ic_I;ic_R];

%Parameters
alpha_h_maricopa= 0.100000000000000;
omega_maricopa= 0.099964544635737;

delta_O=0.04; mu_H=0.0001;
gamma_H=0.000003; H_max=300; delta_H=0.000004;
gamma_A=0.005; delta_A=0.003; phi_A=0.00000001;
delta_C=0.0009; T_opt_H=75; T_opt_A=86;
%S_opt_H=80; S_opt_A=80; T_decay=60;
S_opt_H=13; S_opt_A=9; T_decay=60;
bl_Topt_A=500; ab_Topt_A=70; bl_Topt_H=500; 
ab_Topt_H=70; bl_Sopt_A=15; ab_Sopt_A=4; 
bl_Sopt_H=15; ab_Sopt_H=4; T_hs=78.989;
beta=0.00123; mu_V=0.005; delta_V=0.00022;
 sigma=0.00000000007; T_cs=68.989;
% beta;                 %mu_V;              %delta_V_j;      
% LB(25) = 0.0123;       LB(26) = 0.001;       LB(27) = 0.0015;
% UB(25) = 0.0616;           UB(26) = 0.08;         UB(27) = 0.015;
% delta_V_a;            %sigma;                     %T_cs;        
% LB(28) = 0.00008;      ** LB(29) = 0.00000000005;       LB(30) = 65;
% UB(28) = 0.01;         UB(29) = 0.00000000007;        UB(30) = 75;
% alpha;                    
% LB(31) = 0.000001;                    
% UB(31) = 0.0001;  

alpha=0.0000001;  S_d_s=20; T_d_s=90; 
bl_S_H_s=2; ab_T_H_s=1; xtr_c_s=10; delta_R=0; 
epsilon=0.0000067; rho=0.008; kappa=0.00003; psi=0.0035;%psi=0.00033;
epsilon=0.0000067; rho=0.01; kappa=0.0001;
%epsilon=0.00000085;
alpha_h=alpha_h_maricopa;
omega=omega_maricopa;
 
paramsm4_S=[delta_O; mu_H; gamma_H; H_max; delta_H; gamma_A; delta_A; phi_A;...
delta_C; T_opt_H; T_opt_A; S_opt_H; S_opt_A; T_decay; bl_Topt_A; ab_Topt_A;...
bl_Topt_H; ab_Topt_H; bl_Sopt_A; ab_Sopt_A; bl_Sopt_H; ab_Sopt_H; T_hs;...
beta; delta_V; sigma; T_cs; alpha; S_d_s; T_d_s; xtr_c_s; alpha_h; ...
delta_R; epsilon; omega; rho; kappa; psi];
size(paramsm4_S)
paramsm4_S=[0.014964628356240; 0.045876847010734; 0.005387792143370; 252.733543234581219;...
    0.006462605655229; 0.008817176561336; 0.003100671042591; 0.000000174286152; 0.000000221461174;...
    79.990177233561297; 88.646152658522098; 12.997223474560007; 7.007980069995158; 64.991005593714064;...
    680.267735378204179; 30.000000000000000; 200.000000000000000; 99.984958044777869; 2.102946856281385;...
    6.921855980804210; 3.931056760970143; 7.000000000000000; 84.779404769611958; 0.000100000000000;...
    0.000172446262367; 0.000000000010000; 71.637654691850656; 0.000001142393013; 7.315955895972640;...
    31.000000000000000; 10.000000000000000; 0.100000000000000; 0.000000000000000; 0.000000779510491;...
    0.099964447873567; 0.002739726027397; 0.000004355767986; 0.035714285714286];
%ode run
 options = odeset(...
                'RelTol', 1e-2, ...
                'AbsTol', 1e-5, ...
                'MaxStep', 0.5, ...
                'InitialStep', 1e-6);
 try
     [t, y] = ode15s(@(t, y) M4_SF_S(t, y, paramsm4_S), t_inf_data, y0, options);
     err_m4 = (rmse(y(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
     err_m4_A = (rmse(y(:,5) , y_inf_data/11.308)/sqrt(sumsqr(y_inf_data/11.308')))*100;
    catch 
     try
         [t, y] =ode15s(@(t, y) M4_SF_S(t, y, paramsm4v), t_inf_data, y0);
         err_m4 = (rmse(y(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
         err_m4_A = (rmse(y(:,5) , y_inf_data/11.308)/sqrt(sumsqr(y_inf_data/11.308')))*100;
     catch
         try
            [t, y] = ode23s(@M4_SF_S,t_inf_data,y0,[],paramsm4_S);
            err_m4 = (rmse(y(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
            err_m4_A = (rmse(y(:,5) , y_inf_data/11.308)/sqrt(sumsqr(y_inf_data/11.308')))*100;
         catch
             try
                 [t, y] =ode45(@(t, y) M4_SF_S(t, y, paramsm4_S), t_inf_data, y0);
                 err_m4 = (rmse(y(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
                 err_m4_A = (rmse(y(:,5) , y_inf_data/11.308)/sqrt(sumsqr(y_inf_data/11.308')))*100;
             catch
                 try
                     [t, y] =ode78(@(t, y) M4_SF_S(t, y, paramsm4_S), t_inf_data, y0);
                     err_m4 = (rmse(y(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
                     err_m4_A = (rmse(y(:,5) , y_inf_data/11.308)/sqrt(sumsqr(y_inf_data/11.308')))*100;
                 catch
                     disp('nothing worked')
                 end
             end
         end
     end
 end
 % % [t, y] =ode15s(@(t, y) M4_SF_S(t, y, paramsm4_S), t_inf_data, y0);
 % %                     err_m4 = (rmse(y(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
 % %                     err_m4_A = (rmse(y(:,5) , y_inf_data/11.308)/sqrt(sumsqr(y_inf_data/11.308')))*100;
%[t, y] =ode15s(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
%[t, y] = ode23s(@M4_SF,t_inf_data,y0,[],paramsm4);
%[t, y] =ode45(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
%[t, y] =ode78(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
%err_m4 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;


fprintf('y_inf_data_M4_L_S = [%s%.4f];\n', sprintf('%.4f; ', y(1:end-1,9),y(end,9)));
disp('space')
fprintf('Parameters_M4_L_infdata_S = [%s%.7f];\n', sprintf('%.7f; ', paramsm4_S(1:end-1),paramsm4_S(end)));
disp('space')
 %plotting results

%  plot(t,40*sin(((2*pi)/365)*t)+70,'color', [.55 .55 .55],'LineWidth',2);
% hold on
% plot(t,49*sin(((2*pi)/365)*t-(pi/8))+50,'color', [.85 .85 .85],'LineWidth',2);

figure
plot(t,y(:,1),'color', [0.4940 0.1840 0.5560],'LineWidth',2)
hold on
%plot(t,y(:,2),'color', [0.9290 0.6940 0.1250],'LineWidth',2)
legend('vector','FontSize', 16,'Location','best');
title("Valley Fever Model 4_S - Vector and Fungal Model dependent on Food and Environmentn Food & Env.", 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); %ylabel('Infected Humans', 'FontSize', 18)
hold off

figure
plot(t,y(:,2),'b','LineWidth',2)
hold on
plot(t,y(:,3),'c','LineWidth',2)
legend('Organic Matter','Decayed Organic Matter','FontSize', 16,'Location','best');
title("Valley Fever Model 4_S - Vector and Fungal Model dependent on Food and Environmentn Food & Env.", 'FontSize', 22)
xticks(t_inf_data)
% xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
% xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); %ylabel('Infected Humans', 'FontSize', 18)
hold off

% plot(t,40*sin(((2*pi)/365)*t)+70,'color', [.55 .55 .55],'LineWidth',2);
% hold on
% plot(t,49*sin(((2*pi)/365)*t-(pi/8))+50,'color', [.85 .85 .85],'LineWidth',2);
figure
plot(t,y(:,4),'r','LineWidth',2)
hold on
scatter(t_inf_data,y_inf_data/11.308,'k','LineWidth',4)
plot(t,y(:,5),'g','LineWidth',2)
plot(t,y(:,6),'k','LineWidth',2)
legend('Hyphae','INF DATA S','Arthroconidia','Colonies', 'FontSize', 16,'Location','best');
title("Valley Fever Model 4_S - Vector and Fungal Model dependent on Food & Environment", 'FontSize', 22)
subtitle("A to Infected Manual M4 RRMSE="+err_m4_A, 'FontSize', 14)
xticks(t_inf_data)
 %xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
 %xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); %ylabel('Infected Humans', 'FontSize', 18)
hold off

figure
plot(t,y(:,7),'r','LineWidth',8)
hold on
scatter(t_inf_data,y_inf_data,'k','LineWidth',4)
plot(t,y(:,8),'g','LineWidth',2)
plot(t,y(:,9),'color','[0.9290 0.4940 0.0250]','LineWidth',4)
plot(t,y(:,10),'color','[0.5 0 0.5]','LineWidth',2)
legend('Susceptible','INF DATA','Exposed','Infected','Recovered', 'FontSize', 16,'Location','best');
title("Valley Fever Model 4_S - Vector and Fungal Model dependent on Food & Environment", 'FontSize', 24)
%xticks(t_inf_data)
subtitle("Infected Manual M4 RRMSE="+err_m4, 'FontSize', 14)
 xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
 xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 corresponds to Jan. 1 2013)', 'FontSize', 18); ylabel('Humans', 'FontSize', 18)
ylim([0,max(y_inf_data)+200])
hold off

elseif single_run_or_fitting==2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %FITTING Model 4 SIMPLIFIED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 4 SIMPLIFIED fitting')

    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%m4 SIMPLIFIED Fitting Fungus Model

global alpha_h_maricopa omega_maricopa alpha_h_pinal omega_pinal alpha_h_pima omega_pima alpha_h_AZ omega_AZ
alpha_h_maricopa= 0.000035386745035+0.049996054144265;
omega_maricopa= 0.049996054144265;

alpha_h_pinal= 0.000054197479825+0.049562154054803; %*use looser bounds
omega_pinal= 0.049562154054803; %*use looser bounds

alpha_h_pima= 0.000010637066754+0.050079359342677;
omega_pima= 0.050079359342677;

alpha_h_AZ= 0.002876562772732+0.058375000164113;
omega_AZ= 0.058375000164113;


%import/load data
y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
y_pop_data_Pinal=[394200;425264;484239;513862];
y_pop_data_Pima=[1024000;1043433;1063162;1080149];
y_pop_data_AZ=[6849647;7151502;7431344;7582384];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data_Pinal=[53.74285714;48.85714286;36.28571429;15.42857143;17.71428571;...
    34.14285714;33.57142857;30.57142857;35.42857143;25.42857143;34.14285714;...
    41.42857143;61;38.85714286;35.14285714;54.85714286;43.71428571;57.42857143;...
    40.14285714;27.42857143;33.42857143;28.14285714;22.28571429;30;33.57142857;...
    37;32;37.57142857;48.28571429;42.14285714;48.71428571;60.42857143;...
    68.71428571;71.28571429;78.85714286;73.14285714;56.85714286;47.85714286;...
    42.14285714;42.14285714;57.85714286;32.71428571;28.42857143;50.85714286;...
    30.71428571;26.42857143;42.71428571;47.85714286;49.28571429;47.42857143;...
    24.57142857;42;36.57142857;39.28571429;33.57142857;33.85714286;46.71428571;...
    26;46.85714286;64.71428571;85.42857143;65.57142857;34.85714286;36.57142857;...
    47.42857143;56.57142857;43;52.85714286;37.57142857;32;51.85714286;42.14285714;...
    63.57142857;52.14285714;57.57142857;66.57142857;56.71428571;75.71428571;...
    77.71428571;81.57142857;80;65.28571429;91.85714286;121.8571429;118;...
    83.28571429;71.71428571;36.28571429;45.85714286;71.42857143;77.57142857;...
    87.85714286;99.85714286;118;112.1428571;121.7142857;162.2857143;117.1428571;...
    99;105.8571429;76.57142857;62.57142857;58.14285714;73.71428571;62.42857143;...
    61.28571429;65.85714286;78.57142857;133.8571429;99.85714286;66.42857143;74;...
    69.71428571;79.28571429;73.85714286;95.28571429;49.28571429;50.85714286;...
    50.71428571;61.14285714;70.57142857;56.57142857;49;62.57142857;49.71428571;...
    57.57142857;59.57142857;100.5714286;93.85714286;77.57142857;106.4285714;...
    131.4285714;141.1428571];

y_inf_data_Pima=[128.0714286;116.4285714;70.57142857;42.28571429;62.57142857;...
    71.71428571;88.28571429;71.28571429;88.85714286;72.28571429;80.28571429;...
    106.4285714;137;82.28571429;91.85714286;77.28571429;81.57142857;82;80.42857143;...
    46.57142857;62;52.28571429;61;57.14285714;58.57142857;96;66;58.57142857;...
    71.28571429;75;148.1428571;115.7142857;112.8571429;146.2857143;114.1428571;...
    109.1428571;86.85714286;80.28571429;64.71428571;79.42857143;73.57142857;...
    79.57142857;73.28571429;75.85714286;55.71428571;68.14285714;60.71428571;...
    90;95.71428571;83.85714286;64.14285714;74.28571429;87.42857143;67;63.85714286;...
    105.4285714;75.85714286;58.14285714;82.42857143;128.5714286;146;90.42857143;...
    83.85714286;71.71428571;59.42857143;83.28571429;97.28571429;103.2857143;...
    87.71428571;76.28571429;76;75;62.71428571;85.71428571;111.8571429;127.5714286;...
    115.7142857;115.5714286;122;146.5714286;143;100.1428571;118.4285714;123.4285714;...
    131;101;110;92.57142857;82.57142857;102.8571429;122.2857143;125.2857143;...
    164.5714286;143.1428571;127.7142857;162.4285714;165.5714286;138.5714286;...
    138.2857143;140.7142857;88.14285714;110;104.5714286;117.7142857;84.28571429;...
    80.14285714;92.14285714;98.85714286;123.5714286;95.42857143;57.14285714;...
    83.85714286;83.57142857;112.2857143;113.8571429;139.7142857;100.5714286;...
    81.71428571;89.14285714;79;93.71428571;103.4285714;87.57142857;89;87.28571429;...
    100.5714286;104;109.4285714;115.2857143;93.42857143;113.4285714;132;134.5714286];

y_inf_data_AZ=[798.9142857;726.2857143;461.5714286;326;356.4285714;425;431.5714286;...
    431.4285714;463.7142857;401.1428571;489.7142857;682.1428571;696;564.8571429;...
    591.8571429;574;529.2857143;595;505.1428571;319.5714286;347.8571429;352.2857143;...
    325.7142857;338.8571429;435.5714286;410;380;432.5714286;517.4285714;471.7142857;...
    700.1428571;727.7142857;778.7142857;944.5714286;786.1428571;800;684;581.2857143;...
    464.1428571;574.4285714;529.1428571;459;454.8571429;483.2857143;495.4285714;...
    392.4285714;553;590;577;532.1428571;416;408.7142857;457.1428571;442.7142857;...
    417.2857143;522.8571429;522.2857143;444.8571429;643.4285714;953.8571429;...
    1184.714286;898.2857143;584.4285714;564.2857143;552;663;611;689.5714286;...
    609.8571429;538;622.7142857;523.4285714;630.4285714;745.5714286;658;811.4285714;...
    749.7142857;797.7142857;818.2857143;943.2857143;971;798.2857143;902.4285714;...
    1115.285714;1059;930;830;635.2857143;475.7142857;630.5714286;747.1428571;...
    800.2857143;1067.142857;1188.285714;1175.571429;1382.857143;1560.142857;...
    1323.285714;1113.428571;1147.285714;863.1428571;854.4285714;809;814.4285714;...
    810.7142857;736.7142857;842;1009.857143;1223.714286;952.8571429;673.5714286;...
    704.5714286;787;948.1428571;911.2857143;1072.571429;715.7142857;625.8571429;...
    617.1428571;691.2857143;759;704.4285714;615.2857143;773.5714286;702.4285714;...
    750.7142857;706;869.2857143;974.4285714;929.8571429;1126;1335;1417];

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];

y_inf_data=y_inf_data_Maricopa;
y_pop_data=y_pop_data_Maricopa;
y_inf_data_D=y_inf_data/11.308;
alpha_h_b=alpha_h_maricopa;
omega_b=omega_maricopa;
county_M4=["Maricopa"];
county=2; %1=AZ, 2=Maricopa, 3=Pima, 4=Pinal

%Initial Conditions
ic_V=5000;
ic_O=40;
ic_D=70;
ic_H=100;%
ic_A=50;%100
ic_I=y_inf_data(1)/1;
ic_E=ic_I*1.5;%y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_E-ic_R);

y0=[ic_V;ic_O;ic_D;ic_H;ic_A;ic_S;ic_E;ic_I;ic_R];

%Parameter Ranges

% delta_O             %mu_H
LB(1) = 0.00001;      LB(2) = 0.000001;        
UB(1) = 0.1;           UB(2) = 0.1;

% gamma_h            % H_max                %delta_H
LB(3) =  0.00000001;    LB(4) = 210;       LB(5) = 0.000001;         
UB(3) = 0.06;        UB(4) = 450;    UB(5) = 0.2;

% gamma_A            % delta_A              %phi_A
LB(6) = 0.000001;     LB(7) = 0.0000001;    LB(8) = 0.000000001;        
UB(6) = 0.1;           UB(7) = 0.2;       UB(8) = 0.00001;

%T_opt_H                  %T_opt_A
LB(9) = 65;      LB(10) = 77;      
UB(9) = 85;        UB(10) = 90; 

% S_opt_H            %S_opt_A                  %T_decay
LB(11) = 10;       LB(12) = 7;      LB(13) = 55;      
UB(11) = 13;          UB(12) = 10;        UB(13) = 70; 

% bl_Topt_A            %ab_Topt_A                  %bl_Topt_H
LB(14) = 200;         LB(15) = 30;      LB(16) = 200;      
UB(14) = 700;        UB(15) = 100;        UB(16) = 700;

% ab_Topt_H            %bl_Sopt_A                  %ab_Sopt_A
LB(17) = 30;         LB(18) = 2;      LB(19) = 0.1;      
UB(17) = 100;           UB(18) = 20;        UB(19) = 8;

% bl_Sopt_H           %ab_Sopt_H           %T_hs       
LB(20) = 2;       LB(21) = 0.1;       LB(22) = 75;
UB(20) = 20;           UB(21) = 8;         UB(22) = 90;

% beta;              %delta_V;      
LB(23) = 0.000001;     LB(24) = 0.00008;
UB(23) = 0.03;      UB(24) = 0.015;

%sigma;                    %T_cs;        
LB(25) = 0.000000000001;     LB(26) = 60;
UB(25) = 0.0000000007;       UB(26) = 75;

% alpha;                 %S_d_s;%Fit later          T_d_s; %Fit later     
LB(27) = 0.0000000005;     LB(28) = 5;       LB(29) = 31;
UB(27) = 0.0001;           UB(28) = 8;         UB(29) = 31;
 
% xtr_c_s;               % alpha_h                          %epsilon 
LB(30) = 1;            LB(31) = alpha_h_b*0.999999;    LB(32) = 0.00000001;
UB(30) = 20;           UB(31) = alpha_h_b*1.000001;    UB(32) = 0.0001;

% omega                             % rho                %kappa
LB(33) = omega_b*0.999999;    LB(34) = 1/(365*2);    LB(35) = 0.000000027768;
UB(33) = omega_b*1.000001;    UB(34) = 1/14;         UB(35) = 0.000359;

% psi                   %delta_D 
LB(36) = 1/60;          LB(37) = 0.000001; 
UB(36) = 1/5;           UB(37) = 0.06; 
                            

%FITTING
tspan=t_inf_data;
pool = gcp; % Will create a pool if none exists
numWorkers = pool.NumWorkers;
disp(numWorkers);
format long
%'OutputFcn', @myOutputFcn, ...

  % options = optimset('Algorithm','interior-point','TolX',1e-20,'TolFun',1e-20,'TolCon'...
  %   ,1e-20,'MaxIter',200000,'MaxFunEvals',100000);
 % options = optimoptions("fmincon",...
 %    Algorithm="interior-point",...
 %    EnableFeasibilityMode=true,...
 %    SubproblemAlgorithm="cg");

 options = optimoptions('fmincon', ...
    'UseParallel', true, ...
    'Algorithm','interior-point',...
    'TolX',1e-20,...
    'TolFun',1e-20,...
    'TolCon',1e-20,...
    'MaxIter',200000,...
    'MaxFunEvals',100000,...
    'Display', 'iter');

 options = optimoptions('fmincon', ...
    'UseParallel', true, ...
    'Algorithm', 'interior-point', ...
    'Display', 'iter-detailed', ...
    'MaxFunctionEvaluations', 1e5, ...
    'StepTolerance', 1e-8);
  
 options = optimoptions('fmincon', ...
    'Algorithm', 'interior-point', ...
    'Display', 'iter-detailed', ...
    'MaxFunctionEvaluations', 1e5, ...
    'StepTolerance', 1e-8);

 options = optimset('Algorithm','interior-point','TolX',1e-13,'TolFun',1e-13,'TolCon'...
    ,1e-13,'MaxIter',2000,'MaxFunEvals',3000);

 %FAST
 options = optimoptions('fmincon', ...
    'Algorithm', 'interior-point', ...       % Fastest for large problems
    'MaxIterations', 100, ...                 % Fewer iterations = faster
    'MaxFunctionEvaluations', 1e3, ...        % Set low if function is expensive
    'OptimalityTolerance', 1e-2, ...          % Looser tolerance for speed
    'StepTolerance', 1e-4, ...                % Looser tolerance for early stopping
    'ConstraintTolerance', 1e-3, ...          % Looser for inequality/eq. constraints
    'SpecifyObjectiveGradient', false, ...    % If no gradients provided
    'SpecifyConstraintGradient', false);
 % Parameters initial guess 
    p0 = [(LB)'];
    %p0=[(LB+Parameters_M4_H_infdata+Parameters_M4_H_infdata)/3];

optionsfast = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*5, ...
    'MaxIterations', 2000, ...
    'MaxStallIterations', 10, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-5, ... %1e-15
    'Display', 'iter');

optionsmedium = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*50, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-12, ... %1e-15
    'Display', 'iter');

optionsslow = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*100, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 120, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 0.9, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-15, ... %1e-15
    'Display', 'iter');
options=optionsfast;
[params_m4pswarm_S, errorOBJ]= particleswarm(@(p) objective_functionM4_S(p, tspan, y0, y_inf_data, county),length(LB),LB,UB,options);
fprintf('params_m4pswarm = [%s%.15f]', sprintf('%.15f; ', params_m4pswarm_S(1:end-1),params_m4pswarm_S(end)),'.\n');
county_M4
errorOBJ
filename = "params_m4pswarm_" + county_M4 + ".mat";
save(filename, 'params_m4pswarm_S');
filename = "m4_RRMSE_" + county_M4 + ".mat";
save(filename, 'errorOBJ');

[params_m4pswarm_S_RSS, rss]= particleswarm(@(p) objective_functionM4_S_RSS(p, tspan, y0, y_inf_data, county),length(LB),LB,UB,options);
fprintf('params_m4pswarm = [%s%.15f]', sprintf('%.15f; ', params_m4pswarm_S(1:end-1),params_m4pswarm_S(end)),'.\n');
fprintf('params_m4pswarm_RSS = [%s%.15f]', sprintf('%.15f; ', params_m4pswarm_S_RSS(1:end-1),params_m4pswarm_S_RSS(end)),'.\n');
county_M4
errorOBJ
rss
filename = "params_m4pswarm_RSS" + county_M4 + ".mat";
save(filename, 'params_m4pswarm_S_RSS');
filename = "m4_RSS_" + county_M4 + ".mat";
save(filename, 'rss');

num_data_points = numel(y_inf_data);    % n
k = numel(LB);               % k

% Calculate AIC, AICc, BIC (same formulas)
aic = num_data_points * log(rss / num_data_points) + 2 * k;
aicc = aic + (2 * k * (k + 1)) / (num_data_points - k - 1);
bic = num_data_points * log(rss / num_data_points) + k * log(num_data_points);

%Display Results
fprintf('Model 4 Simp. Information Criteria Results \n');
fprintf('RSS: %.4f\n', rss);
fprintf('AIC: %.4f\n', aic);
fprintf('AICc: %.4f\n', aicc);
fprintf('BIC: %.4f\n', bic);
% p_opt= particleswarm(@(p) objective_functionM4_S_Fungus(p, tspan, y0_F, y_inf_data_D),length(LB),LB,UB,options);
% params_m4pswarm_S_Fung=p_opt;
% fprintf('params_m4pswarm = [%s%.15f]', sprintf('%.15f; ', params_m4pswarm_S_Fung(1:end-1),params_m4pswarm_S_Fung(end)),'.\n');

%%%%Finding Confidence intervals 
% --- Bootstrap Settings ---
num_bootstrap_samples = 100; % A good starting point is a few hundred. More is better but slower.
num_observations = length(tspan);
num_params = length(LB);
% Preallocate a matrix to store the results of each bootstrap fit
bootstrap_params = zeros(num_bootstrap_samples, num_params);
opts = optimoptions('particleswarm', 'Display', 'off', 'UseParallel', false);
opts = optimoptions('particleswarm', ... %FAST
    'UseParallel', false,...
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*5, ... 
    'MaxIterations', 20, ...                 
    'MaxStallIterations', 5, ...            
    'FunctionTolerance', 1e-5, ...           
    'Display', 'iter');

% % --- Bootstrap Loop ---
% parfor i = 1:num_bootstrap_samples % Use 'parfor' for parallel processing if available
%     % 1. Create a bootstrap sample of the data by resampling WITH REPLACEMENT
%     resample_indices = randi(num_observations, num_observations, 1);
%     t_boot = tspan(resample_indices);
%     y_boot = y_inf_data(resample_indices, :);
% 
%     % 2. Define the objective function for this specific bootstrap sample
%     bootstrap_objective = (@(p) objective_functionM4_S(p, tspan, y0, y_inf_data));
% 
%     % 3. Run a SERIAL parswarm instance on the bootstrap data
%     %    The loop itself is parallel, but each individual run is not.
%     bootstrap_params(i, :) = particleswarm(bootstrap_objective, num_params, LB, UB, opts);
% 
%     % Display progress (optional, can be helpful for long runs)
%     if mod(i, 10) == 0
%         fprintf('Completed bootstrap sample %d of %d\n', i, num_bootstrap_samples);
%     end
% end
% 
% t_fine = linspace(min(tspan), max(tspan), 2000); % A fine time vector for smooth plots
% num_states = size(y_inf_data, 2);
% 
% all_solutions = zeros(num_bootstrap_samples, length(t_fine), num_states);
% 
% options = odeset(...
%                 'RelTol', 1e-2, ...
%                 'AbsTol', 1e-4, ...
%                 'MaxStep', 1e-4, ...
%                 'InitialStep', 1e-3);
% for i = 1:num_bootstrap_samples
%     [~, P_sample] = ode15s(@(t, y) M4_SF_S(t, y, bootstrap_params(i, :)),t_fine, y0, options);
%     all_solutions(i, :, :) = P_sample;
% end
% 
% 
% % Get the best-fit solution using the original best parameters
% [~, P_best_fit] = ode45(@(t, P) your_ode_function(t, P, best_params), t_fine, P0);
% 
% figure;
% hold on;
% state_to_plot = 1; % Plot for the first state variable
% % Plot the 99% confidence interval (lighter color)
% fill([t_fine, fliplr(t_fine)], [lower_bound_99(:, state_to_plot)', fliplr(upper_bound_99(:, state_to_plot)')], ...
%      'b', 'FaceAlpha', 0.15, 'EdgeColor', 'none', 'DisplayName', '99% CI');
% % Plot the 95% confidence interval (darker color)
% fill([t_fine, fliplr(t_fine)], [lower_bound_95(:, state_to_plot)', fliplr(upper_bound_95(:, state_to_plot)')], ...
%      'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none', 'DisplayName', '95% CI');
% % Plot the best-fit line
% plot(t_fine, P_best_fit(:, state_to_plot), 'b-', 'LineWidth', 2, 'DisplayName', 'Best Fit');
% 
% % Plot the original experimental data
% plot(tspan, y_inf_data(:, state_to_plot), 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Data');
% 
% xlabel('Time');
% ylabel('State Variable');
% title('ODE Solution with Bootstrapped Confidence Intervals');
% legend;
% grid on;
% hold off;

%%%%Running with fit params for plotting figure
options = odeset(...
                'RelTol', 1e-2, ...
                'AbsTol', 1e-4, ...
                'MaxStep', 1e-4, ...
                'InitialStep', 1e-3);
% params=params_m4fmin_S_Fungus;
% params=params_m4pswarm_S_Fung;
% params=params_m4fmin_S;
 params=params_m4pswarm_S;
% [t, y] = ode15s(@(t, y) M4_SF(t, y, params), t_inf_data, y0, options);
%[t, y] = ode45(@(t, y) M4_SF_S_Fungus(t, y, params), t_inf_data, y0_F);
%[t, y] = ode23s(@(t, y) M4_SF_S_Fungus(t, y, params), t_inf_data, y0_F);
  %[t, y] = ode15s(@(t, y) M4_SF_S_Fungus(t, y, params), t_inf_data, y0_F, options);
  [t, y] = ode15s(@(t, y) M4_SF_S(t, y, params), t_inf_data, y0, options);
  %err_m4_S = (rmse(y(:,5) , y_inf_data_D)/sqrt(sumsqr(y_inf_data_D')))*100;
   %err_m4_S = (rmse(y(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;

% % % % Get the best-fit solution using the original best parameters
% % % [~, P_best_fit] = ode45(@(t, P) your_ode_function(t, P, best_params), t_fine, P0);
% % % 
% % % figure;
% % % hold on;
% % % 
% % % state_to_plot = 1; % Plot for the first state variable
% % % 
% % % % Plot the 99% confidence interval (lighter color)
% % % fill([t_fine, fliplr(t_fine)], [lower_bound_99(:, state_to_plot)', fliplr(upper_bound_99(:, state_to_plot)')], ...
% % %      'b', 'FaceAlpha', 0.15, 'EdgeColor', 'none', 'DisplayName', '99% CI');
% % % 
% % % % Plot the 95% confidence interval (darker color)
% % % fill([t_fine, fliplr(t_fine)], [lower_bound_95(:, state_to_plot)', fliplr(upper_bound_95(:, state_to_plot)')], ...
% % %      'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none', 'DisplayName', '95% CI');
% % % 
% % % % Plot the best-fit line
% % % plot(t_fine, P_best_fit(:, state_to_plot), 'b-', 'LineWidth', 2, 'DisplayName', 'Best Fit');
% % % 
% % % % Plot the original experimental data
% % % plot(t_data, y_data(:, state_to_plot), 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Data');
% % % 
% % % xlabel('Time');
% % % ylabel('State Variable');
% % % title('ODE Solution with Bootstrapped Confidence Intervals');
% % % legend;
% % % grid on;
% % % hold off;


figure
scatter(t_inf_data,y_inf_data_D, 'b','LineWidth',1)
hold on
plot(t,y(:,5),'c','LineWidth',2.5)
%plot(t,ypswarm(:,10),'k','LineWidth',2)
legend('Maricopa Infected',' Model 4_S Fungus fit','Location','best');
%legend('Maricopa Infected','FMin Model 4 fit','Pswarm Model 4 fit','Location','best');
title("Valley Fever Model 4  -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
subtitle("Infected Fmin M4 RRMSE="+err_m4_S, 'FontSize', 14)
%subtitle("Infected Fmin M4 RRMSE="+err_fmin_m4+", Infected Pswarm M4 RRMSE="+err_pswarm_m4, 'FontSize', 14)
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
ylim([0 max(y_inf_data_D)+20])
hold off

y=yfmin;
% if err_fmin_m4<err_pswarm_m4
%     y=yfmin;
% else
%     y=ypswarm;
% end

%plotting of results for specific params 
 figure
plot(t,y(:,1), 'b','LineWidth',2)
hold on
plot(t,y(:,2),'c','LineWidth',2)
legend('Juvenile Vector','Adult Vector','Location','best');
title("Valley Fever Model 4 - Vector/Fungal Model dependent on Food & Env. -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('Mass', 'FontSize', 18)
hold off

figure
plot(t,y(:,3), 'b','LineWidth',2)
hold on
plot(t,y(:,4),'c','LineWidth',2)
legend('Organic Matter','Decomposed Organic Matter','Location','best');
title("Valley Fever Model 4 - Vector/Fungal Model dependent on Food & Env. -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('Mass', 'FontSize', 18)
hold off

figure
plot(t,ypswarm(:,5), 'r','LineWidth',2);
hold on
plot(t,ypswarm(:,6),'g','LineWidth',2)
plot(t,y(:,7), 'k','LineWidth',2);
legend('Hyphae Structure','Arthroconidia','Colonies','Location','best');
title("Valley Fever Model 4 - Vector/Fungal Model dependent on Food & Env. -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('PPM', 'FontSize', 18)
hold off

figure
plot(t,y(:,8), 'color',[0.4660 0.6740 0.1880],'LineWidth',2);
hold on
plot(t,y(:,9),'color',[0.9290 0.4940 0.0250],'LineWidth',2);
plot(t,y(:,10), 'color',[.5 0 .5],'LineWidth',2);
plot(t,y(:,11), 'k','LineWidth',2);
legend('Susceptible','Exposed','Infected','Recovered','Location','best');
title("Valley Fever Model 4 - Vector/Fungal Model dependent on Food & Env. -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('Humans', 'FontSize', 18)
hold off





elseif single_run_or_fitting==3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Forecasting Model 4 SIMPlIFIED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 4 SIMPlIFIED Forecasting')

%import/load infected valley fever data
y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
    y_pop_data_Pinal=[394200;425264;484239;513862];
    y_pop_data_Pima=[1024000;1043433;1063162;1080149];
    y_pop_data_AZ=[6849647;7151502;7431344;7582384];
    t_pop_data=[1006-1006,3653-1006,4839-1006,5205-1006];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data_Pinal=[53.74285714;48.85714286;36.28571429;15.42857143;17.71428571;...
    34.14285714;33.57142857;30.57142857;35.42857143;25.42857143;34.14285714;...
    41.42857143;61;38.85714286;35.14285714;54.85714286;43.71428571;57.42857143;...
    40.14285714;27.42857143;33.42857143;28.14285714;22.28571429;30;33.57142857;...
    37;32;37.57142857;48.28571429;42.14285714;48.71428571;60.42857143;...
    68.71428571;71.28571429;78.85714286;73.14285714;56.85714286;47.85714286;...
    42.14285714;42.14285714;57.85714286;32.71428571;28.42857143;50.85714286;...
    30.71428571;26.42857143;42.71428571;47.85714286;49.28571429;47.42857143;...
    24.57142857;42;36.57142857;39.28571429;33.57142857;33.85714286;46.71428571;...
    26;46.85714286;64.71428571;85.42857143;65.57142857;34.85714286;36.57142857;...
    47.42857143;56.57142857;43;52.85714286;37.57142857;32;51.85714286;42.14285714;...
    63.57142857;52.14285714;57.57142857;66.57142857;56.71428571;75.71428571;...
    77.71428571;81.57142857;80;65.28571429;91.85714286;121.8571429;118;...
    83.28571429;71.71428571;36.28571429;45.85714286;71.42857143;77.57142857;...
    87.85714286;99.85714286;118;112.1428571;121.7142857;162.2857143;117.1428571;...
    99;105.8571429;76.57142857;62.57142857;58.14285714;73.71428571;62.42857143;...
    61.28571429;65.85714286;78.57142857;133.8571429;99.85714286;66.42857143;74;...
    69.71428571;79.28571429;73.85714286;95.28571429;49.28571429;50.85714286;...
    50.71428571;61.14285714;70.57142857;56.57142857;49;62.57142857;49.71428571;...
    57.57142857;59.57142857;100.5714286;93.85714286;77.57142857;106.4285714;...
    131.4285714;141.1428571];

y_inf_data_Pima=[128.0714286;116.4285714;70.57142857;42.28571429;62.57142857;...
    71.71428571;88.28571429;71.28571429;88.85714286;72.28571429;80.28571429;...
    106.4285714;137;82.28571429;91.85714286;77.28571429;81.57142857;82;80.42857143;...
    46.57142857;62;52.28571429;61;57.14285714;58.57142857;96;66;58.57142857;...
    71.28571429;75;148.1428571;115.7142857;112.8571429;146.2857143;114.1428571;...
    109.1428571;86.85714286;80.28571429;64.71428571;79.42857143;73.57142857;...
    79.57142857;73.28571429;75.85714286;55.71428571;68.14285714;60.71428571;...
    90;95.71428571;83.85714286;64.14285714;74.28571429;87.42857143;67;63.85714286;...
    105.4285714;75.85714286;58.14285714;82.42857143;128.5714286;146;90.42857143;...
    83.85714286;71.71428571;59.42857143;83.28571429;97.28571429;103.2857143;...
    87.71428571;76.28571429;76;75;62.71428571;85.71428571;111.8571429;127.5714286;...
    115.7142857;115.5714286;122;146.5714286;143;100.1428571;118.4285714;123.4285714;...
    131;101;110;92.57142857;82.57142857;102.8571429;122.2857143;125.2857143;...
    164.5714286;143.1428571;127.7142857;162.4285714;165.5714286;138.5714286;...
    138.2857143;140.7142857;88.14285714;110;104.5714286;117.7142857;84.28571429;...
    80.14285714;92.14285714;98.85714286;123.5714286;95.42857143;57.14285714;...
    83.85714286;83.57142857;112.2857143;113.8571429;139.7142857;100.5714286;...
    81.71428571;89.14285714;79;93.71428571;103.4285714;87.57142857;89;87.28571429;...
    100.5714286;104;109.4285714;115.2857143;93.42857143;113.4285714;132;134.5714286];

y_inf_data_AZ=[798.9142857;726.2857143;461.5714286;326;356.4285714;425;431.5714286;...
    431.4285714;463.7142857;401.1428571;489.7142857;682.1428571;696;564.8571429;...
    591.8571429;574;529.2857143;595;505.1428571;319.5714286;347.8571429;352.2857143;...
    325.7142857;338.8571429;435.5714286;410;380;432.5714286;517.4285714;471.7142857;...
    700.1428571;727.7142857;778.7142857;944.5714286;786.1428571;800;684;581.2857143;...
    464.1428571;574.4285714;529.1428571;459;454.8571429;483.2857143;495.4285714;...
    392.4285714;553;590;577;532.1428571;416;408.7142857;457.1428571;442.7142857;...
    417.2857143;522.8571429;522.2857143;444.8571429;643.4285714;953.8571429;...
    1184.714286;898.2857143;584.4285714;564.2857143;552;663;611;689.5714286;...
    609.8571429;538;622.7142857;523.4285714;630.4285714;745.5714286;658;811.4285714;...
    749.7142857;797.7142857;818.2857143;943.2857143;971;798.2857143;902.4285714;...
    1115.285714;1059;930;830;635.2857143;475.7142857;630.5714286;747.1428571;...
    800.2857143;1067.142857;1188.285714;1175.571429;1382.857143;1560.142857;...
    1323.285714;1113.428571;1147.285714;863.1428571;854.4285714;809;814.4285714;...
    810.7142857;736.7142857;842;1009.857143;1223.714286;952.8571429;673.5714286;...
    704.5714286;787;948.1428571;911.2857143;1072.571429;715.7142857;625.8571429;...
    617.1428571;691.2857143;759;704.4285714;615.2857143;773.5714286;702.4285714;...
    750.7142857;706;869.2857143;974.4285714;929.8571429;1126;1335;1417];

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];


alpha_h_maricopa= 0.000035386745035+0.049996054144265;
omega_maricopa= 0.049996054144265;

alpha_h_pinal= 0.000054197479825+0.049562154054803; %*use looser bounds
omega_pinal= 0.049562154054803; %*use looser bounds

alpha_h_pima= 0.000010637066754+0.050079359342677;
omega_pima= 0.050079359342677;

alpha_h_AZ= 0.002876562772732+0.058375000164113;
omega_AZ= 0.058375000164113;

y_pop_data=y_pop_data_Maricopa;
y_inf_data=y_inf_data_Maricopa;
alpha_h_b=alpha_h_maricopa;
omega_b=omega_maricopa;
county_M4=["Maricopa"];
county=2; %1=AZ, 2=Maricopa, 3=Pima, 4=Pinal

tspan_8_1=t_inf_data(1:97,1);
tspan_8_1_F=t_inf_data(1:109,1);
tspan_8_2=t_inf_data(13:109,1);
tspan_8_2_F=t_inf_data(13:121,1);
tspan_8_3=t_inf_data(25:121,1);
tspan_8_3_F=t_inf_data(25:133,1);
tspan_11_years=t_inf_data;
y_inf_data_8_1=y_inf_data(1:97,1);
y_inf_data_8_2=y_inf_data(13:109,1);
y_inf_data_8_3=y_inf_data(25:121,1);
y_inf_data_8_4=y_inf_data(25:133,1);

%Initial Conditions
ic_V=5000;
ic_O=40;
ic_D=70;
ic_H=100;%
ic_A=50;%100
ic_C=10;
ic_I=y_inf_data(1)/1;
ic_E=ic_I*1.5;%y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_E-ic_R);

y0=[ic_V;ic_O;ic_D;ic_H;ic_A;ic_C;ic_S;ic_E;ic_I;ic_R];

%Parameter Ranges

%FILL IN

%FORECASTING OF MODEL 4 Simplified 
pool = gcp; %create a pool if none exists
numWorkers = pool.NumWorkers;
disp(numWorkers);
format long

% Parameters initial guess 
    p0 = [LB'];
   
   % p_opt = fmincon(@(p) objective_functionM1(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);

options = optimoptions('particleswarm', ...
    'SwarmSize', length(LB)*10, ...
    'MaxIterations', 1000, ...
    'InertiaRange', [0.3, 1.2], ...
    'SelfAdjustmentWeight', 1.5, ...
    'SocialAdjustmentWeight', 2.0, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-10, ...
    'Display', 'iter');

options = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*3, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-15, ...
    'Display', 'iter');
% %p_opt = particleswarm(@(p) objective_functionM1(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);
% [params_m4spswarm_8_1, errorOBJ8_1]= particleswarm(@(p) objective_functionM4_S(p, tspan_8_1, y0, y_inf_data_8_1),length(LB),LB,UB,options);
% 
% [params_m4spswarm_8_2, errorOBJ8_2]= particleswarm(@(p) objective_functionM4_S(p, tspan_8_2, y0, y_inf_data_8_2),length(LB),LB,UB,options);
% %scnd_year_forecast_rrmse=(rmse(ypswarm_fit8_2(110:121,4) , y_inf_data(110:121,1))/sqrt(sumsqr(y_inf_data(110:121,1)')))*100;
% 
% [params_m4spswarm_8_3, errorOBJ8_3]= particleswarm(@(p) objective_functionM4_S(p, tspan_8_3, y0, y_inf_data_8_3),length(LB),LB,UB,options);
% %thrd_year_forecast_rrmse=(rmse(ypswarm_fit_8_3(122:133,4) , y_inf_data(122:133,1))/sqrt(sumsqr(y_inf_data(122:133,1)')))*100;

params_m4spswarm_8_1 = [0.100000000000000; 0.099993315983788; 0.010000000000000; 448.792907814004309; 0.059443274190637; 0.049854588858974; 0.000001000000000; 0.000000536083295; 0.001000000000000; 70.000142777921283; 77.000000000000000; 10.050955387349321; 9.999828131971546; 61.905296819987932; 750.000000000000000; 10.000000000000000; 699.998553813406602; 30.000000000000000; 1.000000000000000; 8.214847928785824; 1.027336014849692; 0.100000000000000; 75.000000000000000; 0.000601430111274; 0.005797209197117; 0.000000000620390; 74.687658302373578; 0.000001367666055; 5.011594015222514; 31.000000000000000; 1.000000000000000; 0.050031440889300; 0.000000000000000; 0.000000010000000; 0.049996099893209; 0.001369863013699; 0.000006568712283; 0.142849404358245]; 
params_m4spswarm_8_2 = [0.100000000000000; 0.094404663395817; 0.000001000000000; 450.000000000000000; 0.001004193580944; 0.050000000000000; 0.000001168087029; 0.000000010000000; 0.001000000000000; 77.097333028616021; 77.000000000000000; 13.995787811660128; 6.000000000000000; 58.013114643040360; 750.000000000000000; 10.000000000000000; 119.866400271802448; 111.176431333544841; 20.000000000000000; 7.452888840381787; 1.000000000000000; 0.100000000000000; 87.198537130783805; 0.030000000000000; 0.015000000000000; 0.000000000524365; 75.000000000000000; 0.000010000000000; 5.095903427570941; 31.000000000000000; 19.864666333405882; 0.050031440889300; 0.000000000000000; 0.000000010000000; 0.049996037140190; 0.001369863013699; 0.000272171425903; 0.142857142857143]; 
params_m4spswarm_8_3 = [0.100000000000000; 0.099656082522968; 0.010000000000000; 427.209673281194057; 0.059962277093604; 0.039511296724707; 0.000001000000000; 0.000000355564549; 0.000954988048927; 70.000000000000000; 77.000000000000000; 10.000000000000000; 9.875413725769073; 55.668428193401411; 741.574617484509190; 58.678095802831450; 698.493348333886047; 150.000000000000000; 16.077852235009900; 9.999969931618859; 17.316553300097336; 0.372038291111549; 75.000000000000000; 0.001052383817241; 0.015000000000000; 0.000000000001001; 74.997355399403048; 0.000000050000000; 7.983498428408294; 31.000000000000000; 20.000000000000000; 0.050031440889300; 0.000000000000000; 0.000000010000000; 0.049996004231792; 0.002104555487186; 0.000000193983781; 0.141782572437090];

county_M4
fprintf('params_m4spswarm_8_1 = [%s%.15f];\n', sprintf('%.15f; ', params_m4spswarm_8_1(1:end-1),params_m4spswarm_8_1(end)));
fprintf('params_m4spswarm_8_2 = [%s%.15f];\n', sprintf('%.15f; ', params_m4spswarm_8_2(1:end-1),params_m4spswarm_8_2(end)));
fprintf('params_m4spswarm_8_3 = [%s%.15f];\n', sprintf('%.15f; ', params_m4spswarm_8_3(1:end-1),params_m4spswarm_8_3(end)));


[t8_1, ypswarm_fit8_1] = ode23s(@M4_SF_S,tspan_8_1_F,y0,[],params_m4spswarm_8_1);
if length(ypswarm_fit8_1)<109
    frst_year_forecast_rrmse=1e10;
else
frst_year_forecast_rrmse=(rmse(ypswarm_fit8_1(98:109,4) , y_inf_data(98:109,1))/sqrt(sumsqr(y_inf_data(98:109,1)')))*100;
end

[t8_1_15, ypswarm_fit8_1_15] = ode15s(@M4_SF_S,tspan_8_1_F,y0,[],params_m4spswarm_8_1);
if length(ypswarm_fit8_1_15)<109
    frst_year_forecast_rrmse_15=1e10;
else
frst_year_forecast_rrmse_15=(rmse(ypswarm_fit8_1_15(98:109,4) , y_inf_data(98:109,1))/sqrt(sumsqr(y_inf_data(98:109,1)')))*100;
end

[t8_1_45, ypswarm_fit8_1_45] = ode45(@M4_SF_S,tspan_8_1_F,y0,[],params_m4spswarm_8_1);
if length(ypswarm_fit8_1_45)<109
    frst_year_forecast_rrmse_45=1e10;
else
frst_year_forecast_rrmse_45=(rmse(ypswarm_fit8_1_45(98:109,4) , y_inf_data(98:109,1))/sqrt(sumsqr(y_inf_data(98:109,1)')))*100;
end

if frst_year_forecast_rrmse_15<frst_year_forecast_rrmse
    frst_year_forecast_rrmse=frst_year_forecast_rrmse_15;
    ypswarm_fit8_1=ypswarm_fit8_1_15;
elseif frst_year_forecast_rrmse_45<frst_year_forecast_rrmse
    frst_year_forecast_rrmse=frst_year_forecast_rrmse_45;
    ypswarm_fit8_1=ypswarm_fit8_1_45;
end


[t8_2, ypswarm_fit8_2] = ode23s(@M4_SF_S,tspan_8_2_F,y0,[],params_m4spswarm_8_2);
if length(ypswarm_fit8_2)<109
    scnd_year_forecast_rrmse=1e10;
else
scnd_year_forecast_rrmse=(rmse(ypswarm_fit8_2(98:109,4) , y_inf_data(110:121,1))/sqrt(sumsqr(y_inf_data(110:121,1)')))*100;
end

[t8_2_15, ypswarm_fit8_2_15] = ode15s(@M4_SF_S,tspan_8_2_F,y0,[],params_m4spswarm_8_2);
if length(ypswarm_fit8_2_15)<109
    scnd_year_forecast_rrmse_15=1e10;
else
scnd_year_forecast_rrmse_15=(rmse(ypswarm_fit8_2_15(98:109,4) , y_inf_data(110:121,1))/sqrt(sumsqr(y_inf_data(110:121,1)')))*100;
end

[t8_2_45, ypswarm_fit8_2_45] = ode45(@M4_SF_S,tspan_8_2_F,y0,[],params_m4spswarm_8_2);
if length(ypswarm_fit8_2_45)<109
    scnd_year_forecast_rrmse_45=1e10;
else
scnd_year_forecast_rrmse_45=(rmse(ypswarm_fit8_2_45(98:109,4) , y_inf_data(110:121,1))/sqrt(sumsqr(y_inf_data(110:121,1)')))*100;
end

if scnd_year_forecast_rrmse_15<scnd_year_forecast_rrmse
    scnd_year_forecast_rrmse=scnd_year_forecast_rrmse_15;
    ypswarm_fit8_2=ypswarm_fit8_2_15;
elseif scnd_year_forecast_rrmse_45<scnd_year_forecast_rrmse
    scnd_year_forecast_rrmse=scnd_year_forecast_rrmse_45;
    ypswarm_fit8_2=ypswarm_fit8_2_45;
end

[t8_3, ypswarm_fit8_3] = ode23s(@M4_SF_S,tspan_8_3_F,y0,[],params_m4spswarm_8_3);
if length(ypswarm_fit8_3)<109
    thrd_year_forecast_rrmse=1e10;
else
    thrd_year_forecast_rrmse=(rmse(ypswarm_fit8_3(98:109,4) , y_inf_data(122:133,1))/sqrt(sumsqr(y_inf_data(122:133,1)')))*100;
end

[t8_3_15, ypswarm_fit8_3_15] = ode15s(@M4_SF_S,tspan_8_3_F,y0,[],params_m4spswarm_8_3);
if length(ypswarm_fit8_3_15)<109
    thrd_year_forecast_rrmse_15=1e10;
else
    thrd_year_forecast_rrmse_15=(rmse(ypswarm_fit8_3_15(98:109,4) , y_inf_data(122:133,1))/sqrt(sumsqr(y_inf_data(122:133,1)')))*100;
end

[t8_3_45, ypswarm_fit8_3_45] = ode45(@M4_SF_S,tspan_8_3_F,y0,[],params_m4spswarm_8_3);
if length(ypswarm_fit8_3_45)<109
    thrd_year_forecast_rrmse_45=1e10;
else
    thrd_year_forecast_rrmse_45=(rmse(ypswarm_fit8_3_45(98:109,4) , y_inf_data(122:133,1))/sqrt(sumsqr(y_inf_data(122:133,1)')))*100;
end

if thrd_year_forecast_rrmse_15<thrd_year_forecast_rrmse
    thrd_year_forecast_rrmse=thrd_year_forecast_rrmse_15;
    ypswarm_fit8_3=ypswarm_fit8_3_15;
elseif thrd_year_forecast_rrmse_45<thrd_year_forecast_rrmse
    thrd_year_forecast_rrmse=thrd_year_forecast_rrmse_45;
    ypswarm_fit8_3=ypswarm_fit8_3_45;
end

county_M4
fprintf('params_m4spswarm_8_1 = [%s%.15f];\n', sprintf('%.15f; ', params_m4spswarm_8_1(1:end-1),params_m4spswarm_8_1(end)));
fprintf('params_m4spswarm_8_2 = [%s%.15f];\n', sprintf('%.15f; ', params_m4spswarm_8_2(1:end-1),params_m4spswarm_8_2(end)));
fprintf('params_m4spswarm_8_3 = [%s%.15f];\n', sprintf('%.15f; ', params_m4spswarm_8_3(1:end-1),params_m4spswarm_8_3(end)));
frst_year_forecast_rrmse
scnd_year_forecast_rrmse
thrd_year_forecast_rrmse

%Display
figure
scatter(t_inf_data,y_inf_data, 'k','LineWidth',2)
hold on
plot(t8_1(1:97,1),ypswarm_fit8_1(1:97,4), 'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
plot(t8_1(97:109,1),ypswarm_fit8_1(97:109,4), 'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
plot(t8_2(97:109,1),ypswarm_fit8_2(97:109,4), 'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
plot(t8_3(97:109,1),ypswarm_fit8_3(97:109,4),'Color', [0 0 1 0.5], 'LineStyle', '-', 'LineWidth', 6)
xline(2922, 'k','LineWidth',2)
xline(3287, 'k','LineWidth',2)
xline(3652, 'k','LineWidth',2)
legend(county_M4+' Infected','Model 4 fit first 8 years', '2022 forecast','2023 forecast','2024 forecast','Location','best');
title(county_M4+" Valley Fever Model 4 Forecast ", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
subtitle("Forecasted 2022 RRMSE="+frst_year_forecast_rrmse+"%, Forecasted 2023 RRMSE="+scnd_year_forecast_rrmse...
    +"%, Forecasted 2024 RRMSE="+thrd_year_forecast_rrmse+"%", 'FontSize', 14)
xlabel('Year', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
ylim([0,max(y_inf_data)+200])
hold off
end









































elseif choose_model==7
%% Model 5 - Human, Vector, Fungal Model dependent on Food and Environment

if single_run_or_fitting==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %SINGLE RUN Model 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 5 single parameter run')
t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];

y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
y_pop_data_Pinal=[394200;425264;484239;513862];
y_pop_data_Pima=[1024000;1043433;1063162;1080149];
y_pop_data_AZ=[6849647;7151502;7431344;7582384];

y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

temp_data_Maricopa=[50;52.9;65;69.8;78.2;88.5;91.4;89.6;83.2;69.2;62.1;52.3;...
    56.5;59.8;64.5;69.8;77.9;87.2;91.3;86.4;84.4;74.7;61.8;53.9;55.1;61.5;...
    67.2;68.8;73;88.1;89.4;92.3;85.6;74.7;58;50.7;51.7;61.8;65.6;69.2;74.7;...
    90.2;93.2;88.8;82.4;76.6;63.6;54.8;52;58.5;66.8;70.7;76.9;89.4;91.8;...
    90.4;82.8;76.2;67.4;56.9;58.4;56.2;62.6;73;78.1;87.1;91.9;90.3;87.4;...
    69.6;59.7;52.5;52.8;50.2;61.4;70.3;71.1;85.6;92.4;92.6;84.2;71;62.2;...
    52.5;53.5;55.7;60.3;69;81.2;86.7;94;94.7;87;76.6;63.9;52.9;53.2;57;59.9;...
    71.6;77.4;89.9;90.2;88.8;84.7;69.9;66.2;55.2;53.7;55;62.5;70.7;78;89;92;...
    89;86;72.4;55.5;51.5;50;52.6;56.8;68.7;76.5;81.7;96;92;84.2;74.9;63.2;55.6];

%palmer z-index
soil_mstr_data_Maricopa=[11.19;9.57;9.05;8.3;8.4;8.6;10.31;9.64;10.95;8.72;...
    13.29;8.92;7.68;7.11;8.73;7.78;7.86;8.47;10.07;13.74;15.11;9.01;8.2;...
    10.15;10.2;7.97;8.1;8.49;10.23;9.47;8.95;7.89;9.81;11.29;9.41;8.75;10.84;...
    7.72;6.72;8.7;8.68;8.92;7.67;10.57;8.92;8.19;9.67;10.84;11;11.25;8.09;...
    8.62;9.25;8.84;12.26;8.76;8.04;7.75;7.43;7.89;7.82;8.77;7.47;7.25;7.91;...
    8.98;13.33;10.48;8.17;16.69;9.11;8.62;9.84;13.51;10.12;9.43;10.42;9.92;...
    8.32;7.2;13.61;8.33;14.64;10.86;8.77;10.93;13.42;11.24;11.26;8.67;7.06;...
    7.09;7.46;7.71;8.02;8.8;9.8;7.94;8.14;7.53;7.91;8.81;15.97;12.66;9.59;...
    9.52;7.61;11.6;8.49;8.95;7.88;7.87;8.12;9.31;10.8;12.56;9.97;10.21;9.47;...
    11.1;11.67;10.64;11.91;11.03;11.01;9.89;7.22;7.43;9.54;7.93;8.66;9.77];
tind = [15.5;45;74.5;105;135.5;166;196.5;227.5;258;288.5;319;349.5;380.5;410;...
    439.5;470;500.5;531;561.5;592.5;623;653.5;684;714.5;745.5;775;804.5;835;...
    865.5;896;926.5;957.5;988;1018.5;1049;1079.5;1110.5;1140.5;1170.5;1201;...
    1231.5;1262;1292.5;1323.5;1354;1384.5;1415;1445.5;1476.5;1506;1535.5;1566;...
    1596.5;1627;1657.5;1688.5;1719;1749.5;1780;1810.5;1841.5;1871;1900.5;1931;...
    1961.5;1992;2022.5;2053.5;2084;2114.5;2145;2175.5;2206.5;2236;2265.5;2296;...
    2326.5;2357;2387.5;2418.5;2449;2479.5;2510;2540.5;2571.5;2601.5;2631.5;2662;...
    2692.5;2723;2753.5;2784.5;2815;2845.5;2876;2906.5;2937.5;2967;2996.5;3027;...
    3057.5;3088;3118.5;3149.5;3180;3210.5;3241;3271.5;3302.5;3332;3361.5;3392;...
    3422.5;3453;3483.5;3514.5;3545;3575.5;3606;3636.5;3667.5;3697;3726.5;3757;...
    3787.5;3818;3848.5;3879.5;3910; 3940.5; 3971; 4001.5];

y_inf_data=y_inf_data_Maricopa;
y_pop_data=y_pop_data_Maricopa;

%Initial Conditions
ic_V_j=50;
ic_V_a=100;
ic_O=100;
ic_D=50;
ic_H=100;
ic_A=100;%100
ic_C=5;
ic_I=y_inf_data(1)/1;
ic_E_1=ic_I/2;%y_inf_data(1);
ic_E_2=ic_I/2;%y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_E_1-ic_E_2-ic_R);

y0=[ic_V_j;ic_V_a;ic_O;ic_D;ic_H;ic_A;ic_C;ic_S;ic_E_1;ic_E_2;ic_I;ic_R];
 
Parameters_M4_L_infdata = [10.0000000; 0.0400000; 0.0001000; 0.0000050; 350.0000000; 0.0000400; 0.0150000; 0.0150000; 0.0000010; 0.0020000; 75.0000000; 80.0000000; 13.0000000; 9.0000000; 60.0000000; 500.0000000; 70.0000000; 500.0000000; 70.0000000; 2000.0000000; 500.0000000; 2000.0000000; 500.0000000; 78.0000000; 0.0090000; 0.0050000; 0.0030000; 0.0010000; 0.0000000; 68.0000000; 0.0000040; 20.0000000; 90.0000000; 10.0000000; 0.1000000; 0.0000000; 0.0000009; 0.0999645; 0.0400000; 0.0003000; 0.0350000; 0]; 
Parameters_M5_L_infdata = [10.0000000; 0.0400000; 0.0001000; 0.0000050; 350.0000000; 0.0000400; 0.0150000; 0.0150000; 0.0000010; 0.0020000; 75.0000000; 80.0000000; 13.0000000; 9.0000000; 60.0000000; 500.0000000; 70.0000000; 500.0000000; 70.0000000; 2000.0000000; 500.0000000; 2000.0000000; 500.0000000; 78.0000000; 0.0090000; 0.0050000; 0.0030000; 0.0010000; 0.0000000; 68.0000000; 0.0000040; 20.0000000; 90.0000000; 10.0000000; 0.1000000; 0.0000000; 0.0000009; 0.0999645; 0.0400000; 0.0003000; 0.0350000; 0.0700000]; 
Parameters_M5_L_infdata-Parameters_M4_L_infdata;

alpha_h_maricopa= 0.100000000000000;
omega_maricopa= 0.099964544635737;

PI=10; delta_O=0.04; mu_H=0.0001;
gamma_H=0.000005; H_max=350; delta_H=0.00004;
gamma_A=0.014; delta_A=0.011; phi_A=0.000001;
delta_C=0.002; T_opt_H=75; T_opt_A=90; %80
%S_opt_H=80; S_opt_A=80; T_decay=60;
S_opt_H=13; S_opt_A=6; T_decay=60;
bl_Topt_A=500; ab_Topt_A=70; bl_Topt_H=500; 
ab_Topt_H=70; bl_Sopt_A=2000; ab_Sopt_A=500; 
bl_Sopt_H=2000; ab_Sopt_H=500; T_hs=78;
beta=0.009; mu_V=0.005; delta_V_j=0.003;
delta_V_a=0.001; sigma=0.00000000007; T_cs=68;
alpha=0.000004;  S_d_s=0; T_d_s=90; 
bl_S_H_s=2; ab_T_H_s=1; xtr_c_s=10; delta_R=0; 
epsilon=0.000002; rho=0.004; kappa=0.0000003;  psi_1=0.035;%psi=0.00033;
psi_2=0.035;
alpha_h=alpha_h_maricopa;
omega=omega_maricopa;%*0.9999;
%below for low vector input option
  % alpha=0.000004;
  % phi_A=0.000016;
 
paramsm5=[PI; delta_O; mu_H; gamma_H; H_max; delta_H; gamma_A; delta_A; ...
    phi_A; delta_C; T_opt_H; T_opt_A; S_opt_H; S_opt_A; T_decay; bl_Topt_A; ...
    ab_Topt_A; bl_Topt_H; ab_Topt_H; bl_Sopt_A; ab_Sopt_A; bl_Sopt_H; ...
    ab_Sopt_H; T_hs; beta; mu_V; delta_V_j; delta_V_a; sigma; T_cs; alpha; ...
    S_d_s; T_d_s; xtr_c_s; alpha_h; delta_R; epsilon; omega; rho; kappa; psi_1; psi_2];


 %ode run

 options = odeset(...
                'RelTol', 1e-2, ...
                'AbsTol', 1e-5, ...
                'MaxStep', 0.5, ...
                'InitialStep', 1e-6);
 % try
 %     [t, y] = ode15s(@(t, y) M5_SF(t, y, paramsm5), t_inf_data, y0, options);
 %     err_m4 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
 %    catch 
 %     try
 %         [t, y] =ode15s(@(t, y) M5_SF(t, y, paramsm5), t_inf_data, y0);
 %         err_m5 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
 %     catch
 %         try
 %            [t, y] = ode23s(@M5_SF,t_inf_data,y0,[],paramsm5);
 %            err_m5 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
 %         catch
 %             try
 %                 [t, y] =ode45(@(t, y) M5_SF(t, y, paramsm5), t_inf_data, y0);
 %                 err_m5 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
 %             catch
 %                 try
 %                     [t, y] =ode78(@(t, y) M5_SF(t, y, paramsm5), t_inf_data, y0);
 %                     err_m5 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
 %                 catch
 %                     disp('nothing worked')
 %                 end
 %             end
 %         end
 %     end
 % end
 [t, y] =ode15s(@(t, y) M5_SF(t, y, paramsm5), t_inf_data, y0);
 err_m5 = (rmse(y(:,11) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;

%[t, y] =ode15s(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
%[t, y] = ode23s(@M4_SF,t_inf_data,y0,[],paramsm4);
%[t, y] =ode45(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
%[t, y] =ode78(@(t, y) M4_SF(t, y, paramsm4), t_inf_data, y0);
%err_m4 = (rmse(y(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;


fprintf('y_inf_data_M5_L = [%s%.4f];\n', sprintf('%.4f; ', y(1:end-1,11),y(end,11)));
disp('space')
fprintf('Parameters_M5_L_infdata = [%s%.7f];\n', sprintf('%.7f; ', paramsm5(1:end-1),paramsm5(end)));
disp('space')
 %plotting results

%  plot(t,40*sin(((2*pi)/365)*t)+70,'color', [.55 .55 .55],'LineWidth',2);
% hold on
% plot(t,49*sin(((2*pi)/365)*t-(pi/8))+50,'color', [.85 .85 .85],'LineWidth',2);

figure
plot(t,y(:,1),'color', [0.4940 0.1840 0.5560],'LineWidth',2)
hold on
plot(t,y(:,2),'color', [0.9290 0.6940 0.1250],'LineWidth',2)
legend('Juvenile vector','Adult vector','FontSize', 16,'Location','best');
title("Valley Fever Model 5 - Vector and Fungal Model dependent on Food and Environmentn Food & Env.", 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); %ylabel('Infected Humans', 'FontSize', 18)
hold off

figure
plot(t,y(:,3),'b','LineWidth',2)
hold on
plot(t,y(:,4),'c','LineWidth',2)
legend('Organic Matter','Decayed Organic Matter','FontSize', 16,'Location','best');
title("Valley Fever Model 5 - Vector and Fungal Model dependent on Food and Environmentn Food & Env.", 'FontSize', 22)
xticks(t_inf_data)
% xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
% xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); %ylabel('Infected Humans', 'FontSize', 18)
hold off

% plot(t,40*sin(((2*pi)/365)*t)+70,'color', [.55 .55 .55],'LineWidth',2);
% hold on
% plot(t,49*sin(((2*pi)/365)*t-(pi/8))+50,'color', [.85 .85 .85],'LineWidth',2);
figure
scatter(tind, temp_data_Maricopa,'k','LineWidth',4)
hold on
plot(t,y(:,5),'r','LineWidth',2)
plot(t,y(:,6),'g','LineWidth',2)
plot(t,y(:,7),'k','LineWidth',2)
legend('Temp','Hyphae','Arthroconidia','Colonies', 'FontSize', 16,'Location','best');
title("Valley Fever Model 5 - Vector and Fungal Model dependent on Food & Environment", 'FontSize', 22)
xticks(t_inf_data)
 %xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
 %xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Year', 'FontSize', 18); %ylabel('Infected Humans', 'FontSize', 18)
hold off

figure
plot(t,y(:,8),'r','LineWidth',8)
hold on
scatter(t_inf_data,y_inf_data,'k','LineWidth',4)
plot(t,y(:,9),'g','LineWidth',4)
plot(t,y(:,10),'color','[0.9290 0.4940 0.0250]','LineWidth',6)
plot(t,y(:,11),'color','[0.5 0 0.5]','LineWidth',8)
plot(t,y(:,12),'b','LineWidth',2)
legend('Susceptible','INF DATA','Exposed_1','Exposed_2','Infected','Recovered', 'FontSize', 16,'Location','best');
title("Valley Fever Model 5 - Vector and Fungal Model dependent on Food & Environment", 'FontSize', 24)
%xticks(t_inf_data)
subtitle("Infected Manual M5 RRMSE="+err_m5, 'FontSize', 14)
 xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
 xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 corresponds to Jan. 1 2013)', 'FontSize', 18); ylabel('Humans', 'FontSize', 18)
ylim([0,max(y_inf_data)+200])
hold off


elseif single_run_or_fitting==2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %FITTING Model 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running Model 5 fitting')


global alpha_h_maricopa omega_maricopa alpha_h_pinal omega_pinal alpha_h_pima omega_pima alpha_h_AZ omega_AZ
alpha_h_maricopa= 0.000035386745035+0.049996054144265;
omega_maricopa= 0.049996054144265;

alpha_h_pinal= 0.000054197479825+0.049562154054803; %*use looser bounds
omega_pinal= 0.049562154054803; %*use looser bounds

alpha_h_pima= 0.000010637066754+0.050079359342677;
omega_pima= 0.050079359342677;

alpha_h_AZ= 0.002876562772732+0.058375000164113;
omega_AZ= 0.058375000164113;

%import/load data
y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
y_pop_data_Pinal=[394200;425264;484239;513862];
y_pop_data_Pima=[1024000;1043433;1063162;1080149];
y_pop_data_AZ=[6849647;7151502;7431344;7582384];


y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data_Pinal=[53.74285714;48.85714286;36.28571429;15.42857143;17.71428571;...
    34.14285714;33.57142857;30.57142857;35.42857143;25.42857143;34.14285714;...
    41.42857143;61;38.85714286;35.14285714;54.85714286;43.71428571;57.42857143;...
    40.14285714;27.42857143;33.42857143;28.14285714;22.28571429;30;33.57142857;...
    37;32;37.57142857;48.28571429;42.14285714;48.71428571;60.42857143;...
    68.71428571;71.28571429;78.85714286;73.14285714;56.85714286;47.85714286;...
    42.14285714;42.14285714;57.85714286;32.71428571;28.42857143;50.85714286;...
    30.71428571;26.42857143;42.71428571;47.85714286;49.28571429;47.42857143;...
    24.57142857;42;36.57142857;39.28571429;33.57142857;33.85714286;46.71428571;...
    26;46.85714286;64.71428571;85.42857143;65.57142857;34.85714286;36.57142857;...
    47.42857143;56.57142857;43;52.85714286;37.57142857;32;51.85714286;42.14285714;...
    63.57142857;52.14285714;57.57142857;66.57142857;56.71428571;75.71428571;...
    77.71428571;81.57142857;80;65.28571429;91.85714286;121.8571429;118;...
    83.28571429;71.71428571;36.28571429;45.85714286;71.42857143;77.57142857;...
    87.85714286;99.85714286;118;112.1428571;121.7142857;162.2857143;117.1428571;...
    99;105.8571429;76.57142857;62.57142857;58.14285714;73.71428571;62.42857143;...
    61.28571429;65.85714286;78.57142857;133.8571429;99.85714286;66.42857143;74;...
    69.71428571;79.28571429;73.85714286;95.28571429;49.28571429;50.85714286;...
    50.71428571;61.14285714;70.57142857;56.57142857;49;62.57142857;49.71428571;...
    57.57142857;59.57142857;100.5714286;93.85714286;77.57142857;106.4285714;...
    131.4285714;141.1428571];

y_inf_data_Pima=[128.0714286;116.4285714;70.57142857;42.28571429;62.57142857;...
    71.71428571;88.28571429;71.28571429;88.85714286;72.28571429;80.28571429;...
    106.4285714;137;82.28571429;91.85714286;77.28571429;81.57142857;82;80.42857143;...
    46.57142857;62;52.28571429;61;57.14285714;58.57142857;96;66;58.57142857;...
    71.28571429;75;148.1428571;115.7142857;112.8571429;146.2857143;114.1428571;...
    109.1428571;86.85714286;80.28571429;64.71428571;79.42857143;73.57142857;...
    79.57142857;73.28571429;75.85714286;55.71428571;68.14285714;60.71428571;...
    90;95.71428571;83.85714286;64.14285714;74.28571429;87.42857143;67;63.85714286;...
    105.4285714;75.85714286;58.14285714;82.42857143;128.5714286;146;90.42857143;...
    83.85714286;71.71428571;59.42857143;83.28571429;97.28571429;103.2857143;...
    87.71428571;76.28571429;76;75;62.71428571;85.71428571;111.8571429;127.5714286;...
    115.7142857;115.5714286;122;146.5714286;143;100.1428571;118.4285714;123.4285714;...
    131;101;110;92.57142857;82.57142857;102.8571429;122.2857143;125.2857143;...
    164.5714286;143.1428571;127.7142857;162.4285714;165.5714286;138.5714286;...
    138.2857143;140.7142857;88.14285714;110;104.5714286;117.7142857;84.28571429;...
    80.14285714;92.14285714;98.85714286;123.5714286;95.42857143;57.14285714;...
    83.85714286;83.57142857;112.2857143;113.8571429;139.7142857;100.5714286;...
    81.71428571;89.14285714;79;93.71428571;103.4285714;87.57142857;89;87.28571429;...
    100.5714286;104;109.4285714;115.2857143;93.42857143;113.4285714;132;134.5714286];

y_inf_data_AZ=[798.9142857;726.2857143;461.5714286;326;356.4285714;425;431.5714286;...
    431.4285714;463.7142857;401.1428571;489.7142857;682.1428571;696;564.8571429;...
    591.8571429;574;529.2857143;595;505.1428571;319.5714286;347.8571429;352.2857143;...
    325.7142857;338.8571429;435.5714286;410;380;432.5714286;517.4285714;471.7142857;...
    700.1428571;727.7142857;778.7142857;944.5714286;786.1428571;800;684;581.2857143;...
    464.1428571;574.4285714;529.1428571;459;454.8571429;483.2857143;495.4285714;...
    392.4285714;553;590;577;532.1428571;416;408.7142857;457.1428571;442.7142857;...
    417.2857143;522.8571429;522.2857143;444.8571429;643.4285714;953.8571429;...
    1184.714286;898.2857143;584.4285714;564.2857143;552;663;611;689.5714286;...
    609.8571429;538;622.7142857;523.4285714;630.4285714;745.5714286;658;811.4285714;...
    749.7142857;797.7142857;818.2857143;943.2857143;971;798.2857143;902.4285714;...
    1115.285714;1059;930;830;635.2857143;475.7142857;630.5714286;747.1428571;...
    800.2857143;1067.142857;1188.285714;1175.571429;1382.857143;1560.142857;...
    1323.285714;1113.428571;1147.285714;863.1428571;854.4285714;809;814.4285714;...
    810.7142857;736.7142857;842;1009.857143;1223.714286;952.8571429;673.5714286;...
    704.5714286;787;948.1428571;911.2857143;1072.571429;715.7142857;625.8571429;...
    617.1428571;691.2857143;759;704.4285714;615.2857143;773.5714286;702.4285714;...
    750.7142857;706;869.2857143;974.4285714;929.8571429;1126;1335;1417];

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];

y_inf_data=y_inf_data_AZ;
y_pop_data=y_pop_data_AZ;
alpha_h_b=alpha_h_AZ;
omega_b=omega_AZ;
county_M5=["AZ"];
county=1; %1=AZ, 2=Maricopa, 3=Pima, 4=Pinal

%new ICS, reorder bounds, redo objective function/parswarm settings
%Initial Conditions
ic_V=5000;
ic_O=40;
ic_D=70;
ic_H=100;%
ic_A=50;%100
ic_I=y_inf_data(1)/1;
ic_E=ic_I*1.5;%y_inf_data(1);
ic_A_H=y_inf_data(1);
ic_R=ic_I/2;
ic_S=(y_pop_data(1)-ic_I-ic_A_H-ic_E-ic_R);
y0=[ic_V;ic_O;ic_D;ic_H;ic_A;ic_S;ic_E;ic_A_H;ic_I;ic_R];


%Parameter Ranges
%Q_18                %k_ref               %T_ref 
LB(1) = 0.001;       LB(2) = 1.5;         LB(3) = 55;
UB(1) = 0.06;        UB(2) = 3.5;         UB(3) = 80;      
%mu_H
LB(4) = 0.000001;        
UB(4) = 0.1;

% gamma_h            % H_max                %delta_H
LB(5) =  0.00000001;    LB(6) = 210;         LB(7) = 0.000001;         
UB(5) = 0.06;        UB(6) = 450;         UB(7) = 0.2;

% gamma_A            % delta_A              %phi_A
LB(8) = 0.000001;    LB(9) = 0.0000001;    LB(10) = 0.000000001;        
UB(8) = 0.1;        UB(9) = 0.2;          UB(10) = 0.00001;

%T_opt_H            %T_opt_A
LB(11) = 65;        LB(12) = 77;      
UB(11) = 85;        UB(12) = 90; 

% S_opt_H            %S_opt_A                 
LB(13) = 10;         LB(14) = 7;          
UB(13) = 13;         UB(14) = 10;        

% bl_Topt_A            %ab_Topt_A        %bl_Topt_H
LB(15) = 200;         LB(16) = 30;       LB(17) = 200;      
UB(15) = 700;        UB(16) = 100;        UB(17) = 700;

% ab_Topt_H            %bl_Sopt_A         %ab_Sopt_A
LB(18) = 30;         LB(19) = 2;         LB(20) = 0.1;      
UB(18) = 100;          UB(19) = 20;       UB(20) = 8;

% bl_Sopt_H           %ab_Sopt_H           %T_hs       
LB(21) = 2;           LB(22) = 0.1;       LB(23) = 75;
UB(21) = 20;           UB(22) = 8;        UB(23) = 90;

% beta;                                    
LB(24) = 0.000001;             
UB(24) = 0.03;                    

% delta_V;              %sigma;                         %T_cs;        
LB(25) = 0.000008;      LB(26) = 0.000000000001;       LB(27) = 60;
UB(25) = 0.015;         UB(26) = 0.0000000007;       UB(27) = 75;

% alpha;                  %S_d_s;%Fit later           %T_d_s; %Fit later     
LB(28) = 0.0000000005;    LB(29) = 5;             LB(30) = 95;
                         %20up/down for %32 when fit to synth data
UB(28) = 0.0001;          UB(29) = 8;               UB(30) = 95;

% xtr_c_s;         % alpha_h                         %epsilon
LB(31) = 1;        LB(32) = alpha_h_b*0.999999;      LB(33) = 0.00000001;   
UB(31) = 20;       UB(32) = alpha_h_b*1.000001;      UB(33) = 0.0001;      

% omega                           % rho_I                %kappa
LB(34) = omega_b*0.999999;    LB(35) = 1/(2*365);        LB(36) = 0.000000027768;        
UB(34) = omega_b*1.000001;    UB(35) = 1/14;         UB(36) = 0.000359; 

% psi               %delta_D                    %rho_A
LB(37) = 1/60;      LB(38) = 0.000001;         LB(39) = 1/365;
UB(37) = 1/5;       UB(38) = 0.06;              UB(39) = 1/14;  
  
%FITTING
tspan=t_inf_data;
pool = gcp; % Will create a pool if none exists
numWorkers = pool.NumWorkers;
disp(numWorkers);
format long

  options = optimset('Algorithm','interior-point','TolX',1e-20,'TolFun',1e-20,'TolCon'...
    ,1e-20,'MaxIter',200000,'MaxFunEvals',100000);
 % options = optimoptions("fmincon",...
 %    Algorithm="interior-point",...
 %    EnableFeasibilityMode=true,...
 %    SubproblemAlgorithm="cg");

 options = optimoptions('fmincon', ...
    'UseParallel', true, ...
    'Algorithm','interior-point',...
    'TolX',1e-20,...
    'TolFun',1e-20,...
    'TolCon',1e-20,...
    'MaxIter',200000,...
    'MaxFunEvals',100000,...
    'Display', 'iter');

 options = optimoptions('fmincon', ...
    'UseParallel', true, ...
    'Algorithm', 'interior-point', ...
    'Display', 'iter-detailed', ...
    'MaxFunctionEvaluations', 1e5, ...
    'StepTolerance', 1e-8);
  
 options = optimoptions('fmincon', ...
    'Algorithm', 'interior-point', ...
    'Display', 'iter-detailed', ...
    'MaxFunctionEvaluations', 1e5, ...
    'StepTolerance', 1e-8);

 options = optimset('Algorithm','interior-point','TolX',1e-13,'TolFun',1e-13,'TolCon'...
    ,1e-13,'MaxIter',2000,'MaxFunEvals',3000);
 % Parameters initial guess 
    %p0 = [((LB + UB) / 2)'];

%without options
%p_opt = fmincon(@(p) objective_functionM4(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, []);
%with options    
% p_opt = fmincon(@(p) objective_functionM5(p, tspan, y0, y_inf_data), p0, [], [], [], [], LB, UB, [], options);
% % 
% %     % Display optimized parameters
% params_m5fmin=p_opt
% fprintf('params_m5fmin = [%s%.15f];\n', sprintf('%.15f; ', params_m5fmin(1:end-1),params_m5fmin(end)));

optionsfast = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*5, ...
    'MaxIterations', 2000, ...
    'MaxStallIterations', 10, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-5, ... %1e-15
    'Display', 'iter');

optionsmedium = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*50, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 1.5, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-12, ... %1e-15
    'Display', 'iter');

optionsslow = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*100, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 120, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 0.9, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-15, ... %1e-15
    'Display', 'iter');
%'InitialSwarmMatrix', initial_points, ...
options=optionsfast;
[params_m5pswarm, errorOBJ]= particleswarm(@(p) objective_functionM5(p, tspan, y0, y_inf_data,county),length(LB),LB,UB,options);
fprintf('params_m5pswarm = [%s%.15f];\n', sprintf('%.15f; ', params_m5pswarm(1:end-1),params_m5pswarm(end)));
county_M5
errorOBJ
filename = "params_m5pswarm_" + county_M5 + ".mat";
save(filename, 'params_m5pswarm');
filename = "m5_RRMSE_" + county_M5 + ".mat";
save(filename, 'errorOBJ');

[params_m5pswarm_RSS, rss]= particleswarm(@(p) objective_functionM5_RSS(p, tspan, y0, y_inf_data,county),length(LB),LB,UB,options);
filename = "params_m5pswarm_RSS_" + county_M5 + ".mat";
save(filename, 'params_m5pswarm_RSS');
filename = "m5_RSS_" + county_M5 + ".mat";
save(filename, 'rss');

num_data_points = numel(y_inf_data);    % n
k = numel(LB);               % k

% Calculate AIC, AICc, BIC (same formulas)
aic = num_data_points * log(rss / num_data_points) + 2 * k;
aicc = aic + (2 * k * (k + 1)) / (num_data_points - k - 1);
bic = num_data_points * log(rss / num_data_points) + k * log(num_data_points);

%Display Results
fprintf('Model 5 Information Criteria Results \n');
fprintf('RSS: %.4f\n', rss);
fprintf('AIC: %.4f\n', aic);
fprintf('AICc: %.4f\n', aicc);
fprintf('BIC: %.4f\n', bic);

options = odeset(...
                'RelTol', 1e-2, ...
                'AbsTol', 1e-4, ...
                'MaxStep', 1e-4, ...
                'InitialStep', 1e-3);


[t, ypswarm] = ode15s(@(t, y) M5_SF(t, y, params_m5pswarm), t_inf_data, y0, options);
 err_pswarm_m5 = (rmse(ypswarm(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;

% [t, yfmin] = ode15s(@(t, y) M5_SF(t, y, params_m4fmin), t_inf_data, y0, options);
% err_fmin_m5 = (rmse(yfmin(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;


figure
scatter(t_inf_data,y_inf_data, 'b','LineWidth',1)
hold on
%plot(t,yfmin(:,10),'c','LineWidth',2.5)
plot(t,ypswarm(:,10),'k','LineWidth',2)
legend('Maricopa Infected','FMin Model 4 fit','Location','best');
legend('Maricopa Infected','FMin Model 4 fit','Pswarm Model 4 fit','Location','best');
title("Valley Fever Model 4  -"+county_M5, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
subtitle("Infected Pswarm M5 RRMSE= "+err_pswarm_m5, 'FontSize', 14)
%subtitle("Infected Fmin M4 RRMSE="+err_fmin_m4+", Infected Pswarm M4 RRMSE="+err_pswarm_m4, 'FontSize', 14)
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
ylim([0 max(y_inf_data)+200])
hold off

y=yfmin;
% if err_fmin_m4<err_pswarm_m4
%     y=yfmin;
% else
%     y=ypswarm;
% end

%plotting of results for specific params 
 figure
plot(t,y(:,1), 'b','LineWidth',2)
hold on
plot(t,y(:,2),'c','LineWidth',2)
legend('Juvenile Vector','Adult Vector','Location','best');
title("Valley Fever Model 4 - Vector/Fungal Model dependent on Food & Env. -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('Mass', 'FontSize', 18)
hold off

figure
plot(t,y(:,3), 'b','LineWidth',2)
hold on
plot(t,y(:,4),'c','LineWidth',2)
legend('Organic Matter','Decomposed Organic Matter','Location','best');
title("Valley Fever Model 4 - Vector/Fungal Model dependent on Food & Env. -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('Mass', 'FontSize', 18)
hold off

figure
plot(t,ypswarm(:,5), 'r','LineWidth',2);
hold on
plot(t,ypswarm(:,6),'g','LineWidth',2)
plot(t,y(:,7), 'k','LineWidth',2);
legend('Hyphae Structure','Arthroconidia','Colonies','Location','best');
title("Valley Fever Model 4 - Vector/Fungal Model dependent on Food & Env. -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('PPM', 'FontSize', 18)
hold off

figure
plot(t,y(:,8), 'color',[0.4660 0.6740 0.1880],'LineWidth',2);
hold on
plot(t,y(:,9),'color',[0.9290 0.4940 0.0250],'LineWidth',2);
plot(t,y(:,10), 'color',[.5 0 .5],'LineWidth',2);
plot(t,y(:,11), 'k','LineWidth',2);
legend('Susceptible','Exposed','Infected','Recovered','Location','best');
title("Valley Fever Model 5 - Vector/Fungal Model dependent on Food & Env. -"+county_M4, 'FontSize', 22)
xticks(t_inf_data)
%xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023'})
xlabel('Day (Day 0 correspondes to Jan. 1 2013)', 'FontSize', 18); ylabel('Humans', 'FontSize', 18)
hold off

end


















elseif choose_model==8
%% Model 6 function  %%UNFINISHED$$ Patch
%%%%%%%%%%%%% Parameter values  %%%%%%%%%%%%%%%%%%%%%
%beta_HM= .0008; delta=.08 ; alpha=.003 ; omega=.05 ;  beta_MH=.0008;
PI= 10; mu_H= .03; GAM= 100; mu_M= .4; delta=.08;
beta_HM= 8.80e-04; alpha=0.0031; omega=.0483; beta_MH=8.80e-04; 

%Initial Conditions/parameters of 2 patch SIRS model
S_1_0=1000;
I_1_0=10;
R_1_0=10;
S_2_0=500;
I_2_0=5;
R_2_0=5;
theta_S_1_2=0.05; theta_S_2_1=0.1; theta_I_1_2=0.01; theta_I_2_1=0.02;
theta_R_1_2=0.025; theta_R_2_1=0.05; beta_1_1=0.0008; 
beta_1_2=0.0004; beta_2_2=0.0008; beta_2_1=0.0004;
gamma=0.05; delta=0.001;

y0=[S_1_0;I_1_0;R_1_0;S_2_0;I_2_0;R_2_0;];
params=[theta_S_1_2;theta_S_2_1;theta_I_1_2;theta_I_2_1;theta_R_1_2;theta_R_2_1;beta_1_1;beta_1_2;beta_2_2;beta_2_1;gamma;delta];
[t,y]=ode15s(@SIRS_2patch,[0:1:100],y0,[],params);

figure
% plot(0:100, MSusceptible_H, 'b--o','LineWidth',1);
% hold on
% plot(0:100, MInfected_H,'c--o','LineWidth',1);
% plot(0:100, MRecovered_H, 'r--o','LineWidth',1);
% plot(0:100, MSusceptible_M, 'g--o','LineWidth',1);
% plot(0:100, MInfected_M,'k--o','LineWidth',1);

plot(t,y(:,1), 'b','LineWidth',2)
hold on
plot(t,y(:,2),'c','LineWidth',2)
plot(t,y(:,3), 'r','LineWidth',2);
plot(t,y(:,4),'b--o','LineWidth',2)
plot(t,y(:,5), 'c--o','LineWidth',2);
plot(t,y(:,6), 'r--o','LineWidth',2);
legend('S1_{ODE}','I1_{ODE}','R1_{ODE}','S2_{ODE}','I2_{ODE}','R2_{ODE}');%,...
%    'H Susceptible_{ODE}','H Infected_{ODE}','H Recovered_{ODE}','M Susceptible_{ODE}','M Infected_{ODE}');
title("2 patch SIRS Model ODE v Stochastic Petri Net", 'FontSize', 24)
%subtitle("Infected humans RRMSE="+err_I_H, 'FontSize', 14)
hold off







elseif choose_model==9
    %% Plotting Fittings
choose_region=1; %1=AZ, 2=Maricopa, 3=Pima, 4=pinal

 %import/load data
y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
y_pop_data_Pinal=[394200;425264;484239;513862];
y_pop_data_Pima=[1024000;1043433;1063162;1080149];
y_pop_data_AZ=[6849647;7151502;7431344;7582384];


y_inf_data_Maricopa=[565.4;514;323.7142857;232.7142857;258.1428571;...
    294.1428571;286;305;324.2857143;281.4285714;337.2857143;500.2857143;...
    460;406.7142857;439;418.2857143;372.2857143;419.7142857;353.1428571;227;...
    224.7142857;253.2857143;223.1428571;225.2857143;315.4285714;244;268;...
    312.2857143;364.2857143;331.5714286;448.8571429;501.7142857;557.5714286;...
    674.2857143;553.4285714;586.2857143;505.7142857;414.5714286;340.4285714;...
    427.8571429;369.1428571;318.8571429;333.7142857;327.5714286;369.7142857;...
    284;425.1428571;427.1428571;398.8571429;370.4285714;290;264;305.7142857;...
    310.7142857;290.8571429;345.5714286;364.1428571;323.5714286;477.8571429;...
    721.1428571;905;702.7142857;437.5714286;428.7142857;421;481;430;494.5714286;...
    448;389.8571429;461.7142857;362.4285714;464.4285714;555;440.4285714;...
    567.5714286;514;545.2857143;556.1428571;657.8571429;666.7142857;575;...
    631.7142857;806.2857143;754;677;597;463.4285714;305.5714286;415.4285714;...
    500.7142857;535.4285714;735;860;882.4285714;1035.571429;1150.428571;...
    994.2857143;804.7142857;829.4285714;637.5714286;620.8571429;605.7142857;...
    571.4285714;613.8571429;529.4285714;646.1428571;773.2857143;919.2857143;...
    708.8571429;514.2857143;501.7142857;593.1428571;692.5714286;669.7142857;...
    773.7142857;525.5714286;442.7142857;430.4285714;514.1428571;558.1428571;...
    501.4285714;433.2857143;548.8571429;511.4285714;542;491.1428571;...
    609.7142857;704;689.1428571;842.4285714;989.1428571;1072.428571];

y_inf_data_Pinal=[53.74285714;48.85714286;36.28571429;15.42857143;17.71428571;...
    34.14285714;33.57142857;30.57142857;35.42857143;25.42857143;34.14285714;...
    41.42857143;61;38.85714286;35.14285714;54.85714286;43.71428571;57.42857143;...
    40.14285714;27.42857143;33.42857143;28.14285714;22.28571429;30;33.57142857;...
    37;32;37.57142857;48.28571429;42.14285714;48.71428571;60.42857143;...
    68.71428571;71.28571429;78.85714286;73.14285714;56.85714286;47.85714286;...
    42.14285714;42.14285714;57.85714286;32.71428571;28.42857143;50.85714286;...
    30.71428571;26.42857143;42.71428571;47.85714286;49.28571429;47.42857143;...
    24.57142857;42;36.57142857;39.28571429;33.57142857;33.85714286;46.71428571;...
    26;46.85714286;64.71428571;85.42857143;65.57142857;34.85714286;36.57142857;...
    47.42857143;56.57142857;43;52.85714286;37.57142857;32;51.85714286;42.14285714;...
    63.57142857;52.14285714;57.57142857;66.57142857;56.71428571;75.71428571;...
    77.71428571;81.57142857;80;65.28571429;91.85714286;121.8571429;118;...
    83.28571429;71.71428571;36.28571429;45.85714286;71.42857143;77.57142857;...
    87.85714286;99.85714286;118;112.1428571;121.7142857;162.2857143;117.1428571;...
    99;105.8571429;76.57142857;62.57142857;58.14285714;73.71428571;62.42857143;...
    61.28571429;65.85714286;78.57142857;133.8571429;99.85714286;66.42857143;74;...
    69.71428571;79.28571429;73.85714286;95.28571429;49.28571429;50.85714286;...
    50.71428571;61.14285714;70.57142857;56.57142857;49;62.57142857;49.71428571;...
    57.57142857;59.57142857;100.5714286;93.85714286;77.57142857;106.4285714;...
    131.4285714;141.1428571];

y_inf_data_Pima=[128.0714286;116.4285714;70.57142857;42.28571429;62.57142857;...
    71.71428571;88.28571429;71.28571429;88.85714286;72.28571429;80.28571429;...
    106.4285714;137;82.28571429;91.85714286;77.28571429;81.57142857;82;80.42857143;...
    46.57142857;62;52.28571429;61;57.14285714;58.57142857;96;66;58.57142857;...
    71.28571429;75;148.1428571;115.7142857;112.8571429;146.2857143;114.1428571;...
    109.1428571;86.85714286;80.28571429;64.71428571;79.42857143;73.57142857;...
    79.57142857;73.28571429;75.85714286;55.71428571;68.14285714;60.71428571;...
    90;95.71428571;83.85714286;64.14285714;74.28571429;87.42857143;67;63.85714286;...
    105.4285714;75.85714286;58.14285714;82.42857143;128.5714286;146;90.42857143;...
    83.85714286;71.71428571;59.42857143;83.28571429;97.28571429;103.2857143;...
    87.71428571;76.28571429;76;75;62.71428571;85.71428571;111.8571429;127.5714286;...
    115.7142857;115.5714286;122;146.5714286;143;100.1428571;118.4285714;123.4285714;...
    131;101;110;92.57142857;82.57142857;102.8571429;122.2857143;125.2857143;...
    164.5714286;143.1428571;127.7142857;162.4285714;165.5714286;138.5714286;...
    138.2857143;140.7142857;88.14285714;110;104.5714286;117.7142857;84.28571429;...
    80.14285714;92.14285714;98.85714286;123.5714286;95.42857143;57.14285714;...
    83.85714286;83.57142857;112.2857143;113.8571429;139.7142857;100.5714286;...
    81.71428571;89.14285714;79;93.71428571;103.4285714;87.57142857;89;87.28571429;...
    100.5714286;104;109.4285714;115.2857143;93.42857143;113.4285714;132;134.5714286];

y_inf_data_AZ=[798.9142857;726.2857143;461.5714286;326;356.4285714;425;431.5714286;...
    431.4285714;463.7142857;401.1428571;489.7142857;682.1428571;696;564.8571429;...
    591.8571429;574;529.2857143;595;505.1428571;319.5714286;347.8571429;352.2857143;...
    325.7142857;338.8571429;435.5714286;410;380;432.5714286;517.4285714;471.7142857;...
    700.1428571;727.7142857;778.7142857;944.5714286;786.1428571;800;684;581.2857143;...
    464.1428571;574.4285714;529.1428571;459;454.8571429;483.2857143;495.4285714;...
    392.4285714;553;590;577;532.1428571;416;408.7142857;457.1428571;442.7142857;...
    417.2857143;522.8571429;522.2857143;444.8571429;643.4285714;953.8571429;...
    1184.714286;898.2857143;584.4285714;564.2857143;552;663;611;689.5714286;...
    609.8571429;538;622.7142857;523.4285714;630.4285714;745.5714286;658;811.4285714;...
    749.7142857;797.7142857;818.2857143;943.2857143;971;798.2857143;902.4285714;...
    1115.285714;1059;930;830;635.2857143;475.7142857;630.5714286;747.1428571;...
    800.2857143;1067.142857;1188.285714;1175.571429;1382.857143;1560.142857;...
    1323.285714;1113.428571;1147.285714;863.1428571;854.4285714;809;814.4285714;...
    810.7142857;736.7142857;842;1009.857143;1223.714286;952.8571429;673.5714286;...
    704.5714286;787;948.1428571;911.2857143;1072.571429;715.7142857;625.8571429;...
    617.1428571;691.2857143;759;704.4285714;615.2857143;773.5714286;702.4285714;...
    750.7142857;706;869.2857143;974.4285714;929.8571429;1126;1335;1417];

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];

y_inf_data=y_inf_data_AZ;
y_pop_data=y_pop_data_AZ;

%Initial Conditions
ic_D_M1=70;
ic_H_M1=200;%
ic_I_M1=y_inf_data(1);
ic_R_M1=ic_I_M1/2;
ic_S_M1=(y_pop_data(1)-ic_I_M1-ic_R_M1);
y0_M1=[ic_D_M1;ic_H_M1;ic_S_M1;ic_I_M1;ic_R_M1];

ic_O_M2=40;
ic_D_M2=70;
ic_H_M2=100;%
ic_A_M2=50;%100
ic_C_M2=10;
ic_I_M2=y_inf_data(1)/1;
ic_E_M2=ic_I_M2*1.5;%y_inf_data(1);
ic_R_M2=ic_I_M2/2;
ic_S_M2=(y_pop_data(1)-ic_I_M2-ic_E_M2-ic_R_M2);
y0_M2=[ic_O_M2;ic_D_M2;ic_H_M2;ic_A_M2;ic_C_M2;ic_S_M2;ic_E_M2;ic_I_M2;ic_R_M2];

ic_O_M3=40;
ic_D_M3=70;
ic_H_M3=100;%
ic_A_M3=50;%100
ic_C_M3=10;
ic_I_M3=y_inf_data(1)/1;
ic_E_M3=ic_I_M3*1.5;%y_inf_data(1);
ic_R_M3=ic_I_M3/2;
ic_S_M3=(y_pop_data(1)-ic_I_M3-ic_E_M3-ic_R_M3);
y0_M3=[ic_O_M3;ic_D_M3;ic_H_M3;ic_A_M3;ic_C_M3;ic_S_M3;ic_E_M3;ic_I_M3;ic_R_M3];

ic_V_M4=5000;
ic_O_M4=40;
ic_D_M4=70;
ic_H_M4=100;%
ic_A_M4=50;%100
ic_C_M4=10;
ic_I_M4=y_inf_data(1)/1;
ic_E_M4=ic_I_M4*1.5;%y_inf_data(1);
ic_R_M4=ic_I_M4/2;
ic_S_M4=(y_pop_data(1)-ic_I_M4-ic_E_M4-ic_R_M4);
y0_M4=[ic_V_M4;ic_O_M4;ic_D_M4;ic_H_M4;ic_A_M4;ic_C_M4;ic_S_M4;ic_E_M4;ic_I_M4;ic_R_M4];

ic_V_M5=5000;
ic_O_M5=40;
ic_D_M5=70;
ic_H_M5=100;%
ic_A_M5=50;%100
ic_C_M5=10;
ic_I_M5=y_inf_data(1)/1;
ic_E_M5=ic_I_M5*1.5;%y_inf_data(1);
ic_A_H_M5=y_inf_data(1);
ic_R_M5=ic_I_M5/2;
ic_S_M5=(y_pop_data(1)-ic_I_M5-ic_A_H_M5-ic_E_M5-ic_R_M5);
y0_M5=[ic_V_M5;ic_O_M5;ic_D_M5;ic_H_M5;ic_A_M5;ic_C_M5;ic_S_M5;ic_E_M5;ic_A_H_M5;ic_I_M5;ic_R_M5];
   
if choose_region==1
%AZ
disp('Plotting all AZ fittings')

params_m1pswarm_AZ = [10.000000000000000; 0.089999999978330; 0.000000010000000; 450.000000000000000; 0.002688686921919; 0.061251562936845; 0.000000000000000; 0.000000020961869; 0.058375006001613; 0.003267139435456; 0.000000027768000]; 
params_m2pswarm_AZ = [5.009606620067531; 0.434798441239070; 0.089732287736925; 0.000026255026616; 377.699911269605366; 0.199999919194991; 0.026685897897313; 0.002937147058955; 0.000000361032194; 0.000829456046382; 0.061251562936845; 0.000000103246512; 0.058374942666625; 0.001377500774935; 0.000000027768000; 0.120779967337124];
params_m3pswarm_AZ = [138.306647821959984; 0.258402702487866; 0.077522117057234; 0.000001137285266; 283.093564372919161; 0.015289782791561; 0.093066971023964; 0.003763458248558; 0.000000010000000; 0.001000000000000; 84.729852446712655; 87.910790753539800; 10.228749400936026; 8.645219449835233; 64.285085426902810; 202.428141804046078; 30.000000000000000; 349.012743014071987; 100.000000000000000; 20.000000000000000; 3.623422058349262; 1.548024556951697; 7.000000000000000; 0.061251562936845; 0.000000101621370; 0.058375035490238; 0.002739726027397; 0.000000027768000; 0.142857142857143];
%params_m4pswarm_AZ = [1e-05 0.0927564337915979 0.00999999716595209 204.052185285492 0.00992814215369503 0.0416989593002848 0.00241644152450362 1.22260042558277e-07 5.93957762906623e-07 80.6243043124889 89.6808301876968 11.9830773958433 9.73927437004644 69.9613052999443 471.377518774397 99.9814093154029 261.665834059705 150 20 0.103450024873664 2.03934708911984 3.74463006672424 75.7979947536554 0.03 0.0141489501584713 1.55787181212836e-11 65.0584021660052 9.83117221693812e-06 7.0729186657143 31 19.6035704517919 0.0500314408893 0 5.93870291947533e-08 0.0499961041403191 0.00137144519715801 1.00417349271266e-05 0.142440445327285];
params_m4pswarm_AZ = [0.000010000000000; 0.100000000000000; 0.001193555815515; 200.000000000000000; 0.022385459335596; 0.042222790640204; 0.003144487439878; 0.000000096197426; 0.000876554055535; 84.870691898837876; 78.147016260535935; 11.489009158195209; 6.789232680376182; 70.000000000000000; 294.932347237731278; 100.000000000000000; 346.254637419418486; 84.741735688121537; 1.000000000000000; 2.980798109967469; 12.402321014667727; 14.792775954681861; 75.000000000000000; 0.017458884094707; 0.015000000000000; 0.000000000241534; 70.736523086611996; 0.000001819109156; 6.487726810815982; 31.000000000000000; 18.674308332333556; 0.061251562936845; 0.000000000000000; 0.000000163491776; 0.058374994132322; 0.011429842607003; 0.000304412803731; 0.097915620963345];
params_m5pswarm_AZ = [0.059666039475293; 1.500000000000000; 56.159676367528043; 0.083324561876196; 0.001071128181719; 251.043272507251231; 0.038467227364723; 0.000307339890048; 0.003458821692034; 0.000000909560967; 0.000118658789881; 79.623388236315577; 80.875730227330436; 12.815115427521537; 9.668902757394513; 600.000000000000000; 78.846512885914464; 411.879715104253080; 77.014429908153815; 15.612823451643191; 6.117954156767697; 11.849000119033166; 0.111319764863660; 79.824736842352536; 0.029206812832168; 0.006562653165126; 0.000000000011563; 74.940377446107533; 0.000000922100719; 6.488857921114797; 95.000000000000000; 1.001258627809564; 0.061251562936845; 0.000000143905641; 0.058374952754485; 0.002500000000000; 0.000359000000000; 0.124306798546976];
%params_m5pswarm_AZ = [0.013570881517425; 3.486114778821585; 71.406523778789293; 0.026463109731532; 0.009991594012416; 250.168964486127066; 0.006768187939550; 0.014336448312723; 0.003875647947497; 0.000000254669175; 0.000628423005189; 82.998323072617339; 85.492406059282430; 12.999717238074208; 7.874232437595512; 600.000000000000000; 77.952271528502479; 549.070017687924860; 80.000000000000000; 5.294916732113520; 5.669890993717204; 5.000174208490977; 5.004743929127285; 82.996474120536789; 0.000100000000000; 0.000155519428524; 0.000000000010811; 65.055263049055469; 0.000000121532291; 6.999810033504946; 95.000000000000000; 10.000000000000000; 0.050031440889300; 0.000000100352435; 0.049996103209800; 0.002547901582564; 0.000000027768000; 0.098069080146065]; 

y_M1_AZ=[];
[t, y_M1_AZ_test] = ode23s(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_AZ);
if length(y_M1_AZ_test)<133
    M1_AZ_rrmse=1e10;
else
    M1_AZ_rrmse=(rmse(y_M1_AZ_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M1_AZ=y_M1_AZ_test;
end

[t, y_M1_AZ_test] = ode15s(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_AZ);
if length(y_M1_AZ_test)<133
    M1_AZ_rrmse_test=1e10;
else
    M1_AZ_rrmse_test=(rmse(y_M1_AZ_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M1_AZ_rrmse_test<M1_AZ_rrmse
        M1_AZ_rrmse=M1_AZ_rrmse_test;
        y_M1_AZ=y_M1_AZ_test;
    end
end

[t, y_M1_AZ_test] = ode78(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_AZ);
if length(y_M1_AZ_test)<133
    M1_AZ_rrmse_test=1e10;
else
    M1_AZ_rrmse_test=(rmse(y_M1_AZ_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M1_AZ_rrmse_test<M1_AZ_rrmse
        M1_AZ_rrmse=M1_AZ_rrmse_test;
        y_M1_AZ=y_M1_AZ_test;
    end
end

[t, y_M1_AZ_test] = ode45(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_AZ);
if length(y_M1_AZ_test)<133
    M1_AZ_rrmse_test=1e10;
else
    M1_AZ_rrmse_test=(rmse(y_M1_AZ_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M1_AZ_rrmse_test<M1_AZ_rrmse
        M1_AZ_rrmse=M1_AZ_rrmse_test;
        y_M1_AZ=y_M1_AZ_test;
    end
end

y_M2_AZ=[];
[t, y_M2_AZ_test] = ode23s(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_AZ);
if length(y_M2_AZ_test)<133
    M2_AZ_rrmse=1e10;
else
    M2_AZ_rrmse=(rmse(y_M2_AZ_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M2_AZ=y_M2_AZ_test;
end

[t, y_M2_AZ_test] = ode15s(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_AZ);
if length(y_M2_AZ_test)<133
    M2_AZ_rrmse_test=1e10;
else
    M2_AZ_rrmse_test=(rmse(y_M2_AZ_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M2_AZ_rrmse_test<M2_AZ_rrmse
        M2_AZ_rrmse=M2_AZ_rrmse_test;
        y_M2_AZ=y_M2_AZ_test;
    end
end

[t, y_M2_AZ_test] = ode78(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_AZ);
if length(y_M2_AZ_test)<133
    M2_AZ_rrmse_test=1e10;
else
    M2_AZ_rrmse_test=(rmse(y_M2_AZ_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M2_AZ_rrmse_test<M2_AZ_rrmse
        M2_AZ_rrmse=M2_AZ_rrmse_test;
        y_M2_AZ=y_M2_AZ_test;
    end
end

[t, y_M2_AZ_test] = ode45(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_AZ);
if length(y_M2_AZ_test)<133
    M2_AZ_rrmse_test=1e10;
else
    M2_AZ_rrmse_test=(rmse(y_M2_AZ_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M2_AZ_rrmse_test<M2_AZ_rrmse
        M2_AZ_rrmse=M2_AZ_rrmse_test;
        y_M2_AZ=y_M2_AZ_test;
    end
end
 
y_M3_AZ=[];
[t, y_M3_AZ_test] = ode23s(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_AZ);
if length(y_M3_AZ_test)<133
    M3_AZ_rrmse=1e10;
else
    M3_AZ_rrmse=(rmse(y_M3_AZ_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M3_AZ=y_M3_AZ_test;
end

[t, y_M3_AZ_test] = ode15s(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_AZ);
if length(y_M3_AZ_test)<133
    M3_AZ_rrmse_test=1e10;
else
    M3_AZ_rrmse_test=(rmse(y_M3_AZ_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M3_AZ_rrmse_test<M3_AZ_rrmse
        M3_AZ_rrmse=M3_AZ_rrmse_test;
        y_M3_AZ=y_M3_AZ_test;
    end
end

[t, y_M3_AZ_test] = ode78(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_AZ);
if length(y_M3_AZ_test)<133
    M3_AZ_rrmse_test=1e10;
else
    M3_AZ_rrmse_test=(rmse(y_M3_AZ_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M3_AZ_rrmse_test<M3_AZ_rrmse
        M3_AZ_rrmse=M3_AZ_rrmse_test;
        y_M3_AZ=y_M3_AZ_test;
    end
end

[t, y_M3_AZ_test] = ode45(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_AZ);
if length(y_M3_AZ_test)<133
    M3_AZ_rrmse_test=1e10;
else
    M3_AZ_rrmse_test=(rmse(y_M3_AZ_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M3_AZ_rrmse_test<M3_AZ_rrmse
        M3_AZ_rrmse=M3_AZ_rrmse_test;
        y_M3_AZ=y_M3_AZ_test;
    end
end

y_M4_AZ=[];
[t, y_M4_AZ_test] = ode23s(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_AZ);
if length(y_M4_AZ_test)<133
    M4_AZ_rrmse=1e10;
else
    M4_AZ_rrmse=(rmse(y_M4_AZ_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M4_AZ=y_M4_AZ_test;
end

[t, y_M4_AZ_test] = ode15s(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_AZ);
if length(y_M4_AZ_test)<133
    M4_AZ_rrmse_test=1e10;
else
    M4_AZ_rrmse_test=(rmse(y_M4_AZ_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M4_AZ_rrmse_test<M4_AZ_rrmse
        M4_AZ_rrmse=M4_AZ_rrmse_test;
        y_M4_AZ=y_M4_AZ_test;
    end
end

[t, y_M4_AZ_test] = ode78(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_AZ);
if length(y_M4_AZ_test)<133
    M4_AZ_rrmse_test=1e10;
else
    M4_AZ_rrmse_test=(rmse(y_M4_AZ_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M4_AZ_rrmse_test<M4_AZ_rrmse
        M4_AZ_rrmse=M4_AZ_rrmse_test;
        y_M4_AZ=y_M4_AZ_test;
    end
end

[t, y_M4_AZ_test] = ode45(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_AZ);
if length(y_M4_AZ_test)<133
    M4_AZ_rrmse_test=1e10;
else
    M4_AZ_rrmse_test=(rmse(y_M4_AZ_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M4_AZ_rrmse_test<M4_AZ_rrmse
        M4_AZ_rrmse=M4_AZ_rrmse_test;
        y_M4_AZ=y_M4_AZ_test;
    end
end


y_M5_AZ=[];
[t, y_M5_AZ_test] = ode23s(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_AZ);
if length(y_M5_AZ_test)<133
    M5_AZ_rrmse=1e10;
else
    M5_AZ_rrmse=(rmse(y_M5_AZ_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M5_AZ=y_M5_AZ_test;
end

[t, y_M5_AZ_test] = ode15s(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_AZ);
if length(y_M5_AZ_test)<133
    M5_AZ_rrmse_test=1e10;
else
    M5_AZ_rrmse_test=(rmse(y_M5_AZ_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M5_AZ_rrmse_test<M5_AZ_rrmse
        M5_AZ_rrmse=M5_AZ_rrmse_test;
        y_M5_AZ=y_M5_AZ_test;
    end
end

[t, y_M5_AZ_test] = ode78(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_AZ);
if length(y_M5_AZ_test)<133
    M5_AZ_rrmse_test=1e10;
else
    M5_AZ_rrmse_test=(rmse(y_M5_AZ_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M5_AZ_rrmse_test<M5_AZ_rrmse
        M5_AZ_rrmse=M5_AZ_rrmse_test;
        y_M5_AZ=y_M5_AZ_test;
    end
end

[t, y_M5_AZ_test] = ode45(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_AZ);
if length(y_M5_AZ_test)<133
    M5_AZ_rrmse_test=1e10;
else
    M5_AZ_rrmse_test=(rmse(y_M5_AZ_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M5_AZ_rrmse_test<M5_AZ_rrmse
        M5_AZ_rrmse=M5_AZ_rrmse_test;
        y_M5_AZ=y_M5_AZ_test;
    end
end

%Display
figure
scatter(t_inf_data,y_inf_data, 'k','LineWidth',2)
hold on
plot(t,y_M1_AZ(:,4), 'Color', [0.9 0.6 0.0 0.6], 'LineStyle', '-', 'LineWidth', 11)
plot(t,y_M2_AZ(:,8), 'Color', [0.35 0.7 0.9 0.7], 'LineStyle', '-', 'LineWidth', 9)
plot(t,y_M3_AZ(:,8), 'Color', [0.0 0.6 0.5 0.8], 'LineStyle', '-', 'LineWidth', 7)
plot(t,y_M4_AZ(:,9), 'Color', [0.8 0.4 0.0 0.9], 'LineStyle', '-', 'LineWidth', 5)
plot(t,y_M5_AZ(:,10), 'Color', [0 0 0 1], 'LineStyle', '-', 'LineWidth', 3)
%plot(t,y_M5_AZ(:,10), 'Color', [0.8 0.6 0.7 1], 'LineStyle', '-', 'LineWidth', 3)
legend('AZ Infected','Model 1 fit', 'Model 2 fit','Model 3 fit','Model 4 fit','Model 5 fit','Location','best' ,'FontSize', 16);
title("Valley Fever Model Comparison for Arizona ", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10,365*11])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
subtitle("M1 RRMSE="+M1_AZ_rrmse+"%, M2 RRMSE="+M2_AZ_rrmse+"%, M3 RRMSE="+M3_AZ_rrmse...
    +"%, M4 RRMSE="+M4_AZ_rrmse+"%, M5 RRMSE="+M5_AZ_rrmse+"%", 'FontSize', 14)
xlabel('Year', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
ylim([0,max(y_inf_data)+100])
xlim([0,max(t_inf_data)+31])
hold off


elseif choose_region==2
%Maricopa
disp('Plotting all Maricopa fittings')
y_inf_data=y_inf_data_Maricopa;
y_pop_data=y_pop_data_Maricopa;


params_m1pswarm_maricopa = [107.966058512893952; 0.000000010000000; 0.000000010000000; 362.402257489276849; 0.000280229097724; 0.050031440889300; 0.000000000000000; 0.000000054180839; 0.049996059143870; 0.071158515657904; 0.000359000000000; 92.000000000000000];
params_m2pswarm_maricopa = [1999.998994242816025; 0.000252946061599; 0.000474844922769; 0.000000010000000; 250.000000000000000; 0.000001000000000; 0.016621402067285; 0.060000000000000; 0.000001000000000; 0.000296114264124; 0.050031440889300; 0.000000280335282; 0.049996059143870; 0.023434241099017; 0.000359000000000; 0.129551958597833];
params_m3pswarm_maricopa = [780.695849755297786; 0.112987522578676; 0.000001000000000; 0.010000000000000; 448.327017398121882; 0.000001000000000; 0.100000000000000; 0.002303415338279; 0.000028001008066; 0.000555181020475; 70.729913155894437; 89.997194860644484; 12.799960121895687; 7.924845045529040; 59.660702604131473; 515.266334220423687; 69.590845870346797; 678.163344771200627; 32.955607478521912; 20.000000000000000; 6.832375523748846; 1.000347691820149; 4.150862236904837; 0.050031440889300; 0.000000001000000; 0.049996007843259; 0.002739726027397; 0.000353712166194; 0.142856150324346];
params_m3pswarm_maricopa=[1000; 0.1945561100332; 0.1; 0.0088109715500486; 328.400733100386; 0.0146664577603797;...
    0.00925296790976682; 0.00188911310023338; 1e-08; 1e-07; 70.1928311610478; 90; 11.7815475109342; 7; 63.8091936150225;...
    333.491813715222; 30; 579.076935447301; 100; 12.1047035027643; 5.08577518979687; 1; 4.44203800161786; 0.0500314408893;...
    2.29938769844477e-07; 0.049996014923555; 0.0175208447272361; 0.000359; 0.0357142857142857; 31; 4.43818349092801; 0.1; 0;...
    5.57149614193524e-05; 0.0999644523082336; 0.0714285714285714; 0.000191325147250823; 0.135739418597056];
%params_m3pswarm_maricopa =[1.000033320129755; 0.300000000000000; 0.079041150781044; 0.010000000000000; 355.869894324574773; 0.033218059492438; 0.000711932724192; 0.003172927158405; 0.000000010000000; 0.000979733036141; 80.379814582080272; 77.000000000000000; 12.073714747218034; 8.113138524159655; 63.415140674666034; 416.720257108450824; 30.087045405026011; 212.054069198338908; 69.230656678768852; 1.002046848312875; 0.166877686395806; 1.000000000000000; 0.100000000000000; 0.061251562936845; 0.000000511173392; 0.058374941831806; 0.051477137251744; 0.000000027768000; 0.039008944578565];
%params_m4pswarm_maricopa_1 = [1e-05 0.042230571057144 0.00837263872214115 437.229023348524 0.0117605898219566 0.0251546831899933 0.00224084145667181 4.2044486606697e-07 1e-07 83.1216533120269 89.9849401550875 11.2375587126391 7.23029133229563 70 501.35136690225 73.8929486988334 267.671867266095 143.432600277587 5.83546573153626 6.93408240270328 1.46414375933179 14.8432829206185 90 0.0103814157410378 0.0133132904271675 1.73863275441109e-10 70.2666204401365 9.91494515338526e-06 5 31 1.00054265623384 0.0500314408893 0 2.20787719022041e-07 0.0499961041403191 0.00148929622632351 9.86810439244902e-05 0.0244484085296731];
%params_m4pswarm_maricopa_2 = [1e-05 0.1 0.00999836816707709 201.330102080304 0.00788521804953164 0.0243604662280288 0.00260002906337214 1e-08 1.02296781329829e-07 79.1169186064556 90 12.3191718540064 9.72360498956246 70 530.976600025891 99.6662467207895 222.054228051293 149.972611453959 19.9673752551938 0.102809682633881 2.25183570767026 3.03928627864365 75.1312122162779 0.0272047006393934 0.0103622577049875 7.28667419284812e-12 65.0011363905912 9.99998811517349e-06 7.21470806023159 31 19.9687857026201 0.0500314408893 0 1.14988664122046e-07 0.0499961041403191 0.00136986306590546 1.17356234908942e-06 0.0451224074566781];
params_m4pswarm_maricopa_3 = [0.000010000000000; 0.100000000000000; 0.009966864510448; 201.225612482564628; 0.007792528427811; 0.023950497037501; 0.002593893807706; 0.000000010000000; 0.000000103015383; 79.684809059824147; 90.000000000000000; 12.261639500423215; 9.772284389420793; 70.000000000000000; 488.155996459108110; 99.318900482000188; 217.336654881775843; 149.974884412188800; 19.969250295208315; 0.102229127750650; 2.217953146581862; 3.346218700664260; 75.000000000000000; 0.026075481232795; 0.010141847192760; 0.000000000002248; 65.001212802818813; 0.000009999992753; 7.175129812875232; 31.000000000000000; 19.970847084426751; 0.050031440889300; 0.000000000000000; 0.000000120397558; 0.049996104140319; 0.001369863013699; 0.000002092853757; 0.045002038482630];
params_m5pswarm_maricopa = [0.013570881517425; 3.486114778821585; 71.406523778789293; 0.026463109731532; 0.009991594012416; 250.168964486127066; 0.006768187939550; 0.014336448312723; 0.003875647947497; 0.000000254669175; 0.000628423005189; 82.998323072617339; 85.492406059282430; 12.999717238074208; 7.874232437595512; 600.000000000000000; 77.952271528502479; 549.070017687924860; 80.000000000000000; 5.294916732113520; 5.669890993717204; 5.000174208490977; 5.004743929127285; 82.996474120536789; 0.000100000000000; 0.000155519428524; 0.000000000010811; 65.055263049055469; 0.000000121532291; 6.999810033504946; 95.000000000000000; 10.000000000000000; 0.050031440889300; 0.000000100352435; 0.049996103209800; 0.002547901582564; 0.000000027768000; 0.098069080146065]; 

y_M1_maricopa=[];
[t, y_M1_maricopa_test] = ode23s(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_maricopa);
if length(y_M1_maricopa_test)<133
    M1_maricopa_rrmse=1e10;
else
    M1_maricopa_rrmse=(rmse(y_M1_maricopa_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M1_maricopa=y_M1_maricopa_test;
end

[t, y_M1_maricopa_test] = ode15s(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_maricopa);
if length(y_M1_maricopa_test)<133
    M1_maricopa_rrmse_test=1e10;
else
    M1_maricopa_rrmse_test=(rmse(y_M1_maricopa_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M1_maricopa_rrmse_test<M1_maricopa_rrmse
        M1_maricopa_rrmse=M1_maricopa_rrmse_test;
        y_M1_maricopa=y_M1_maricopa_test;
    end
end

[t, y_M1_maricopa_test] = ode78(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_maricopa);
if length(y_M1_maricopa_test)<133
    M1_maricopa_rrmse_test=1e10;
else
    M1_maricopa_rrmse_test=(rmse(y_M1_maricopa_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M1_maricopa_rrmse_test<M1_maricopa_rrmse
        M1_maricopa_rrmse=M1_maricopa_rrmse_test;
        y_M1_maricopa=y_M1_maricopa_test;
    end
end

[t, y_M1_maricopa_test] = ode45(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_maricopa);
if length(y_M1_maricopa_test)<133
    M1_maricopa_rrmse_test=1e10;
else
    M1_maricopa_rrmse_test=(rmse(y_M1_maricopa_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M1_maricopa_rrmse_test<M1_maricopa_rrmse
        M1_maricopa_rrmse=M1_maricopa_rrmse_test;
        y_M1_maricopa=y_M1_maricopa_test;
    end
end

y_M2_maricopa=[];
[t, y_M2_maricopa_test] = ode23s(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_maricopa);
if length(y_M2_maricopa_test)<133
    M2_maricopa_rrmse=1e10;
else
    M2_maricopa_rrmse=(rmse(y_M2_maricopa_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M2_maricopa=y_M2_maricopa_test;
end

[t, y_M2_maricopa_test] = ode15s(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_maricopa);
if length(y_M2_maricopa_test)<133
    M2_maricopa_rrmse_test=1e10;
else
    M2_maricopa_rrmse_test=(rmse(y_M2_maricopa_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M2_maricopa_rrmse_test<M2_maricopa_rrmse
        M2_maricopa_rrmse=M2_maricopa_rrmse_test;
        y_M2_maricopa=y_M2_maricopa_test;
    end
end

[t, y_M2_maricopa_test] = ode78(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_maricopa);
if length(y_M2_maricopa_test)<133
    M2_maricopa_rrmse_test=1e10;
else
    M2_maricopa_rrmse_test=(rmse(y_M2_maricopa_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M2_maricopa_rrmse_test<M2_maricopa_rrmse
        M2_maricopa_rrmse=M2_maricopa_rrmse_test;
        y_M2_maricopa=y_M2_maricopa_test;
    end
end

[t, y_M2_maricopa_test] = ode45(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_maricopa);
if length(y_M2_maricopa_test)<133
    M2_maricopa_rrmse_test=1e10;
else
    M2_maricopa_rrmse_test=(rmse(y_M2_maricopa_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M2_maricopa_rrmse_test<M2_maricopa_rrmse
        M2_maricopa_rrmse=M2_maricopa_rrmse_test;
        y_M2_maricopa=y_M2_maricopa_test;
    end
end
 
y_M3_maricopa=[];
[t, y_M3_maricopa_test] = ode23s(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_maricopa);
if length(y_M3_maricopa_test)<133
    M3_maricopa_rrmse=1e10;
else
    M3_maricopa_rrmse=(rmse(y_M3_maricopa_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M3_maricopa=y_M3_maricopa_test;
end

[t, y_M3_maricopa_test] = ode15s(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_maricopa);
if length(y_M3_maricopa_test)<133
    M3_maricopa_rrmse_test=1e10;
else
    M3_maricopa_rrmse_test=(rmse(y_M3_maricopa_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M3_maricopa_rrmse_test<M3_maricopa_rrmse
        M3_maricopa_rrmse=M3_maricopa_rrmse_test;
        y_M3_maricopa=y_M3_maricopa_test;
    end
end

[t, y_M3_maricopa_test] = ode78(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_maricopa);
if length(y_M3_maricopa_test)<133
    M3_maricopa_rrmse_test=1e10;
else
    M3_maricopa_rrmse_test=(rmse(y_M3_maricopa_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M3_maricopa_rrmse_test<M3_maricopa_rrmse
        M3_maricopa_rrmse=M3_maricopa_rrmse_test;
        y_M3_maricopa=y_M3_maricopa_test;
    end
end

[t, y_M3_maricopa_test] = ode45(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_maricopa);
if length(y_M3_maricopa_test)<133
    M3_maricopa_rrmse_test=1e10;
else
    M3_maricopa_rrmse_test=(rmse(y_M3_maricopa_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M3_maricopa_rrmse_test<M3_maricopa_rrmse
        M3_maricopa_rrmse=M3_maricopa_rrmse_test;
        y_M3_maricopa=y_M3_maricopa_test;
    end
end

y_M4_maricopa=[];
[t, y_M4_maricopa_test] = ode23s(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_maricopa_3);
if length(y_M4_maricopa_test)<133
    M4_maricopa_rrmse=1e10;
else
    M4_maricopa_rrmse=(rmse(y_M4_maricopa_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M4_maricopa=y_M4_maricopa_test;
end

[t, y_M4_maricopa_test] = ode15s(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_maricopa_3);
if length(y_M4_maricopa_test)<133
    M4_maricopa_rrmse_test=1e10;
else
    M4_maricopa_rrmse_test=(rmse(y_M4_maricopa_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M4_maricopa_rrmse_test<M4_maricopa_rrmse
        M4_maricopa_rrmse=M4_maricopa_rrmse_test;
        y_M4_maricopa=y_M4_maricopa_test;
    end
end

[t, y_M4_maricopa_test] = ode45(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_maricopa_3);
if length(y_M4_maricopa_test)<133
    M4_maricopa_rrmse_test=1e10;
else
    M4_maricopa_rrmse_test=(rmse(y_M4_maricopa_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M4_maricopa_rrmse_test<M4_maricopa_rrmse
        M4_maricopa_rrmse=M4_maricopa_rrmse_test;
        y_M4_maricopa=y_M4_maricopa_test;
    end
end


y_M5_maricopa=[];
[t, y_M5_maricopa_test] = ode23s(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_maricopa);
if length(y_M5_maricopa_test)<133
    M5_maricopa_rrmse=1e10;
else
    M5_maricopa_rrmse=(rmse(y_M5_maricopa_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M5_maricopa=y_M5_maricopa_test;
end

[t, y_M5_maricopa_test] = ode15s(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_maricopa);
if length(y_M5_maricopa_test)<133
    M5_maricopa_rrmse_test=1e10;
else
    M5_maricopa_rrmse_test=(rmse(y_M5_maricopa_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M5_maricopa_rrmse_test<M5_maricopa_rrmse
        M5_maricopa_rrmse=M5_maricopa_rrmse_test;
        y_M5_maricopa=y_M5_maricopa_test;
    end
end

[t, y_M5_maricopa_test] = ode78(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_maricopa);
if length(y_M5_maricopa_test)<133
    M5_maricopa_rrmse_test=1e10;
else
    M5_maricopa_rrmse_test=(rmse(y_M5_maricopa_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M5_maricopa_rrmse_test<M5_maricopa_rrmse
        M5_maricopa_rrmse=M5_maricopa_rrmse_test;
        y_M5_maricopa=y_M5_maricopa_test;
    end
end

[t, y_M5_maricopa_test] = ode45(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_maricopa);
if length(y_M5_maricopa_test)<133
    M5_maricopa_rrmse_test=1e10;
else
    M5_maricopa_rrmse_test=(rmse(y_M5_maricopa_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M5_maricopa_rrmse_test<M5_maricopa_rrmse
        M5_maricopa_rrmse=M5_maricopa_rrmse_test;
        y_M5_maricopa=y_M5_maricopa_test;
    end
end


%Display
figure
scatter(t_inf_data,y_inf_data, 'k','LineWidth',2)
hold on
plot(t,y_M1_maricopa(:,4), 'Color', [0.9 0.6 0.0 0.6], 'LineStyle', '-', 'LineWidth', 11)
plot(t,y_M2_maricopa(:,8), 'Color', [0.35 0.7 0.9 0.7], 'LineStyle', '-', 'LineWidth', 9)
plot(t,y_M3_maricopa(:,8), 'Color', [0.0 0.6 0.5 0.8], 'LineStyle', '-', 'LineWidth', 7)
plot(t,y_M4_maricopa(:,9), 'Color', [0.8 0.4 0.0 0.9], 'LineStyle', '-', 'LineWidth', 5)
plot(t,y_M5_maricopa(:,10), 'Color', [0 0 0 1], 'LineStyle', '-', 'LineWidth', 3)
%plot(t,y_M5_maricopa(:,10), 'Color', [0.8 0.6 0.7 1], 'LineStyle', '-', 'LineWidth', 3)
legend('Maricopa Infected','Model 1 fit', 'Model 2 fit','Model 3 fit','Model 4 fit','Model 5 fit','Location','best');
title("Valley Fever Model Comparison for Maricopa County ", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10,365*11])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
subtitle("M1 RRMSE="+M1_maricopa_rrmse+"%, M2 RRMSE="+M2_maricopa_rrmse+"%, M3 RRMSE="+M3_maricopa_rrmse...
    +"%, M4 RRMSE="+M4_maricopa_rrmse+"%, M5 RRMSE="+M5_maricopa_rrmse+"%", 'FontSize', 14)
xlabel('Year', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
ylim([0,max(y_inf_data)+100])
xlim([0,max(t_inf_data)+31])
hold off



elseif choose_region==3
%Pima
disp('Plotting all Pima fittings')

params_m1pswarm_pima = [109.397181039289094; 0.000000010000000; 0.000000010000000; 275.369005536686529; 0.000166003637744; 0.050089996409431; 0.000000000000000; 0.000000005519936; 0.050079364316579; 0.004789703380360; 0.000060194817064]; 
params_m2pswarm_pima = [5.000000000000000; 0.000000001000000; 0.000009036430485; 0.009583452249398; 307.683245664926801; 0.000001258961163; 0.029052133876465; 0.031974350777597; 0.000000018054436; 0.000394979870026; 0.050089996409431; 0.000000020917158; 0.050079317535948; 0.002135911184399; 0.000212286205543; 0.116648951361555];  
params_m3pswarm_pima =[1.001958584897151; 0.051042432222074; 0.026979111466328; 0.003923177834857; 420.559374505995152; 0.011081410714083; 0.098729412596656; 0.000453986029834; 0.000100000000000; 0.000192628405566; 70.000000000000000; 78.601456362136503; 12.769850408294619; 9.760981912713550; 57.755236872837706; 215.670293705046277; 30.063529194531188; 699.945885944297629; 30.060984278977333; 1.000001911363284; 0.100000000000000; 1.000000000000000; 0.100140601152242; 0.050089996409431; 0.000000094890335; 0.050079409322391; 0.002739726027397; 0.000339157359695; 0.089588358839410];  
%M4 is just guess from maricopa
params_m4pswarm_pima = [0.000010000000000; 0.100000000000000; 0.009966864510448; 201.225612482564628; 0.007792528427811; 0.023950497037501; 0.002593893807706; 0.000000010000000; 0.000000103015383; 79.684809059824147; 90.000000000000000; 12.261639500423215; 9.772284389420793; 70.000000000000000; 488.155996459108110; 99.318900482000188; 217.336654881775843; 149.974884412188800; 19.969250295208315; 0.102229127750650; 2.217953146581862; 3.346218700664260; 75.000000000000000; 0.026075481232795; 0.010141847192760; 0.000000000002248; 65.001212802818813; 0.000009999992753; 7.175129812875232; 31.000000000000000; 19.970847084426751; 0.050031440889300; 0.000000000000000; 0.000000120397558; 0.049996104140319; 0.001369863013699; 0.000002092853757; 0.045002038482630];
params_m5pswarm_pima = [0.048225552093831; 3.498680547158601; 80.000000000000000; 0.014128398686701; 0.000002254662011; 360.000000000000000; 0.017306540718082; 0.043676816987336; 0.001403399151341; 0.000001000000000; 0.000242781986754; 77.675156368739394; 81.176312775207492; 12.246075847950394; 8.672455834883079; 300.000000000000000; 50.308740170172761; 377.390710316257241; 80.000000000000000; 15.689220086247433; 5.781445734880267; 5.000000000000000; 0.100000000000000; 78.012080812738560; 0.000897710479038; 0.000402841576667; 0.000000000010000; 68.309708046942660; 0.000007695068597; 5.515944291236175; 95.000000000000000; 10.000000000000000; 0.050089996409431; 0.000000100024105; 0.050079310171154; 0.010060627847230; 0.000358961627659; 0.134355916594832];


y_M1_pima=[];
[t, y_M1_pima_test] = ode23s(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_pima);
if length(y_M1_pima_test)<133
    M1_pima_rrmse=1e10;
else
    M1_pima_rrmse=(rmse(y_M1_pima_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M1_pima=y_M1_pima_test;
end

[t, y_M1_pima_test] = ode15s(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_pima);
if length(y_M1_pima_test)<133
    M1_pima_rrmse_test=1e10;
else
    M1_pima_rrmse_test=(rmse(y_M1_pima_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M1_pima_rrmse_test<M1_pima_rrmse
        M1_pima_rrmse=M1_pima_rrmse_test;
        y_M1_pima=y_M1_pima_test;
    end
end

[t, y_M1_pima_test] = ode78(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_pima);
if length(y_M1_pima_test)<133
    M1_pima_rrmse_test=1e10;
else
    M1_pima_rrmse_test=(rmse(y_M1_pima_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M1_pima_rrmse_test<M1_pima_rrmse
        M1_pima_rrmse=M1_pima_rrmse_test;
        y_M1_pima=y_M1_pima_test;
    end
end

[t, y_M1_pima_test] = ode45(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_pima);
if length(y_M1_pima_test)<133
    M1_pima_rrmse_test=1e10;
else
    M1_pima_rrmse_test=(rmse(y_M1_pima_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M1_pima_rrmse_test<M1_pima_rrmse
        M1_pima_rrmse=M1_pima_rrmse_test;
        y_M1_pima=y_M1_pima_test;
    end
end

y_M2_pima=[];
[t, y_M2_pima_test] = ode23s(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_pima);
if length(y_M2_pima_test)<133
    M2_pima_rrmse=1e10;
else
    M2_pima_rrmse=(rmse(y_M2_pima_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M2_pima=y_M2_pima_test;
end

[t, y_M2_pima_test] = ode15s(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_pima);
if length(y_M2_pima_test)<133
    M2_pima_rrmse_test=1e10;
else
    M2_pima_rrmse_test=(rmse(y_M2_pima_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M2_pima_rrmse_test<M2_pima_rrmse
        M2_pima_rrmse=M2_pima_rrmse_test;
        y_M2_pima=y_M2_pima_test;
    end
end

[t, y_M2_pima_test] = ode78(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_pima);
if length(y_M2_pima_test)<133
    M2_pima_rrmse_test=1e10;
else
    M2_pima_rrmse_test=(rmse(y_M2_pima_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M2_pima_rrmse_test<M2_pima_rrmse
        M2_pima_rrmse=M2_pima_rrmse_test;
        y_M2_pima=y_M2_pima_test;
    end
end

[t, y_M2_pima_test] = ode45(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_pima);
if length(y_M2_pima_test)<133
    M2_pima_rrmse_test=1e10;
else
    M2_pima_rrmse_test=(rmse(y_M2_pima_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M2_pima_rrmse_test<M2_pima_rrmse
        M2_pima_rrmse=M2_pima_rrmse_test;
        y_M2_pima=y_M2_pima_test;
    end
end
 
y_M3_pima=[];
[t, y_M3_pima_test] = ode23s(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_pima);
if length(y_M3_pima_test)<133
    M3_pima_rrmse=1e10;
else
    M3_pima_rrmse=(rmse(y_M3_pima_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M3_pima=y_M3_pima_test;
end

[t, y_M3_pima_test] = ode15s(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_pima);
if length(y_M3_pima_test)<133
    M3_pima_rrmse_test=1e10;
else
    M3_pima_rrmse_test=(rmse(y_M3_pima_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M3_pima_rrmse_test<M3_pima_rrmse
        M3_pima_rrmse=M3_pima_rrmse_test;
        y_M3_pima=y_M3_pima_test;
    end
end

[t, y_M3_pima_test] = ode78(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_pima);
if length(y_M3_pima_test)<133
    M3_pima_rrmse_test=1e10;
else
    M3_pima_rrmse_test=(rmse(y_M3_pima_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M3_pima_rrmse_test<M3_pima_rrmse
        M3_pima_rrmse=M3_pima_rrmse_test;
        y_M3_pima=y_M3_pima_test;
    end
end

[t, y_M3_pima_test] = ode45(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_pima);
if length(y_M3_pima_test)<133
    M3_pima_rrmse_test=1e10;
else
    M3_pima_rrmse_test=(rmse(y_M3_pima_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M3_pima_rrmse_test<M3_pima_rrmse
        M3_pima_rrmse=M3_pima_rrmse_test;
        y_M3_pima=y_M3_pima_test;
    end
end

y_M4_pima=[];
[t, y_M4_pima_test] = ode23s(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_pima);
if length(y_M4_pima_test)<133
    M4_pima_rrmse=1e10;
else
    M4_pima_rrmse=(rmse(y_M4_pima_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M4_pima=y_M4_pima_test;
end

[t, y_M4_pima_test] = ode15s(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_pima);
if length(y_M4_pima_test)<133
    M4_pima_rrmse_test=1e10;
else
    M4_pima_rrmse_test=(rmse(y_M4_pima_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M4_pima_rrmse_test<M4_pima_rrmse
        M4_pima_rrmse=M4_pima_rrmse_test;
        y_M4_pima=y_M4_pima_test;
    end
end

[t, y_M4_pima_test] = ode78(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_pima);
if length(y_M4_pima_test)<133
    M4_pima_rrmse_test=1e10;
else
    M4_pima_rrmse_test=(rmse(y_M4_pima_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M4_pima_rrmse_test<M4_pima_rrmse
        M4_pima_rrmse=M4_pima_rrmse_test;
        y_M4_pima=y_M4_pima_test;
    end
end

[t, y_M4_pima_test] = ode45(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_pima);
if length(y_M4_pima_test)<133
    M4_pima_rrmse_test=1e10;
else
    M4_pima_rrmse_test=(rmse(y_M4_pima_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M4_pima_rrmse_test<M4_pima_rrmse
        M4_pima_rrmse=M4_pima_rrmse_test;
        y_M4_pima=y_M4_pima_test;
    end
end


y_M5_pima=[];
[t, y_M5_pima_test] = ode23s(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_pima);
if length(y_M5_pima_test)<133
    M5_pima_rrmse=1e10;
else
    M5_pima_rrmse=(rmse(y_M5_pima_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M5_pima=y_M5_pima_test;
end

[t, y_M5_pima_test] = ode15s(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_pima);
if length(y_M5_pima_test)<133
    M5_pima_rrmse_test=1e10;
else
    M5_pima_rrmse_test=(rmse(y_M5_pima_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M5_pima_rrmse_test<M5_pima_rrmse
        M5_pima_rrmse=M5_pima_rrmse_test;
        y_M5_pima=y_M5_pima_test;
    end
end

[t, y_M5_pima_test] = ode78(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_pima);
if length(y_M5_pima_test)<133
    M5_pima_rrmse_test=1e10;
else
    M5_pima_rrmse_test=(rmse(y_M5_pima_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M5_pima_rrmse_test<M5_pima_rrmse
        M5_pima_rrmse=M5_pima_rrmse_test;
        y_M5_pima=y_M5_pima_test;
    end
end

[t, y_M5_pima_test] = ode45(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_pima);
if length(y_M5_pima_test)<133
    M5_pima_rrmse_test=1e10;
else
    M5_pima_rrmse_test=(rmse(y_M5_pima_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M5_pima_rrmse_test<M5_pima_rrmse
        M5_pima_rrmse=M5_pima_rrmse_test;
        y_M5_pima=y_M5_pima_test;
    end
end

%Display
figure
scatter(t_inf_data,y_inf_data, 'k','LineWidth',2)
hold on
plot(t,y_M1_pima(:,4), 'Color', [0.9 0.6 0.0 0.6], 'LineStyle', '-', 'LineWidth', 11)
plot(t,y_M2_pima(:,8), 'Color', [0.35 0.7 0.9 0.7], 'LineStyle', '-', 'LineWidth', 9)
plot(t,y_M3_pima(:,8), 'Color', [0.0 0.6 0.5 0.8], 'LineStyle', '-', 'LineWidth', 7)
plot(t,y_M4_pima(:,9), 'Color', [0.8 0.4 0.0 0.9], 'LineStyle', '-', 'LineWidth', 5)
plot(t,y_M5_pima(:,10), 'Color', [0 0 0 1], 'LineStyle', '-', 'LineWidth', 3)
%plot(t,y_M5_pima(:,10), 'Color', [0.8 0.6 0.7 1], 'LineStyle', '-', 'LineWidth', 3)
legend('Pima Infected','Model 1 fit', 'Model 2 fit','Model 3 fit','Model 4 fit','Model 5 fit','Location','best' ,'FontSize', 16);
title("Valley Fever Model Comparison for Pima County ", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10,365*11])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
subtitle("M1 RRMSE="+M1_pima_rrmse+"%, M2 RRMSE="+M2_pima_rrmse+"%, M3 RRMSE="+M3_pima_rrmse...
    +"%, M4 RRMSE="+M4_pima_rrmse+"%, M5 RRMSE="+M5_pima_rrmse+"%", 'FontSize', 14)
xlabel('Year', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
ylim([0,max(y_inf_data)+100])
xlim([0,max(t_inf_data)+31])
hold off


elseif choose_region==4
%Pinal
disp('Plotting all Pinal fittings')
y_inf_data=y_inf_data_Pinal;
y_pop_data=y_pop_data_Pinal;

params_m1pswarm_pinal = 0;

y_M1_pinal=[];
[t, y_M1_pinal_test] = ode23s(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_pinal);
if length(y_M1_pinal_test)<133
    M1_pinal_rrmse=1e10;
else
    M1_pinal_rrmse=(rmse(y_M1_pinal_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M1_pinal=y_M1_pinal_test;
end

[t, y_M1_pinal_test] = ode15s(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_pinal);
if length(y_M1_pinal_test)<133
    M1_pinal_rrmse_test=1e10;
else
    M1_pinal_rrmse_test=(rmse(y_M1_pinal_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M1_pinal_rrmse_test<M1_pinal_rrmse
        M1_pinal_rrmse=M1_pinal_rrmse_test;
        y_M1_pinal=y_M1_pinal_test;
    end
end

[t, y_M1_pinal_test] = ode78(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_pinal);
if length(y_M1_pinal_test)<133
    M1_pinal_rrmse_test=1e10;
else
    M1_pinal_rrmse_test=(rmse(y_M1_pinal_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M1_pinal_rrmse_test<M1_pinal_rrmse
        M1_pinal_rrmse=M1_pinal_rrmse_test;
        y_M1_pinal=y_M1_pinal_test;
    end
end

[t, y_M1_pinal_test] = ode45(@M1_SF_T,t_inf_data,y0_M1,[],params_m1pswarm_pinal);
if length(y_M1_pinal_test)<133
    M1_pinal_rrmse_test=1e10;
else
    M1_pinal_rrmse_test=(rmse(y_M1_pinal_test(:,4) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M1_pinal_rrmse_test<M1_pinal_rrmse
        M1_pinal_rrmse=M1_pinal_rrmse_test;
        y_M1_pinal=y_M1_pinal_test;
    end
end

y_M2_pinal=[];
[t, y_M2_pinal_test] = ode23s(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_pinal);
if length(y_M2_pinal_test)<133
    M2_pinal_rrmse=1e10;
else
    M2_pinal_rrmse=(rmse(y_M2_pinal_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M2_pinal=y_M2_pinal_test;
end

[t, y_M2_pinal_test] = ode15s(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_pinal);
if length(y_M2_pinal_test)<133
    M2_pinal_rrmse_test=1e10;
else
    M2_pinal_rrmse_test=(rmse(y_M2_pinal_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M2_pinal_rrmse_test<M2_pinal_rrmse
        M2_pinal_rrmse=M2_pinal_rrmse_test;
        y_M2_pinal=y_M2_pinal_test;
    end
end

[t, y_M2_pinal_test] = ode78(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_pinal);
if length(y_M2_pinal_test)<133
    M2_pinal_rrmse_test=1e10;
else
    M2_pinal_rrmse_test=(rmse(y_M2_pinal_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M2_pinal_rrmse_test<M2_pinal_rrmse
        M2_pinal_rrmse=M2_pinal_rrmse_test;
        y_M2_pinal=y_M2_pinal_test;
    end
end

[t, y_M2_pinal_test] = ode45(@M2_SF,t_inf_data,y0_M2,[],params_m2pswarm_pinal);
if length(y_M2_pinal_test)<133
    M2_pinal_rrmse_test=1e10;
else
    M2_pinal_rrmse_test=(rmse(y_M2_pinal_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M2_pinal_rrmse_test<M2_pinal_rrmse
        M2_pinal_rrmse=M2_pinal_rrmse_test;
        y_M2_pinal=y_M2_pinal_test;
    end
end
 
y_M3_pinal=[];
[t, y_M3_pinal_test] = ode23s(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_pinal);
if length(y_M3_pinal_test)<133
    M3_pinal_rrmse=1e10;
else
    M3_pinal_rrmse=(rmse(y_M3_pinal_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M3_pinal=y_M3_pinal_test;
end

[t, y_M3_pinal_test] = ode15s(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_pinal);
if length(y_M3_pinal_test)<133
    M3_pinal_rrmse_test=1e10;
else
    M3_pinal_rrmse_test=(rmse(y_M3_pinal_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M3_pinal_rrmse_test<M3_pinal_rrmse
        M3_pinal_rrmse=M3_pinal_rrmse_test;
        y_M3_pinal=y_M3_pinal_test;
    end
end

[t, y_M3_pinal_test] = ode78(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_pinal);
if length(y_M3_pinal_test)<133
    M3_pinal_rrmse_test=1e10;
else
    M3_pinal_rrmse_test=(rmse(y_M3_pinal_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M3_pinal_rrmse_test<M3_pinal_rrmse
        M3_pinal_rrmse=M3_pinal_rrmse_test;
        y_M3_pinal=y_M3_pinal_test;
    end
end

[t, y_M3_pinal_test] = ode45(@M3_SF,t_inf_data,y0_M3,[],params_m3pswarm_pinal);
if length(y_M3_pinal_test)<133
    M3_pinal_rrmse_test=1e10;
else
    M3_pinal_rrmse_test=(rmse(y_M3_pinal_test(:,8) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M3_pinal_rrmse_test<M3_pinal_rrmse
        M3_pinal_rrmse=M3_pinal_rrmse_test;
        y_M3_pinal=y_M3_pinal_test;
    end
end

y_M4_pinal=[];
[t, y_M4_pinal_test] = ode23s(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_pinal);
if length(y_M4_pinal_test)<133
    M4_pinal_rrmse=1e10;
else
    M4_pinal_rrmse=(rmse(y_M4_pinal_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M4_pinal=y_M4_pinal_test;
end

[t, y_M4_pinal_test] = ode15s(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_pinal);
if length(y_M4_pinal_test)<133
    M4_pinal_rrmse_test=1e10;
else
    M4_pinal_rrmse_test=(rmse(y_M4_pinal_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M4_pinal_rrmse_test<M4_pinal_rrmse
        M4_pinal_rrmse=M4_pinal_rrmse_test;
        y_M4_pinal=y_M4_pinal_test;
    end
end

[t, y_M4_pinal_test] = ode78(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_pinal);
if length(y_M4_pinal_test)<133
    M4_pinal_rrmse_test=1e10;
else
    M4_pinal_rrmse_test=(rmse(y_M4_pinal_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M4_pinal_rrmse_test<M4_pinal_rrmse
        M4_pinal_rrmse=M4_pinal_rrmse_test;
        y_M4_pinal=y_M4_pinal_test;
    end
end

[t, y_M4_pinal_test] = ode45(@M4_SF_S,t_inf_data,y0_M4,[],params_m4pswarm_pinal);
if length(y_M4_pinal_test)<133
    M4_pinal_rrmse_test=1e10;
else
    M4_pinal_rrmse_test=(rmse(y_M4_pinal_test(:,9) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M4_pinal_rrmse_test<M4_pinal_rrmse
        M4_pinal_rrmse=M4_pinal_rrmse_test;
        y_M4_pinal=y_M4_pinal_test;
    end
end


y_M5_pinal=[];
[t, y_M5_pinal_test] = ode23s(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_pinal);
if length(y_M5_pinal_test)<133
    M5_pinal_rrmse=1e10;
else
    M5_pinal_rrmse=(rmse(y_M5_pinal_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    y_M5_pinal=y_M5_pinal_test;
end

[t, y_M5_pinal_test] = ode15s(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_pinal);
if length(y_M5_pinal_test)<133
    M5_pinal_rrmse_test=1e10;
else
    M5_pinal_rrmse_test=(rmse(y_M5_pinal_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M5_pinal_rrmse_test<M5_pinal_rrmse
        M5_pinal_rrmse=M5_pinal_rrmse_test;
        y_M5_pinal=y_M5_pinal_test;
    end
end

[t, y_M5_pinal_test] = ode78(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_pinal);
if length(y_M5_pinal_test)<133
    M5_pinal_rrmse_test=1e10;
else
    M5_pinal_rrmse_test=(rmse(y_M5_pinal_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M5_pinal_rrmse_test<M5_pinal_rrmse
        M5_pinal_rrmse=M5_pinal_rrmse_test;
        y_M5_pinal=y_M5_pinal_test;
    end
end

[t, y_M5_pinal_test] = ode45(@M5_SF,t_inf_data,y0_M5,[],params_m5pswarm_pinal);
if length(y_M5_pinal_test)<133
    M5_pinal_rrmse_test=1e10;
else
    M5_pinal_rrmse_test=(rmse(y_M5_pinal_test(:,10) , y_inf_data)/sqrt(sumsqr(y_inf_data')))*100;
    if  M5_pinal_rrmse_test<M5_pinal_rrmse
        M5_pinal_rrmse=M5_pinal_rrmse_test;
        y_M5_pinal=y_M5_pinal_test;
    end
end

%Display
figure
scatter(t_inf_data,y_inf_data, 'k','LineWidth',2)
hold on
plot(t,y_M1_pinal(:,4), 'Color', [0.9 0.6 0.0 0.6], 'LineStyle', '-', 'LineWidth', 11)
plot(t,y_M2_pinal(:,8), 'Color', [0.35 0.7 0.9 0.7], 'LineStyle', '-', 'LineWidth', 9)
plot(t,y_M3_pinal(:,8), 'Color', [0.0 0.6 0.5 0.8], 'LineStyle', '-', 'LineWidth', 7)
plot(t,y_M4_pinal(:,9), 'Color', [0.8 0.4 0.0 0.9], 'LineStyle', '-', 'LineWidth', 5)
plot(t,y_M5_pinal(:,10), 'Color', [0 0 0 1], 'LineStyle', '-', 'LineWidth', 3)
%plot(t,y_M5_pinal(:,10), 'Color', [0.8 0.6 0.7 1], 'LineStyle', '-', 'LineWidth', 3)
legend('Pinal Infected','Model 1 fit', 'Model 2 fit','Model 3 fit','Model 4 fit','Model 5 fit','Location','best' ,'FontSize', 16);
title("Valley Fever Model Comparison for Pinal County ", 'FontSize', 22)
xticks([0,365,365*2,365*3,365*4,365*5,365*6,365*7,365*8,365*9,365*10,365*11])
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
subtitle("M1 RRMSE="+M1_pinal_rrmse+"%, M2 RRMSE="+M2_pinal_rrmse+"%, M3 RRMSE="+M3_pinal_rrmse...
    +"%, M4 RRMSE="+M4_pinal_rrmse+"%, M5 RRMSE="+M5_pinal_rrmse+"%", 'FontSize', 14)
xlabel('Year', 'FontSize', 18); ylabel('Infected Humans', 'FontSize', 18)
ylim([0,max(y_inf_data)+100])
xlim([0,max(t_inf_data)+31])
hold off

end

end

































%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Output function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stop = myOutputFcn(optimValues, state)
    stop = false;
    format long
    % Display or log the best solution so far
    if strcmp(state, 'iter')
        disp(['Best error so far: ', num2str(optimValues.bestfval)]);
        disp(['Best parameters so far: ', mat2str(optimValues.bestx)]);
        
        % Save to file or workspace for recovery
        save('bestSoFar.mat', 'optimValues');
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Output function Time ODE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function status = myOutputFcn_Time(t, y, flag)
% Time limit in seconds
timeLimit = 4;  % seconds
    persistent startTime
    if isempty(flag) % During integration
        elapsedTime = toc(startTime);
        if elapsedTime > timeLimit
            status = 1; % Stop integration
        else
            status = 0;
        end
    elseif strcmp(flag, 'init')
        startTime = tic;
        status = 0;
    elseif strcmp(flag, 'done')
        status = 0;
    end
end




function outFcn = makeTimedOutputFcn(startTime, limitSec)
    outFcn = @(t, y, flag) timedOutputFcn(t, y, flag, startTime, limitSec);
end

% Timer-aware output function
function status = timedOutputFcn(t, y, flag, startTime, timeLimit)
    if isempty(flag) || strcmp(flag, '')
        status = toc(startTime) > timeLimit;
    else
        status = 0;
    end
end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Objective function Model 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective function: minimize difference between ODE solution and target
function error = objective_functionM0(p, tspan, y0, y_pop_data)
    % Solve ODE with given p
    [~, y] = ode15s(@(t, Y) pop_fit(t, Y, p), tspan, y0); %(t,a,params)

    % Compute mean squared error between solution and target
    %error = sum(sum((y - y_pop_data).^2));
    %error= (rmse(y_pop_data,y)/sqrt(sumsqr(y')));
    %error= rmse(y_pop_data,y);
   error=(rmse(y,y_pop_data)/sqrt(sumsqr(y_pop_data)));
    if error==inf||error==-inf
        % y
        % size(y)
        %  size(y_pop_data)
        %  rmse(y,y_pop_data)
        %  sqrt(sumsqr(y_pop_data))
         %pause;
        error=1e10;
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Objective function Model 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective function: minimize difference between ODE solution and target
function errorOBJ = objective_functionM1(p, tspan, y0, y_inf_data)
     % --- State flags for the timeout mechanism ---
    timed_out = false; 
    start_time_for_ode = []; 

    % --- 1. Define the ODE Problem using the input 'p' ---
    odefun = @(t, y) M1_SF_T(t, y, p);
    
    
    % --- 2. Solver Chain and Timeout Configuration ---
    timeLimit = 15.0; 

    % --- Define multiple sets of options ---
    % Standard options
    stdOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0));
    % Looser options for a second attempt
    looseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
                          'RelTol', 1e-2, 'AbsTol', 1e-4);
    % Very loose options for a final, best-effort attempt
    vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
                           'RelTol', 1e-1, 'AbsTol', 1e-2);

    % --- Create a single, extended solver chain ---
    solverChain = {
        % --- Pass 1: Attempting with standard accuracy ---
        struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
        struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
        struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
        
        % --- Pass 2: Retrying with looser accuracy ---
        struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
        struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),

        % --- Pass 3: Final attempt with very loose accuracy ---
        struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
    };
    
    % --- 3. Execute the Solver Chain ---
    t_out = [];
    y_out = [];
    success = false;
    
    for i = 1:length(solverChain)
        current = solverChain{i};
        timed_out = false;
        start_time_for_ode = []; 
        
        try
            [t_out, y_out] = current.solver(odefun, tspan, y0, current.options);
            
            if timed_out
                continue; % Timed out, try next solver
            elseif size(y_out,1)<length(tspan)-1
                continue;   % solver can't solve for entire time span, try next solver
            else
                success = true; % Solver succeeded.
                break; % Exit the loop.
            end
        catch ME
             % If any error occurs (including tolerance errors), just try the next solver.
             if contains(ME.identifier, 'IntegrationTolNotMet')
                 % This was a tolerance failure, which is an expected failure mode.
                 continue;
             else
                 % This was a different, unexpected error. Stop processing this particle.
                 success = false;
                 break;
             end
        end
    end % End of solverChain loop

    % --- 4. Calculate Final Objective Value ---
    if success
        [numRowsM,numCols] =size(y_out);
        if numRowsM<length(tspan)-1
            errorOBJ=1e10;
        else
        ycomp=y_inf_data(1:numRowsM,:);
        errorOBJ = max((rmse(y_out(:,4),  ycomp)/sqrt(sumsqr( ycomp'))));
        end
    else
       errorOBJ = 1e10; 
    end

    % --- NESTED TIMEOUT FUNCTION ---
    function status = timeLimitOutputFcn(~, ~, flag)
        status = 0;
        if strcmp(flag, 'init')
            start_time_for_ode = tic;
        elseif isempty(flag)
            if ~isempty(start_time_for_ode) && toc(start_time_for_ode) > timeLimit
                timed_out = true;
                status = 1;
            end
        end
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RSS Objective function Model 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective function: minimize difference between ODE solution and target
function rss = objective_functionM1_RSS(p, tspan, y0, y_inf_data)
     % --- State flags for the timeout mechanism ---
    timed_out = false; 
    start_time_for_ode = []; 

    % --- 1. Define the ODE Problem using the input 'p' ---
    odefun = @(t, y) M1_SF_T(t, y, p);
    
    
    % --- 2. Solver Chain and Timeout Configuration ---
    timeLimit = 15.0; 

    % --- Define multiple sets of options ---
    % Standard options
    stdOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0));
    % Looser options for a second attempt
    looseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
                          'RelTol', 1e-2, 'AbsTol', 1e-4);
    % Very loose options for a final, best-effort attempt
    vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
                           'RelTol', 1e-1, 'AbsTol', 1e-2);

    % --- Create a single, extended solver chain ---
    solverChain = {
        % --- Pass 1: Attempting with standard accuracy ---
        struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
        struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
        struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
        
        % --- Pass 2: Retrying with looser accuracy ---
        struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
        struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),

        % --- Pass 3: Final attempt with very loose accuracy ---
        struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
    };
    
    % --- 3. Execute the Solver Chain ---
    t_out = [];
    y_out = [];
    success = false;
    
    for i = 1:length(solverChain)
        current = solverChain{i};
        timed_out = false;
        start_time_for_ode = []; 
        
        try
            [t_out, y_out] = current.solver(odefun, tspan, y0, current.options);
            
            if timed_out
                continue; % Timed out, try next solver
            elseif size(y_out,1)<length(tspan)-1
                continue;   % solver can't solve for entire time span, try next solver
            else
                success = true; % Solver succeeded.
                break; % Exit the loop.
            end
        catch ME
             % If any error occurs (including tolerance errors), just try the next solver.
             if contains(ME.identifier, 'IntegrationTolNotMet')
                 % This was a tolerance failure, which is an expected failure mode.
                 continue;
             else
                 % This was a different, unexpected error. Stop processing this particle.
                 success = false;
                 break;
             end
        end
    end % End of solverChain loop

    % --- 4. Calculate Final Objective Value ---
    if success
        [numRowsM,numCols] =size(y_out);
        if numRowsM<length(tspan)-1
            rss=1e12;
        else
        ycomp=y_inf_data(1:numRowsM,:);
        residuals = ycomp - y_out(:,4);
        rss = sum(residuals.^2);
        end
    else
       rss = 1e12; 
    end

    % --- NESTED TIMEOUT FUNCTION ---
    function status = timeLimitOutputFcn(~, ~, flag)
        status = 0;
        if strcmp(flag, 'init')
            start_time_for_ode = tic;
        elseif isempty(flag)
            if ~isempty(start_time_for_ode) && toc(start_time_for_ode) > timeLimit
                timed_out = true;
                status = 1;
            end
        end
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Objective function Model 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective function: minimize difference between ODE solution and target
function errorOBJ = objective_functionM2(p, tspan, y0, y_inf_data)
    % __________Flags for the timeout mechanism __________
    timed_out = false; 
    start_time_for_ode = []; 

    % __________ODE Problem __________
    odefun = @(t, y) M2_SF(t, y, p);
    
    
    % Solver Chain and Timeout Config.
    timeLimit = 15; 

    % __________Define options__________
    % Standard options
    stdOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0));
    % Looser options for a second attempt
    looseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
                          'RelTol', 1e-2, 'AbsTol', 1e-4);
    % Very loose options for a final, best-effort attempt
    vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
                           'RelTol', 1e-1, 'AbsTol', 1e-2);

    % __________Create a single, extended solver chain__________
    solverChain = {
        % __________Pass 1: standard accuracy __________
        struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
        struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
        struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
        
        % --- Pass 2: looser accuracy __________
        struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
        struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),

        % __________Pass 3: Very loose accuracy__________
        struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
    };
    
    % __________Execute Chain__________
    t_out = [];
    y_out = [];
    success = false;
    
    for i = 1:length(solverChain)
        current = solverChain{i};
        timed_out = false;
        start_time_for_ode = []; 
        
        try
            [t_out, y_out] = current.solver(odefun, tspan, y0, current.options);
            
            if timed_out
                continue; % Timed out, try next solver
            elseif size(y_out,1)<length(tspan)-1
                continue;   % solver can't solve for entire time span, try next solver
            else
                success = true; % Solver succeeded.
                break; % Exit the loop.
            end
        catch ME
             % If any error occurs (including tolerance errors), just try the next solver.
             if contains(ME.identifier, 'IntegrationTolNotMet')
                 % This was a tolerance failure, which is an expected failure mode.
                 continue;
             else
                 % This was a different, unexpected error. Stop processing this particle.
                 success = false;
                 break;
             end
        end
    end % End of solverChain loop

    % __________Calculate Error __________
    if success
        [numRowsM,numCols] =size(y_out);
        if numRowsM<length(tspan)-1
            errorOBJ=1e10;
        else
        ycomp=y_inf_data(1:numRowsM,:);
        errorOBJ = max((rmse(y_out(:,7),  ycomp)/sqrt(sumsqr( ycomp'))));
        end
    else
       errorOBJ = 1e10; 
    end

    % __________NESTED TIMEOUT FUNCTION__________ (works better w/ nested)
    function status = timeLimitOutputFcn(~, ~, flag)
        status = 0;
        if strcmp(flag, 'init')
            start_time_for_ode = tic;
        elseif isempty(flag)
            if ~isempty(start_time_for_ode) && toc(start_time_for_ode) > timeLimit
                timed_out = true;
                status = 1;
            end
        end
    end

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RSS Objective function Model 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective function: minimize difference between ODE solution and target
function rss = objective_functionM2_RSS(p, tspan, y0, y_inf_data)
    % __________Flags for the timeout mechanism __________
    timed_out = false; 
    start_time_for_ode = []; 

    % __________ODE Problem __________
    odefun = @(t, y) M2_SF(t, y, p);
    
    
    % Solver Chain and Timeout Config.
    timeLimit = 15; 

    % __________Define options__________
    % Standard options
    stdOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0));
    % Looser options for a second attempt
    looseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
                          'RelTol', 1e-2, 'AbsTol', 1e-4);
    % Very loose options for a final, best-effort attempt
    vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
                           'RelTol', 1e-1, 'AbsTol', 1e-2);

    % __________Create a single, extended solver chain__________
    solverChain = {
        % __________Pass 1: standard accuracy __________
        struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
        struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
        struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
        
        % --- Pass 2: looser accuracy __________
        struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
        struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),

        % __________Pass 3: Very loose accuracy__________
        struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
    };
    
    % __________Execute Chain__________
    t_out = [];
    y_out = [];
    success = false;
    
    for i = 1:length(solverChain)
        current = solverChain{i};
        timed_out = false;
        start_time_for_ode = []; 
        
        try
            [t_out, y_out] = current.solver(odefun, tspan, y0, current.options);
            
            if timed_out
                continue; % Timed out, try next solver
            elseif size(y_out,1)<length(tspan)-1
                continue;   % solver can't solve for entire time span, try next solver
            else
                success = true; % Solver succeeded.
                break; % Exit the loop.
            end
        catch ME
             % If any error occurs (including tolerance errors), just try the next solver.
             if contains(ME.identifier, 'IntegrationTolNotMet')
                 % This was a tolerance failure, which is an expected failure mode.
                 continue;
             else
                 % This was a different, unexpected error. Stop processing this particle.
                 success = false;
                 break;
             end
        end
    end % End of solverChain loop

    % __________Calculate Error __________
    if success
        [numRowsM,numCols] =size(y_out);
        if numRowsM<length(tspan)-1
            rss=1e12;
        else
        ycomp=y_inf_data(1:numRowsM,:);
        residuals = ycomp - y_out(:,7);
        rss = sum(residuals.^2);  
        end
    else
       rss = 1e12; 
    end

    % __________NESTED TIMEOUT FUNCTION__________ 
    function status = timeLimitOutputFcn(~, ~, flag)
        status = 0;
        if strcmp(flag, 'init')
            start_time_for_ode = tic;
        elseif isempty(flag)
            if ~isempty(start_time_for_ode) && toc(start_time_for_ode) > timeLimit
                timed_out = true;
                status = 1;
            end
        end
    end

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Objective function Model 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective function: minimize difference between ODE solution and target
function errorOBJ = objective_functionM3(p, tspan, y0, y_inf_data,county)
%WORKING TIMED ODE RUNS
maxTime = 15; 
% Initialize outputs
    solution_y = [];
    solverUsed = ['None (All failed)']; 

    % The timer will be reset before each solver attempt. A single nested output function can be used by all solvers.
    % It captures 'solverStartTime' and 'maxTime' from the local scope.
    solverStartTime = []; % Will be set before each try
    function status = timeLimitOutputFcn(t, y, flag)
        if isempty(flag)
            if toc(solverStartTime) > maxTime
                    error('Solver:TimeLimitExceeded', 'Solver time limit (%.1fs) exceeded.', maxTime, solverUsed);
            end
        end
        status = 0;
    end

    timed_options = odeset('OutputFcn', @timeLimitOutputFcn);
    
    % NESTED TRY-CATCH FOR SOLVER FALLBACK CHAIN
    try % ATTEMPT 1: ode15s
        %fprintf('  -> Trying ode15s...');
        solverStartTime = tic; % Reset timer
        [~, solution_y] = ode15s(@(t, Y) M3_SF(t, Y, p,county), tspan, y0,timed_options);
        solverUsed = 'ode15s';
        if size(solution_y, 1) < length(tspan)
            % Throw an error to trigger the catch block and try the next solver
            error('Solver:IncompleteSolution', 'ode15s finished but solution was too short.');
        end
        %fprintf(' Succeeded.\n');
    catch ME1
        if strcmp(ME1.identifier, 'Solver:TimeLimitExceeded') || strcmp(ME1.identifier, 'Solver:IncompleteSolution')
            fprintf(' Timed out.\n');
            try % ATTEMPT 2: ode23s
                fprintf('    -> Trying ode23s...');
                solverStartTime = tic; % Reset timer
                [~, solution_y] = ode23s(@(t, Y) M3_SF(t, Y, p,county), tspan, y0, timed_options);
                solverUsed = 'ode23s';
                if size(solution_y, 1) < length(tspan)
                error('Solver:IncompleteSolution', 'ode23s finished but solution was too short.');
                end
                fprintf(' Succeeded.\n');
            catch ME2
                if strcmp(ME2.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME2.identifier, 'Solver:IncompleteSolution')
                    fprintf(' Timed out.\n');
                    try % ATTEMPT 3: ode45
                        fprintf('      -> Trying ode45...');
                        solverStartTime = tic; % Reset timer
                        [~, solution_y] = ode45(@(t, Y) M3_SF(t, Y, p,county), tspan, y0, timed_options);
                        solverUsed = 'ode45';
                        if size(solution_y, 1) < length(tspan)
                         error('Solver:IncompleteSolution', 'ode45 finished but solution was too short.');
                        end
                        fprintf(' Succeeded.\n');
                    catch ME3
                        if strcmp(ME3.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME3.identifier, 'Solver:IncompleteSolution')
                            fprintf(' Timed out.\n');
                            try % ATTEMPT 4: ode113 (Last resort, no time limit)
                            fprintf('        -> Trying ode23...');
                             solverStartTime = tic; % Reset timer
                            [~, solution_y] = ode23(@(t, Y) M3_SF(t, Y, p,county), tspan, y0,timed_options);
                            solverUsed = 'ode23';
                            if size(solution_y, 1) < length(tspan)
                            error('Solver:IncompleteSolution', 'ode23 finished but solution was too short.');
                            end
                            fprintf(' Succeeded.\n');
                            catch ME4
                                if strcmp(ME4.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME4.identifier, 'Solver:IncompleteSolution')
                                    fprintf(' Timed out.\n');
                                    try % ATTEMPT 5: ode15s (Loose, no time limit)
                                    fprintf('          -> FINAL ATTEMPT: ode15s (loose tolerance)...');

                                    loose_options_final= odeset('RelTol', 1e-2, ...
                                                                'AbsTol', 1e-4, ...
                                                                'MaxStep', 1e-3, ...
                                                                'InitialStep', 1e-3,...
                                                                'OutputFcn', @timeLimitOutputFcn);
                                    [~, solution_y] = ode15s(@(t, Y) M3_SF(t, Y, p,county), tspan, y0, loose_options_final);
                                    solverUsed = 'ode15s (loose)';
                                        if size(solution_y, 1) < length(tspan)
                                         error('Solver:IncompleteSolution', 'ode15s loose finished but solution was too short.');
                                         end
                                        fprintf(' Succeeded.\n');
                                    catch ME5
                                       %_____
                                        if strcmp(ME5.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME5.identifier, 'Solver:IncompleteSolution')
                                            % This is the final timeout. Do not error.
                                            % Simply log it and let the function proceed.
                                            fprintf(' Timed out. Assigning penalty.\n');
                                            solverUsed = 'None (All timed out)';
                                            solution_y = []; % Ensure solution is empty
                                        else
                                            rethrow(ME5); % A different error from the last step
                                        end
                                    end
                                else
                                    rethrow(ME4); % Unexpected error from ode113
                                end
                            end
                        else
                            rethrow(ME3); % Unexpected error from ode45
                        end
                    end
                else
                    rethrow(ME2); % Unexpected error from ode23s
                end
            end
        else
            rethrow(ME1); % Unexpected error from ode15s
        end
    end

    % If all solvers failed, 'solution_y' will be empty.
    if ~isempty(solution_y)
        [numRowsM,numCols] =size(solution_y);
        if size(solution_y, 1) < length(tspan)
            errorOBJ=1e10;
            fprintf(' Problem in solver, did no solve full length.\n');
        else
        ycomp=y_inf_data(1:numRowsM,:);
        errorOBJ = max((rmse(solution_y(:,7),  ycomp)/sqrt(sumsqr( ycomp'))));
        end
    else
        errorOBJ = 1e10; % Penalty for complete failure
    end

%ALTERNATE
    % %    % __________Flags for the timeout mechanism __________
    % % timed_out = false; 
    % % start_time_for_ode = []; 
    % % 
    % % % __________ODE Problem __________
    % % odefun = @(t, y) M3_SF(t, y, p,county);
    % % 
    % % 
    % % % Solver Chain and Timeout Config.
    % % timeLimit = 15.0; 
    % % 
    % % % __________Define options__________
    % % % Standard options
    % % stdOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0));
    % % % Looser options for a second attempt
    % % looseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
    % %                       'RelTol', 1e-2, 'AbsTol', 1e-4);
    % % % Very loose options for a final, best-effort attempt
    % % vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
    % %                        'RelTol', 1e-1, 'AbsTol', 1e-2);
    % % 
    % % % __________Create a single, extended solver chain__________
    % % solverChain = {
    % %     % __________Pass 1: standard accuracy __________
    % %     struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
    % %     struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
    % %     struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
    % %     struct('solver', @ode78,  'name', 'ode78 (standard tol)',  'options', stdOptions),
    % % 
    % %     % --- Pass 2: looser accuracy __________
    % %     struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
    % %     struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),
    % % 
    % %     % __________Pass 3: Very loose accuracy__________
    % %     struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
    % % };
    % % 
    % % % __________Execute Chain__________
    % % t_out = [];
    % % y_out = [];
    % % success = false;
    % % 
    % % for i = 1:length(solverChain)
    % %     current = solverChain{i};
    % %     timed_out = false;
    % %     start_time_for_ode = []; 
    % % 
    % %     try
    % %         [t_out, y_out] = current.solver(odefun, tspan, y0, current.options);
    % % 
    % %         if timed_out
    % %             continue; % Timed out, try next solver
    % %         elseif size(y_out,1)<length(tspan)-1
    % %             continue;   % solver can't solve for entire time span, try next solver
    % %         else
    % %             success = true; % Solver succeeded.
    % %             break; % Exit the loop.
    % %         end
    % %     catch ME
    % %          % If any error occurs (including tolerance errors), just try the next solver.
    % %          if contains(ME.identifier, 'IntegrationTolNotMet')
    % %              % This was a tolerance failure, which is an expected failure mode.
    % %              continue;
    % %          else
    % %              % This was a different, unexpected error. Stop processing this particle.
    % %              success = false;
    % %              break;
    % %          end
    % %     end
    % % end % End of solverChain loop
    % % 
    % % % __________Calculate Error __________
    % % if success
    % %     [numRowsM,numCols] =size(y_out);
    % %     if numRowsM<length(tspan)-1
    % %         errorOBJ=1e10;
    % %     else
    % %     ycomp=y_inf_data(1:numRowsM,:);
    % %     errorOBJ = max((rmse(y_out(:,7),  ycomp)/sqrt(sumsqr( ycomp'))));
    % %     end
    % % else
    % %    errorOBJ = 1e10; 
    % % end
    % % 
    % % % __________NESTED TIMEOUT FUNCTION__________ (works better w/ nested)
    % % function status = timeLimitOutputFcn(~, ~, flag)
    % %     status = 0;
    % %     if strcmp(flag, 'init')
    % %         start_time_for_ode = tic;
    % %     elseif isempty(flag)
    % %         if ~isempty(start_time_for_ode) && toc(start_time_for_ode) > timeLimit
    % %             timed_out = true;
    % %             status = 1;
    % %         end
    % %     end
    % % end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RSS Objective function Model 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective function: minimize difference between ODE solution and target
function rss = objective_functionM3_RSS(p, tspan, y0, y_inf_data,county)
%WORKING TIMED ODE RUNS
maxTime = 15; 
% Initialize outputs
    solution_y = [];
    solverUsed = ['None (All failed)']; %'None (All failed)'

    % The timer will be reset before each solver attempt. A single nested output function can be used by all solvers.
    % It captures 'solverStartTime' and 'maxTime' from the local scope.
    solverStartTime = []; % Will be set before each try
    function status = timeLimitOutputFcn(t, y, flag)
        if isempty(flag)
            if toc(solverStartTime) > maxTime
                    error('Solver:TimeLimitExceeded', 'Solver time limit (%.1fs) exceeded.', maxTime, solverUsed);
            end
        end
        status = 0;
    end

    timed_options = odeset('OutputFcn', @timeLimitOutputFcn);
    
    % NESTED TRY-CATCH FOR SOLVER FALLBACK CHAIN
    try % ATTEMPT 1: ode15s
        %fprintf('  -> Trying ode15s...');
        solverStartTime = tic; % Reset timer
        [~, solution_y] = ode15s(@(t, Y) M3_SF(t, Y, p,county), tspan, y0,timed_options);
        solverUsed = 'ode15s';
        if size(solution_y, 1) < length(tspan)
            % Throw an error to trigger the catch block and try the next solver
            error('Solver:IncompleteSolution', 'ode15s finished but solution was too short.');
        end
        %fprintf(' Succeeded.\n');
    catch ME1
        if strcmp(ME1.identifier, 'Solver:TimeLimitExceeded') || strcmp(ME1.identifier, 'Solver:IncompleteSolution')
            fprintf(' Timed out.\n');
            try % ATTEMPT 2: ode23s
                fprintf('    -> Trying ode23s...');
                solverStartTime = tic; % Reset timer
                [~, solution_y] = ode23s(@(t, Y) M3_SF(t, Y, p,county), tspan, y0, timed_options);
                solverUsed = 'ode23s';
                if size(solution_y, 1) < length(tspan)
                error('Solver:IncompleteSolution', 'ode23s finished but solution was too short.');
                end
                fprintf(' Succeeded.\n');
            catch ME2
                if strcmp(ME2.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME2.identifier, 'Solver:IncompleteSolution')
                    fprintf(' Timed out.\n');
                    try % ATTEMPT 3: ode45
                        fprintf('      -> Trying ode45...');
                        solverStartTime = tic; % Reset timer
                        [~, solution_y] = ode45(@(t, Y) M3_SF(t, Y, p,county), tspan, y0, timed_options);
                        solverUsed = 'ode45';
                        if size(solution_y, 1) < length(tspan)
                         error('Solver:IncompleteSolution', 'ode45 finished but solution was too short.');
                        end
                        fprintf(' Succeeded.\n');
                    catch ME3
                        if strcmp(ME3.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME3.identifier, 'Solver:IncompleteSolution')
                            fprintf(' Timed out.\n');
                            try % ATTEMPT 4: ode113 (Last resort, no time limit)
                            fprintf('        -> Trying ode23...');
                             solverStartTime = tic; % Reset timer
                            [~, solution_y] = ode23(@(t, Y) M3_SF(t, Y, p,county), tspan, y0,timed_options);
                            solverUsed = 'ode23';
                            if size(solution_y, 1) < length(tspan)
                            error('Solver:IncompleteSolution', 'ode23 finished but solution was too short.');
                            end
                            fprintf(' Succeeded.\n');
                            catch ME4
                                if strcmp(ME4.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME4.identifier, 'Solver:IncompleteSolution')
                                    fprintf(' Timed out.\n');
                                    try % ATTEMPT 5: ode15s (Loose, no time limit)
                                    fprintf('          -> FINAL ATTEMPT: ode15s (loose tolerance)...');

                                    loose_options_final= odeset('RelTol', 1e-2, ...
                                                                'AbsTol', 1e-4, ...
                                                                'MaxStep', 1e-3, ...
                                                                'InitialStep', 1e-3,...
                                                                'OutputFcn', @timeLimitOutputFcn);
                                    [~, solution_y] = ode15s(@(t, Y) M3_SF(t, Y, p,county), tspan, y0, loose_options_final);
                                    solverUsed = 'ode15s (loose)';
                                        if size(solution_y, 1) < length(tspan)
                                         error('Solver:IncompleteSolution', 'ode15s loose finished but solution was too short.');
                                         end
                                        fprintf(' Succeeded.\n');
                                    catch ME5
                                       %_____
                                        if strcmp(ME5.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME5.identifier, 'Solver:IncompleteSolution')
                                            % This is the final timeout. Do not error.
                                            % Simply log it and let the function proceed.
                                            fprintf(' Timed out. Assigning penalty.\n');
                                            solverUsed = 'None (All timed out)';
                                            solution_y = []; % Ensure solution is empty
                                        else
                                            rethrow(ME5); % A different error from the last step
                                        end
                                    end
                                else
                                    rethrow(ME4); % Unexpected error from ode113
                                end
                            end
                        else
                            rethrow(ME3); % Unexpected error from ode45
                        end
                    end
                else
                    rethrow(ME2); % Unexpected error from ode23s
                end
            end
        else
            rethrow(ME1); % Unexpected error from ode15s
        end
    end

    % If all solvers failed, 'solution_y' will be empty.
    if ~isempty(solution_y)
        [numRowsM,numCols] =size(solution_y);
        if size(solution_y, 1) < length(tspan)
            rss=1e12;
        else
        ycomp=y_inf_data(1:numRowsM,:);
        residuals = ycomp - solution_y(:,7);
        rss = sum(residuals.^2);      
        end
    else
       rss = 1e12; 
        
    end
%%%ALTERNATE
    % %    % __________Flags for the timeout mechanism __________
    % % timed_out = false; 
    % % start_time_for_ode = []; 
    % % 
    % % % __________ODE Problem __________
    % % odefun = @(t, y) M3_SF(t, y, p,county);
    % % 
    % % 
    % % % Solver Chain and Timeout Config.
    % % timeLimit = 15.0; 
    % % 
    % % % __________Define options__________
    % % % Standard options
    % % stdOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0));
    % % % Looser options for a second attempt
    % % looseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
    % %                       'RelTol', 1e-2, 'AbsTol', 1e-4);
    % % % Very loose options for a final, best-effort attempt
    % % vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
    % %                        'RelTol', 1e-1, 'AbsTol', 1e-2);
    % % 
    % % % __________Create a single, extended solver chain__________
    % % solverChain = {
    % %     % __________Pass 1: standard accuracy __________
    % %     struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
    % %     struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
    % %     struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
    % %     struct('solver', @ode78,  'name', 'ode78 (standard tol)',  'options', stdOptions),
    % % 
    % %     % --- Pass 2: looser accuracy __________
    % %     struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
    % %     struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),
    % % 
    % %     % __________Pass 3: Very loose accuracy__________
    % %     struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
    % % };
    % % 
    % % % __________Execute Chain__________
    % % t_out = [];
    % % y_out = [];
    % % success = false;
    % % 
    % % for i = 1:length(solverChain)
    % %     current = solverChain{i};
    % %     timed_out = false;
    % %     start_time_for_ode = []; 
    % % 
    % %     try
    % %         [t_out, y_out] = current.solver(odefun, tspan, y0, current.options);
    % % 
    % %         if timed_out
    % %             continue; % Timed out, try next solver
    % %         elseif size(y_out,1)<length(tspan)-1
    % %             continue;   % solver can't solve for entire time span, try next solver
    % %         else
    % %             success = true; % Solver succeeded.
    % %             break; % Exit the loop.
    % %         end
    % %     catch ME
    % %          % If any error occurs (including tolerance errors), just try the next solver.
    % %          if contains(ME.identifier, 'IntegrationTolNotMet')
    % %              % This was a tolerance failure, which is an expected failure mode.
    % %              continue;
    % %          else
    % %              % This was a different, unexpected error. Stop processing this particle.
    % %              success = false;
    % %              break;
    % %          end
    % %     end
    % % end % End of solverChain loop
    % % 
    % % % __________Calculate Error __________
    % % if success
    % %     [numRowsM,numCols] =size(y_out);
    % %     if numRowsM<length(tspan)-1
    % %         rss=1e12;
    % %     else
    % %     ycomp=y_inf_data(1:numRowsM,:);
    % %     residuals = ycomp - y_out(:,8);
    % %     rss = sum(residuals.^2);      
    % %     end
    % % else
    % %    rss = 1e12; 
    % % end
    % % 
    % % % __________NESTED TIMEOUT FUNCTION__________ (works better w/ nested)
    % % function status = timeLimitOutputFcn(~, ~, flag)
    % %     status = 0;
    % %     if strcmp(flag, 'init')
    % %         start_time_for_ode = tic;
    % %     elseif isempty(flag)
    % %         if ~isempty(start_time_for_ode) && toc(start_time_for_ode) > timeLimit
    % %             timed_out = true;
    % %             status = 1;
    % %         end
    % %     end
    % % end

end
 








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%M4 Simp  OBJ Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function errorOBJ = objective_functionM4_S(p, tspan, y0, y_inf_data,county)
    
t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];
    t_data=t_inf_data;

%WORKING TIMED ODE RUNS
maxTime = 15; 
% Initialize outputs
    solution_y = [];
    solverUsed = ['None (All failed)']; %'None (All failed)'

    % The timer will be reset before each solver attempt. A single nested output function can be used by all solvers.
    % It captures 'solverStartTime' and 'maxTime' from the local scope.
    solverStartTime = []; % Will be set before each try
    function status = timeLimitOutputFcn(t, y, flag)
        if isempty(flag)
            if toc(solverStartTime) > maxTime
                    error('Solver:TimeLimitExceeded', 'Solver time limit (%.1fs) exceeded.', maxTime, solverUsed);
            end
        end
        status = 0;
    end

    timed_options = odeset('OutputFcn', @timeLimitOutputFcn);
    
    % NESTED TRY-CATCH FOR SOLVER FALLBACK CHAIN
    try % ATTEMPT 1: ode15s
        %fprintf('  -> Trying ode15s...');
        solverStartTime = tic; % Reset timer
        [~, solution_y] = ode15s(@(t, Y) M4_SF_S(t, Y, p, county), tspan, y0,timed_options);
        solverUsed = 'ode15s';
        if size(solution_y, 1) < length(tspan)
            % Throw an error to trigger the catch block and try the next solver
            error('Solver:IncompleteSolution', 'ode15s finished but solution was too short.');
        end
        %fprintf(' Succeeded.\n');
    catch ME1
        if strcmp(ME1.identifier, 'Solver:TimeLimitExceeded') || strcmp(ME1.identifier, 'Solver:IncompleteSolution')
            fprintf(' Timed out.\n');
            try % ATTEMPT 2: ode23s
                fprintf('    -> Trying ode23s...');
                solverStartTime = tic; % Reset timer
                [~, solution_y] = ode23s(@(t, Y) M4_SF_S(t, Y, p,county), tspan, y0, timed_options);
                solverUsed = 'ode23s';
                if size(solution_y, 1) < length(tspan)
                error('Solver:IncompleteSolution', 'ode23s finished but solution was too short.');
                end
                fprintf(' Succeeded.\n');
            catch ME2
                if strcmp(ME2.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME2.identifier, 'Solver:IncompleteSolution')
                    fprintf(' Timed out.\n');
                    try % ATTEMPT 3: ode45
                        fprintf('      -> Trying ode45...');
                        solverStartTime = tic; % Reset timer
                        [~, solution_y] = ode45(@(t, Y) M4_SF_S(t, Y, p,county), tspan, y0, timed_options);
                        solverUsed = 'ode45';
                        if size(solution_y, 1) < length(tspan)
                         error('Solver:IncompleteSolution', 'ode45 finished but solution was too short.');
                        end
                        fprintf(' Succeeded.\n');
                    catch ME3
                        if strcmp(ME3.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME3.identifier, 'Solver:IncompleteSolution')
                            fprintf(' Timed out.\n');
                            try % ATTEMPT 4: ode113 (Last resort, no time limit)
                            fprintf('        -> Trying ode23...');
                             solverStartTime = tic; % Reset timer
                            [~, solution_y] = ode23(@(t, Y) M4_SF_S(t, Y, p,county), tspan, y0,timed_options);
                            solverUsed = 'ode23';
                            if size(solution_y, 1) < length(tspan)
                            error('Solver:IncompleteSolution', 'ode23 finished but solution was too short.');
                            end
                            fprintf(' Succeeded.\n');
                            catch ME4
                                if strcmp(ME4.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME4.identifier, 'Solver:IncompleteSolution')
                                    fprintf(' Timed out.\n');
                                    try % ATTEMPT 5: ode15s (Loose, no time limit)
                                    fprintf('          -> FINAL ATTEMPT: ode15s (loose tolerance)...');

                                    loose_options_final= odeset('RelTol', 1e-2, ...
                                                                'AbsTol', 1e-4, ...
                                                                'MaxStep', 1e-3, ...
                                                                'InitialStep', 1e-3,...
                                                                'OutputFcn', @timeLimitOutputFcn);
                                    [~, solution_y] = ode15s(@(t, Y) M4_SF_S(t, Y, p,county), tspan, y0, loose_options_final);
                                    solverUsed = 'ode15s (loose)';
                                        if size(solution_y, 1) < length(tspan)
                                         error('Solver:IncompleteSolution', 'ode15s loose finished but solution was too short.');
                                         end
                                        fprintf(' Succeeded.\n');
                                    catch ME5
                                       %_____
                                        if strcmp(ME5.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME5.identifier, 'Solver:IncompleteSolution')
                                            % This is the final timeout. Do not error.
                                            % Simply log it and let the function proceed.
                                            fprintf(' Timed out. Assigning penalty.\n');
                                            solverUsed = 'None (All timed out)';
                                            solution_y = []; % Ensure solution is empty
                                        else
                                            rethrow(ME5); % A different error from the last step
                                        end
                                    end
                                else
                                    rethrow(ME4); % Unexpected error from ode113
                                end
                            end
                        else
                            rethrow(ME3); % Unexpected error from ode45
                        end
                    end
                else
                    rethrow(ME2); % Unexpected error from ode23s
                end
            end
        else
            rethrow(ME1); % Unexpected error from ode15s
        end
    end

    % If all solvers failed, 'solution_y' will be empty.
    if ~isempty(solution_y)
        [numRowsM,numCols] =size(solution_y);
        if size(solution_y, 1) < length(tspan)
            errorOBJ=1e10;
            fprintf(' Problem in solver, did no solve full length.\n');
        else
        ycomp=y_inf_data(1:numRowsM,:);
        errorOBJ = max((rmse(solution_y(:,8),  ycomp)/sqrt(sumsqr( ycomp'))));
        end
    else
        errorOBJ = 1e10; % Penalty for complete failure
    end

    
%alternate
% % %alternate
% %    % --- State flags for the timeout mechanism ---
% %     timed_out = false; 
% %     start_time_for_ode = []; 
% % 
% %     % --- 1. Define the ODE Problem using the input 'p' ---
% %     odefun = @(t, y) M4_SF_S(t, y, p,county);
% % 
% % 
% %     % --- 2. Solver Chain and Timeout Configuration ---
% %     timeLimit = 15.0; 
% % 
% %     % --- Define multiple sets of options ---
% %     % Standard options
% %     stdOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0));
% %     % Looser options for a second attempt
% %     looseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
% %                           'RelTol', 1e-2, 'AbsTol', 1e-4);
% %     % Very loose options for a final, best-effort attempt
% %     vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
% %                            'RelTol', 1e-1, 'AbsTol', 1e-2);
% % 
% %     % --- Create a single, extended solver chain ---
% %     solverChain = {
% %         % --- Pass 1: Attempting with standard accuracy ---
% %         struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
% %         struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
% %         struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
% %         struct('solver', @ode78,  'name', 'ode45 (standard tol)',  'options', stdOptions),
% % 
% %         % --- Pass 2: Retrying with looser accuracy ---
% %         struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
% %         struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),
% % 
% %         % --- Pass 3: Final attempt with very loose accuracy ---
% %         struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
% %     };
% % 
% %     % --- 3. Execute the Solver Chain ---
% %     t_out = [];
% %     y_out = [];
% %     success = false;
% % 
% %     for i = 1:length(solverChain)
% %         current = solverChain{i};
% %         timed_out = false;
% %         start_time_for_ode = []; 
% % 
% %         try
% %             [t_out, y_out] = current.solver(odefun, tspan, y0, current.options);
% % 
% %             if timed_out
% %                continue; % Timed out, try next solver
% %             elseif size(y_out,1)<length(tspan)-1
% %                 continue;   % solver can't solve for entire time span, try next solver
% %             else
% %                 success = true; % Solver succeeded.
% %                 break; % Exit the loop.
% %             end
% %         catch ME
% %              % If any error occurs (including tolerance errors), just try the next solver.
% %              if contains(ME.identifier, 'IntegrationTolNotMet')
% %                  % This was a tolerance failure, which is an expected failure mode.
% %                  continue;
% %              else
% %                  % This was a different, unexpected error. Stop processing this particle.
% %                  success = false;
% %                  break;
% %              end
% %         end
% %     end % End of solverChain loop
% % 
% %     % --- 4. Calculate Final Objective Value ---
% %     if success
% %         [numRowsM,numCols] =size(y_out);
% %         if numRowsM<length(tspan)-1
% %         errorOBJ=1e10;
% %        else
% %         ycomp=y_inf_data(1:numRowsM,:);
% %         errorOBJ = max((rmse(y_out(:,8),  ycomp)/sqrt(sumsqr( ycomp'))));
% %         end
% %     else
% %        errorOBJ = 1e10; 

% %     end
% % 
% %     % --- NESTED TIMEOUT FUNCTION ---
% %     function status = timeLimitOutputFcn(~, ~, flag)
% %         status = 0;
% %         if strcmp(flag, 'init')
% %             start_time_for_ode = tic;
% %         elseif isempty(flag)
% %             if ~isempty(start_time_for_ode) && toc(start_time_for_ode) > timeLimit
% %                 timed_out = true;
% %                 status = 1;
% %             end
% %         end
% %     end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RSS M4 Simp  OBJ Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rss = objective_functionM4_S_RSS(p, tspan, y0, y_inf_data,county)
    
t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];
    t_data=t_inf_data;
%WORKING TIMED ODE RUNS
maxTime = 15; % Time limit in seconds for each attempt

    % Initialize outputs
    solution_y = [];
    solverUsed = ['None (All failed)']; %'None (All failed)'

    % The timer will be reset before each solver attempt. A single nested output function can be used by all solvers.
    % It captures 'solverStartTime' and 'maxTime' from the local scope.
    solverStartTime = []; % Will be set before each try
    function status = timeLimitOutputFcn(t, y, flag)
        if isempty(flag)
            if toc(solverStartTime) > maxTime
                    error('Solver:TimeLimitExceeded', 'Solver time limit (%.1fs) exceeded.', maxTime, solverUsed);
            end
        end
        status = 0;
    end

    timed_options = odeset('OutputFcn', @timeLimitOutputFcn);
    
    % NESTED TRY-CATCH FOR SOLVER FALLBACK CHAIN
    try % ATTEMPT 1: ode15s
        %fprintf('  -> Trying ode15s...');
        solverStartTime = tic; % Reset timer
        [~, solution_y] = ode15s(@(t, Y) M4_SF_S(t, Y, p,county), tspan, y0,timed_options);
        solverUsed = 'ode15s';
        if size(solution_y, 1) < length(tspan)
            % Throw an error to trigger the catch block and try the next solver
            error('Solver:IncompleteSolution', 'ode15s finished but solution was too short.');
        end
        %fprintf(' Succeeded.\n');
    catch ME1
        if strcmp(ME1.identifier, 'Solver:TimeLimitExceeded') || strcmp(ME1.identifier, 'Solver:IncompleteSolution')
            fprintf(' Timed out.\n');
            try % ATTEMPT 2: ode23s
                fprintf('    -> Trying ode23s...');
                solverStartTime = tic; % Reset timer
                [~, solution_y] = ode23s(@(t, Y) M4_SF_S(t, Y, p,county), tspan, y0, timed_options);
                solverUsed = 'ode23s';
                if size(solution_y, 1) < length(tspan)
                error('Solver:IncompleteSolution', 'ode23s finished but solution was too short.');
                end
                fprintf(' Succeeded.\n');
            catch ME2
                if strcmp(ME2.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME2.identifier, 'Solver:IncompleteSolution')
                    fprintf(' Timed out.\n');
                    try % ATTEMPT 3: ode45
                        fprintf('      -> Trying ode45...');
                        solverStartTime = tic; % Reset timer
                        [~, solution_y] = ode45(@(t, Y) M4_SF_S(t, Y, p,county), tspan, y0, timed_options);
                        solverUsed = 'ode45';
                        if size(solution_y, 1) < length(tspan)
                         error('Solver:IncompleteSolution', 'ode45 finished but solution was too short.');
                        end
                        fprintf(' Succeeded.\n');
                    catch ME3
                        if strcmp(ME3.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME3.identifier, 'Solver:IncompleteSolution')
                            fprintf(' Timed out.\n');
                            try % ATTEMPT 4: ode113 (Last resort, no time limit)
                            fprintf('        -> Trying ode23...');
                             solverStartTime = tic; % Reset timer
                            [~, solution_y] = ode23(@(t, Y) M4_SF_S(t, Y, p,county), tspan, y0,timed_options);
                            solverUsed = 'ode23';
                            if size(solution_y, 1) < length(tspan)
                            error('Solver:IncompleteSolution', 'ode23 finished but solution was too short.');
                            end
                            fprintf(' Succeeded.\n');
                            catch ME4
                                if strcmp(ME4.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME4.identifier, 'Solver:IncompleteSolution')
                                    fprintf(' Timed out.\n');
                                    try % ATTEMPT 5: ode15s (Loose, no time limit)
                                    fprintf('          -> FINAL ATTEMPT: ode15s (loose tolerance)...');

                                    loose_options_final= odeset('RelTol', 1e-2, ...
                                                                'AbsTol', 1e-4, ...
                                                                'MaxStep', 1e-3, ...
                                                                'InitialStep', 1e-3,...
                                                                'OutputFcn', @timeLimitOutputFcn);
                                    [~, solution_y] = ode15s(@(t, Y) M4_SF_S(t, Y, p,county), tspan, y0, loose_options_final);
                                    solverUsed = 'ode15s (loose)';
                                        if size(solution_y, 1) < length(tspan)
                                         error('Solver:IncompleteSolution', 'ode15s loose finished but solution was too short.');
                                         end
                                        fprintf(' Succeeded.\n');
                                    catch ME5
                                       %_____
                                        if strcmp(ME5.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME5.identifier, 'Solver:IncompleteSolution')
                                            % This is the final timeout. Do not error.
                                            % Simply log it and let the function proceed.
                                            fprintf(' Timed out. Assigning penalty.\n');
                                            solverUsed = 'None (All timed out)';
                                            solution_y = []; % Ensure solution is empty
                                        else
                                            rethrow(ME5); % A different error from the last step
                                        end
                                    end
                                else
                                    rethrow(ME4); % Unexpected error from ode113
                                end
                            end
                        else
                            rethrow(ME3); % Unexpected error from ode45
                        end
                    end
                else
                    rethrow(ME2); % Unexpected error from ode23s
                end
            end
        else
            rethrow(ME1); % Unexpected error from ode15s
        end
    end

    % If all solvers failed, 'solution_y' will be empty.
    if ~isempty(solution_y)
        [numRowsM,numCols] =size(solution_y);
        if size(solution_y, 1) < length(tspan)
            rss=1e12;
            fprintf(' Problem in solver, did no solve full length.\n');
        else
        ycomp=y_inf_data(1:numRowsM,:);
        residuals = ycomp - solution_y(:,8);
         rss = sum(residuals.^2); 
        end
    else
        rss = 1e12; % Penalty for complete failure
    end
    
%alternate

% % %alternate
% %    % --- State flags for the timeout mechanism ---
% %     timed_out = false; 
% %     start_time_for_ode = []; 
% % 
% %     % --- 1. Define the ODE Problem using the input 'p' ---
% %     odefun = @(t, y) M4_SF_S(t, y, p,county);
% % 
% % 
% %     % --- 2. Solver Chain and Timeout Configuration ---
% %     timeLimit = 15.0; 
% % 
% %     % --- Define multiple sets of options ---
% %     % Standard options
% %     stdOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0));
% %     % Looser options for a second attempt
% %     looseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
% %                           'RelTol', 1e-2, 'AbsTol', 1e-4);
% %     % Very loose options for a final, best-effort attempt
% %     vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
% %                            'RelTol', 1e-1, 'AbsTol', 1e-2);
% % 
% %     % --- Create a single, extended solver chain ---
% %     solverChain = {
% %         % --- Pass 1: Attempting with standard accuracy ---
% %         struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
% %         struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
% %         struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
% %         struct('solver', @ode78,  'name', 'ode45 (standard tol)',  'options', stdOptions),
% % 
% %         % --- Pass 2: Retrying with looser accuracy ---
% %         struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
% %         struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),
% % 
% %         % --- Pass 3: Final attempt with very loose accuracy ---
% %         struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
% %     };
% % 
% %     % --- 3. Execute the Solver Chain ---
% %     t_out = [];
% %     y_out = [];
% %     success = false;
% % 
% %     for i = 1:length(solverChain)
% %         current = solverChain{i};
% %         timed_out = false;
% %         start_time_for_ode = []; 
% % 
% %         try
% %             [t_out, y_out] = current.solver(odefun, tspan, y0, current.options);
% % 
% %             if timed_out
% %                 continue; % Timed out, try next solver
% %             elseif size(y_out,1)<length(tspan)-1
% %                 continue;   % solver can't solve for entire time span, try next solver
% %             else
% %                 success = true; % Solver succeeded.
% %                 break; % Exit the loop.
% %             end
% %         catch ME
% %              % If any error occurs (including tolerance errors), just try the next solver.
% %              if contains(ME.identifier, 'IntegrationTolNotMet')
% %                  % This was a tolerance failure, which is an expected failure mode.
% %                  continue;
% %              else
% %                  % This was a different, unexpected error. Stop processing this particle.
% %                  success = false;
% %                  break;
% %              end
% %         end
% %     end % End of solverChain loop
% % 
% %     % --- 4. Calculate Final Objective Value ---
% %     if success
% %         [numRowsM,numCols] =size(y_out);
% %         if numRowsM<length(tspan)-1
% %         rss=1e12;
% %        else
% %         ycomp=y_inf_data(1:numRowsM,:);
% %         residuals = ycomp - y_out(:,8);
% %         rss = sum(residuals.^2);   
% %         end
% %     else
% %        rss = 1e12;
% % 
% %     end
% % 
% %     % --- NESTED TIMEOUT FUNCTION ---
% %     function status = timeLimitOutputFcn(~, ~, flag)
% %         status = 0;
% %         if strcmp(flag, 'init')
% %             start_time_for_ode = tic;
% %         elseif isempty(flag)
% %             if ~isempty(start_time_for_ode) && toc(start_time_for_ode) > timeLimit
% %                 timed_out = true;
% %                 status = 1;
% %             end
% %         end
% %     end

end







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Objective function Model 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function errorOBJ = objective_functionM5(p, tspan, y0, y_inf_data,county)
t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];
    t_data=t_inf_data;

%WORKING TIMED ODE RUNS
maxTime = 15; % Time limit in seconds for each attempt

    % Initialize outputs
    solution_y = [];
    solverUsed = ['None (All failed)']; %'None (All failed)'

    % The timer will be reset before each solver attempt. A single nested output function can be used by all solvers.
    % It captures 'solverStartTime' and 'maxTime' from the local scope.
    solverStartTime = []; % Will be set before each try
    function status = timeLimitOutputFcn(t, y, flag)
        if isempty(flag)
            if toc(solverStartTime) > maxTime
                    error('Solver:TimeLimitExceeded', 'Solver time limit (%.1fs) exceeded.', maxTime, solverUsed);
            end
        end
        status = 0;
    end

    timed_options = odeset('OutputFcn', @timeLimitOutputFcn);
    
    % NESTED TRY-CATCH FOR SOLVER FALLBACK CHAIN
    try % ATTEMPT 1: ode15s
        %fprintf('  -> Trying ode15s...');
        solverStartTime = tic; % Reset timer
        [~, solution_y] = ode15s(@(t, Y) M5_SF(t, Y, p,county), tspan, y0,timed_options);
        solverUsed = 'ode15s';
        if size(solution_y, 1) < length(tspan)
            % Throw an error to trigger the catch block and try the next solver
            error('Solver:IncompleteSolution', 'ode15s finished but solution was too short.');
        end
        %fprintf(' Succeeded.\n');
    catch ME1
        if strcmp(ME1.identifier, 'Solver:TimeLimitExceeded') || strcmp(ME1.identifier, 'Solver:IncompleteSolution')
            fprintf(' Timed out.\n');
            try % ATTEMPT 2: ode23s
                fprintf('    -> Trying ode23s...');
                solverStartTime = tic; % Reset timer
                [~, solution_y] = ode23s(@(t, Y) M5_SF(t, Y, p,county), tspan, y0, timed_options);
                solverUsed = 'ode23s';
                if size(solution_y, 1) < length(tspan)
                error('Solver:IncompleteSolution', 'ode23s finished but solution was too short.');
                end
                fprintf(' Succeeded.\n');
            catch ME2
                if strcmp(ME2.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME2.identifier, 'Solver:IncompleteSolution')
                    fprintf(' Timed out.\n');
                    try % ATTEMPT 3: ode45
                        fprintf('      -> Trying ode45...');
                        solverStartTime = tic; % Reset timer
                        [~, solution_y] = ode45(@(t, Y) M5_SF(t, Y, p,county), tspan, y0, timed_options);
                        solverUsed = 'ode45';
                        if size(solution_y, 1) < length(tspan)
                         error('Solver:IncompleteSolution', 'ode45 finished but solution was too short.');
                        end
                        fprintf(' Succeeded.\n');
                    catch ME3
                        if strcmp(ME3.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME3.identifier, 'Solver:IncompleteSolution')
                            fprintf(' Timed out.\n');
                            try % ATTEMPT 4: ode113 (Last resort, no time limit)
                            fprintf('        -> Trying ode23...');
                             solverStartTime = tic; % Reset timer
                            [~, solution_y] = ode23(@(t, Y) M5_SF(t, Y, p,county), tspan, y0,timed_options);
                            solverUsed = 'ode23';
                            if size(solution_y, 1) < length(tspan)
                            error('Solver:IncompleteSolution', 'ode23 finished but solution was too short.');
                            end
                            fprintf(' Succeeded.\n');
                            catch ME4
                                if strcmp(ME4.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME4.identifier, 'Solver:IncompleteSolution')
                                    fprintf(' Timed out.\n');
                                    try % ATTEMPT 5: ode15s (Loose, no time limit)
                                    fprintf('          -> FINAL ATTEMPT: ode15s (loose tolerance)...');

                                    loose_options_final= odeset('RelTol', 1e-2, ...
                                                                'AbsTol', 1e-4, ...
                                                                'MaxStep', 1e-3, ...
                                                                'InitialStep', 1e-3,...
                                                                'OutputFcn', @timeLimitOutputFcn);
                                    [~, solution_y] = ode15s(@(t, Y) M5_SF(t, Y, p,county), tspan, y0, loose_options_final);
                                    solverUsed = 'ode15s (loose)';
                                        if size(solution_y, 1) < length(tspan)
                                         error('Solver:IncompleteSolution', 'ode15s loose finished but solution was too short.');
                                         end
                                        fprintf(' Succeeded.\n');
                                    catch ME5
                                       %_____
                                        if strcmp(ME5.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME5.identifier, 'Solver:IncompleteSolution')
                                            % This is the final timeout. Do not error.
                                            % Simply log it and let the function proceed.
                                            fprintf(' Timed out. Assigning penalty.\n');
                                            solverUsed = 'None (All timed out)';
                                            solution_y = []; % Ensure solution is empty
                                        else
                                            rethrow(ME5); % A different error from the last step
                                        end
                                    end
                                else
                                    rethrow(ME4); % Unexpected error from ode113
                                end
                            end
                        else
                            rethrow(ME3); % Unexpected error from ode45
                        end
                    end
                else
                    rethrow(ME2); % Unexpected error from ode23s
                end
            end
        else
            rethrow(ME1); % Unexpected error from ode15s
        end
    end

    % If all solvers failed, 'solution_y' will be empty.
    if ~isempty(solution_y)
        [numRowsM,numCols] =size(solution_y);
        if size(solution_y, 1) < length(tspan)
            errorOBJ=1e10;
            fprintf(' Problem in solver, did no solve full length.\n');
        else
        ycomp=y_inf_data(1:numRowsM,:);
        errorOBJ = max((rmse(solution_y(:,9),  ycomp)/sqrt(sumsqr( ycomp'))));
        end
    else
        errorOBJ = 1e10; % Penalty for complete failure
    end

% %NO ERROR THROWN METHOD
%     % __________Flags for the timeout mechanism __________
%     timed_out = false; 
%     start_time_for_ode = []; 
% 
%     % __________ODE Problem __________
%     odefun = @(t, y) M5_SF(t, y, p,county);
% 
% 
%     % Solver Chain and Timeout Config.
%     timeLimit = 15; 
% 
%     % __________Define options__________
%     % Standard options
%     stdOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0));
%     % Looser options for a second attempt
%     looseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
%                           'RelTol', 1e-2, 'AbsTol', 1e-4);
%     % Very loose options for a final, best-effort attempt
%     vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
%                            'RelTol', 1e-1, 'AbsTol', 1e-2);
% 
%     % __________Create a single, extended solver chain__________
%     solverChain = {
%         % __________Pass 1: standard accuracy __________
%         struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
%         struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
%         struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
%         struct('solver', @ode78,  'name', 'ode78 (standard tol)',  'options', stdOptions),
% 
%         % --- Pass 2: looser accuracy __________
%         struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
%         struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),
% 
%         % __________Pass 3: Very loose accuracy__________
%         struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
%     };
% 
%     % __________Execute Chain__________
%     t_out = [];
%     y_out = [];
%     success = false;
% 
%     for i = 1:length(solverChain)
%         current = solverChain{i};
%         timed_out = false;
%         start_time_for_ode = []; 
% 
%         try
%             [t_out, y_out] = current.solver(odefun, tspan, y0, current.options);
% 
%             if timed_out
%                continue; % Timed out, try next solver
%             elseif size(y_out,1)<length(tspan)-1
%               continue;   % solver can't solve for entire time span, try next solver
%             else
%                 success = true; % Solver succeeded.
%                 break; % Exit the loop.
%             end
%         catch ME
%              % If any error occurs (including tolerance errors), just try the next solver.
%              if contains(ME.identifier, 'IntegrationTolNotMet')
%                  % This was a tolerance failure, which is an expected failure mode.
%                  continue;
%              else
%                  % This was a different, unexpected error. Stop processing this particle.
%                  success = false;
%                  break;
%              end
%         end
%     end % End of solverChain loop
% 
%     % __________Calculate Error __________
%     if success
%         [numRowsM,numCols] =size(y_out);
%         if numRowsM<length(tspan)-1
%          errorOBJ=1e10;
%         else
%         ycomp=y_inf_data(1:numRowsM,:);
%         errorOBJ = max((rmse(y_out(:,9),  ycomp)/sqrt(sumsqr( ycomp'))));
%         end
%     else
%        errorOBJ = 1e10; 
%     end
% 
%     % __________NESTED TIMEOUT FUNCTION__________ (works better w/ nested)
%     function status = timeLimitOutputFcn(~, ~, flag)
%         status = 0;
%         if strcmp(flag, 'init')
%             start_time_for_ode = tic;
%         elseif isempty(flag)
%             if ~isempty(start_time_for_ode) && toc(start_time_for_ode) > timeLimit
%                 timed_out = true;
%                 status = 1;
%             end
%         end
%     end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RSS Objective function Model 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rss = objective_functionM5_RSS(p, tspan, y0, y_inf_data,county)
%WORKING TIMED ODE RUNS
maxTime = 15; % Time limit in seconds for each attempt

    % Initialize outputs
    solution_y = [];
   solverUsed = ['None (All failed)']; %'None (All failed)'

    % The timer will be reset before each solver attempt. A single nested output function can be used by all solvers.
    % It captures 'solverStartTime' and 'maxTime' from the local scope.
    solverStartTime = []; % Will be set before each try
    function status = timeLimitOutputFcn(t, y, flag)
        if isempty(flag)
            if toc(solverStartTime) > maxTime
                    error('Solver:TimeLimitExceeded', 'Solver time limit (%.1fs) exceeded.', maxTime, solverUsed);
            end
        end
        status = 0;
    end

    timed_options = odeset('OutputFcn', @timeLimitOutputFcn);

    lastcall=0;
    % NESTED TRY-CATCH FOR SOLVER FALLBACK CHAIN
   try % ATTEMPT 1: ode15s
        %fprintf('  -> Trying ode15s...');
        solverStartTime = tic; % Reset timer
        [~, solution_y] = ode15s(@(t, Y) M5_SF(t, Y, p,county), tspan, y0,timed_options);
        solverUsed = 'ode15s';
        if size(solution_y, 1) < length(tspan)
            % Throw an error to trigger the catch block and try the next solver
            error('Solver:IncompleteSolution', 'ode15s finished but solution was too short.');
        end
        %fprintf(' Succeeded.\n');
    catch ME1
        if strcmp(ME1.identifier, 'Solver:TimeLimitExceeded') || strcmp(ME1.identifier, 'Solver:IncompleteSolution')
            fprintf(' Timed out.\n');
            try % ATTEMPT 2: ode23s
                fprintf('    -> Trying ode23s...');
                solverStartTime = tic; % Reset timer
                [~, solution_y] = ode23s(@(t, Y) M5_SF(t, Y, p,county), tspan, y0, timed_options);
                solverUsed = 'ode23s';
                if size(solution_y, 1) < length(tspan)
                error('Solver:IncompleteSolution', 'ode23s finished but solution was too short.');
                end
                fprintf(' Succeeded.\n');
            catch ME2
                if strcmp(ME2.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME2.identifier, 'Solver:IncompleteSolution')
                    fprintf(' Timed out.\n');
                    try % ATTEMPT 3: ode45
                        fprintf('      -> Trying ode45...');
                        solverStartTime = tic; % Reset timer
                        [~, solution_y] = ode45(@(t, Y) M5_SF(t, Y, p,county), tspan, y0, timed_options);
                        solverUsed = 'ode45';
                        if size(solution_y, 1) < length(tspan)
                         error('Solver:IncompleteSolution', 'ode45 finished but solution was too short.');
                        end
                        fprintf(' Succeeded.\n');
                    catch ME3
                        if strcmp(ME3.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME3.identifier, 'Solver:IncompleteSolution')
                            fprintf(' Timed out.\n');
                            try % ATTEMPT 4: ode113 (Last resort, no time limit)
                            fprintf('        -> Trying ode23...');
                             solverStartTime = tic; % Reset timer
                            [~, solution_y] = ode23(@(t, Y) M5_SF(t, Y, p,county), tspan, y0,timed_options);
                            solverUsed = 'ode23';
                            if size(solution_y, 1) < length(tspan)
                            error('Solver:IncompleteSolution', 'ode23 finished but solution was too short.');
                            end
                            fprintf(' Succeeded.\n');
                            catch ME4
                                if strcmp(ME4.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME4.identifier, 'Solver:IncompleteSolution')
                                    fprintf(' Timed out.\n');
                                    try % ATTEMPT 5: ode15s (Loose, no time limit)
                                    fprintf('          -> FINAL ATTEMPT: ode15s (loose tolerance)...');

                                    loose_options_final= odeset('RelTol', 1e-2, ...
                                                                'AbsTol', 1e-4, ...
                                                                'MaxStep', 1e-3, ...
                                                                'InitialStep', 1e-3,...
                                                                'OutputFcn', @timeLimitOutputFcn);
                                    [~, solution_y] = ode15s(@(t, Y) M5_SF(t, Y, p,county), tspan, y0, loose_options_final);
                                    solverUsed = 'ode15s (loose)';
                                        if size(solution_y, 1) < length(tspan)
                                         error('Solver:IncompleteSolution', 'ode15s loose finished but solution was too short.');
                                         end
                                        fprintf(' Succeeded.\n');
                                    catch ME5
                                       %_____
                                        if strcmp(ME5.identifier, 'Solver:TimeLimitExceeded')|| strcmp(ME5.identifier, 'Solver:IncompleteSolution')
                                            % This is the final timeout. Do not error.
                                            % Simply log it and let the function proceed.
                                            fprintf(' Timed out. Assigning penalty.\n');
                                            solverUsed = 'None (All timed out)';
                                            solution_y = []; % Ensure solution is empty
                                        else
                                            rethrow(ME5); % A different error from the last step
                                        end
                                    end
                                else
                                    rethrow(ME4); % Unexpected error from ode113
                                end
                            end
                        else
                            rethrow(ME3); % Unexpected error from ode45
                        end
                    end
                else
                    rethrow(ME2); % Unexpected error from ode23s
                end
            end
        else
            rethrow(ME1); % Unexpected error from ode15s
        end
    end

    % If all solvers failed, 'solution_y' will be empty.
    if ~isempty(solution_y)
        [numRowsM,numCols] =size(solution_y);
        if size(solution_y, 1) < length(tspan)
            rss=1e12;
            fprintf(' Problem in solver, did no solve full length.\n');
        else
        ycomp=y_inf_data(1:numRowsM,:);
        residuals = ycomp - solution_y(:,9);
        rss = sum(residuals.^2);      
        end
    else
        rss = 1e12; % Penalty for complete failure
    end   
%%%Alternate

% % % __________Flags for the timeout mechanism __________
% %     timed_out = false; 
% %     start_time_for_ode = []; 
% % 
% %     % __________ODE Problem __________
% %     odefun = @(t, y) M5_SF(t, y, p,county);
% % 
% % 
% %     % Solver Chain and Timeout Config.
% %     timeLimit = 15; 
% % 
% %     % __________Define options__________
% %     % Standard options
% %     stdOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0));
% %     % Looser options for a second attempt
% %     looseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
% %                           'RelTol', 1e-2, 'AbsTol', 1e-4);
% %     % Very loose options for a final, best-effort attempt
% %     vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcn, 'NonNegative', 1:length(y0), ...
% %                            'RelTol', 1e-1, 'AbsTol', 1e-2);
% % 
% %     % __________Create a single, extended solver chain__________
% %     solverChain = {
% %         % __________Pass 1: standard accuracy __________
% %         struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
% %         struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
% %         struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
% %         struct('solver', @ode78,  'name', 'ode78 (standard tol)',  'options', stdOptions),
% % 
% %         % --- Pass 2: looser accuracy __________
% %         struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
% %         struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),
% % 
% %         % __________Pass 3: Very loose accuracy__________
% %         struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
% %     };
% % 
% %     % __________Execute Chain__________
% %     t_out = [];
% %     y_out = [];
% %     success = false;
% % 
% %     for i = 1:length(solverChain)
% %         current = solverChain{i};
% %         timed_out = false;
% %         start_time_for_ode = []; 
% % 
% %         try
% %             [t_out, y_out] = current.solver(odefun, tspan, y0, current.options);
% % 
% %             if timed_out
% %            continue; % Timed out, try next solver
% %         elseif size(y_out,1)<length(tspan)-1
% %             continue;   % solver can't solve for entire time span, try next solver
 % %         else
% %                 success = true; % Solver succeeded.
% %                 break; % Exit the loop.
% %             end
% %         catch ME
% %              % If any error occurs (including tolerance errors), just try the next solver.
% %              if contains(ME.identifier, 'IntegrationTolNotMet')
% %                  % This was a tolerance failure, which is an expected failure mode.
% %                  continue;
% %              else
% %                  % This was a different, unexpected error. Stop processing this particle.
% %                  success = false;
% %                  break;
% %              end
% %         end
% %     end % End of solverChain loop
% % 
% %     % __________Calculate Error __________
% %     if success
% %         [numRowsM,numCols] =size(y_out);
% %         if numRowsM<length(tspan)-1
% %         rss=1e12;
% %        else
% %         ycomp=y_inf_data(1:numRowsM,:);
% %         residuals = ycomp - y_out(:,9);
% %         rss = sum(residuals.^2);      
% %         end
% %     else
% %        rss = 1e12; 
% %     end
% % 
% %     % __________NESTED TIMEOUT FUNCTION__________ (works better w/ nested)
% %     function status = timeLimitOutputFcn(~, ~, flag)
% %         status = 0;
% %         if strcmp(flag, 'init')
% %             start_time_for_ode = tic;
% %         elseif isempty(flag)
% %             if ~isempty(start_time_for_ode) && toc(start_time_for_ode) > timeLimit
% %                 timed_out = true;
% %                 status = 1;
% %             end
% %         end
% %     end

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL 0 Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dpop_fit = pop_fit(t,a,params)
N=a(1);
alpha_h=params(1);  omega=params(2); %N_max=params(3);

%dN=alpha_h*N*(1-N/N_max)-omega*N;
dN=(alpha_h+omega)*N-omega*N;

dpop_fit=[dN];
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL 1 Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Model 1 function  
function dM1_SF_T = M1_SF_T(t,a,params)
D = a(1); H = a(2); S=a(3); I=a(4); R=a(5); 

O=params(1);  mu_H=params(2);
gamma_H=params(3); H_max=params(4); delta_H=params(5);
alpha_h=params(6);      delta_R=params(7);
epsilon=params(8);     omega=params(9);        rho=params(10);
kappa=params(11);   delta_D=params(12);

%dD=O-mu_H*D*H;
dD=O-mu_H*D*H-delta_D*D;
dH=gamma_H*D*H*(1-(H/H_max))-delta_H*H;

dS=alpha_h*(S+I+R)+delta_R*R-epsilon*S*H-omega*S;
dI=epsilon*S*H-rho*I-kappa*I-omega*I;
dR=rho*I-delta_R*R-omega*R;


dM1_SF_T=[dD;dH;dS;dI;dR];
end









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL 2 Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dM2_SF = M2_SF(t,a,params)
O = a(1); D = a(2); H = a(3); A = a(4); %C = a(5); 
S = a(5); E = a(6);I = a(7); R = a(8);

PI=params(1);           delta_O=params(2);      mu_H=params(3);
gamma_H=params(4);      H_max=params(5);        delta_H=params(6);
gamma_A=params(7);      delta_A=params(8);      phi_A=params(9);
alpha_h=params(10);    
epsilon=params(11);     omega=params(12);       rho=params(13);
kappa=params(14);       psi=params(15);     delta_D=params(16);

dO=PI-delta_O*O;
dD=delta_O*O-mu_H*D*H-delta_D*D;
dH=(phi_A*A+gamma_H*D*H)*(1-(H/H_max))-delta_H*H;
dA=gamma_A*H-phi_A*A-delta_A*A;

dS=alpha_h*(S+I+R)-epsilon*S*A-omega*S;
dE=epsilon*S*A-psi*E-omega*E;
dI=psi*E-rho*I-kappa*I-omega*I;
dR=rho*I-omega*R;

dM2_SF=[dO;dD;dH;dA;dS;dE;dI;dR];
end









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL 3 Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Model 3 function
function dM3_SF = M3_SF(t,a,params,county)
O = a(1); D = a(2); H = a(3); A = a(4); 
S = a(5); E = a(6); I = a(7); R = a(8);

PI=params(1);         delta_O=params(2); mu_H=params(3);
gamma_H=params(4);    H_max=params(5); delta_H=params(6);
gamma_A=params(7);    delta_A=params(8); phi_A=params(9);
T_opt_H=params(10); T_opt_A=params(11);
S_opt_H=params(12);   S_opt_A=params(13); T_decay=params(14);
bl_Topt_A=params(15); ab_Topt_A=params(16); bl_Topt_H=params(17); 
ab_Topt_H=params(18); bl_Sopt_A=params(19); ab_Sopt_A=params(20); 
bl_Sopt_H=params(21); ab_Sopt_H=params(22);  alpha_h=params(23);      
epsilon=params(24);   omega=params(25);        
rho=params(26);       kappa=params(27);         psi=params(28);
delta_D=params(29);    

%TF=40*sin(((2*pi)/365)*t)+70; %Mimics temperature annual temps of a simulated location with variation of 20-120
%S_m=49*sin(((2*pi)/365)*t-(pi/8))+50; %Mimics soil moisture of a simulated location with variation of 0-100
t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];


temp_data_Maricopa=[50;52.9;65;69.8;78.2;88.5;91.4;89.6;83.2;69.2;62.1;52.3;...
    56.5;59.8;64.5;69.8;77.9;87.2;91.3;86.4;84.4;74.7;61.8;53.9;55.1;61.5;...
    67.2;68.8;73;88.1;89.4;92.3;85.6;74.7;58;50.7;51.7;61.8;65.6;69.2;74.7;...
    90.2;93.2;88.8;82.4;76.6;63.6;54.8;52;58.5;66.8;70.7;76.9;89.4;91.8;...
    90.4;82.8;76.2;67.4;56.9;58.4;56.2;62.6;73;78.1;87.1;91.9;90.3;87.4;...
    69.6;59.7;52.5;52.8;50.2;61.4;70.3;71.1;85.6;92.4;92.6;84.2;71;62.2;...
    52.5;53.5;55.7;60.3;69;81.2;86.7;94;94.7;87;76.6;63.9;52.9;53.2;57;59.9;...
    71.6;77.4;89.9;90.2;88.8;84.7;69.9;66.2;55.2;53.7;55;62.5;70.7;78;89;92;...
    89;86;72.4;55.5;51.5;50;52.6;56.8;68.7;76.5;81.7;96;92;84.2;74.9;63.2;55.6];

temp_data_Pima=[48.0; 49.5; 62.7; 66.7; 74.4; 85.6; 85.3; 83.9; 79.8; 67.1; 60.2;...
    50.8; 55.5; 58.1; 61.7; 66.6; 74.2; 85.2; 85.9; 82.1; 80.4; 72.2; 60.0; 52.1;...
    53.4; 59.7; 63.5; 65.6; 69.5; 84.6; 84.2; 86.9; 81.0; 71.9; 57.0; 49.5; 50.3;...
    59.6; 62.7; 65.9; 71.1; 86.1; 88.2; 83.4; 77.9; 74.2; 61.1; 53.7; 50.3; 57.1;...
    65.1; 68.3; 73.1; 85.9; 86.0; 84.8; 78.9; 74.7; 66.3; 55.1; 56.9; 55.0; 60.5;...
    70.6; 74.7; 84.1; 86.7; 85.1; 83.1; 67.4; 57.6; 51.1; 51.7; 48.6; 59.0; 67.0;...
    67.5; 81.4; 87.6; 87.2; 79.9; 68.7; 61.2; 51.6; 52.2; 52.8; 58.0; 66.1; 77.3;...
    83.2; 88.6; 89.6; 82.8; 73.9; 62.7; 50.9; 51.5; 54.8; 57.2; 68.5; 74.4; 86.6;...
    84.7; 83.9; 80.7; 68.0; 64.2; 54.2; 52.0; 52.0; 59.5; 67.8; 75.2; 84.9; 86.7;...
    83.3; 81.5; 68.9; 54.1; 50.5; 49.0; 50.3; 55.5; 65.9; 73.1; 79.1; 91.1; 87.3;...
    82.0; 73.1; 61.8; 54.0];

temp_data_Pinal=[48.2; 50.5; 62.6; 67.6; 76.5; 87.3; 88.2; 86.7; 81.4; 68.4; 60.7;...
    50.5; 54.4; 58.4; 62.5; 68.3; 76.3; 86.8; 88.6; 84.3; 81.9; 73.2; 60.2; 52.2;...
    52.8; 59.5; 64.6; 66.6; 71.6; 86.9; 87.0; 88.9; 82.0; 72.5; 56.4; 48.7; 50.1;...
    59.3; 63.4; 67.1; 73.6; 88.0; 90.1; 85.2; 80.3; 75.4; 62.1; 53.5; 50.8; 57.3;...
    65.0; 68.2; 74.9; 87.8; 88.0; 86.4; 81.1; 75.0; 66.2; 54.9; 56.4; 55.6; 61.1;...
    71.5; 76.9; 85.8; 89.0; 87.0; 84.3; 68.7; 58.0; 51.0; 50.9; 49.3; 59.3; 68.4;...
    69.7; 84.3; 90.3; 89.7; 82.5; 70.3; 61.3; 51.2; 51.5; 53.4; 58.8; 67.6; 79.4;...
    85.3; 91.1; 92.0; 84.6; 75.0; 62.6; 51.0; 52.0; 55.8; 58.2; 69.8; 76.5; 88.4;...
    86.7; 85.7; 82.2; 69.2; 64.7; 54.8; 51.9; 52.3; 59.9; 68.9; 76.8; 87.3; 89.4;...
    85.8; 84.0; 70.7; 55.0; 50.4; 48.8; 51.1; 55.8; 67.0; 75.4; 81.2; 93.7; 90.0;...
    82.8; 74.4; 62.3; 53.9];

temp_data_AZ=[38.6; 42.2; 54.8; 59.4; 67.4; 79.5; 81.0; 78.5; 72.4; 58.8; 51.3;...
41.5; 46.5; 50.0; 53.9; 59.1; 66.8; 77.7; 81.4; 76.5; 74.2; 64.9; 51.7; 44.3; 45.1;...
52.0; 56.3; 58.4; 62.9; 78.4; 78.6; 80.6; 75.0; 64.5; 48.3; 40.9; 41.8; 50.6; 54.9;...
58.5; 64.6; 80.3; 82.4; 77.5; 71.6; 66.1; 53.1; 44.7; 42.3; 49.4; 56.6; 59.9; 66.1;...
79.8; 81.5; 79.1; 72.4; 65.1; 57.6; 46.6; 47.6; 46.7; 52.3; 62.9; 68.5; 78.6; 82.3;...
80.2; 76.0; 59.9; 49.4; 42.8; 42.4; 40.9; 51.7; 60.3; 60.7; 75.2; 81.9; 81.9; 73.8;...
60.0; 52.1; 42.2; 43.7; 45.9; 51.0; 59.3; 70.5; 76.8; 82.8; 84.1; 75.6; 66.2; 53.5;...
42.0; 42.6; 46.5; 49.4; 61.2; 67.9; 80.6; 81.4; 79.5; 74.8; 59.9; 55.8; 45.6; 43.5;...
44.0; 51.8; 60.5; 68.6; 78.6; 82.2; 79.0; 75.9; 61.8; 46.1; 42.8; 40.3; 41.9; 47.2;...
58.4; 66.5; 72.4; 85.4; 80.7; 73.6; 64.4; 52.6; 45.4];


%palmer z-index
soil_mstr_data_Maricopa=[11.19;9.57;9.05;8.3;8.4;8.6;10.31;9.64;10.95;8.72;...
    13.29;8.92;7.68;7.11;8.73;7.78;7.86;8.47;10.07;13.74;15.11;9.01;8.2;...
    10.15;10.2;7.97;8.1;8.49;10.23;9.47;8.95;7.89;9.81;11.29;9.41;8.75;10.84;...
    7.72;6.72;8.7;8.68;8.92;7.67;10.57;8.92;8.19;9.67;10.84;11;11.25;8.09;...
    8.62;9.25;8.84;12.26;8.76;8.04;7.75;7.43;7.89;7.82;8.77;7.47;7.25;7.91;...
    8.98;13.33;10.48;8.17;16.69;9.11;8.62;9.84;13.51;10.12;9.43;10.42;9.92;...
    8.32;7.2;13.61;8.33;14.64;10.86;8.77;10.93;13.42;11.24;11.26;8.67;7.06;...
    7.09;7.46;7.71;8.02;8.8;9.8;7.94;8.14;7.53;7.91;8.81;15.97;12.66;9.59;...
    9.52;7.61;11.6;8.49;8.95;7.88;7.87;8.12;9.31;10.8;12.56;9.97;10.21;9.47;...
    11.1;11.67;10.64;11.91;11.03;11.01;9.89;7.22;7.43;9.54;7.93;8.66;9.77];

soil_mstr_data_Pima=[9.94;10.4;8.27;8.04;8.16;8.23;10.48;10.21;10.37;8.27;13.32;...
9.16;7.62;7.18;8.27;8.11;8.05;7.98;10.59;11.6;12.03;10.55;8.23;10.35;12.34;8.45;...
8.32;9.19;10.13;11.13;9.25;8.08;12.24;11.52;9.11;9.08;10.78;7.84;6.91;9.45;8.42;...
9.86;8.24;9.57;10.93;7.81;8.95;10.14;10.71;9.14;6.89;7.94;8.67;8.17;12.31;7.77;7.77;...
7.36;7.42;8.26;7.21;10.82;8;7.34;8.03;10.14;11.34;9.7;9.35;14.9;8.92;9.8;10.23;13.59;...
10.56;10.04;10.95;10.3;7.42;8.54;13.23;8.06;14.66;11.59;9.49;10.36;11.7;10.99;10.51;...
9.04;6.36;6.36;6.86;7.46;8.05;8.45;10.66;8.26;8.38;7.95;8.03;8.88;18.62;12.45;9.39;8.38;...
7.63;9.82;8.41;8.51;7.73;7.73;7.96;10.1;10.83;12.76;10.19;10.15;8.83;10.62;11.38;10.98;...
10.49;9.88;10.42;9.39;6.58;8.2;8.69;7.92;8.52;10.4];

soil_mstr_data_Pinal= [10.82; 9.64; 9.20; 8.65; 8.65; 8.40; 11.98; 8.05; 9.70;...
8.48; 12.07; 8.79; 7.53; 6.86; 8.95; 7.40; 7.51; 7.88; 8.81; 10.79; 14.72; 10.25;...
7.99; 10.15; 11.68; 8.12; 7.78; 9.04; 10.83; 10.48; 9.33; 9.75; 13.02; 11.84; 9.73;...
8.65; 10.84; 7.70; 6.75; 8.86; 8.33; 9.53; 7.85; 9.88; 9.85; 8.00; 9.60; 10.02; 10.87;...
8.92; 7.26; 7.86; 8.61; 8.31; 13.30; 9.20; 7.85; 7.50; 7.19; 7.94; 7.67; 9.63; 7.46; 6.74;...
7.52; 9.43; 11.60; 9.57; 10.68; 14.41; 9.01; 9.05; 9.83; 14.28; 9.55; 9.82; 10.37; 10.31;...
8.35; 6.86; 11.60; 8.08; 14.76; 11.76; 9.24; 10.30; 11.11; 10.56; 11.07; 8.67; 6.74; 6.69;...
7.18; 7.55; 8.15; 8.50; 9.84; 7.74; 8.15; 7.18; 7.49; 8.05; 18.35; 10.85; 11.11; 8.74; 7.43;...
10.29; 9.01; 8.97; 8.48; 7.22; 7.47; 9.72; 9.13; 12.40; 9.67; 10.03; 9.01; 12.06; 11.71; 10.98;...
10.68; 10.67; 11.82; 10.26; 6.83; 7.90; 9.35; 7.75; 8.99; 10.00];

soil_mstr_data_AZ=[10.62;9.22;8.26;7.91;8.25;7.71;11.94;10.43;11.66;8.52;12.04;...
8.76;7.16;6.9;8.03;7.26;7.22;6.88;9.67;12.5;12.95;8.7;7.98;10.2;10.95;8.23;8.67;8.47;...
10.74;10.34;10.35;9.59;10.03;11.91;9.92;8.87;10.34;7.49;6.66;8.81;8.83;8.16;8.32;11.03;...
10.42;7.91;9.67;11.41;12;10.17;7.85;8.52;10.04;8.96;12.46;8.01;8.45;7.26;6.84;7.38;7.64;...
9.06;7.82;5.99;7.16;7.63;11.46;9.36;8.46;14.53;8.8;8.9;10.48;13.67;10.25;9.89;11.96;...
10.88;7.47;6.54;10.97;7.91;14.44;11.23;8.92;10.21;12.52;10.47;11.24;9.56;6.77;5.54;6.75;...
7.38;8.08;8.18;9.89;7.85;8.99;7.1;7;7.21;14.84;9.74;9.84;9.69;7.21;10.62;8.14;8.52;8.52;...
6.77;6.97;8.74;10.66;12.3;10.1;10.64;9.4;10.35;12.34;10.55;12.46;9.84;11.96;10.83;6.61;...
8.88;9.72;7.75;8.67;9.03];

if county==1
temp_data=temp_data_AZ;
soil_mstr_data=soil_mstr_data_AZ;
elseif county==2
temp_data=temp_data_Maricopa;
soil_mstr_data=soil_mstr_data_Maricopa;
elseif county==3
temp_data=temp_data_Pima;
soil_mstr_data=soil_mstr_data_Pima;
elseif county==4
temp_data=temp_data_Pinal;
soil_mstr_data=soil_mstr_data_Pinal;
else
    error('No region selected or invaled input');
end

tind = [15.5;45;74.5;105;135.5;166;196.5;227.5;258;288.5;319;349.5;380.5;410;...
    439.5;470;500.5;531;561.5;592.5;623;653.5;684;714.5;745.5;775;804.5;835;...
    865.5;896;926.5;957.5;988;1018.5;1049;1079.5;1110.5;1140.5;1170.5;1201;...
    1231.5;1262;1292.5;1323.5;1354;1384.5;1415;1445.5;1476.5;1506;1535.5;1566;...
    1596.5;1627;1657.5;1688.5;1719;1749.5;1780;1810.5;1841.5;1871;1900.5;1931;...
    1961.5;1992;2022.5;2053.5;2084;2114.5;2145;2175.5;2206.5;2236;2265.5;2296;...
    2326.5;2357;2387.5;2418.5;2449;2479.5;2510;2540.5;2571.5;2601.5;2631.5;2662;...
    2692.5;2723;2753.5;2784.5;2815;2845.5;2876;2906.5;2937.5;2967;2996.5;3027;...
    3057.5;3088;3118.5;3149.5;3180;3210.5;3241;3271.5;3302.5;3332;3361.5;3392;...
    3422.5;3453;3483.5;3514.5;3545;3575.5;3606;3636.5;3667.5;3697;3726.5;3757;...
    3787.5;3818;3848.5;3879.5;3910; 3940.5; 3971; 4001.5];

TFSpchip=pchip(tind,temp_data);
%TFSpline=spline(tind,temp_data);
TF=ppval(TFSpchip, t);

S_mpchip=pchip(tind,soil_mstr_data);
%S_mSpline=spline(tind,soil_mstr_data);
S_m=ppval(S_mpchip, t);

%TF
if TF<T_opt_A || TF==T_opt_A
F_A_T=exp(-((TF-T_opt_A)^2/bl_Topt_A));
else
F_A_T=exp(-((TF-T_opt_A)^2/ab_Topt_A));
end

if TF<T_opt_H || TF==T_opt_H
F_H_T=exp(-((TF-T_opt_H)^2/bl_Topt_H));
else
F_H_T=exp(-((TF-T_opt_H)^2/ab_Topt_H));
end

if S_m<S_opt_A || S_m==S_opt_A
F_A_S_m=exp(-((S_m-S_opt_A)^2/bl_Sopt_A));
else
F_A_S_m=exp(-((S_m-S_opt_A)^2/ab_Sopt_A));
end

if S_m<S_opt_H || S_m==S_opt_H
F_H_S_m=exp(-((S_m-S_opt_H)^2/bl_Sopt_H));
else
F_H_S_m=exp(-((S_m-S_opt_H)^2/ab_Sopt_H));
end

dO=PI-(TF/T_decay)*delta_O*O;
dD=(TF/T_decay)*delta_O*O-(mu_H*H*D)-delta_D*D;
dH=(phi_A*A+gamma_H*D*H*(F_H_T*F_H_S_m))*(1-(H/H_max))-delta_H*H;
dA=gamma_A*H*(F_A_T*F_A_S_m)-phi_A*A-delta_A*A;

dS=alpha_h*(S+E+I+R)-epsilon*S*A-omega*S;
dE=epsilon*S*A-psi*E-omega*E;
dI=psi*E-rho*I-kappa*I-omega*I;
dR=rho*I-omega*R;


dM3_SF=[dO;dD;dH;dA;dS;dE;dI;dR];
end












% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %MODEL 4 Function
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% %Option 4.2
% function dM4_SF = M4_SF(t,a,params)
% V_j=a(1); V_a=a(2); O = a(3); D = a(4); H = a(5); A = a(6); C = a(7); 
% S= a(8); E= a(9); I= a(10); R= a(11);
% 
% PI=params(1);           delta_O=params(2);      mu_H=params(3);
% gamma_H=params(4);      H_max=params(5);        delta_H=params(6);
% gamma_A=params(7);      delta_A=params(8);      phi_A=params(9);
% delta_C=params(10);     T_opt_H=params(11);     T_opt_A=params(12);
% S_opt_H=params(13);     S_opt_A=params(14);     T_decay=params(15);
% bl_Topt_A=params(16);   ab_Topt_A=params(17);   bl_Topt_H=params(18); 
% ab_Topt_H=params(19);   bl_Sopt_A=params(20);   ab_Sopt_A=params(21); 
% bl_Sopt_H=params(22);   ab_Sopt_H=params(23);   T_hs=params(24);
% beta=params(25);        mu_V=params(26);        delta_V_j=params(27);
% delta_V_a=params(28);   sigma=params(29);       T_cs=params(30); 
% alpha=params(31);       S_d_s=params(32);       T_d_s=params(33); 
% xtr_c_s=params(34);
% alpha_h=params(35);      delta_R=params(36);  epsilon=params(37);     
% omega=params(38);        rho=params(39);     kappa=params(40);
% psi=params(41);
% %bl_S_H_s=params(34);    ab_T_H_s=params(35);
% 
% % TF=40*sin(((2*pi)/365)*t)+70; %Mimics temperature annual temps of a simulated location with variation of 20-120
% % S_m=49*sin(((2*pi)/365)*t-(pi/8))+50; %Mimics soil moisture of a simulated location with variation of 0-100
% t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
%     516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
%     1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
%     1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
%     1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
%     2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
%     2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
%     3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
%     3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];
% 
% temp_data_Maricopa=[50;52.9;65;69.8;78.2;88.5;91.4;89.6;83.2;69.2;62.1;52.3;...
%     56.5;59.8;64.5;69.8;77.9;87.2;91.3;86.4;84.4;74.7;61.8;53.9;55.1;61.5;...
%     67.2;68.8;73;88.1;89.4;92.3;85.6;74.7;58;50.7;51.7;61.8;65.6;69.2;74.7;...
%     90.2;93.2;88.8;82.4;76.6;63.6;54.8;52;58.5;66.8;70.7;76.9;89.4;91.8;...
%     90.4;82.8;76.2;67.4;56.9;58.4;56.2;62.6;73;78.1;87.1;91.9;90.3;87.4;...
%     69.6;59.7;52.5;52.8;50.2;61.4;70.3;71.1;85.6;92.4;92.6;84.2;71;62.2;...
%     52.5;53.5;55.7;60.3;69;81.2;86.7;94;94.7;87;76.6;63.9;52.9;53.2;57;59.9;...
%     71.6;77.4;89.9;90.2;88.8;84.7;69.9;66.2;55.2;53.7;55;62.5;70.7;78;89;92;...
%     89;86;72.4;55.5;51.5;50;52.6;56.8;68.7;76.5;81.7;96;92;84.2;74.9;63.2;55.6];
% 
% %palmer z-index
% soil_mstr_data_Maricopa=[11.19;9.57;9.05;8.3;8.4;8.6;10.31;9.64;10.95;8.72;...
%     13.29;8.92;7.68;7.11;8.73;7.78;7.86;8.47;10.07;13.74;15.11;9.01;8.2;...
%     10.15;10.2;7.97;8.1;8.49;10.23;9.47;8.95;7.89;9.81;11.29;9.41;8.75;10.84;...
%     7.72;6.72;8.7;8.68;8.92;7.67;10.57;8.92;8.19;9.67;10.84;11;11.25;8.09;...
%     8.62;9.25;8.84;12.26;8.76;8.04;7.75;7.43;7.89;7.82;8.77;7.47;7.25;7.91;...
%     8.98;13.33;10.48;8.17;16.69;9.11;8.62;9.84;13.51;10.12;9.43;10.42;9.92;...
%     8.32;7.2;13.61;8.33;14.64;10.86;8.77;10.93;13.42;11.24;11.26;8.67;7.06;...
%     7.09;7.46;7.71;8.02;8.8;9.8;7.94;8.14;7.53;7.91;8.81;15.97;12.66;9.59;...
%     9.52;7.61;11.6;8.49;8.95;7.88;7.87;8.12;9.31;10.8;12.56;9.97;10.21;9.47;...
%     11.1;11.67;10.64;11.91;11.03;11.01;9.89;7.22;7.43;9.54;7.93;8.66;9.77];
% 
% temp_data=temp_data_Pima;
% soil_mstr_data=soil_mstr_data_Pima;
% 
% tind = [15.5;45;74.5;105;135.5;166;196.5;227.5;258;288.5;319;349.5;380.5;410;...
%     439.5;470;500.5;531;561.5;592.5;623;653.5;684;714.5;745.5;775;804.5;835;...
%     865.5;896;926.5;957.5;988;1018.5;1049;1079.5;1110.5;1140.5;1170.5;1201;...
%     1231.5;1262;1292.5;1323.5;1354;1384.5;1415;1445.5;1476.5;1506;1535.5;1566;...
%     1596.5;1627;1657.5;1688.5;1719;1749.5;1780;1810.5;1841.5;1871;1900.5;1931;...
%     1961.5;1992;2022.5;2053.5;2084;2114.5;2145;2175.5;2206.5;2236;2265.5;2296;...
%     2326.5;2357;2387.5;2418.5;2449;2479.5;2510;2540.5;2571.5;2601.5;2631.5;2662;...
%     2692.5;2723;2753.5;2784.5;2815;2845.5;2876;2906.5;2937.5;2967;2996.5;3027;...
%     3057.5;3088;3118.5;3149.5;3180;3210.5;3241;3271.5;3302.5;3332;3361.5;3392;...
%     3422.5;3453;3483.5;3514.5;3545;3575.5;3606;3636.5;3667.5;3697;3726.5;3757;...
%     3787.5;3818;3848.5;3879.5;3910; 3940.5; 3971; 4001.5];
% 
% TFSpchip=pchip(tind,temp_data);
% %TFSpline=spline(tind,temp_data);
% TF=ppval(TFSpchip, t);
% 
% S_mpchip=pchip(tind,soil_mstr_data);
% %S_mSpline=spline(tind,soil_mstr_data);
% S_m=ppval(S_mpchip, t);
% 
% if TF<T_opt_A || TF==T_opt_A
% F_A_T=exp(-((TF-T_opt_A)^2/bl_Topt_A));
% else
% F_A_T=exp(-((TF-T_opt_A)^2/ab_Topt_A));
% end
% 
% if TF<T_opt_H || TF==T_opt_H
% F_H_T=exp(-((TF-T_opt_H)^2/bl_Topt_H));
% else
% F_H_T=exp(-((TF-T_opt_H)^2/ab_Topt_H));
% end
% 
% if S_m<S_opt_A || S_m==S_opt_A
% F_A_S_m=exp(-((S_m-S_opt_A)^2/bl_Sopt_A));
% else
% F_A_S_m=exp(-((S_m-S_opt_A)^2/ab_Sopt_A));
% end
% 
% if S_m<S_opt_H || S_m==S_opt_H
% F_H_S_m=exp(-((S_m-S_opt_H)^2/bl_Sopt_H));
% else
% F_H_S_m=exp(-((S_m-S_opt_H)^2/ab_Sopt_H));
% end
% 
% % if S_m<S_d_s && TF>T_d_s
% %   F_dr=exp(-((S_m-S_d_s)^2/bl_S_d_s))*exp(-((TF-T_d_s)^2/ab_T_d_s));
% % else
% %     F_H_dr=1;
% % end
% 
% if S_m<S_d_s %&& TF>T_d_s %&& xtr_c_s*(S_d_s/S_m)*(TF/T_d_s)>1
% %F_H_dr=xtr_c_s*(S_d_s/S_m)*(TF/T_d_s);
% %F_dr=exp(((S_d_s-S_m)/S_d_s)*((TF-T_d_s)/T_d_s)*xtr_c_s);
% F_dr=exp(((S_d_s-S_m)/S_d_s)*xtr_c_s);
% else
%     F_dr=1;
% end
% 
% dV_j=((1/(1+exp(TF-T_hs)))-(1/(1+exp(TF-T_cs))))*beta*V_a-mu_V*V_j-delta_V_j*V_j;
% dV_a=mu_V*V_j-delta_V_a*V_a;
% dO=PI-(TF/T_decay)*delta_O*O+delta_V_j*V_j*0.001+delta_V_a*V_a*0.005;
% dD=(TF/T_decay)*(delta_O*O+sigma*V_j+sigma*V_a)-(mu_H*H*D);
% dH=C*gamma_H*H*D*(1-(H/H_max))*(F_H_T*F_H_S_m)-delta_H*H*F_dr;
% dA=gamma_A*H*(F_A_T*F_A_S_m)-delta_A*A;
% dC=(alpha*A*V_a+phi_A*A)*(1-(H/H_max))-delta_C*C;
% 
% dS=alpha_h*(S+E+I+R)+delta_R*R-epsilon*S*A-omega*S;
% dE=epsilon*S*A-psi*E-omega*E;
% dI=psi*E-rho*I-kappa*I-omega*I;
% dR=rho*I-delta_R*R-omega*R;
% 
% dM4_SF=[dV_j;dV_a;dO;dD;dH;dA;dC;dS;dE;dI;dR];
% end









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%MODEL 4 SIMPLIFIED FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dM4_SF_S = M4_SF_S(t,a,params,county)
V=a(1); O = a(2); D = a(3); H = a(4); A = a(5); 
S= a(6); E= a(7); I= a(8); R= a(9);

delta_O=params(1);      mu_H=params(2);
gamma_H=params(3);      H_max=params(4);        delta_H=params(5);
gamma_A=params(6);      delta_A=params(7);      phi_A=params(8);
T_opt_H=params(9);     T_opt_A=params(10);
S_opt_H=params(11);     S_opt_A=params(12);     T_decay=params(13);
bl_Topt_A=params(14);   ab_Topt_A=params(15);   bl_Topt_H=params(16); 
ab_Topt_H=params(17);   bl_Sopt_A=params(18);   ab_Sopt_A=params(19); 
bl_Sopt_H=params(20);   ab_Sopt_H=params(21);   T_hs=params(22);
beta=params(23);        delta_V=params(24);     sigma=params(25); 
T_cs=params(26); 
alpha=params(27);       S_d_s=params(28);       T_d_s=params(29); 
xtr_c_s=params(30);
alpha_h=params(31);        epsilon=params(32);     
omega=params(33);        rho=params(34);     kappa=params(35);
psi=params(36);       delta_D=params(37);      

% TF=40*sin(((2*pi)/365)*t)+70; %Mimics temperature annual temps of a simulated location with variation of 20-120
% S_m=49*sin(((2*pi)/365)*t-(pi/8))+50; %Mimics soil moisture of a simulated location with variation of 0-100
t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];


temp_data_Maricopa=[50;52.9;65;69.8;78.2;88.5;91.4;89.6;83.2;69.2;62.1;52.3;...
    56.5;59.8;64.5;69.8;77.9;87.2;91.3;86.4;84.4;74.7;61.8;53.9;55.1;61.5;...
    67.2;68.8;73;88.1;89.4;92.3;85.6;74.7;58;50.7;51.7;61.8;65.6;69.2;74.7;...
    90.2;93.2;88.8;82.4;76.6;63.6;54.8;52;58.5;66.8;70.7;76.9;89.4;91.8;...
    90.4;82.8;76.2;67.4;56.9;58.4;56.2;62.6;73;78.1;87.1;91.9;90.3;87.4;...
    69.6;59.7;52.5;52.8;50.2;61.4;70.3;71.1;85.6;92.4;92.6;84.2;71;62.2;...
    52.5;53.5;55.7;60.3;69;81.2;86.7;94;94.7;87;76.6;63.9;52.9;53.2;57;59.9;...
    71.6;77.4;89.9;90.2;88.8;84.7;69.9;66.2;55.2;53.7;55;62.5;70.7;78;89;92;...
    89;86;72.4;55.5;51.5;50;52.6;56.8;68.7;76.5;81.7;96;92;84.2;74.9;63.2;55.6];

temp_data_Pima=[48.0; 49.5; 62.7; 66.7; 74.4; 85.6; 85.3; 83.9; 79.8; 67.1; 60.2;...
    50.8; 55.5; 58.1; 61.7; 66.6; 74.2; 85.2; 85.9; 82.1; 80.4; 72.2; 60.0; 52.1;...
    53.4; 59.7; 63.5; 65.6; 69.5; 84.6; 84.2; 86.9; 81.0; 71.9; 57.0; 49.5; 50.3;...
    59.6; 62.7; 65.9; 71.1; 86.1; 88.2; 83.4; 77.9; 74.2; 61.1; 53.7; 50.3; 57.1;...
    65.1; 68.3; 73.1; 85.9; 86.0; 84.8; 78.9; 74.7; 66.3; 55.1; 56.9; 55.0; 60.5;...
    70.6; 74.7; 84.1; 86.7; 85.1; 83.1; 67.4; 57.6; 51.1; 51.7; 48.6; 59.0; 67.0;...
    67.5; 81.4; 87.6; 87.2; 79.9; 68.7; 61.2; 51.6; 52.2; 52.8; 58.0; 66.1; 77.3;...
    83.2; 88.6; 89.6; 82.8; 73.9; 62.7; 50.9; 51.5; 54.8; 57.2; 68.5; 74.4; 86.6;...
    84.7; 83.9; 80.7; 68.0; 64.2; 54.2; 52.0; 52.0; 59.5; 67.8; 75.2; 84.9; 86.7;...
    83.3; 81.5; 68.9; 54.1; 50.5; 49.0; 50.3; 55.5; 65.9; 73.1; 79.1; 91.1; 87.3;...
    82.0; 73.1; 61.8; 54.0];

temp_data_Pinal=[48.2; 50.5; 62.6; 67.6; 76.5; 87.3; 88.2; 86.7; 81.4; 68.4; 60.7;...
    50.5; 54.4; 58.4; 62.5; 68.3; 76.3; 86.8; 88.6; 84.3; 81.9; 73.2; 60.2; 52.2;...
    52.8; 59.5; 64.6; 66.6; 71.6; 86.9; 87.0; 88.9; 82.0; 72.5; 56.4; 48.7; 50.1;...
    59.3; 63.4; 67.1; 73.6; 88.0; 90.1; 85.2; 80.3; 75.4; 62.1; 53.5; 50.8; 57.3;...
    65.0; 68.2; 74.9; 87.8; 88.0; 86.4; 81.1; 75.0; 66.2; 54.9; 56.4; 55.6; 61.1;...
    71.5; 76.9; 85.8; 89.0; 87.0; 84.3; 68.7; 58.0; 51.0; 50.9; 49.3; 59.3; 68.4;...
    69.7; 84.3; 90.3; 89.7; 82.5; 70.3; 61.3; 51.2; 51.5; 53.4; 58.8; 67.6; 79.4;...
    85.3; 91.1; 92.0; 84.6; 75.0; 62.6; 51.0; 52.0; 55.8; 58.2; 69.8; 76.5; 88.4;...
    86.7; 85.7; 82.2; 69.2; 64.7; 54.8; 51.9; 52.3; 59.9; 68.9; 76.8; 87.3; 89.4;...
    85.8; 84.0; 70.7; 55.0; 50.4; 48.8; 51.1; 55.8; 67.0; 75.4; 81.2; 93.7; 90.0;...
    82.8; 74.4; 62.3; 53.9];

temp_data_AZ=[38.6; 42.2; 54.8; 59.4; 67.4; 79.5; 81.0; 78.5; 72.4; 58.8; 51.3;...
41.5; 46.5; 50.0; 53.9; 59.1; 66.8; 77.7; 81.4; 76.5; 74.2; 64.9; 51.7; 44.3; 45.1;...
52.0; 56.3; 58.4; 62.9; 78.4; 78.6; 80.6; 75.0; 64.5; 48.3; 40.9; 41.8; 50.6; 54.9;...
58.5; 64.6; 80.3; 82.4; 77.5; 71.6; 66.1; 53.1; 44.7; 42.3; 49.4; 56.6; 59.9; 66.1;...
79.8; 81.5; 79.1; 72.4; 65.1; 57.6; 46.6; 47.6; 46.7; 52.3; 62.9; 68.5; 78.6; 82.3;...
80.2; 76.0; 59.9; 49.4; 42.8; 42.4; 40.9; 51.7; 60.3; 60.7; 75.2; 81.9; 81.9; 73.8;...
60.0; 52.1; 42.2; 43.7; 45.9; 51.0; 59.3; 70.5; 76.8; 82.8; 84.1; 75.6; 66.2; 53.5;...
42.0; 42.6; 46.5; 49.4; 61.2; 67.9; 80.6; 81.4; 79.5; 74.8; 59.9; 55.8; 45.6; 43.5;...
44.0; 51.8; 60.5; 68.6; 78.6; 82.2; 79.0; 75.9; 61.8; 46.1; 42.8; 40.3; 41.9; 47.2;...
58.4; 66.5; 72.4; 85.4; 80.7; 73.6; 64.4; 52.6; 45.4];


%palmer z-index
soil_mstr_data_Maricopa=[11.19;9.57;9.05;8.3;8.4;8.6;10.31;9.64;10.95;8.72;...
    13.29;8.92;7.68;7.11;8.73;7.78;7.86;8.47;10.07;13.74;15.11;9.01;8.2;...
    10.15;10.2;7.97;8.1;8.49;10.23;9.47;8.95;7.89;9.81;11.29;9.41;8.75;10.84;...
    7.72;6.72;8.7;8.68;8.92;7.67;10.57;8.92;8.19;9.67;10.84;11;11.25;8.09;...
    8.62;9.25;8.84;12.26;8.76;8.04;7.75;7.43;7.89;7.82;8.77;7.47;7.25;7.91;...
    8.98;13.33;10.48;8.17;16.69;9.11;8.62;9.84;13.51;10.12;9.43;10.42;9.92;...
    8.32;7.2;13.61;8.33;14.64;10.86;8.77;10.93;13.42;11.24;11.26;8.67;7.06;...
    7.09;7.46;7.71;8.02;8.8;9.8;7.94;8.14;7.53;7.91;8.81;15.97;12.66;9.59;...
    9.52;7.61;11.6;8.49;8.95;7.88;7.87;8.12;9.31;10.8;12.56;9.97;10.21;9.47;...
    11.1;11.67;10.64;11.91;11.03;11.01;9.89;7.22;7.43;9.54;7.93;8.66;9.77];

soil_mstr_data_Pima=[9.94;10.4;8.27;8.04;8.16;8.23;10.48;10.21;10.37;8.27;13.32;...
9.16;7.62;7.18;8.27;8.11;8.05;7.98;10.59;11.6;12.03;10.55;8.23;10.35;12.34;8.45;...
8.32;9.19;10.13;11.13;9.25;8.08;12.24;11.52;9.11;9.08;10.78;7.84;6.91;9.45;8.42;...
9.86;8.24;9.57;10.93;7.81;8.95;10.14;10.71;9.14;6.89;7.94;8.67;8.17;12.31;7.77;7.77;...
7.36;7.42;8.26;7.21;10.82;8;7.34;8.03;10.14;11.34;9.7;9.35;14.9;8.92;9.8;10.23;13.59;...
10.56;10.04;10.95;10.3;7.42;8.54;13.23;8.06;14.66;11.59;9.49;10.36;11.7;10.99;10.51;...
9.04;6.36;6.36;6.86;7.46;8.05;8.45;10.66;8.26;8.38;7.95;8.03;8.88;18.62;12.45;9.39;8.38;...
7.63;9.82;8.41;8.51;7.73;7.73;7.96;10.1;10.83;12.76;10.19;10.15;8.83;10.62;11.38;10.98;...
10.49;9.88;10.42;9.39;6.58;8.2;8.69;7.92;8.52;10.4];

soil_mstr_data_Pinal= [10.82; 9.64; 9.20; 8.65; 8.65; 8.40; 11.98; 8.05; 9.70;...
8.48; 12.07; 8.79; 7.53; 6.86; 8.95; 7.40; 7.51; 7.88; 8.81; 10.79; 14.72; 10.25;...
7.99; 10.15; 11.68; 8.12; 7.78; 9.04; 10.83; 10.48; 9.33; 9.75; 13.02; 11.84; 9.73;...
8.65; 10.84; 7.70; 6.75; 8.86; 8.33; 9.53; 7.85; 9.88; 9.85; 8.00; 9.60; 10.02; 10.87;...
8.92; 7.26; 7.86; 8.61; 8.31; 13.30; 9.20; 7.85; 7.50; 7.19; 7.94; 7.67; 9.63; 7.46; 6.74;...
7.52; 9.43; 11.60; 9.57; 10.68; 14.41; 9.01; 9.05; 9.83; 14.28; 9.55; 9.82; 10.37; 10.31;...
8.35; 6.86; 11.60; 8.08; 14.76; 11.76; 9.24; 10.30; 11.11; 10.56; 11.07; 8.67; 6.74; 6.69;...
7.18; 7.55; 8.15; 8.50; 9.84; 7.74; 8.15; 7.18; 7.49; 8.05; 18.35; 10.85; 11.11; 8.74; 7.43;...
10.29; 9.01; 8.97; 8.48; 7.22; 7.47; 9.72; 9.13; 12.40; 9.67; 10.03; 9.01; 12.06; 11.71; 10.98;...
10.68; 10.67; 11.82; 10.26; 6.83; 7.90; 9.35; 7.75; 8.99; 10.00];

soil_mstr_data_AZ=[10.62;9.22;8.26;7.91;8.25;7.71;11.94;10.43;11.66;8.52;12.04;...
8.76;7.16;6.9;8.03;7.26;7.22;6.88;9.67;12.5;12.95;8.7;7.98;10.2;10.95;8.23;8.67;8.47;...
10.74;10.34;10.35;9.59;10.03;11.91;9.92;8.87;10.34;7.49;6.66;8.81;8.83;8.16;8.32;11.03;...
10.42;7.91;9.67;11.41;12;10.17;7.85;8.52;10.04;8.96;12.46;8.01;8.45;7.26;6.84;7.38;7.64;...
9.06;7.82;5.99;7.16;7.63;11.46;9.36;8.46;14.53;8.8;8.9;10.48;13.67;10.25;9.89;11.96;...
10.88;7.47;6.54;10.97;7.91;14.44;11.23;8.92;10.21;12.52;10.47;11.24;9.56;6.77;5.54;6.75;...
7.38;8.08;8.18;9.89;7.85;8.99;7.1;7;7.21;14.84;9.74;9.84;9.69;7.21;10.62;8.14;8.52;8.52;...
6.77;6.97;8.74;10.66;12.3;10.1;10.64;9.4;10.35;12.34;10.55;12.46;9.84;11.96;10.83;6.61;...
8.88;9.72;7.75;8.67;9.03];

if county==1
temp_data=temp_data_AZ;
soil_mstr_data=soil_mstr_data_AZ;
elseif county==2
temp_data=temp_data_Maricopa;
soil_mstr_data=soil_mstr_data_Maricopa;
elseif county==3
temp_data=temp_data_Pima;
soil_mstr_data=soil_mstr_data_Pima;
elseif county==4
temp_data=temp_data_Pinal;
soil_mstr_data=soil_mstr_data_Pinal;
else
    error('No region selected or invaled input');
end
%t
% indexer=1;
% while indexer<=length(t_inf_data)
%     if t==0
%         TF=temp_data(indexer);
%         S_m=soil_mstr_data(indexer); 
%         indexer=length(t_inf_data)+1;
%     elseif t<=t_inf_data(indexer)
%         TF=temp_data(indexer-1);
%         S_m=soil_mstr_data(indexer-1);
%         indexer=length(t_inf_data)+1;
%     else
%         indexer=indexer+1;
%     end
% end
 %size(t_inf_data)
 %size(temp_data)
% size(soil_mstr_data)
% TF=interp1(t_inf_data,[0;temp_data],t,'next');
% S_m=interp1(t_inf_data,[0;soil_mstr_data],t,'next');
% TFt-TF
% S_mt-S_m
tind = [15.5;45;74.5;105;135.5;166;196.5;227.5;258;288.5;319;349.5;380.5;410;...
    439.5;470;500.5;531;561.5;592.5;623;653.5;684;714.5;745.5;775;804.5;835;...
    865.5;896;926.5;957.5;988;1018.5;1049;1079.5;1110.5;1140.5;1170.5;1201;...
    1231.5;1262;1292.5;1323.5;1354;1384.5;1415;1445.5;1476.5;1506;1535.5;1566;...
    1596.5;1627;1657.5;1688.5;1719;1749.5;1780;1810.5;1841.5;1871;1900.5;1931;...
    1961.5;1992;2022.5;2053.5;2084;2114.5;2145;2175.5;2206.5;2236;2265.5;2296;...
    2326.5;2357;2387.5;2418.5;2449;2479.5;2510;2540.5;2571.5;2601.5;2631.5;2662;...
    2692.5;2723;2753.5;2784.5;2815;2845.5;2876;2906.5;2937.5;2967;2996.5;3027;...
    3057.5;3088;3118.5;3149.5;3180;3210.5;3241;3271.5;3302.5;3332;3361.5;3392;...
    3422.5;3453;3483.5;3514.5;3545;3575.5;3606;3636.5;3667.5;3697;3726.5;3757;...
    3787.5;3818;3848.5;3879.5;3910; 3940.5; 3971; 4001.5];

TFSpchip=pchip(tind,temp_data);
%TFSpline=spline(tind,temp_data);
TF=ppval(TFSpchip, t);

S_mpchip=pchip(tind,soil_mstr_data);
%S_mSpline=spline(tind,soil_mstr_data);
S_m=ppval(S_mpchip, t);

if TF<T_opt_A || TF==T_opt_A
F_A_T=exp(-((TF-T_opt_A)^2/bl_Topt_A));
else
F_A_T=exp(-((TF-T_opt_A)^2/ab_Topt_A));
end

if TF<T_opt_H || TF==T_opt_H
F_H_T=exp(-((TF-T_opt_H)^2/bl_Topt_H));
else
F_H_T=exp(-((TF-T_opt_H)^2/ab_Topt_H));
end

if S_m<S_opt_A || S_m==S_opt_A
F_A_S_m=exp(-((S_m-S_opt_A)^2/bl_Sopt_A));
else
F_A_S_m=exp(-((S_m-S_opt_A)^2/ab_Sopt_A));
end

if S_m<S_opt_H || S_m==S_opt_H
F_H_S_m=exp(-((S_m-S_opt_H)^2/bl_Sopt_H));
else
F_H_S_m=exp(-((S_m-S_opt_H)^2/ab_Sopt_H));
end

% if S_m<S_d_s && TF>T_d_s
%   F_dr=exp(-((S_m-S_d_s)^2/bl_S_d_s))*exp(-((TF-T_d_s)^2/ab_T_d_s));
% else
%     F_H_dr=1;
% end

if S_m<S_d_s %&& TF>T_d_s %&& xtr_c_s*(S_d_s/S_m)*(TF/T_d_s)>1
%F_H_dr=xtr_c_s*(S_d_s/S_m)*(TF/T_d_s);
%F_dr=exp(((S_d_s-S_m)/S_d_s)*((TF-T_d_s)/T_d_s)*xtr_c_s);
F_dr=exp(((S_d_s-S_m)/S_d_s)*xtr_c_s);
else
    F_dr=1;
end

dV=((1/(1+exp(TF-T_hs)))-(1/(1+exp(TF-T_cs))))*beta*V-delta_V*V;
dO=-(TF/T_decay)*delta_O*O+delta_V*V;
dD=(TF/T_decay)*(delta_O*O+sigma*V)-(mu_H*H*D)-delta_D;
dH=(alpha*A*V+phi_A*A+gamma_H*D*H*(F_H_T*F_H_S_m))*(1-(H/H_max))-delta_H*H*F_dr;
dA=gamma_A*H*(F_A_T*F_A_S_m)-alpha*A*V-phi_A*A-delta_A*A;

dS=alpha_h*(S+E+I+R)-epsilon*S*A-omega*S;
dE=epsilon*S*A-psi*E-omega*E;
dI=psi*E-rho*I-kappa*I-omega*I;
dR=rho*I-omega*R;


dM4_SF_S=[dV;dO;dD;dH;dA;dS;dE;dI;dR];
end









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function dM5_SF = M5_SF(t,a,params,county)
V=a(1); O = a(2); D = a(3); H = a(4); A = a(5); 
S=a(6); E = a(7); A_H=a(8); I =a(9); R =a(10);

k_ref=params(1);        Q_18=params(2);         T_ref=params(3);      
mu_H=params(4);         gamma_H=params(5);      H_max=params(6);        
delta_H=params(7);      gamma_A=params(8);      delta_A=params(9);      
phi_A=params(10);       T_opt_H=params(11);     T_opt_A=params(12);
S_opt_H=params(13);     S_opt_A=params(14);     
bl_Topt_A=params(15);   ab_Topt_A=params(16);   bl_Topt_H=params(17); 
ab_Topt_H=params(18);   bl_Sopt_A=params(19);   ab_Sopt_A=params(20); 
bl_Sopt_H=params(21);   ab_Sopt_H=params(22);   T_hs=params(23);
beta=params(24);        delta_V=params(25);
sigma=params(26);       T_cs=params(27); 
alpha=params(28);       S_d_s=params(29);       T_d_s=params(30); 
xtr_c_s=params(31);
alpha_h=params(32);     epsilon=params(33);     
omega=params(34);       rho_I=params(35);         kappa=params(36);
psi=params(37);        delta_D=params(38);      rho_A=params(39);
%bl_S_H_s=params(34);    ab_T_H_s=params(35);

t_inf_data=[0;31;59;90;120;151;181;212;243;273;304;334;365;396;424;455;485;...
    516;546;577;608;638;669;699;730;761;789;820;850;881;911;942;973;1003;...
    1034;1064;1095;1126;1155;1186;1216;1247;1277;1308;1339;1369;1400;1430;...
    1461;1492;1520;1551;1581;1612;1642;1673;1704;1734;1765;1795;1826;1857;...
    1885;1916;1946;1977;2007;2038;2069;2099;2130;2160;2191;2222;2250;2281;...
    2311;2342;2372;2403;2434;2464;2495;2525;2556;2587;2616;2647;2677;2708;...
    2738;2769;2800;2830;2861;2891;2922;2953;2981;3012;3042;3073;3103;3134;...
    3165;3195;3226;3256;3287;3318;3346;3377;3407;3438;3468;3499;3530;3560;...
    3591;3621;3652;3683;3711;3742;3772;3803;3833;3864;3895;3925;3956;3986;4017];


temp_data_Maricopa=[50;52.9;65;69.8;78.2;88.5;91.4;89.6;83.2;69.2;62.1;52.3;...
    56.5;59.8;64.5;69.8;77.9;87.2;91.3;86.4;84.4;74.7;61.8;53.9;55.1;61.5;...
    67.2;68.8;73;88.1;89.4;92.3;85.6;74.7;58;50.7;51.7;61.8;65.6;69.2;74.7;...
    90.2;93.2;88.8;82.4;76.6;63.6;54.8;52;58.5;66.8;70.7;76.9;89.4;91.8;...
    90.4;82.8;76.2;67.4;56.9;58.4;56.2;62.6;73;78.1;87.1;91.9;90.3;87.4;...
    69.6;59.7;52.5;52.8;50.2;61.4;70.3;71.1;85.6;92.4;92.6;84.2;71;62.2;...
    52.5;53.5;55.7;60.3;69;81.2;86.7;94;94.7;87;76.6;63.9;52.9;53.2;57;59.9;...
    71.6;77.4;89.9;90.2;88.8;84.7;69.9;66.2;55.2;53.7;55;62.5;70.7;78;89;92;...
    89;86;72.4;55.5;51.5;50;52.6;56.8;68.7;76.5;81.7;96;92;84.2;74.9;63.2;55.6];

temp_data_Pima=[48.0; 49.5; 62.7; 66.7; 74.4; 85.6; 85.3; 83.9; 79.8; 67.1; 60.2;...
    50.8; 55.5; 58.1; 61.7; 66.6; 74.2; 85.2; 85.9; 82.1; 80.4; 72.2; 60.0; 52.1;...
    53.4; 59.7; 63.5; 65.6; 69.5; 84.6; 84.2; 86.9; 81.0; 71.9; 57.0; 49.5; 50.3;...
    59.6; 62.7; 65.9; 71.1; 86.1; 88.2; 83.4; 77.9; 74.2; 61.1; 53.7; 50.3; 57.1;...
    65.1; 68.3; 73.1; 85.9; 86.0; 84.8; 78.9; 74.7; 66.3; 55.1; 56.9; 55.0; 60.5;...
    70.6; 74.7; 84.1; 86.7; 85.1; 83.1; 67.4; 57.6; 51.1; 51.7; 48.6; 59.0; 67.0;...
    67.5; 81.4; 87.6; 87.2; 79.9; 68.7; 61.2; 51.6; 52.2; 52.8; 58.0; 66.1; 77.3;...
    83.2; 88.6; 89.6; 82.8; 73.9; 62.7; 50.9; 51.5; 54.8; 57.2; 68.5; 74.4; 86.6;...
    84.7; 83.9; 80.7; 68.0; 64.2; 54.2; 52.0; 52.0; 59.5; 67.8; 75.2; 84.9; 86.7;...
    83.3; 81.5; 68.9; 54.1; 50.5; 49.0; 50.3; 55.5; 65.9; 73.1; 79.1; 91.1; 87.3;...
    82.0; 73.1; 61.8; 54.0];

temp_data_Pinal=[48.2; 50.5; 62.6; 67.6; 76.5; 87.3; 88.2; 86.7; 81.4; 68.4; 60.7;...
    50.5; 54.4; 58.4; 62.5; 68.3; 76.3; 86.8; 88.6; 84.3; 81.9; 73.2; 60.2; 52.2;...
    52.8; 59.5; 64.6; 66.6; 71.6; 86.9; 87.0; 88.9; 82.0; 72.5; 56.4; 48.7; 50.1;...
    59.3; 63.4; 67.1; 73.6; 88.0; 90.1; 85.2; 80.3; 75.4; 62.1; 53.5; 50.8; 57.3;...
    65.0; 68.2; 74.9; 87.8; 88.0; 86.4; 81.1; 75.0; 66.2; 54.9; 56.4; 55.6; 61.1;...
    71.5; 76.9; 85.8; 89.0; 87.0; 84.3; 68.7; 58.0; 51.0; 50.9; 49.3; 59.3; 68.4;...
    69.7; 84.3; 90.3; 89.7; 82.5; 70.3; 61.3; 51.2; 51.5; 53.4; 58.8; 67.6; 79.4;...
    85.3; 91.1; 92.0; 84.6; 75.0; 62.6; 51.0; 52.0; 55.8; 58.2; 69.8; 76.5; 88.4;...
    86.7; 85.7; 82.2; 69.2; 64.7; 54.8; 51.9; 52.3; 59.9; 68.9; 76.8; 87.3; 89.4;...
    85.8; 84.0; 70.7; 55.0; 50.4; 48.8; 51.1; 55.8; 67.0; 75.4; 81.2; 93.7; 90.0;...
    82.8; 74.4; 62.3; 53.9];

temp_data_AZ=[38.6; 42.2; 54.8; 59.4; 67.4; 79.5; 81.0; 78.5; 72.4; 58.8; 51.3;...
41.5; 46.5; 50.0; 53.9; 59.1; 66.8; 77.7; 81.4; 76.5; 74.2; 64.9; 51.7; 44.3; 45.1;...
52.0; 56.3; 58.4; 62.9; 78.4; 78.6; 80.6; 75.0; 64.5; 48.3; 40.9; 41.8; 50.6; 54.9;...
58.5; 64.6; 80.3; 82.4; 77.5; 71.6; 66.1; 53.1; 44.7; 42.3; 49.4; 56.6; 59.9; 66.1;...
79.8; 81.5; 79.1; 72.4; 65.1; 57.6; 46.6; 47.6; 46.7; 52.3; 62.9; 68.5; 78.6; 82.3;...
80.2; 76.0; 59.9; 49.4; 42.8; 42.4; 40.9; 51.7; 60.3; 60.7; 75.2; 81.9; 81.9; 73.8;...
60.0; 52.1; 42.2; 43.7; 45.9; 51.0; 59.3; 70.5; 76.8; 82.8; 84.1; 75.6; 66.2; 53.5;...
42.0; 42.6; 46.5; 49.4; 61.2; 67.9; 80.6; 81.4; 79.5; 74.8; 59.9; 55.8; 45.6; 43.5;...
44.0; 51.8; 60.5; 68.6; 78.6; 82.2; 79.0; 75.9; 61.8; 46.1; 42.8; 40.3; 41.9; 47.2;...
58.4; 66.5; 72.4; 85.4; 80.7; 73.6; 64.4; 52.6; 45.4];


%palmer z-index
soil_mstr_data_Maricopa=[11.19;9.57;9.05;8.3;8.4;8.6;10.31;9.64;10.95;8.72;...
    13.29;8.92;7.68;7.11;8.73;7.78;7.86;8.47;10.07;13.74;15.11;9.01;8.2;...
    10.15;10.2;7.97;8.1;8.49;10.23;9.47;8.95;7.89;9.81;11.29;9.41;8.75;10.84;...
    7.72;6.72;8.7;8.68;8.92;7.67;10.57;8.92;8.19;9.67;10.84;11;11.25;8.09;...
    8.62;9.25;8.84;12.26;8.76;8.04;7.75;7.43;7.89;7.82;8.77;7.47;7.25;7.91;...
    8.98;13.33;10.48;8.17;16.69;9.11;8.62;9.84;13.51;10.12;9.43;10.42;9.92;...
    8.32;7.2;13.61;8.33;14.64;10.86;8.77;10.93;13.42;11.24;11.26;8.67;7.06;...
    7.09;7.46;7.71;8.02;8.8;9.8;7.94;8.14;7.53;7.91;8.81;15.97;12.66;9.59;...
    9.52;7.61;11.6;8.49;8.95;7.88;7.87;8.12;9.31;10.8;12.56;9.97;10.21;9.47;...
    11.1;11.67;10.64;11.91;11.03;11.01;9.89;7.22;7.43;9.54;7.93;8.66;9.77];

soil_mstr_data_Pima=[9.94;10.4;8.27;8.04;8.16;8.23;10.48;10.21;10.37;8.27;13.32;...
9.16;7.62;7.18;8.27;8.11;8.05;7.98;10.59;11.6;12.03;10.55;8.23;10.35;12.34;8.45;...
8.32;9.19;10.13;11.13;9.25;8.08;12.24;11.52;9.11;9.08;10.78;7.84;6.91;9.45;8.42;...
9.86;8.24;9.57;10.93;7.81;8.95;10.14;10.71;9.14;6.89;7.94;8.67;8.17;12.31;7.77;7.77;...
7.36;7.42;8.26;7.21;10.82;8;7.34;8.03;10.14;11.34;9.7;9.35;14.9;8.92;9.8;10.23;13.59;...
10.56;10.04;10.95;10.3;7.42;8.54;13.23;8.06;14.66;11.59;9.49;10.36;11.7;10.99;10.51;...
9.04;6.36;6.36;6.86;7.46;8.05;8.45;10.66;8.26;8.38;7.95;8.03;8.88;18.62;12.45;9.39;8.38;...
7.63;9.82;8.41;8.51;7.73;7.73;7.96;10.1;10.83;12.76;10.19;10.15;8.83;10.62;11.38;10.98;...
10.49;9.88;10.42;9.39;6.58;8.2;8.69;7.92;8.52;10.4];

soil_mstr_data_Pinal= [10.82; 9.64; 9.20; 8.65; 8.65; 8.40; 11.98; 8.05; 9.70;...
8.48; 12.07; 8.79; 7.53; 6.86; 8.95; 7.40; 7.51; 7.88; 8.81; 10.79; 14.72; 10.25;...
7.99; 10.15; 11.68; 8.12; 7.78; 9.04; 10.83; 10.48; 9.33; 9.75; 13.02; 11.84; 9.73;...
8.65; 10.84; 7.70; 6.75; 8.86; 8.33; 9.53; 7.85; 9.88; 9.85; 8.00; 9.60; 10.02; 10.87;...
8.92; 7.26; 7.86; 8.61; 8.31; 13.30; 9.20; 7.85; 7.50; 7.19; 7.94; 7.67; 9.63; 7.46; 6.74;...
7.52; 9.43; 11.60; 9.57; 10.68; 14.41; 9.01; 9.05; 9.83; 14.28; 9.55; 9.82; 10.37; 10.31;...
8.35; 6.86; 11.60; 8.08; 14.76; 11.76; 9.24; 10.30; 11.11; 10.56; 11.07; 8.67; 6.74; 6.69;...
7.18; 7.55; 8.15; 8.50; 9.84; 7.74; 8.15; 7.18; 7.49; 8.05; 18.35; 10.85; 11.11; 8.74; 7.43;...
10.29; 9.01; 8.97; 8.48; 7.22; 7.47; 9.72; 9.13; 12.40; 9.67; 10.03; 9.01; 12.06; 11.71; 10.98;...
10.68; 10.67; 11.82; 10.26; 6.83; 7.90; 9.35; 7.75; 8.99; 10.00];

soil_mstr_data_AZ=[10.62;9.22;8.26;7.91;8.25;7.71;11.94;10.43;11.66;8.52;12.04;...
8.76;7.16;6.9;8.03;7.26;7.22;6.88;9.67;12.5;12.95;8.7;7.98;10.2;10.95;8.23;8.67;8.47;...
10.74;10.34;10.35;9.59;10.03;11.91;9.92;8.87;10.34;7.49;6.66;8.81;8.83;8.16;8.32;11.03;...
10.42;7.91;9.67;11.41;12;10.17;7.85;8.52;10.04;8.96;12.46;8.01;8.45;7.26;6.84;7.38;7.64;...
9.06;7.82;5.99;7.16;7.63;11.46;9.36;8.46;14.53;8.8;8.9;10.48;13.67;10.25;9.89;11.96;...
10.88;7.47;6.54;10.97;7.91;14.44;11.23;8.92;10.21;12.52;10.47;11.24;9.56;6.77;5.54;6.75;...
7.38;8.08;8.18;9.89;7.85;8.99;7.1;7;7.21;14.84;9.74;9.84;9.69;7.21;10.62;8.14;8.52;8.52;...
6.77;6.97;8.74;10.66;12.3;10.1;10.64;9.4;10.35;12.34;10.55;12.46;9.84;11.96;10.83;6.61;...
8.88;9.72;7.75;8.67;9.03];

if county==1
temp_data=temp_data_AZ;
soil_mstr_data=soil_mstr_data_AZ;
elseif county==2
temp_data=temp_data_Maricopa;
soil_mstr_data=soil_mstr_data_Maricopa;
elseif county==3
temp_data=temp_data_Pima;
soil_mstr_data=soil_mstr_data_Pima;
elseif county==4
temp_data=temp_data_Pinal;
soil_mstr_data=soil_mstr_data_Pinal;
else
    error('No region selected or invaled input');
end

tind = [15.5;45;74.5;105;135.5;166;196.5;227.5;258;288.5;319;349.5;380.5;410;...
    439.5;470;500.5;531;561.5;592.5;623;653.5;684;714.5;745.5;775;804.5;835;...
    865.5;896;926.5;957.5;988;1018.5;1049;1079.5;1110.5;1140.5;1170.5;1201;...
    1231.5;1262;1292.5;1323.5;1354;1384.5;1415;1445.5;1476.5;1506;1535.5;1566;...
    1596.5;1627;1657.5;1688.5;1719;1749.5;1780;1810.5;1841.5;1871;1900.5;1931;...
    1961.5;1992;2022.5;2053.5;2084;2114.5;2145;2175.5;2206.5;2236;2265.5;2296;...
    2326.5;2357;2387.5;2418.5;2449;2479.5;2510;2540.5;2571.5;2601.5;2631.5;2662;...
    2692.5;2723;2753.5;2784.5;2815;2845.5;2876;2906.5;2937.5;2967;2996.5;3027;...
    3057.5;3088;3118.5;3149.5;3180;3210.5;3241;3271.5;3302.5;3332;3361.5;3392;...
    3422.5;3453;3483.5;3514.5;3545;3575.5;3606;3636.5;3667.5;3697;3726.5;3757;...
    3787.5;3818;3848.5;3879.5;3910; 3940.5; 3971; 4001.5];

TFSpchip=pchip(tind,temp_data);
%TFSpline=spline(tind,temp_data);
TF=ppval(TFSpchip, t);

S_mpchip=pchip(tind,soil_mstr_data);
%S_mSpline=spline(tind,soil_mstr_data);
S_m=ppval(S_mpchip, t);

if TF<T_opt_A || TF==T_opt_A
F_A_T=exp(-((TF-T_opt_A)^2/bl_Topt_A));
else
F_A_T=exp(-((TF-T_opt_A)^2/ab_Topt_A));
end

if TF<T_opt_H || TF==T_opt_H
F_H_T=exp(-((TF-T_opt_H)^2/bl_Topt_H));
else
F_H_T=exp(-((TF-T_opt_H)^2/ab_Topt_H));
end

if S_m<S_opt_A || S_m==S_opt_A
F_A_S_m=exp(-((S_m-S_opt_A)^2/bl_Sopt_A));
else
F_A_S_m=exp(-((S_m-S_opt_A)^2/ab_Sopt_A));
end

if S_m<S_opt_H || S_m==S_opt_H
F_H_S_m=exp(-((S_m-S_opt_H)^2/bl_Sopt_H));
else
F_H_S_m=exp(-((S_m-S_opt_H)^2/ab_Sopt_H));
end

% if S_m<S_d_s && TF>T_d_s
%   F_dr=exp(-((S_m-S_d_s)^2/bl_S_d_s))*exp(-((TF-T_d_s)^2/ab_T_d_s));
% else
%     F_H_dr=1;
% end

if S_m<S_d_s %&& TF>T_d_s %&& xtr_c_s*(S_d_s/S_m)*(TF/T_d_s)>1
%F_H_dr=xtr_c_s*(S_d_s/S_m)*(TF/T_d_s);
%F_dr=exp(((S_d_s-S_m)/S_d_s)*((TF-T_d_s)/T_d_s)*xtr_c_s);
F_dr=exp(((S_d_s-S_m)/S_d_s)*xtr_c_s);
else
    F_dr=1;
end

dV=((1/(1+exp(TF-T_hs)))-(1/(1+exp(TF-T_cs))))*beta*V-delta_V*V;
dO=delta_V*V-k_ref*Q_18^((TF-T_ref)/18)*O;
dD=k_ref*Q_18^((TF-T_ref)/18)*(O)+sigma*V-(mu_H*H*D)-delta_D*D;
dH=(alpha*A*V+phi_A*A+gamma_H*D*H*(F_H_T*F_H_S_m))*(1-(H/H_max))-delta_H*H*F_dr;
dA=gamma_A*H*(F_A_T*F_A_S_m)-alpha*A*V-phi_A*A-delta_A*A;

dS=alpha_h*(S+E+A_H+I+R)-epsilon*S*A-omega*S;
dE=epsilon*S*A-psi*E-omega*E;
dA_H=(1-psi)*E-rho_A*A_H-omega*A_H;
dI=psi*E-rho_I*I-kappa*I-omega*I;
dR=rho_I*I+rho_A*A_H-omega*R;


dM5_SF=[dV;dO;dD;dH;dA;dS;dE;dA_H;dI;dR];
end


























%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL 6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Option 6.2
function dM6_SF2_2_1 = M5_SF2_2_1(t,a,params)
V_j_1=a(1);  V_a_1=a(2);    O_1=a(3);     D_1=a(4);     H_1=a(5);   A_1=a(6);   C_1=a(7);
S_1=a(8);    I_1=a(9);      R_1=a(10);    V_j_2=a(1);  V_a_2=a(2);    O_2=a(3);     
D_2=a(4);     H_2=a(5);   A_2=a(6);   C_2=a(7); S_2=a(8);    I_2=a(9);      R_2=a(10);

PI=params(1);           delta_O=params(2);      mu_H=params(3);
gamma_H=params(4);      H_max=params(5);        delta_H=params(6);
gamma_A=params(7);      delta_A=params(8);      phi_A=params(9);
delta_C=params(10);     T_opt_H=params(11);     T_opt_A=params(12);
S_opt_H=params(13);     S_opt_A=params(14);     T_decay=params(15);
bl_Topt_A=params(16);   ab_Topt_A=params(17);   bl_Topt_H=params(18); 
ab_Topt_H=params(19);   bl_Sopt_A=params(20);   ab_Sopt_A=params(21); 
bl_Sopt_H=params(22);   ab_Sopt_H=params(23);   T_hs=params(24);
beta=params(25);        mu_V=params(26);        delta_V_j=params(27);
delta_V_a=params(28);   sigma=params(29);       T_cs=params(30); 
alpha=params(31);       alpha_h=params(32);      delta_R=params(33);
epsilon=params(34);     omega=params(35);        rho=params(36);
kappa=params(37);   

TF=40*sin(((2*pi)/365)*t)+70; %Mimics temperature annual temps of a simulated location with variation of 20-120
S_m=49*sin(((2*pi)/365)*t-(pi/8))+50; %Mimics soil moisture of a simulated location with variation of 0-100

if TF<T_opt_A || TF==T_opt_A
F_A_T=exp(-((TF-T_opt_A)^2/bl_Topt_A));
else
F_A_T=exp(-((TF-T_opt_A)^2/ab_Topt_A));
end

if TF<T_opt_H || TF==T_opt_H
F_H_T=exp(-((TF-T_opt_H)^2/bl_Topt_H));
else
F_H_T=exp(-((TF-T_opt_H)^2/ab_Topt_H));
end

if S_m<S_opt_A || S_m==S_opt_A
F_A_S_m=exp(-((S_m-S_opt_A)^2/bl_Sopt_A));
else
F_A_S_m=exp(-((S_m-S_opt_A)^2/ab_Sopt_A));
end

if S_m<S_opt_H || S_m==S_opt_H
F_H_S_m=exp(-((S_m-S_opt_H)^2/bl_Sopt_H));
else
F_H_S_m=exp(-((S_m-S_opt_H)^2/ab_Sopt_H));
end

dV_j_1=((1/(1+exp(TF-T_hs)))-(1/(1+exp(TF-T_cs))))*beta*V_a-mu_V*V_j-delta_V_j*V_j;
dV_a_1=mu_V*V_j-delta_V_a*V_a;
dO_1=PI-(TF/T_decay)*delta_O*O+delta_V_j*V_j+delta_V_a*V_a;
dD_1=(TF/T_decay)*(delta_O*O+sigma*V_j+sigma*V_a)-(mu_H*H*D);
dH_1=C*gamma_H*H*D*(1-(H/H_max))*(F_H_T*F_H_S_m)-delta_H*H;
dA_1=gamma_A*H*(F_A_T*F_A_S_m)-delta_A*A;
dC_1=(alpha*A*V_a+phi_A*A)*(1-(H/H_max))-delta_C*C;
dS_1=alpha_h*(S+I+R)+delta_R*R-epsilon*S*A-omega*S;
dI_1=epsilon*S*A-rho*I-kappa*I-omega*I;
dR_1=rho*I-delta_R*R-omega*R;

dV_j_2=((1/(1+exp(TF-T_hs)))-(1/(1+exp(TF-T_cs))))*beta*V_a-mu_V*V_j-delta_V_j*V_j;
dV_a_2=mu_V*V_j-delta_V_a*V_a;
dO_2=PI-(TF/T_decay)*delta_O*O+delta_V_j*V_j+delta_V_a*V_a;
dD_2=(TF/T_decay)*(delta_O*O+sigma*V_j+sigma*V_a)-(mu_H*H*D);
dH_2=C*gamma_H*H*D*(1-(H/H_max))*(F_H_T*F_H_S_m)-delta_H*H;
dA_2=gamma_A*H*(F_A_T*F_A_S_m)-delta_A*A;
dC_2=(alpha*A*V_a+phi_A*A)*(1-(H/H_max))-delta_C*C;
dS_2=alpha_h*(S+I+R)+delta_R*R-epsilon*S*A-omega*S;
dI_2=epsilon*S*A-rho*I-kappa*I-omega*I;
dR_2=rho*I-delta_R*R-omega*R;

dM5_SF2_2_1=[dV_j_1;dV_a_1;dO_1;dD_1;dH_1;dA_1;dC_1;dS_1;dI_1;dR_1;dV_j_2;dV_a_2;dO_2;dD_2;dH_2;dA_2;dC_2;dS_2;dI_2;dR_2];
end


%% Patch Model for undefined 
% prompt = "How many rows of patches are there? ";
% patch_rows = input(prompt);
% prompt = "How many columns of patches are there? ";
% patch_columns = input(prompt);

% total_patches=patch_rows*patch_columns;

%set initial conditions
% ICs=zeros(total_patches*3,1); %S is every 3rd row starting at row 1, ...
% I every 3rd row starting at row 2, R every 3rd row starting at row 3,
% every 3 rows a new patch is started
% for cntr=1:3:total_patches*3
% prompt = ("Initial Susceptible in patch "+num2str((cntr-1)/3+1)+"? ");
% ICs(cntr,1)=input(prompt);
% prompt = ("Initial Infected in patch "+num2str((cntr-1)/3+1)+"? ");
% ICs(cntr+1,1)=input(prompt);
% prompt = ("Initial Recovered in patch "+num2str((cntr-1)/3+1)+"? ");
% ICs(cntr+2,1)=input(prompt);
% end

%set initial betas
% betas=zeros(total_patches*total_patches+1,1);


% % for totp2=1:total_patches
% %     for totp1=1:total_patches
% %         if totp1==totp2
% %                 prompt = "What is the infection rate within patch "+num2str(totp1)+"? ";
% %                 betas(totp1,1)=input(prompt);
% %             else
% %                 prompt = "What is the infection rate between patch "+num2str(totp1)+"and patch" +num2str(totp2)+"? ";
% %                 betas(totp1*totp2,1)=input(prompt);
% % 
% %         end
% %     end
% % end

%%

function dSIR_MAL = SIR_MAL(t,a,params)
S_H = a(1); I_H = a(2); R_H = a(3);
S_M = a(4); I_M = a(5); 
PI=params(1); beta_HM=params(2); mu_H=params(3);
delta=params(4); alpha=params(5); omega=params(6);
GAM=params(7); beta_MH=params(8); mu_M=params(9);

dS_H=PI-beta_HM*S_H*I_M-mu_H*S_H;
dI_H=beta_HM*S_H*I_M+delta*I_H-alpha*I_H-omega*I_H-mu_H*I_H;
dR_H=omega*I_H-mu_H*R_H;

dS_M=GAM-beta_MH*S_M*I_H-mu_M*S_M;
dI_M=beta_MH*S_M*I_H-mu_M*I_M;

dSIR_MAL=[dS_H;dI_H;dR_H;dS_M;dI_M];
end


function dSIRS_2patch = SIRS_2patch(t,a,params)
S_1 = a(1); I_1 = a(2); R_1 = a(3);
S_2 = a(4); I_2 = a(5); R_2 = a(6); 
theta_S_1_2=params(1); theta_S_2_1=params(2); theta_I_1_2=params(3); theta_I_2_1=params(4);
theta_R_1_2=params(5); theta_R_2_1=params(6); beta_1_1=params(7); 
beta_1_2=params(8); beta_2_2=params(9); beta_2_1=params(10);
gamma=params(11); delta=params(12);

dS_1=S_2*theta_S_2_1-S_1*theta_S_1_2-beta_1_1*S_1*I_1-beta_1_2*S_1*I_2+delta*R_1;
dI_1=I_2*theta_I_2_1-I_1*theta_I_1_2+beta_1_1*S_1*I_1+beta_1_2*S_1*I_2-gamma*I_1;
dR_1=R_2*theta_R_2_1-R_1*theta_R_1_2+gamma*I_1;

dS_2=S_1*theta_S_1_2-S_2*theta_S_2_1-beta_2_2*S_2*I_2-beta_2_1*S_2*I_1+delta*R_2;
dI_2=I_1*theta_I_1_2-I_2*theta_I_2_1+beta_2_2*S_2*I_2+beta_1_2*S_2*I_1-gamma*I_2;
dR_2=R_1*theta_R_1_2-R_2*theta_R_2_1+gamma*I_2;

dSIRS_2patch=[dS_1;dI_1;dR_1;dS_2;dI_2;dR_2];
end

