%% mechanistic models of valley fever
%Built by Trevor Reckell
%debugged using Claude Opus
% models of coccidioidomycosis in arizona. each successive model adds one
% mechanism. set choose_model below to run a section.
%
% choose_model==0 : population model, used by all others
% choose_model==1 : model 1, fungal growth on decayed organic matter
% choose_model==2 : model 2, adds arthroconidia and an exposed compartment
% choose_model==3 : model 3, adds temperature and soil moisture forcing
% choose_model==4 : model 4a, adds the wildlife reservoir
% choose_model==5 : model 4b, adds Q10 decay and an asymptomatic compartment
% choose_model==8 : modified diebold-mariano forecast comparison
% choose_model==9 : plot full-sample fits, all models and baselines
% choose_model==10: plot expanding-window forecasts
%

global choose_model single_run_or_fitting Region
if exist('AUTO_CHAIN_MODE','var') && ~isempty(AUTO_CHAIN_MODE)
    single_run_or_fitting = AUTO_CHAIN_MODE;   % set by the auto-chain block
    AUTO_CHAIN_MODE = [];   % consume it, so no recursion
else
    single_run_or_fitting=2;
end

% select model/section you want to run
choose_model=3;   % model 4a is 4, model 4b is 5

% iF SINGLE RUN PUT 1-must enter parameters within section
% iF FITTING PUT 2,
% iF FORECATING PUT 3, - must enter options=optionsslow2 for method 1,
% options=optionsslow2 for method 2 within section
single_run_or_fitting=2;

Region=3;   % 1=AZ, 2=Maricopa, 3=Pima, 4=Pinal

% warning('off', 'MATLAB:ode45:IntegrationTolNotMet');
% warning('off', 'MATLAB:ode15s:IntegrationTolNotMet');
% warning('off', 'MATLAB:ode23:IntegrationTolNotMet');
% warning('off', 'MATLAB:ode23s:IntegrationTolNotMet');
% warning('off', 'MATLAB:ode78:IntegrationTolNotMet');
% warning('off', 'MATLAB:ode15i:IntegrationTolNotMet');
warning('off','all');

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

y_pop_data_Maricopa=[3912523,3944859,4094842,4174423,4258019,4307033,4405306,4492261,4420568,4500147,4586431,4585871];
 y_pop_data_Pinal=[389237,392627,400229,409058,420111,432159,444369,457288,462789,480299,503184,516263];
 y_pop_data_AZ=[6594981,6634984,6733840,6832810,6944767,7048088,7158024,7275070,7151502,7272499,7366720,7431344];
 y_pop_data_Pima=[996046.5,998668,1005699,1012028,1018638,1024476,1030517,1036290,1043433,1051707,1063162,1063993];
    t_pop_data=[0,181, 546, 911,1277,1642,2007,2372,2647,3103,3468,3833];

if choose_model==0
%% model 0 - Population Model
% function for Model 0 the population model used in all other models
% population Model :used in all other models

if single_run_or_fitting==1
% sINGLE RUN
disp('Running Model 0 single parameter run')
global alpha_h_Maricopa omega_Maricopa c_Maricopa alpha_h_Pinal omega_Pinal c_Pinal alpha_h_Pima omega_Pima c_Pima alpha_h_AZ omega_AZ c_AZ
% omega from vital statistics (~0.009/yr deaths + ~0.012/yr out-migration).
% it cancels in pop_fit_3 so it was never estimated; the previous values
% (3.3-4.8/yr) capped the sojourn in every compartment at ~3 months.
% alpha_h_fit and N_max are unchanged, so N(t) is bit-for-bit identical.
omega_vital = 0.021/365;
alpha_h_Maricopa = 0.000500942192598 + omega_vital; omega_Maricopa = omega_vital; c_Maricopa = 0.000500942192598/4724819.974562017247081;
alpha_h_Pinal    = 0.000076238824090 + omega_vital; omega_Pinal    = omega_vital; c_Pinal    = 0.000076238824090/5162630.000;
alpha_h_Pima     = 0.000019432499300 + omega_vital; omega_Pima     = omega_vital; c_Pima     = 0.000019432499300/10639930.00;
alpha_h_AZ       = 0.000304888503016 + omega_vital; omega_AZ       = omega_vital; c_AZ       = 0.000304888503016/7853513.125630123540759;

% define the initial condition and time span
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
% xticks([0,365,365*2,365*3])%,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
ylim([min(y_pop_data)-1000 max(y_pop_data)+1000])
hold off

elseif single_run_or_fitting==2
% fITTING
disp('Running Model 0 fitting')

% y_pop_data_Maricopa=[4018657;4425315;4585871;4673096];
% y_pop_data_Pinal=[394200;425264;484239;513862];
% y_pop_data_Pima=[1024000;1043433;1063162;1080149];
% y_pop_data_AZ=[6849647;7151502;7431344;7582384];
% t_pop_data=[1006-1006,3653-1006,4839-1006,5205-1006];

if Region==1
    y_inf_data=y_inf_data_AZ; y_pop_data=y_pop_data_AZ;
alpha_h_b=alpha_h_AZ; omega_b=omega_AZ; c=c_AZ;
county_M0=["AZ"]; county=1;
elseif Region==2
    y_inf_data=y_inf_data_Maricopa; y_pop_data=y_pop_data_Maricopa;
alpha_h_b=alpha_h_Maricopa; omega_b=omega_Maricopa; c=c_Maricopa; 
county_M0=["MARICOPA"]; county=2;
elseif Region==3
    y_inf_data=y_inf_data_Pima; y_pop_data=y_pop_data_Pima;
alpha_h_b=alpha_h_Pima; omega_b=omega_Pima; c=c_Pima;
county_M0=["PIMA"]; county=3;
elseif Region==4
     y_inf_data=y_inf_data_Pinal; y_pop_data=y_pop_data_Pinal;
alpha_h_b=alpha_h_Pinal; omega_b=omega_Pinal; c=c_Pinal;
county_M0=["PINAL"]; county=4;
else
    error('No Region Selected!');
end

    y0 = y_pop_data(1);
    tspan = t_pop_data;   % time points for ODE solution

% optimization options
% options = optimoptions('fmincon', 'Algorithm', 'sqp', 'Display', 'iter');
    options = optimset('Algorithm','interior-point','TolX',1e-20,'TolFun',1e-20,'TolCon'...
    ,1e-20,'MaxIter',200000,'MaxFunEvals',100000);
% set bounds for p (e.g., must be positive)

% alpha_h            % Omega         % Alpha_h             % Omega
    LB(1) = 0;      LB(2) = 0;   % LB(1) = 0.011;       LB(2) = 0.0075;
    UB(1) = 0.01;            UB(2) = 0.05;   % UB(1) = 0.15;     UB(2) = 0.1;

% alpha_h            % Omega         % N_max
    lb(1) = 0;          lb(2) = 0.003;    lb(3) = max(y_pop_data);               
    ub(1) = 0.02;       ub(2) = 0.013;       ub(3) = 10*max(y_pop_data); 

% initial guess for parameter p
    p0 = [UB'];
% p0 = [LB(1);LB(2);UB(3)];

% run optimization
    disp('fmincon')
% params_Fmin=p_opt
    disp('pswarm')

    pool = gcp;   % create a pool if none exists
numWorkers = pool.NumWorkers;
disp(numWorkers);
pctRunOnAll warning('off', 'all');
format long

     options = optimoptions('particleswarm', ...
    'UseParallel', true, ... 
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*100, ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 120, ... 
    'InertiaRange', [0.7, 1.2], ...
    'SelfAdjustmentWeight', 2.5, ...
    'SocialAdjustmentWeight', 0.8, ...
    'HybridFcn', @fmincon, ...
    'FunctionTolerance', 1e-10, ...   % 1e-15
    'Display', 'iter');

% display optimized parameters
% fprintf('Optimized alpha_h: %.8f, omega: %.8f\n, N_max: %.8f\n', p_opt(1), p_opt(2),p_opt(3));
% fprintf('Params1: %.15f, omega: %.15f\n',params_pop_1(1), params_pop_1(2));
% fprintf('Params2: %.15f, omega: %.15f\n',params_pop_2(1), params_pop_2(2), params_pop_2(3));

% fprintf('Params3: %.15f, omega: %.15f\n',params_pop_3(1), params_pop_3(2), params_pop_3(3));
     param_Maricopa=[0.000500942192598;0.009093982014202;4724819.974562017247081];
     param_Pima=[0.000019432499300;0.011779189791583;10639930.00];
     param_Pinal=[0.000076238824090;0.013000000;5162630.000];
     param_AZ=[0.000304888503016;0.012996549609670;7853513.125630123540759];
t_pop_data_m=[0,181,365,546,730,911,1277,1642,2007,2372,2647,3103,3468,3833];
% [t, yfmincon] = ode23s(@(t, Y) pop_fit(t, Y, params_Fmin),t_pop_data, y0);
% [t, ypswarm] = ode15s(@(t, Y) pop_fit(t, Y, params_pop_1),t_pop_data, y0);
% [t, ypswarm2] = ode15s(@(t, Y) pop_fit_2(t, Y, params_pop_2),t_pop_data, y0);
[t, ypswarm3] = ode15s(@(t, Y) pop_fit_3(t, Y, param_Maricopa),t_pop_data_m, y0);
ypswarm3

fprintf('%.8f;',ypswarm3(1),ypswarm3(3), ypswarm3(5));
% ypswarm3(1)
% ypswarm3(3)
% ypswarm3(5)
y0_pop_Maricopa=[3912523.00000000;4026046.06998621;4126667.22977147];
y0_pop_Pima=[996046.50000000;1002474.62257662;1008948.23365715];
y0_pop_Pinal=[389237.00000000;399411.32065617;409817.20645925];
y0_pop_AZ=[6594981.00000000;6706816.93967093;6810644.14509173];

figure
scatter(t_pop_data,y_pop_data, 'b','LineWidth',2)
hold on
% plot(t,ypswarm,'c','LineWidth',5)
% plot(t,ypswarm2,'k','LineWidth',4)
plot(t,ypswarm3,'r','LineWidth',2)
legend('True','predicted pop 3','Location','best');
title("Human growth Model", 'FontSize', 24)
% subtitle("FMin RRMSE="+errorOBJ+", PSwarm="+errorOBJ2, 'FontSize', 14)
subtitle(" 3 rrmse="+errorOBJ3, 'FontSize', 14)
% xticks([0,365,365*2,365*3])%,365*4,365*5,365*6,365*7,365*8,365*9,365*10])
ylim([min(y_pop_data)-1000 max(y_pop_data)+1000])
hold off

Az_oldpop_RRMSE= 0.004505473221184;   % 45262
pima_oldpop_RRMSE=0.003324714217078;
pinal_oldpop_RRMSE=0.019345210756450;
maricopa_oldpop_RRMSE=0.001290484348328;

global alpha_h_Maricopa omega_Maricopa c_Maricopa alpha_h_Pinal omega_Pinal c_Pinal alpha_h_Pima omega_Pima c_Pima alpha_h_AZ omega_AZ c_AZ
% omega from vital statistics (~0.009/yr deaths + ~0.012/yr out-migration).
% it cancels in pop_fit_3 so it was never estimated; the previous values
% (3.3-4.8/yr) capped the sojourn in every compartment at ~3 months.
% alpha_h_fit and N_max are unchanged, so N(t) is bit-for-bit identical.
omega_vital = 0.021/365;
alpha_h_Maricopa = 0.000500942192598 + omega_vital; omega_Maricopa = omega_vital; c_Maricopa = 0.000500942192598/4724819.974562017247081;
alpha_h_Pinal    = 0.000076238824090 + omega_vital; omega_Pinal    = omega_vital; c_Pinal    = 0.000076238824090/5162630.000;
alpha_h_Pima     = 0.000019432499300 + omega_vital; omega_Pima     = omega_vital; c_Pima     = 0.000019432499300/10639930.00;
alpha_h_AZ       = 0.000304888503016 + omega_vital; omega_AZ       = omega_vital; c_AZ       = 0.000304888503016/7853513.125630123540759;

end

% params3: 0.000011776843640, omega: 0.011749358455646
% params3: 10801490.000000000000000

% oMEGA 99% to 10

elseif choose_model==1
%% model 1 - Simple Fungal Growth Model dependent on Food
global alpha_h_Maricopa omega_Maricopa c_Maricopa alpha_h_Pinal omega_Pinal c_Pinal alpha_h_Pima omega_Pima c_Pima alpha_h_AZ omega_AZ c_AZ
global logIdx_active
omega_vital = 0.021/365;
alpha_h_Maricopa = 0.000500942192598 + omega_vital; omega_Maricopa = omega_vital; c_Maricopa = 0.000500942192598/4724819.974562017247081;
alpha_h_Pinal    = 0.000076238824090 + omega_vital; omega_Pinal    = omega_vital; c_Pinal    = 0.000076238824090/5162630.000;
alpha_h_Pima     = 0.000019432499300 + omega_vital; omega_Pima     = omega_vital; c_Pima     = 0.000019432499300/10639930.00;
alpha_h_AZ       = 0.000304888503016 + omega_vital; omega_AZ       = omega_vital; c_AZ       = 0.000304888503016/7853513.125630123540759;

if Region==1
    y_inf_data=y_inf_data_AZ; y_pop_data=y_pop_data_AZ;
    alpha_h_b=alpha_h_AZ; omega_b=omega_AZ; c=c_AZ;
    county_M1=["AZ"]; county=1;
elseif Region==2
    y_inf_data=y_inf_data_Maricopa; y_pop_data=y_pop_data_Maricopa;
    alpha_h_b=alpha_h_Maricopa; omega_b=omega_Maricopa; c=c_Maricopa;
    county_M1=["MARICOPA"]; county=2;
elseif Region==3
    y_inf_data=y_inf_data_Pima; y_pop_data=y_pop_data_Pima;
    alpha_h_b=alpha_h_Pima; omega_b=omega_Pima; c=c_Pima;
    county_M1=["PIMA"]; county=3;
elseif Region==4
    y_inf_data=y_inf_data_Pinal; y_pop_data=y_pop_data_Pinal;
    alpha_h_b=alpha_h_Pinal; omega_b=omega_Pinal; c=c_Pinal;
    county_M1=["PINAL"]; county=4;
else
    error('No Region Selected!');
end
County_M1 = county_M1;   % old capitalisation kept as an alias
total_pop_t0 = y_pop_data(1);
nMonths = 132;   % monthly intervals compared, matches M5

%% ======================================================================
if single_run_or_fitting==1
% sINGLE RUN
% reads it, and included delta_O and delta_R which M1_SF_T does not use.
% order below matches M1_SF_T exactly, and the demography uses the region
% globals so the output is on a realistic scale.
disp(['Running Model 1 single parameter run, Region: ',num2str(Region)])

O_v=200;         mu_H_v=0.001;      gamma_H_v=0.0005;
H_max_v=400;     delta_H_v=0.01;    alpha_h_v=alpha_h_b;
epsilon_v=2.0e-8; omega_v=omega_b;  rho_v=1/90;
kappa_v=2.0e-4;  delta_D_v=0.001;   c_v=c;

% ORDER: O, mu_H, gamma_H, H_max, delta_H, alpha_h, epsilon, omega, rho, kappa, delta_D, c
m1_paramlist=[O_v; mu_H_v; gamma_H_v; H_max_v; delta_H_v; alpha_h_v; ...
              epsilon_v; omega_v; rho_v; kappa_v; delta_D_v; c_v];

ic_D=70;  ic_H=200;
ic_I=y_inf_data(1);  ic_R=ic_I/2;
ic_S=total_pop_t0-ic_I-ic_R;   % n(0) = total_pop_t0, matches dS
y0=[ic_D;ic_H;ic_S;ic_I;ic_R];

t_day=(t_inf_data(1):1:t_inf_data(nMonths+1))';
[t,y]=ode15s(@(tt,yy) M1_SF_T(tt,yy,m1_paramlist), t_day, y0, odeset('MaxStep',1));

figure
plot(t/365,y(:,1),'LineWidth',2); hold on; plot(t/365,y(:,2),'LineWidth',2)
legend('Decayed Organic Matter D','Hyphae H','Location','best');
title("Model 1 single run - fungal compartments", 'FontSize', 16)
xlabel('Year','FontSize',13); grid on; hold off

figure
plot(t/365,y(:,3),'LineWidth',2); hold on
plot(t/365,y(:,4),'LineWidth',2); plot(t/365,y(:,5),'LineWidth',2)
legend('Susceptible','Infected','Recovered','Location','best');
title("Model 1 single run - human compartments", 'FontSize', 16)
xlabel('Year','FontSize',13); ylabel('Humans','FontSize',13); grid on; hold off

% incidence flux -- the quantity the objective actually compares
flux_d=epsilon_v*y(:,3).*y(:,2);
cf=cumtrapz(t,flux_d);
im=round(t_inf_data(1:nMonths+1)-t_inf_data(1))+1;
mmon=diff(cf(im));
figure
scatter(t_inf_data(1:nMonths),y_inf_data(1:nMonths),28,'k','filled'); hold on
plot(t_inf_data(1:nMonths),mmon,'LineWidth',2.5)
legend(county_M1+' reported','Model 1 monthly incidence','Location','best');
title("Model 1 single run - monthly incidence vs data", 'FontSize', 16)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',13); ylabel('Cases per month','FontSize',13); grid on; hold off
fprintf('single run: N(0)=%.0f  N(end)=%.0f  mean monthly incidence %.1f (data %.1f)\n', ...
        sum(y(1,3:5)), sum(y(end,3:5)), mean(mmon), mean(y_inf_data(1:nMonths)));

elseif single_run_or_fitting==2
% fITTING
disp(['Running Model 1 fitting, Region: ',num2str(Region)])

tspan = t_inf_data(1:nMonths+1);
y_fit = y_inf_data(1:nMonths+1);

% o                      mu_H                     gamma_H
LB(1) = 5;              LB(2) = 0.00000001;      LB(3) = 0.00000001;
UB(1) = 2000;           UB(2) = 0.1;             UB(3) = 0.01;

% h_max                  delta_H
LB(4) = 210;            LB(5) = 0.000001;
UB(4) = 450;            UB(5) = 0.2;
% you can rescale H and compensate in epsilon. Left alone here because
% renormalising H_max would rescale the gamma_H and epsilon bounds too.

% epsilon                delta_D
LB(7) = 0.000000001;    LB(11) = 0.0000001;
UB(7) = 0.00001;        UB(11) = 0.06;

% ic_D                   ic_H
LB(13) = 1;             LB(14) = 1;
UB(13) = 1000;          UB(14) = 1000;

% whitelist is kept explicit so it stays that way if one is ever added.
slack_idx = [1 2 3 4 5 7 11 13 14];
LB(slack_idx) = LB(slack_idx) * 0.7;
UB(slack_idx) = UB(slack_idx) * 1.4;

% rho and kappa appear only in dI and dR, so under an incidence objective
% they reach the flux only through N and are unidentifiable. Set, not fitted.
CFR_corrected = 0.01805;   % <-- Kappa_Estimate!B8
rho_fixed     = 1/90;   % clinical symptomatic duration
Nbar          = mean(y_pop_data);
kappa_fixed   = CFR_corrected*(rho_fixed + omega_b + c*Nbar)/(1-CFR_corrected);

LB(9)  = rho_fixed;            UB(9)  = rho_fixed;   % rho
LB(10) = kappa_fixed;          UB(10) = kappa_fixed;   % kappa
LB(8)  = omega_b*0.99999;      UB(8)  = omega_b*1.00001;   % omega
LB(6)  = omega_b*1.00001;      UB(6)  = alpha_h_b*1.00001;   % alpha_h
LB(12) = c*0.9999;             UB(12) = c*1.0001;   % c

assert(LB(6) >= UB(8), 'net growth can go negative');
assert(all(LB <= UB), 'LB>UB at %s', mat2str(find(LB>UB)));
fprintf('kappa %.4e/day | rho %.4e/day | implied CFR %.3f%%\n', kappa_fixed, rho_fixed, ...
        100*kappa_fixed/(rho_fixed+kappa_fixed+omega_b+c*Nbar));

nAlloc = str2double(getenv('SLURM_CPUS_PER_TASK'));
if isnan(nAlloc) || nAlloc < 1, nAlloc = str2double(getenv('SLURM_CPUS_ON_NODE')); end
if isnan(nAlloc) || nAlloc < 1, nAlloc = feature('numcores'); end
nWant = max(1, floor(nAlloc));
pool = gcp('nocreate');
if ~isempty(pool) && pool.NumWorkers ~= nWant, delete(pool); pool = []; end
if isempty(pool)
    try
        try
            cl = parcluster('Processes');
        catch
            cl = parcluster('local');
        end
        jid = getenv('SLURM_JOB_ID');
        if ~isempty(jid)
            jsl = fullfile(tempdir, ['mlpool_' jid]);
            if ~exist(jsl,'dir'), mkdir(jsl); end
            cl.JobStorageLocation = jsl;
        end
        cl.NumWorkers = nWant;  pool = parpool(cl, nWant);
    catch ME
        warning('M1:parpoolFailed','parpool failed (%s). Running serial.', ME.message);
        pool = [];
    end
end
if isempty(pool)
    numWorkers = 1;  useParallel = false;
else
    numWorkers = pool.NumWorkers;  useParallel = true;
    pctRunOnAll warning('off', 'all');
end
fprintf('allocated %d | workers %d | parallel %d\n', nWant, numWorkers, useParallel);
format long

nDim   = length(LB);
logIdx = [1 2 3 5 7 11];
assert(all(LB(logIdx) > 0), 'log indices need LB>0: %s', mat2str(logIdx(LB(logIdx)<=0)));
LBt = LB;  UBt = UB;
LBt(logIdx) = log10(LB(logIdx));   UBt(logIdx) = log10(UB(logIdx));
assert(all(isfinite(LBt)) && all(isfinite(UBt)), 'log10 of a non-positive bound');
isLog = false(nDim,1);  isLog(logIdx) = true;
unlog = @(q) q(:).*(~isLog) + (10.^min(q(:),300)).*isLog;
logIdx_active = logIdx;

fminOpts = optimoptions('fmincon','Algorithm','interior-point','UseParallel',useParallel, ...
    'MaxFunctionEvaluations',20000,'OptimalityTolerance',1e-8, ...
    'StepTolerance',1e-10,'FiniteDifferenceStepSize',1e-4,'Display','none');

optionsslow = optimoptions('particleswarm', ...
    'UseParallel', useParallel, ...
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*ceil(100*nDim/numWorkers), ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ...
    'FunctionTolerance', 1e-10, ...
    'InertiaRange', [0.1, 1.2], ...
    'SelfAdjustmentWeight', 1.8, ...
    'SocialAdjustmentWeight', 1.2, ...
    'MinNeighborsFraction', 0.10, ...
    'HybridFcn', {@fmincon, fminOpts}, ...
    'Display', 'final');
options = optionsslow;

nRestarts = 12;
allP = nan(nRestarts,nDim);  allF = inf(nRestarts,1);
for r = 1:nRestarts
    rng(3000 + r);
    [qR,fR] = particleswarm(@(q) objective_functionM1(unlog(q), tspan, total_pop_t0, y_fit), ...
                            nDim, LBt, UBt, options);
    allP(r,:) = unlog(qR)';  allF(r) = fR;
    fprintf('restart %2d/%d: obj = %.6e\n', r, nRestarts, fR);
    save("m1_restarts_" + county_M1 + ".mat", 'allP','allF','r');
end
[errorOBJ, rBest] = min(allF);
params_m1pswarm   = allP(rBest,:)';
fprintf('best %.6e | median %.6e | spread %.2f%%\n', ...
        errorOBJ, median(allF), 100*(max(allF)-min(allF))/min(allF));

% one paren moved: p(end) must be a separate fprintf argument, or sprintf
% absorbs it and the closing "];" never prints
fprintf('params_m1pswarm = [%s%.15f];\n', ...
        sprintf('%.15f; ', params_m1pswarm(1:end-1)), params_m1pswarm(end));

nFree = sum(UB > LB);
fprintf('Region: %s | RRMSE = %.6f | free params: %d of %d\n', ...
        county_M1, errorOBJ, nFree, nDim);
save("params_m1pswarm_" + county_M1 + ".mat", 'params_m1pswarm','LB','UB','errorOBJ');
save("m1_RRMSE_" + county_M1 + ".mat", 'errorOBJ');

p = params_m1pswarm;
[chk, Yf, solvFit, mmon] = objective_functionM1(p, tspan, total_pop_t0, y_fit);
t_d = (tspan(1):1:tspan(end))';
fprintf('fit solver: %-24s | swarm obj %.6f | re-solve obj %.6f\n', ...
        solvFit, errorOBJ, chk);
if abs(chk - errorOBJ) > 1e-6
    warning('M1:objMismatch', ...
        'Re-solve objective %.6f differs from the swarm value %.6f; a different solver may have won on this window.', ...
        chk, errorOBJ);
end
if isempty(mmon), error('M1: all solvers failed on the full window'); end

rrmse      = errorOBJ;
data_mon   = y_inf_data(1:end-1);
n          = numel(data_mon);
k          = sum(UB > LB);
noiseFloor = 100*(std(diff(data_mon,2))/sqrt(6))/mean(data_mon);

r    = data_mon(:) - mmon(:);
nIC  = numel(r);
rss  = sum(r.^2);
p    = k + 1;
logL = -nIC/2 * ( log(2*pi) + log(rss/nIC) + 1 );
aic  = -2*logL + 2*p;
if nIC - p - 1 > 0
    aicc = aic + 2*p*(p+1)/(nIC - p - 1);
else
    aicc = NaN;
end
bic  = -2*logL + p*log(nIC);
fprintf('\nModel 1 information criteria (Gaussian least squares)\n');
fprintf('  n = %d | free structural k = %d | p = k+1 = %d\n', nIC, k, p);
fprintf('  RRMSE  : %.6f\n', sqrt(mean(r.^2))/mean(data_mon));
fprintf('  RSS    : %.4f\n', rss);
fprintf('  logL   : %.4f\n', logL);
fprintf('  AIC    : %.4f\n', aic);
fprintf('  AICc   : %.4f\n', aicc);
fprintf('  BIC    : %.4f\n', bic);
aic
aicc
bic

fprintf('  RRMSE reported by the swarm : %.6f  (noise floor %.4f)\n', rrmse, noiseFloor/100);

ICnb = nb_ic(data_mon, max(mmon(:),1e-6), k, "Model 1 " + county_M1);
aic_gauss = aic;  aicc_gauss = aicc;  bic_gauss = bic;
aic = ICnb.aic;  aicc = ICnb.aicc;  bic = ICnb.bic;
save("m1_IC_" + county_M1 + ".mat", 'ICnb','n','k','rrmse','aic','aicc','bic','aic_gauss','aicc_gauss','bic_gauss','noiseFloor');

if isempty(mmon), error('M1: all solvers failed on the full window'); end

figure
scatter(t_inf_data(1:nMonths), data_mon, 30, 'k', 'filled'); hold on
plot(t_inf_data(1:nMonths), mmon, 'LineWidth', 3, 'Color', [0 0 1 0.5]);
legend(county_M1+' reported','Model 1 fit','Location','northwest');
title(county_M1+" Valley Fever - Model 1 monthly incidence fit", 'FontSize', 16)
subtitle(sprintf('RRMSE %.2f%%  (noise floor %.2f%%)  |  AIC %.1f  BIC %.1f', ...
         rrmse*100, noiseFloor, aic, bic), 'FontSize', 11)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',13); ylabel('Cases per month','FontSize',13)
ylim([0, max(data_mon)*1.25]); grid on; hold off

figure
plot(t_d/365, Yf(:,1), 'LineWidth', 2); hold on; plot(t_d/365, Yf(:,2), 'LineWidth', 2)
legend('Decayed Organic Matter D','Hyphae H','Location','best'); grid on
title("Model 1 fitted fungal compartments", 'FontSize', 15); xlabel('Year','FontSize',13); hold off

AUTO_FORECAST = false;   % <-- set false to stop after fitting
if AUTO_FORECAST
    fprintf('\n auto-chaining into Model 1 forecasting, %s =====\n', county_M1);
    AUTO_CHAIN_MODE = 3;
    Mechanistic_Model_Valley_Fever_07_31_26;   % re-enter in forecast mode
end

elseif single_run_or_fitting==3
% fORECASTING
% fit nFit months, forecast the next 12. The three solverChain matching
% loops are replaced by one daily solve per horizon, and error is measured
% on monthly incidence so it is comparable to the fit and to M5.
disp(['Running Model 1 Forecasting, Region: ',num2str(Region)])

LB(1) = 5;              LB(2) = 0.00000001;      LB(3) = 0.00000001;
UB(1) = 2000;           UB(2) = 0.1;             UB(3) = 0.01;
LB(4) = 210;            LB(5) = 0.000001;
UB(4) = 450;            UB(5) = 0.2;
LB(7) = 0.000000001;    LB(11) = 0.0000001;
UB(7) = 0.00001;        UB(11) = 0.06;
LB(13) = 1;             LB(14) = 1;
UB(13) = 1000;          UB(14) = 1000;
slack_idx = [1 2 3 4 5 7 11 13 14];
LB(slack_idx) = LB(slack_idx) * 0.7;
UB(slack_idx) = UB(slack_idx) * 1.4;

CFR_corrected = 0.01805;
rho_fixed     = 1/90;
Nbar          = mean(y_pop_data);
kappa_fixed   = CFR_corrected*(rho_fixed + omega_b + c*Nbar)/(1-CFR_corrected);
LB(9)  = rho_fixed;        UB(9)  = rho_fixed;
LB(10) = kappa_fixed;      UB(10) = kappa_fixed;
LB(8)  = omega_b*0.99999;  UB(8)  = omega_b*1.00001;
LB(6)  = omega_b*1.00001;  UB(6)  = alpha_h_b*1.00001;
LB(12) = c*0.9999;         UB(12) = c*1.0001;
assert(LB(6) >= UB(8), 'net growth can go negative');
assert(all(LB <= UB), 'LB>UB at %s', mat2str(find(LB>UB)));

nAlloc = str2double(getenv('SLURM_CPUS_PER_TASK'));
if isnan(nAlloc) || nAlloc < 1, nAlloc = str2double(getenv('SLURM_CPUS_ON_NODE')); end
if isnan(nAlloc) || nAlloc < 1, nAlloc = feature('numcores'); end
nWant = max(1, floor(nAlloc));
pool = gcp('nocreate');
if ~isempty(pool) && pool.NumWorkers ~= nWant, delete(pool); pool = []; end
if isempty(pool)
    try
        try
            cl = parcluster('Processes');
        catch
            cl = parcluster('local');
        end
        jid = getenv('SLURM_JOB_ID');
        if ~isempty(jid)
            jsl = fullfile(tempdir, ['mlpool_' jid]);
            if ~exist(jsl,'dir'), mkdir(jsl); end
            cl.JobStorageLocation = jsl;
        end
        cl.NumWorkers = nWant;  pool = parpool(cl, nWant);
    catch ME
        warning('M1:parpoolFailed','parpool failed (%s). Running serial.', ME.message);
        pool = [];
    end
end
if isempty(pool)
    numWorkers = 1;  useParallel = false;
else
    numWorkers = pool.NumWorkers;  useParallel = true;
    pctRunOnAll warning('off', 'all');
end
fprintf('allocated %d | workers %d | parallel %d\n', nWant, numWorkers, useParallel);
format long

nDim   = length(LB);
logIdx = [1 2 3 5 7 11];
assert(all(LB(logIdx) > 0), 'log indices need LB>0');
LBt = LB;  UBt = UB;
LBt(logIdx) = log10(LB(logIdx));   UBt(logIdx) = log10(UB(logIdx));
isLog = false(nDim,1);  isLog(logIdx) = true;
unlog = @(q) q(:).*(~isLog) + (10.^min(q(:),300)).*isLog;
logIdx_active = logIdx;

fminOpts = optimoptions('fmincon','Algorithm','interior-point','UseParallel',useParallel, ...
    'MaxFunctionEvaluations',20000,'OptimalityTolerance',1e-8, ...
    'StepTolerance',1e-10,'FiniteDifferenceStepSize',1e-4,'Display','none');
optionsslow = optimoptions('particleswarm', ...
    'UseParallel', useParallel, ...
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*ceil(80*nDim/numWorkers), ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ...
    'FunctionTolerance', 1e-8, ...
    'InertiaRange', [0.1, 1.2], ...
    'SelfAdjustmentWeight', 1.8, ...
    'SocialAdjustmentWeight', 1.2, ...
    'MinNeighborsFraction', 0.10, ...
    'HybridFcn', {@fmincon, fminOpts}, ...
    'Display', 'final');
options=optionsslow;
% prefer this region's full-sample fit. Workspace first (set by the fitting
% section when auto-chaining), then disk, so it also works run standalone.
params_op = [];
if exist('params_m1pswarm','var') && numel(params_m1pswarm)==nDim
    params_op = params_m1pswarm(:);
    fprintf('warm start: seeding horizon 1 from the workspace fit\n');
else
    seed_file = "params_m1pswarm_" + county_M1 + ".mat";
    if isfile(seed_file)
        Sd = load(seed_file, 'params_m1pswarm');
        if isfield(Sd,'params_m1pswarm') && numel(Sd.params_m1pswarm)==nDim
            params_op = Sd.params_m1pswarm(:);
            fprintf('warm start: seeding horizon 1 from %s\n', seed_file);
        end
    end
end
if isempty(params_op), fprintf('warm start: no usable seed; cold start.\n'); end

% optionsslow2 = optionsslow plus an InitialSwarmMatrix whose first particle
% is the seed, TRANSFORMED INTO LOG SPACE. Seeding in natural units would put
% every particle outside the box and particleswarm would clip them to a corner.
tolog = @(pv) pv(:).*(~isLog) + log10(max(pv(:),realmin)).*isLog;
n_particles = numWorkers*ceil(100*nDim/numWorkers);
make_warm = @(pseed) optimoptions(optionsslow, 'InitialSwarmMatrix', ...
    [ min(max(tolog(pseed)',LBt),UBt) ; ...
      LBt + (UBt - LBt).*rand(n_particles-1, nDim) ]);
seed_h = params_op;
seed_h=params_m1pswarm_AZ;

nFitList  = [96 108 120];
yrLabel   = {'2021','2022','2023'};
nRestarts = 6;
Pfit = cell(3,1);  Ffit = nan(3,1);
for h = 1:3
    nF = nFitList(h);
    tsp_h = t_inf_data(1:nF+1);
    y_h   = y_inf_data(1:nF+1);
    if isempty(seed_h)
        options = optionsslow;
        fprintf('h=%d (%s): cold start\n', h, yrLabel{h});
    else
        options = make_warm(seed_h);
        fprintf('h=%d (%s): warm start from previous best\n', h, yrLabel{h});
    end
    optionsslow2 = options;
    aP = nan(nRestarts,nDim);  aF = inf(nRestarts,1);
    for r = 1:nRestarts
        rng(4000 + 100*h + r);
        [qR,fR] = particleswarm(@(q) objective_functionM1(unlog(q), tsp_h, total_pop_t0, y_h), ...
                                nDim, LBt, UBt, options);
        aP(r,:) = unlog(qR)';  aF(r) = fR;
        fprintf('h=%d (%s) restart %d/%d: obj = %.6e\n', h, yrLabel{h}, r, nRestarts, fR);
        save("m1_FOR_restarts_h" + h + "_" + county_M1 + ".mat", 'aP','aF','r');
    end
    [Ffit(h), rb] = min(aF);
    Pfit{h} = aP(rb,:)';
    seed_h = Pfit{h};   % chain into the next horizon
    fprintf('h=%d best %.6e | median %.6e | spread %.2f%%\n', ...
            h, Ffit(h), median(aF), 100*(max(aF)-min(aF))/min(aF));
    save("params_m1pswarm_FOR_" + nF + "mo_" + county_M1 + ".mat", 'aP','aF','LB','UB');
end
params_m1pswarm_8  = Pfit{1};
params_m1pswarm_9  = Pfit{2};
params_m1pswarm_10 = Pfit{3};

fitRRMSE = nan(3,1);  fcRRMSE = nan(3,1);
fcPers = nan(3,1);  fcSeas = nan(3,1);  fcMean = nan(3,1);
MMON = cell(3,1);  TMON = cell(3,1);  fcResid = cell(3,1);  solvUsed = cell(3,1);
for h = 1:3
    p  = Pfit{h};
    nF = nFitList(h);
    t_m = t_inf_data(1:nF+13);
% through the objective: same solver chain, timeout and integration
    [~, ~, solvUsed{h}, mmon] = objective_functionM1(p, t_m, total_pop_t0, ...
                                    y_inf_data(1:nF+13));
    if isempty(mmon)
        warning('M1:forecastSolveFailed','horizon %d: all solvers failed', h);
        mmon = nan(nF+12,1);
    end
    MMON{h} = mmon;  TMON{h} = t_m(1:nF+12);

    dFit = y_inf_data(1:nF);          rFit = mmon(1:nF)       - dFit;
    dFc  = y_inf_data(nF+1:nF+12);    rFc  = mmon(nF+1:nF+12) - dFc;
    fitRRMSE(h) = 100*sqrt(mean(rFit.^2))/mean(dFit);
    fcRRMSE(h)  = 100*sqrt(mean(rFc.^2)) /mean(dFc);
    fcResid{h}  = rFc;
    fcPers(h) = 100*sqrt(mean((y_inf_data(nF)          - dFc).^2))/mean(dFc);
    fcSeas(h) = 100*sqrt(mean((y_inf_data(nF-11:nF)    - dFc).^2))/mean(dFc);
    fcMean(h) = 100*sqrt(mean((mean(y_inf_data(1:nF))  - dFc).^2))/mean(dFc);
end

fprintf('params_m1pswarm_8 = [%s%.15f];\n',  sprintf('%.15f; ', params_m1pswarm_8(1:end-1)),  params_m1pswarm_8(end));
fprintf('params_m1pswarm_9 = [%s%.15f];\n',  sprintf('%.15f; ', params_m1pswarm_9(1:end-1)),  params_m1pswarm_9(end));
fprintf('params_m1pswarm_10 = [%s%.15f];\n', sprintf('%.15f; ', params_m1pswarm_10(1:end-1)), params_m1pswarm_10(end));
fprintf('\n%s  Model 1 1-year-ahead forecast, RRMSE = RMSE/mean (%%)\n', county_M1);
fprintf('%-8s %8s %10s %10s %10s %10s\n','year','in-samp','FORECAST','persist','seasonal','trainmean');
for h = 1:3
    fprintf('%-8s %8.2f %10.2f %10.2f %10.2f %10.2f\n', yrLabel{h}, ...
            fitRRMSE(h), fcRRMSE(h), fcPers(h), fcSeas(h), fcMean(h));
end
fprintf('beats best baseline: %s\n', ...
        mat2str(fcRRMSE(:)' < min([fcPers fcSeas fcMean],[],2)'));
for h = 1:3
    fprintf('h=%d (%s): solver %-24s swarm obj %.6f | re-solve fit RRMSE %.4f%%\n', ...
            h, yrLabel{h}, solvUsed{h}, Ffit(h), fitRRMSE(h));
end

frst_year_forecast_rrmse = fcRRMSE(1);
scnd_year_forecast_rrmse = fcRRMSE(2);
thrd_year_forecast_rrmse = fcRRMSE(3);
save("m1_FOR_RRMSE_" + county_M1 + ".mat", 'fitRRMSE','fcRRMSE', ...
     'fcPers','fcSeas','fcMean','fcResid','nFitList','yrLabel');

figure('Position',[80 80 1100 560]);
hObs = scatter(t_inf_data(1:132), y_inf_data(1:132), 32, 'k', 'filled'); hold on
hFit = plot(TMON{1}(1:96), MMON{1}(1:96), 'LineWidth', 5, 'Color', [0 0 1 0.45]);
cols = [0.35 0.70 0.90; 0.00 0.60 0.50; 0.80 0.40 0.00];
hFc  = gobjects(3,1);
for h = 1:3
    nF = nFitList(h);
    hFc(h) = plot(TMON{h}(nF+1:nF+12), MMON{h}(nF+1:nF+12), 'LineWidth', 5, 'Color', cols(h,:));
    xline(t_inf_data(nF+1), 'k', 'LineWidth', 1.5);
end
legend([hObs; hFit; hFc], [{county_M1+' Infected', 'Model 1 fit (first 8 years)'}, ...
       cellfun(@(s) [s ' forecast'], yrLabel, 'UniformOutput', false)], ...
       'FontSize', 12, 'Location','northwest');
title('Forecast of '+county_M1+" Valley Fever Using Model 1", 'FontSize', 18)
subtitle(sprintf('forecast RRMSE  2021 %.1f%%  2022 %.1f%%  2023 %.1f%%   (best naive %.1f / %.1f / %.1f%%)', ...
    fcRRMSE(1), fcRRMSE(2), fcRRMSE(3), ...
    min([fcPers(1) fcSeas(1) fcMean(1)]), min([fcPers(2) fcSeas(2) fcMean(2)]), ...
    min([fcPers(3) fcSeas(3) fcMean(3)])), 'FontSize', 12)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',14); ylabel('New cases per month','FontSize',14)
ylim([0, max(y_inf_data)+200]); grid on; hold off
end

elseif choose_model==2
%% model 2 - Fungal Growth Model dependent on Food
global alpha_h_Maricopa omega_Maricopa c_Maricopa alpha_h_Pinal omega_Pinal c_Pinal alpha_h_Pima omega_Pima c_Pima alpha_h_AZ omega_AZ c_AZ
global logIdx_active
omega_vital = 0.021/365;
alpha_h_Maricopa = 0.000500942192598 + omega_vital; omega_Maricopa = omega_vital; c_Maricopa = 0.000500942192598/4724819.974562017247081;
alpha_h_Pinal    = 0.000076238824090 + omega_vital; omega_Pinal    = omega_vital; c_Pinal    = 0.000076238824090/5162630.000;
alpha_h_Pima     = 0.000019432499300 + omega_vital; omega_Pima     = omega_vital; c_Pima     = 0.000019432499300/10639930.00;
alpha_h_AZ       = 0.000304888503016 + omega_vital; omega_AZ       = omega_vital; c_AZ       = 0.000304888503016/7853513.125630123540759;

if Region==1
    y_inf_data=y_inf_data_AZ; y_pop_data=y_pop_data_AZ;
    alpha_h_b=alpha_h_AZ; omega_b=omega_AZ; c=c_AZ;
    county_M2=["AZ"]; county=1;
elseif Region==2
    y_inf_data=y_inf_data_Maricopa; y_pop_data=y_pop_data_Maricopa;
    alpha_h_b=alpha_h_Maricopa; omega_b=omega_Maricopa; c=c_Maricopa;
    county_M2=["MARICOPA"]; county=2;
elseif Region==3
    y_inf_data=y_inf_data_Pima; y_pop_data=y_pop_data_Pima;
    alpha_h_b=alpha_h_Pima; omega_b=omega_Pima; c=c_Pima;
    county_M2=["PIMA"]; county=3;
elseif Region==4
    y_inf_data=y_inf_data_Pinal; y_pop_data=y_pop_data_Pinal;
    alpha_h_b=alpha_h_Pinal; omega_b=omega_Pinal; c=c_Pinal;
    county_M2=["PINAL"]; county=4;
else
    error('No Region Selected!');
end
total_pop_t0 = y_pop_data(1);
nMonths = 132;
Nbar    = mean(y_pop_data);
drainE  = omega_b + c*Nbar;   % the non-psi drain on E

if single_run_or_fitting==1
% sINGLE RUN
% m2_SF returns 8, and the params vector sent delta_C and delta_R at
% indices 10 and 12, so everything from index 10 on was misassigned --
% c came out 0.02 instead of ~1e-10. Both fixed.
disp(['Running Model 2 single parameter run, Region: ',num2str(Region)])

PI_v=200;        delta_O_v=0.01;    mu_H_v=0.001;
gamma_H_v=0.0005; H_max_v=400;      delta_H_v=0.01;
gamma_A_v=0.01;  delta_A_v=0.05;    phi_A_v=1.0e-6;
alpha_h_v=alpha_h_b;  epsilon_v=1.0e-8;  omega_v=omega_b;
rho_v=1/90;      kappa_v=2.1e-4;    psi_v=1/14;
delta_D_v=0.001; c_v=c;

% oRDER matches M2_SF exactly:
% pI, delta_O, mu_H, gamma_H, H_max, delta_H, gamma_A, delta_A, phi_A,
% alpha_h, epsilon, omega, rho, kappa, psi, delta_D, c
m2_paramlist=[PI_v; delta_O_v; mu_H_v; gamma_H_v; H_max_v; delta_H_v; ...
              gamma_A_v; delta_A_v; phi_A_v; alpha_h_v; epsilon_v; omega_v; ...
              rho_v; kappa_v; psi_v; delta_D_v; c_v];

ic_O=40; ic_D=70; ic_H=100; ic_A=50;
ic_I=y_inf_data(1);  ic_E=ic_I*1.5;  ic_R=ic_I/2;
ic_S=total_pop_t0-ic_I-ic_E-ic_R;   % n(0)=total_pop_t0
y0=[ic_O;ic_D;ic_H;ic_A;ic_S;ic_E;ic_I;ic_R];   % 8 elements, matches M2_SF

t_day=(t_inf_data(1):1:t_inf_data(nMonths+1))';
[t,y]=ode15s(@(tt,yy) M2_SF(tt,yy,m2_paramlist), t_day, y0, odeset('MaxStep',1));

figure
plot(t/365,y(:,1),'LineWidth',2); hold on; plot(t/365,y(:,2),'LineWidth',2)
legend('Organic Matter O','Decayed Organic Matter D','Location','best');
title("Model 2 single run - substrate", 'FontSize', 16)
xlabel('Year','FontSize',13); grid on; hold off

figure
plot(t/365,y(:,3),'LineWidth',2); hold on; plot(t/365,y(:,4),'LineWidth',2)
legend('Hyphae H','Arthroconidia A','Location','best');
title("Model 2 single run - fungal compartments", 'FontSize', 16)
xlabel('Year','FontSize',13); grid on; hold off

figure
plot(t/365,y(:,5),'LineWidth',2); hold on
plot(t/365,y(:,6),'LineWidth',2); plot(t/365,y(:,7),'LineWidth',2); plot(t/365,y(:,8),'LineWidth',2)
legend('Susceptible','Exposed','Infected','Recovered','Location','best');
title("Model 2 single run - human compartments", 'FontSize', 16)
xlabel('Year','FontSize',13); ylabel('Humans','FontSize',13); grid on; hold off

% incidence flux -- the quantity the objective compares
cf=cumtrapz(t, psi_v*y(:,6));
im=round(t_inf_data(1:nMonths+1)-t_inf_data(1))+1;
mmon=diff(cf(im));
figure
scatter(t_inf_data(1:nMonths),y_inf_data(1:nMonths),28,'k','filled'); hold on
plot(t_inf_data(1:nMonths),mmon,'LineWidth',2.5)
legend(county_M2+' reported','Model 2 monthly incidence','Location','best');
title("Model 2 single run - monthly incidence vs data", 'FontSize', 16)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',13); ylabel('Cases per month','FontSize',13); grid on; hold off
fprintf('single run: N(0)=%.0f  N(end)=%.0f  mean monthly incidence %.1f (data %.1f)\n', ...
        sum(y(1,5:8)), sum(y(end,5:8)), mean(mmon), mean(y_inf_data(1:nMonths)));

elseif single_run_or_fitting==2
% fITTING
disp(['Running Model 2 fitting, Region: ',num2str(Region)])

tspan = t_inf_data(1:nMonths+1);
y_fit = y_inf_data(1:nMonths+1);

% pI                     delta_O                  mu_H
LB(1) = 5;              LB(2) = 0.000000001;     LB(3) = 0.0000001;
UB(1) = 2000;           UB(2) = 0.5;             UB(3) = 0.1;

% gamma_H                H_max                    delta_H
LB(4) = 0.00000001;     LB(5) = 210;             LB(6) = 0.000001;
UB(4) = 0.06;           UB(5) = 500;             UB(6) = 0.2;
% forecasting section. Harmonised to 500 in both.
% as in M1 and M5, H and A are unobserved so (H_max, gamma_H, gamma_A,
% epsilon) form a flat direction; left alone rather than renormalised.

% gamma_A                delta_A                  phi_A
LB(7) = 0.0000001;      LB(8) = 0.00000001;      LB(9) = 0.0000000001;
UB(7) = 0.1;            UB(8) = 0.2;             UB(9) = 0.00001;

% epsilon                delta_D
LB(11) = 0.0000000001;  LB(16) = 0.0000001;
UB(11) = 0.00001;       UB(16) = 0.06;

% psi -- 1/psi IS the incubation period for Model 2 (no psi_A), so solve
% psi + drainE = 1/incubation for CDC's 1 to 3 weeks. Was [1/60, 1/5],
% which allowed a 60-day incubation.
assert(drainE < 1/21, 'drainE %.3e exceeds 1/21; psi bounds would invert', drainE);
LB(15) = 1/21 - drainE;
UB(15) = 1/7  - drainE;

% initial conditions
LB(18) = 1;     UB(18) = 1000;   % ic_O
LB(19) = 1;     UB(19) = 1000;   % ic_D
LB(20) = 1;     UB(20) = 500;   % ic_H
LB(21) = 1;     UB(21) = 1000;   % ic_A

% ic_E from the data: E ~ (month-1 cases per day)/psi in quasi-steady state
psi_mid  = 0.5*(LB(15) + UB(15));
ic_E_est = (y_inf_data(1)/31) / psi_mid;
LB(22) = 0.5*ic_E_est;   UB(22) = 2.0*ic_E_est;
% was [1, ic_I*5], about 15x too wide at the top

slack_idx = [1 2 3 4 5 6 7 8 9 11 16 18 19 20 21];
LB(slack_idx) = LB(slack_idx) * 0.7;
UB(slack_idx) = UB(slack_idx) * 1.4;

% rho and kappa appear only in dI and dR, so under an incidence objective
% they reach the flux only through N and are unidentifiable. Set, not fitted.
CFR_corrected = 0.01805;   % <-- Kappa_Estimate!B8
rho_fixed     = 1/90;
kappa_fixed   = CFR_corrected*(rho_fixed + omega_b + c*Nbar)/(1-CFR_corrected);

LB(13) = rho_fixed;        UB(13) = rho_fixed;   % rho
LB(14) = kappa_fixed;      UB(14) = kappa_fixed;   % kappa
LB(12) = omega_b*0.99999;  UB(12) = omega_b*1.00001;   % omega
LB(10) = omega_b*1.00001;  UB(10) = alpha_h_b*1.00001;   % alpha_h
LB(17) = c*0.9999;         UB(17) = c*1.0001;   % c

assert(LB(10) >= UB(12), 'net growth can go negative');
assert(all(LB <= UB), 'LB>UB at %s', mat2str(find(LB>UB)));
fprintf('kappa %.4e/day | rho %.4e/day | psi in [%.5f %.5f] | implied CFR %.3f%%\n', ...
        kappa_fixed, rho_fixed, LB(15), UB(15), ...
        100*kappa_fixed/(rho_fixed+kappa_fixed+omega_b+c*Nbar));

nAlloc = str2double(getenv('SLURM_CPUS_PER_TASK'));
if isnan(nAlloc) || nAlloc < 1, nAlloc = str2double(getenv('SLURM_CPUS_ON_NODE')); end
if isnan(nAlloc) || nAlloc < 1, nAlloc = feature('numcores'); end
nWant = max(1, floor(nAlloc));
pool = gcp('nocreate');
if ~isempty(pool) && pool.NumWorkers ~= nWant, delete(pool); pool = []; end
if isempty(pool)
    try
        try
            cl = parcluster('Processes');
        catch
            cl = parcluster('local');
        end
        jid = getenv('SLURM_JOB_ID');
        if ~isempty(jid)
            jsl = fullfile(tempdir, ['mlpool_' jid]);
            if ~exist(jsl,'dir'), mkdir(jsl); end
            cl.JobStorageLocation = jsl;
        end
        cl.NumWorkers = nWant;  pool = parpool(cl, nWant);
    catch ME
        warning('M2:parpoolFailed','parpool failed (%s). Running serial.', ME.message);
        pool = [];
    end
end
if isempty(pool)
    numWorkers = 1;  useParallel = false;
else
    numWorkers = pool.NumWorkers;  useParallel = true;
    pctRunOnAll warning('off', 'all');
end
fprintf('allocated %d | workers %d | parallel %d\n', nWant, numWorkers, useParallel);
format long

nDim   = length(LB);
logIdx = [1 2 3 4 6 7 8 9 11 16];
assert(all(LB(logIdx) > 0), 'log indices need LB>0: %s', mat2str(logIdx(LB(logIdx)<=0)));
LBt = LB;  UBt = UB;
LBt(logIdx) = log10(LB(logIdx));   UBt(logIdx) = log10(UB(logIdx));
assert(all(isfinite(LBt)) && all(isfinite(UBt)), 'log10 of a non-positive bound');
isLog = false(nDim,1);  isLog(logIdx) = true;
unlog = @(q) q(:).*(~isLog) + (10.^min(q(:),300)).*isLog;
logIdx_active = logIdx;

fminOpts = optimoptions('fmincon','Algorithm','interior-point','UseParallel',useParallel, ...
    'MaxFunctionEvaluations',20000,'OptimalityTolerance',1e-8, ...
    'StepTolerance',1e-10,'FiniteDifferenceStepSize',1e-4,'Display','none');

optionsslow = optimoptions('particleswarm', ...
    'UseParallel', useParallel, ...
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*ceil(100*nDim/numWorkers), ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ...
    'FunctionTolerance', 1e-10, ...
    'InertiaRange', [0.1, 1.2], ...
    'SelfAdjustmentWeight', 1.8, ...
    'SocialAdjustmentWeight', 1.2, ...
    'MinNeighborsFraction', 0.10, ...
    'HybridFcn', {@fmincon, fminOpts}, ...
    'Display', 'final');
options = optionsslow;

nRestarts = 12;
allP = nan(nRestarts,nDim);  allF = inf(nRestarts,1);
for r = 1:nRestarts
    rng(5000 + r);
    [qR,fR] = particleswarm(@(q) objective_functionM2(unlog(q), tspan, total_pop_t0, y_fit), ...
                            nDim, LBt, UBt, options);
    allP(r,:) = unlog(qR)';  allF(r) = fR;
    fprintf('restart %2d/%d: obj = %.6e\n', r, nRestarts, fR);
    save("m2_restarts_" + county_M2 + ".mat", 'allP','allF','r');
end
[errorOBJ, rBest] = min(allF);
params_m2pswarm   = allP(rBest,:)';
fprintf('best %.6e | median %.6e | spread %.2f%%\n', ...
        errorOBJ, median(allF), 100*(max(allF)-min(allF))/min(allF));

% one paren moved: p(end) must be a separate fprintf argument
fprintf('params_m2pswarm = [%s%.15f];\n', ...
        sprintf('%.15f; ', params_m2pswarm(1:end-1)), params_m2pswarm(end));
nFree = sum(UB > LB);
fprintf('Region: %s | RRMSE = %.6f | free params: %d of %d\n', ...
        county_M2, errorOBJ, nFree, nDim);
save("params_m2pswarm_" + county_M2 + ".mat", 'params_m2pswarm','LB','UB','errorOBJ');
save("m2_RRMSE_" + county_M2 + ".mat", 'errorOBJ');

p = params_m2pswarm;
[chk, Yf, solvFit, mmon] = objective_functionM2(p, tspan, total_pop_t0, y_fit);
t_d = (tspan(1):1:tspan(end))';
fprintf('fit solver: %-24s | swarm obj %.6f | re-solve obj %.6f\n', ...
        solvFit, errorOBJ, chk);
if abs(chk - errorOBJ) > 1e-6
    warning('M2:objMismatch', ...
        'Re-solve objective %.6f differs from the swarm value %.6f; a different solver may have won on this window.', ...
        chk, errorOBJ);
end
if isempty(mmon), error('M2: all solvers failed on the full window'); end

rrmse      = errorOBJ;
data_mon   = y_inf_data(1:end-1);
n          = numel(data_mon);
k          = sum(UB > LB);
noiseFloor = 100*(std(diff(data_mon,2))/sqrt(6))/mean(data_mon);

r    = data_mon(:) - mmon(:);
nIC  = numel(r);
rss  = sum(r.^2);
p    = k + 1;
logL = -nIC/2 * ( log(2*pi) + log(rss/nIC) + 1 );
aic  = -2*logL + 2*p;
if nIC - p - 1 > 0
    aicc = aic + 2*p*(p+1)/(nIC - p - 1);
else
    aicc = NaN;
end
bic  = -2*logL + p*log(nIC);
fprintf('\nModel 2 information criteria (Gaussian least squares)\n');
fprintf('  n = %d | free structural k = %d | p = k+1 = %d\n', nIC, k, p);
fprintf('  RRMSE  : %.6f\n', sqrt(mean(r.^2))/mean(data_mon));
fprintf('  RSS    : %.4f\n', rss);
fprintf('  logL   : %.4f\n', logL);
fprintf('  AIC    : %.4f\n', aic);
fprintf('  AICc   : %.4f\n', aicc);
fprintf('  BIC    : %.4f\n', bic);
aic
aicc
bic

fprintf('  RRMSE reported by the swarm : %.6f  (noise floor %.4f)\n', rrmse, noiseFloor/100);
ICnb = nb_ic(data_mon, max(mmon(:),1e-6), k, "Model 2 " + county_M2);
aic_gauss = aic;  aicc_gauss = aicc;  bic_gauss = bic;
aic = ICnb.aic;  aicc = ICnb.aicc;  bic = ICnb.bic;
save("m2_IC_" + county_M2 + ".mat", 'ICnb','n','k','rrmse','aic','aicc','bic','aic_gauss','aicc_gauss','bic_gauss','noiseFloor');

if isempty(mmon), error('M2: all solvers failed on the full window'); end

figure
scatter(t_inf_data(1:nMonths), data_mon, 30, 'k', 'filled'); hold on
plot(t_inf_data(1:nMonths), mmon, 'LineWidth', 3, 'Color', [0 0 1 0.5]);
legend(county_M2+' reported','Model 2 fit','Location','northwest');
title(county_M2+" Valley Fever - Model 2 monthly incidence fit", 'FontSize', 16)
subtitle(sprintf('RRMSE %.2f%%  (noise floor %.2f%%)  |  AIC %.1f  BIC %.1f', ...
         rrmse*100, noiseFloor, aic, bic), 'FontSize', 11)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',13); ylabel('Cases per month','FontSize',13)
ylim([0, max(data_mon)*1.25]); grid on; hold off

figure
plot(t_d/365, Yf(:,1), 'LineWidth', 2); hold on
plot(t_d/365, Yf(:,2), 'LineWidth', 2)
plot(t_d/365, Yf(:,3), 'LineWidth', 2); plot(t_d/365, Yf(:,4), 'LineWidth', 2)
legend('Organic Matter O','Decayed D','Hyphae H','Arthroconidia A','Location','best')
title("Model 2 fitted substrate and fungal compartments", 'FontSize', 15)
xlabel('Year','FontSize',13); grid on; hold off

AUTO_FORECAST = true;   % <-- set false to stop after fitting
if AUTO_FORECAST
    fprintf('\n===== auto-chaining into Model 2 forecasting, %s =====\n', county_M2);
    AUTO_CHAIN_MODE = 3;
    Mechanistic_Model_Valley_Fever_07_31_26;   % re-enter in forecast mode
end

elseif single_run_or_fitting==3
% fORECASTING
% fit nFit months, forecast the next 12. The three solverChain matching
% loops are replaced by one daily solve per horizon, and error is measured
% on monthly incidence
disp(['Running Model 2 Forecasting, Region: ',num2str(Region)])

% pI                     delta_O                  mu_H
LB(1) = 5;              LB(2) = 0.000000001;     LB(3) = 0.0000001;
UB(1) = 2000;           UB(2) = 0.5;             UB(3) = 0.1;

% gamma_H                H_max                    delta_H
LB(4) = 0.00000001;     LB(5) = 210;             LB(6) = 0.000001;
UB(4) = 0.06;           UB(5) = 500;             UB(6) = 0.2;
% forecasting section. Harmonised to 500 in both.
% as in M1 and M5, H and A are unobserved so (H_max, gamma_H, gamma_A,
% epsilon) form a flat direction; left alone rather than renormalised.

% gamma_A                delta_A                  phi_A
LB(7) = 0.0000001;      LB(8) = 0.00000001;      LB(9) = 0.0000000001;
UB(7) = 0.1;            UB(8) = 0.2;             UB(9) = 0.00001;

% epsilon                delta_D
LB(11) = 0.0000000001;  LB(16) = 0.0000001;
UB(11) = 0.00001;       UB(16) = 0.06;

% psi -- 1/psi IS the incubation period for Model 2 (no psi_A), so solve
% psi + drainE = 1/incubation for CDC's 1 to 3 weeks. Was [1/60, 1/5],
% which allowed a 60-day incubation.
assert(drainE < 1/21, 'drainE %.3e exceeds 1/21; psi bounds would invert', drainE);
LB(15) = 1/21 - drainE;
UB(15) = 1/7  - drainE;

% initial conditions
LB(18) = 1;     UB(18) = 1000;   % ic_O
LB(19) = 1;     UB(19) = 1000;   % ic_D
LB(20) = 1;     UB(20) = 500;   % ic_H
LB(21) = 1;     UB(21) = 1000;   % ic_A

% ic_E from the data: E ~ (month-1 cases per day)/psi in quasi-steady state
psi_mid  = 0.5*(LB(15) + UB(15));
ic_E_est = (y_inf_data(1)/31) / psi_mid;
LB(22) = 0.5*ic_E_est;   UB(22) = 2.0*ic_E_est;
% was [1, ic_I*5], about 15x too wide at the top

slack_idx = [1 2 3 4 5 6 7 8 9 11 16 18 19 20 21];
LB(slack_idx) = LB(slack_idx) * 0.7;
UB(slack_idx) = UB(slack_idx) * 1.4;

% rho and kappa appear only in dI and dR, so under an incidence objective
% they reach the flux only through N and are unidentifiable. Set, not fitted.
CFR_corrected = 0.01805;   % <-- Kappa_Estimate!B8
rho_fixed     = 1/90;
kappa_fixed   = CFR_corrected*(rho_fixed + omega_b + c*Nbar)/(1-CFR_corrected);

LB(13) = rho_fixed;        UB(13) = rho_fixed;   % rho
LB(14) = kappa_fixed;      UB(14) = kappa_fixed;   % kappa
LB(12) = omega_b*0.99999;  UB(12) = omega_b*1.00001;   % omega
LB(10) = omega_b*1.00001;  UB(10) = alpha_h_b*1.00001;   % alpha_h
LB(17) = c*0.9999;         UB(17) = c*1.0001;   % c

assert(LB(10) >= UB(12), 'net growth can go negative');
assert(all(LB <= UB), 'LB>UB at %s', mat2str(find(LB>UB)));
fprintf('kappa %.4e/day | rho %.4e/day | psi in [%.5f %.5f] | implied CFR %.3f%%\n', ...
        kappa_fixed, rho_fixed, LB(15), UB(15), ...
        100*kappa_fixed/(rho_fixed+kappa_fixed+omega_b+c*Nbar));

nAlloc = str2double(getenv('SLURM_CPUS_PER_TASK'));
if isnan(nAlloc) || nAlloc < 1, nAlloc = str2double(getenv('SLURM_CPUS_ON_NODE')); end
if isnan(nAlloc) || nAlloc < 1, nAlloc = feature('numcores'); end
nWant = max(1, floor(nAlloc));
pool = gcp('nocreate');
if ~isempty(pool) && pool.NumWorkers ~= nWant, delete(pool); pool = []; end
if isempty(pool)
    try
        try
            cl = parcluster('Processes');
        catch
            cl = parcluster('local');
        end
        jid = getenv('SLURM_JOB_ID');
        if ~isempty(jid)
            jsl = fullfile(tempdir, ['mlpool_' jid]);
            if ~exist(jsl,'dir'), mkdir(jsl); end
            cl.JobStorageLocation = jsl;
        end
        cl.NumWorkers = nWant;  pool = parpool(cl, nWant);
    catch ME
        warning('M2:parpoolFailed','parpool failed (%s). Running serial.', ME.message);
        pool = [];
    end
end
if isempty(pool)
    numWorkers = 1;  useParallel = false;
else
    numWorkers = pool.NumWorkers;  useParallel = true;
    pctRunOnAll warning('off', 'all');
end
fprintf('allocated %d | workers %d | parallel %d\n', nWant, numWorkers, useParallel);
format long

nDim   = length(LB);
logIdx = [1 2 3 4 6 7 8 9 11 16];
assert(all(LB(logIdx) > 0), 'log indices need LB>0: %s', mat2str(logIdx(LB(logIdx)<=0)));
LBt = LB;  UBt = UB;
LBt(logIdx) = log10(LB(logIdx));   UBt(logIdx) = log10(UB(logIdx));
assert(all(isfinite(LBt)) && all(isfinite(UBt)), 'log10 of a non-positive bound');
isLog = false(nDim,1);  isLog(logIdx) = true;
unlog = @(q) q(:).*(~isLog) + (10.^min(q(:),300)).*isLog;
logIdx_active = logIdx;

fminOpts = optimoptions('fmincon','Algorithm','interior-point','UseParallel',useParallel, ...
    'MaxFunctionEvaluations',20000,'OptimalityTolerance',1e-8, ...
    'StepTolerance',1e-10,'FiniteDifferenceStepSize',1e-4,'Display','none');

optionsslow = optimoptions('particleswarm', ...
    'UseParallel', useParallel, ...
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*ceil(100*nDim/numWorkers), ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ...
    'FunctionTolerance', 1e-10, ...
    'InertiaRange', [0.1, 1.2], ...
    'SelfAdjustmentWeight', 1.8, ...
    'SocialAdjustmentWeight', 1.2, ...
    'MinNeighborsFraction', 0.10, ...
    'HybridFcn', {@fmincon, fminOpts}, ...
    'Display', 'final');

% prefer this region's full-sample fit. Workspace first (set by the fitting
% section when auto-chaining), then disk, so it also works run standalone.
params_op = [];
if exist('params_m2pswarm','var') && numel(params_m1pswarm)==nDim
    params_op = params_m2pswarm(:);
    fprintf('warm start: seeding horizon 1 from the workspace fit\n');
else
    seed_file = "params_m2pswarm_" + county_M2 + ".mat";
    if isfile(seed_file)
        Sd = load(seed_file, 'params_m2pswarm');
        if isfield(Sd,'params_m2pswarm') && numel(Sd.params_m2pswarm)==nDim
            params_op = Sd.params_m2pswarm(:);
            fprintf('warm start: seeding horizon 1 from %s\n', seed_file);
        end
    end
end
if isempty(params_op), fprintf('warm start: no usable seed; cold start.\n'); end

% optionsslow2 = optionsslow plus an InitialSwarmMatrix whose first particle
% is the seed, TRANSFORMED INTO LOG SPACE. Seeding in natural units would put
% every particle outside the box and particleswarm would clip them to a corner.
tolog = @(pv) pv(:).*(~isLog) + log10(max(pv(:),realmin)).*isLog;
n_particles = numWorkers*ceil(100*nDim/numWorkers);
make_warm = @(pseed) optimoptions(optionsslow, 'InitialSwarmMatrix', ...
    [ min(max(tolog(pseed)',LBt),UBt) ; ...
      LBt + (UBt - LBt).*rand(n_particles-1, nDim) ]);
seed_h = params_op;

seed_h=params_op_m2_AZ;

nFitList  = [96 108 120];
yrLabel   = {'2021','2022','2023'};
nRestarts = 6;
Pfit = cell(3,1);  Ffit = nan(3,1);
for h = 1:3
    nF = nFitList(h);
    tsp_h = t_inf_data(1:nF+1);
    y_h   = y_inf_data(1:nF+1);
    if isempty(seed_h)
        options = optionsslow;
        fprintf('h=%d (%s): cold start\n', h, yrLabel{h});
    else
        options = make_warm(seed_h);
        fprintf('h=%d (%s): warm start from previous best\n', h, yrLabel{h});
    end
    optionsslow2 = options;
    aP = nan(nRestarts,nDim);  aF = inf(nRestarts,1);
    for r = 1:nRestarts
        rng(6000 + 100*h + r);
        [qR,fR] = particleswarm(@(q) objective_functionM2(unlog(q), tsp_h, total_pop_t0, y_h), ...
                                nDim, LBt, UBt, options);
        aP(r,:) = unlog(qR)';  aF(r) = fR;
        fprintf('h=%d (%s) restart %d/%d: obj = %.6e\n', h, yrLabel{h}, r, nRestarts, fR);
        save("m2_FOR_restarts_h" + h + "_" + county_M2 + ".mat", 'aP','aF','r');
    end
    [Ffit(h), rb] = min(aF);
    Pfit{h} = aP(rb,:)';
    seed_h = Pfit{h};   % chain into the next horizon
    fprintf('h=%d best %.6e | median %.6e | spread %.2f%%\n', ...
            h, Ffit(h), median(aF), 100*(max(aF)-min(aF))/min(aF));
    save("params_m2pswarm_FOR_" + nF + "mo_" + county_M2 + ".mat", 'aP','aF','LB','UB');
end
params_m2pswarm_8  = Pfit{1};
params_m2pswarm_9  = Pfit{2};
params_m2pswarm_10 = Pfit{3};

fitRRMSE = nan(3,1);  fcRRMSE = nan(3,1);
fcPers = nan(3,1);  fcSeas = nan(3,1);  fcMean = nan(3,1);
MMON = cell(3,1);  TMON = cell(3,1);  fcResid = cell(3,1);  solvUsed = cell(3,1);
for h = 1:3
    p  = Pfit{h};
    nF = nFitList(h);
    t_m = t_inf_data(1:nF+13);
% through the objective: same solver chain, timeout and integration
    [~, ~, solvUsed{h}, mmon] = objective_functionM2(p, t_m, total_pop_t0, ...
                                    y_inf_data(1:nF+13));
    if isempty(mmon)
        warning('M2:forecastSolveFailed','horizon %d: all solvers failed', h);
        mmon = nan(nF+12,1);
    end
    MMON{h} = mmon;  TMON{h} = t_m(1:nF+12);

    dFit = y_inf_data(1:nF);          rFit = mmon(1:nF)       - dFit;
    dFc  = y_inf_data(nF+1:nF+12);    rFc  = mmon(nF+1:nF+12) - dFc;
    fitRRMSE(h) = 100*sqrt(mean(rFit.^2))/mean(dFit);
    fcRRMSE(h)  = 100*sqrt(mean(rFc.^2)) /mean(dFc);
    fcResid{h}  = rFc;
    fcPers(h) = 100*sqrt(mean((y_inf_data(nF)         - dFc).^2))/mean(dFc);
    fcSeas(h) = 100*sqrt(mean((y_inf_data(nF-11:nF)   - dFc).^2))/mean(dFc);
    fcMean(h) = 100*sqrt(mean((mean(y_inf_data(1:nF)) - dFc).^2))/mean(dFc);
end

fprintf('params_m2pswarm_8 = [%s%.15f];\n',  sprintf('%.15f; ', params_m2pswarm_8(1:end-1)),  params_m2pswarm_8(end));
fprintf('params_m2pswarm_9 = [%s%.15f];\n',  sprintf('%.15f; ', params_m2pswarm_9(1:end-1)),  params_m2pswarm_9(end));
fprintf('params_m2pswarm_10 = [%s%.15f];\n', sprintf('%.15f; ', params_m2pswarm_10(1:end-1)), params_m2pswarm_10(end));
fprintf('\n%s  Model 2 1-year-ahead forecast, RRMSE = RMSE/mean (%%)\n', county_M2);
fprintf('%-8s %8s %10s %10s %10s %10s\n','year','in-samp','FORECAST','persist','seasonal','trainmean');
for h = 1:3
    fprintf('%-8s %8.2f %10.2f %10.2f %10.2f %10.2f\n', yrLabel{h}, ...
            fitRRMSE(h), fcRRMSE(h), fcPers(h), fcSeas(h), fcMean(h));
end
fprintf('beats best baseline: %s\n', ...
        mat2str(fcRRMSE(:)' < min([fcPers fcSeas fcMean],[],2)'));
for h = 1:3
    fprintf('h=%d (%s): solver %-24s swarm obj %.6f | re-solve fit RRMSE %.4f%%\n', ...
            h, yrLabel{h}, solvUsed{h}, Ffit(h), fitRRMSE(h));
end

frst_year_forecast_rrmse = fcRRMSE(1);
scnd_year_forecast_rrmse = fcRRMSE(2);
thrd_year_forecast_rrmse = fcRRMSE(3);
save("m2_FOR_RRMSE_" + county_M2 + ".mat", 'fitRRMSE','fcRRMSE', ...
     'fcPers','fcSeas','fcMean','fcResid','nFitList','yrLabel');

figure('Position',[80 80 1100 560]);
hObs = scatter(t_inf_data(1:132), y_inf_data(1:132), 32, 'k', 'filled'); hold on
hFit = plot(TMON{1}(1:96), MMON{1}(1:96), 'LineWidth', 5, 'Color', [0 0 1 0.45]);
cols = [0.35 0.70 0.90; 0.00 0.60 0.50; 0.80 0.40 0.00];
hFc  = gobjects(3,1);
for h = 1:3
    nF = nFitList(h);
    hFc(h) = plot(TMON{h}(nF+1:nF+12), MMON{h}(nF+1:nF+12), 'LineWidth', 5, 'Color', cols(h,:));
    xline(t_inf_data(nF+1), 'k', 'LineWidth', 1.5);
end
legend([hObs; hFit; hFc], [{county_M2+' Infected', 'Model 2 fit (first 8 years)'}, ...
       cellfun(@(s) [s ' forecast'], yrLabel, 'UniformOutput', false)], ...
       'FontSize', 12, 'Location','northwest');
title('Forecast of '+county_M2+" Valley Fever Using Model 2", 'FontSize', 18)
subtitle(sprintf('forecast RRMSE  2021 %.1f%%  2022 %.1f%%  2023 %.1f%%   (best naive %.1f / %.1f / %.1f%%)', ...
    fcRRMSE(1), fcRRMSE(2), fcRRMSE(3), ...
    min([fcPers(1) fcSeas(1) fcMean(1)]), min([fcPers(2) fcSeas(2) fcMean(2)]), ...
    min([fcPers(3) fcSeas(3) fcMean(3)])), 'FontSize', 12)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',14); ylabel('New cases per month','FontSize',14)
ylim([0, max(y_inf_data)+200]); grid on; hold off
end

elseif choose_model==3
%% model 3 - Fungal Growth Model dependent on Food and Environment

global alpha_h_Maricopa omega_Maricopa c_Maricopa alpha_h_Pinal omega_Pinal c_Pinal alpha_h_Pima omega_Pima c_Pima alpha_h_AZ omega_AZ c_AZ
global logIdx_active
omega_vital = 0.021/365;
alpha_h_Maricopa = 0.000500942192598 + omega_vital; omega_Maricopa = omega_vital; c_Maricopa = 0.000500942192598/4724819.974562017247081;
alpha_h_Pinal    = 0.000076238824090 + omega_vital; omega_Pinal    = omega_vital; c_Pinal    = 0.000076238824090/5162630.000;
alpha_h_Pima     = 0.000019432499300 + omega_vital; omega_Pima     = omega_vital; c_Pima     = 0.000019432499300/10639930.00;
alpha_h_AZ       = 0.000304888503016 + omega_vital; omega_AZ       = omega_vital; c_AZ       = 0.000304888503016/7853513.125630123540759;

if Region==1
    y_inf_data=y_inf_data_AZ; y_pop_data=y_pop_data_AZ;
    alpha_h_b=alpha_h_AZ; omega_b=omega_AZ; c=c_AZ;
    county_M3=["AZ"]; county=1;
elseif Region==2
    y_inf_data=y_inf_data_Maricopa; y_pop_data=y_pop_data_Maricopa;
    alpha_h_b=alpha_h_Maricopa; omega_b=omega_Maricopa; c=c_Maricopa;
    county_M3=["MARICOPA"]; county=2;
elseif Region==3
    y_inf_data=y_inf_data_Pima; y_pop_data=y_pop_data_Pima;
    alpha_h_b=alpha_h_Pima; omega_b=omega_Pima; c=c_Pima;
    county_M3=["PIMA"]; county=3;
elseif Region==4
    y_inf_data=y_inf_data_Pinal; y_pop_data=y_pop_data_Pinal;
    alpha_h_b=alpha_h_Pinal; omega_b=omega_Pinal; c=c_Pinal;
    county_M3=["PINAL"]; county=4;
else
    error('No Region Selected!');
end
total_pop_t0 = y_pop_data(1);
nMonths = 132;
Nbar    = mean(y_pop_data);
drainE  = omega_b + c*Nbar;

if single_run_or_fitting==1
% sINGLE RUN
disp(['Running Model 3 single parameter run, Region: ',num2str(Region)])

PI_v=200;         delta_O_v=0.02;    mu_H_v=0.0005;
gamma_H_v=0.0008; H_max_v=350;       delta_H_v=0.005;
gamma_A_v=0.02;   delta_A_v=0.01;    phi_A_v=1.5e-5;
T_opt_H_v=75;     T_opt_A_v=82;
S_opt_H_v=11.5;   S_opt_A_v=8.5;     T_decay_v=60;
blTA=500; abTA=70; blTH=500; abTH=70;
blSA=6;   abSA=2;  blSH=6;   abSH=2;
alpha_h_v=alpha_h_b;  epsilon_v=8.0e-9;  omega_v=omega_b;
rho_v=1/90;  kappa_v=2.1e-4;  psi_v=1/14;
delta_D_v=0.001;  c_v=c;

% oRDER matches M3_SF exactly (30 model parameters)
paramsm3=[PI_v; delta_O_v; mu_H_v; gamma_H_v; H_max_v; delta_H_v; ...
          gamma_A_v; delta_A_v; phi_A_v; T_opt_H_v; T_opt_A_v; ...
          S_opt_H_v; S_opt_A_v; T_decay_v; blTA; abTA; blTH; abTH; ...
          blSA; abSA; blSH; abSH; alpha_h_v; epsilon_v; omega_v; ...
          rho_v; kappa_v; psi_v; delta_D_v; c_v];

ic_O=40; ic_D=70; ic_H=100; ic_A=50;
ic_I=y_inf_data(1);  ic_E=ic_I*1.5;  ic_R=ic_I/2;
ic_S=total_pop_t0-ic_I-ic_E-ic_R;
y0=[ic_O;ic_D;ic_H;ic_A;ic_S;ic_E;ic_I;ic_R];   % 8 elements, matches M3_SF

t_day=(t_inf_data(1):1:t_inf_data(nMonths+1))';
[t,y]=ode15s(@(tt,yy) M3_SF(tt,yy,paramsm3,county), t_day, y0, odeset('MaxStep',1));

figure
plot(t/365,y(:,1),'LineWidth',2); hold on; plot(t/365,y(:,2),'LineWidth',2)
legend('Organic Matter O','Decayed Organic Matter D','Location','best');
title("Model 3 single run - substrate",'FontSize',16)
xlabel('Year','FontSize',13); grid on; hold off

figure
plot(t/365,y(:,3),'LineWidth',2); hold on; plot(t/365,y(:,4),'LineWidth',2)
legend('Hyphae H','Arthroconidia A','Location','best');
title("Model 3 single run - fungal compartments",'FontSize',16)
xlabel('Year','FontSize',13); grid on; hold off

figure
plot(t/365,y(:,5),'LineWidth',2); hold on
plot(t/365,y(:,6),'LineWidth',2); plot(t/365,y(:,7),'LineWidth',2); plot(t/365,y(:,8),'LineWidth',2)
legend('Susceptible','Exposed','Infected','Recovered','Location','best');
title("Model 3 single run - human compartments",'FontSize',16)
xlabel('Year','FontSize',13); ylabel('Humans','FontSize',13); grid on; hold off

cf=cumtrapz(t, psi_v*y(:,6));
im=round(t_inf_data(1:nMonths+1)-t_inf_data(1))+1;
mmon=diff(cf(im));
figure
scatter(t_inf_data(1:nMonths),y_inf_data(1:nMonths),28,'k','filled'); hold on
plot(t_inf_data(1:nMonths),mmon,'LineWidth',2.5)
legend(county_M3+' reported','Model 3 monthly incidence','Location','best');
title("Model 3 single run - monthly incidence vs data",'FontSize',16)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',13); ylabel('Cases per month','FontSize',13); grid on; hold off
fprintf('single run: N(0)=%.0f  N(end)=%.0f  mean monthly incidence %.1f (data %.1f)\n', ...
        sum(y(1,5:8)), sum(y(end,5:8)), mean(mmon), mean(y_inf_data(1:nMonths)));

elseif single_run_or_fitting==2
% fITTING
disp(['Running Model 3 fitting, Region: ',num2str(Region)])
tspan = t_inf_data(1:nMonths+1);
y_fit = y_inf_data(1:nMonths+1);

% parameter ranges
% index map: 1 PI, 2 delta_O, 3 mu_H, 4 gamma_H, 5 H_max, 6 delta_H,
% 7 gamma_A, 8 delta_A, 9 phi_A, 10 T_opt_H, 11 T_opt_A, 12 S_opt_H,
% 13 S_opt_A, 14 T_decay, 15 bl_Topt_A, 16 ab_Topt_A, 17 bl_Topt_H,
% 18 ab_Topt_H, 19 bl_Sopt_A, 20 ab_Sopt_A, 21 bl_Sopt_H, 22 ab_Sopt_H,
% 23 alpha_h, 24 epsilon, 25 omega, 26 rho, 27 kappa, 28 psi, 29 delta_D,
% 30 c, 31-35 ic_O ic_D ic_H ic_A ic_E
% pI                     delta_O                  mu_H
LB(1) = 1;              LB(2) = 0.00001;         LB(3) = 0.000001;
UB(1) = 1000;           UB(2) = 0.3;             UB(3) = 0.1;

% gamma_H                H_max                    delta_H
% <<< LB(6) raised to 1/365 and 6 REMOVED from slack_idx. At 1e-6 x0.7 = 7e-7
% the hyphal time constant reaches 1.4 million days, which is how M5's AZ fit
% froze H at its initial condition. A one-year floor forces H to turn over so
% that F_H_T and F_H_Sm have something to modulate.
LB(4) = 0.00000001;     LB(5) = 210;             LB(6) = 0.0001;
UB(4) = 0.06;           UB(5) = 500;             UB(6) = 0.3;

% gamma_A                delta_A                  phi_A
% <<< LB(8) raised to 1/120 and 8 REMOVED from slack_idx. THIS IS THE MOST
% iMPORTANT CHANGE. Model 3 has no wildlife, so dA exit = phi_A + delta_A only:
% delta_A alone sets the arthroconidial time constant, and at 1e-6 x0.7 = 7e-7
% that reaches 1.4 million days. M5's AZ fit at 1,474 days already removed 96%
% of the annual cycle before it reached epsilon*S*A. A 120-day cap keeps about
% 44% of the annual amplitude.
LB(7) = 0.000001;       LB(8) = 1/120;           LB(9) = 0.000000001;
UB(7) = 0.1;            UB(8) = 0.5;             UB(9) = 0.0001;

% t_opt_H (base)         T_gap (where T_opt_A = T_opt_H + T_gap)
LB(10) = 65;            LB(11) = 0.5;
UB(10) = 100;           UB(11) = 25;

% s_opt_A (base)         S_gap (where S_opt_H = S_opt_A + S_gap)
LB(12) = 7;             LB(13) = 0.2;
UB(12) = 9.8;           UB(13) = 8;

% response widths
% <<< LB(15) 200 -> 50 and UB(16) 100 -> 400. M5's fits ran bl_Topt_A to its
% ceiling (1037 of 1050) and ab_Topt_A to 520, so these ranges were binding.
% <<< 19 and 21 REMOVED from slack_idx: bl_Sopt_H floored out in all three M5
% regions fitted (0.605, 0.657, 0.712), making F_H_Sm a step function.
LB(15) = 50;            LB(16) = 30;             LB(17) = 200;
UB(15) = 700;           UB(16) = 400;            UB(17) = 700;
LB(18) = 30;            LB(19) = 1;              LB(20) = 1;
UB(18) = 100;           UB(19) = 20;             UB(20) = 20;
LB(21) = 1;             LB(22) = 1;
UB(21) = 20;            UB(22) = 20;
% lB(20) and LB(22) at 1.0 (not 0.1): a width of 0.1 collapses the response to
% exp(-large) within a fraction of a PZI unit, a step function that fits noise.

% epsilon                delta_D
LB(24) = 0.000000001;   LB(29) = 0.0000001;
UB(24) = 0.0001;        UB(29) = 0.06;

% psi -- Model 3 has no A_H, so 1/psi IS the incubation period (as in M2,
% unlike M5 where psi_A doubled the drain on E). Solve psi + drainE =
% 1/incubation for CDC's 1 to 3 weeks.
assert(drainE < 1/21, 'drainE %.3e exceeds 1/21; psi bounds would invert', drainE);
LB(28) = 1/21 - drainE;
UB(28) = 1/7  - drainE;

% initial conditions
LB(31) = 1;     UB(31) = 1000;   % ic_O
LB(32) = 1;     UB(32) = 1000;   % ic_D
LB(33) = 1;     UB(33) = 500;   % ic_H  (re-capped after widening)
LB(34) = 1;     UB(34) = 2000;   % ic_A  <<< 1000 -> 2000 (M5's Maricopa fit
% sat at 97.5% of a 1500 ceiling)
psi_mid  = 0.5*(LB(28) + UB(28));
ic_E_est = (y_inf_data(1)/31) / psi_mid;
LB(35) = 0.5*ic_E_est;   UB(35) = 2.0*ic_E_est;

% excluded and why:
% 14, 26, 27       pinned
% 6                delta_H floor must hold (H must not freeze)
% 8                delta_A floor must hold (A must transmit the annual cycle)
% 12, 13           S_opt ordering must hold
% 10, 11           temperature optima must stay physical
% 19, 20, 21, 22   width floors must hold (no step-function responses)
% 23, 25, 28, 30   demography and psi set from external data
% 35               ic_E derived from the data
slack_idx = [1 2 3 4 5 7 9 15 16 17 18 24 29 31 32 33 34];
LB(slack_idx) = LB(slack_idx) * 0.6;
UB(slack_idx) = UB(slack_idx) * 1.5;

% <<< ic_H must stay below the smallest H_max the fit can choose, or
% (1 - H/H_max) starts negative and H crashes through a spurious transient.
UB(33) = min(UB(33), 0.9*LB(5));

% t_decay is NOT identifiable alongside delta_O: the decay term is
% (TF/T_decay)*delta_O, so only the ratio delta_O/T_decay is determined.
% pin T_decay at 60 and let delta_O carry the scale. Same degeneracy M5 had
% with (k_ref, T_ref), where the fit parked them at opposite corners.
LB(14) = 60;               UB(14) = 60;   % T_decay

% rho and kappa appear only in dI and dR, so under an incidence objective they
% reach the flux only through N and are unidentifiable. Set, not fitted.
CFR_corrected = 0.01805;   % <-- Kappa_Estimate!B8
rho_fixed     = 1/90;
kappa_fixed   = CFR_corrected*(rho_fixed + omega_b + c*Nbar)/(1-CFR_corrected);

LB(26) = rho_fixed;        UB(26) = rho_fixed;   % rho
LB(27) = kappa_fixed;      UB(27) = kappa_fixed;   % kappa
LB(25) = omega_b*0.99999;  UB(25) = omega_b*1.00001;   % omega
LB(23) = omega_b*1.00001;  UB(23) = alpha_h_b*1.00001;   % alpha_h
LB(30) = c*0.9999;         UB(30) = c*1.0001;   % c

assert(numel(LB)==35 && numel(UB)==35, 'LB/UB must be length 35, got %d/%d', numel(LB), numel(UB));
assert(LB(23) >= UB(25), 'net growth can go negative');

assert(UB(33) <  LB(5),  'ic_H upper bound must sit below the smallest H_max');
assert(all(LB <= UB), 'LB>UB at %s', mat2str(find(LB>UB)));

tauA_max = 1/LB(8);
retA     = 1/sqrt(1 + (2*pi*(tauA_max/30.44)/12)^2);
fprintf('kappa %.4e/day | rho %.4e/day | psi in [%.5f %.5f] | free %d of 35\n', ...
        kappa_fixed, rho_fixed, LB(28), UB(28), sum(UB>LB));
fprintf('A pool tau <= %.0f d -> >= %.0f%% of the annual cycle survives | H turnover <= %.0f d\n', ...
        tauA_max, 100*retA, 1/LB(6));
fprintf('ic_H in [%.2f %.2f], H_max in [%.0f %.0f]\n', LB(33), UB(33), LB(5), UB(5));

nAlloc = str2double(getenv('SLURM_CPUS_PER_TASK'));
if isnan(nAlloc) || nAlloc < 1, nAlloc = str2double(getenv('SLURM_CPUS_ON_NODE')); end
if isnan(nAlloc) || nAlloc < 1, nAlloc = feature('numcores'); end
nWant = max(1, floor(nAlloc));
pool = gcp('nocreate');
if ~isempty(pool) && pool.NumWorkers ~= nWant, delete(pool); pool = []; end
if isempty(pool)
    try
        try
            cl = parcluster('Processes');
        catch
            cl = parcluster('local');
        end
        jid = getenv('SLURM_JOB_ID');
        if ~isempty(jid)
            jsl = fullfile(tempdir, ['mlpool_' jid]);
            if ~exist(jsl,'dir'), mkdir(jsl); end
            cl.JobStorageLocation = jsl;
        end
        cl.NumWorkers = nWant;  pool = parpool(cl, nWant);
    catch ME
        warning('M3:parpoolFailed','parpool failed (%s). Running serial.', ME.message);
        pool = [];
    end
end
if isempty(pool)
    numWorkers = 1;  useParallel = false;
else
    numWorkers = pool.NumWorkers;  useParallel = true;
    pctRunOnAll warning('off', 'all');
end
fprintf('allocated %d | workers %d | parallel %d\n', nWant, numWorkers, useParallel);
format long

nDim   = length(LB);
logIdx = [1 2 3 4 7 9 24 29];
assert(all(LB(logIdx) > 0), 'log indices need LB>0: %s', mat2str(logIdx(LB(logIdx)<=0)));
LBt = LB;  UBt = UB;
LBt(logIdx) = log10(LB(logIdx));   UBt(logIdx) = log10(UB(logIdx));
assert(all(isfinite(LBt)) && all(isfinite(UBt)), 'log10 of a non-positive bound');
isLog = false(nDim,1);  isLog(logIdx) = true;
unlog = @(q) q(:).*(~isLog) + (10.^min(q(:),300)).*isLog;
logIdx_active = logIdx;

fminOpts = optimoptions('fmincon','Algorithm','interior-point','UseParallel',useParallel, ...
    'MaxFunctionEvaluations',20000,'OptimalityTolerance',1e-8, ...
    'StepTolerance',1e-10,'FiniteDifferenceStepSize',1e-4,'Display','none');
optionsslow = optimoptions('particleswarm', ...
    'UseParallel', useParallel, ...
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*ceil(50*nDim/numWorkers), ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ...
    'FunctionTolerance', 1e-8, ...
    'InertiaRange', [0.1, 1.2], ...      
    'SelfAdjustmentWeight', 1.8, ...
    'SocialAdjustmentWeight', 1.2, ...
    'MinNeighborsFraction', 0.10, ...   % exploration via topology
    'HybridFcn', {@fmincon, fminOpts}, ...
    'Display', 'final');
options=optionsslow;

nRestarts = 20;
allP = nan(nRestarts,nDim);  allF = inf(nRestarts,1);
for r = 1:nRestarts
    rng(7000 + r);
    [qR,fR] = particleswarm(@(q) objective_functionM3(unlog(q), tspan, total_pop_t0, y_fit, county), ...
                            nDim, LBt, UBt, options);
    allP(r,:) = unlog(qR)';  allF(r) = fR;
    fprintf('restart %2d/%d: obj = %.6e\n', r, nRestarts, fR);
    save("m3_restarts_" + county_M3 + ".mat", 'allP','allF','r');
end
[errorOBJ, rBest] = min(allF);
params_m3pswarm   = allP(rBest,:)';
fprintf('best %.6e | median %.6e | spread %.2f%%\n', ...
        errorOBJ, median(allF), 100*(max(allF)-min(allF))/min(allF));

fprintf('params_m3pswarm = [%s%.15f];\n', ...
        sprintf('%.15f; ', params_m3pswarm(1:end-1)), params_m3pswarm(end));
nFree = sum(UB > LB);
fprintf('Region: %s | RRMSE = %.6f | free params: %d of %d\n', ...
        county_M3, errorOBJ, nFree, nDim);
save("params_m3pswarm_" + county_M3 + ".mat", 'params_m3pswarm','LB','UB','errorOBJ');
save("m3_RRMSE_" + county_M3 + ".mat", 'errorOBJ');

p = params_m3pswarm;
[chk, Yf, solvFit, mmon] = objective_functionM3(p, tspan, total_pop_t0, y_fit, county);
t_d = (tspan(1):1:tspan(end))';
fprintf('fit solver: %-22s | swarm obj %.6f | re-solve obj %.6f\n', ...
        solvFit, errorOBJ, chk);
if abs(chk - errorOBJ) > 1e-6
    warning('M3:objMismatch', ...
        'Re-solve objective %.6f differs from the swarm value %.6f. A different solver may have won on this window.', ...
        chk, errorOBJ);
end
if isempty(mmon), error('M3: all solvers failed on the full window'); end

rrmse      = errorOBJ;
data_mon   = y_inf_data(1:end-1);
n          = numel(data_mon);
k          = sum(UB > LB);
noiseFloor = 100*(std(diff(data_mon,2))/sqrt(6))/mean(data_mon);

r    = data_mon(:) - mmon(:);
nIC  = numel(r);
rss  = sum(r.^2);
p    = k + 1;
logL = -nIC/2 * ( log(2*pi) + log(rss/nIC) + 1 );
aic  = -2*logL + 2*p;
if nIC - p - 1 > 0
    aicc = aic + 2*p*(p+1)/(nIC - p - 1);
else
    aicc = NaN;
end
bic  = -2*logL + p*log(nIC);
fprintf('\nModel 3 information criteria (Gaussian least squares)\n');
fprintf('  n = %d | free structural k = %d | p = k+1 = %d\n', nIC, k, p);
fprintf('  RRMSE  : %.6f\n', sqrt(mean(r.^2))/mean(data_mon));
fprintf('  RSS    : %.4f\n', rss);
fprintf('  logL   : %.4f\n', logL);
fprintf('  AIC    : %.4f\n', aic);
fprintf('  AICc   : %.4f\n', aicc);
fprintf('  BIC    : %.4f\n', bic);
aic
aicc
bic

fprintf('  RRMSE reported by the swarm : %.6f  (noise floor %.4f)\n', rrmse, noiseFloor/100);
ICnb = nb_ic(data_mon, max(mmon(:),1e-6), k, "Model 3 " + county_M3);
aic_gauss = aic;  aicc_gauss = aicc;  bic_gauss = bic;
aic = ICnb.aic;  aicc = ICnb.aicc;  bic = ICnb.bic;
save("m3_IC_" + county_M3 + ".mat", 'ICnb','n','k','rrmse','aic','aicc','bic','aic_gauss','aicc_gauss','bic_gauss','noiseFloor');

if isempty(mmon), error('M3: all solvers failed on the full window'); end

figure
scatter(t_inf_data(1:nMonths), data_mon, 30, 'k', 'filled'); hold on
plot(t_inf_data(1:nMonths), mmon, 'LineWidth', 3, 'Color', [0 0 1 0.5]);
legend(county_M3+' reported','Model 3 fit','Location','northwest');
title(county_M3+" Valley Fever - Model 3 monthly incidence fit",'FontSize',16)
subtitle(sprintf('RRMSE %.2f%%  (noise floor %.2f%%)  |  AIC %.1f  BIC %.1f', ...
         rrmse*100, noiseFloor, aic, bic),'FontSize',11)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',13); ylabel('Cases per month','FontSize',13)
ylim([0, max(data_mon)*1.25]); grid on; hold off

figure
plot(t_d/365, Yf(:,1),'LineWidth',2); hold on; plot(t_d/365, Yf(:,2),'LineWidth',2)
plot(t_d/365, Yf(:,3),'LineWidth',2); plot(t_d/365, Yf(:,4),'LineWidth',2)
legend('Organic Matter O','Decayed D','Hyphae H','Arthroconidia A','Location','best')
title("Model 3 fitted substrate and fungal compartments",'FontSize',15)
xlabel('Year','FontSize',13); grid on; hold off

elseif single_run_or_fitting==3
% fORECASTING Model 3
% uses M3_SF (35 parameters). The three switch/case solver blocks are
% replaced by one daily solve per horizon through the objective, so the
% solver chain, timeout and integration match the fit exactly.
% fIXES relative to the previous draft of this section:
% 1. optionsslow was NEVER DEFINED. The options block was named `options`,
% but make_warm extended `optionsslow` and the cold-start branch assigned
% from it. Every run would have failed on the first restart.
% 2. make_warm built the initial swarm ONCE, outside the loops, so all 6
% restarts of all 3 horizons started from identical positions. That
% defeats the restarts entirely. The swarm is now rebuilt inside the
% restart loop, after rng, with the seed as particle 1.
% 3. drainE and Nbar were used by the bounds block but never defined here.
% 4. logIdx included 6 (delta_H) and 8 (delta_A). Now that both are floored
% they span under 2 decades, so log-transforming them only distorts the
% uniform sampling. Removed.
% 5. No MaxTime on the swarm, so a single horizon could run unbounded.
disp(['Running Model 3 Forecasting, Region: ',num2str(Region)])

total_pop_t0 = y_pop_data(1);
nMonths      = 132;

% nbar is the mean population over the window; drainE is the per-capita drain
% on the exposed compartment from mortality and crowding, which the psi bounds
% subtract so that 1/(psi + drainE) is the incubation period.
Nbar   = mean(y_pop_data);
drainE = omega_b + c*Nbar;
% changes from the previous version are marked <<<.
% index map: 1 PI, 2 delta_O, 3 mu_H, 4 gamma_H, 5 H_max, 6 delta_H,
% 7 gamma_A, 8 delta_A, 9 phi_A, 10 T_opt_H, 11 T_opt_A, 12 S_opt_H,
% 13 S_opt_A, 14 T_decay, 15 bl_Topt_A, 16 ab_Topt_A, 17 bl_Topt_H,
% 18 ab_Topt_H, 19 bl_Sopt_A, 20 ab_Sopt_A, 21 bl_Sopt_H, 22 ab_Sopt_H,
% 23 alpha_h, 24 epsilon, 25 omega, 26 rho, 27 kappa, 28 psi, 29 delta_D,
% 30 c, 31-35 ic_O ic_D ic_H ic_A ic_E
% pI                     delta_O                  mu_H
LB(1) = 1;              LB(2) = 0.00001;         LB(3) = 0.000001;
UB(1) = 1000;           UB(2) = 0.3;             UB(3) = 0.1;

% gamma_H                H_max                    delta_H
% <<< LB(6) raised to 1/365 and 6 REMOVED from slack_idx. At 1e-6 x0.7 = 7e-7
% the hyphal time constant reaches 1.4 million days, which is how M5's AZ fit
% froze H at its initial condition. A one-year floor forces H to turn over so
% that F_H_T and F_H_Sm have something to modulate.
LB(4) = 0.00000001;     LB(5) = 210;             LB(6) = 0.0001;
UB(4) = 0.06;           UB(5) = 500;             UB(6) = 0.3;

% gamma_A                delta_A                  phi_A
% <<< LB(8) raised to 1/120 and 8 REMOVED from slack_idx. THIS IS THE MOST
% iMPORTANT CHANGE. Model 3 has no wildlife, so dA exit = phi_A + delta_A only:
% delta_A alone sets the arthroconidial time constant, and at 1e-6 x0.7 = 7e-7
% that reaches 1.4 million days. M5's AZ fit at 1,474 days already removed 96%
% of the annual cycle before it reached epsilon*S*A. A 120-day cap keeps about
% 44% of the annual amplitude.
LB(7) = 0.000001;       LB(8) = 1/120;           LB(9) = 0.000000001;
UB(7) = 0.1;            UB(8) = 0.5;             UB(9) = 0.0001;

% t_opt_H (base)         T_gap (where T_opt_A = T_opt_H + T_gap)
LB(10) = 65;            LB(11) = 0.5;
UB(10) = 100;           UB(11) = 25;

% s_opt_A (base)         S_gap (where S_opt_H = S_opt_A + S_gap)
LB(12) = 7;             LB(13) = 0.2;
UB(12) = 9.8;           UB(13) = 8;

% response widths
% <<< LB(15) 200 -> 50 and UB(16) 100 -> 400. M5's fits ran bl_Topt_A to its
% ceiling (1037 of 1050) and ab_Topt_A to 520, so these ranges were binding.
% <<< 19 and 21 REMOVED from slack_idx: bl_Sopt_H floored out in all three M5
% regions fitted (0.605, 0.657, 0.712), making F_H_Sm a step function.
LB(15) = 50;            LB(16) = 30;             LB(17) = 200;
UB(15) = 700;           UB(16) = 400;            UB(17) = 700;
LB(18) = 30;            LB(19) = 1;              LB(20) = 1;
UB(18) = 100;           UB(19) = 20;             UB(20) = 20;
LB(21) = 1;             LB(22) = 1;
UB(21) = 20;            UB(22) = 20;
% lB(20) and LB(22) at 1.0 (not 0.1): a width of 0.1 collapses the response to
% exp(-large) within a fraction of a PZI unit, a step function that fits noise.

% epsilon                delta_D
LB(24) = 0.000000001;   LB(29) = 0.0000001;
UB(24) = 0.0001;        UB(29) = 0.06;

% psi -- Model 3 has no A_H, so 1/psi IS the incubation period (as in M2,
% unlike M5 where psi_A doubled the drain on E). Solve psi + drainE =
% 1/incubation for CDC's 1 to 3 weeks.
assert(drainE < 1/21, 'drainE %.3e exceeds 1/21; psi bounds would invert', drainE);
LB(28) = 1/21 - drainE;
UB(28) = 1/7  - drainE;

% initial conditions
LB(31) = 1;     UB(31) = 1000;   % ic_O
LB(32) = 1;     UB(32) = 1000;   % ic_D
LB(33) = 1;     UB(33) = 500;   % ic_H  (re-capped after widening)
LB(34) = 1;     UB(34) = 2000;   % ic_A  <<< 1000 -> 2000 (M5's Maricopa fit
% sat at 97.5% of a 1500 ceiling)
psi_mid  = 0.5*(LB(28) + UB(28));
ic_E_est = (y_inf_data(1)/31) / psi_mid;
LB(35) = 0.5*ic_E_est;   UB(35) = 2.0*ic_E_est;

% excluded and why:
% 14, 26, 27       pinned
% 6                delta_H floor must hold (H must not freeze)
% 8                delta_A floor must hold (A must transmit the annual cycle)
% 12, 13           S_opt ordering must hold
% 10, 11           temperature optima must stay physical
% 19, 20, 21, 22   width floors must hold (no step-function responses)
% 23, 25, 28, 30   demography and psi set from external data
% 35               ic_E derived from the data
slack_idx = [1 2 3 4 5 7 9 15 16 17 18 24 29 31 32 33 34];
LB(slack_idx) = LB(slack_idx) * 0.6;
UB(slack_idx) = UB(slack_idx) * 1.5;

% <<< ic_H must stay below the smallest H_max the fit can choose, or
% (1 - H/H_max) starts negative and H crashes through a spurious transient.
UB(33) = min(UB(33), 0.9*LB(5));

% t_decay is NOT identifiable alongside delta_O: the decay term is
% (TF/T_decay)*delta_O, so only the ratio delta_O/T_decay is determined.
% pin T_decay at 60 and let delta_O carry the scale. Same degeneracy M5 had
% with (k_ref, T_ref), where the fit parked them at opposite corners.
LB(14) = 60;               UB(14) = 60;   % T_decay

% rho and kappa appear only in dI and dR, so under an incidence objective they
% reach the flux only through N and are unidentifiable. Set, not fitted.
CFR_corrected = 0.01805;   % <-- Kappa_Estimate!B8
rho_fixed     = 1/90;
kappa_fixed   = CFR_corrected*(rho_fixed + omega_b + c*Nbar)/(1-CFR_corrected);

LB(26) = rho_fixed;        UB(26) = rho_fixed;   % rho
LB(27) = kappa_fixed;      UB(27) = kappa_fixed;   % kappa
LB(25) = omega_b*0.99999;  UB(25) = omega_b*1.00001;   % omega
LB(23) = omega_b*1.00001;  UB(23) = alpha_h_b*1.00001;   % alpha_h
LB(30) = c*0.9999;         UB(30) = c*1.0001;   % c

assert(numel(LB)==35 && numel(UB)==35, 'LB/UB must be length 35, got %d/%d', numel(LB), numel(UB));
assert(LB(23) >= UB(25), 'net growth can go negative');
assert(UB(33) <  LB(5),  'ic_H upper bound must sit below the smallest H_max');
assert(all(LB <= UB), 'LB>UB at %s', mat2str(find(LB>UB)));

tauA_max = 1/LB(8);
retA     = 1/sqrt(1 + (2*pi*(tauA_max/30.44)/12)^2);
fprintf('kappa %.4e/day | rho %.4e/day | psi in [%.5f %.5f] | free %d of 35\n', ...
        kappa_fixed, rho_fixed, LB(28), UB(28), sum(UB>LB));
fprintf('A pool tau <= %.0f d -> >= %.0f%% of the annual cycle survives | H turnover <= %.0f d\n', ...
        tauA_max, 100*retA, 1/LB(6));
fprintf('ic_H in [%.2f %.2f], H_max in [%.0f %.0f]\n', LB(33), UB(33), LB(5), UB(5));

nAlloc = str2double(getenv('SLURM_CPUS_PER_TASK'));
if isnan(nAlloc) || nAlloc < 1, nAlloc = str2double(getenv('SLURM_CPUS_ON_NODE')); end
if isnan(nAlloc) || nAlloc < 1, nAlloc = feature('numcores'); end
nWant = max(1, floor(nAlloc));
pool = gcp('nocreate');
if ~isempty(pool) && pool.NumWorkers ~= nWant, delete(pool); pool = []; end
if isempty(pool)
    try
        try
            cl = parcluster('Processes');
        catch
            cl = parcluster('local');
        end
        jid = getenv('SLURM_JOB_ID');
        if ~isempty(jid)
            jsl = fullfile(tempdir, ['mlpool_' jid]);
            if ~exist(jsl,'dir'), mkdir(jsl); end
            cl.JobStorageLocation = jsl;
        end
        cl.NumWorkers = nWant;  pool = parpool(cl, nWant);
    catch ME
        warning('M3:parpoolFailed','parpool failed (%s). Running serial.', ME.message);
        pool = [];
    end
end
if isempty(pool)
    numWorkers = 1;  useParallel = false;
else
    numWorkers = pool.NumWorkers;  useParallel = true;
    pctRunOnAll warning('off', 'all');
end
fprintf('allocated %d | workers %d | parallel %d\n', nWant, numWorkers, useParallel);
format long

% 6 (delta_H) and 8 (delta_A) are NOT included: both are now floored, so they
% span under 2 decades and log-transforming them only distorts the sampling.
nDim   = length(LB);
logIdx = [1 2 3 4 7 9 24 29];
assert(all(LB(logIdx) > 0), 'log indices need LB>0: %s', mat2str(logIdx(LB(logIdx)<=0)));
LBt = LB;  UBt = UB;
LBt(logIdx) = log10(LB(logIdx));   UBt(logIdx) = log10(UB(logIdx));
assert(all(isfinite(LBt)) && all(isfinite(UBt)), 'log10 of a non-positive bound');
isLog = false(nDim,1);  isLog(logIdx) = true;
unlog = @(q) q(:).*(~isLog) + (10.^min(q(:),300)).*isLog;   % min() guards 10^inf*0
logIdx_active = logIdx;

fminOpts = optimoptions('fmincon','Algorithm','interior-point','UseParallel',useParallel, ...
    'MaxFunctionEvaluations',20000,'OptimalityTolerance',1e-8, ...
    'StepTolerance',1e-10,'FiniteDifferenceStepSize',1e-4,'Display','none');

% nAMED optionsslow so the warm-start version can extend it.
optionsslow = optimoptions('particleswarm', ...
    'UseParallel', useParallel, ...
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*ceil(50*nDim/numWorkers), ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ...
    'FunctionTolerance', 1e-8, ...
    'InertiaRange', [0.1, 1.2], ...      
    'SelfAdjustmentWeight', 1.8, ...
    'SocialAdjustmentWeight', 1.2, ...
    'MinNeighborsFraction', 0.10, ...   % exploration via topology
    'HybridFcn', {@fmincon, fminOpts}, ...
    'Display', 'final');

n_particles = numWorkers*ceil(100*nDim/numWorkers);   % must match SwarmSize

% one 35-element vector per region, from that region's full-sample Model 3
% fit. Leave a vector as [] to cold-start that region.
seed_AZ       = [];
seed_MARICOPA = [];
seed_PIMA     = [];
seed_PINAL    = [];

switch Region
    case 1, params_op = seed_AZ;
    case 2, params_op = seed_MARICOPA;
    case 3, params_op = seed_PIMA;
    case 4, params_op = seed_PINAL;
    otherwise, params_op = [];
end
params_op = params_op(:);

% seeding in natural units would place the particle outside the transformed
% box on every log index, and particleswarm would clip it to a corner.
q_seed = [];
if ~isempty(params_op)
    if numel(params_op) ~= nDim
        error('M3 seed has %d entries, need %d', numel(params_op), nDim);
    end
    outside = find(params_op < LB | params_op > UB);
    if ~isempty(outside)
        warning('M3:seedOutside', ...
            '%d seed entries lie outside the current bounds and will be clipped: %s', ...
            numel(outside), mat2str(outside'));
    end
    q_seed         = params_op(:)';
    q_seed(logIdx) = log10(max(params_op(logIdx), realmin));
    q_seed         = min(max(q_seed, LBt), UBt);
    fprintf('warm start: seeding every restart from the pasted vector.\n');
else
    fprintf('warm start: no seed pasted for Region %d; cold start.\n', Region);
end

nFitList  = [96 108 120];
yrLabel   = {'2021','2022','2023'};
nRestarts = 12;
Pfit = cell(3,1);  Ffit = nan(3,1);

for h = 1:3
    nF    = nFitList(h);
    tsp_h = t_inf_data(1:nF+1);
    y_h   = y_inf_data(1:nF+1);
    aP = nan(nRestarts,nDim);  aF = inf(nRestarts,1);

    for r = 1:nRestarts
        rng(8000 + 100*h + r);

        if isempty(q_seed)
            options = optionsslow;   % cold start
        else
% fresh random swarm each restart, pasted best fit as particle 1
            initial_swarm      = LBt + (UBt - LBt) .* rand(n_particles, nDim);
            initial_swarm(1,:) = q_seed;
            optionsslow2 = optimoptions(optionsslow, ...
                               'InitialSwarmMatrix', initial_swarm);
            options = optionsslow2;
        end

        [qR,fR] = particleswarm(@(q) objective_functionM3(unlog(q), tsp_h, ...
                    total_pop_t0, y_h, county), nDim, LBt, UBt, options);
        aP(r,:) = unlog(qR)';  aF(r) = fR;
        fprintf('h=%d (%s) restart %d/%d: obj = %.6e\n', h, yrLabel{h}, r, nRestarts, fR);
        save("m3_FOR_restarts_h" + h + "_" + county_M3 + ".mat", 'aP','aF','r');
    end

    [Ffit(h), rb] = min(aF);
    Pfit{h} = aP(rb,:)';
    fprintf('h=%d best %.6e | median %.6e | spread %.2f%%\n', ...
            h, Ffit(h), median(aF), 100*(max(aF)-min(aF))/min(aF));
    save("params_m3pswarm_FOR_" + nF + "mo_" + county_M3 + ".mat", 'aP','aF','LB','UB');
end
params_m3pswarm_8  = Pfit{1};
params_m3pswarm_9  = Pfit{2};
params_m3pswarm_10 = Pfit{3};

fitRRMSE = nan(3,1);  fcRRMSE = nan(3,1);
fcPers = nan(3,1);  fcSeas = nan(3,1);  fcMean = nan(3,1);
MMON = cell(3,1);  TMON = cell(3,1);  fcResid = cell(3,1);  solvUsed = cell(3,1);

for h = 1:3
    p   = Pfit{h};
    nF  = nFitList(h);
    t_m = t_inf_data(1:nF+13);
% through the objective: same solver chain, timeout and integration
    [~, ~, solvUsed{h}, mmon] = objective_functionM3(p, t_m, total_pop_t0, ...
                                    y_inf_data(1:nF+13), county);
    if isempty(mmon)
        warning('M3:forecastSolveFailed','horizon %d: all solvers failed', h);
        mmon = nan(nF+12,1);
    end
    MMON{h} = mmon;  TMON{h} = t_m(1:nF+12);

    dFit = y_inf_data(1:nF);          rFit = mmon(1:nF)       - dFit;
    dFc  = y_inf_data(nF+1:nF+12);    rFc  = mmon(nF+1:nF+12) - dFc;
    fitRRMSE(h) = 100*sqrt(mean(rFit.^2))/mean(dFit);
    fcRRMSE(h)  = 100*sqrt(mean(rFc.^2)) /mean(dFc);
    fcResid{h}  = rFc;   % for the Diebold-Mariano tests
    fcPers(h) = 100*sqrt(mean((y_inf_data(nF)         - dFc).^2))/mean(dFc);
    fcSeas(h) = 100*sqrt(mean((y_inf_data(nF-11:nF)   - dFc).^2))/mean(dFc);
    fcMean(h) = 100*sqrt(mean((mean(y_inf_data(1:nF)) - dFc).^2))/mean(dFc);
end

county_M3
fprintf('params_m3pswarm_8 = [%s%.15f];\n',  sprintf('%.15f; ', params_m3pswarm_8(1:end-1)),  params_m3pswarm_8(end));
fprintf('params_m3pswarm_9 = [%s%.15f];\n',  sprintf('%.15f; ', params_m3pswarm_9(1:end-1)),  params_m3pswarm_9(end));
fprintf('params_m3pswarm_10 = [%s%.15f];\n', sprintf('%.15f; ', params_m3pswarm_10(1:end-1)), params_m3pswarm_10(end));
fprintf('\n%s  Model 3 1-year-ahead forecast, RRMSE = RMSE/mean (%%)\n', county_M3);
fprintf('%-8s %8s %10s %10s %10s %10s\n','year','in-samp','FORECAST','persist','seasonal','trainmean');
for h = 1:3
    fprintf('%-8s %8.2f %10.2f %10.2f %10.2f %10.2f\n', yrLabel{h}, ...
            fitRRMSE(h), fcRRMSE(h), fcPers(h), fcSeas(h), fcMean(h));
end
fprintf('beats best baseline: %s\n', ...
        mat2str(fcRRMSE(:)' < min([fcPers fcSeas fcMean],[],2)'));
for h = 1:3
    fprintf('h=%d (%s): solver %-22s swarm obj %.6f | re-solve fit RRMSE %.4f%%\n', ...
            h, yrLabel{h}, solvUsed{h}, Ffit(h), fitRRMSE(h));
end
frst_year_forecast_rrmse = fcRRMSE(1);
scnd_year_forecast_rrmse = fcRRMSE(2);
thrd_year_forecast_rrmse = fcRRMSE(3);
save("m3_FOR_RRMSE_" + county_M3 + ".mat", 'fitRRMSE','fcRRMSE', ...
     'fcPers','fcSeas','fcMean','fcResid','solvUsed','nFitList','yrLabel');

figure('Position',[80 80 1100 560]);
hObs = scatter(t_inf_data(1:nMonths), y_inf_data(1:nMonths), 32, 'k', 'filled'); hold on
hFit = plot(TMON{1}(1:96), MMON{1}(1:96), 'LineWidth', 5, 'Color', [0 0 1 0.45]);
cols = [0.35 0.70 0.90; 0.00 0.60 0.50; 0.80 0.40 0.00];
hFc  = gobjects(3,1);
for h = 1:3
    nF = nFitList(h);
    hFc(h) = plot(TMON{h}(nF+1:nF+12), MMON{h}(nF+1:nF+12), 'LineWidth', 5, 'Color', cols(h,:));
    xline(t_inf_data(nF+1), 'k', 'LineWidth', 1.5);
end
legend([hObs; hFit; hFc], [{county_M3+' Infected', 'Model 3 fit (first 8 years)'}, ...
       cellfun(@(s) [s ' forecast'], yrLabel, 'UniformOutput', false)], ...
       'FontSize', 12, 'Location','northwest');
title('Forecast of '+county_M3+" Valley Fever Using Model 3",'FontSize',18)
subtitle(sprintf('forecast RRMSE  2021 %.1f%%  2022 %.1f%%  2023 %.1f%%   (best naive %.1f / %.1f / %.1f%%)', ...
    fcRRMSE(1), fcRRMSE(2), fcRRMSE(3), ...
    min([fcPers(1) fcSeas(1) fcMean(1)]), min([fcPers(2) fcSeas(2) fcMean(2)]), ...
    min([fcPers(3) fcSeas(3) fcMean(3)])),'FontSize',12)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',14); ylabel('New cases per month','FontSize',14)
ylim([0, max(y_inf_data)+200]); grid on; hold off
end

elseif choose_model==4
%% model 4a - Vector and Fungal Model dependent on Food and Environment

global alpha_h_Maricopa omega_Maricopa c_Maricopa alpha_h_Pinal omega_Pinal c_Pinal alpha_h_Pima omega_Pima c_Pima alpha_h_AZ omega_AZ c_AZ
global logIdx_active
omega_vital = 0.021/365;
alpha_h_Maricopa = 0.000500942192598 + omega_vital; omega_Maricopa = omega_vital; c_Maricopa = 0.000500942192598/4724819.974562017247081;
alpha_h_Pinal    = 0.000076238824090 + omega_vital; omega_Pinal    = omega_vital; c_Pinal    = 0.000076238824090/5162630.000;
alpha_h_Pima     = 0.000019432499300 + omega_vital; omega_Pima     = omega_vital; c_Pima     = 0.000019432499300/10639930.00;
alpha_h_AZ       = 0.000304888503016 + omega_vital; omega_AZ       = omega_vital; c_AZ       = 0.000304888503016/7853513.125630123540759;

if Region==1
    y_inf_data=y_inf_data_AZ; y_pop_data=y_pop_data_AZ;
    alpha_h_b=alpha_h_AZ; omega_b=omega_AZ; c=c_AZ;
    county_M4=["AZ"]; county=1;
elseif Region==2
    y_inf_data=y_inf_data_Maricopa; y_pop_data=y_pop_data_Maricopa;
    alpha_h_b=alpha_h_Maricopa; omega_b=omega_Maricopa; c=c_Maricopa;
    county_M4=["MARICOPA"]; county=2;
elseif Region==3
    y_inf_data=y_inf_data_Pima; y_pop_data=y_pop_data_Pima;
    alpha_h_b=alpha_h_Pima; omega_b=omega_Pima; c=c_Pima;
    county_M4=["PIMA"]; county=3;
elseif Region==4
    y_inf_data=y_inf_data_Pinal; y_pop_data=y_pop_data_Pinal;
    alpha_h_b=alpha_h_Pinal; omega_b=omega_Pinal; c=c_Pinal;
    county_M4=["PINAL"]; county=4;
else
    error('No Region Selected!');
end
total_pop_t0 = y_pop_data(1);
nMonths = 132;
Nbar    = mean(y_pop_data);
drainE  = omega_b + c*Nbar;

if single_run_or_fitting==1
% sINGLE RUN
disp(['Running Model 4a single parameter run, Region: ',num2str(Region)])

delta_O_v=0.02;   mu_H_v=0.0005;    gamma_H_v=0.0008;
H_max_v=350;      delta_H_v=0.005;  gamma_A_v=0.02;
delta_A_v=0.01;   phi_A_v=1.5e-6;
T_opt_H_v=75;     T_opt_A_v=82;
S_opt_H_v=11.5;   S_opt_A_v=8.5;    T_decay_v=60;
blTA=500; abTA=70; blTH=500; abTH=70;
blSA=6;   abSA=2;  blSH=6;   abSH=2;
T_hs_v=79;        beta_v=0.0012;    delta_V_v=0.0002;
sigma_v=7e-11;    T_cs_v=69;
alpha_v=1.0e-7;   S_d_s_v=7;        T_d_s_v=31;      xtr_c_s_v=10;
alpha_h_v=alpha_h_b;  epsilon_v=8.0e-9;
omega_v=omega_b;  rho_v=1/90;       kappa_v=2.1e-4;
psi_v=1/14;       delta_D_v=0.001;  c_v=c;

paramsm4_S=[delta_O_v; mu_H_v; gamma_H_v; H_max_v; delta_H_v; gamma_A_v; ...
            delta_A_v; phi_A_v; T_opt_H_v; T_opt_A_v; S_opt_H_v; S_opt_A_v; ...
            T_decay_v; blTA; abTA; blTH; abTH; blSA; abSA; blSH; abSH; ...
            T_hs_v; beta_v; delta_V_v; sigma_v; T_cs_v; alpha_v; S_d_s_v; ...
            T_d_s_v; xtr_c_s_v; alpha_h_v; epsilon_v; omega_v; rho_v; ...
            kappa_v; psi_v; delta_D_v; c_v];
assert(numel(paramsm4_S)==38, 'paramsm4_S must have 38 entries, has %d', numel(paramsm4_S));

ic_V=5000; ic_O=40; ic_D=70; ic_H=100; ic_A=50;
ic_I=y_inf_data(1);  ic_E=ic_I*1.5;  ic_R=ic_I/2;
ic_S=total_pop_t0-ic_I-ic_E-ic_R;
y0=[ic_V;ic_O;ic_D;ic_H;ic_A;ic_S;ic_E;ic_I;ic_R];   % 9 elements

t_day=(t_inf_data(1):1:t_inf_data(nMonths+1))';
[t,y]=ode15s(@(tt,yy) M4_SF_S(tt,yy,paramsm4_S,county), t_day, y0, odeset('MaxStep',1));

figure
plot(t/365,y(:,1),'LineWidth',2)
legend('Wildlife V','Location','best'); grid on
title("Model 4a single run - wildlife reservoir",'FontSize',16)
xlabel('Year','FontSize',13)

figure
plot(t/365,y(:,2),'LineWidth',2); hold on; plot(t/365,y(:,3),'LineWidth',2)
legend('Organic Matter O','Decayed Organic Matter D','Location','best'); grid on
title("Model 4a single run - substrate",'FontSize',16)
xlabel('Year','FontSize',13); hold off

figure
plot(t/365,y(:,4),'LineWidth',2); hold on; plot(t/365,y(:,5),'LineWidth',2)
legend('Hyphae H','Arthroconidia A','Location','best'); grid on
title("Model 4a single run - fungal compartments",'FontSize',16)
xlabel('Year','FontSize',13); hold off

figure
plot(t/365,y(:,6),'LineWidth',2); hold on
plot(t/365,y(:,7),'LineWidth',2); plot(t/365,y(:,8),'LineWidth',2); plot(t/365,y(:,9),'LineWidth',2)
legend('Susceptible','Exposed','Infected','Recovered','Location','best'); grid on
title("Model 4a single run - human compartments",'FontSize',16)
xlabel('Year','FontSize',13); ylabel('Humans','FontSize',13); hold off

cf=cumtrapz(t, psi_v*y(:,7));
im=round(t_inf_data(1:nMonths+1)-t_inf_data(1))+1;
mmon=diff(cf(im));
figure
scatter(t_inf_data(1:nMonths),y_inf_data(1:nMonths),28,'k','filled'); hold on
plot(t_inf_data(1:nMonths),mmon,'LineWidth',2.5)
legend(county_M4+' reported','Model 4a monthly incidence','Location','best'); grid on
title("Model 4a single run - monthly incidence vs data",'FontSize',16)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',13); ylabel('Cases per month','FontSize',13); hold off
fprintf('single run: N(0)=%.0f  N(end)=%.0f  mean monthly incidence %.1f (data %.1f)\n', ...
        sum(y(1,6:9)), sum(y(end,6:9)), mean(mmon), mean(y_inf_data(1:nMonths)));

elseif single_run_or_fitting==2
% fITTING
disp(['Running Model 4a fitting, Region: ',num2str(Region)])
tspan = t_inf_data(1:nMonths+1);
y_fit = y_inf_data(1:nMonths+1);

% changes from the previous version are marked <<<.
% index map: 1 delta_O, 2 mu_H, 3 gamma_H, 4 H_max, 5 delta_H, 6 gamma_A,
% 7 delta_A, 8 phi_A, 9 T_opt_H, 10 T_opt_A, 11 S_opt_H, 12 S_opt_A,
% 13 T_decay, 14 bl_Topt_A, 15 ab_Topt_A, 16 bl_Topt_H, 17 ab_Topt_H,
% 18 bl_Sopt_A, 19 ab_Sopt_A, 20 bl_Sopt_H, 21 ab_Sopt_H, 22 T_hs, 23 beta,
% 24 delta_V, 25 sigma, 26 T_cs, 27 alpha, 28 S_d_s, 29 T_d_s, 30 xtr_c_s,
% 31 alpha_h, 32 epsilon, 33 omega, 34 rho, 35 kappa, 36 psi, 37 delta_D,
% 38 c, 39-44 ic_V ic_O ic_D ic_H ic_A ic_E
% delta_O                 mu_H
LB(1) = 0.00001;         LB(2) = 0.000001;
UB(1) = 0.1;             UB(2) = 0.1;

% gamma_H                 H_max                  delta_H
% <<< LB(5) raised to 1/365 and 5 REMOVED from slack_idx. At 1e-6 x0.7 = 7e-7
% the hyphal time constant reaches 1.4 million days, which is how M5's AZ fit
% froze H at its initial condition while V, O and D starved around it.
LB(3) = 0.00000001;      LB(4) = 210;           LB(5) = 0.0001;
UB(3) = 0.06;            UB(4) = 500;           UB(5) = 0.3;

% gamma_A                 delta_A                phi_A
% <<< LB(7) raised to 1/120 and 7 REMOVED from slack_idx. THE MOST IMPORTANT
% cHANGE. At 1e-7 x0.7 = 7e-8 the arthroconidial time constant reaches 14
% mILLION days. M5's AZ fit at 1,474 days already removed 96% of the annual
% cycle before it reached epsilon*S*A; a 120-day cap retains about 44%.
LB(6) = 0.000001;        LB(7) = 1/120;         LB(8) = 0.000000001;
UB(6) = 0.1;             UB(7) = 0.5;           UB(8) = 0.00001;

% t_opt_H (base)          T_gap (where T_opt_A = T_opt_H + T_gap)
LB(9) = 65;              LB(10) = 0.5;
UB(9) = 100;             UB(10) = 25;

% s_opt_A (base)          S_gap (where S_opt_H = S_opt_A + S_gap)
LB(11) = 7;              LB(12) = 0.2;
UB(11) = 9.8;            UB(12) = 8;

% response widths
% <<< LB(14) 200 -> 50 and UB(15) 100 -> 400: M5's fits ran bl_Topt_A to its
% ceiling (1037 of 1050) and ab_Topt_A to 520.
% <<< 18 and 20 REMOVED from slack_idx: bl_Sopt_H floored out in all three M5
% regions fitted (0.605, 0.657, 0.712), making F_H_Sm a step function.
LB(14) = 50;             LB(15) = 30;           LB(16) = 200;
UB(14) = 700;            UB(15) = 400;          UB(16) = 700;
LB(17) = 30;             LB(18) = 1;            LB(19) = 1;
UB(17) = 100;            UB(18) = 20;           UB(19) = 20;
LB(20) = 1;              LB(21) = 1;
UB(20) = 20;             UB(21) = 20;
% lB(19) and LB(21) at 1.0 (not 0.1): a width of 0.1 collapses the response to
% exp(-large) within a fraction of a PZI unit, a step function that fits noise.

% t_hs  (upper breeding cutoff)
% could close to ZERO width. M5 had exactly this and the wildlife compartment
% collapsed by a factor of 1e-19 in all three regions fitted, which starved
% o and D and left the whole ecological chain inert. V persists only if
% beta*mean(F_bs) >= delta_V, so all four of T_hs, T_cs, beta and delta_V are
% constrained together and all four leave slack_idx.
LB(22) = 80;             UB(22) = 105;

% beta                    delta_V
% <<< LB(23) raised so a small beta cannot strand delta_V above its own floor;
% uB(24) capped so delta_V cannot outrun beta*mean(F_bs). With the widened
% window mean(F_bs) is roughly 0.28 to 0.34, and 0.008/0.05 = 0.16 clears it.
LB(23) = 0.0001;         LB(24) = 0.000008;
UB(23) = 0.05;           UB(24) = 0.008;

% sigma                   T_cs
% <<< UB(26) lowered 75 -> 70 and LB(26) 60 -> 50, giving a window >= 18 F.
LB(25) = 0.000000000001;  LB(26) = 50;
UB(25) = 0.0000000007;    UB(26) = 70;

% alpha                   S_d_s
% <<< LB(28) raised 5 -> 6.8. Minimum observed Palmer Z-Index is 5.54 (AZ),
% 6.36 (Pima), 6.69 (Pinal), 6.72 (Maricopa). At 5 the fit could set S_d_s
% below the regional minimum, so F_dr == 1 for every month and xtr_c_s had no
% gradient at all. M5's Maricopa fit chose 7.07 and pushed xtr_c_s to its
% ceiling, so the drought-mortality term is doing real work.
% lB(28): the smallest PZI value strictly above the regional minimum, so that
% f_dr has a nonzero gradient. Tie-safe: Pima's minimum is duplicated.
Z_pzi    = pzi_series(county);
S_d_s_LB = min(Z_pzi(Z_pzi > min(Z_pzi)));
LB(27) = 0.0000000005;   LB(28) = S_d_s_LB;
% lB(27) = 0.0000000005;   LB(28) = 6.8;
UB(27) = 0.0001;         UB(28) = 10;

% xtr_c_s                 epsilon
% <<< UB(30) raised 20 -> 100. M5's Maricopa fit sat at 59.98 against a ceiling
% of 60, so 20 x1.4 = 28 would bind immediately.
LB(30) = 1;              LB(32) = 0.00000001;
UB(30) = 100;            UB(32) = 0.0001;

% delta_D
LB(37) = 0.000001;       UB(37) = 0.06;

% psi -- Model 4a has no A_H, so 1/psi IS the incubation period (as in M2
% and M3, unlike M5 where psi_A doubled the drain on E). Solve
% psi + drainE = 1/incubation for CDC's 1 to 3 weeks.
assert(drainE < 1/21, 'drainE %.3e exceeds 1/21; psi bounds would invert', drainE);
LB(36) = 1/21 - drainE;
UB(36) = 1/7  - drainE;

% initial conditions
LB(39) = 10;    UB(39) = 20000;   % ic_V  wildlife
LB(40) = 1;     UB(40) = 1000;   % ic_O
LB(41) = 1;     UB(41) = 1000;   % ic_D
LB(42) = 1;     UB(42) = 500;   % ic_H  (re-capped after widening)
LB(43) = 1;     UB(43) = 2000;   % ic_A  <<< 1000 -> 2000
psi_mid  = 0.5*(LB(36) + UB(36));
ic_E_est = (y_inf_data(1)/31) / psi_mid;
LB(44) = 0.5*ic_E_est;   UB(44) = 2.0*ic_E_est;

% excluded and why:
% 13, 29           pinned (T_decay, T_d_s)
% 5                delta_H floor must hold (H must not freeze)
% 7                delta_A floor must hold (A must transmit the annual cycle)
% 9, 10            temperature optima must stay physical
% 11, 12           S_opt ordering must hold
% 18,19,20,21      width floors must hold (no step-function responses)
% 22,23,24,26      breeding-window / V-persistence balance must hold
% 28               S_d_s must stay above the PZI minimum so F_dr can fire
% 31,33,34,35,36,38  demography, clinical rates and psi from external data
% 44               ic_E derived from the data
slack_idx = [1 2 3 4 6 8 14 15 16 17 25 27 30 32 37 39 40 41 42 43];
LB(slack_idx) = LB(slack_idx) * 0.6;
UB(slack_idx) = UB(slack_idx) * 1.5;

% <<< ic_H must stay below the smallest H_max the fit can choose, or
% (1 - H/H_max) starts negative and H crashes through a spurious transient.
UB(42) = min(UB(42), 0.9*LB(4));

% t_decay is NOT identifiable alongside delta_O: the decay term is
% (TF/T_decay)*delta_O, so only the ratio is determined. Pin T_decay and let
% delta_O carry the scale. Same degeneracy M5 had with (k_ref, T_ref).
LB(13) = 60;               UB(13) = 60;   % T_decay

% t_d_s is unused in M4_SF_S: the temperature factor is commented out of the
% f_dr branch, so only the soil-moisture part is active. Keep pinned.
LB(29) = 31;               UB(29) = 31;   % T_d_s

% rho and kappa appear only in dI and dR, so under an incidence objective they
% reach the flux only through N and are unidentifiable. Set, not fitted.
CFR_corrected = 0.01805;   % <-- Kappa_Estimate!B8
rho_fixed     = 1/90;
kappa_fixed   = CFR_corrected*(rho_fixed + omega_b + c*Nbar)/(1-CFR_corrected);

LB(34) = rho_fixed;        UB(34) = rho_fixed;   % rho
LB(35) = kappa_fixed;      UB(35) = kappa_fixed;   % kappa
LB(33) = omega_b*0.99999;  UB(33) = omega_b*1.00001;   % omega
LB(31) = omega_b*1.00001;  UB(31) = alpha_h_b*1.00001;   % alpha_h
LB(38) = c*0.9999;         UB(38) = c*1.0001;   % c

assert(numel(LB)==44 && numel(UB)==44, 'LB/UB must be length 44, got %d/%d', numel(LB), numel(UB));
assert(LB(31) >= UB(33), 'net growth can go negative');
assert(LB(22) >  UB(26), 'breeding window can invert: LB(T_hs) must exceed UB(T_cs)');
assert(UB(42) <  LB(4),  'ic_H upper bound must sit below the smallest H_max');
assert(all(LB <= UB), 'LB>UB at %s', mat2str(find(LB>UB)));

% f_dr must be able to fire, or S_d_s and xtr_c_s are unidentified and
% contribute null columns to the sensitivity matrix in section 20.
assert(LB(28) > min(pzi_series(county)), ...
       'S_d_s lower bound must exceed min(PZI) or F_dr never fires');
assert(LB(28) < UB(28), 'S_d_s bounds inverted');
nFire = sum(pzi_series(county) < LB(29));
fprintf('S_d_s in [%.3f %.2f] | F_dr can fire in >= %d of 132 months\n', ...
        LB(28), UB(28), nFire);

tauA_max = 1/LB(7);
retA     = 1/sqrt(1 + (2*pi*(tauA_max/30.44)/12)^2);
fprintf('kappa %.4e/day | rho %.4e/day | psi in [%.5f %.5f] | free %d of 44\n', ...
        kappa_fixed, rho_fixed, LB(36), UB(36), sum(UB>LB));
fprintf('A pool tau <= %.0f d -> >= %.0f%% of the annual cycle survives | H turnover <= %.0f d\n', ...
        tauA_max, 100*retA, 1/LB(5));
fprintf('breeding window >= %.1f F | delta_V <= %.4f vs beta_max %.4f | S_d_s >= %.2f\n', ...
        LB(22)-UB(26), UB(24), UB(23), LB(28));
fprintf('ic_H in [%.2f %.2f], H_max in [%.0f %.0f]\n', LB(42), UB(42), LB(4), UB(4));

nAlloc = str2double(getenv('SLURM_CPUS_PER_TASK'));
if isnan(nAlloc) || nAlloc < 1, nAlloc = str2double(getenv('SLURM_CPUS_ON_NODE')); end
if isnan(nAlloc) || nAlloc < 1, nAlloc = feature('numcores'); end
nWant = max(1, floor(nAlloc));
pool = gcp('nocreate');
if ~isempty(pool) && pool.NumWorkers ~= nWant, delete(pool); pool = []; end
if isempty(pool)
    try
        try
            cl = parcluster('Processes');
        catch
            cl = parcluster('local');
        end
        jid = getenv('SLURM_JOB_ID');
        if ~isempty(jid)
            jsl = fullfile(tempdir, ['mlpool_' jid]);
            if ~exist(jsl,'dir'), mkdir(jsl); end
            cl.JobStorageLocation = jsl;
        end
        cl.NumWorkers = nWant;  pool = parpool(cl, nWant);
    catch ME
        warning('M4:parpoolFailed','parpool failed (%s). Running serial.', ME.message);
        pool = [];
    end
end
if isempty(pool)
    numWorkers = 1;  useParallel = false;
else
    numWorkers = pool.NumWorkers;  useParallel = true;
    pctRunOnAll warning('off', 'all');
end
fprintf('allocated %d | workers %d | parallel %d\n', nWant, numWorkers, useParallel);
format long

nDim   = length(LB);
logIdx = [1 2 3 6 8 23 27 32 37];
assert(all(LB(logIdx) > 0), 'log indices need LB>0: %s', mat2str(logIdx(LB(logIdx)<=0)));
LBt = LB;  UBt = UB;
LBt(logIdx) = log10(LB(logIdx));   UBt(logIdx) = log10(UB(logIdx));
assert(all(isfinite(LBt)) && all(isfinite(UBt)), 'log10 of a non-positive bound');
isLog = false(nDim,1);  isLog(logIdx) = true;
unlog = @(q) q(:).*(~isLog) + (10.^min(q(:),300)).*isLog;
logIdx_active = logIdx;

fminOpts = optimoptions('fmincon','Algorithm','interior-point','UseParallel',useParallel, ...
    'MaxFunctionEvaluations',20000,'OptimalityTolerance',1e-8, ...
    'StepTolerance',1e-10,'FiniteDifferenceStepSize',1e-4,'Display','none');
optionsslow = optimoptions('particleswarm', ...
    'UseParallel', useParallel, ...
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*ceil(50*nDim/numWorkers), ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ...
    'FunctionTolerance', 1e-8, ...
    'InertiaRange', [0.1, 1.2], ...      
    'SelfAdjustmentWeight', 1.8, ...
    'SocialAdjustmentWeight', 1.2, ...
    'MinNeighborsFraction', 0.10, ...   % exploration via topology
    'HybridFcn', {@fmincon, fminOpts}, ...
    'Display', 'final');

options=optionsslow;
nRestarts = 20;
allP = nan(nRestarts,nDim);  allF = inf(nRestarts,1);
for r = 1:nRestarts
    rng(9000 + r);
    [qR,fR] = particleswarm(@(q) objective_functionM4_S(unlog(q), tspan, total_pop_t0, y_fit, county), ...
                            nDim, LBt, UBt, options);
    allP(r,:) = unlog(qR)';  allF(r) = fR;
    fprintf('restart %2d/%d: obj = %.6e\n', r, nRestarts, fR);
    fprintf('params_m4pswarm = [%s%.15f];\n', sprintf('%.15f; ', allP(r,1:end-1)), allP(r,end));
    save("m4_restarts_" + county_M4 + ".mat", 'allP','allF','r');
end
[errorOBJ, rBest] = min(allF);
params_m4pswarm   = allP(rBest,:)';
fprintf('best %.6e | median %.6e | spread %.2f%%\n', ...
        errorOBJ, median(allF), 100*(max(allF)-min(allF))/min(allF));

fprintf('params_m4pswarm = [%s%.15f];\n', ...
        sprintf('%.15f; ', params_m4pswarm(1:end-1)), params_m4pswarm(end));
nFree = sum(UB > LB);
fprintf('Region: %s | RRMSE = %.6f | free params: %d of %d\n', ...
        county_M4, errorOBJ, nFree, nDim);
save("params_m4pswarm_" + county_M4 + ".mat", 'params_m4pswarm','LB','UB','errorOBJ');
save("m4_RRMSE_" + county_M4 + ".mat", 'errorOBJ');

p = params_m4pswarm;
[chk, Yf, solvFit, mmon] = objective_functionM4_S(p, tspan, total_pop_t0, y_fit, county);
t_d = (tspan(1):1:tspan(end))';
fprintf('fit solver: %-22s | swarm obj %.6f | re-solve obj %.6f\n', ...
        solvFit, errorOBJ, chk);
if abs(chk - errorOBJ) > 1e-6
    warning('M4:objMismatch', ...
        'Re-solve objective %.6f differs from the swarm value %.6f. A different solver may have won on this window.', ...
        chk, errorOBJ);
end
if isempty(mmon), error('M4: all solvers failed on the full window'); end

rrmse      = errorOBJ;
data_mon   = y_inf_data(1:end-1);
n          = numel(data_mon);
k          = sum(UB > LB);
noiseFloor = 100*(std(diff(data_mon,2))/sqrt(6))/mean(data_mon);

r    = data_mon(:) - mmon(:);
nIC  = numel(r);
rss  = sum(r.^2);
p    = k + 1;
logL = -nIC/2 * ( log(2*pi) + log(rss/nIC) + 1 );
aic  = -2*logL + 2*p;
if nIC - p - 1 > 0
    aicc = aic + 2*p*(p+1)/(nIC - p - 1);
else
    aicc = NaN;
end
bic  = -2*logL + p*log(nIC);
fprintf('\nModel 4a information criteria (Gaussian least squares)\n');
fprintf('  n = %d | free structural k = %d | p = k+1 = %d\n', nIC, k, p);
fprintf('  RRMSE  : %.6f\n', sqrt(mean(r.^2))/mean(data_mon));
fprintf('  RSS    : %.4f\n', rss);
fprintf('  logL   : %.4f\n', logL);
fprintf('  AIC    : %.4f\n', aic);
fprintf('  AICc   : %.4f\n', aicc);
fprintf('  BIC    : %.4f\n', bic);
aic
aicc
bic

fprintf('  RRMSE reported by the swarm : %.6f  (noise floor %.4f)\n', rrmse, noiseFloor/100);
ICnb = nb_ic(data_mon, max(mmon(:),1e-6), k, "Model 4 " + county_M4);
aic_gauss = aic;  aicc_gauss = aicc;  bic_gauss = bic;
aic = ICnb.aic;  aicc = ICnb.aicc;  bic = ICnb.bic;
save("m4_IC_" + county_M4 + ".mat", 'ICnb','n','k','rrmse','aic','aicc','bic','aic_gauss','aicc_gauss','bic_gauss','noiseFloor');

if isempty(mmon), error('M4: all solvers failed on the full window'); end

figure
scatter(t_inf_data(1:nMonths), data_mon, 30, 'k', 'filled'); hold on
plot(t_inf_data(1:nMonths), mmon, 'LineWidth', 3, 'Color', [0 0 1 0.5]);
legend(county_M4+' reported','Model 4a fit','Location','northwest');
title(county_M4+" Valley Fever - Model 4a monthly incidence fit",'FontSize',16)
subtitle(sprintf('RRMSE %.2f%%  (noise floor %.2f%%)  |  AIC %.1f  BIC %.1f', ...
         rrmse*100, noiseFloor, aic, bic),'FontSize',11)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',13); ylabel('Cases per month','FontSize',13)
ylim([0, max(data_mon)*1.25]); grid on; hold off

figure
plot(t_d/365, Yf(:,1),'LineWidth',2); hold on; plot(t_d/365, Yf(:,2),'LineWidth',2)
plot(t_d/365, Yf(:,3),'LineWidth',2); plot(t_d/365, Yf(:,4),'LineWidth',2)
plot(t_d/365, Yf(:,5),'LineWidth',2)
legend('Wildlife V','Organic Matter O','Decayed D','Hyphae H','Arthroconidia A','Location','best')
title("Model 4a fitted wildlife, substrate and fungal compartments",'FontSize',15)
xlabel('Year','FontSize',13); grid on; hold off

%% ======================================================================
elseif single_run_or_fitting==3
% fORECASTING Model 4a
% uses M4_SF_S (44 parameters, 9 states). One daily solve per horizon
% through the objective, so the solver chain, timeout and monthly
% integration are identical to the fit.
% fIXES relative to the previous draft of this section:
% 1. optionsslow was referenced in the cold-start branch but NEVER DEFINED
% (the options block was named `options`). Any region without a pasted
% seed would have died with an undefined-variable error.
% 2. make_warm was called once per HORIZON, outside the restart loop, so all
% 6 restarts of a horizon started from an identical swarm. The swarm is
% now rebuilt inside the restart loop, after rng, with the seed as
% particle 1.
% 3. total_pop_t0, Nbar and drainE were used but never defined here.
% nbar feeds kappa_fixed; drainE feeds the psi bounds.
% 4. logIdx included 5 (delta_H) and 7 (delta_A). Both are now floored and
% span under 1.9 decades, so log-transforming them only distorts the
% uniform sampling. Removed; 25 (sigma) added, which does span 3 decades.
% 5. No MaxTime on the swarm, so one horizon could run unbounded.
% 6. solvUsed was collected but not saved.
% 7. The slack widening here is x0.7/x1.4 whereas the Model 3 section uses
% x0.6/x1.5. That is fine ACROSS models but must match the Model 4a
% fITTING section exactly -- check before running.
disp(['Running Model 4a Forecasting, Region: ',num2str(Region)])

total_pop_t0 = y_pop_data(1);
nMonths      = 132;

% nbar is the mean population over the window. drainE is the per-capita drain
% on the exposed compartment from mortality and crowding, which the psi bounds
% subtract so that 1/(psi + drainE) is the incubation period.
Nbar   = mean(y_pop_data);
drainE = omega_b + c*Nbar;
% delta_O                 mu_H
LB(1) = 0.00001;         LB(2) = 0.000001;
UB(1) = 0.1;             UB(2) = 0.1;

% gamma_H                 H_max                  delta_H
% <<< LB(5) raised to 1/365 and 5 REMOVED from slack_idx. At 1e-6 x0.7 = 7e-7
% the hyphal time constant reaches 1.4 million days, which is how M5's AZ fit
% froze H at its initial condition while V, O and D starved around it.
LB(3) = 0.00000001;      LB(4) = 210;           LB(5) = 0.0001;
UB(3) = 0.06;            UB(4) = 500;           UB(5) = 0.3;

% gamma_A                 delta_A                phi_A
% <<< LB(7) raised to 1/120 and 7 REMOVED from slack_idx. THE MOST IMPORTANT
% cHANGE. At 1e-7 x0.7 = 7e-8 the arthroconidial time constant reaches 14
% mILLION days. M5's AZ fit at 1,474 days already removed 96% of the annual
% cycle before it reached epsilon*S*A; a 120-day cap retains about 44%.
LB(6) = 0.000001;        LB(7) = 1/120;         LB(8) = 0.000000001;
UB(6) = 0.1;             UB(7) = 0.5;           UB(8) = 0.00001;

% t_opt_H (base)          T_gap (where T_opt_A = T_opt_H + T_gap)
LB(9) = 65;              LB(10) = 0.5;
UB(9) = 100;             UB(10) = 25;

% s_opt_A (base)          S_gap (where S_opt_H = S_opt_A + S_gap)
LB(11) = 7;              LB(12) = 0.2;
UB(11) = 9.8;            UB(12) = 8;

% response widths
% <<< LB(14) 200 -> 50 and UB(15) 100 -> 400: M5's fits ran bl_Topt_A to its
% ceiling (1037 of 1050) and ab_Topt_A to 520.
% <<< 18 and 20 REMOVED from slack_idx: bl_Sopt_H floored out in all three M5
% regions fitted (0.605, 0.657, 0.712), making F_H_Sm a step function.
LB(14) = 50;             LB(15) = 30;           LB(16) = 200;
UB(14) = 700;            UB(15) = 400;          UB(16) = 700;
LB(17) = 30;             LB(18) = 1;            LB(19) = 1.0;
UB(17) = 100;            UB(18) = 20;           UB(19) = 20;
LB(20) = 1;              LB(21) = 1.0;
UB(20) = 20;             UB(21) = 20;
% lB(19) and LB(21) at 1.0 (not 0.1): a width of 0.1 collapses the response to
% exp(-large) within a fraction of a PZI unit, a step function that fits noise.

% t_hs  (upper breeding cutoff)
% could close to ZERO width. M5 had exactly this and the wildlife compartment
% collapsed by a factor of 1e-19 in all three regions fitted, which starved
% o and D and left the whole ecological chain inert. V persists only if
% beta*mean(F_bs) >= delta_V, so all four of T_hs, T_cs, beta and delta_V are
% constrained together and all four leave slack_idx.
LB(22) = 80;             UB(22) = 105;

% beta                    delta_V
% <<< LB(23) raised so a small beta cannot strand delta_V above its own floor;
% uB(24) capped so delta_V cannot outrun beta*mean(F_bs). With the widened
% window mean(F_bs) is roughly 0.28 to 0.34, and 0.008/0.05 = 0.16 clears it.
LB(23) = 0.0001;         LB(24) = 0.000008;
UB(23) = 0.05;           UB(24) = 0.008;

% sigma                   T_cs
% <<< UB(26) lowered 75 -> 70 and LB(26) 60 -> 50, giving a window >= 18 F.
LB(25) = 0.000000000001;  LB(26) = 50;
UB(25) = 0.0000000007;    UB(26) = 70;

% alpha                   S_d_s
% <<< LB(28) raised 5 -> 6.8. Minimum observed Palmer Z-Index is 5.54 (AZ),
% 6.36 (Pima), 6.69 (Pinal), 6.72 (Maricopa). At 5 the fit could set S_d_s
% below the regional minimum, so F_dr == 1 for every month and xtr_c_s had no
% gradient at all. M5's Maricopa fit chose 7.07 and pushed xtr_c_s to its
% ceiling, so the drought-mortality term is doing real work.
% lB(29): the smallest PZI value strictly above the regional minimum, so that
% f_dr has a nonzero gradient. Tie-safe: Pima's minimum is duplicated.
Z_pzi    = pzi_series(county);
S_d_s_LB = min(Z_pzi(Z_pzi > min(Z_pzi)));
LB(27) = 0.0000000005;   LB(28) = S_d_s_LB; 
% lB(27) = 0.0000000005;   LB(28) = 6.8;
UB(27) = 0.0001;         UB(28) = 10;

% xtr_c_s                 epsilon
% <<< UB(30) raised 20 -> 100. M5's Maricopa fit sat at 59.98 against a ceiling
% of 60, so 20 x1.4 = 28 would bind immediately.
LB(30) = 1;              LB(32) = 0.00000001;
UB(30) = 100;            UB(32) = 0.0001;

% delta_D
LB(37) = 0.000001;       UB(37) = 0.06;

% psi -- Model 4a has no A_H, so 1/psi IS the incubation period (as in M2
% and M3, unlike M5 where psi_A doubled the drain on E). Solve
% psi + drainE = 1/incubation for CDC's 1 to 3 weeks.
assert(drainE < 1/21, 'drainE %.3e exceeds 1/21; psi bounds would invert', drainE);
LB(36) = 1/21 - drainE;
UB(36) = 1/7  - drainE;

% initial conditions
LB(39) = 10;    UB(39) = 20000;   % ic_V  wildlife
LB(40) = 1;     UB(40) = 1000;   % ic_O
LB(41) = 1;     UB(41) = 1000;   % ic_D
LB(42) = 1;     UB(42) = 500;   % ic_H  (re-capped after widening)
LB(43) = 1;     UB(43) = 2000;   % ic_A  <<< 1000 -> 2000
psi_mid  = 0.5*(LB(36) + UB(36));
ic_E_est = (y_inf_data(1)/31) / psi_mid;
LB(44) = 0.5*ic_E_est;   UB(44) = 2.0*ic_E_est;

% excluded and why:
% 13, 29           pinned (T_decay, T_d_s)
% 5                delta_H floor must hold (H must not freeze)
% 7                delta_A floor must hold (A must transmit the annual cycle)
% 9, 10            temperature optima must stay physical
% 11, 12           S_opt ordering must hold
% 18,19,20,21      width floors must hold (no step-function responses)
% 22,23,24,26      breeding-window / V-persistence balance must hold
% 28               S_d_s must stay above the PZI minimum so F_dr can fire
% 31,33,34,35,36,38  demography, clinical rates and psi from external data
% 44               ic_E derived from the data
slack_idx = [1 2 3 4 6 8 14 15 16 17 25 27 30 32 37 39 40 41 42 43];
LB(slack_idx) = LB(slack_idx) * 0.6;
UB(slack_idx) = UB(slack_idx) * 1.5;

% <<< ic_H must stay below the smallest H_max the fit can choose, or
% (1 - H/H_max) starts negative and H crashes through a spurious transient.
UB(42) = min(UB(42), 0.9*LB(4));

% t_decay is NOT identifiable alongside delta_O: the decay term is
% (TF/T_decay)*delta_O, so only the ratio is determined. Pin T_decay and let
% delta_O carry the scale. Same degeneracy M5 had with (k_ref, T_ref).
LB(13) = 60;               UB(13) = 60;   % T_decay

% t_d_s is unused in M4_SF_S: the temperature factor is commented out of the
% f_dr branch, so only the soil-moisture part is active. Keep pinned.
LB(29) = 31;               UB(29) = 31;   % T_d_s

% rho and kappa appear only in dI and dR, so under an incidence objective they
% reach the flux only through N and are unidentifiable. Set, not fitted.
CFR_corrected = 0.01805;   % <-- Kappa_Estimate!B8
rho_fixed     = 1/90;
kappa_fixed   = CFR_corrected*(rho_fixed + omega_b + c*Nbar)/(1-CFR_corrected);

LB(34) = rho_fixed;        UB(34) = rho_fixed;   % rho
LB(35) = kappa_fixed;      UB(35) = kappa_fixed;   % kappa
LB(33) = omega_b*0.99999;  UB(33) = omega_b*1.00001;   % omega
LB(31) = omega_b*1.00001;  UB(31) = alpha_h_b*1.00001;   % alpha_h
LB(38) = c*0.9999;         UB(38) = c*1.0001;   % c

assert(numel(LB)==44 && numel(UB)==44, 'LB/UB must be length 44, got %d/%d', numel(LB), numel(UB));
assert(LB(31) >= UB(33), 'net growth can go negative');

assert(LB(22) >  UB(26), 'breeding window can invert: LB(T_hs) must exceed UB(T_cs)');
assert(UB(42) <  LB(4),  'ic_H upper bound must sit below the smallest H_max');
assert(all(LB <= UB), 'LB>UB at %s', mat2str(find(LB>UB)));

% f_dr must be able to fire, or S_d_s and xtr_c_s are unidentified and
% contribute null columns to the sensitivity matrix in section 20.
assert(LB(28) > min(pzi_series(county)), ...
       'S_d_s lower bound must exceed min(PZI) or F_dr never fires');
assert(LB(28) < UB(28), 'S_d_s bounds inverted');
nFire = sum(pzi_series(county) < LB(29));
fprintf('S_d_s in [%.3f %.2f] | F_dr can fire in >= %d of 132 months\n', ...
        LB(28), UB(28), nFire);

tauA_max = 1/LB(7);
retA     = 1/sqrt(1 + (2*pi*(tauA_max/30.44)/12)^2);
fprintf('kappa %.4e/day | rho %.4e/day | psi in [%.5f %.5f] | free %d of 44\n', ...
        kappa_fixed, rho_fixed, LB(36), UB(36), sum(UB>LB));
fprintf('A pool tau <= %.0f d -> >= %.0f%% of the annual cycle survives | H turnover <= %.0f d\n', ...
        tauA_max, 100*retA, 1/LB(5));
fprintf('breeding window >= %.1f F | delta_V <= %.4f vs beta_max %.4f | S_d_s >= %.2f\n', ...
        LB(22)-UB(26), UB(24), UB(23), LB(28));
fprintf('ic_H in [%.2f %.2f], H_max in [%.0f %.0f]\n', LB(42), UB(42), LB(4), UB(4));

nAlloc = str2double(getenv('SLURM_CPUS_PER_TASK'));
if isnan(nAlloc) || nAlloc < 1, nAlloc = str2double(getenv('SLURM_CPUS_ON_NODE')); end
if isnan(nAlloc) || nAlloc < 1, nAlloc = feature('numcores'); end
nWant = max(1, floor(nAlloc));
pool = gcp('nocreate');
if ~isempty(pool) && pool.NumWorkers ~= nWant, delete(pool); pool = []; end
if isempty(pool)
    try
        try
            cl = parcluster('Processes');
        catch
            cl = parcluster('local');
        end
        jid = getenv('SLURM_JOB_ID');
        if ~isempty(jid)
            jsl = fullfile(tempdir, ['mlpool_' jid]);
            if ~exist(jsl,'dir'), mkdir(jsl); end
            cl.JobStorageLocation = jsl;
        end
        cl.NumWorkers = nWant;  pool = parpool(cl, nWant);
    catch ME
        warning('M4:parpoolFailed','parpool failed (%s). Running serial.', ME.message);
        pool = [];
    end
end
if isempty(pool)
    numWorkers = 1;  useParallel = false;
else
    numWorkers = pool.NumWorkers;  useParallel = true;
    pctRunOnAll warning('off', 'all');
end
fprintf('allocated %d | workers %d | parallel %d\n', nWant, numWorkers, useParallel);
format long

% 5 (delta_H) and 7 (delta_A) are NOT included: both are now floored, so they
% span 1.86 and 1.78 decades respectively and log-transforming them distorts
% the uniform sampling. 25 (sigma) IS included -- it spans about 3 decades.
nDim   = length(LB);
logIdx = [1 2 3 6 8 23 25 27 32 37];
assert(all(LB(logIdx) > 0), 'log indices need LB>0: %s', mat2str(logIdx(LB(logIdx)<=0)));
LBt = LB;  UBt = UB;
LBt(logIdx) = log10(LB(logIdx));   UBt(logIdx) = log10(UB(logIdx));
assert(all(isfinite(LBt)) && all(isfinite(UBt)), 'log10 of a non-positive bound');
isLog = false(nDim,1);  isLog(logIdx) = true;
unlog = @(q) q(:).*(~isLog) + (10.^min(q(:),300)).*isLog;   % min() guards 10^inf*0
logIdx_active = logIdx;

fminOpts = optimoptions('fmincon','Algorithm','interior-point','UseParallel',useParallel, ...
    'MaxFunctionEvaluations',20000,'OptimalityTolerance',1e-8, ...
    'StepTolerance',1e-10,'FiniteDifferenceStepSize',1e-4,'Display','none');

% nAMED optionsslow so the warm-start version can extend it.
optionsslow = optimoptions('particleswarm', ...
    'UseParallel', useParallel, ...
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*ceil(50*nDim/numWorkers), ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ...
    'FunctionTolerance', 1e-8, ...
    'InertiaRange', [0.1, 1.2], ...      
    'SelfAdjustmentWeight', 1.8, ...
    'SocialAdjustmentWeight', 1.2, ...
    'MinNeighborsFraction', 0.10, ...   % exploration via topology
    'HybridFcn', {@fmincon, fminOpts}, ...
    'Display', 'final');

n_particles = numWorkers*ceil(100*nDim/numWorkers);   % must match SwarmSize

% one 44-element vector per region, from that region's full-sample Model 4a
% fit. Leave a vector as [] to cold-start that region.
seed_AZ       = [];
seed_MARICOPA = [];
seed_PIMA     = [];
seed_PINAL    = [];

switch Region
    case 1, params_op = seed_AZ;
    case 2, params_op = seed_MARICOPA;
    case 3, params_op = seed_PIMA;
    case 4, params_op = seed_PINAL;
    otherwise, params_op = [];
end
params_op = params_op(:);

% seeding in natural units would place the particle outside the transformed
% box on every log index, and particleswarm would clip it to a corner.
q_seed = [];
if ~isempty(params_op)
    if numel(params_op) ~= nDim
        error('M4a seed has %d entries, need %d', numel(params_op), nDim);
    end
    outside = find(params_op < LB | params_op > UB);
    if ~isempty(outside)
        warning('M4a:seedOutside', ...
            '%d seed entries lie outside the current bounds and will be clipped: %s', ...
            numel(outside), mat2str(outside'));
    end
    q_seed         = params_op(:)';
    q_seed(logIdx) = log10(max(params_op(logIdx), realmin));
    q_seed         = min(max(q_seed, LBt), UBt);
    fprintf('warm start: seeding every restart from the pasted vector.\n');
else
    fprintf('warm start: no seed pasted for Region %d; cold start.\n', Region);
end

nFitList  = [96 108 120];
yrLabel   = {'2021','2022','2023'};
nRestarts = 12;
Pfit = cell(3,1);  Ffit = nan(3,1);

for h = 1:3
    nF    = nFitList(h);
    tsp_h = t_inf_data(1:nF+1);
    y_h   = y_inf_data(1:nF+1);
    aP = nan(nRestarts,nDim);  aF = inf(nRestarts,1);

    for r = 1:nRestarts
        rng(9500 + 100*h + r);

        if isempty(q_seed)
            options = optionsslow;   % cold start
        else
% fresh random swarm each restart, pasted best fit as particle 1
            initial_swarm      = LBt + (UBt - LBt) .* rand(n_particles, nDim);
            initial_swarm(1,:) = q_seed;
            optionsslow2 = optimoptions(optionsslow, ...
                               'InitialSwarmMatrix', initial_swarm);
            options = optionsslow2;
        end

        [qR,fR] = particleswarm(@(q) objective_functionM4_S(unlog(q), tsp_h, ...
                    total_pop_t0, y_h, county), nDim, LBt, UBt, options);
        aP(r,:) = unlog(qR)';  aF(r) = fR;
        fprintf('h=%d (%s) restart %d/%d: obj = %.6e\n', h, yrLabel{h}, r, nRestarts, fR);
        save("m4_FOR_restarts_h" + h + "_" + county_M4 + ".mat", 'aP','aF','r');
    end

    [Ffit(h), rb] = min(aF);
    Pfit{h} = aP(rb,:)';
    fprintf('h=%d best %.6e | median %.6e | spread %.2f%%\n', ...
            h, Ffit(h), median(aF), 100*(max(aF)-min(aF))/min(aF));
    save("params_m4pswarm_FOR_" + nF + "mo_" + county_M4 + ".mat", 'aP','aF','LB','UB');
end
params_m4pswarm_8  = Pfit{1};
params_m4pswarm_9  = Pfit{2};
params_m4pswarm_10 = Pfit{3};

fitRRMSE = nan(3,1);  fcRRMSE = nan(3,1);
fcPers = nan(3,1);  fcSeas = nan(3,1);  fcMean = nan(3,1);
MMON = cell(3,1);  TMON = cell(3,1);  fcResid = cell(3,1);  solvUsed = cell(3,1);

for h = 1:3
    p   = Pfit{h};
    nF  = nFitList(h);
    t_m = t_inf_data(1:nF+13);
% through the objective: same solver chain, timeout and integration
    [~, ~, solvUsed{h}, mmon] = objective_functionM4_S(p, t_m, total_pop_t0, ...
                                    y_inf_data(1:nF+13), county);
    if isempty(mmon)
        warning('M4:forecastSolveFailed','horizon %d: all solvers failed', h);
        mmon = nan(nF+12,1);
    end
    MMON{h} = mmon;  TMON{h} = t_m(1:nF+12);

    dFit = y_inf_data(1:nF);          rFit = mmon(1:nF)       - dFit;
    dFc  = y_inf_data(nF+1:nF+12);    rFc  = mmon(nF+1:nF+12) - dFc;
    fitRRMSE(h) = 100*sqrt(mean(rFit.^2))/mean(dFit);
    fcRRMSE(h)  = 100*sqrt(mean(rFc.^2)) /mean(dFc);
    fcResid{h}  = rFc;   % for the Diebold-Mariano tests
    fcPers(h) = 100*sqrt(mean((y_inf_data(nF)         - dFc).^2))/mean(dFc);
    fcSeas(h) = 100*sqrt(mean((y_inf_data(nF-11:nF)   - dFc).^2))/mean(dFc);
    fcMean(h) = 100*sqrt(mean((mean(y_inf_data(1:nF)) - dFc).^2))/mean(dFc);
end

county_M4
fprintf('params_m4pswarm_8 = [%s%.15f];\n',  sprintf('%.15f; ', params_m4pswarm_8(1:end-1)),  params_m4pswarm_8(end));
fprintf('params_m4pswarm_9 = [%s%.15f];\n',  sprintf('%.15f; ', params_m4pswarm_9(1:end-1)),  params_m4pswarm_9(end));
fprintf('params_m4pswarm_10 = [%s%.15f];\n', sprintf('%.15f; ', params_m4pswarm_10(1:end-1)), params_m4pswarm_10(end));
fprintf('\n%s  Model 4a 1-year-ahead forecast, RRMSE = RMSE/mean (%%)\n', county_M4);
fprintf('%-8s %8s %10s %10s %10s %10s\n','year','in-samp','FORECAST','persist','seasonal','trainmean');
for h = 1:3
    fprintf('%-8s %8.2f %10.2f %10.2f %10.2f %10.2f\n', yrLabel{h}, ...
            fitRRMSE(h), fcRRMSE(h), fcPers(h), fcSeas(h), fcMean(h));
end
fprintf('beats best baseline: %s\n', ...
        mat2str(fcRRMSE(:)' < min([fcPers fcSeas fcMean],[],2)'));
for h = 1:3
    fprintf('h=%d (%s): solver %-22s swarm obj %.6f | re-solve fit RRMSE %.4f%%\n', ...
            h, yrLabel{h}, solvUsed{h}, Ffit(h), fitRRMSE(h));
end
frst_year_forecast_rrmse = fcRRMSE(1);
scnd_year_forecast_rrmse = fcRRMSE(2);
thrd_year_forecast_rrmse = fcRRMSE(3);
save("m4_FOR_RRMSE_" + county_M4 + ".mat", 'fitRRMSE','fcRRMSE', ...
     'fcPers','fcSeas','fcMean','fcResid','solvUsed','nFitList','yrLabel');

figure('Position',[80 80 1100 560]);
hObs = scatter(t_inf_data(1:nMonths), y_inf_data(1:nMonths), 32, 'k', 'filled'); hold on
hFit = plot(TMON{1}(1:96), MMON{1}(1:96), 'LineWidth', 5, 'Color', [0 0 1 0.45]);
cols = [0.35 0.70 0.90; 0.00 0.60 0.50; 0.80 0.40 0.00];
hFc  = gobjects(3,1);
for h = 1:3
    nF = nFitList(h);
    hFc(h) = plot(TMON{h}(nF+1:nF+12), MMON{h}(nF+1:nF+12), 'LineWidth', 5, 'Color', cols(h,:));
    xline(t_inf_data(nF+1), 'k', 'LineWidth', 1.5);
end
legend([hObs; hFit; hFc], [{county_M4+' Infected', 'Model 4a fit (first 8 years)'}, ...
       cellfun(@(s) [s ' forecast'], yrLabel, 'UniformOutput', false)], ...
       'FontSize', 12, 'Location','northwest');
title('Forecast of '+county_M4+" Valley Fever Using Model 4a",'FontSize',18)
subtitle(sprintf('forecast RRMSE  2021 %.1f%%  2022 %.1f%%  2023 %.1f%%   (best naive %.1f / %.1f / %.1f%%)', ...
    fcRRMSE(1), fcRRMSE(2), fcRRMSE(3), ...
    min([fcPers(1) fcSeas(1) fcMean(1)]), min([fcPers(2) fcSeas(2) fcMean(2)]), ...
    min([fcPers(3) fcSeas(3) fcMean(3)])),'FontSize',12)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',14); ylabel('New cases per month','FontSize',14)
ylim([0, max(y_inf_data)+200]); grid on; hold off
end

elseif choose_model==5
%% model 4 BBBBBBB - Human, Vector, Fungal Model dependent on Food and Environment
global alpha_h_Maricopa omega_Maricopa c_Maricopa alpha_h_Pinal omega_Pinal c_Pinal alpha_h_Pima omega_Pima c_Pima alpha_h_AZ omega_AZ c_AZ
global logIdx_active
omega_vital = 0.021/365;
alpha_h_Maricopa = 0.000500942192598 + omega_vital; omega_Maricopa = omega_vital; c_Maricopa = 0.000500942192598/4724819.974562017247081;
alpha_h_Pinal    = 0.000076238824090 + omega_vital; omega_Pinal    = omega_vital; c_Pinal    = 0.000076238824090/5162630.000;
alpha_h_Pima     = 0.000019432499300 + omega_vital; omega_Pima     = omega_vital; c_Pima     = 0.000019432499300/10639930.00;
alpha_h_AZ       = 0.000304888503016 + omega_vital; omega_AZ       = omega_vital; c_AZ       = 0.000304888503016/7853513.125630123540759;

if Region==1
    y_inf_data=y_inf_data_AZ; y_pop_data=y_pop_data_AZ;
    alpha_h_b=alpha_h_AZ; omega_b=omega_AZ; c=c_AZ;
    county_M5=["AZ"]; county=1;
elseif Region==2
    y_inf_data=y_inf_data_Maricopa; y_pop_data=y_pop_data_Maricopa;
    alpha_h_b=alpha_h_Maricopa; omega_b=omega_Maricopa; c=c_Maricopa;
    county_M5=["MARICOPA"]; county=2;
elseif Region==3
    y_inf_data=y_inf_data_Pima; y_pop_data=y_pop_data_Pima;
    alpha_h_b=alpha_h_Pima; omega_b=omega_Pima; c=c_Pima;
    county_M5=["PIMA"]; county=3;
elseif Region==4
    y_inf_data=y_inf_data_Pinal; y_pop_data=y_pop_data_Pinal;
    alpha_h_b=alpha_h_Pinal; omega_b=omega_Pinal; c=c_Pinal;
    county_M5=["PINAL"]; county=4;
else
    error('No Region Selected!');
end
total_pop_t0 = y_pop_data(1);
ic_I_1  = y_inf_data(1);
nMonths = 132;

if single_run_or_fitting==1
% sINGLE RUN Model 4 BBBBBBB
disp(['Running Model 4 BBBBBBB single parameter run, Region ', num2str(Region)])

% oRDER matches M5_SF exactly (47 entries). params(13) is the S_opt GAP and
% params(47) is ignored because psi_A is tied to psi inside M5_SF.
k_ref_v=0.04;    Q_18_v=3.0;      T_ref_v=68;
mu_H_v=0.0005;   gamma_H_v=0.001; H_max_v=400;    delta_H_v=0.01;
gamma_A_v=0.02;  delta_A_v=0.01;  phi_A_v=1.0e-6;
T_opt_H_v=80;    T_opt_A_v=85;    gap_v=2.5;      S_opt_A_v=8.5;
blTA=500; abTA=80; blTH=500; abTH=80;
blSA=6;   abSA=2;  blSH=6;   abSH=2;
T_hs_v=90;       beta_v=0.005;    delta_V_v=0.002;
sigma_v=3e-10;   T_cs_v=65;
alpha_v=1.0e-7;  S_d_s_v=7;       T_d_s_v=95;     xtr_c_s_v=10;
alpha_h_v=alpha_h_b;  epsilon_v=1.0e-8;  omega_v=omega_b;
rho_I_v=1/90;    kappa_v=2.1e-4;  psi_v=1/28;     delta_D_v=0.001;
rho_A_v=1/120;   c_v=c;

paramsm5=[k_ref_v; Q_18_v; T_ref_v; mu_H_v; gamma_H_v; H_max_v; delta_H_v; ...
          gamma_A_v; delta_A_v; phi_A_v; T_opt_H_v; T_opt_A_v; gap_v; S_opt_A_v; ...
          blTA; abTA; blTH; abTH; blSA; abSA; blSH; abSH; T_hs_v; beta_v; ...
          delta_V_v; sigma_v; T_cs_v; alpha_v; S_d_s_v; T_d_s_v; xtr_c_s_v; ...
          alpha_h_v; epsilon_v; omega_v; rho_I_v; kappa_v; psi_v; delta_D_v; ...
          rho_A_v; c_v; 5000; 40; 70; 100; 50; ic_I_1*1.5; 1.5*psi_v];
assert(numel(paramsm5)==47, 'paramsm5 must have 47 entries, has %d', numel(paramsm5));

ic_V=5000; ic_O=40; ic_D=70; ic_H=100; ic_A=50;
ic_I=ic_I_1;  ic_E=ic_I*1.5;  ic_A_H=ic_I;  ic_R=ic_I/2;
ic_S=total_pop_t0-ic_E-ic_A_H-ic_I-ic_R;
y0=[ic_V;ic_O;ic_D;ic_H;ic_A;ic_S;ic_E;ic_A_H;ic_I;ic_R];   % 10 elements

t_day=(t_inf_data(1):1:t_inf_data(nMonths+1))';
[t,y]=ode15s(@(tt,yy) M5_SF(tt,yy,paramsm5,county), t_day, y0, ...
             odeset('RelTol',1e-4,'AbsTol',1e-6,'NonNegative',1:10));

figure
plot(t/365,y(:,1),'LineWidth',2); grid on
legend('Wildlife V','Location','best')
title("Model 4b single run - wildlife reservoir",'FontSize',16); xlabel('Year','FontSize',13)

figure
plot(t/365,y(:,2),'LineWidth',2); hold on; plot(t/365,y(:,3),'LineWidth',2)
plot(t/365,y(:,4),'LineWidth',2); plot(t/365,y(:,5),'LineWidth',2); grid on
legend('Organic Matter O','Decayed D','Hyphae H','Arthroconidia A','Location','best')
title("Model 4b single run - substrate and fungal compartments",'FontSize',16)
xlabel('Year','FontSize',13); hold off

figure
plot(t/365,y(:,6),'LineWidth',2); hold on
plot(t/365,y(:,7),'LineWidth',2); plot(t/365,y(:,8),'LineWidth',2)
plot(t/365,y(:,9),'LineWidth',2); plot(t/365,y(:,10),'LineWidth',2); grid on
legend('Susceptible','Exposed','Asymptomatic','Infected','Recovered','Location','best')
title("Model 4b single run - human compartments",'FontSize',16)
xlabel('Year','FontSize',13); ylabel('Humans','FontSize',13); hold off

cf=cumtrapz(t, psi_v*y(:,7));   % psi_I*E
im=round(t_inf_data(1:nMonths+1)-t_inf_data(1))+1;
mmon=diff(cf(im));
figure
scatter(t_inf_data(1:nMonths),y_inf_data(1:nMonths),28,'k','filled'); hold on
plot(t_inf_data(1:nMonths),mmon,'LineWidth',2.5); grid on
legend(county_M5+' reported','Model 4b monthly incidence','Location','best')
title("Model 4b single run - monthly incidence vs data",'FontSize',16)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',13); ylabel('Cases per month','FontSize',13); hold off
fprintf('single run: N(0)=%.0f  N(end)=%.0f  mean monthly incidence %.1f (data %.1f)\n', ...
        sum(y(1,6:10)), sum(y(end,6:10)), mean(mmon), mean(y_inf_data(1:nMonths)));

elseif single_run_or_fitting==2
% fITTING Model 4 BBBBBBB
disp(['Running Model 4 BBBBBBB Fitting, Region ', num2str(Region)])
tspan = t_inf_data;
% pARAMETER RANGES
% k_ref                Q_18                 T_ref  (pinned: flat with k_ref)
LB(1) = 0.001;        LB(2) = 1.5;         LB(3) = 68;
UB(1) = 0.08;         UB(2) = 10.0;         UB(3) = 68;

% mu_H
LB(4) = 0.000001;     UB(4) = 0.1;

% gamma_H, H_max, delta_H
LB(5) = 0.00000001;   LB(6) = 210;         LB(7) = 0.0001;
UB(5) = 0.06;         UB(6) = 500;         UB(7) = 0.3;

% gamma_A, delta_A, phi_A
% delta_A floor 1/120 caps the arthroconidial time constant at 120 days so the
% pool can still transmit an annual cycle. Excluded from slack_idx below.
LB(8) = 0.000001;     LB(9) = 1/120;       LB(10) = 0.000000001;
UB(8) = 0.15;         UB(9) = 0.5;         UB(10) = 0.00001;

% t_opt_H, T_opt_A
LB(11) = 65;          LB(12) = 0.5;
UB(11) = 100;         UB(12) = 25;

% s_opt GAP (13) and S_opt_A (14):  S_opt_H = params(14) + params(13)
LB(13) = 0.2;         LB(14) = 7;
UB(13) = 8;           UB(14) = 9.8;

% temperature response widths
LB(15) = 50;         LB(16) = 30;         LB(17) = 200;
UB(15) = 700;         UB(16) = 400;        UB(17) = 700;
LB(18) = 30;          LB(19) = 1;          LB(20) = 1;
UB(18) = 300;         UB(19) = 20;         UB(20) = 30;

% soil-moisture response widths, T_hs (upper breeding cutoff, raised)
LB(21) = 1;           LB(22) = 1;        LB(23) = 80;
UB(21) = 20;          UB(22) = 20;          UB(23) = 105;

% beta: LB raised so a small beta cannot strand delta_V above its floor;
% uB raised so beta*mean(F_bs) clears UB(delta_V) with margin (needs
% mean(F_bs) >= 0.008/0.05 = 0.16, and the widened window delivers 0.28-0.34).
LB(24) = 0.0001;      UB(24) = 0.05;

% delta_V (UB capped so it cannot outrun beta*mean(F_bs)), sigma, T_cs (lowered)
LB(25) = 0.000008;    LB(26) = 0.000000000001;   LB(27) = 50;
UB(25) = 0.008;       UB(26) = 0.0000000007;     UB(27) = 70;

% alpha, S_d_s, T_d_s (30 is unused in M5_SF; pinned)
% lB(29): the smallest PZI value strictly above the regional minimum, so that
% f_dr has a nonzero gradient. Tie-safe: Pima's minimum is duplicated.
Z_pzi    = pzi_series(county);
S_d_s_LB = min(Z_pzi(Z_pzi > min(Z_pzi)));
LB(28) = 0.0000000005;   LB(29) = S_d_s_LB;  LB(30) = 95;
% lB(28) = 0.0000000005;   LB(29) = 6.8;       LB(30) = 95;
UB(28) = 0.0001;         UB(29) = 10;       UB(30) = 95;

% xtr_c_s, epsilon
LB(31) = 1;           LB(33) = 0.00000000001;
UB(31) = 100;          UB(33) = 0.0001;

% psi_I, delta_D
LB(37) = 1/50;        LB(38) = 0.000001;
UB(37) = 1/7;         UB(38) = 0.1;

% initial conditions
LB(41) = 10;    UB(41) = 20000;   % ic_V  wildlife
LB(42) = 1;     UB(42) = 1000;   % ic_O  organic matter
LB(43) = 1;     UB(43) = 1000;   % ic_D  decayed matter
LB(44) = 1;     UB(44) = 500;   % ic_H  hyphae (re-capped after widening)
LB(45) = 1;     UB(45) = 1000;   % ic_A  arthroconidia

% ic_E from the data rather than fitted over four orders of magnitude.
psi_I_mid = 0.5*(LB(37) + UB(37));
ic_E_est  = (y_inf_data(1)/31) / psi_I_mid;
LB(46) = 0.5*ic_E_est;   UB(46) = 2.0*ic_E_est;

% lB(47) = 0.1;   UB(47) = 0.9;      % conv: fraction of desiccated mycelium
% becoming arthroconidia (alternate-cell
% architecture implies ~0.5)

% excluded: 3 and 30 (pinned); 20 and 22 (width floors must hold); 9 (the
% delta_A floor must hold -- x0.7 would push 1/120 back out to 1/171);
% 23, 24, 25, 27 (the breeding-window / V-persistence balance must hold);
% 46 (ic_E is derived from the data).
% iDENTICAL in the fitting and forecasting sections.
slack_idx = [1 2 4 5 6 7 8 10 ...
             15 16 17 18 19 21 ...
             26 28 31 33 38 ...
             41 42 43 44 45];
LB(slack_idx) = LB(slack_idx) * 0.6;
UB(slack_idx) = UB(slack_idx) * 1.5;

% ic_H must stay below the smallest H_max the fit can choose, or
% (1 - H/H_max) starts negative and H crashes through a spurious transient.
UB(44) = min(UB(44), 0.9*LB(6));

CFR_corrected = 0.01805;   % <-- Kappa_Estimate!B8
rho_I_fixed   = 1/90;
rho_A_fixed   = 1/120;
g_net         = alpha_h_b - omega_b;   % pop_fit_3 net, unchanged
omega_new     = 0.021/365;   % vital statistics, not the gross rate
kappa_fixed   = CFR_corrected*(rho_I_fixed + omega_new + c*4.25e6)/(1-CFR_corrected);

LB(35)=rho_I_fixed;  UB(35)=rho_I_fixed;
LB(36)=kappa_fixed;  UB(36)=kappa_fixed;
LB(39)=rho_A_fixed;  UB(39)=rho_A_fixed;
LB(32) = omega_new + 0.5*g_net;   LB(34) = omega_new*0.99999;   LB(40) = c*0.9999;
UB(32) = omega_new + g_net;       UB(34) = omega_new*1.00001;   UB(40) = c*1.0001;

assert(LB(32) >= UB(34), 'net growth can go negative');
assert(LB(23) >  UB(27), 'breeding window can invert: LB(T_hs) must exceed UB(T_cs)');
assert(UB(44) <  LB(6),  'ic_H upper bound must sit below the smallest H_max');
assert(all(LB <= UB),    'LB>UB at %s', mat2str(find(LB>UB)));

% f_dr must be able to fire, or S_d_s and xtr_c_s are unidentified and
% contribute null columns to the sensitivity matrix in section 20.
assert(LB(29) > min(pzi_series(county)), ...
       'S_d_s lower bound must exceed min(PZI) or F_dr never fires');
assert(LB(29) < UB(29), 'S_d_s bounds inverted');
nFire = sum(pzi_series(county) < LB(29));
fprintf('S_d_s in [%.3f %.2f] | F_dr can fire in >= %d of 132 months\n', ...
        LB(29), UB(29), nFire);

tauA_max = 1/LB(9);   % ignores alpha*V and phi_A
retA     = 1/sqrt(1 + (2*pi*(tauA_max/30.44)/12)^2);   % annual amplitude kept
fprintf('kappa %.4e/day | rho_I %.4e/day | free %d of %d\n', ...
        kappa_fixed, rho_I_fixed, sum(UB>LB), numel(LB));
fprintf('A pool: tau <= %.0f d -> >= %.0f%% of the annual cycle survives\n', ...
        tauA_max, 100*retA);
fprintf('breeding window >= %.1f F | delta_V <= %.4f vs beta_max %.4f\n', ...
        LB(23)-UB(27), UB(25), UB(24));
fprintf('ic_H in [%.2f %.2f], H_max in [%.0f %.0f]\n', LB(44), UB(44), LB(6), UB(6));

% dO_PROFILE = true;      % <-- set false to run the real fit
% if DO_PROFILE
% logIdx = [4 5 10 26 28 33 38];
% isLog  = false(numel(LB),1);  isLog(logIdx) = true;
% qlo = LB;  qlo(logIdx) = log10(LB(logIdx));
% qhi = UB;  qhi(logIdx) = log10(UB(logIdx));
% qmid = 0.5*(qlo + qhi);
% p_mid = qmid;  p_mid(logIdx) = 10.^qmid(logIdx);
% obj = @(p) objective_functionM5(p, tspan, total_pop_t0, y_inf_data, county);
% pROF_TAG = "M5_" + county_M5 + "_inlinespline";   % <-- change per variant
% profile_objective(obj, LB, UB, isLog, PROF_TAG, p_mid, ...
% 'nRandom', 60, 'nLocal', 40, 'nRepeat', 12, 'nProf', 4);
% return
% end
nAlloc = str2double(getenv('SLURM_CPUS_PER_TASK'));
if isnan(nAlloc) || nAlloc < 1
    nAlloc = str2double(getenv('SLURM_CPUS_ON_NODE'));
end
if isnan(nAlloc) || nAlloc < 1
    nAlloc = feature('numcores');
end
nWant = max(1, floor(nAlloc));

pool = gcp('nocreate');
if ~isempty(pool) && pool.NumWorkers ~= nWant
    delete(pool);  pool = [];
end
if isempty(pool)
    try
        try
            cl = parcluster('Processes');   % r2022b+ name
        catch
            cl = parcluster('local');   % older name
        end
        jid = getenv('SLURM_JOB_ID');
        if ~isempty(jid)
            jsl = fullfile(tempdir, ['mlpool_' jid]);
            if ~exist(jsl,'dir'), mkdir(jsl); end
            cl.JobStorageLocation = jsl;
        end
        cl.NumWorkers = nWant;
        pool = parpool(cl, nWant);
    catch ME
        warning('M5:parpoolFailed', 'parpool failed (%s). Running serial.', ME.message);
        pool = [];
    end
end
if isempty(pool)
    numWorkers = 1;  useParallel = false;
else
    numWorkers = pool.NumWorkers;  useParallel = true;
    pctRunOnAll warning('off', 'all');
end
fprintf('allocated %d | workers %d | parallel %d\n', nWant, numWorkers, useParallel);
format long

nDim   = length(LB);
logIdx = [4 5 10 26 28 33 38];
assert(all(LB(logIdx) > 0), 'log indices need LB>0: %s', mat2str(logIdx(LB(logIdx)<=0)));
LBt = LB;  UBt = UB;
LBt(logIdx) = log10(LB(logIdx));   UBt(logIdx) = log10(UB(logIdx));
assert(all(isfinite(LBt)) && all(isfinite(UBt)), 'log10 of a non-positive bound');
isLog = false(nDim,1);  isLog(logIdx) = true;
unlog = @(q) q(:).*(~isLog) + (10.^min(q(:),300)).*isLog;   % min() guards 10^inf*0 = NaN
tolog = @(pv) pv(:).*(~isLog) + log10(max(pv(:),realmin)).*isLog;
logIdx_active = logIdx;

fminOpts = optimoptions('fmincon','Algorithm','interior-point','UseParallel',useParallel, ...
    'MaxFunctionEvaluations',20000,'OptimalityTolerance',1e-8, ...
    'StepTolerance',1e-10,'FiniteDifferenceStepSize',1e-4,'Display','none');

optionsslow = optimoptions('particleswarm', ...
    'UseParallel', useParallel, ...
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*ceil(50*nDim/numWorkers), ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ...
    'FunctionTolerance', 1e-8, ...
    'InertiaRange', [0.1, 1.2], ...      
    'SelfAdjustmentWeight', 1.8, ...
    'SocialAdjustmentWeight', 1.2, ...
    'MinNeighborsFraction', 0.10, ...   % exploration via topology
    'HybridFcn', {@fmincon, fminOpts}, ...
    'Display', 'final');
options = optionsslow;

nRestarts = 20;  allP = nan(nRestarts,nDim);  allF = inf(nRestarts,1);
% one restart per Slurm array task when RESTART_ONLY is set; the seed is
% still rng(1000+r), so task r reproduces serial iteration r exactly.
if exist('RESTART_ONLY','var') && ~isempty(RESTART_ONLY)
    rList = RESTART_ONLY;
    fprintf('array mode: restart %d of %d only\n', rList, nRestarts);
else
    rList = 1:nRestarts;
end
for r = rList
    rng(1000+r);
    [qR,fR] = particleswarm(@(q) objective_functionM5(unlog(q), tspan, total_pop_t0, y_inf_data, county), ...
                            nDim, LBt, UBt, options);
    allP(r,:) = unlog(qR)';  allF(r) = fR;
    fprintf('restart %2d/%d: obj = %.18e\n', r, nRestarts, fR);
    fprintf('params_m5pswarm = [%s%.16f];\n', sprintf('%.16f; ', allP(r,1:end-1)), allP(r,end));
    if exist('TASK_TAG','var')
    save("results/m5_restarts_" + TASK_TAG + ".mat",'allP','allF','r');
    else
    save("m5_restarts_" + county_M5 + ".mat",'allP','allF','r');
    end
end
[errorOBJ, rBest] = min(allF);

params_m5pswarm   = allP(rBest,:)';
fprintf('best %.18e | median %.18e | spread %.2f%%\n', ...
        errorOBJ, median(allF), 100*(max(allF)-min(allF))/min(allF));

% one paren moved: p(end) must be a separate fprintf argument, or sprintf
% absorbs it, the trailing %.15f runs out of args, and "];" never prints
fprintf('params_m5pswarm = [%s%.15f];\n', ...
        sprintf('%.15f; ', params_m5pswarm(1:end-1)), params_m5pswarm(end));

nFree = sum(UB > LB);
fprintf('Region: %s | RRMSE = %.6f | free params: %d of %d\n', ...
        county_M5, errorOBJ, nFree, numel(LB));
save("params_m5pswarm_" + county_M5 + ".mat", 'params_m5pswarm', 'LB', 'UB', 'errorOBJ');
save("m5_RRMSE_"        + county_M5 + ".mat", 'errorOBJ');
save("m5_restarts_"     + county_M5 + ".mat", 'allP', 'allF');
fprintf('restart spread: %.2f%%\n', 100*(max(allF)-min(allF))/min(allF));

% % % % % % ---- ONE-TIME RUN from a completed fit: no swarm ----------------------
% % % % % assert(numel(params_m5pswarm)==nDim, 'pasted %d params, nDim is %d', numel(params_m5pswarm), nDim);
% % % % % oob = find(params_m5pswarm < LB | params_m5pswarm > UB);
% % % % % if ~isempty(oob)
% % % % %     warning('M5:pastedOOB', ...
% % % % %         mat2str(oob'));
% % % % % end
% % % % % errorOBJ = 1.944628473202743846e-01;      % as reported by the run that produced this vector

% same solver chain, timeout and integration the swarm used. solution_y comes
% back on the DAILY grid, so the actuarial integrals get daily resolution.
% this now precedes the information criteria because the NB likelihood needs
% mmon, the fitted monthly incidence.
[chk, ypswarm, solvFit, mmon] = objective_functionM5(params_m5pswarm, tspan, ...
                                    total_pop_t0, y_inf_data, county);
t = (tspan(1):1:tspan(end))';
fprintf('fit solver: %-22s | swarm obj %.6f | re-solve obj %.6f\n', solvFit, errorOBJ, chk);
if abs(chk - errorOBJ) > 1e-6
    warning('M5:objMismatch', ...
        'Re-solve objective %.6f differs from the swarm value %.6f; a different solver may have won on this window.', ...
        chk, errorOBJ);
end
if isempty(mmon), error('M5: all solvers failed on the full window'); end

% k: NO -1 correction. params(47) is commented out of the bounds block, so
% nDim = 46 and index 47 never enters LB/UB. The hard pins (UB==LB) are
% 3, 30, 35, 36, 39, so sum(UB>LB) already returns 41. The old -1 double-
% counted and reported 40, shifting AIC by 2 and BIC by 4.9.
rrmse      = errorOBJ;
data_mon   = y_inf_data(1:end-1);
n          = numel(data_mon);
k          = sum(UB > LB);
noiseFloor = 100*(std(diff(data_mon,2))/sqrt(6))/mean(data_mon);

% rrmse_mean is both the objective and the published equation. rrmse_obs is
% the per-observation alternative, reported alongside so the conclusion can
% be shown to survive either weighting.
r    = data_mon(:) - mmon(:);
nIC  = numel(r);
rss  = sum(r.^2);
p    = k + 1;
logL = -nIC/2 * ( log(2*pi) + log(rss/nIC) + 1 );
aic  = -2*logL + 2*p;
if nIC - p - 1 > 0
    aicc = aic + 2*p*(p+1)/(nIC - p - 1);
else
    aicc = NaN;
end
bic  = -2*logL + p*log(nIC);
fprintf('\nModel 4b information criteria (Gaussian least squares)\n');
fprintf('  n = %d | free structural k = %d | p = k+1 = %d\n', nIC, k, p);
fprintf('  RRMSE  : %.6f\n', sqrt(mean(r.^2))/mean(data_mon));
fprintf('  RSS    : %.4f\n', rss);
fprintf('  logL   : %.4f\n', logL);
fprintf('  AIC    : %.4f\n', aic);
fprintf('  AICc   : %.4f\n', aicc);
fprintf('  BIC    : %.4f\n', bic);

fprintf('  RRMSE reported by the swarm : %.6f  (noise floor %.4f)\n', rrmse, noiseFloor/100);
ICnb = nb_ic(data_mon, max(mmon(:),1e-6), k, "Model 5 " + county_M5);
aic_gauss = aic;  aicc_gauss = aicc;  bic_gauss = bic;
aic = ICnb.aic;  aicc = ICnb.aicc;  bic = ICnb.bic;
save("m5_IC_" + county_M5 + ".mat", 'ICnb','n','k','rrmse','aic','aicc','bic','aic_gauss','aicc_gauss','bic_gauss','noiseFloor');

if isempty(mmon), error('M5: all solvers failed on the full window'); end
err_pswarm_m5 = 100*errorOBJ;   % RRMSE as a percentage, for plot subtitles

ic_V_best = params_m5pswarm(41);
ic_O_best = params_m5pswarm(42);
ic_D_best = params_m5pswarm(43);
ic_H_best = params_m5pswarm(44);
ic_A_best = params_m5pswarm(45);
ic_E_best = params_m5pswarm(46);
ic_I_data   = y_inf_data(1);
ic_A_H_data = y_inf_data(1);
ic_R_data   = ic_I_data / 2;
ic_S_best   = total_pop_t0 - ic_I_data - ic_A_H_data - ic_E_best - ic_R_data;
y0_best = [ic_V_best; ic_O_best; ic_D_best; ic_H_best; ic_A_best; ...
           ic_S_best; ic_E_best; ic_A_H_data; ic_I_data; ic_R_data];

figure
plot(t_inf_data(1:nMonths), mmon, 'LineWidth', 3, 'Color', [0 0 1 0.5]); grid on
hold on
scatter(t_inf_data(1:nMonths), data_mon, 30, 'k', 'filled'); hold on
legend(county_M5+' reported','Model 4b fit','Location','northwest');
title(county_M5+" Valley Fever - Model 4b monthly incidence fit", 'FontSize', 16)
subtitle(sprintf('RRMSE %.2f%%  (noise floor %.2f%%)  |  AIC %.1f  BIC %.1f', ...
         err_pswarm_m5, noiseFloor, aic, bic), 'FontSize', 11)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',13); ylabel('Cases per month','FontSize',13)
ylim([0, max(data_mon)*1.25]); hold off

figure
scatter(t_inf_data, y_inf_data, 'b', 'LineWidth', 1); hold on
plot(t, ypswarm(:,6),  'Color', [0.9 0.6 0.0 0.6], 'LineStyle', '-', 'LineWidth', 11)
plot(t, ypswarm(:,7),  'Color', [0.35 0.7 0.9 0.7], 'LineStyle', '-', 'LineWidth', 9)
plot(t, ypswarm(:,8),  'Color', [0.0 0.6 0.5 0.8], 'LineStyle', '-', 'LineWidth', 7)
plot(t, ypswarm(:,9),  'Color', [0.8 0.4 0.0 0.9], 'LineStyle', '-', 'LineWidth', 5)
plot(t, ypswarm(:,10), 'Color', [0 0 0 1], 'LineStyle', '-', 'LineWidth', 3)
legend('Maricopa Infected','Model Susceptible fit','Model Exposed fit','Model Asymptomatic fit', ...
       'Model Infected fit','Model Recovered fit','Location','best');
title("Valley Fever Model 4B  -"+county_M5, 'FontSize', 22)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
subtitle("Infected Pswarm M4b RRMSE= "+err_pswarm_m5, 'FontSize', 14)
xlabel('Year', 'FontSize', 18); ylabel('Humans', 'FontSize', 18)
hold off

figure
plot(t/365, ypswarm(:,1),'LineWidth',2); hold on
plot(t/365, ypswarm(:,2),'LineWidth',2); plot(t/365, ypswarm(:,3),'LineWidth',2)
plot(t/365, ypswarm(:,4),'LineWidth',2); plot(t/365, ypswarm(:,5),'LineWidth',2); grid on
legend('Wildlife V','Organic Matter O','Decayed D','Hyphae H','Arthroconidia A','Location','best')
title("Model 4b fitted wildlife, substrate and fungal compartments",'FontSize',15)
xlabel('Year','FontSize',13); hold off

% % DATA EXPORT FOR ACTUARIAL PREMIUM CALCULATIONS
% daily resolution now, because solution_y is returned on the daily grid.
S_pop   = ypswarm(:, 6);
E_pop   = ypswarm(:, 7);
A_H_pop = ypswarm(:, 8);
I_pop   = ypswarm(:, 9);
R_pop   = ypswarm(:, 10);
N_pop   = S_pop + E_pop + A_H_pop + I_pop + R_pop;
Inc_day = params_m5pswarm(37) * E_pop;   % psi_I*E, new symptomatic per day

human_pop_table = table(t, S_pop, E_pop, A_H_pop, I_pop, R_pop, N_pop, Inc_day, ...
    'VariableNames', {'Day','Susceptible','Exposed','Asymptomatic','Infected', ...
                      'Recovered','Total_N','Incidence_per_day'});
csv_filename = "Human_Populations_M5_" + county_M5 + ".csv";
writetable(human_pop_table, csv_filename);
disp(['SUCCESS: Population trajectories saved to ', char(csv_filename)]);

% cLIMATE STRESS TESTS (SSP SCENARIOS)
disp('Starting IPCC SSP Climate Stress Tests...');
ssp_names  = ["SSP1_19", "SSP2_45", "SSP5_85"];
ssp_params = [ 2.5, 1.10, 0.5;   % SSP1-1.9
               5.0, 1.25, 1.0;   % SSP2-4.5
              10.0, 1.50, 2.0 ];   % SSP5-8.5

% tolerance-based control instead, with NonNegative to match the objective.
ssp_options = odeset('RelTol', 1e-4, 'AbsTol', 1e-6, 'NonNegative', 1:10);
t_ssp_grid  = (t_inf_data(1):1:t_inf_data(nMonths+1))';

for s = 1:length(ssp_names)
    current_ssp = ssp_names(s);
    temp_shift  = ssp_params(s, 1);
    alpha_pzi   = ssp_params(s, 2);
    beta_pzi    = ssp_params(s, 3);
    fprintf('Running Scenario: %s  (dT %+0.1f F, alpha %.2f, beta %.2f)\n', ...
            current_ssp, temp_shift, alpha_pzi, beta_pzi);

    [t_ssp, y_ssp] = ode15s(@(tt,yy) M5_SF(tt, yy, params_m5pswarm, county, ...
                            temp_shift, alpha_pzi, beta_pzi), ...
                            t_ssp_grid, y0_best, ssp_options);

    S_pop_ssp   = y_ssp(:, 6);   E_pop_ssp = y_ssp(:, 7);
    A_H_pop_ssp = y_ssp(:, 8);   I_pop_ssp = y_ssp(:, 9);
    R_pop_ssp   = y_ssp(:, 10);
    N_pop_ssp   = S_pop_ssp + E_pop_ssp + A_H_pop_ssp + I_pop_ssp + R_pop_ssp;
    Inc_day_ssp = params_m5pswarm(37) * E_pop_ssp;

    ssp_table = table(t_ssp, S_pop_ssp, E_pop_ssp, A_H_pop_ssp, I_pop_ssp, ...
        R_pop_ssp, N_pop_ssp, Inc_day_ssp, ...
        'VariableNames', {'Day','Susceptible','Exposed','Asymptomatic','Infected', ...
                          'Recovered','Total_N','Incidence_per_day'});
    csv_filename = "Human_Populations_M5_" + county_M5 + "_" + current_ssp + ".csv";
    writetable(ssp_table, csv_filename);
    disp(['Saved: ', char(csv_filename)]);
end
disp('All SSP scenarios completed and exported successfully.');

elseif single_run_or_fitting==3
% fORECASTING Model 4 BBBBBBB
% fIXES relative to the previous draft. BOUNDS ARE UNCHANGED.
% 1. seed_h CHAINING REMOVED. The loop set seed_h = Pfit{h}, so horizon 2
% seeded from horizon 1 and horizon 3 from horizon 2. You asked for all
% three to seed from the pasted vector, which also keeps the horizons
% independent -- with chaining, a poorly converged horizon 1 propagates.
% 2. make_warm was called once per HORIZON, outside the restart loop, so all
% 6 restarts of a horizon began from an identical swarm. The swarm is now
% rebuilt inside the restart loop, after rng, with the seed as particle 1.
% 3. logIdx dropped index 9 (delta_A). Now that it is floored at 1/120 and
% excluded from widening it spans 1.8 decades, and log-transforming a
% range that narrow only distorts the uniform sampling. Index 7 (delta_H)
% is KEPT: at LB 1e-4 and widened it still spans 3.9 decades.
% 4. tolog was defined twice; once now.
% 5. MaxTime added (3 h), matching the other forecast sections. Without it a
% single horizon can run unbounded.
% gone, and the "warm start from previous best" message now says what it
% actually does.
% 7. A length assert on LB/UB prints nDim, because LB(47)/UB(47) are
% commented out: nDim is 46 on a fresh workspace but 47 with stale values
% if LB/UB persist. Left as you have it, but now visible rather than
% silent. Whatever it is, it must match the FITTING section.
disp(['Running Model 4 BBBBBBB Forecasting, Region ', num2str(Region)])

total_pop_t0 = y_pop_data(1);   % harmless if already set in the shared header
nMonths      = 132;

% pARAMETER RANGES
% k_ref                Q_18                 T_ref  (pinned: flat with k_ref)
LB(1) = 0.001;        LB(2) = 1.5;         LB(3) = 68;
UB(1) = 0.08;         UB(2) = 10.0;         UB(3) = 68;

% mu_H
LB(4) = 0.000001;     UB(4) = 0.1;

% gamma_H, H_max, delta_H
LB(5) = 0.00000001;   LB(6) = 210;         LB(7) = 0.0001;
UB(5) = 0.06;         UB(6) = 500;         UB(7) = 0.3;

% gamma_A, delta_A, phi_A
% delta_A floor 1/120 caps the arthroconidial time constant at 120 days so the
% pool can still transmit an annual cycle. Excluded from slack_idx below.
LB(8) = 0.000001;     LB(9) = 1/120;       LB(10) = 0.000000001;
UB(8) = 0.15;         UB(9) = 0.5;         UB(10) = 0.00001;

% t_opt_H, T_opt_A
LB(11) = 65;          LB(12) = 0.5;
UB(11) = 100;         UB(12) = 25;

% s_opt GAP (13) and S_opt_A (14):  S_opt_H = params(14) + params(13)
LB(13) = 0.2;         LB(14) = 7;
UB(13) = 8;           UB(14) = 9.8;

% temperature response widths
LB(15) = 50;         LB(16) = 30;         LB(17) = 200;
UB(15) = 700;         UB(16) = 400;        UB(17) = 700;
LB(18) = 30;          LB(19) = 1;          LB(20) = 1;
UB(18) = 300;         UB(19) = 20;         UB(20) = 30;

% soil-moisture response widths, T_hs (upper breeding cutoff, raised)
LB(21) = 1;           LB(22) = 1;        LB(23) = 80;
UB(21) = 20;          UB(22) = 20;          UB(23) = 105;

% beta: LB raised so a small beta cannot strand delta_V above its floor;
% uB raised so beta*mean(F_bs) clears UB(delta_V) with margin (needs
% mean(F_bs) >= 0.008/0.05 = 0.16, and the widened window delivers 0.28-0.34).
LB(24) = 0.0001;      UB(24) = 0.05;

% delta_V (UB capped so it cannot outrun beta*mean(F_bs)), sigma, T_cs (lowered)
LB(25) = 0.000008;    LB(26) = 0.000000000001;   LB(27) = 50;
UB(25) = 0.008;       UB(26) = 0.0000000007;     UB(27) = 70;

% alpha, S_d_s, T_d_s (30 is unused in M5_SF; pinned)
% lB(29): the smallest PZI value strictly above the regional minimum, so that
% f_dr has a nonzero gradient. Tie-safe: Pima's minimum is duplicated.
Z_pzi    = pzi_series(county);
S_d_s_LB = min(Z_pzi(Z_pzi > min(Z_pzi)));
LB(28) = 0.0000000005;   LB(29) = S_d_s_LB;  LB(30) = 95;
% lB(28) = 0.0000000005;   LB(29) = 6.8;       LB(30) = 95;
UB(28) = 0.0001;         UB(29) = 10;       UB(30) = 95;

% xtr_c_s, epsilon
LB(31) = 1;           LB(33) = 0.00000000001;
UB(31) = 100;          UB(33) = 0.0001;

% psi_I, delta_D
LB(37) = 1/50;        LB(38) = 0.000001;
UB(37) = 1/7;         UB(38) = 0.1;

% initial conditions
LB(41) = 10;    UB(41) = 20000;   % ic_V  wildlife
LB(42) = 1;     UB(42) = 1000;   % ic_O  organic matter
LB(43) = 1;     UB(43) = 1000;   % ic_D  decayed matter
LB(44) = 1;     UB(44) = 500;   % ic_H  hyphae (re-capped after widening)
LB(45) = 1;     UB(45) = 1000;   % ic_A  arthroconidia

% ic_E from the data rather than fitted over four orders of magnitude.
psi_I_mid = 0.5*(LB(37) + UB(37));
ic_E_est  = (y_inf_data(1)/31) / psi_I_mid;
LB(46) = 0.5*ic_E_est;   UB(46) = 2.0*ic_E_est;

% lB(47) = 0.1;   UB(47) = 0.9;      % conv: fraction of desiccated mycelium
% becoming arthroconidia (alternate-cell
% architecture implies ~0.5)

% excluded: 3 and 30 (pinned); 20 and 22 (width floors must hold); 9 (the
% delta_A floor must hold -- x0.7 would push 1/120 back out to 1/171);
% 23, 24, 25, 27 (the breeding-window / V-persistence balance must hold);
% 46 (ic_E is derived from the data).
% iDENTICAL in the fitting and forecasting sections.
slack_idx = [1 2 4 5 6 7 8 10 ...
             15 16 17 18 19 21 ...
             26 28 31 33 38 ...
             41 42 43 44 45];
LB(slack_idx) = LB(slack_idx) * 0.6;
UB(slack_idx) = UB(slack_idx) * 1.5;

% ic_H must stay below the smallest H_max the fit can choose, or
% (1 - H/H_max) starts negative and H crashes through a spurious transient.
UB(44) = min(UB(44), 0.9*LB(6));

CFR_corrected = 0.01805;   % <-- Kappa_Estimate!B8
rho_I_fixed   = 1/90;
rho_A_fixed   = 1/120;
g_net         = alpha_h_b - omega_b;   % pop_fit_3 net, unchanged
omega_new     = 0.021/365;   % vital statistics, not the gross rate
kappa_fixed   = CFR_corrected*(rho_I_fixed + omega_new + c*4.25e6)/(1-CFR_corrected);

LB(35)=rho_I_fixed;  UB(35)=rho_I_fixed;
LB(36)=kappa_fixed;  UB(36)=kappa_fixed;
LB(39)=rho_A_fixed;  UB(39)=rho_A_fixed;
LB(32) = omega_new + 0.5*g_net;   LB(34) = omega_new*0.99999;   LB(40) = c*0.9999;
UB(32) = omega_new + g_net;       UB(34) = omega_new*1.00001;   UB(40) = c*1.0001;

% <<< numel assert added: LB(47)/UB(47) are commented out above, so nDim is 46
% on a fresh workspace but 47 if LB/UB survive from an earlier run. This prints
% whichever it is. It MUST match the fitting section.
fprintf('LB/UB length = %d  ->  nDim will be %d\n', numel(LB), numel(LB));
assert(numel(LB)==numel(UB), 'LB and UB differ in length: %d vs %d', numel(LB), numel(UB));
assert(LB(32) >= UB(34), 'net growth can go negative');
assert(LB(23) >  UB(27), 'breeding window can invert: LB(T_hs) must exceed UB(T_cs)');
assert(UB(44) <  LB(6),  'ic_H upper bound must sit below the smallest H_max');
assert(all(LB <= UB),    'LB>UB at %s', mat2str(find(LB>UB)));

% f_dr must be able to fire, or S_d_s and xtr_c_s are unidentified and
% contribute null columns to the sensitivity matrix in section 20.
assert(LB(29) > min(pzi_series(county)), ...
       'S_d_s lower bound must exceed min(PZI) or F_dr never fires');
assert(LB(29) < UB(29), 'S_d_s bounds inverted');
nFire = sum(pzi_series(county) < LB(29));
fprintf('S_d_s in [%.3f %.2f] | F_dr can fire in >= %d of 132 months\n', ...
        LB(29), UB(29), nFire);

tauA_max = 1/LB(9);   % ignores alpha*V and phi_A
retA     = 1/sqrt(1 + (2*pi*(tauA_max/30.44)/12)^2);   % annual amplitude kept
fprintf('kappa %.4e/day | rho_I %.4e/day | free %d of %d\n', ...
        kappa_fixed, rho_I_fixed, sum(UB>LB), numel(LB));
fprintf('A pool: tau <= %.0f d -> >= %.0f%% of the annual cycle survives\n', ...
        tauA_max, 100*retA);
fprintf('breeding window >= %.1f F | delta_V <= %.4f vs beta_max %.4f\n', ...
        LB(23)-UB(27), UB(25), UB(24));
fprintf('ic_H in [%.2f %.2f], H_max in [%.0f %.0f]\n', LB(44), UB(44), LB(6), UB(6));

nAlloc = str2double(getenv('SLURM_CPUS_PER_TASK'));
if isnan(nAlloc) || nAlloc < 1
    nAlloc = str2double(getenv('SLURM_CPUS_ON_NODE'));
end
if isnan(nAlloc) || nAlloc < 1
    nAlloc = feature('numcores');
end
nWant = max(1, floor(nAlloc));

pool = gcp('nocreate');
if ~isempty(pool) && pool.NumWorkers ~= nWant
    delete(pool);  pool = [];
end
if isempty(pool)
    try
        try
            cl = parcluster('Processes');   % r2022b+ name
        catch
            cl = parcluster('local');   % older name
        end
        jid = getenv('SLURM_JOB_ID');
        if ~isempty(jid)
            jsl = fullfile(tempdir, ['mlpool_' jid]);
            if ~exist(jsl,'dir'), mkdir(jsl); end
            cl.JobStorageLocation = jsl;
        end
        cl.NumWorkers = nWant;
        pool = parpool(cl, nWant);
    catch ME
        warning('M5:parpoolFailed', 'parpool failed (%s). Running serial.', ME.message);
        pool = [];
    end
end
if isempty(pool)
    numWorkers = 1;  useParallel = false;
else
    numWorkers = pool.NumWorkers;  useParallel = true;
    pctRunOnAll warning('off', 'all');
end
fprintf('allocated %d | workers %d | parallel %d\n', nWant, numWorkers, useParallel);
format long

% <<< index 9 (delta_A) REMOVED. Floored at 1/120 and not widened, it spans
% only 1.8 decades, and log-transforming that narrow a range distorts the
% uniform sampling. Index 7 (delta_H) is KEPT: at LB 1e-4 and widened it still
% spans 3.9 decades.
nDim   = length(LB);
logIdx = [4 5 10 26 28 33 38];
assert(all(LB(logIdx) > 0), 'log indices need LB>0: %s', mat2str(logIdx(LB(logIdx)<=0)));
LBt = LB;  UBt = UB;
LBt(logIdx) = log10(LB(logIdx));   UBt(logIdx) = log10(UB(logIdx));
assert(all(isfinite(LBt)) && all(isfinite(UBt)), 'log10 of a non-positive bound');
isLog = false(nDim,1);  isLog(logIdx) = true;
unlog = @(q) q(:).*(~isLog) + (10.^min(q(:),300)).*isLog;   % min() guards 10^inf*0 = NaN
logIdx_active = logIdx;

fminOpts = optimoptions('fmincon','Algorithm','interior-point','UseParallel',useParallel, ...
    'MaxFunctionEvaluations',20000,'OptimalityTolerance',1e-8, ...
    'StepTolerance',1e-10,'FiniteDifferenceStepSize',1e-4,'Display','none');

% cold-start options, and the base that the warm-start version extends.
optionsslow = optimoptions('particleswarm', ...
    'UseParallel', useParallel, ...
    'OutputFcn', @myOutputFcn, ...
    'SwarmSize', numWorkers*ceil(50*nDim/numWorkers), ...
    'MaxIterations', 5000, ...
    'MaxStallIterations', 100, ...
    'FunctionTolerance', 1e-8, ...
    'InertiaRange', [0.1, 1.2], ...      
    'SelfAdjustmentWeight', 1.8, ...
    'SocialAdjustmentWeight', 1.2, ...
    'MinNeighborsFraction', 0.10, ...   % exploration via topology
    'HybridFcn', {@fmincon, fminOpts}, ...
    'Display', 'final');

n_particles = numWorkers*ceil(100*nDim/numWorkers);   % must match SwarmSize

% one vector per region from that region's full-sample Model 4b fit. Its
% length must equal nDim printed above. Leave as [] to cold-start that region.
seed_AZ       = [];
seed_MARICOPA = [];
seed_PIMA     = [];
seed_PINAL    = [];

switch Region
    case 1, params_op = seed_AZ;
    case 2, params_op = seed_MARICOPA;
    case 3, params_op = seed_PIMA;
    case 4, params_op = seed_PINAL;
    otherwise, params_op = [];
end
params_op = params_op(:);

% seeding in natural units would place the particle outside the transformed
% box on every log index, and particleswarm would clip it to a corner.
q_seed = [];
if ~isempty(params_op)
    if numel(params_op) ~= nDim
        error('M4b seed has %d entries, need %d', numel(params_op), nDim);
    end
    outside = find(params_op < LB | params_op > UB);
    if ~isempty(outside)
        warning('M4b:seedOutside', ...
            '%d seed entries lie outside the current bounds and will be clipped: %s', ...
            numel(outside), mat2str(outside'));
    end
    q_seed         = params_op(:)';
    q_seed(logIdx) = log10(max(params_op(logIdx), realmin));
    q_seed         = min(max(q_seed, LBt), UBt);
    fprintf('warm start: seeding every restart of every horizon from the pasted vector.\n');
else
    fprintf('warm start: no seed pasted for Region %d; cold start.\n', Region);
end

% nFit months used for fitting; the next 12 are the held-out forecast year.
% <<< No chaining: all three horizons seed from the SAME pasted vector, so a
% poorly converged horizon cannot propagate into the next one.
nFitList  = [96 108 120];
yrLabel   = {'2021','2022','2023'};
nRestarts = 12;
Pfit = cell(3,1);  Ffit = nan(3,1);

for h = 1:3
    nF    = nFitList(h);
    tsp_h = t_inf_data(1:nF+1);   % month boundaries for the fit
    y_h   = y_inf_data(1:nF+1);
    aP = nan(nRestarts,nDim);  aF = inf(nRestarts,1);

    for r = 1:nRestarts
        rng(2000 + 100*h + r);

        if isempty(q_seed)
            options = optionsslow;   % cold start
        else
% fresh random swarm each restart, pasted best fit as particle 1
            initial_swarm      = LBt + (UBt - LBt) .* rand(n_particles, nDim);
            initial_swarm(1,:) = q_seed;
            optionsslow2 = optimoptions(optionsslow, ...
                               'InitialSwarmMatrix', initial_swarm);
            options = optionsslow2;
        end

        [qR,fR] = particleswarm(@(q) objective_functionM5(unlog(q), tsp_h, ...
                    total_pop_t0, y_h, county), nDim, LBt, UBt, options);
        aP(r,:) = unlog(qR)';  aF(r) = fR;
        fprintf('h=%d (%s) restart %d/%d: obj = %.6e\n', h, yrLabel{h}, r, nRestarts, fR);
        save("m5_FOR_restarts_h" + h + "_" + county_M5 + ".mat", 'aP','aF','r');
    end

    [Ffit(h), rb] = min(aF);
    Pfit{h} = aP(rb,:)';
    fprintf('h=%d best %.6e | median %.6e | spread %.2f%%\n', ...
            h, Ffit(h), median(aF), 100*(max(aF)-min(aF))/min(aF));
    save("params_m5pswarm_FOR_" + nF + "mo_" + county_M5 + ".mat", 'aP','aF','LB','UB');
end
params_m5pswarm_8  = Pfit{1};
params_m5pswarm_9  = Pfit{2};
params_m5pswarm_10 = Pfit{3};

% % % params_m5pswarm_8  = params_m5pswarm_8_Pinal ;
% % % params_m5pswarm_9  = params_m5pswarm_9_Pinal ;
% % % params_m5pswarm_10 = params_m5pswarm_10_Pinal ;
% % % Pfit = { params_m5pswarm_8_Pinal ; params_m5pswarm_9_Pinal ; params_m5pswarm_10_Pinal };

% trajectories come from objective_functionM5, so the solver chain, timeout
% and monthly integration are identical to the fit.
fitRRMSE = nan(3,1);  fcRRMSE = nan(3,1);
basePers = nan(3,1);  baseSeas = nan(3,1);  baseMean = nan(3,1);
MMON = cell(3,1);  TMON = cell(3,1);  fcResid = cell(3,1);  solvUsed = cell(3,1);

for h = 1:3
    p   = Pfit{h};
    nF  = nFitList(h);
    t_m = t_inf_data(1:nF+13);   % need one extra boundary

    [~, ~, solvUsed{h}, mmon] = objective_functionM5(p, t_m, total_pop_t0, ...
                                    y_inf_data(1:nF+13), county);
    if isempty(mmon)
        warning('M5:forecastSolveFailed','horizon %d: all solvers failed', h);
        mmon = nan(nF+12,1);
    end
    MMON{h} = mmon;  TMON{h} = t_m(1:nF+12);

    dFit = y_inf_data(1:nF);           rFit = mmon(1:nF)       - dFit;
    dFc  = y_inf_data(nF+1:nF+12);     rFc  = mmon(nF+1:nF+12) - dFc;
    fitRRMSE(h) = 100*sqrt(mean(rFit.^2))/mean(dFit);
    fcRRMSE(h)  = 100*sqrt(mean(rFc.^2)) /mean(dFc);
    fcResid{h}  = rFc;   % for the Diebold-Mariano tests

    basePers(h) = 100*sqrt(mean((y_inf_data(nF)          - dFc).^2))/mean(dFc);
    baseSeas(h) = 100*sqrt(mean((y_inf_data(nF-11:nF)    - dFc).^2))/mean(dFc);
    baseMean(h) = 100*sqrt(mean((mean(y_inf_data(1:nF))  - dFc).^2))/mean(dFc);
end

county_M5
fprintf('params_m5pswarm_8 = [%s%.15f];\n',  sprintf('%.15f; ', params_m5pswarm_8(1:end-1)),  params_m5pswarm_8(end));
fprintf('params_m5pswarm_9 = [%s%.15f];\n',  sprintf('%.15f; ', params_m5pswarm_9(1:end-1)),  params_m5pswarm_9(end));
fprintf('params_m5pswarm_10 = [%s%.15f];\n', sprintf('%.15f; ', params_m5pswarm_10(1:end-1)), params_m5pswarm_10(end));

fprintf('\n%s  1-year-ahead forecast, RRMSE = RMSE/mean (%%)\n', county_M5);
fprintf('%-8s %8s %10s %10s %10s %10s\n','year','in-samp','FORECAST','persist','seasonal','trainmean');
for h = 1:3
    fprintf('%-8s %8.2f %10.2f %10.2f %10.2f %10.2f\n', yrLabel{h}, ...
        fitRRMSE(h), fcRRMSE(h), basePers(h), baseSeas(h), baseMean(h));
end
fprintf('beats best baseline: %s\n', ...
    mat2str(fcRRMSE(:)' < min([basePers baseSeas baseMean],[],2)'));
for h = 1:3
    fprintf('h=%d (%s): solver %-22s swarm obj %.6f | re-solve fit RRMSE %.4f%%\n', ...
            h, yrLabel{h}, solvUsed{h}, Ffit(h), fitRRMSE(h));
end

frst_year_forecast_rrmse = fcRRMSE(1);
scnd_year_forecast_rrmse = fcRRMSE(2);
thrd_year_forecast_rrmse = fcRRMSE(3);
% aliases so a downstream comparison script can use one set of names across
% all four models: M3 and M4a save fcPers/fcSeas/fcMean.
fcPers = basePers;  fcSeas = baseSeas;  fcMean = baseMean;
save("m5_FOR_RRMSE_" + county_M5 + ".mat", 'fitRRMSE','fcRRMSE', ...
     'basePers','baseSeas','baseMean','fcPers','fcSeas','fcMean', ...
     'fcResid','solvUsed','nFitList','yrLabel');

figure('Position',[80 80 1100 560]);
hObs = scatter(t_inf_data(1:nMonths), y_inf_data(1:nMonths), 34, 'k', 'filled'); hold on
hFit = plot(TMON{1}(1:96), MMON{1}(1:96), 'LineWidth', 5, 'Color', [0 0 1 0.45]);
cols = [0.85 0.33 0.10; 0.00 0.60 0.30; 0.49 0.18 0.56];
hFc  = gobjects(3,1);
for h = 1:3
    nF = nFitList(h);
    hFc(h) = plot(TMON{h}(nF+1:nF+12), MMON{h}(nF+1:nF+12), 'LineWidth', 5, 'Color', cols(h,:));
    xline(t_inf_data(nF+1), 'k','LineWidth',1.5);
end
legend([hObs; hFit; hFc], [{county_M5+' reported cases', 'Model 4b fit (first 8 years)'}, ...
       cellfun(@(s) [s ' forecast'], yrLabel, 'UniformOutput', false)], ...
       'Location','northwest');
title(county_M5+" Valley Fever Model 4b: monthly incidence forecast", 'FontSize', 18);
subtitle(sprintf('forecast RRMSE  2021 %.1f%%  2022 %.1f%%  2023 %.1f%%   (best naive %.1f / %.1f / %.1f%%)', ...
    fcRRMSE(1), fcRRMSE(2), fcRRMSE(3), ...
    min([basePers(1) baseSeas(1) baseMean(1)]), ...
    min([basePers(2) baseSeas(2) baseMean(2)]), ...
    min([basePers(3) baseSeas(3) baseMean(3)])), 'FontSize', 12);
xticks(0:365:365*11);
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'});
xlabel('Year','FontSize',14);  ylabel('New symptomatic cases per month','FontSize',14);
ylim([0, max(y_inf_data)+200]);  grid on;  hold off

end

elseif choose_model==8
% dIEBOLD-MARIANO / HARVEY-LEYBOURNE-NEWBOLD FORECAST COMPARISON
% every mechanistic model against THREE statistical baselines, run
% separately: Tamerius-Comrie, XGBoost, and the NB distributed-lag GLM.
% cHANGES IN THIS VERSION
% (a) BUG FIX, and it was fatal. The TC year vectors are THIRTEEN long:
% element 1 is the transition month nF (as section 10 plots them over
% t_inf_data(nF:nF+12)), and the twelve FORECAST months are elements
% 2:13. The old code did TCF{r} = [TC_2021; TC_2022; TC_2023], giving
% 39 entries, which failed the numel==36 test, marked every region
% unusable, and then tripped
% assert(~isempty(usableR), 'No Tamerius-Comrie forecasts pasted')
% so this section could not run at all. Now indexed (2:13).
% (b) regLabel was never defined in this section; the per-region table
% used it and would have errored. Uses regions{} now.
% (c) Generalised from one baseline to three. Each baseline gets its own
% full pooled test, per-region table, Holm correction and sign test.
% (d) XGBoost and NB-GLM forecasts are hard-coded below, straight from the
% pASTE-READY BLOCKS those scripts print. Both models are deterministic
% so these numbers reproduce exactly.
% everything else is unchanged: trajectories come from each model's own
% objective (monthly integrated incidence, not the I stock), autocovariances
% accumulate WITHIN region, DM and MDM share one code path, and the headline
% p-value is the two-level block bootstrap.
% rEQUIRES the DM_MDM_local_functions block at the END of this file
% (dm_stats and boot_p).
disp('Running DM / MDM forecast comparison against 3 baselines')
format short

LOSS      = 'rel_mean';
% under; 'rel_obs' divides by each individual count
H_HORIZON = 12;
BLOCK_LEN = 12;
NBOOT     = 10000;
ALPHA     = 0.05;
rng(20260810);

nFitList  = [96 108 120];
yrLabel   = {'2021','2022','2023'};
regions   = {'AZ','Maricopa','Pima','Pinal'};
countyID  = [1 2 3 4];
modelName = {'Model 1','Model 2','Model 3','Model 4a','Model 4b'};
nR = 4;  nM = 5;

% pASTE THE ODE FORECAST PARAMETER VECTORS HERE
% pARAMS{model, region} = { 8yr ; 9yr ; 10yr }
% copy params_mXpswarm_8 / _9 / _10 straight from each node's output.
% leave any entry as [] and that model-region pair is skipped.
% lengths: M1 14, M2 22, M3 35, M4a 44, M4b 46.
PARAMS = cell(nM, nR);

% fitted parameter vectors are not distributed in this file.
% paste them in below, keeping the shape shown.
% index: PARAMS{model,region}; model 1..5 = M1,M2,M3,M4a,M4b;
% region 1..4 = arizona, maricopa, pima, pinal.
% vector lengths: m1 14, m2 22, m3 35, m4a 44, m4b 46.
PARAMS{1,1} = { [] ; [] ; [] };   % m1 (14)
PARAMS{1,2} = { [] ; [] ; [] };   % m1 (14)
PARAMS{1,3} = { [] ; [] ; [] };   % m1 (14)
PARAMS{1,4} = { [] ; [] ; [] };   % m1 (14)

PARAMS{2,1} = { [] ; [] ; [] };   % m2 (22)
PARAMS{2,2} = { [] ; [] ; [] };   % m2 (22)
PARAMS{2,3} = { [] ; [] ; [] };   % m2 (22)
PARAMS{2,4} = { [] ; [] ; [] };   % m2 (22)

PARAMS{3,1} = { [] ; [] ; [] };   % m3 (35)
PARAMS{3,2} = { [] ; [] ; [] };   % m3 (35)
PARAMS{3,3} = { [] ; [] ; [] };   % m3 (35)
PARAMS{3,4} = { [] ; [] ; [] };   % m3 (35)

PARAMS{4,1} = { [] ; [] ; [] };   % m4a (44)
PARAMS{4,2} = { [] ; [] ; [] };   % m4a (44)
PARAMS{4,3} = { [] ; [] ; [] };   % m4a (44)
PARAMS{4,4} = { [] ; [] ; [] };   % m4a (44)

PARAMS{5,1} = { [] ; [] ; [] };   % m4b (46)
PARAMS{5,2} = { [] ; [] ; [] };   % m4b (46)
PARAMS{5,3} = { [] ; [] ; [] };   % m4b (46)
PARAMS{5,4} = { [] ; [] ; [] };   % m4b (46)

% bASELINE 1: TAMERIUS-COMRIE FORECASTS
% tHIRTEEN values per year. Element 1 is the transition month nF; the
% twelve forecast months are elements 2:13. Do not change this convention
% without also changing the (2:13) indexing further down.
TC_AZ_2021 = [707.5104; 737.2373; 733.9080; 750.9479; 658.8718; 675.1611; 563.6294; 565.6346; 599.1101; 558.9227; 567.5328; 680.7445; 824.9367];
TC_AZ_2022 = [908.4276; 819.5085; 736.6732; 790.6021; 837.6447; 743.3576; 693.0547; 620.4095; 573.5439; 595.8047; 566.4448; 658.8287; 767.2971];
TC_AZ_2023 = [781.9093; 758.6741; 630.5566; 679.5883; 703.2214; 725.1679; 700.6664; 613.6168; 797.5111; 702.2744; 690.3678; 781.6884; 763.2257];

TC_Maricopa_2021 = [565.0907; 548.5036; 554.7399; 557.3126; 428.3653; 480.2193; 379.6675; 407.5240; 449.0779; 359.1002; 404.3420; 525.0564; 671.4363];
TC_Maricopa_2022 = [724.6351; 599.2606; 530.2629; 584.3016; 613.0064; 555.7155; 527.3416; 451.1276; 410.8944; 393.8711; 394.5529; 444.2505; 541.2429];
TC_Maricopa_2023 = [553.8612; 551.1149; 473.5029; 463.3333; 474.6553; 539.6458; 492.3527; 440.6241; 599.8478; 513.6198; 476.1020; 605.0966; 550.7576];

TC_Pima_2021 = [95.0597; 97.0932; 94.7931; 96.2102; 90.5458; 95.0764; 88.7555; 90.7834; 95.5735; 96.8089; 97.9194; 95.1658; 102.7506];
TC_Pima_2022 = [108.0345; 104.0081; 98.6287; 99.9073; 101.8449; 97.3830; 95.5852; 93.0267; 92.2272; 95.1189; 91.3467; 93.9072; 98.6093];
TC_Pima_2023 = [96.4506; 95.7274; 95.2367; 93.1071; 95.2706; 97.0378; 94.7545; 94.4359; 114.9199; 105.3301; 97.4491; 96.3992; 95.2962];

TC_Pinal_2021 = [59.6547; 63.4995; 59.8326; 65.4443; 54.6446; 60.6737; 44.0501; 48.1776; 59.0723; 56.3596; 56.6211; 61.4767; 68.2531];
TC_Pinal_2022 = [75.4466; 76.7341; 70.8362; 71.2748; 73.5138; 65.3073; 62.0864; 58.5096; 54.8137; 63.9513; 61.2581; 66.7516; 72.4096];
TC_Pinal_2023 = [73.5401; 77.0145; 55.1673; 62.7127; 67.1860; 67.7313; 66.6701; 54.9977; 76.1307; 69.9924; 69.6143; 67.1935; 71.8966];

% bASELINE 2: XGBOOST FORECASTS  (B.fcPred rows from the paste-ready block)
% tWELVE values per year: the forecast months only.
XGB_AZ_2021 = [1012.9443; 868.8881; 772.1630; 682.2053; 597.4088; 578.2216; 688.7863; 694.1551; 685.7263; 636.1924; 574.0775; 648.1558];
XGB_AZ_2022 = [1196.9231; 1213.4247; 1179.7246; 1209.5599; 1125.0896; 1145.2573; 1122.2458; 1085.6937; 1120.8518; 1088.5477; 1124.7803; 1265.1228];
XGB_AZ_2023 = [761.5176; 799.0724; 734.4827; 686.5269; 691.4819; 632.9226; 728.5461; 857.0472; 905.9446; 859.0927; 885.4941; 952.8561];

XGB_Maricopa_2021 = [740.3182; 650.5286; 602.1549; 519.3777; 475.3572; 566.8234; 533.3378; 477.6929; 494.9686; 484.2459; 484.6469; 592.6965];
XGB_Maricopa_2022 = [948.6762; 902.4980; 898.0259; 835.5712; 838.0183; 851.3199; 794.9159; 785.8469; 813.7142; 769.0352; 787.8491; 953.0441];
XGB_Maricopa_2023 = [593.2013; 587.2902; 483.3821; 443.7912; 450.4017; 463.1648; 474.0211; 560.5059; 706.4294; 669.9343; 666.9277; 786.3369];

XGB_Pima_2021 = [127.9822; 98.8230; 92.6440; 88.3221; 90.4304; 94.8163; 92.8638; 103.8414; 111.6494; 115.9360; 112.6675; 130.7268];
XGB_Pima_2022 = [124.5578; 122.4502; 114.2284; 113.2338; 129.4280; 125.3993; 120.2814; 114.1357; 102.6377; 100.1575; 104.9393; 118.7614];
XGB_Pima_2023 = [77.7498; 83.3453; 85.8745; 85.2378; 89.8031; 93.6885; 98.7393; 96.0900; 102.4253; 113.2496; 104.9972; 120.2010];

XGB_Pinal_2021 = [115.1649; 87.2110; 65.0125; 47.4911; 57.2558; 65.1472; 82.6616; 72.3651; 75.2776; 78.0412; 80.7718; 87.1311];
XGB_Pinal_2022 = [95.4569; 117.5786; 90.9482; 81.4363; 65.3827; 77.1383; 68.8730; 75.0258; 77.3956; 73.6375; 74.9039; 81.3741];
XGB_Pinal_2023 = [71.2722; 70.1592; 53.4693; 41.2032; 47.8371; 53.3493; 62.0681; 72.0617; 73.0028; 74.5599; 73.4514; 76.9563];

% bASELINE 3: NB DISTRIBUTED-LAG GLM FORECASTS
% tWELVE values per year: the forecast months only.
GLM_AZ_2021 = [1119.7727; 1034.5261; 916.2183; 802.9698; 811.3395; 790.5415; 666.4485; 672.0680; 622.6886; 707.3744; 772.8118; 938.3738];
GLM_AZ_2022 = [1192.2356; 1255.7494; 1154.6616; 1164.1739; 1247.2425; 1357.2060; 1367.1489; 1260.0566; 1126.9384; 1114.0660; 1432.9687; 1614.6581];
GLM_AZ_2023 = [1274.4663; 1270.8791; 1064.4274; 897.2202; 842.0070; 950.3577; 1151.4745; 1269.9516; 1185.3570; 1206.6453; 1234.9138; 1436.4204];
GLM_Maricopa_2021 = [973.5853; 922.0611; 886.7263; 762.2752; 751.1497; 636.3773; 474.8932; 429.7455; 401.0205; 502.7222; 494.4550; 562.4570];
GLM_Maricopa_2022 = [722.8934; 689.2448; 623.9347; 589.0941; 610.7162; 682.9015; 702.4848; 680.9384; 677.4514; 715.6797; 960.9637; 1110.4833];
GLM_Maricopa_2023 = [954.9169; 937.0922; 779.4092; 610.3436; 576.7877; 633.2114; 773.4358; 939.2692; 916.3141; 947.4523; 951.6297; 1060.2031];
GLM_Pima_2021 = [115.2879; 104.7189; 82.2152; 72.0385; 72.6508; 72.6823; 62.4117; 63.7901; 70.2940; 83.5888; 101.3713; 134.1782];
GLM_Pima_2022 = [138.5042; 137.8598; 120.0654; 109.2966; 113.2430; 136.6040; 152.9987; 142.5068; 129.4835; 120.2845; 136.3476; 159.4900];
GLM_Pima_2023 = [129.8210; 126.1466; 106.7150; 85.8349; 85.4827; 90.0777; 114.0429; 137.2336; 127.4020; 120.2240; 111.1697; 127.1574];
GLM_Pinal_2021 = [83.3972; 64.8623; 54.7477; 46.2195; 45.2192; 48.3871; 36.6884; 34.8297; 31.5764; 39.7635; 52.0440; 72.9865];
GLM_Pinal_2022 = [97.3183; 92.9860; 82.9946; 82.9309; 95.2252; 116.2642; 129.8334; 116.2848; 104.7892; 104.1812; 129.2321; 140.6618];
GLM_Pinal_2023 = [105.6885; 97.2668; 80.8577; 67.5562; 68.6519; 78.9200; 101.4800; 111.2793; 99.2661; 102.8615; 109.0651; 131.0173];

% tC is 13-long per year, so take (2:13); the other two are already 12-long.
baseName = {'Tamerius-Comrie', 'XGBoost', 'NB-GLM'};
nB       = numel(baseName);
BASE     = cell(nB, nR);
BASE{1,1} = [TC_AZ_2021(2:13);       TC_AZ_2022(2:13);       TC_AZ_2023(2:13)];
BASE{1,2} = [TC_Maricopa_2021(2:13); TC_Maricopa_2022(2:13); TC_Maricopa_2023(2:13)];
BASE{1,3} = [TC_Pima_2021(2:13);     TC_Pima_2022(2:13);     TC_Pima_2023(2:13)];
BASE{1,4} = [TC_Pinal_2021(2:13);    TC_Pinal_2022(2:13);    TC_Pinal_2023(2:13)];
BASE{2,1} = [XGB_AZ_2021;       XGB_AZ_2022;       XGB_AZ_2023];
BASE{2,2} = [XGB_Maricopa_2021; XGB_Maricopa_2022; XGB_Maricopa_2023];
BASE{2,3} = [XGB_Pima_2021;     XGB_Pima_2022;     XGB_Pima_2023];
BASE{2,4} = [XGB_Pinal_2021;    XGB_Pinal_2022;    XGB_Pinal_2023];
BASE{3,1} = [GLM_AZ_2021;       GLM_AZ_2022;       GLM_AZ_2023];
BASE{3,2} = [GLM_Maricopa_2021; GLM_Maricopa_2022; GLM_Maricopa_2023];
BASE{3,3} = [GLM_Pima_2021;     GLM_Pima_2022;     GLM_Pima_2023];
BASE{3,4} = [GLM_Pinal_2021;    GLM_Pinal_2022;    GLM_Pinal_2023];

global alpha_h_Maricopa omega_Maricopa c_Maricopa alpha_h_Pinal omega_Pinal c_Pinal alpha_h_Pima omega_Pima c_Pima alpha_h_AZ omega_AZ c_AZ
omega_vital = 0.021/365;
alpha_h_Maricopa = 0.000500942192598 + omega_vital; omega_Maricopa = omega_vital; c_Maricopa = 0.000500942192598/4724819.974562017247081;
alpha_h_Pinal    = 0.000076238824090 + omega_vital; omega_Pinal    = omega_vital; c_Pinal    = 0.000076238824090/5162630.000;
alpha_h_Pima     = 0.000019432499300 + omega_vital; omega_Pima     = omega_vital; c_Pima     = 0.000019432499300/10639930.00;
alpha_h_AZ       = 0.000304888503016 + omega_vital; omega_AZ       = omega_vital; c_AZ       = 0.000304888503016/7853513.125630123540759;

YINF = { y_inf_data_AZ, y_inf_data_Maricopa, y_inf_data_Pima, y_inf_data_Pinal };
YPOP = { y_pop_data_AZ, y_pop_data_Maricopa, y_pop_data_Pima, y_pop_data_Pinal };
nDimExp = [14 22 35 44 46];

% sign convention: predicted minus observed, on BOTH sides.
Yob  = cell(1,nR);
Eb   = cell(nB,nR);
haveB = false(nB,nR);
for r = 1:nR
    Yob{r} = YINF{r}(97:132);
    assert(numel(Yob{r})==36, '%s: expected 36 forecast months, got %d', regions{r}, numel(Yob{r}));
    for b = 1:nB
        v = BASE{b,r};
        if numel(v) == 36 && all(isfinite(v))
            Eb{b,r} = v(:) - Yob{r};  haveB(b,r) = true;
        else
            warning('DM:noBaseline','%s / %s: forecast is %d long, need 36. Skipped.', ...
                    baseName{b}, regions{r}, numel(v));
        end
    end
end
assert(any(haveB(:)), 'No usable baseline forecasts; nothing to compare against.');

E    = cell(nM, nR);
have = false(nM, nR);
SOLV = cell(nM, nR);
fprintf('\nre-solving each model on its forecast window\n');
fprintf('%-9s %-9s %-6s %-24s %s\n','model','region','horiz','solver','fc RRMSE %%');
fprintf('%s\n', repmat('-',1,72));

for m = 1:nM
    for r = 1:nR
        if ~any(haveB(:,r)), continue; end
        pc = PARAMS{m,r};
        if isempty(pc) || all(cellfun(@isempty, pc)), continue; end
        if numel(pc) ~= 3
            warning('DM:badSlot','%s %s: PARAMS needs 3 entries, has %d. Skipped.', ...
                    modelName{m}, regions{r}, numel(pc));
            continue;
        end

        pop0 = YPOP{r}(1);  ydat = YINF{r};  cid = countyID(r);
        eAll = nan(36,1);   sAll = cell(3,1);  ok = true;

        for h = 1:3
            p = pc{h};
            if isempty(p), ok = false; break; end
            p = p(:);
            if numel(p) ~= nDimExp(m)
                warning('DM:badLen','%s %s h=%d: %d parameters, expected %d. Skipped.', ...
                        modelName{m}, regions{r}, h, numel(p), nDimExp(m));
                ok = false; break;
            end
            nF  = nFitList(h);
            t_m = t_inf_data(1:nF+13);
            yd  = ydat(1:nF+13);

            switch m
                case 1, [~,~,sv,mmon] = objective_functionM1(  p, t_m, pop0, yd);
                case 2, [~,~,sv,mmon] = objective_functionM2(  p, t_m, pop0, yd);
                case 3, [~,~,sv,mmon] = objective_functionM3(  p, t_m, pop0, yd, cid);
                case 4, [~,~,sv,mmon] = objective_functionM4_S(p, t_m, pop0, yd, cid);
                case 5, [~,~,sv,mmon] = objective_functionM5(  p, t_m, pop0, yd, cid);
            end

            if isempty(mmon) || numel(mmon) < nF+12 || ~all(isfinite(mmon(nF+1:nF+12)))
                warning('DM:solveFailed','%s %s h=%d: solvers failed (%s). Skipped.', ...
                        modelName{m}, regions{r}, h, sv);
                ok = false; break;
            end
            slot = (h-1)*12 + (1:12);
            eAll(slot) = mmon(nF+1:nF+12) - ydat(nF+1:nF+12);
            sAll{h}    = sv;
            fprintf('%-9s %-9s %-6s %-24s %10.2f\n', modelName{m}, regions{r}, ...
                    yrLabel{h}, sv, 100*sqrt(mean(eAll(slot).^2))/mean(ydat(nF+1:nF+12)));
        end

        if ok && all(isfinite(eAll))
            E{m,r} = eAll;  SOLV{m,r} = sAll;  have(m,r) = true;
        end
    end
end

fprintf('%s\n', repmat('-',1,72));
fprintf('\nmodel-region pairs available (rows models, cols regions):\n');
fprintf('%-16s', 'model'); fprintf('%12s', regions{:}); fprintf('\n');
for m = 1:nM
    fprintf('%-16s', modelName{m});
    for r = 1:nR, fprintf('%12s', string(have(m,r))); end
    fprintf('\n');
end
for b = 1:nB
    fprintf('%-16s', baseName{b});
    for r = 1:nR, fprintf('%12s', string(haveB(b,r))); end
    fprintf('\n');
end
assert(any(have(:)), 'No ODE parameter vectors pasted; nothing to test.');

fprintf('\nbaseline forecast RRMSE (%%), pooled over the 36 months:\n');
fprintf('%-16s', 'baseline'); fprintf('%12s', regions{:}); fprintf('\n');
for b = 1:nB
    fprintf('%-16s', baseName{b});
    for r = 1:nR
        if haveB(b,r)
            fprintf('%12.2f', 100*sqrt(mean(Eb{b,r}.^2))/mean(Yob{r}));
        else
            fprintf('%12s','-');
        end
    end
    fprintf('\n');
end

% oNE FULL TEST PER BASELINE
RESULTS = struct('baseline',{},'DM',{},'MDM',{},'Pasym',{},'Pboot',{}, ...
                 'Pholm',{},'Psign',{},'WinFrac',{},'DBAR',{},'Ntot',{}, ...
                 'HF',{},'DMreg',{},'Preg',{});

for b = 1:nB
    usableR = find(haveB(b,:));
    if isempty(usableR)
        fprintf('\n%s: no usable regions, skipped.\n', baseName{b});
        continue
    end

% d{m,r} is 36x1. Positive means the BASELINE had the larger loss, i.e.
% the mechanistic model forecast better.
    d = cell(nM, nR);
    for r = usableR
        switch LOSS
            case 'rel_mean', den = mean(Yob{r}) * ones(36,1);
            case 'rel_obs',  den = Yob{r};
            otherwise, error('LOSS must be rel_mean or rel_obs');
        end
        assert(all(den > 0), '%s has a non-positive loss denominator', regions{r});
        lb = (Eb{b,r} ./ den).^2;
        for m = 1:nM
            if have(m,r), d{m,r} = lb - (E{m,r} ./ den).^2; end
        end
    end

    DMp = nan(nM,1);  MDMp = nan(nM,1);  Pasym = nan(nM,1);  Pboot = nan(nM,1);
    HF  = nan(nM,1);  Ntot = nan(nM,1);  DBAR  = nan(nM,1);
    WinFrac = nan(nM,1);  Psign = nan(nM,1);

    for m = 1:nM
        dc = d(m, usableR);
        if all(cellfun(@isempty, dc)), continue; end
        [DMp(m), MDMp(m), HF(m), Ntot(m), DBAR(m)] = dm_stats(dc, H_HORIZON);
        Pasym(m) = 2*(1 - tcdf(abs(MDMp(m)), Ntot(m)-1));
        Pboot(m) = boot_p(dc, NBOOT, BLOCK_LEN);

        blkmeans = [];
        for q = 1:numel(dc)
            if isempty(dc{q}), continue; end
            x  = dc{q}(:);
            nb = floor(numel(x)/BLOCK_LEN);
            blkmeans = [blkmeans; arrayfun(@(j) mean(x((j-1)*BLOCK_LEN+1 : j*BLOCK_LEN)), (1:nb)')];   % #ok<AGROW>
        end
        nb = numel(blkmeans);  w = sum(blkmeans > 0);
        WinFrac(m) = w/nb;
        Psign(m)   = min(2*min(binocdf(w,nb,0.5), 1-binocdf(w-1,nb,0.5)), 1);
    end

    valid = find(~isnan(Pasym));
    Pholm = nan(nM,1);
    if ~isempty(valid)
        [ps, ord] = sort(Pasym(valid));
        kk  = numel(ps);
        adj = min(1, ps .* (kk - (1:kk)' + 1));
        adj = cummax(adj);
        Pholm(valid(ord)) = adj;
    end

    fprintf('\n========================================================================\n');
    fprintf('  POOLED DIEBOLD-MARIANO, mechanistic models vs %s\n', baseName{b});
    fprintf('  loss = %s   regions = %s   N = %d   h = %d\n', ...
            LOSS, strjoin(regions(usableR), ' '), max(Ntot(~isnan(Ntot))), H_HORIZON);
    fprintf('========================================================================\n');
    fprintf('%-9s %10s %8s %8s %9s %9s %9s %7s %8s\n', ...
            'model','mean d','DM','MDM','p asym','p boot','p Holm','win %','p sign');
    fprintf('%s\n', repmat('-',1,86));
    for m = 1:nM
        if isnan(DMp(m)), fprintf('%-9s %10s\n', modelName{m}, 'no data'); continue; end
        star = '';
        if ~isnan(Pholm(m))
            if     Pholm(m) < 0.001, star = '***';
            elseif Pholm(m) < 0.01,  star = '**';
            elseif Pholm(m) < ALPHA, star = '*';
            end
        end
        fprintf('%-9s %10.3e %8.3f %8.3f %9.4f %9.4f %9.4f %7.1f %8.4f %s\n', ...
            modelName{m}, DBAR(m), DMp(m), MDMp(m), Pasym(m), Pboot(m), Pholm(m), ...
            100*WinFrac(m), Psign(m), star);
    end
    fprintf('%s\n', repmat('-',1,86));
    if any(~isnan(HF))
        fprintf('Harvey factor %.4f at N = %d, h = %d\n', ...
                HF(find(~isnan(HF),1)), max(Ntot(~isnan(Ntot))), H_HORIZON);
    end
    fprintf('Positive mean d and positive DM: the mechanistic model forecasts BETTER\n');
    fprintf('than %s. MDM = DM x Harvey factor, exactly.\n', baseName{b});
    fprintf('p boot is the two-level block bootstrap (%d draws, %d-month blocks) and is\n', ...
            NBOOT, BLOCK_LEN);
    fprintf('the p-value to report. p Holm adjusts it across the %d models tested.\n', numel(valid));

    fprintf('\n  PER-REGION MDM vs %s (single-level block bootstrap)\n', baseName{b});
    fprintf('%-9s', 'model');
    for r = usableR, fprintf('%18s', regions{r}); end
    fprintf('\n%s\n', repmat('-', 1, 9 + 18*numel(usableR)));
    DMreg = nan(nM,nR);  Preg = nan(nM,nR);
    for m = 1:nM
        fprintf('%-9s', modelName{m});
        for r = usableR
            if isempty(d{m,r}), fprintf('%18s', '-'); continue; end
            [~, mdm_r, ~, ~, ~] = dm_stats(d(m,r), H_HORIZON);
            p_r = boot_p(d(m,r), NBOOT, BLOCK_LEN);
            DMreg(m,r) = mdm_r;  Preg(m,r) = p_r;
            mk = '';
            if p_r < 0.001, mk='***'; elseif p_r < 0.01, mk='**'; elseif p_r < ALPHA, mk='*'; end
            fprintf('%14.2f %-3s', mdm_r, mk);
        end
        fprintf('\n');
    end
    fprintf('%s\n', repmat('-', 1, 9 + 18*numel(usableR)));
    fprintf('Per region only 9 blocks of %d months are available, so these are\n', BLOCK_LEN);
    fprintf('underpowered individually and are shown for consistency of sign.\n');

    RESULTS(b) = struct('baseline',baseName{b},'DM',DMp,'MDM',MDMp,'Pasym',Pasym, ...
        'Pboot',Pboot,'Pholm',Pholm,'Psign',Psign,'WinFrac',WinFrac,'DBAR',DBAR, ...
        'Ntot',Ntot,'HF',HF,'DMreg',DMreg,'Preg',Preg);
end

fprintf('\n\n================= MDM SUMMARY ACROSS BASELINES =================\n');
fprintf('%-9s', 'model');
for b = 1:nB, fprintf('%24s', baseName{b}); end
fprintf('\n%s\n', repmat('-', 1, 9 + 24*nB));
for m = 1:nM
    fprintf('%-9s', modelName{m});
    for b = 1:nB
        if b > numel(RESULTS) || isempty(RESULTS(b).MDM) || isnan(RESULTS(b).MDM(m))
            fprintf('%24s','-');
        else
            fprintf('%16.3f (%.3f)', RESULTS(b).MDM(m), RESULTS(b).Pboot(m));
        end
    end
    fprintf('\n');
end
fprintf('%s\n', repmat('-', 1, 9 + 24*nB));
fprintf('MDM statistic with bootstrap p in parentheses. Positive favours the ODE.\n');

save('DM_MDM_results_3baselines.mat', 'RESULTS','modelName','regions','baseName', ...
     'LOSS','NBOOT','BLOCK_LEN','H_HORIZON');
fprintf('\nsaved DM_MDM_results_3baselines.mat\n');

fprintf('\n\n');
fprintf('###########################################################################\n');
fprintf('#  MDM TABLES FOR THE MANUSCRIPT                                          #\n');
fprintf('#  n = %d pooled months, h = %d, Harvey factor = %.6f                 #\n', ...
        144, H_HORIZON, sqrt((144 + 1 - 2*H_HORIZON + H_HORIZON*(H_HORIZON-1)/144)/144));
fprintf('#  loss = %s, block length = %d months, %d bootstrap draws          #\n', ...
        LOSS, BLOCK_LEN, NBOOT);
fprintf('#  two-sided t critical value at 0.05, df = 143 : %.4f                   #\n', ...
        tinv(0.975, 143));
fprintf('###########################################################################\n');

% d2{b,m,r} is 36x1. Positive means the BASELINE had the larger loss, i.e. the
% mechanistic model forecast better. Identical construction to the main loop.
d2 = cell(nB, nM, nR);
for b = 1:nB
    for r = 1:nR
        if ~haveB(b,r), continue; end
        switch LOSS
            case 'rel_mean', den = mean(Yob{r}) * ones(36,1);
            case 'rel_obs',  den = Yob{r};
        end
        lb = (Eb{b,r} ./ den).^2;
        for m = 1:nM
            if have(m,r)
                d2{b,m,r} = lb - (E{m,r} ./ den).^2;
            end
        end
    end
end

% tABLES 1-4: ONE PER REGION
% each region contributes 36 forecast months = 3 independent forecast
% episodes, so these are underpowered by construction. They belong in the
% sI; the informative content is whether the SIGN is consistent.
for r = 1:nR
    fprintf('\n\n=== TABLE %d: %s (per-region MDM, n = 36, h = %d) ===\n', ...
            r, upper(regions{r}), H_HORIZON);
    fprintf('%-9s %14s %14s %14s %14s %14s\n', ...
            'model', 'baseline', 'mean d', 'MDM', 'p asym', 'p boot');
    fprintf('%s\n', repmat('-', 1, 83));
    for m = 1:nM
        for b = 1:nB
            if isempty(d2{b,m,r})
                fprintf('%-9s %14s %14s %14s %14s %14s\n', ...
                        modelName{m}, baseName{b}, '-', '-', '-', '-');
                continue
            end
            [~, mdm_r, ~, nT_r, db_r] = dm_stats(d2(b,m,r), H_HORIZON);
            pa_r = 2*(1 - tcdf(abs(mdm_r), nT_r - 1));
            pb_r = boot_p(d2(b,m,r), NBOOT, BLOCK_LEN);
            fprintf('%-9s %14s %14.8f %14.6f %14.6f %14.6f\n', ...
                    modelName{m}, baseName{b}, db_r, mdm_r, pa_r, pb_r);
        end
    end
    fprintf('%s\n', repmat('-', 1, 83));
end

% tABLE 5: POOLED ACROSS ALL FOUR REGIONS  -- the main-body table
% autocovariances accumulate WITHIN region only, so the concatenation seams
% are never treated as consecutive observations.
fprintf('\n\n=== TABLE 5: POOLED ACROSS ALL REGIONS (main body) ===\n');
fprintf('%-9s %14s %6s %13s %10s %9s %9s %9s %9s %9s %9s\n', ...
        'model','baseline','n','mean d','MDM','p asym','p Holm', ...
        'RR base%','RR mod%','dRRMSE%','dMSE%');
fprintf('%s\n', repmat('-', 1, 124));

PooledMDM  = nan(nM, nB);  PooledPa = nan(nM, nB);
PooledPb   = nan(nM, nB);  PooledPh = nan(nM, nB);
PooledDbar = nan(nM, nB);  PooledSg = nan(nM, nB);  PooledN = nan(nM, nB);
PooledRRb  = nan(nM, nB);  PooledRRm = nan(nM, nB);  PooledMSEred = nan(nM, nB);

for b = 1:nB
    usableR = find(haveB(b,:));
    if isempty(usableR), continue; end

    for m = 1:nM
        dc = squeeze(d2(b, m, usableR));
        if ~iscell(dc), dc = {dc}; end
        dc = reshape(dc, 1, []);
        if all(cellfun(@isempty, dc)), continue; end
        [~, mdm_p, ~, nT, db] = dm_stats(dc, H_HORIZON);
        PooledMDM(m,b)  = mdm_p;
        PooledDbar(m,b) = db;
        PooledN(m,b)    = nT;
% pooled mean scaled squared loss for baseline and model, over the
% same months the test used. RRMSE is its square root; MSE reduction
% is linear in the DM loss, RRMSE reduction is what the RRMSE tables
% report. Both printed so either can be quoted without recomputation.
        Lb = 0;  Lm = 0;  nn = 0;
        for rr2 = usableR
            if isempty(d2{b,m,rr2}), continue; end
            den = mean(Yob{rr2});
            Lb  = Lb + sum((Eb{b,rr2} ./ den).^2);
            Lm  = Lm + sum((E{m,rr2}  ./ den).^2);
            nn  = nn + numel(Yob{rr2});
        end
        if nn > 0
            Lb = Lb/nn;  Lm = Lm/nn;
            PooledRRb(m,b)    = 100*sqrt(Lb);
            PooledRRm(m,b)    = 100*sqrt(Lm);
            PooledMSEred(m,b) = 100*(Lb - Lm)/Lb;
        end
        PooledPa(m,b)   = 2*(1 - tcdf(abs(mdm_p), nT - 1));
        PooledPb(m,b)   = boot_p(dc, NBOOT, BLOCK_LEN);
% sign consistency across BLOCK_LEN-month blocks
        bm = [];
        for q = 1:numel(dc)
            if isempty(dc{q}), continue; end
            x  = dc{q}(:);
            nb = floor(numel(x)/BLOCK_LEN);
            bm = [bm; arrayfun(@(j) mean(x((j-1)*BLOCK_LEN+1 : j*BLOCK_LEN)), (1:nb)')];   % #ok<AGROW>
        end
        PooledSg(m,b) = 100*sum(bm > 0)/numel(bm);
    end

% holm-Bonferroni across the five models, on the asymptotic p
    valid = find(~isnan(PooledPa(:,b)));
    if ~isempty(valid)
        [ps, ord] = sort(PooledPa(valid, b));
        kk  = numel(ps);
        adj = cummax(min(1, ps .* (kk - (1:kk)' + 1)));
        PooledPh(valid(ord), b) = adj;
    end
end

for m = 1:nM
    for b = 1:nB
        if isnan(PooledMDM(m,b))
            fprintf('%-9s %14s %6s %13s %10s %9s %9s %9s %9s %9s %9s\n', ...
                    modelName{m}, baseName{b}, '-','-','-','-','-','-','-','-','-');
            continue
        end
        dRR = 100*(PooledRRm(m,b) - PooledRRb(m,b))/PooledRRb(m,b);
        fprintf('%-9s %14s %6d %13.8f %10.6f %9.6f %9.6f %9.4f %9.4f %9.2f %9.2f\n', ...
                modelName{m}, baseName{b}, PooledN(m,b), PooledDbar(m,b), ...
                PooledMDM(m,b), PooledPa(m,b), PooledPh(m,b), ...
                PooledRRb(m,b), PooledRRm(m,b), dRR, PooledMSEred(m,b));
    end
end
fprintf('%s\n', repmat('-', 1, 112));
fprintf('Positive mean d and positive MDM: the mechanistic model forecasts BETTER\n');
fprintf('than the baseline. p asym refers MDM to t(n-1) and is internally consistent\n');
fprintf('with the statistic; p boot is the two-level block bootstrap. p Holm adjusts\n');
fprintf('p asym across the five models within each baseline family.\n');

fprintf('\n=== SIGN CONSISTENCY ACROSS REGIONS (12 model-baseline-region cells) ===\n');
fprintf('%-9s %14s %10s %10s\n', 'model','baseline','pos/4 reg','all same?');
fprintf('%s\n', repmat('-', 1, 47));
for m = 1:nM
    for b = 1:nB
        sgn = nan(1,nR);
        for r = 1:nR
            if isempty(d2{b,m,r}), continue; end
            [~, mr] = dm_stats(d2(b,m,r), H_HORIZON);
            sgn(r) = sign(mr);
        end
        v = sgn(~isnan(sgn));
        if isempty(v), continue; end
        fprintf('%-9s %14s %10s %10s\n', modelName{m}, baseName{b}, ...
                sprintf('%d/%d', sum(v>0), numel(v)), ...
                string(all(v>0) || all(v<0)));
    end
end
fprintf('%s\n', repmat('-', 1, 47));
fprintf('Under equal accuracy each region sign is a fair coin, so 4/4 in one\n');
fprintf('direction has probability 2*(1/2)^4 = 0.125 for a single comparison.\n');

save('MDM_tables_for_manuscript.mat', 'PooledMDM','PooledPa','PooledPb', ...
     'PooledPh','PooledDbar','PooledSg','PooledN','modelName','baseName', ...
     'regions','LOSS','BLOCK_LEN','NBOOT','H_HORIZON');
fprintf('\nsaved MDM_tables_for_manuscript.mat\n');

elseif choose_model==9
% pLOTTING THE FULL-SAMPLE FITS: all five mechanistic models plus
% tamerius-Comrie, for one region.
% rEBUILT. What changed and why:
% 1. PLOTS MONTHLY INTEGRATED INCIDENCE, NOT THE I COMPARTMENT. The previous
% version plotted y(:,4), (:,7), (:,8) and (:,9) -- the I STOCK -- against
% monthly case counts. The models are fitted to the integral of the
% incidence flux over each calendar month. At a 90-day sojourn the stock
% filters out roughly 80% of month-to-month variation, which is why the
% old curves looked far better than the fits were.
% 2. THE SUBTITLE RRMSE VALUES WERE HARDCODED, AND WERE THE OLD ONES.
% e.g. "Tamerius/Comrie Model=2.6701%, M1 RRMSE=2.2534%, ... M5=1.3107%".
% those came from the sqrt(sumsqr(y)) normalisation, which is about 12.3x
% too small, so 1.31% is really about 16%. Every number in the subtitle is
% now computed from the trajectory actually plotted.
% 3. A HAND-CONSTRUCTED MODEL 4b CURVE FOR PIMA. The previous version ran:
% for i = 1:length(y_inf_data)
% if (y_inf_data(i)-y_M4_Pima(i,8)) <= (y_inf_data(i)-y_M3_Pima(i,7))
% y_M5_Pima(i,9) = (y_inf_data(i)-y_M4_Pima(i,8))./4 + y_M4_Pima(i,8);
% elseif ...
% end
% that OVERWRITES the fitted Model 4b trajectory with a synthetic curve
% placed one quarter of the way from whichever of Model 3 or 4a was closer
% toward the observed data. It is not a model output. REMOVED. If Model 4b
% genuinely fits Pima poorly, that is the result.
% 4. BEST-OF-FOUR-SOLVERS IS KEPT, as you asked: each model is integrated
% with ode15s, ode23s, ode45 and ode78 and the one giving the LOWEST
% rRMSE is reported, along with which solver that was. Unlike before, the
% comparison is on MONTHLY INTEGRATED INCIDENCE rather than the I stock,
% the solve is on a daily grid, and a solver that returns a short solution
% or errors is skipped rather than silently scoring 1e10 and being kept.
% a cross-check against the objective's own chain result is printed, so a
% mismatch in the reconstructed y0 cannot pass unnoticed.
% 5. ode123s does not exist (typo for ode23s) in the Model 4b switch block,
% and the 'otherwise' branches printed the undefined final_solver_name.
% 6. rmse() and sumsqr() need the Statistics and Deep Learning toolboxes and
% are gone. loose_options_final set MaxStep 1e-3, which over a 4017-day
% span forces 4 million steps; it was also never used.
% 7. EIGHTY near-identical solve blocks (4 regions x 5 models x 4 solvers)
% collapse to one loop.
disp('Plotting full-sample fits')
format short

global alpha_h_Maricopa omega_Maricopa c_Maricopa alpha_h_Pinal omega_Pinal c_Pinal alpha_h_Pima omega_Pima c_Pima alpha_h_AZ omega_AZ c_AZ
omega_vital = 0.021/365;
alpha_h_Maricopa = 0.000500942192598 + omega_vital; omega_Maricopa = omega_vital; c_Maricopa = 0.000500942192598/4724819.974562017247081;
alpha_h_Pinal    = 0.000076238824090 + omega_vital; omega_Pinal    = omega_vital; c_Pinal    = 0.000076238824090/5162630.000;
alpha_h_Pima     = 0.000019432499300 + omega_vital; omega_Pima     = omega_vital; c_Pima     = 0.000019432499300/10639930.00;
alpha_h_AZ       = 0.000304888503016 + omega_vital; omega_AZ       = omega_vital; c_AZ       = 0.000304888503016/7853513.125630123540759;

modelName = {'Model 1','Model 2','Model 3','Model 4a','Model 4b'};
nM        = 5;
nMonths   = 132;
% expected parameter-vector lengths. Model 4b is 46 because LB(47)/UB(47) are
% left commented out in its bounds block; change to 47 if you pin that index.
nDimExp   = [14 22 35 44 46];
% which state column holds S, E, A_H, I, R for each model, for the
% compartment figure. NaN where the model has no such compartment.
colS = [3 5 5  6  6];
colE = [NaN 6 6 7 7];
colAH= [NaN NaN NaN NaN 8];
colI = [4 7 7 8 9];
colR = [5 8 8 9 10];

% pASTE THE FULL-SAMPLE FITTED PARAMETER VECTORS HERE
% pARAMS{model, region}, region 1 = AZ, 2 = Maricopa, 3 = Pima, 4 = Pinal
% these are the params_mXpswarm vectors from the FITTING runs (all 132
% months), not the forecasting ones. Leave [] to skip that model.
PARAMS = cell(nM,4);

% rows: 1 = Model 1, 2 = Model 2, 3 = Model 3, 4 = Model 4a, 5 = Model 4b
% cols: 1 = AZ, 2 = Maricopa, 3 = Pima, 4 = Pinal   (matches regTag switch)
% lengths: M1 14, M2 22, M3 35, M4a 44, M4b 46. Verified against the
% objective's own bounds vectors; a length mismatch is caught by the assert
% at the bottom of this block rather than surfacing as a solver error.
% mean-normalised RRMSE of each cell, for reference:
% aZ      Maricopa    Pima      Pinal
% model 1     26.85%    28.50%    23.07%    32.43%
% model 2     25.07%    26.96%    22.91%    31.69%
% model 3     20.47%    23.14%    22.04%    27.56%
% model 4a    21.27%    19.66%    22.04%    26.71%
% model 4b    20.86%    19.45%    20.98%    23.21%
% floor        9.78%    10.28%    14.20%    17.00%

% fitted parameter vectors are not distributed in this file.
% paste them in below, keeping the shape shown.
% index: PARAMS{model,region}; model 1..5 = M1,M2,M3,M4a,M4b;
% region 1..4 = arizona, maricopa, pima, pinal.
% vector lengths: m1 14, m2 22, m3 35, m4a 44, m4b 46.
PARAMS{1,1} = [];   % m1 (14)
PARAMS{1,2} = [];   % m1 (14)
PARAMS{1,3} = [];   % m1 (14)
PARAMS{1,4} = [];   % m1 (14)

PARAMS{2,1} = [];   % m2 (22)
PARAMS{2,2} = [];   % m2 (22)
PARAMS{2,3} = [];   % m2 (22)
PARAMS{2,4} = [];   % m2 (22)

PARAMS{3,1} = [];   % m3 (35)
PARAMS{3,2} = [];   % m3 (35)
PARAMS{3,3} = [];   % m3 (35)
PARAMS{3,4} = [];   % m3 (35)

PARAMS{4,1} = [];   % m4a (44)
PARAMS{4,2} = [];   % m4a (44)
PARAMS{4,3} = [];   % m4a (44)
PARAMS{4,4} = [];   % m4a (44)

PARAMS{5,1} = [];   % m4b (46)
PARAMS{5,2} = [];   % m4b (46)
PARAMS{5,3} = [];   % m4b (46)
PARAMS{5,4} = [];   % m4b (46)

nExpect = [14 22 35 44 46];
for mm = 1:5
    for rr = 1:4
        if isempty(PARAMS{mm,rr})
            fprintf('PARAMS{%d,%d} is empty\n', mm, rr);
        elseif numel(PARAMS{mm,rr}) ~= nExpect(mm)
            error('PARAMS:len', 'PARAMS{%d,%d} has %d entries, expected %d', ...
                  mm, rr, numel(PARAMS{mm,rr}), nExpect(mm));
        end
    end
end
fprintf('PARAMS: all 20 cells present and correctly sized\n');
TARGET_RRMSE = [26.8484  28.5035  23.0653  32.4293;   % model 1
                25.0695  26.9622  22.9112  31.6866;   % model 2
                20.4697  23.1381  22.0350  27.5606;   % model 3
                21.2713  19.6643  22.0414  26.7058;   % model 4a
                20.8569  19.4463  20.9769  23.2141];   % model 4b
% wide scan: looser than the objective's default at the top, tighter below.
% loose tolerances are included deliberately -- if the reported fit was
% obtained under a loose solve, that is what we need to discover.
TOL_LIST   = [1e-1 1e-2 ; 3e-2 1e-3 ; 1e-2 1e-4 ; 3e-3 1e-5 ; ...
              1e-3 1e-6 ; 1e-4 1e-6 ; 1e-5 1e-8 ; 1e-6 1e-8 ; 1e-7 1e-10; 1e-8 1e-12];
TOL_MATCH  = 0.01;   % accept when |RRMSE - target| < this, in pp
SCAN_VERBOSE = true;

% tC Full  fits
TC_AZ_FullFit = [782.0571; 643.1545; 670.7843; 635.7386; 694.7256; 655.8205; 585.4907; 659.4947; 640.2451; 640.2839; 722.6061; 738.0791; 771.1762; 634.6458; 636.0469; 686.3567; 712.9133; 706.2514; 586.3221; 658.2400; 652.7131; 629.0975; 678.3449; 744.4083; 769.0145; 613.7352; 591.7070; 615.8381; 697.1063; 572.7569; 612.5421; 701.8360; 691.6209; 638.7741; 650.7595; 796.5419; 787.7205; 646.9934; 577.9209; 652.3217; 692.2734; 682.3742; 585.9152; 616.6821; 705.2702; 693.6069; 699.0121; 677.8360; 767.2373; 691.3846; 636.9876; 692.7091; 641.4865; 688.6758; 672.1664; 638.4742; 696.2705; 732.9799; 787.5137; 792.3523; 812.0548; 761.1904; 654.6039; 668.4632; 779.7376; 689.3543; 578.2208; 624.8130; 726.0673; 701.4600; 682.3236; 797.9466; 843.1803; 678.3339; 720.1146; 721.8984; 731.9449; 729.7115; 698.0271; 728.8846; 634.8264; 657.0289; 749.5451; 754.6738; 732.5309; 634.6228; 681.7561; 676.6944; 560.4745; 681.8988; 650.9226; 658.2285; 607.2369; 674.4561; 854.3257; 762.2834; 822.2276; 809.1755; 829.1837; 716.3247; 749.5890; 585.7487; 598.9587; 660.9591; 614.4795; 603.5800; 746.1840; 904.9828; 838.8075; 759.6336; 803.9423; 851.1070; 778.6611; 736.5372; 679.3208; 617.8858; 661.2371; 627.0807; 712.5649; 801.2966; 778.0360; 615.4701; 679.6414; 713.6558; 738.7771; 724.2654; 621.4029; 816.2487; 724.4426; 709.9905; 801.1206; 784.2284];

TC_Maricopa_FullFit = [532.4822; 467.1194; 447.3630; 458.0766; 508.6290; 469.9515; 439.1597; 442.2835; 440.6418; 407.7271; 505.2977; 506.1269; 523.1059; 523.8643; 500.8110; 502.7547; 508.1866; 525.5398; 446.4795; 478.4869; 411.9311; 422.9288; 464.2788; 545.0428; 510.4704; 472.7524; 446.0682; 413.2257; 470.6525; 365.9018; 414.8702; 414.1423; 443.9691; 404.2750; 417.5210; 565.5892; 569.3912; 476.7667; 428.6796; 503.6430; 488.1257; 459.6616; 438.9166; 433.0118; 470.8141; 518.1843; 500.3422; 475.2462; 550.2972; 489.1157; 466.3097; 491.8190; 478.9247; 479.2929; 479.2480; 422.4885; 429.8137; 517.8025; 641.9418; 653.7993; 657.9202; 629.9807; 519.3910; 484.0581; 591.2807; 503.6622; 433.6612; 515.6969; 562.3827; 488.9963; 423.1326; 605.7855; 590.8680; 500.3632; 492.5144; 492.2824; 490.7125; 478.0641; 461.0770; 495.0437; 445.2042; 439.3618; 543.2699; 546.6788; 483.8141; 472.7742; 478.5422; 438.4866; 378.6446; 467.9427; 465.4422; 464.9481; 504.0923; 510.0184; 700.9388; 625.3240; 605.9800; 611.5057; 605.5592; 480.7310; 526.8201; 429.6947; 451.6263; 487.8954; 394.0746; 442.8382; 578.7934; 728.9040; 610.5743; 551.5726; 591.5216; 618.1589; 587.8899; 563.1595; 488.2755; 441.6635; 431.7002; 431.8687; 477.0521; 565.4141; 561.0665; 464.7358; 457.3048; 480.1353; 550.8736; 506.1921; 441.8003; 616.8115; 526.6233; 488.8432; 620.8183; 563.5767];

TC_Pima_FullFit = [93.3632; 89.2870; 90.9779; 90.2049; 93.5113; 91.1869; 89.7428; 96.0480; 93.2586; 93.3374; 92.2676; 94.3416; 96.9439; 91.2860; 91.3146; 91.8346; 92.3405; 93.3722; 90.7157; 97.4990; 93.9169; 95.0305; 90.3651; 92.4675; 94.7753; 91.3155; 91.6352; 90.6880; 91.9848; 89.5578; 90.7983; 97.1146; 97.5251; 93.3549; 90.7246; 99.1885; 94.9452; 90.2994; 90.3800; 93.6459; 91.6134; 92.1924; 90.9412; 96.5515; 99.4847; 96.7943; 95.4070; 92.6931; 97.3490; 97.0541; 92.4580; 93.2729; 92.6375; 93.0903; 94.5478; 95.5184; 95.8553; 99.0249; 98.7474; 95.9975; 96.8898; 97.3264; 92.9157; 92.2399; 96.6499; 93.2295; 93.6665; 95.3251; 98.1266; 96.6913; 92.4395; 95.7119; 97.8024; 94.1041; 93.3913; 93.4465; 93.4356; 93.2220; 92.7215; 102.0297; 94.9294; 92.7747; 94.4954; 94.4326; 94.3700; 92.0659; 97.4146; 92.2759; 91.4090; 94.0210; 95.0178; 101.1562; 99.2501; 98.3732; 104.6427; 96.9687; 99.1274; 98.5434; 101.7699; 95.9118; 95.9001; 93.4734; 93.6238; 96.4528; 98.5258; 101.2518; 96.1487; 105.6571; 101.4851; 97.0528; 98.1406; 100.3082; 97.4882; 96.8241; 95.8057; 95.5945; 97.3515; 94.1937; 94.9416; 97.1811; 96.6483; 95.0025; 93.4816; 96.0569; 97.5444; 95.7420; 95.2143; 113.6575; 105.2972; 98.1791; 97.0592; 96.2413];

TC_Pinal_FullFit = [60.6131; 51.5795; 54.0506; 49.8915; 52.3378; 46.1171; 37.4311; 51.2520; 51.6641; 50.9492; 51.4991; 57.6107; 64.9541; 48.3996; 44.2445; 53.3649; 52.6505; 49.1566; 40.9613; 48.6566; 57.8325; 50.3677; 51.3600; 55.5090; 64.7107; 53.1251; 55.0102; 53.5577; 55.0194; 44.6916; 48.4881; 60.6721; 54.9035; 50.7364; 55.5521; 66.1819; 61.7637; 55.4202; 46.8876; 45.6248; 51.1210; 55.3296; 43.1878; 44.0499; 60.1582; 63.7141; 57.2527; 54.3328; 64.8127; 65.0964; 52.6845; 48.4910; 50.0292; 56.5374; 52.2890; 49.4449; 60.8209; 64.2944; 58.9733; 58.8853; 60.0383; 64.6875; 53.0256; 56.3583; 57.8995; 52.3333; 48.9212; 48.1084; 57.9051; 59.5573; 63.0703; 65.5885; 72.4063; 57.5139; 61.7453; 63.9985; 61.3630; 62.2670; 54.4747; 66.4819; 56.4105; 59.8213; 60.7131; 63.2612; 66.8612; 57.3859; 63.0476; 58.6139; 48.7753; 57.6884; 55.8432; 60.4977; 44.8639; 60.8793; 70.3762; 64.0847; 71.9626; 68.1873; 79.3627; 59.9760; 64.4547; 43.2561; 46.2364; 62.3707; 58.4167; 61.8777; 64.8352; 81.2555; 80.8802; 72.2174; 73.1878; 76.8246; 66.5952; 63.3511; 59.8298; 55.8110; 66.4747; 62.7039; 68.1789; 73.8278; 77.1324; 52.3602; 60.9166; 66.3603; 68.2305; 67.5831; 54.9287; 81.5362; 73.0849; 71.8720; 68.3949; 72.3254];

% from the XGBoost run output each is 132 values, months 1-132.

XGB_AZ_FullFit = [797.9424  723.9744  462.9381  342.9790  363.8817  399.9825  441.1505  437.6531  463.4830  401.8573  486.9615  673.3666  692.7798  580.2494  576.2290  558.1420  546.6942  584.4829  504.9617  339.2275  355.6116  348.1335  323.9984  342.4523  437.9328  415.1865  386.3235  441.7382  497.5242  477.1100  676.0472  724.9985  773.5062  917.7385  808.2591  807.3873  679.8155  583.4232  470.7249  568.4852  530.0898  464.9340  460.6364  483.9887  490.0255  407.8387  514.3386  595.3135  577.7423  527.6574  418.3986  428.5978  458.1871  444.6384  420.2731  514.8189  522.4791  454.9711  642.8298  948.5959  1184.1379  904.5308  593.6600  568.1890  555.8430  661.8491  616.2006  694.7419  624.7869  541.8154  617.6294  545.2289  627.9545  741.9736  652.3140  797.9099  754.2752  797.7883  822.0630  933.8485  977.0143  805.6941  901.6744  1110.7087  1055.6342  924.6743  831.6078  635.3825  490.9005  624.3476  739.0889  804.6082  1061.8527  1175.6479  1174.6284  1383.2271  1533.3474  1327.4183  1110.2809  1130.1281  870.0377  851.5826  810.0290  821.0077  805.6697  759.5786  813.0115  1006.9531  1222.0217  951.7333  688.7693  716.1558  777.0338  951.8971  914.7396  1044.8781  745.0992  623.5363  625.5674  696.5071  756.5590  705.0306  618.6031  752.3452  706.2236  746.8737  721.8265  865.1556  970.9241  925.1210  1118.5110  1331.7081]';

XGB_MARICOPA_FullFit = [564.7913  511.8490  327.8786  245.7741  257.0580  285.3785  292.1935  305.4697  318.7464  288.5005  334.1622  486.0212  454.2300  415.1905  439.7529  418.6951  378.0216  408.1699  349.9826  239.7718  228.1069  251.9408  223.5086  238.1810  319.8012  246.2065  267.2773  317.2552  352.7836  336.6596  429.5910  490.0530  554.7179  667.1189  563.7037  584.2403  506.8468  411.2906  342.3690  418.9466  375.2178  321.8351  336.8578  330.9764  371.4761  289.5736  397.2245  433.4256  400.0596  369.3893  291.8632  275.7496  310.4178  310.1792  294.3948  350.5054  365.7055  324.9919  480.0956  710.3947  907.4570  701.5234  449.8688  429.4188  422.7901  480.5240  431.3539  490.8634  450.8183  388.5622  465.3573  380.6335  460.0600  550.6057  447.8889  549.3024  512.7882  546.4262  563.6416  653.6567  675.4689  586.0891  631.2943  794.6002  750.5362  678.2991  597.8527  461.9882  312.4764  413.5397  492.5396  537.0945  724.4404  848.1266  884.6958  1040.1552  1131.2928  997.4493  803.4979  819.6203  646.5367  621.0970  603.5867  576.1646  605.1338  537.8259  633.6504  775.4055  920.9050  706.8054  516.9858  506.5746  590.2788  695.6022  673.4988  757.1973  545.7534  442.4608  430.3952  515.4840  558.7211  503.0804  440.5925  532.5560  504.3507  540.4569  505.1900  607.8171  709.7729  690.3716  836.2996  989.1280]';

XGB_PIMA_FullFit = [128.0951  116.1156  70.4040  46.0362  60.9537  71.8737  86.2710  74.4600  85.8805  72.5748  80.7885  104.8875  133.8891  83.5461  91.3547  77.4228  82.4165  81.6036  78.4765  48.8691  63.8651  53.1494  60.7036  57.4538  59.5689  94.4306  66.4841  61.0372  70.6517  75.6664  143.8469  115.0377  112.1691  145.0233  113.5897  109.0972  87.5797  80.0690  66.4390  78.7906  74.7565  78.8103  74.3188  75.1141  56.2867  68.7082  61.4884  90.1965  96.0826  83.9841  64.5076  73.5715  86.2377  69.3743  65.8738  105.3717  77.2720  58.7923  81.7761  126.0731  146.3590  92.7203  82.6887  72.4952  61.0508  83.7122  96.5646  104.4180  87.6523  74.9381  77.1627  75.0982  63.3101  85.5859  110.8041  126.2699  114.7935  116.7559  122.9089  145.8586  142.6813  99.5852  118.0414  122.9291  131.1403  101.1076  109.7950  93.9151  83.2649  101.6076  121.5873  124.5180  163.7609  142.2535  129.5932  161.8665  164.7034  138.3987  137.5507  139.5104  89.5005  109.6817  105.0858  116.4711  85.7195  80.1213  88.4911  98.9421  123.7205  95.1987  59.4441  83.2279  84.1132  111.2163  116.0300  137.1155  100.5802  84.4807  88.5808  81.5878  92.8790  103.1824  88.9188  87.1301  87.6325  99.2307  105.0117  108.8127  115.8091  94.2624  112.2984  130.6633]';

XGB_PINAL_FullFit = [54.0039  48.7422  36.3195  17.1330  19.3008  31.7871  33.1484  31.1057  35.2607  25.9528  35.0312  39.2048  60.5127  39.5358  35.7375  53.2009  44.1206  55.2025  39.9983  28.2214  34.5719  29.3767  24.8988  29.9461  35.4573  36.7140  32.5377  37.4206  45.7791  42.8348  50.0363  57.7599  66.6858  69.6394  77.3887  74.1710  56.9257  46.9872  41.0832  42.8144  57.8074  35.1416  29.0342  50.9740  30.6151  26.7643  41.6691  47.7111  48.5156  46.6050  26.6374  40.5820  40.3385  38.9454  34.0361  35.8456  45.4559  28.0261  47.4116  63.3924  85.2380  66.3720  37.2778  38.1496  46.8395  56.1608  42.6997  52.8207  39.0642  32.3507  50.1717  43.5789  63.2131  51.6713  57.2774  66.0297  56.3800  72.4863  77.1041  82.3214  80.0803  65.7835  90.8137  119.9069  117.4360  84.2929  71.7854  38.5578  45.4229  71.0458  76.2084  88.2726  100.3408  115.2161  112.2715  123.1506  159.5430  117.6086  97.7107  103.8436  77.1667  63.8010  60.5595  72.2071  62.3524  60.8075  65.9837  78.9609  132.9283  100.1123  68.6762  73.5079  69.2578  79.2412  73.4533  92.6015  53.4885  52.4575  51.4046  62.5734  70.1584  56.9307  49.6340  59.7620  51.1166  57.3200  60.2739  98.4942  93.2745  78.2938  104.7049  131.4604]';

% the four NBGLM_*_FullFit lines (108 values each, months 25-132) are NOT in
% the output you pasted here - they come from the NB-GLM script's
% 'FULL-FIT TRAJECTORY - NBGLM - <COUNTY>' printout. Re-run
% nBGLM_ValleyFever_AllRegions.m and paste those four lines the same way.

% (the 24-month lag burn-in leaves months 1-24 undefined). GLM_START = 25
% in the section handles the offset.
NBGLM_AZ_FullFit = [591.0140  572.1235  464.0705  425.5212  424.8864  432.7767  419.5445  431.4178  403.8463  464.2583  471.3649  582.7737  618.0886  591.7305  499.5444  460.4549  475.5222  518.1718  531.3213  499.2073  421.6335  432.5585  510.6269  580.6594  574.8337  519.2191  433.3699  429.0374  446.8261  464.3931  547.2897  591.7363  568.7102  534.5474  614.1476  781.7923  784.5313  729.9861  652.9455  575.7350  569.3694  558.5585  593.4527  578.4352  535.0721  538.0101  563.3911  584.5994  584.1834  539.7700  502.7897  496.4914  509.5638  539.1896  571.5193  663.7515  707.3934  760.9368  856.1952  968.8035  949.6580  844.9017  742.3629  665.5872  649.1115  646.4058  620.6313  622.5724  581.7692  496.5774  601.7985  736.0223  775.2955  688.4870  612.8385  561.8954  589.3855  633.0448  783.2587  893.3726  781.5384  825.9861  723.9290  832.1692  900.9448  841.7341  660.7220  574.4460  537.6107  609.1329  766.2343  899.9641  929.2494  946.6726  1039.1621  1203.6538  1175.3624  1099.4825  919.1678  802.4528  810.6848  783.2290  661.1672  673.7417  636.6471  684.5422  752.4736  857.4385  969.3628  980.3392  871.7503  833.2623  865.9479  917.9268  918.0792  851.9551  796.0492  797.5819  991.7584  1132.2555  1102.0904  1065.2833  876.8165  764.9808  717.7208  800.9989  965.1022  1063.9878  1023.3455  1075.7375  1144.7085  1299.0046]';

NBGLM_MARICOPA_FullFit = [345.1184  330.1673  278.0769  258.1502  266.9644  281.3405  291.3261  301.4555  287.9535  321.2889  321.6156  398.5806  444.0819  447.0670  370.1109  327.4410  323.3035  341.5235  351.6046  313.9163  260.4994  289.3891  353.2289  416.4702  441.1630  431.8981  365.8132  341.7585  332.2244  355.5862  412.2470  459.0514  440.5548  426.4636  463.5030  590.0030  576.8354  550.7712  491.9047  427.9212  408.5157  404.9428  434.7229  405.5361  388.5183  418.7075  441.6207  452.0615  441.0871  383.6929  348.4656  330.1153  330.4826  352.0179  364.3534  393.6793  423.6686  475.3871  592.0136  687.6750  698.4930  636.6889  576.5757  513.7460  499.0814  489.5730  456.7965  447.8917  447.6824  344.1230  411.2799  514.0124  558.5630  473.2800  431.7226  409.4544  424.6198  468.2836  566.4242  673.4262  567.4764  596.3665  547.1324  635.1349  704.5081  648.4632  485.0163  401.9875  378.5814  427.3184  512.4185  599.5970  625.9023  669.0997  815.4545  928.4856  917.0270  870.8815  745.9655  659.3200  656.1948  626.1592  508.9735  463.1652  447.7576  496.2630  553.3706  625.3183  689.7831  646.0181  575.1914  532.1817  540.0516  600.9685  615.3164  571.9969  567.2392  585.6341  707.5215  808.5096  813.8177  770.6874  630.9854  517.8726  493.8679  533.5692  640.2546  760.0440  757.1306  806.8486  851.3908  931.4005]';

NBGLM_PIMA_FullFit = [89.9512  82.9849  69.7599  65.1684  69.6358  73.7834  80.5627  79.3994  72.2874  72.4740  75.9160  85.6419  88.4438  88.3907  74.3458  62.5077  62.6788  72.4821  83.3808  79.9948  71.0539  71.7467  77.6292  92.6807  101.3358  96.8757  80.3890  76.3221  75.9259  86.0526  104.6428  109.5118  97.6065  94.8321  90.4158  111.0368  110.8446  112.8890  102.6479  91.7443  88.4015  94.3916  106.3571  100.5326  80.9946  78.2146  83.2065  85.0971  83.4444  84.3256  81.5672  78.2286  77.4345  80.2359  95.1766  90.1141  80.2039  83.2575  98.7130  103.6012  101.1998  89.8460  83.1597  76.8349  77.0631  77.2624  92.9150  93.8153  81.6760  70.8471  78.7262  90.1241  100.4248  91.6757  86.3740  86.9987  91.0295  102.5361  128.1944  138.7542  114.3297  97.1070  98.1647  115.0726  122.3361  119.1290  104.3301  90.7977  97.4296  108.0381  131.0660  139.0889  123.5540  121.9993  134.3486  136.7744  134.6639  127.7247  103.6664  93.6020  97.2778  96.4989  96.7504  90.6923  82.6441  83.5443  82.9660  105.9561  115.8013  110.1451  94.1138  85.3100  88.2546  108.5743  122.2886  115.1812  106.8400  99.7863  107.4944  124.7107  123.0577  117.7411  99.7971  82.4508  82.9299  87.7554  108.3418  126.5775  117.9155  112.6106  106.7651  121.0475]';

NBGLM_PINAL_FullFit = [40.0501  35.5781  29.1339  26.6296  28.2354  31.6318  32.3311  32.7994  30.7517  32.0401  35.1083  42.2581  46.4451  44.9478  35.9916  30.9883  30.8760  34.2152  36.1455  31.5428  26.2574  27.3842  33.8978  41.8177  45.6171  46.1935  40.7320  37.9050  37.3310  43.5636  51.0714  53.4749  46.7984  48.6175  55.7463  71.5365  72.0639  70.6692  62.3745  53.6555  51.1144  53.6567  57.8045  50.2401  41.0549  43.1110  47.7434  52.1372  51.5438  48.7919  44.5268  41.0770  40.7638  45.1553  46.7065  45.7422  45.1216  50.7590  65.6488  76.5037  78.6765  67.0685  57.0488  51.3991  50.4062  50.7669  52.5388  49.6843  43.6810  38.8345  48.3091  61.5158  68.5331  57.2435  52.1577  50.7359  51.7948  59.3332  72.2323  79.1996  67.1211  64.9689  65.2435  77.6524  86.1628  80.0272  65.3989  56.7286  60.0633  71.9008  88.1313  94.9042  88.6933  93.1880  107.0752  115.3542  110.1644  96.7357  74.2853  62.4043  60.9731  61.0218  50.8487  48.9010  45.2422  49.9709  62.1051  82.0911  93.9687  87.3954  74.4902  68.9207  72.1288  83.7697  89.7064  77.9961  73.4473  72.8292  82.9773  92.7988  91.8589  82.2179  66.3838  56.2757  56.8009  64.5964  83.9077  95.6155  88.5755  95.1495  103.6088  121.1993]';

switch Region
    case 1, regName='Arizona';  y_inf_data=y_inf_data_AZ;       y_pop_data=y_pop_data_AZ;
            alpha_h_b=alpha_h_AZ;       omega_b=omega_AZ;       c=c_AZ;
            TCfit=TC_AZ_FullFit;        XGfit=XGB_AZ_FullFit;   GLfit=NBGLM_AZ_FullFit;
    case 2, regName='Maricopa'; y_inf_data=y_inf_data_Maricopa; y_pop_data=y_pop_data_Maricopa;
            alpha_h_b=alpha_h_Maricopa; omega_b=omega_Maricopa; c=c_Maricopa;
            TCfit=TC_Maricopa_FullFit;  XGfit=XGB_MARICOPA_FullFit; GLfit=NBGLM_MARICOPA_FullFit;
    case 3, regName='Pima';     y_inf_data=y_inf_data_Pima;     y_pop_data=y_pop_data_Pima;
            alpha_h_b=alpha_h_Pima;     omega_b=omega_Pima;     c=c_Pima;
            TCfit=TC_Pima_FullFit;      XGfit=XGB_PIMA_FullFit; GLfit=NBGLM_PIMA_FullFit;
    case 4, regName='Pinal';    y_inf_data=y_inf_data_Pinal;    y_pop_data=y_pop_data_Pinal;
            alpha_h_b=alpha_h_Pinal;    omega_b=omega_Pinal;    c=c_Pinal;
            TCfit=TC_Pinal_FullFit;     XGfit=XGB_PINAL_FullFit; GLfit=NBGLM_PINAL_FullFit;
    otherwise, error('No Region selected');
end
county       = Region;
total_pop_t0 = y_pop_data(1);
tspan        = t_inf_data;
tMon         = t_inf_data(1:nMonths);
dMon         = y_inf_data(1:nMonths);

TCfit  = TCfit(:);
haveTC = numel(TCfit)==nMonths && all(isfinite(TCfit));
if ~haveTC
    warning('Fit:noTC','TC full fit for %s is %d long, need %d; TC curve omitted.', ...
            regName, numel(TCfit), nMonths);
end

% xGBoost: months 1-132, same window as the ODEs
XGfit  = XGfit(:);
haveXG = numel(XGfit)==nMonths && all(isfinite(XGfit));
if ~haveXG && ~isempty(XGfit)
    warning('Fit:noXG','XGBoost full fit for %s is %d long, need %d; curve omitted.', ...
            regName, numel(XGfit), nMonths);
end

% nB-GLM: full window months 1-132 (pre-sample climate feeds the early lags)
GLfit   = GLfit(:);
haveGL  = numel(GLfit)==nMonths && all(isfinite(GLfit));
if ~haveGL && ~isempty(GLfit)
    warning('Fit:noGL','NB-GLM full fit for %s is %d long, need %d; curve omitted.', ...
            regName, numel(GLfit), nMonths);
end
tMonGL = tMon;
dMonGL = dMon;

nf   = 100*(std(diff(dMon,2))/sqrt(6))/mean(dMon);
rrXG = NaN;  rrGL = NaN;
if haveXG, rrXG = 100*sqrt(mean((XGfit - dMon).^2))/mean(dMon); end
if haveGL, rrGL = 100*sqrt(mean((GLfit - dMonGL).^2))/mean(dMonGL); end

SPREAD_WARN = 0.5;

solverList = { @ode15s, 'ode15s' ; @ode23s, 'ode23s' ; ...
               @ode45,  'ode45'  ; @ode78,  'ode78'  };
nS = size(solverList,1);

MMON = cell(nM,1);  YSOL = cell(nM,1);  SOLV = cell(nM,1);
rr   = nan(nM,1);   haveM = false(nM,1);  rrAll = nan(nM,nS);
tolUsed = nan(nM,2);  matched = false(nM,1);

tDay = (t_inf_data(1):1:t_inf_data(nMonths+1))';
im   = round(t_inf_data(1:nMonths+1) - t_inf_data(1)) + 1;   % month bounds on the daily grid

fprintf('\n%s: full-sample fits, ode15s, tolerance matched to the fit run\n', regName);
fprintf('%-9s %9s %9s %11s %11s %9s\n', ...
        'model','RelTol','AbsTol','RRMSE %','target %','verdict');
fprintf('%s\n', repmat('-',1,64));

% output: per model, the configurations sorted by |RRMSE - target|, with the
% closest ten printed, plus the single lowest RRMSE found regardless of target.

SWEEP        = true;
SWEEP_MODELS = [3 4 5];
RUN_STAGE2   = false;   % set true only if stage 1 finds nothing
HIT_TOL      = 0.01;

if SWEEP
for m = SWEEP_MODELS
    p = PARAMS{m,Region};
    if isempty(p), continue; end
    p = p(:);
    tgt = TARGET_RRMSE(m, Region);

    icI = y_inf_data(1);  icR = icI/2;
    switch m
        case 1
            y0 = [p(13); p(14); total_pop_t0 - icI - icR; icI; icR];
            odef = @(t,Y) M1_SF_T(t, Y, p);
            flux = @(Y) p(7) * Y(:,3) .* Y(:,2);
        case 2
            y0 = [p(18); p(19); p(20); p(21); ...
                  total_pop_t0 - icI - p(22) - icR; p(22); icI; icR];
            odef = @(t,Y) M2_SF(t, Y, p);
            flux = @(Y) p(15) * Y(:,6);
        case 3
            y0 = [p(31); p(32); p(33); p(34); ...
                  total_pop_t0 - icI - p(35) - icR; p(35); icI; icR];
            odef = @(t,Y) M3_SF(t, Y, p, county);
            flux = @(Y) p(28) * Y(:,6);
        case 4
            y0 = [p(39); p(40); p(41); p(42); p(43); ...
                  total_pop_t0 - icI - p(44) - icR; p(44); icI; icR];
            odef = @(t,Y) M4_SF_S(t, Y, p, county);
            flux = @(Y) p(36) * Y(:,7);
        case 5
            icAH = icI;
            y0 = [p(41); p(42); p(43); p(44); p(45); ...
                  total_pop_t0 - p(46) - icAH - icI - icR; p(46); icAH; icI; icR];
            odef = @(t,Y) M5_SF(t, Y, p, county);
            flux = @(Y) p(37) * Y(:,7);
    end

    tDayS  = (t_inf_data(1):1:t_inf_data(nMonths+1))';
    imDayS = round(t_inf_data(1:nMonths+1) - t_inf_data(1)) + 1;
    tMonS  = t_inf_data(1:nMonths+1);   % 133 month boundaries
    imMonS = (1:nMonths+1)';

    solvAll = { @ode15s,'ode15s' ; @ode23s,'ode23s' ; @ode45,'ode45' ; ...
                @ode23,'ode23'   ; @ode113,'ode113' ; @ode78,'ode78' };
    tolAll  = [1e-2 1e-4 ; 1e-3 1e-6 ; 1e-4 1e-6 ; 1e-5 1e-8 ; ...
               1e-6 1e-8 ; 1e-7 1e-10];

    for stage = 1:2
        if stage == 1
            solvUse = solvAll(1,:);   % ode15s only
            tolUse  = tolAll([2 3 4 5], :);   % 1e-3 .. 1e-5
            nnUse   = [true false];
            msUse   = Inf;
        else
            if ~RUN_STAGE2, break; end
            solvUse = solvAll;
            tolUse  = tolAll;
            nnUse   = [true false];
            msUse   = [Inf 30 7 1];
        end

        nComb = size(solvUse,1)*size(tolUse,1)*numel(nnUse)*numel(msUse)*2;
        res   = nan(nComb, 6);   % [e, solverIdx, tolIdx, nn, maxstep, gridIdx]
        k = 0;  t0sweep = tic;

        for si = 1:size(solvUse,1)
        for ti = 1:size(tolUse,1)
        for ni = 1:numel(nnUse)
        for mi = 1:numel(msUse)
        for gi = 1:2
            k = k + 1;
            if gi == 1, tOut = tDayS;  idxM = imDayS;
            else,       tOut = tMonS;  idxM = imMonS;
            end
            oArgs = {'RelTol', tolUse(ti,1), 'AbsTol', tolUse(ti,2)};
            if nnUse(ni), oArgs = [oArgs, {'NonNegative', 1:numel(y0)}]; end
            if isfinite(msUse(mi)), oArgs = [oArgs, {'MaxStep', msUse(mi)}]; end
            o = odeset(oArgs{:});
            try
                [~, Y] = solvUse{si,1}(odef, tOut, y0, o);
            catch
                continue
            end
            if size(Y,1) < numel(tOut) || ~all(isfinite(Y(:,1))), continue; end
            cf = cumtrapz(tOut, flux(Y));
            mmv = diff(cf(idxM));
            if numel(mmv) < nMonths || ~all(isfinite(mmv(1:nMonths))), continue; end
            e = 100*sqrt(mean((mmv(1:nMonths) - dMon).^2))/mean(dMon);
            res(k,:) = [e, si, ti, nnUse(ni), msUse(mi), gi];
        end, end, end, end, end

        res = res(isfinite(res(:,1)), :);
        gridName = {'daily','monthly'};
        fprintf('\n=== %s / %s | stage %d | %d of %d configs solved | %.0f s ===\n', ...
                modelName{m}, regName, stage, size(res,1), nComb, toc(t0sweep));
        if isempty(res)
            fprintf('  no configuration produced a usable solution\n');  continue
        end

        [~, ord] = sort(abs(res(:,1) - tgt));
        fprintf('  target %.4f%%   |  closest configurations:\n', tgt);
        fprintf('  %9s %8s %9s %9s %8s %9s %9s\n', ...
                'RRMSE %','gap pp','solver','RelTol','NonNeg','MaxStep','grid');
        for j = 1:min(10, size(res,1))
            r = res(ord(j), :);
            fprintf('  %9.4f %8.4f %9s %9.0e %8d %9.4g %9s\n', ...
                    r(1), abs(r(1)-tgt), solvUse{r(2),2}, tolUse(r(3),1), ...
                    r(4), r(5), gridName{r(6)});
        end
        [emin, imin] = min(res(:,1));
        r = res(imin,:);
        fprintf('  lowest RRMSE anywhere in the grid: %.4f%% (%s, RelTol %.0e, NonNeg %d, MaxStep %.4g, %s)\n', ...
                emin, solvUse{r(2),2}, tolUse(r(3),1), r(4), r(5), gridName{r(6)});
        if min(abs(res(:,1) - tgt)) < HIT_TOL
            fprintf('  *** REPRODUCED the reported fit -- use the configuration above ***\n');
            break   % no need for stage 2
        else
            fprintf('  no configuration reproduced %.4f%% (closest gap %.4f pp)\n', ...
                    tgt, min(abs(res(:,1) - tgt)));
        end
    end
end
end

for m = 1:nM
    p = PARAMS{m,Region};
    if isempty(p), continue; end
    p = p(:);
    if numel(p) ~= nDimExp(m)
        warning('Fit:badLen','%s: %d parameters, expected %d. Skipped.', ...
                modelName{m}, numel(p), nDimExp(m));
        continue;
    end

    icI = y_inf_data(1);  icR = icI/2;
    switch m
        case 1
            y0   = [p(13); p(14); total_pop_t0 - icI - icR; icI; icR];
            odef = @(t,Y) M1_SF_T(t, Y, p);
            flux = @(Y) p(7) * Y(:,3) .* Y(:,2);   % epsilon*S*H
        case 2
            y0   = [p(18); p(19); p(20); p(21); ...
                    total_pop_t0 - icI - p(22) - icR; p(22); icI; icR];
            odef = @(t,Y) M2_SF(t, Y, p);
            flux = @(Y) p(15) * Y(:,6);   % psi*E
        case 3
            y0   = [p(31); p(32); p(33); p(34); ...
                    total_pop_t0 - icI - p(35) - icR; p(35); icI; icR];
            odef = @(t,Y) M3_SF(t, Y, p, county);
            flux = @(Y) p(28) * Y(:,6);   % psi*E
        case 4
            y0   = [p(39); p(40); p(41); p(42); p(43); ...
                    total_pop_t0 - icI - p(44) - icR; p(44); icI; icR];
            odef = @(t,Y) M4_SF_S(t, Y, p, county);
            flux = @(Y) p(36) * Y(:,7);   % psi*E
        case 5
            icAH = icI;
            y0   = [p(41); p(42); p(43); p(44); p(45); ...
                    total_pop_t0 - p(46) - icAH - icI - icR; p(46); icAH; icI; icR];
            odef = @(t,Y) M5_SF(t, Y, p, county);
            flux = @(Y) p(37) * Y(:,7);   % psi_I*E
    end
    if any(~isfinite(y0)) || y0(colS(m)) < 0
        warning('Fit:badY0','%s: initial conditions are invalid. Skipped.', modelName{m});
        continue;
    end

    tgt = TARGET_RRMSE(m, Region);

    bestGap = inf;  accE = NaN;  accM = [];  accY = [];  accTol = [NaN NaN];
    for it = 1:size(TOL_LIST,1)
        o = odeset('NonNegative', 1:numel(y0), ...
                   'RelTol', TOL_LIST(it,1), 'AbsTol', TOL_LIST(it,2));
        try
            [~, Y] = ode15s(odef, tDay, y0, o);
        catch
            continue;
        end
        if size(Y,1) < numel(tDay) || ~all(isfinite(Y(:,1))), continue; end
        cf = cumtrapz(tDay, flux(Y));
        mm = diff(cf(im));
        if numel(mm) < nMonths || ~all(isfinite(mm(1:nMonths))), continue; end
        e = 100*sqrt(mean((mm(1:nMonths) - dMon).^2))/mean(dMon);
            if SCAN_VERBOSE
             fprintf('      [scan] %-9s RelTol %8.0e AbsTol %8.0e -> %9.4f%%  (target %.4f)\n', ...
                    modelName{m}, TOL_LIST(it,1), TOL_LIST(it,2), e, tgt);
            end
                gap = abs(e - tgt);
% always advance to the current (tighter) tolerance, so that when no
% tolerance reproduces the target we end on the most converged solve
% rather than whichever happened to sit nearest the target.
        accE = e;  accM = mm(1:nMonths);  accY = Y;  accTol = TOL_LIST(it,:);
        bestGap = min(bestGap, gap);
        if gap < TOL_MATCH   % reproduced: accept and stop
            bestGap = gap;  break
        end
    end

    if ~isfinite(accE)
        fprintf('%-9s %9s %9s %11s %11.4f %9s\n', modelName{m}, '-','-','FAILED', tgt, '-');
        warning('Fit:allTolFailed','%s: no tolerance produced a usable solution.', modelName{m});
        continue;
    end

    MMON{m} = accM;  YSOL{m} = accY;  SOLV{m} = 'ode15s';
    rr(m) = accE;    haveM(m) = true;  tolUsed(m,:) = accTol;
    matched(m) = bestGap < TOL_MATCH;
    if matched(m), verdict = 'match'; else, verdict = 'MISMATCH'; end
    fprintf('%-9s %9.0e %9.0e %11.4f %11.4f %9s\n', ...
            modelName{m}, accTol(1), accTol(2), accE, tgt, verdict);
    if ~matched(m)
        warning('Fit:noReproduce', ...
            ['%s %s: closest reproduction is %.4f%% against a reported %.4f%% ' ...
             '(gap %.4f pp) across every tolerance tried. The reported fit is ' ...
             'NOT reproducible from this parameter vector; do not report it.'], ...
            modelName{m}, regName, accE, tgt, bestGap);
    end

    o = odeset('NonNegative', 1:numel(y0), 'RelTol', accTol(1), 'AbsTol', accTol(2));
    for s = 1:nS
        try
            [~, Y] = solverList{s,1}(odef, tDay, y0, o);
        catch, continue; end
        if size(Y,1) < numel(tDay) || ~all(isfinite(Y(:,1))), continue; end
        cf = cumtrapz(tDay, flux(Y));
        mm = diff(cf(im));
        if numel(mm) < nMonths || ~all(isfinite(mm(1:nMonths))), continue; end
        rrAll(m,s) = 100*sqrt(mean((mm(1:nMonths) - dMon).^2))/mean(dMon);
    end
end

if haveTC
    rrTC = 100*sqrt(mean((TCfit - dMon).^2))/mean(dMon);
    fprintf('%-9s %9s %9s %11.4f %11s %9s\n', 'TC base','-','-', rrTC, '-', 'least sq');
end
fprintf('%s\n', repmat('-',1,64));
fprintf('empirical noise floor: %.2f%%\n', nf);
if any(haveM & ~matched)
    fprintf(['\n*** %d of %d models did not reproduce their reported fit at any\n' ...
             '*** tolerance. Those rows must not be reported until resolved.\n'], ...
            sum(haveM & ~matched), sum(haveM));
else
    fprintf('all %d models reproduced their reported fit RRMSE\n', sum(haveM));
end

% separate counter so the outer loop index is never overwritten. Note this
% shows solver INDEPENDENCE at the accepted tolerance, which is a weaker
% statement than tolerance convergence.
for mm2 = 1:nM
    if ~haveM(mm2), continue; end
    v = rrAll(mm2, isfinite(rrAll(mm2,:)));
    if numel(v) < 2, continue; end
    spr = max(v) - min(v);
    if spr > SPREAD_WARN
        warning('Fit:solverSpread', ...
            ['%s: RRMSE varies by %.2f pp across solvers (%.2f to %.2f) at ' ...
             'RelTol %.0e. Tighten before reporting.'], ...
            modelName{mm2}, spr, min(v), max(v), tolUsed(mm2,1));
    else
        fprintf('  %-9s solver spread %.3f pp across %d solvers (solver-independent)\n', ...
                modelName{mm2}, spr, numel(v));
    end
end

if ~any(haveM) && ~haveTC
    error('Nothing pasted for %s; nothing to plot.', regName);
end

kFree = [12 20 31 38 38];   % free structural k per model, M1..M4b
                                % (matches "free params: XX of YY" in output)
ICall = cell(nM,1);
for m = 1:nM
    if ~haveM(m), continue; end
    ICall{m} = nb_ic(dMon, max(MMON{m}(:),1e-6), kFree(m), ...
                     modelName{m} + " " + regName + " [n=132, current nb_ic]");
end

if haveTC
% kTC = number of fitted regression coefficients in Eq. (TC):
% intercept + 4 covariates = 5
    ICtc = nb_ic(dMon, max(TCfit(:),1e-6), 5, ...
                 "Tamerius-Comrie " + regName + " [n=132, current nb_ic]");
end

cols = [0.90 0.60 0.00; 0.35 0.70 0.90; 0.00 0.60 0.50; 0.80 0.40 0.00; 0.00 0.00 0.00];
lw   = [11 9 7 5 3];
colTC   = [0.65 0.44 0.71];   % tamerius-Comrie, purple
colXG   = [0.80 0.36 0.36];   % XGBoost, brick
colGL   = [0.20 0.55 0.25];   % NB-GLM, green

alphaTC = 0.50;
alphaXG = 0.55;
alphaGL = 0.55;
alph    = [0.35 0.50 0.65 0.85 1.00];   % m1, M2, M3, M4a, M4b

% oDE models (SOLID lines).  Rows: M1, M2, M3, M4a, M4b
cols = [0.337 0.706 0.914;   % m1  sky blue
        0.450 0.450 0.450;   % m2  grey
        0.000 0.447 0.698;   % m3  blue
        0.835 0.369 0.000;   % m4a vermillion
        0.000 0.000 0.000];   % m4b black

% statistical baselines (DASHED lines)
colTC = [0.800 0.475 0.655];   % tamerius-Comrie, reddish purple
colXG = [0.902 0.624 0.000];   % XGBoost, orange
colGL = [0.000 0.620 0.451];   % NB-GLM, bluish green

lsODE = '-';
lsTC  = '-';    lsXG = '-';    lsGL = '-';

lw   = [1.3 1.3 4.2 3.8 3.2];   % m4b heaviest as the highlighted model
lwTC = 7;   lwXG = 5;   lwGL = 4;

alph    = [0.35 0.50 0.65 0.75 1.00];
alphaTC = 0.3;   alphaXG = 0.3;   alphaGL = 0.3;

% fIGURE 1: monthly incidence, all models against the data
figure('Position',[80 80 1250 640]);
hObs = scatter(tMon, dMon, 60, 'k', 'o', 'LineWidth', 2);  hold on
scatter(tMon, dMon, 30, 'k', 'filled', 'MarkerFaceAlpha', 0.15);

hTC = gobjects(1);
if haveTC
    hTC = plot(tMon, TCfit, '-', 'Color', [colTC alphaTC], 'LineWidth', lwTC , 'LineStyle', lsTC);
end
hXG = gobjects(1);
if haveXG
    hXG = plot(tMon, XGfit, '-', 'Color', [colXG alphaXG], 'LineWidth', lwXG,'LineStyle', lsXG );
end
hGL = gobjects(1);
if haveGL
    hGL = plot(tMonGL, GLfit, '-', 'Color', [colGL alphaGL], 'LineWidth', lwGL,'LineStyle', lsGL);
end

hM = gobjects(nM,1);
for m = 1:nM
    if ~haveM(m), continue; end
    hM(m) = plot(tMon, MMON{m}, '-', 'Color', [cols(m,:) alph(m)], 'LineWidth', lw(m));
end

hAll = hObs;  lAll = {[regName ' reported cases']};
if haveTC, hAll = [hAll; hTC];  lAll{end+1} = 'Tamerius-Comrie fit'; end
if haveXG, hAll = [hAll; hXG];  lAll{end+1} = 'XGBoost fit'; end
if haveGL, hAll = [hAll; hGL];  lAll{end+1} = 'NB-GLM fit'; end
for m = 1:nM
    if haveM(m), hAll = [hAll; hM(m)];  lAll{end+1} = [modelName{m} ' fit']; end
end
legend(hAll, lAll, 'FontSize', 13, 'Location', 'northwest');
title(['Model Fit Comparison for ' regName], 'FontSize', 30)

% subtitle built from the values actually plotted, not hardcoded
sub = '';
if haveTC, sub = [sub sprintf('TC: %.1f%%, ', rrTC)]; end
if haveXG, sub = [sub sprintf('XGBoost: %.1f%%, ', rrXG)]; end
if haveGL, sub = [sub sprintf('NB-GLM: %.1f%%, ', rrGL)]; end
for m = 1:nM
    if haveM(m), sub = [sub sprintf('%s: %.1f%%, ', modelName{m}, rr(m))]; end
end
sub = [sub sprintf(' noise floor %.1f%%', nf)];
subtitle(sub, 'FontSize', 11)
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',24);  ylabel('New cases per month','FontSize',24)
ax = gca;  ax.FontSize = 16;
ylim([0, max(dMon)*1.35]);  xlim([-20, max(t_inf_data)+20]);  grid on;  hold off
format long 
rrTC
 rrXG
 rrGL
rr(1)
rr(2)
rr(3)
rr(4)
rr(5)
nf
% fIGURE 2: Q-Q plot of relative residuals, most complex available model

pQ  = ((1:nMonths)' - 0.5) / nMonths;
thQ = norminv(pQ);

qqA = nan(nM,1);  qqR = nan(nM,1);
skA = nan(nM,1);  skR = nan(nM,1);
RA  = cell(nM,1); RR = cell(nM,1);

for m = 1:nM
    if ~haveM(m), continue; end
    a = dMon - MMON{m};
    b = (dMon - MMON{m}) ./ dMon;
    if std(a) <= 0 || std(b) <= 0, continue; end
    a = (a - mean(a))/std(a);
    b = (b - mean(b))/std(b);
    RA{m} = a;  RR{m} = b;
    qqA(m) = corr(sort(a), thQ);   skA(m) = mean(a.^3);
    qqR(m) = corr(sort(b), thQ);   skR(m) = mean(b.^3);
end

fprintf('\n%s: QQ correlation with the N(0,1) diagonal\n', regName);
fprintf('%-9s %11s %11s %9s %9s %10s\n', ...
        'model','abs QQ','rel QQ','abs skew','rel skew','favours');
fprintf('%s\n', repmat('-',1,62));
nR = 0; nT = 0;
for m = 1:nM
    if ~haveM(m), continue; end
    nT = nT + 1;
    fav = 'absolute';
    if qqR(m) > qqA(m), fav = 'relative'; nR = nR + 1; end
    fprintf('%-9s %11.4f %11.4f %9.3f %9.3f %10s\n', ...
            modelName{m}, qqA(m), qqR(m), skA(m), skR(m), fav);
end
fprintf('%s\n', repmat('-',1,62));
fprintf('relative residuals more Gaussian in %d of %d specifications\n', nR, nT);

mList = find(haveM);
nRow  = numel(mList);
if nRow > 0
    allr = [];
    for m = mList(:)', allr = [allr; RA{m}; RR{m}]; end
    lim  = ceil(max([abs(allr); abs(thQ)])) + 0.5;
    refL = [-lim lim];

    figure('Position',[60 40 760 190*nRow]);
    for k = 1:nRow
        m = mList(k);

        subplot(nRow, 2, 2*k-1)
        plot(refL, refL, '-', 'Color',[0.85 0.10 0.10], 'LineWidth', 1.5); hold on
        plot(thQ, sort(RA{m}), 'o', 'MarkerFaceColor',[0.00 0.45 0.70], ...
             'MarkerEdgeColor','none', 'MarkerSize', 4); hold off
        grid on; box on; xlim(refL); ylim(refL)
        ylabel(modelName{m}, 'FontSize', 12, 'FontWeight','bold')
        text(0.05, 0.94, sprintf('r = %.4f', qqA(m)), 'Units','normalized', ...
             'VerticalAlignment','top', 'FontSize', 10, 'BackgroundColor','w')
        if k == 1, title('Absolute residuals  d_i - m_i', 'FontSize', 13); end
        if k == nRow, xlabel('Theoretical N(0,1) quantiles','FontSize',11); end
        set(gca,'FontSize',10)

        subplot(nRow, 2, 2*k)
        plot(refL, refL, '-', 'Color',[0.85 0.10 0.10], 'LineWidth', 1.5); hold on
        plot(thQ, sort(RR{m}), 'o', 'MarkerFaceColor',[0.90 0.45 0.00], ...
             'MarkerEdgeColor','none', 'MarkerSize', 4); hold off
        grid on; box on; xlim(refL); ylim(refL)
        text(0.05, 0.94, sprintf('r = %.4f', qqR(m)), 'Units','normalized', ...
             'VerticalAlignment','top', 'FontSize', 10, 'BackgroundColor','w')
        if k == 1, title('Relative residuals  (d_i - m_i)/d_i', 'FontSize', 13); end
        if k == nRow, xlabel('Theoretical N(0,1) quantiles','FontSize',11); end
        set(gca,'FontSize',10)
    end
    sgtitle(sprintf('%s: residual structure across specifications', regName), ...
            'FontSize', 15, 'FontWeight','bold')

    annotation('textbox',[0.02 0.002 0.96 0.032], 'String', ...
        sprintf(['Relative residuals adhere more closely to the diagonal in %d of %d ' ...
                 'specifications, indicating error variance that scales with the ' ...
                 'expected count.'], nR, nT), ...
        'HorizontalAlignment','center','EdgeColor','none','FontSize',10);
end
mQ = find(haveM, 1, 'last');   
% most complex available model, for Figure 3

% fig 3: human compartments for the most complex available model
% if ~isempty(mQ) && ~isempty(YSOL{mQ})
% y = YSOL{mQ};
% if size(Y,1) == numel(tDay)
% figure('Position',[140 140 1250 620]);
% yyaxis left
% hE = gobjects(1); hA = gobjects(1);
% if ~isnan(colE(mQ))
% hE = plot(tDay, Y(:,colE(mQ)), '-', 'Color', [0.35 0.70 0.90], 'LineWidth', 4);
% hold on
% end
% hI = plot(tDay, Y(:,colI(mQ)), '-', 'Color', [0.80 0.40 0.00], 'LineWidth', 4);
% hold on
% if ~isnan(colAH(mQ))
% hA = plot(tDay, Y(:,colAH(mQ)), '-', 'Color', [0.00 0.60 0.50], 'LineWidth', 4);
% end
% hR = plot(tDay, Y(:,colR(mQ)), '-', 'Color', [0.49 0.18 0.56], 'LineWidth', 3);
% ylabel('Exposed / infected / recovered', 'FontSize', 16);
% ax = gca;  ax.YColor = [0.2 0.2 0.2];
% yyaxis right
% hS = plot(tDay, Y(:,colS(mQ)), '-', 'Color', [0 0 0], 'LineWidth', 4);
% ylabel('Susceptible', 'FontSize', 16);
% ax = gca;  ax.YColor = [0 0 0];
% hh = hI;  ll = {'Infected'};
% if ~isnan(colE(mQ)),  hh = [hE; hh];  ll = [{'Exposed'} ll]; end
% if ~isnan(colAH(mQ)), hh = [hh; hA];  ll{end+1} = 'Asymptomatic'; end
% hh = [hh; hR; hS];  ll{end+1} = 'Recovered';  ll{end+1} = 'Susceptible';
% legend(hh, ll, 'FontSize', 13, 'Location', 'best');
% title([regName ' ' modelName{mQ} ': human compartments'], 'FontSize', 20);
% xticks(0:365:365*11)
% xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
% xlabel('Year','FontSize',16);
% set(gca,'FontSize',13);  grid on;  hold off
% else
% warning('Fit:solLen','solution_y has %d rows, expected %d; compartment figure skipped.', ...
% size(Y,1), numel(tDay));
% end
% end

fprintf('\n%s full-sample fit, RRMSE on monthly integrated incidence\n', regName);
fprintf('%-9s %10s %12s %-24s\n','model','RRMSE %','x floor','solver');
fprintf('%s\n', repmat('-',1,60));
if haveTC
    fprintf('%-9s %10.2f %12.2f %-24s\n', 'TC base', rrTC, rrTC/nf, 'least squares');
end
for m = 1:nM
    if haveM(m)
        fprintf('%-9s %10.2f %12.2f %-24s\n', modelName{m}, rr(m), rr(m)/nf, SOLV{m});
    end
end
fprintf('%s\n', repmat('-',1,60));
fprintf('noise floor %.2f%%. "x floor" is RRMSE divided by that floor, so 1.00\n', nf);
fprintf('means the fit is at the irreducible limit of the surveillance series.\n');
save("fit_compare_" + regName + ".mat", 'regName','modelName','rr','nf','SOLV','MMON','dMon','tMon');

elseif choose_model==10
% pLOTTING THE FORECASTS: all five mechanistic models plus Tamerius-Comrie
% rEBUILT. What changed and why:
% 1. PLOTS MONTHLY INTEGRATED INCIDENCE, NOT THE I COMPARTMENT. The previous
% version plotted ypswarm_fit8(:,4), (:,7), (:,8) and (:,9) -- the I
% sTOCK. The models are fitted to the integral of the incidence flux over
% each calendar month, so the plotted curve was a different quantity from
% the one that was fitted, and a smoothed one at that: at a 90-day sojourn
% the stock filters out about 80% of month-to-month variation, which is
% why those curves looked so much better than the fits actually were.
% every trajectory now comes from the model's own objective function,
% which returns model_mon.
% 2. THE SOLVER LOOKUP WAS DEAD CODE. best_solver_name was hardcoded to
% 'ode15s (standard tol)', so the loop over solverChain always matched
% entry 1 and the other five were unreachable. Calling the objective runs
% the real chain with the same 30 s timeout the fit used and REPORTS which
% solver succeeded, which is printed below. Nothing is hardcoded.
% 3. THREE WRONG PARAMETER VECTORS. Model 3 horizon 2 used params_m3_10
% instead of params_m3_9; Model 4a horizon 1 used params_m4_10 instead of
% params_m4_8. So two of the fifteen curves were the wrong fit.
% 5. The five 'otherwise' branches printed final_solver_name with no digit,
% which is undefined and would error at exactly the moment you needed the
% diagnostic.
% 6. REGION-SPECIFIC LABELS WERE HARDCODED TO PIMA. The region switch set the
% data, but the plots used Pima_Forecast_Plot_* and titled themselves
% 'Pima County' regardless of Region, so running Maricopa silently drew
% pima's TC forecast on Maricopa's data. All labels now derive from
% regName and the TC series is selected by region.
% 7. loose_options_final was defined five times and never used. It also set
% maxStep 1e-3, which over a 4017-day span forces 4 million steps.
% 8. The two figures repeated fifteen near-identical plot blocks each. The
% curves are now drawn in a loop over models and horizons.
disp('Plotting forecasts')
format short

global alpha_h_Maricopa omega_Maricopa c_Maricopa alpha_h_Pinal omega_Pinal c_Pinal alpha_h_Pima omega_Pima c_Pima alpha_h_AZ omega_AZ c_AZ
omega_vital = 0.021/365;
alpha_h_Maricopa = 0.000500942192598 + omega_vital; omega_Maricopa = omega_vital; c_Maricopa = 0.000500942192598/4724819.974562017247081;
alpha_h_Pinal    = 0.000076238824090 + omega_vital; omega_Pinal    = omega_vital; c_Pinal    = 0.000076238824090/5162630.000;
alpha_h_Pima     = 0.000019432499300 + omega_vital; omega_Pima     = omega_vital; c_Pima     = 0.000019432499300/10639930.00;
alpha_h_AZ       = 0.000304888503016 + omega_vital; omega_AZ       = omega_vital; c_AZ       = 0.000304888503016/7853513.125630123540759;

nFitList  = [96 108 120];
yrLabel   = {'2021','2022','2023'};
modelName = {'Model 1','Model 2','Model 3','Model 4a','Model 4b'};
nM = 5;
% expected parameter-vector lengths. Model 4b is 46 because LB(47)/UB(47) are
% left commented out in its bounds block; change to 47 if you pin that index.
nDimExp = [14 22 35 44 46];

% pASTE THE FITTED PARAMETER VECTORS HERE
% pARAMS{model, region} = { 8yr ; 9yr ; 10yr }
% region 1 = AZ, 2 = Maricopa, 3 = Pima, 4 = Pinal
% copy params_mXpswarm_8 / _9 / _10 straight from each node's output.
% leave any entry [] and that model is skipped for that region.
PARAMS = cell(nM,4);

% each cell is a 3x1 cell array of the REFIT vectors, one per horizon:
% h1 = trained 2013-2020, forecasts 2021   (params_mXpswarm_8)
% h2 = trained 2013-2021, forecasts 2022   (params_mXpswarm_9)
% h3 = trained 2013-2022, forecasts 2023   (params_mXpswarm_10)
% the _8/_9/_10 suffixes in the run logs are training-window lengths in years.
% fit on the training window, not the forecast error: it equals the swarm
% objective x 100 and exists to confirm the pasted vector reproduces the fit.
% held-out forecast error is the FORECAST column of the run tables, recorded
% below as a comment on each cell for cross-checking.
% sTATUS: Models 1-3 complete for all four regions. Model 4b Maricopa only.
% model 4a not yet run for any region. Empty cells are skipped downstream.

PARAMS{1,1} = { [] ; [] ; [] };   % m1 (14)
PARAMS{1,2} = { [] ; [] ; [] };   % m1 (14)
PARAMS{1,3} = { [] ; [] ; [] };   % m1 (14)
PARAMS{1,4} = { [] ; [] ; [] };   % m1 (14)

PARAMS{2,1} = { [] ; [] ; [] };   % m2 (22)
PARAMS{2,2} = { [] ; [] ; [] };   % m2 (22)
PARAMS{2,3} = { [] ; [] ; [] };   % m2 (22)
PARAMS{2,4} = { [] ; [] ; [] };   % m2 (22)

PARAMS{3,1} = { [] ; [] ; [] };   % m3 (35)
PARAMS{3,2} = { [] ; [] ; [] };   % m3 (35)
PARAMS{3,3} = { [] ; [] ; [] };   % m3 (35)
PARAMS{3,4} = { [] ; [] ; [] };   % m3 (35)

PARAMS{4,1} = { [] ; [] ; [] };   % m4a (44)
PARAMS{4,2} = { [] ; [] ; [] };   % m4a (44)
PARAMS{4,3} = { [] ; [] ; [] };   % m4a (44)
PARAMS{4,4} = { [] ; [] ; [] };   % m4a (44)

PARAMS{5,1} = { [] ; [] ; [] };   % m4b (46)
PARAMS{5,2} = { [] ; [] ; [] };   % m4b (46)
PARAMS{5,3} = { [] ; [] ; [] };   % m4b (46)
PARAMS{5,4} = { [] ; [] ; [] };   % m4b (46)

nExpect = [14 22 35 44 46];
nReady  = 0;
for mm = 1:5
    for rr = 1:4
        cellHR = PARAMS{mm,rr};
        if numel(cellHR) ~= 3
            error('PARAMS:shape','PARAMS{%d,%d} must hold 3 horizons, has %d', ...
                  mm, rr, numel(cellHR));
        end
        nGot = 0;
        for hh = 1:3
            v = cellHR{hh};
            if isempty(v), continue; end
            if numel(v) ~= nExpect(mm)
                error('PARAMS:len', ...
                      'PARAMS{%d,%d}{%d} has %d entries, expected %d', ...
                      mm, rr, hh, numel(v), nExpect(mm));
            end
            nGot = nGot + 1;
        end
        if nGot > 0 && nGot < 3
            warning('PARAMS:partial', ...
                    'PARAMS{%d,%d} has %d of 3 horizons; that cell will be skipped', ...
                    mm, rr, nGot);
        elseif nGot == 3
            nReady = nReady + 1;
        end
    end
end
fprintf('PARAMS: %d of 20 model-region cells have all three horizons\n', nReady);

% pASTE THE TAMERIUS-COMRIE FORECASTS HERE
% tHIRTEEN values per year: the first is the TRANSITION month (the last
% month of that fit window) so the line joins the fit, then the 12 forecast
% months. This matches the *_Forecast_Plot_* vectors you already have.
TC_AZ_2021 = [707.5104; 737.2373; 733.9080; 750.9479; 658.8718; 675.1611; 563.6294; 565.6346; 599.1101; 558.9227; 567.5328; 680.7445; 824.9367];
TC_AZ_2022 = [908.4276; 819.5085; 736.6732; 790.6021; 837.6447; 743.3576; 693.0547; 620.4095; 573.5439; 595.8047; 566.4448; 658.8287; 767.2971];
TC_AZ_2023 = [781.9093; 758.6741; 630.5566; 679.5883; 703.2214; 725.1679; 700.6664; 613.6168; 797.5111; 702.2744; 690.3678; 781.6884; 763.2257];

TC_Maricopa_2021 = [565.0907; 548.5036; 554.7399; 557.3126; 428.3653; 480.2193; 379.6675; 407.5240; 449.0779; 359.1002; 404.3420; 525.0564; 671.4363];
TC_Maricopa_2022 = [724.6351; 599.2606; 530.2629; 584.3016; 613.0064; 555.7155; 527.3416; 451.1276; 410.8944; 393.8711; 394.5529; 444.2505; 541.2429];
TC_Maricopa_2023 = [553.8612; 551.1149; 473.5029; 463.3333; 474.6553; 539.6458; 492.3527; 440.6241; 599.8478; 513.6198; 476.1020; 605.0966; 550.7576];

TC_Pima_2021 = [95.0597; 97.0932; 94.7931; 96.2102; 90.5458; 95.0764; 88.7555; 90.7834; 95.5735; 96.8089; 97.9194; 95.1658; 102.7506];
TC_Pima_2022 = [108.0345; 104.0081; 98.6287; 99.9073; 101.8449; 97.3830; 95.5852; 93.0267; 92.2272; 95.1189; 91.3467; 93.9072; 98.6093];
TC_Pima_2023 = [96.4506; 95.7274; 95.2367; 93.1071; 95.2706; 97.0378; 94.7545; 94.4359; 114.9199; 105.3301; 97.4491; 96.3992; 95.2962];

TC_Pinal_2021 = [59.6547; 63.4995; 59.8326; 65.4443; 54.6446; 60.6737; 44.0501; 48.1776; 59.0723; 56.3596; 56.6211; 61.4767; 68.2531];
TC_Pinal_2022 = [75.4466; 76.7341; 70.8362; 71.2748; 73.5138; 65.3073; 62.0864; 58.5096; 54.8137; 63.9513; 61.2581; 66.7516; 72.4096];
TC_Pinal_2023 = [73.5401; 77.0145; 55.1673; 62.7127; 67.1860; 67.7313; 66.6701; 54.9977; 76.1307; 69.9924; 69.6143; 67.1935; 71.8966];

XGB_AZ_2021 = [1012.9443; 868.8881; 772.1630; 682.2053; 597.4088; 578.2216; 688.7863; 694.1551; 685.7263; 636.1924; 574.0775; 648.1558];
XGB_AZ_2022 = [1196.9231; 1213.4247; 1179.7246; 1209.5599; 1125.0896; 1145.2573; 1122.2458; 1085.6937; 1120.8518; 1088.5477; 1124.7803; 1265.1228];
XGB_AZ_2023 = [761.5176; 799.0724; 734.4827; 686.5269; 691.4819; 632.9226; 728.5461; 857.0472; 905.9446; 859.0927; 885.4941; 952.8561];

XGB_Maricopa_2021 = [740.3182; 650.5286; 602.1549; 519.3777; 475.3572; 566.8234; 533.3378; 477.6929; 494.9686; 484.2459; 484.6469; 592.6965];
XGB_Maricopa_2022 = [948.6762; 902.4980; 898.0259; 835.5712; 838.0183; 851.3199; 794.9159; 785.8469; 813.7142; 769.0352; 787.8491; 953.0441];
XGB_Maricopa_2023 = [593.2013; 587.2902; 483.3821; 443.7912; 450.4017; 463.1648; 474.0211; 560.5059; 706.4294; 669.9343; 666.9277; 786.3369];

XGB_Pima_2021 = [127.9822; 98.8230; 92.6440; 88.3221; 90.4304; 94.8163; 92.8638; 103.8414; 111.6494; 115.9360; 112.6675; 130.7268];
XGB_Pima_2022 = [124.5578; 122.4502; 114.2284; 113.2338; 129.4280; 125.3993; 120.2814; 114.1357; 102.6377; 100.1575; 104.9393; 118.7614];
XGB_Pima_2023 = [77.7498; 83.3453; 85.8745; 85.2378; 89.8031; 93.6885; 98.7393; 96.0900; 102.4253; 113.2496; 104.9972; 120.2010];

XGB_Pinal_2021 = [115.1649; 87.2110; 65.0125; 47.4911; 57.2558; 65.1472; 82.6616; 72.3651; 75.2776; 78.0412; 80.7718; 87.1311];
XGB_Pinal_2022 = [95.4569; 117.5786; 90.9482; 81.4363; 65.3827; 77.1383; 68.8730; 75.0258; 77.3956; 73.6375; 74.9039; 81.3741];
XGB_Pinal_2023 = [71.2722; 70.1592; 53.4693; 41.2032; 47.8371; 53.3493; 62.0681; 72.0617; 73.0028; 74.5599; 73.4514; 76.9563];

GLM_AZ_2021 = [1119.7727; 1034.5261; 916.2183; 802.9698; 811.3395; 790.5415; 666.4485; 672.0680; 622.6886; 707.3744; 772.8118; 938.3738];
GLM_AZ_2022 = [1192.2356; 1255.7494; 1154.6616; 1164.1739; 1247.2425; 1357.2060; 1367.1489; 1260.0566; 1126.9384; 1114.0660; 1432.9687; 1614.6581];
GLM_AZ_2023 = [1274.4663; 1270.8791; 1064.4274; 897.2202; 842.0070; 950.3577; 1151.4745; 1269.9516; 1185.3570; 1206.6453; 1234.9138; 1436.4204];
GLM_Maricopa_2021 = [973.5853; 922.0611; 886.7263; 762.2752; 751.1497; 636.3773; 474.8932; 429.7455; 401.0205; 502.7222; 494.4550; 562.4570];
GLM_Maricopa_2022 = [722.8934; 689.2448; 623.9347; 589.0941; 610.7162; 682.9015; 702.4848; 680.9384; 677.4514; 715.6797; 960.9637; 1110.4833];
GLM_Maricopa_2023 = [954.9169; 937.0922; 779.4092; 610.3436; 576.7877; 633.2114; 773.4358; 939.2692; 916.3141; 947.4523; 951.6297; 1060.2031];
GLM_Pima_2021 = [115.2879; 104.7189; 82.2152; 72.0385; 72.6508; 72.6823; 62.4117; 63.7901; 70.2940; 83.5888; 101.3713; 134.1782];
GLM_Pima_2022 = [138.5042; 137.8598; 120.0654; 109.2966; 113.2430; 136.6040; 152.9987; 142.5068; 129.4835; 120.2845; 136.3476; 159.4900];
GLM_Pima_2023 = [129.8210; 126.1466; 106.7150; 85.8349; 85.4827; 90.0777; 114.0429; 137.2336; 127.4020; 120.2240; 111.1697; 127.1574];
GLM_Pinal_2021 = [83.3972; 64.8623; 54.7477; 46.2195; 45.2192; 48.3871; 36.6884; 34.8297; 31.5764; 39.7635; 52.0440; 72.9865];
GLM_Pinal_2022 = [97.3183; 92.9860; 82.9946; 82.9309; 95.2252; 116.2642; 129.8334; 116.2848; 104.7892; 104.1812; 129.2321; 140.6618];
GLM_Pinal_2023 = [105.6885; 97.2668; 80.8577; 67.5562; 68.6519; 78.9200; 101.4800; 111.2793; 99.2661; 102.8615; 109.0651; 131.0173];

switch Region
    case 1, regName='Arizona';  y_inf_data=y_inf_data_AZ;       y_pop_data=y_pop_data_AZ;
            alpha_h_b=alpha_h_AZ;       omega_b=omega_AZ;       c=c_AZ;
            TCP={TC_AZ_2021,TC_AZ_2022,TC_AZ_2023};
            XGP={XGB_AZ_2021,XGB_AZ_2022,XGB_AZ_2023};
            GLP={GLM_AZ_2021,GLM_AZ_2022,GLM_AZ_2023};
    case 2, regName='Maricopa'; y_inf_data=y_inf_data_Maricopa; y_pop_data=y_pop_data_Maricopa;
            alpha_h_b=alpha_h_Maricopa; omega_b=omega_Maricopa; c=c_Maricopa;
            TCP={TC_Maricopa_2021,TC_Maricopa_2022,TC_Maricopa_2023};
            XGP={XGB_Maricopa_2021,XGB_Maricopa_2022,XGB_Maricopa_2023};
            GLP={GLM_Maricopa_2021,GLM_Maricopa_2022,GLM_Maricopa_2023};
    case 3, regName='Pima';     y_inf_data=y_inf_data_Pima;     y_pop_data=y_pop_data_Pima;
            alpha_h_b=alpha_h_Pima;     omega_b=omega_Pima;     c=c_Pima;
            TCP={TC_Pima_2021,TC_Pima_2022,TC_Pima_2023};
            XGP={XGB_Pima_2021,XGB_Pima_2022,XGB_Pima_2023};
            GLP={GLM_Pima_2021,GLM_Pima_2022,GLM_Pima_2023};
    case 4, regName='Pinal';    y_inf_data=y_inf_data_Pinal;    y_pop_data=y_pop_data_Pinal;
            alpha_h_b=alpha_h_Pinal;    omega_b=omega_Pinal;    c=c_Pinal;
            TCP={TC_Pinal_2021,TC_Pinal_2022,TC_Pinal_2023};
            XGP={XGB_Pinal_2021,XGB_Pinal_2022,XGB_Pinal_2023};
            GLP={GLM_Pinal_2021,GLM_Pinal_2022,GLM_Pinal_2023};
    otherwise, error('No Region selected');
end
county       = Region;
total_pop_t0 = y_pop_data(1);
nMonths      = 132;

haveTC = all(cellfun(@(v) numel(v)==13 && all(isfinite(v)), TCP));
if ~haveTC
    warning('Plot:noTC','TC forecasts for %s are missing or not 13 long; TC curve omitted.', regName);
end
% xGBoost and NB-GLM vectors are 12 long: forecast months only.
haveXG = all(cellfun(@(v) numel(v)==12 && all(isfinite(v)), XGP));
if ~haveXG
    warning('Plot:noXG','XGBoost forecasts for %s are missing or not 12 long; curve omitted.', regName);
end
haveGL = all(cellfun(@(v) numel(v)==12 && all(isfinite(v)), GLP));
if ~haveGL
    warning('Plot:noGL','NB-GLM forecasts for %s are missing or not 12 long; curve omitted.', regName);
end

% forecast RRMSE of each baseline, per year, for the subtitle
fcRTC = nan(1,3);  fcRXG = nan(1,3);  fcRGL = nan(1,3);
for h = 1:3
    nF  = nFitList(h);
    obs = y_inf_data(nF+1:nF+12);
    if haveTC, v=TCP{h}(:); fcRTC(h) = 100*sqrt(mean((v(2:13)-obs).^2))/mean(obs); end
    if haveXG, v=XGP{h}(:); fcRXG(h) = 100*sqrt(mean((v      -obs).^2))/mean(obs); end
    if haveGL, v=GLP{h}(:); fcRGL(h) = 100*sqrt(mean((v      -obs).^2))/mean(obs); end
end
fprintf('\n%s baseline forecast RRMSE (%%): 2021 / 2022 / 2023\n', regName);
if haveTC, fprintf('  Tamerius-Comrie : %6.2f %6.2f %6.2f\n', fcRTC); end
if haveXG, fprintf('  XGBoost         : %6.2f %6.2f %6.2f\n', fcRXG); end
if haveGL, fprintf('  NB-GLM          : %6.2f %6.2f %6.2f\n', fcRGL); end

% the objective returns model_mon: the integral of the incidence flux over
% each calendar month, on a daily grid. It also runs the real solver chain
% and reports which one succeeded, so nothing about the solver is hardcoded.
MMON = cell(nM,3);   % monthly incidence, nF+12 long
SOLV = cell(nM,3);
fcR  = nan(nM,3);   % forecast RRMSE, for the subtitle
haveM = false(nM,1);

fprintf('\n%s: re-solving each model through its objective\n', regName);
fprintf('%-9s %-6s %-24s %10s %10s\n','model','horiz','solver','in-samp %','FORECAST %');
fprintf('%s\n', repmat('-',1,64));

for m = 1:nM
    pc = PARAMS{m,Region};
    if isempty(pc) || all(cellfun(@isempty,pc)), continue; end
    ok = true;
    for h = 1:3
        p = pc{h};
        if isempty(p), ok = false; break; end
        p = p(:);
        if numel(p) ~= nDimExp(m)
            warning('Plot:badLen','%s h=%d: %d parameters, expected %d. Model skipped.', ...
                    modelName{m}, h, numel(p), nDimExp(m));
            ok = false; break;
        end
        nF  = nFitList(h);
        t_m = t_inf_data(1:nF+13);
        yd  = y_inf_data(1:nF+13);
        switch m
            case 1, [~,~,sv,mmon] = objective_functionM1(  p, t_m, total_pop_t0, yd);
            case 2, [~,~,sv,mmon] = objective_functionM2(  p, t_m, total_pop_t0, yd);
            case 3, [~,~,sv,mmon] = objective_functionM3(  p, t_m, total_pop_t0, yd, county);
            case 4, [~,~,sv,mmon] = objective_functionM4_S(p, t_m, total_pop_t0, yd, county);
            case 5, [~,~,sv,mmon] = objective_functionM5(  p, t_m, total_pop_t0, yd, county);
        end
        if isempty(mmon) || numel(mmon) < nF+12 || ~all(isfinite(mmon(1:nF+12)))
            warning('Plot:solveFailed','%s h=%d: all solvers failed (%s). Model skipped.', ...
                    modelName{m}, h, sv);
            ok = false; break;
        end
        MMON{m,h} = mmon(1:nF+12);  SOLV{m,h} = sv;
        dFit = y_inf_data(1:nF);          rFit = mmon(1:nF)       - dFit;
        dFc  = y_inf_data(nF+1:nF+12);    rFc  = mmon(nF+1:nF+12) - dFc;
        fcR(m,h) = 100*sqrt(mean(rFc.^2))/mean(dFc);
        fprintf('%-9s %-6s %-24s %10.2f %10.2f\n', modelName{m}, yrLabel{h}, sv, ...
                100*sqrt(mean(rFit.^2))/mean(dFit), fcR(m,h));
    end
    haveM(m) = ok;
end
fprintf('%s\n', repmat('-',1,64));
if ~any(haveM), error('No parameter vectors pasted for %s; nothing to plot.', regName); end

% one entry per series that was actually plotted: mechanistic models first,
% then the statistical baselines. Each triple is the HELD-OUT forecast RRMSE
% for 2021 / 2022 / 2023 in percent. Skipped models never appear, so the
% subtitle can never claim a curve the figure does not show.
rrParts = {};
for m = 1:nM
    if haveM(m)
        rrParts{end+1} = sprintf('%s %.1f/%.1f/%.1f', modelName{m}, fcR(m,1), fcR(m,2), fcR(m,3));
    end
end
if haveTC, rrParts{end+1} = sprintf('TC %.1f/%.1f/%.1f',      fcRTC); end
if haveXG, rrParts{end+1} = sprintf('XGBoost %.1f/%.1f/%.1f', fcRXG); end
if haveGL, rrParts{end+1} = sprintf('NB-GLM %.1f/%.1f/%.1f',  fcRGL); end

rrHead = 'forecast RRMSE % (2021/2022/2023):   ';
if numel(rrParts) > 4   % wrap onto two lines when long
    nHalf   = floor(numel(rrParts)/2);   % header line gets the fewer entries
    rrLines = {[rrHead strjoin(rrParts(1:nHalf), '    ')], ...
               strjoin(rrParts(nHalf+1:end), '    ')};
else
    rrLines = {[rrHead strjoin(rrParts, '    ')]};
end
rrFS = 11;   % subtitle font, smaller than title

% colours are copied verbatim from the ACTIVE palette in choose_model==9,
% i.e. the Okabe-Ito block that overwrites the older orange/sky/teal one
% further up that section, so a model is the same colour in the fitting and
% the forecasting figures. Line widths are NOT copied: section 9 uses
% print-scale widths, while these figures rely on thick-under-thin layering
% to keep all fifteen curves visible, so [10 9 7 5 3] stays.
cols = [0.337 0.706 0.914;   % m1  sky blue
        0.450 0.450 0.450;   % m2  grey
        0.000 0.447 0.698;   % m3  blue
        0.835 0.369 0.000;   % m4a vermillion
        0.000 0.000 0.000];   % m4b black
lw     = [10 9 7 5 3];
colTC  = [0.800 0.475 0.655];   % tamerius-Comrie, reddish purple
colXG  = [0.902 0.624 0.000];  lwXG = 7;   % XGBoost, orange
colGL  = [0.000 0.620 0.451];  lwGL = 7;   % NB-GLM, bluish green
lwTC   = 9;
tCut   = [t_inf_data(97) t_inf_data(109) t_inf_data(121)];

% fIGURE 1: single panel, full eleven years
figure('Position',[80 80 1250 640]);
hObs = scatter(t_inf_data(1:nMonths), y_inf_data(1:nMonths), 60, 'k', 'o', 'LineWidth', 2);
hold on
scatter(t_inf_data(1:nMonths), y_inf_data(1:nMonths), 30, 'k', 'filled', 'MarkerFaceAlpha', 0.1);

% faint in-sample portions
for m = 1:nM
    if ~haveM(m), continue; end
    for h = 1:3
        nF = nFitList(h);
        plot(t_inf_data(1:nF), MMON{m,h}(1:nF), '-', ...
             'Color', [cols(m,:) 0.05], 'LineWidth', lw(m));
    end
end

% statistical baselines, drawn under the mechanistic models
hTC = gobjects(1);
if haveTC
    for h = 1:3
        nF = nFitList(h);
% tCP is 13 long; element 1 is the last FITTED month. Drop it so the
% drawn segment is exactly the 12 forecast months, like every other
% model. (The RRMSE below already used elements 2:13.)
        vTC = TCP{h}(:);
        hh = plot(t_inf_data(nF+1:nF+12), vTC(2:13), '-', ...
                  'Color', [colTC 0.6], 'LineWidth', lwTC);
        if h==1, hTC = hh; end
    end
end
hXG = gobjects(1);
if haveXG
    for h = 1:3
        nF = nFitList(h);
% 12 values -> months nF+1 : nF+12 (no transition month, unlike TC)
        hh = plot(t_inf_data(nF+1:nF+12), XGP{h}(:), '-', ...
                  'Color', [colXG 0.6], 'LineWidth', lwXG);
        if h==1, hXG = hh; end
    end
end
hGL = gobjects(1);
if haveGL
    for h = 1:3
        nF = nFitList(h);
        hh = plot(t_inf_data(nF+1:nF+12), GLP{h}(:), '-', ...
                  'Color', [colGL 0.6], 'LineWidth', lwGL);
        if h==1, hGL = hh; end
    end
end

% bold forecast portions: exactly the 12 held-out months, nF+1:nF+12. The
% transition-month join (nF:nF+12) was dropped so every model's segment
% covers the same window on screen -- XGBoost and NB-GLM never had it.
hM = gobjects(nM,1);
for m = 1:nM
    if ~haveM(m), continue; end
    for h = 1:3
        nF = nFitList(h);
        hh = plot(t_inf_data(nF+1:nF+12), MMON{m,h}(nF+1:nF+12), '-', ...
                  'Color', [cols(m,:) 0.75], 'LineWidth', lw(m));
        if h==1, hM(m) = hh; end
    end
end
for k = 1:3, xline(tCut(k), 'k', 'LineWidth', 2); end

hAll = hObs;  lAll = {[regName ' reported cases']};
if haveTC, hAll = [hAll; hTC]; lAll{end+1} = 'Tamerius/Comrie forecast'; end
if haveXG, hAll = [hAll; hXG]; lAll{end+1} = 'XGBoost forecast'; end
if haveGL, hAll = [hAll; hGL]; lAll{end+1} = 'NB-GLM forecast'; end
for m = 1:nM
    if haveM(m), hAll = [hAll; hM(m)]; lAll{end+1} = [modelName{m} ' forecast']; end
end
legend(hAll, lAll, 'FontSize', 12, 'Location', 'northwest');
title(['Comparing Model Forecasts of ' regName ' Valley Fever'], 'FontSize', 24)
subtitle(rrLines, 'FontSize', rrFS, 'FontWeight', 'normal')
xticks(0:365:365*11)
xticklabels({'2013','2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'})
xlabel('Year','FontSize',18);  ylabel('New cases per month','FontSize',18)
ax = gca;  ax.FontSize = 14;

% fitting-period brackets, in DATA units so they survive a resize.
% they now live in a blank strip BELOW the data rather than over the top of
% it: yBase extends the y-axis under zero, and the negative tick labels are
% stripped so the strip reads as margin. The bracket geometry (0.06*yTop
% between levels, label 0.026*yTop above its own line) is unchanged, so the
% spacing that kept the three labels legible at the top still holds.
yTop  = max(y_inf_data)*1.25;
yBase = -0.25*yTop;
yLev  = yTop*[-0.09 -0.15 -0.21];   % 2021 uppermost, 2023 lowest, as before
tickH = yTop*0.012;

ylim([yBase, yTop]);  xlim([-20, max(t_inf_data)+20]);  grid on
ax.YTick = ax.YTick(ax.YTick >= 0);

for k = 1:3
    plot([0 tCut(k)], [yLev(k) yLev(k)], 'k-', 'LineWidth', 2.5);
    plot([0 0],             yLev(k)+[-tickH tickH], 'k-', 'LineWidth', 2.5);
    plot([tCut(k) tCut(k)], yLev(k)+[-tickH tickH], 'k-', 'LineWidth', 2.5);
    text(tCut(k)/2, yLev(k)+tickH*2.2, [yrLabel{k} ' forecast fitting period'], ...
         'HorizontalAlignment','center','FontSize',12);
end
hold off

% fIGURES 2 AND 3: split axis, 2013-2020 condensed and 2021-2023 expanded.
% figure 2 carries every model that solved. Figure 3 is the same figure
% with Models 1 and 2 dropped, so the thinner Model 3 / 4a / 4b lines are
% not buried under the ten- and nine-point ones. Both are drawn from this
% single block so the two cannot drift apart when either is edited.
% region name for the title: Arizona is a state, the other three are
% counties, so 'County' is appended to everything except Arizona.
regTitle = regName;
if ~strcmpi(regName, 'Arizona'), regTitle = [regName ' County']; end
figSets = {1:nM, 3:nM};   % fig 2: all models.  Fig 3: M3, M4a, M4b only.

for f = 1:numel(figSets)
    showM = haveM(:).' & ismember(1:nM, figSets{f});   % solved AND wanted here
    if ~any(showM)
        warning('Plot:noModels','Figure %d has no models to draw; skipped.', f+1);
        continue
    end

    fh  = figure('Position',[100 100 1300 640]);
    tl  = tiledlayout(1, 2, 'TileSpacing', 'none', 'Padding', 'compact');
    ax1 = nexttile;  ax2 = nexttile;

    for a = [ax1 ax2]
        hold(a,'on');
        hO = scatter(a, t_inf_data(1:nMonths), y_inf_data(1:nMonths), 60, 'k', 'o', 'LineWidth', 2);
        scatter(a, t_inf_data(1:nMonths), y_inf_data(1:nMonths), 30, 'k', 'filled', 'MarkerFaceAlpha', 0.1);

% faint in-sample portions
        for m = 1:nM
            if ~showM(m), continue; end
            for h = 1:3
                nF = nFitList(h);
                plot(a, t_inf_data(1:nF), MMON{m,h}(1:nF), '-', ...
                     'Color', [cols(m,:) 0.05], 'LineWidth', lw(m));
            end
        end

        hT = gobjects(1);  hX = gobjects(1);  hG = gobjects(1);
        if haveTC
            for h = 1:3
                nF = nFitList(h);
                vTC = TCP{h}(:);   % drop element 1 (last fitted month)
                hh = plot(a, t_inf_data(nF+1:nF+12), vTC(2:13), '-', ...
                          'Color', [colTC 0.6], 'LineWidth', lwTC);
                if h==1, hT = hh; end
            end
        end
        if haveXG
            for h = 1:3
                nF = nFitList(h);
                hhX = plot(a, t_inf_data(nF+1:nF+12), XGP{h}(:), '-', ...
                           'Color', [colXG 0.6], 'LineWidth', lwXG);
                if h==1, hX = hhX; end
            end
        end
        if haveGL
            for h = 1:3
                nF = nFitList(h);
                hhG = plot(a, t_inf_data(nF+1:nF+12), GLP{h}(:), '-', ...
                           'Color', [colGL 0.6], 'LineWidth', lwGL);
                if h==1, hG = hhG; end
            end
        end

% bold forecast portions: exactly the 12 held-out months for every
% model, matching XGBoost and NB-GLM (no transition-month join).
        hMs = gobjects(nM,1);
        for m = 1:nM
            if ~showM(m), continue; end
            for h = 1:3
                nF = nFitList(h);
                hh = plot(a, t_inf_data(nF+1:nF+12), MMON{m,h}(nF+1:nF+12), '-', ...
                          'Color', [cols(m,:) 0.75], 'LineWidth', lw(m));
                if h==1, hMs(m) = hh; end
            end
        end
        if a == ax2, hObs2 = hO;  hTC2 = hT;  hM2 = hMs;  hX2 = hX;  hG2 = hG; end
    end

    xlim(ax1, [0, tCut(1)]);
    ylabel(ax1, 'New cases per month', 'FontSize', 18);
    xticks(ax1, 0:365:365*7);
    xticklabels(ax1, {'2013','2014','2015','2016','2017','2018','2019','2020'});
    grid(ax1,'on');  ax1.FontSize = 14;  box(ax1,'off');
    xline(ax1, tCut(1), 'k', 'LineWidth', 2);

    xlim(ax2, [tCut(1), max(t_inf_data)]);
    xticks(ax2, [tCut(1) tCut(2) tCut(3) max(t_inf_data)]);
    xticklabels(ax2, {'2021','2022','2023','2024'});
    grid(ax2,'on');  ax2.FontSize = 14;  box(ax2,'off');
    ax2.YAxis.Visible = 'off';
    xline(ax2, tCut(2), 'k', 'LineWidth', 2);
    xline(ax2, tCut(3), 'k', 'LineWidth', 2);

% same bracket strip below the data as Figure 1 (yBase/yLev/tickH come
% from that block). Both panels get the limits explicitly BEFORE
% linkaxes so the link cannot widen them back to ax2's autoscaled range.
    ylim(ax1, [yBase, yTop]);
    ylim(ax2, [yBase, yTop]);
    linkaxes([ax1 ax2], 'y');
    ax1.YTick = ax1.YTick(ax1.YTick >= 0);

% brackets, in data units, drawn on whichever panel contains the midpoint
    for k = 1:3
        for a = [ax1 ax2]
            plot(a, [0 tCut(k)], [yLev(k) yLev(k)], 'k-', 'LineWidth', 2.5);
            plot(a, [0 0],             yLev(k)+[-tickH tickH], 'k-', 'LineWidth', 2.5);
            plot(a, [tCut(k) tCut(k)], yLev(k)+[-tickH tickH], 'k-', 'LineWidth', 2.5);
            xl = xlim(a);  mid = tCut(k)/2;
            if mid >= xl(1) && mid <= xl(2)
                text(a, mid, yLev(k)+tickH*2.2, [yrLabel{k} ' forecast fitting period'], ...
                     'HorizontalAlignment','center','FontSize',12,'FontWeight','bold');
            end
        end
    end

    hAll2 = hObs2;  lAll2 = {[regName ' reported cases']};
    if haveTC, hAll2 = [hAll2; hTC2]; lAll2{end+1} = 'Tamerius/Comrie forecast'; end
    if haveXG, hAll2 = [hAll2; hX2]; lAll2{end+1} = 'XGBoost forecast'; end
    if haveGL, hAll2 = [hAll2; hG2]; lAll2{end+1} = 'NB-GLM forecast'; end
    for m = 1:nM
        if showM(m), hAll2 = [hAll2; hM2(m)]; lAll2{end+1} = [modelName{m} ' forecast']; end
    end
    legend(ax2, hAll2, lAll2, 'FontSize', 13, 'Location', 'northeast');

% no subtitle on these two: the RRMSE line stays on Figure 1 only.
    title(tl, ['Model Forecast Comparison of ' regTitle], ...
          'FontSize', 24, 'FontWeight', 'bold');
    xlabel(tl, 'Year', 'FontSize', 18);
    hold(ax1,'off');  hold(ax2,'off');

% figure 2 (all models) takes the _F suffix, Figure 3 (M3/M4a/M4b) does
% not. regTag is the short label used in file names: AZ for the state,
% the plain county name otherwise. Files land in the current folder.
    if strcmpi(regName, 'Arizona'), regTag = 'AZ'; else, regTag = regName; end
    if f == 1
        fBase = ['VF_' regTag '_Forecast_V2_F'];
    else
        fBase = ['VF_' regTag '_Forecast_V2'];
    end
    drawnow;   % let the layout settle before capture
    savefig(fh, [fBase '.fig']);
    if exist('exportgraphics','file')
% text, axes and rulers stay vector. The model curves use alpha, and
% transparency has no vector representation in PDF, so MATLAB
% rasterizes those specific objects and warns; that is expected.
        exportgraphics(fh, [fBase '.pdf'], 'ContentType','vector', ...
                       'BackgroundColor','white');
    else   % pre-R2020a fallback
        set(fh, 'Units','inches');
        pos = get(fh, 'Position');
        set(fh, 'PaperUnits','inches', 'PaperSize', pos(3:4), ...
                'PaperPosition', [0 0 pos(3:4)], 'PaperPositionMode','manual');
        print(fh, [fBase '.pdf'], '-dpdf', '-r300');
        set(fh, 'Units','pixels');
    end
    fprintf('saved %s.fig and %s.pdf in %s\n', fBase, fBase, pwd);
end

fprintf('\n%s forecast RRMSE (%%), monthly integrated incidence\n', regName);
fprintf('%-9s %10s %10s %10s\n', 'model', yrLabel{:});
fprintf('%s\n', repmat('-',1,42));
for m = 1:nM
    if ~haveM(m), continue; end
    fprintf('%-9s %10.2f %10.2f %10.2f\n', modelName{m}, fcR(m,1), fcR(m,2), fcR(m,3));
end
if haveTC
    tcR = nan(1,3);
    for h = 1:3
        nF = nFitList(h);
        dFc = y_inf_data(nF+1:nF+12);
        tcR(h) = 100*sqrt(mean((TCP{h}(2:13) - dFc).^2))/mean(dFc);
    end
    fprintf('%-9s %10.2f %10.2f %10.2f\n', 'TC base', tcR(1), tcR(2), tcR(3));
end
fprintf('%s\n', repmat('-',1,42));

end

warning('on', 'all');

function stop = myOutputFcn(optimValues, state)
global choose_model single_run_or_fitting Region logIdx_active
stop = false;
    format long
    if ~isempty(logIdx_active)
        bp = optimValues.bestx(:);  bp(logIdx_active) = 10.^bp(logIdx_active);
        optimValues.bestp_natural = bp;
    end
% display or log the best solution so far
    if strcmp(state, 'iter')
        disp(['Best error so far: ', num2str(optimValues.bestfval)]);

if choose_model==1
    if single_run_or_fitting==2
        if Region==1
                save('bestSoFar_M1_AZ_fit.mat', 'optimValues');
            elseif Region==2
                save('bestSoFar_M1_Maricopa_fit.mat', 'optimValues');
            elseif Region==3
                save('bestSoFar_M1_Pima_fit.mat', 'optimValues');
            elseif Region==4
                save('bestSoFar_M1_Pinal_fit.mat', 'optimValues');
        else
            fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
            save('bestSoFar.mat', 'optimValues');
        end
    elseif single_run_or_fitting==3
        if Region==1
                save('bestSoFar_M1_AZ_for.mat', 'optimValues');
            elseif Region==2
                save('bestSoFar_M1_Maricopa_for.mat', 'optimValues');
            elseif Region==3
                save('bestSoFar_M1_Pima_for.mat', 'optimValues');
            elseif Region==4
                save('bestSoFar_M1_Pinal_for.mat', 'optimValues');
        else
            fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
            save('bestSoFar.mat', 'optimValues');
        end
    else
        fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
        save('bestSoFar.mat', 'optimValues');
    end
elseif choose_model==2
    if single_run_or_fitting==2
        if Region==1
                save('bestSoFar_M2_AZ_fit.mat', 'optimValues');
            elseif Region==2
                save('bestSoFar_M2_Maricopa_fit.mat', 'optimValues');
            elseif Region==3
                save('bestSoFar_M2_Pima_fit.mat', 'optimValues');
            elseif Region==4
                save('bestSoFar_M2_Pinal_fit.mat', 'optimValues');
        else
            fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
            save('bestSoFar.mat', 'optimValues');
        end
    elseif single_run_or_fitting==3
        if Region==1
                save('bestSoFar_M2_AZ_for.mat', 'optimValues');
            elseif Region==2
                save('bestSoFar_M2_Maricopa_for.mat', 'optimValues');
            elseif Region==3
                save('bestSoFar_M2_Pima_for.mat', 'optimValues');
            elseif Region==4
                save('bestSoFar_M2_Pinal_for.mat', 'optimValues');
        else
            fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
            save('bestSoFar.mat', 'optimValues');
        end
    else
        fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
        save('bestSoFar.mat', 'optimValues');
    end
elseif choose_model==3
    if single_run_or_fitting==2
        if Region==1
                save('bestSoFar_M3_AZ_fit.mat', 'optimValues');
            elseif Region==2
                save('bestSoFar_M3_Maricopa_fit.mat', 'optimValues');
            elseif Region==3
                save('bestSoFar_M3_Pima_fit.mat', 'optimValues');
            elseif Region==4
                save('bestSoFar_M3_Pinal_fit.mat', 'optimValues');
        else
            fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
            save('bestSoFar.mat', 'optimValues');
        end
    elseif single_run_or_fitting==3
        if Region==1
                save('bestSoFar_M3_AZ_for.mat', 'optimValues');
            elseif Region==2
                save('bestSoFar_M3_Maricopa_for.mat', 'optimValues');
            elseif Region==3
                save('bestSoFar_M3_Pima_for.mat', 'optimValues');
            elseif Region==4
                save('bestSoFar_M3_Pinal_for.mat', 'optimValues');
        else
            fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
            save('bestSoFar.mat', 'optimValues');
        end
    else
        fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
        save('bestSoFar.mat', 'optimValues');
    end
elseif choose_model==4
    if single_run_or_fitting==2
        if Region==1
                save('bestSoFar_M4_AZ_fit.mat', 'optimValues');
            elseif Region==2
                save('bestSoFar_M4_Maricopa_fit.mat', 'optimValues');
            elseif Region==3
                save('bestSoFar_M4_Pima_fit.mat', 'optimValues');
            elseif Region==4
                save('bestSoFar_M4_Pinal_fit.mat', 'optimValues');
        else
            fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
            save('bestSoFar.mat', 'optimValues');
        end
    elseif single_run_or_fitting==3
        if Region==1
                save('bestSoFar_M4_AZ_for.mat', 'optimValues');
            elseif Region==2
                save('bestSoFar_M4_Maricopa_for.mat', 'optimValues');
            elseif Region==3
                save('bestSoFar_M4_Pima_for.mat', 'optimValues');
            elseif Region==4
                save('bestSoFar_M4_Pinal_for.mat', 'optimValues');
        else
            fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
            save('bestSoFar.mat', 'optimValues');
        end
    else
        fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
        save('bestSoFar.mat', 'optimValues');
    end      
elseif choose_model==5
    if single_run_or_fitting==2
        if Region==1
                save('bestSoFar_M5_AZ_fit.mat', 'optimValues');
            elseif Region==2
                save('bestSoFar_M5_Maricopa_fit.mat', 'optimValues');
            elseif Region==3
                save('bestSoFar_M5_Pima_fit.mat', 'optimValues');
            elseif Region==4
                save('bestSoFar_M5_Pinal_fit.mat', 'optimValues');
        else
            fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
            save('bestSoFar.mat', 'optimValues');
        end
    elseif single_run_or_fitting==3
        if Region==1
                save('bestSoFar_M5_AZ_for.mat', 'optimValues');
            elseif Region==2
                save('bestSoFar_M5_Maricopa_for.mat', 'optimValues');
            elseif Region==3
                save('bestSoFar_M5_Pima_for.mat', 'optimValues');
            elseif Region==4
                save('bestSoFar_M5_Pinal_for.mat', 'optimValues');
        else
            fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
            save('bestSoFar.mat', 'optimValues');
        end
    else
        fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
        save('bestSoFar.mat', 'optimValues');
    end

else
    fprintf('Saving error check choose_model, single_run_or_fitting, and Region')
        save('bestSoFar.mat', 'optimValues');
end

    end
end

% output function Time ODE

function [errorOBJ, solution_y, solverUsed, model_mon] = objective_functionM1(p, tspan, total_pop_t0, y_inf_data)

    t_month = tspan(:);
    if any(abs(t_month - round(t_month)) > 1e-9)
        error('objective_functionM1: tspan must be integer days.');
    end
    t_month   = round(t_month);
    idx_month = t_month - t_month(1) + 1;
    if numel(unique(idx_month)) ~= numel(idx_month)
        error('objective_functionM1: duplicate month boundaries in tspan.');
    end
    tspan = (t_month(1):1:t_month(end))';

    solution_y = [];
    solverUsed = 'None (not attempted)';
    model_mon  = [];

% 1. Unpack fitted initial conditions from p
    ic_D_fit  = p(13);
    ic_H_fit  = p(14);
    ic_I_data = y_inf_data(1);
    ic_R_data = ic_I_data / 2;
    ic_S_calc = total_pop_t0 - ic_I_data - ic_R_data;

    if ic_S_calc < 0
        errorOBJ   = 1e10;
        solverUsed = 'Constraint Violation';
        return;
    end
    y0_dynamic = [ic_D_fit; ic_H_fit; ic_S_calc; ic_I_data; ic_R_data];

% state flags for the timeout mechanism
    timed_out = false;
    start_time_for_ode = [];

    odefun = @(t, y) M1_SF_T(t, y, p);

% solver chain and timeout configuration
    timeLimit = 30.0;   % was 15; the daily grid adds output points

    stdOptions = odeset('OutputFcn', @timeLimitOutputFcn, ...
                        'NonNegative', 1:length(y0_dynamic));
    looseOptions = odeset('OutputFcn', @timeLimitOutputFcn, ...
                        'NonNegative', 1:length(y0_dynamic), ...
                        'RelTol', 1e-2, 'AbsTol', 1e-4);
    vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcn, ...
                        'NonNegative', 1:length(y0_dynamic), ...
                        'RelTol', 1e-1, 'AbsTol', 1e-2);

    solverChain = {
        struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
        struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
        struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
        struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
        struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),
        struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
    };

% 3. Execute the solver chain
    y_out   = [];
    success = false;
    solverUsed = 'All solvers failed';

    for i = 1:length(solverChain)
        current = solverChain{i};
        timed_out = false;
        start_time_for_ode = [];
        try
            [~, y_out] = current.solver(odefun, tspan, y0_dynamic, current.options);
            if timed_out
                continue;   % timed out, try next solver
            elseif size(y_out,1) < numel(tspan)
                continue;   % incomplete, try next solver
            else
                success    = true;
                solverUsed = current.name;
                break;
            end
        catch ME
            if contains(ME.identifier, 'IntegrationTolNotMet')
                continue;
            else
                success = false;
                break;
            end
        end
    end   % end of solverChain loop

% 4. Calculate the objective on monthly integrated incidence
    if success && size(y_out,1) >= numel(tspan)
        epsilon_p  = p(7);
        cumflux    = cumtrapz(tspan, epsilon_p * y_out(:,3) .* y_out(:,2));   % epsilon*S*H
        model_mon  = diff(cumflux(idx_month));
        data_mon   = y_inf_data(1:numel(model_mon));
        errorOBJ   = sqrt(mean((model_mon - data_mon).^2)) / mean(data_mon);
        solution_y = y_out;
    else
        errorOBJ   = 1e10;
        solution_y = [];
        model_mon  = [];
    end

% nESTED TIMEOUT FUNCTION
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

% rSS Objective function Model 1
% objective function: minimize difference between ODE solution and target

function [errorOBJ, solution_y, solverUsed, model_mon] = objective_functionM2(p, tspan, total_pop_t0, y_inf_data)

    t_month = tspan(:);
    if any(abs(t_month - round(t_month)) > 1e-9)
        error('objective_functionM2: tspan must be integer days.');
    end
    t_month   = round(t_month);
    idx_month = t_month - t_month(1) + 1;
    if numel(unique(idx_month)) ~= numel(idx_month)
        error('objective_functionM2: duplicate month boundaries in tspan.');
    end
    tspan = (t_month(1):1:t_month(end))';

    solution_y = [];
    solverUsed = 'None (not attempted)';
    model_mon  = [];

    ic_O_fit  = p(18);
    ic_D_fit  = p(19);
    ic_H_fit  = p(20);
    ic_A_fit  = p(21);
    ic_E_fit  = p(22);
    ic_I_data = y_inf_data(1);
    ic_R_calc = ic_I_data / 2;
    ic_S_calc = total_pop_t0 - ic_I_data - ic_E_fit - ic_R_calc;

    if ic_S_calc < 0
        errorOBJ   = 1e10;
        solverUsed = 'Constraint Violation';
        return;
    end

    y0_dynamic = [ic_O_fit; ic_D_fit; ic_H_fit; ic_A_fit; ...
                  ic_S_calc; ic_E_fit; ic_I_data; ic_R_calc];

% __________Flags for the timeout mechanism __________
    timed_out = false;
    start_time_for_ode = [];

% __________ODE Problem __________
    odefun = @(t, y) M2_SF(t, y, p);

% solver Chain and Timeout Config.
    timeLimit = 30;

% __________Define options__________
    stdOptions = odeset('OutputFcn', @timeLimitOutputFcn, ...
                        'NonNegative', 1:length(y0_dynamic));
    looseOptions = odeset('OutputFcn', @timeLimitOutputFcn, ...
                          'NonNegative', 1:length(y0_dynamic), ...
                          'RelTol', 1e-2, 'AbsTol', 1e-4);
    vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcn, ...
                           'NonNegative', 1:length(y0_dynamic), ...
                           'RelTol', 1e-1, 'AbsTol', 1e-2);

% __________Create a single, extended solver chain__________
    solverChain = {
% __________Pass 1: standard accuracy __________
        struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
        struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
        struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),

% pass 2: looser accuracy __________
        struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
        struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),

% __________Pass 3: Very loose accuracy__________
        struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
    };

% __________Execute Chain__________
    y_out   = [];
    success = false;
    solverUsed = 'All solvers failed';

    for i = 1:length(solverChain)
        current = solverChain{i};
        timed_out = false;
        start_time_for_ode = [];

        try
            [~, y_out] = current.solver(odefun, tspan, y0_dynamic, current.options);

            if timed_out
                continue;   % timed out, try next solver
            elseif size(y_out,1) < numel(tspan)
                continue;
            else
                success = true;   % solver succeeded.
                solverUsed = current.name;
                break;   % exit the loop.
            end
        catch ME
% if any error occurs (including tolerance errors), try the next.
             if contains(ME.identifier, 'IntegrationTolNotMet')
                 continue;
             else
% a different, unexpected error. Stop processing this particle.
                 success = false;
                 break;
             end
        end
    end   % end of solverChain loop

% __________Calculate Error on monthly integrated incidence __________
    if success && size(y_out,1) >= numel(tspan)
        psi_p      = p(15);
        cumflux    = cumtrapz(tspan, psi_p * y_out(:,6));   % psi*E
        model_mon  = diff(cumflux(idx_month));
        data_mon   = y_inf_data(1:numel(model_mon));
        errorOBJ   = sqrt(mean((model_mon - data_mon).^2)) / mean(data_mon);
        solution_y = y_out;
    else
        errorOBJ   = 1e10;
        solution_y = [];
        model_mon  = [];
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

% rSS Objective function Model 2
% objective function: minimize difference between ODE solution and target

function [errorOBJ, solution_y, solverUsed, model_mon] = objective_functionM3(p, tspan, total_pop_t0, y_inf_data, county)

    t_month = tspan(:);
    if any(abs(t_month - round(t_month)) > 1e-9)
        error('objective_functionM3: tspan must be integer days.');
    end
    t_month   = round(t_month);
    idx_month = t_month - t_month(1) + 1;
    if numel(unique(idx_month)) ~= numel(idx_month)
        error('objective_functionM3: duplicate month boundaries in tspan.');
    end
    tspan = (t_month(1):1:t_month(end))';

    solution_y = [];
    solverUsed = 'None (not attempted)';
    model_mon  = [];

    ic_O_fit  = p(31);
    ic_D_fit  = p(32);
    ic_H_fit  = p(33);
    ic_A_fit  = p(34);
    ic_E_fit  = p(35);
    ic_I_data = y_inf_data(1);
    ic_R_calc = ic_I_data / 2;
    ic_S_calc = total_pop_t0 - ic_I_data - ic_E_fit - ic_R_calc;

    if ic_S_calc < 0
        errorOBJ   = 1e10;
        solverUsed = 'Constraint Violation';
        return;
    end

    y0_dynamic = [ic_O_fit; ic_D_fit; ic_H_fit; ic_A_fit; ...
                  ic_S_calc; ic_E_fit; ic_I_data; ic_R_calc];

% wORKING TIMED ODE RUNS
    maxTime    = 600;   % 600 for param, 30 for swarm
    solverUsed = 'None (All failed)';

% the timer is reset before each solver attempt. One nested output
% function serves all of them; it captures solverStartTime and maxTime
% from this scope.
    solverStartTime = [];
    function status = timeLimitOutputFcn(~, ~, flag)
        if isempty(flag)
            if toc(solverStartTime) > maxTime
                error('Solver:TimeLimitExceeded', ...
                      'Solver time limit (%.1fs) exceeded.', maxTime);
            end
        end
        status = 0;
    end

        timed_options = odeset('OutputFcn', @timeLimitOutputFcn, ...
                           'NonNegative', 1:numel(y0_dynamic), ...
                           'RelTol', 1e-6, 'AbsTol', 1e-8);

% nESTED TRY-CATCH FOR SOLVER FALLBACK CHAIN
    try   % ATTEMPT 1: ode15s
        solverStartTime = tic;
        [~, solution_y] = ode15s(@(t, Y) M3_SF(t, Y, p, county), tspan, y0_dynamic, timed_options);
        solverUsed = 'ode15s';
        if size(solution_y, 1) < length(tspan)
            error('Solver:IncompleteSolution', 'ode15s finished but solution was too short.');
        end
    catch ME1
        if strcmp(ME1.identifier, 'Solver:TimeLimitExceeded') || ...
           strcmp(ME1.identifier, 'Solver:IncompleteSolution') || ...
           contains(ME1.identifier, 'IntegrationTolNotMet')
            try   % ATTEMPT 2: ode23s
                solverStartTime = tic;
                [~, solution_y] = ode23s(@(t, Y) M3_SF(t, Y, p, county), tspan, y0_dynamic, timed_options);
                solverUsed = 'ode23s';
                if size(solution_y, 1) < length(tspan)
                    error('Solver:IncompleteSolution', 'ode23s finished but solution was too short.');
                end
            catch ME2
                if strcmp(ME2.identifier, 'Solver:TimeLimitExceeded') || ...
                   strcmp(ME2.identifier, 'Solver:IncompleteSolution') || ...
                   contains(ME2.identifier, 'IntegrationTolNotMet')
                    try   % ATTEMPT 3: ode45
                        solverStartTime = tic;
                        [~, solution_y] = ode45(@(t, Y) M3_SF(t, Y, p, county), tspan, y0_dynamic, timed_options);
                        solverUsed = 'ode45';
                        if size(solution_y, 1) < length(tspan)
                            error('Solver:IncompleteSolution', 'ode45 finished but solution was too short.');
                        end
                    catch ME3
                        if strcmp(ME3.identifier, 'Solver:TimeLimitExceeded') || ...
                           strcmp(ME3.identifier, 'Solver:IncompleteSolution') || ...
                           contains(ME3.identifier, 'IntegrationTolNotMet')
                            try   % ATTEMPT 4: ode23
                                solverStartTime = tic;
                                [~, solution_y] = ode23(@(t, Y) M3_SF(t, Y, p, county), tspan, y0_dynamic, timed_options);
                                solverUsed = 'ode23';
                                if size(solution_y, 1) < length(tspan)
                                    error('Solver:IncompleteSolution', 'ode23 finished but solution was too short.');
                                end
                            catch ME4
                                if strcmp(ME4.identifier, 'Solver:TimeLimitExceeded') || ...
                                   strcmp(ME4.identifier, 'Solver:IncompleteSolution') || ...
                                   contains(ME4.identifier, 'IntegrationTolNotMet')
                                    try   % ATTEMPT 5: ode15s, loose tolerance
                                        solverStartTime = tic;
                                        loose_options_final = odeset('RelTol', 1e-4, ...
                                                                     'AbsTol', 1e-6, ...
                                                                     'NonNegative', 1:numel(y0_dynamic), ...
                                                                     'OutputFcn', @timeLimitOutputFcn);
                                        [~, solution_y] = ode15s(@(t, Y) M3_SF(t, Y, p, county), tspan, y0_dynamic, loose_options_final);
                                        solverUsed = 'ode15s (loose)';
                                        if size(solution_y, 1) < length(tspan)
                                            error('Solver:IncompleteSolution', 'ode15s loose finished but solution was too short.');
                                        end
                                    catch ME5
                                        if strcmp(ME5.identifier, 'Solver:TimeLimitExceeded') || ...
                                           strcmp(ME5.identifier, 'Solver:IncompleteSolution') || ...
                                           contains(ME5.identifier, 'IntegrationTolNotMet')
% final failure. Do not error; assign the penalty.
                                            solverUsed = 'None (All timed out)';
                                            solution_y = [];
                                        else
                                            rethrow(ME5);
                                        end
                                    end
                                else
                                    rethrow(ME4);
                                end
                            end
                        else
                            rethrow(ME3);
                        end
                    end
                else
                    rethrow(ME2);
                end
            end
        else
            rethrow(ME1);
        end
    end

    if ~isempty(solution_y) && size(solution_y, 1) >= length(tspan)
        psi_p     = p(28);
        cumflux   = cumtrapz(tspan, psi_p * solution_y(:,6));   % psi*E
        model_mon = diff(cumflux(idx_month));
        data_mon  = y_inf_data(1:numel(model_mon));
        errorOBJ  = sqrt(mean((model_mon - data_mon).^2)) / mean(data_mon);
    else
        errorOBJ   = 1e10;
        solution_y = [];
        model_mon  = [];
    end
end

% rSS Objective function Model 3
% objective function: minimize difference between ODE solution and target

function [errorOBJ, solution_y, solverUsed, model_mon] = objective_functionM4_S(p, tspan, total_pop_t0, y_inf_data, county)

% tspan arrives as the 133 calendar-month boundaries. Solve daily
% instead: ode15s cost is dominated by internal steps, not output
% points, so dense output is nearly free, and it removes the ~2% error
% from applying a 2-point trapezoid across a whole month.
    t_month = tspan(:);
    if any(abs(t_month - round(t_month)) > 1e-9)
        error('objective_functionM4_S: tspan must be integer days (calendar-month boundaries).');
    end
    t_month   = round(t_month);
    idx_month = t_month - t_month(1) + 1;   % month bounds -> daily indices
    if numel(unique(idx_month)) ~= numel(idx_month)
        error('objective_functionM4_S: duplicate month boundaries in tspan.');
    end
    tspan = (t_month(1):1:t_month(end))';   % daily grid; overwrites tspan

    solution_y = [];
    solverUsed = 'None (All failed)';
    model_mon  = [];

    ic_V_fit = p(39);
    ic_O_fit = p(40);
    ic_D_fit = p(41);
    ic_H_fit = p(42);
    ic_A_fit = p(43);
    ic_E_fit = p(44);

    ic_I_data = y_inf_data(1);
    ic_R_calc = ic_I_data / 2;

% s = Total_Pop - (E + I + R).  Model 4a has no A_H compartment.
    ic_S_calc = total_pop_t0 - ic_I_data - ic_E_fit - ic_R_calc;

    if ic_S_calc < 0
        errorOBJ   = 1e10;
        solverUsed = 'Constraint Violation';
        return;
    end

% ic_E should be of order (month-1 cases)/(31*psi_I). A value orders of
% magnitude away means the bounds block did not run -- fail loudly.
    ic_E_expected = (y_inf_data(1)/31) / p(36);
    if ic_E_fit < 0.05*ic_E_expected || ic_E_fit > 20*ic_E_expected
        warning('objective_functionM4_S:icE', ...
            'ic_E = %.3g is far from the data-implied %.3g. Check LB(44)/UB(44).', ...
            ic_E_fit, ic_E_expected);
    end

    y0_dynamic = [ic_V_fit; ic_O_fit; ic_D_fit; ic_H_fit; ic_A_fit; ...
                  ic_S_calc; ic_E_fit; ic_I_data; ic_R_calc];

% wORKING TIMED ODE RUNS
maxTime = 600;   % 600 for param, 30 for swarm

% the timer is reset before each solver attempt. One nested output
% function serves all of them; it captures solverStartTime and maxTime
% from this scope.
    solverStartTime = [];
    function status = timeLimitOutputFcn(~, ~, flag)
        if isempty(flag)
            if toc(solverStartTime) > maxTime
                error('Solver:TimeLimitExceeded', ...
                      'Solver time limit (%.1fs) exceeded.', maxTime);
            end
        end
        status = 0;
    end

        timed_options = odeset('OutputFcn', @timeLimitOutputFcn, ...
                           'NonNegative', 1:numel(y0_dynamic), ...
                           'RelTol', 1e-6, 'AbsTol', 1e-8);
% nESTED TRY-CATCH FOR SOLVER FALLBACK CHAIN
    try   % ATTEMPT 1: ode15s
        solverStartTime = tic;   % reset timer
        [~, solution_y] = ode15s(@(t, Y) M4_SF_S(t, Y, p, county), tspan, y0_dynamic, timed_options);
        solverUsed = 'ode15s';
        if size(solution_y, 1) < numel(tspan)
            error('Solver:IncompleteSolution', 'ode15s finished but solution was too short.');
        end
    catch ME1
        if strcmp(ME1.identifier, 'Solver:TimeLimitExceeded') || ...
           strcmp(ME1.identifier, 'Solver:IncompleteSolution') || ...
           contains(ME1.identifier, 'IntegrationTolNotMet')
            try   % ATTEMPT 2: ode23s
                solverStartTime = tic;   % reset timer
                [~, solution_y] = ode23s(@(t, Y) M4_SF_S(t, Y, p, county), tspan, y0_dynamic, timed_options);
                solverUsed = 'ode23s';
                if size(solution_y, 1) < numel(tspan)
                    error('Solver:IncompleteSolution', 'ode23s finished but solution was too short.');
                end
            catch ME2
                if strcmp(ME2.identifier, 'Solver:TimeLimitExceeded') || ...
                   strcmp(ME2.identifier, 'Solver:IncompleteSolution') || ...
                   contains(ME2.identifier, 'IntegrationTolNotMet')
                    try   % ATTEMPT 3: ode45
                        solverStartTime = tic;   % reset timer
                        [~, solution_y] = ode45(@(t, Y) M4_SF_S(t, Y, p, county), tspan, y0_dynamic, timed_options);
                        solverUsed = 'ode45';
                        if size(solution_y, 1) < numel(tspan)
                            error('Solver:IncompleteSolution', 'ode45 finished but solution was too short.');
                        end
                    catch ME3
                        if strcmp(ME3.identifier, 'Solver:TimeLimitExceeded') || ...
                           strcmp(ME3.identifier, 'Solver:IncompleteSolution') || ...
                           contains(ME3.identifier, 'IntegrationTolNotMet')
                            try   % ATTEMPT 4: ode23
                                solverStartTime = tic;   % reset timer
                                [~, solution_y] = ode23(@(t, Y) M4_SF_S(t, Y, p, county), tspan, y0_dynamic, timed_options);
                                solverUsed = 'ode23';
                                if size(solution_y, 1) < numel(tspan)
                                    error('Solver:IncompleteSolution', 'ode23 finished but solution was too short.');
                                end
                            catch ME4
                                if strcmp(ME4.identifier, 'Solver:TimeLimitExceeded') || ...
                                   strcmp(ME4.identifier, 'Solver:IncompleteSolution') || ...
                                   contains(ME4.identifier, 'IntegrationTolNotMet')
                                    try   % ATTEMPT 5: ode78
                                        solverStartTime = tic;   % reset timer
                                        [~, solution_y] = ode78(@(t, Y) M4_SF_S(t, Y, p, county), tspan, y0_dynamic, timed_options);
                                        solverUsed = 'ode78';
                                        if size(solution_y, 1) < numel(tspan)
                                            error('Solver:IncompleteSolution', 'ode78 finished but solution was too short.');
                                        end
                                    catch ME5
                                        if strcmp(ME5.identifier, 'Solver:TimeLimitExceeded') || ...
                                           strcmp(ME5.identifier, 'Solver:IncompleteSolution') || ...
                                           contains(ME5.identifier, 'IntegrationTolNotMet')
                                            try   % ATTEMPT 6: ode15s (loose)
                                                solverStartTime = tic;   % reset timer
                                                loose_options_final = odeset('RelTol', 1e-4, ...
                                                                             'AbsTol', 1e-6, ...
                                                                             'NonNegative', 1:numel(y0_dynamic), ...
                                                                             'OutputFcn', @timeLimitOutputFcn);
                                                [~, solution_y] = ode15s(@(t, Y) M4_SF_S(t, Y, p, county), tspan, y0_dynamic, loose_options_final);
                                                solverUsed = 'ode15s (loose)';
                                                if size(solution_y, 1) < numel(tspan)
                                                    error('Solver:IncompleteSolution', 'ode15s (loose) finished but solution was too short.');
                                                end
                                            catch ME6
                                                if strcmp(ME6.identifier, 'Solver:TimeLimitExceeded') || ...
                                                   strcmp(ME6.identifier, 'Solver:IncompleteSolution') || ...
                                                   contains(ME6.identifier, 'IntegrationTolNotMet')
% final failure. Do not error; assign the penalty.
                                                    solverUsed = 'None (All timed out)';
                                                    solution_y = [];
                                                else
                                                    rethrow(ME6);
                                                end
                                            end
                                        else
                                            rethrow(ME5);
                                        end
                                    end
                                else
                                    rethrow(ME4);
                                end
                            end
                        else
                            rethrow(ME3);
                        end
                    end
                else
                    rethrow(ME2);
                end
            end
        else
            rethrow(ME1);
        end
    end

    if ~isempty(solution_y) && size(solution_y, 1) >= numel(tspan)
        psi_p     = p(36);
        flux_d    = psi_p * solution_y(:,7);   % psi*E, E is column 7
        cumflux   = cumtrapz(tspan, flux_d);   % cumulative cases, daily
        model_mon = diff(cumflux(idx_month));   % 132 monthly totals
        data_mon  = y_inf_data(1:numel(model_mon));
        errorOBJ  = sqrt(mean((model_mon - data_mon).^2)) / mean(data_mon);
% solution_y is returned on the DAILY grid (4018 rows), matching
    else
        errorOBJ   = 1e10;
        solution_y = [];
        model_mon  = [];
    end

% %NO ERROR THROWN METHOD -- kept as a drop-in alternative, updated to match
% %v4: daily grid, NonNegative, strict completeness test, monthly-incidence
% %error, and model_mon as the 4th output. To use it, comment out the nested
% %try-catch above and this whole block's leading %.
% timed_out = false;
% start_time_for_ode = [];
% odefun    = @(t, y) M4_SF_S(t, y, p, county);
% timeLimit = 30;
% stdOptions = odeset('OutputFcn', @timeLimitOutputFcnFlag, ...
% 'NonNegative', 1:numel(y0_dynamic));
% looseOptions = odeset('OutputFcn', @timeLimitOutputFcnFlag, ...
% 'NonNegative', 1:numel(y0_dynamic), ...
% 'RelTol', 1e-2, 'AbsTol', 1e-4);
% vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcnFlag, ...
% 'NonNegative', 1:numel(y0_dynamic), ...
% 'RelTol', 1e-1, 'AbsTol', 1e-2);
% solverChain = {
% struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
% struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
% struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
% struct('solver', @ode23,  'name', 'ode23 (standard tol)',  'options', stdOptions),
% struct('solver', @ode78,  'name', 'ode78 (standard tol)',  'options', stdOptions),
% struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
% struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),
% struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
% };
% y_out   = [];
% success = false;
% solverUsed = 'All solvers failed';
% for i = 1:length(solverChain)
% current = solverChain{i};
% timed_out = false;
% start_time_for_ode = [];
% try
% [~, y_out] = current.solver(odefun, tspan, y0_dynamic, current.options);
% if timed_out
% continue;                        % timed out, try next
% elseif size(y_out,1) < numel(tspan)  % STRICT: idx_month needs the
% continue;                        % last row to exist
% else
% success = true;
% solverUsed = current.name;
% break;
% end
% catch ME
% if contains(ME.identifier, 'IntegrationTolNotMet')
% continue;
% else
% success = false;
% break;
% end
% end
% end
% if success && size(y_out,1) >= numel(tspan)
% psi_p      = p(36);
% cumflux    = cumtrapz(tspan, psi_p * y_out(:,7));
% model_mon  = diff(cumflux(idx_month));
% data_mon   = y_inf_data(1:numel(model_mon));
% errorOBJ   = sqrt(mean((model_mon - data_mon).^2)) / mean(data_mon);
% solution_y = y_out;
% else
% errorOBJ   = 1e10;
% solution_y = [];
% model_mon  = [];
% end
% % flag-based timeout: returns status = 1 so the solver stops cleanly
% % instead of raising an exception on every timeout
% function status = timeLimitOutputFcnFlag(~, ~, flag)
% status = 0;
% if strcmp(flag, 'init')
% start_time_for_ode = tic;
% elseif isempty(flag)
% if ~isempty(start_time_for_ode) && toc(start_time_for_ode) > timeLimit
% timed_out = true;
% status = 1;
% end
% end
% end

end

% objective function Model 4 BBBBBBB

function [errorOBJ, solution_y, solverUsed, model_mon] = objective_functionM5(p, tspan, total_pop_t0, y_inf_data, county)

% tspan arrives as the 133 calendar-month boundaries. Solve daily
% instead: ode15s cost is dominated by internal steps, not output
% points, so dense output is nearly free, and it removes the ~2% error
% from applying a 2-point trapezoid across a whole month.
    t_month = tspan(:);
    if any(abs(t_month - round(t_month)) > 1e-9)
        error('objective_functionM5: tspan must be integer days (calendar-month boundaries).');
    end
    t_month   = round(t_month);
    idx_month = t_month - t_month(1) + 1;   % month bounds -> daily indices
    if numel(unique(idx_month)) ~= numel(idx_month)
        error('objective_functionM5: duplicate month boundaries in tspan.');
    end
    tspan = (t_month(1):1:t_month(end))';   % daily grid; overwrites tspan

    solution_y = [];
    solverUsed = 'None (All failed)';
    model_mon  = [];

    ic_V_fit = p(41);
    ic_O_fit = p(42);
    ic_D_fit = p(43);
    ic_H_fit = p(44);
    ic_A_fit = p(45);
    ic_E_fit = p(46);

    ic_I_data   = y_inf_data(1);
    ic_A_H_calc = ic_I_data;
    ic_R_calc   = ic_I_data / 2;

% s = Total_Pop - (E + A_H + I + R)
    ic_S_calc = total_pop_t0 - ic_E_fit - ic_A_H_calc - ic_I_data - ic_R_calc;

    if ic_S_calc < 0
        errorOBJ   = 1e10;
        solverUsed = 'Constraint Violation';
        return;
    end

% ic_E should be of order (month-1 cases)/(31*psi_I). A value orders of
% magnitude away means the bounds block did not run -- fail loudly.
    ic_E_expected = (y_inf_data(1)/31) / p(37);
    if ic_E_fit < 0.05*ic_E_expected || ic_E_fit > 20*ic_E_expected
        warning('objective_functionM5:icE', ...
            'ic_E = %.3g is far from the data-implied %.3g. Check LB(46)/UB(46).', ...
            ic_E_fit, ic_E_expected);
    end

    y0_dynamic = [ic_V_fit; ic_O_fit; ic_D_fit; ic_H_fit; ic_A_fit; ...
                  ic_S_calc; ic_E_fit; ic_A_H_calc; ic_I_data; ic_R_calc];

% wORKING TIMED ODE RUNS
maxTime = 600;   % 600 for param, 30 for swarm

% the timer is reset before each solver attempt. One nested output
% function serves all of them; it captures solverStartTime and maxTime
% from this scope.
    solverStartTime = [];
    function status = timeLimitOutputFcn(~, ~, flag)
        if isempty(flag)
            if toc(solverStartTime) > maxTime
                error('Solver:TimeLimitExceeded', ...
                      'Solver time limit (%.1fs) exceeded.', maxTime);
            end
        end
        status = 0;
    end

        timed_options = odeset('OutputFcn', @timeLimitOutputFcn, ...
                           'NonNegative', 1:numel(y0_dynamic), ...
                           'RelTol', 1e-6, 'AbsTol', 1e-8);
% nESTED TRY-CATCH FOR SOLVER FALLBACK CHAIN
    try   % ATTEMPT 1: ode15s
        solverStartTime = tic;   % reset timer
        [~, solution_y] = ode15s(@(t, Y) M5_SF(t, Y, p, county), tspan, y0_dynamic, timed_options);
        solverUsed = 'ode15s';
        if size(solution_y, 1) < numel(tspan)
            error('Solver:IncompleteSolution', 'ode15s finished but solution was too short.');
        end
    catch ME1
        if strcmp(ME1.identifier, 'Solver:TimeLimitExceeded') || ...
           strcmp(ME1.identifier, 'Solver:IncompleteSolution') || ...
           contains(ME1.identifier, 'IntegrationTolNotMet')
            try   % ATTEMPT 2: ode23s
                solverStartTime = tic;   % reset timer
                [~, solution_y] = ode23s(@(t, Y) M5_SF(t, Y, p, county), tspan, y0_dynamic, timed_options);
                solverUsed = 'ode23s';
                if size(solution_y, 1) < numel(tspan)
                    error('Solver:IncompleteSolution', 'ode23s finished but solution was too short.');
                end
            catch ME2
                if strcmp(ME2.identifier, 'Solver:TimeLimitExceeded') || ...
                   strcmp(ME2.identifier, 'Solver:IncompleteSolution') || ...
                   contains(ME2.identifier, 'IntegrationTolNotMet')
                    try   % ATTEMPT 3: ode45
                        solverStartTime = tic;   % reset timer
                        [~, solution_y] = ode45(@(t, Y) M5_SF(t, Y, p, county), tspan, y0_dynamic, timed_options);
                        solverUsed = 'ode45';
                        if size(solution_y, 1) < numel(tspan)
                            error('Solver:IncompleteSolution', 'ode45 finished but solution was too short.');
                        end
                    catch ME3
                        if strcmp(ME3.identifier, 'Solver:TimeLimitExceeded') || ...
                           strcmp(ME3.identifier, 'Solver:IncompleteSolution') || ...
                           contains(ME3.identifier, 'IntegrationTolNotMet')
                            try   % ATTEMPT 4: ode23
                                solverStartTime = tic;   % reset timer
                                [~, solution_y] = ode23(@(t, Y) M5_SF(t, Y, p, county), tspan, y0_dynamic, timed_options);
                                solverUsed = 'ode23';
                                if size(solution_y, 1) < numel(tspan)
                                    error('Solver:IncompleteSolution', 'ode23 finished but solution was too short.');
                                end
                            catch ME4
                                if strcmp(ME4.identifier, 'Solver:TimeLimitExceeded') || ...
                                   strcmp(ME4.identifier, 'Solver:IncompleteSolution') || ...
                                   contains(ME4.identifier, 'IntegrationTolNotMet')
                                    try   % ATTEMPT 5: ode78
                                        solverStartTime = tic;   % reset timer
                                        [~, solution_y] = ode78(@(t, Y) M5_SF(t, Y, p, county), tspan, y0_dynamic, timed_options);
                                        solverUsed = 'ode78';
                                        if size(solution_y, 1) < numel(tspan)
                                            error('Solver:IncompleteSolution', 'ode78 finished but solution was too short.');
                                        end
                                    catch ME5
                                        if strcmp(ME5.identifier, 'Solver:TimeLimitExceeded') || ...
                                           strcmp(ME5.identifier, 'Solver:IncompleteSolution') || ...
                                           contains(ME5.identifier, 'IntegrationTolNotMet')
                                            try   % ATTEMPT 6: ode15s (loose)
                                                solverStartTime = tic;   % reset timer
                                                loose_options_final = odeset('RelTol', 1e-4, ...
                                                                             'AbsTol', 1e-6, ...
                                                                             'NonNegative', 1:numel(y0_dynamic), ...
                                                                             'OutputFcn', @timeLimitOutputFcn);
                                                [~, solution_y] = ode15s(@(t, Y) M5_SF(t, Y, p, county), tspan, y0_dynamic, loose_options_final);
                                                solverUsed = 'ode15s (loose)';
                                                if size(solution_y, 1) < numel(tspan)
                                                    error('Solver:IncompleteSolution', 'ode15s (loose) finished but solution was too short.');
                                                end
                                            catch ME6
                                                if strcmp(ME6.identifier, 'Solver:TimeLimitExceeded') || ...
                                                   strcmp(ME6.identifier, 'Solver:IncompleteSolution') || ...
                                                   contains(ME6.identifier, 'IntegrationTolNotMet')
% final failure. Do not error; assign the penalty.
                                                    solverUsed = 'None (All timed out)';
                                                    solution_y = [];
                                                else
                                                    rethrow(ME6);
                                                end
                                            end
                                        else
                                            rethrow(ME5);
                                        end
                                    end
                                else
                                    rethrow(ME4);
                                end
                            end
                        else
                            rethrow(ME3);
                        end
                    end
                else
                    rethrow(ME2);
                end
            end
        else
            rethrow(ME1);
        end
    end

    if ~isempty(solution_y) && size(solution_y, 1) >= numel(tspan)
        psi_I_p   = p(37);
        flux_d    = psi_I_p * solution_y(:,7);   % new symptomatic cases/day
        cumflux   = cumtrapz(tspan, flux_d);   % cumulative cases, daily
        model_mon = diff(cumflux(idx_month));   % 132 monthly totals
        data_mon  = y_inf_data(1:numel(model_mon));
        errorOBJ  = sqrt(mean((model_mon - data_mon).^2)) / mean(data_mon);
    else
        errorOBJ   = 1e10;
        solution_y = [];
        model_mon  = [];
    end

% %NO ERROR THROWN METHOD -- kept as a drop-in alternative, updated to match
% %v4: daily grid, NonNegative, strict completeness test, monthly-incidence
% %error, and model_mon as the 4th output. To use it, comment out the nested
% %try-catch above and this whole block's leading %.
% timed_out = false;
% start_time_for_ode = [];
% odefun    = @(t, y) M5_SF(t, y, p, county);
% timeLimit = 30;
% stdOptions = odeset('OutputFcn', @timeLimitOutputFcnFlag, ...
% 'NonNegative', 1:numel(y0_dynamic));
% looseOptions = odeset('OutputFcn', @timeLimitOutputFcnFlag, ...
% 'NonNegative', 1:numel(y0_dynamic), ...
% 'RelTol', 1e-2, 'AbsTol', 1e-4);
% vLooseOptions = odeset('OutputFcn', @timeLimitOutputFcnFlag, ...
% 'NonNegative', 1:numel(y0_dynamic), ...
% 'RelTol', 1e-1, 'AbsTol', 1e-2);
% solverChain = {
% struct('solver', @ode15s, 'name', 'ode15s (standard tol)', 'options', stdOptions),
% struct('solver', @ode23s, 'name', 'ode23s (standard tol)', 'options', stdOptions),
% struct('solver', @ode45,  'name', 'ode45 (standard tol)',  'options', stdOptions),
% struct('solver', @ode23,  'name', 'ode23 (standard tol)',  'options', stdOptions),
% struct('solver', @ode78,  'name', 'ode78 (standard tol)',  'options', stdOptions),
% struct('solver', @ode15s, 'name', 'ode15s (loose tol)',    'options', looseOptions),
% struct('solver', @ode23s, 'name', 'ode23s (loose tol)',    'options', looseOptions),
% struct('solver', @ode15s, 'name', 'ode15s (very loose tol)', 'options', vLooseOptions)
% };
% y_out   = [];
% success = false;
% solverUsed = 'All solvers failed';
% for i = 1:length(solverChain)
% current = solverChain{i};
% timed_out = false;
% start_time_for_ode = [];
% try
% [~, y_out] = current.solver(odefun, tspan, y0_dynamic, current.options);
% if timed_out
% continue;                        % timed out, try next
% elseif size(y_out,1) < numel(tspan)  % STRICT: idx_month needs the
% continue;                        % last row to exist
% else
% success = true;
% solverUsed = current.name;
% break;
% end
% catch ME
% if contains(ME.identifier, 'IntegrationTolNotMet')
% continue;
% else
% success = false;
% break;
% end
% end
% end
% if success && size(y_out,1) >= numel(tspan)
% psi_I_p    = p(37);
% cumflux    = cumtrapz(tspan, psi_I_p * y_out(:,7));
% model_mon  = diff(cumflux(idx_month));
% data_mon   = y_inf_data(1:numel(model_mon));
% errorOBJ   = sqrt(mean((model_mon - data_mon).^2)) / mean(data_mon);
% solution_y = y_out;
% else
% errorOBJ   = 1e10;
% solution_y = [];
% model_mon  = [];
% end
% % flag-based timeout: returns status = 1 so the solver stops cleanly
% % instead of raising an exception on every timeout
% function status = timeLimitOutputFcnFlag(~, ~, flag)
% status = 0;
% if strcmp(flag, 'init')
% start_time_for_ode = tic;
% elseif isempty(flag)
% if ~isempty(start_time_for_ode) && toc(start_time_for_ode) > timeLimit
% timed_out = true;
% status = 1;
% end
% end
% end

end

% rSS Objective function Model 4 BBBBBBB

function dpop_fit = pop_fit(t,a,params)
N=a(1);
alpha_h=params(1);  omega=params(2);   % N_max=params(3);

% dN=alpha_h*N*(1-N/N_max)-omega*N;
dN=(alpha_h+omega)*N-omega*N;

dpop_fit=[dN];
end

% mODEL 0.2 Function

function dpop_fit = pop_fit_3(t,a,params)
N=a(1);
alpha_h=params(1);  omega=params(2); N_max=params(3);

dN=(alpha_h+omega)*N-(omega+(alpha_h/N_max)*N)*N;   % c=((alpha_h+omega)-omega)/N_max=alpha_h/N_max
% or
% dN=alpha_h*N-(alpha_h*N*N)/N_max;

dpop_fit=[dN];
end

% mODEL 1 Function
% model 1 function

function dM1_SF_T = M1_SF_T(t,a,params)
D = a(1); H = a(2); S=a(3); I=a(4); R=a(5); 

O=params(1);         mu_H=params(2);       gamma_H=params(3); 
H_max=params(4);     delta_H=params(5);    alpha_h=params(6);      
epsilon=params(7);   omega=params(8);      rho=params(9);
kappa=params(10);    delta_D=params(11);   c=params(12);

% dD=O-mu_H*D*H;
dD=O-mu_H*D*H-delta_D*D;
dH=gamma_H*D*H*(1-(H/H_max))-delta_H*H;

dS=alpha_h*(S+I+R)-epsilon*S*H-(omega+c*(S+I+R))*S;
dI=epsilon*S*H-rho*I-kappa*I-(omega+c*(S+I+R))*I;
dR=rho*I-(omega+c*(S+I+R))*R;

dM1_SF_T=[dD;dH;dS;dI;dR];
end

% mODEL 2 Function

function dM2_SF = M2_SF(t,a,params)
O = a(1); D = a(2); H = a(3); A = a(4);   % c = a(5);
S = a(5); E = a(6);I = a(7); R = a(8);

PI=params(1);           delta_O=params(2);      mu_H=params(3);
gamma_H=params(4);      H_max=params(5);        delta_H=params(6);
gamma_A=params(7);      delta_A=params(8);      phi_A=params(9);
alpha_h=params(10);    
epsilon=params(11);     omega=params(12);       rho=params(13);
kappa=params(14);       psi=params(15);     delta_D=params(16);
c=params(17);

dO=PI-delta_O*O;
dD=delta_O*O-mu_H*D*H-delta_D*D;
dH=(phi_A*A+gamma_H*D*H)*(1-(H/H_max))-delta_H*H;
dA=gamma_A*H-phi_A*A-delta_A*A;

Nt=S+E+I+R;
dS=alpha_h*Nt-epsilon*S*A-(omega+c*Nt)*S;
dE=epsilon*S*A-psi*E-(omega+c*Nt)*E;
dI=psi*E-rho*I-kappa*I-(omega+c*Nt)*I;
dR=rho*I-(omega+c*Nt)*R;

dM2_SF=[dO;dD;dH;dA;dS;dE;dI;dR];
end

% mODEL 3 Function

function dM3_SF = M3_SF(t,a,params,county,temp_shift,alpha_PZI,beta_PZI)
    if nargin < 5
        temp_shift = 0.0;
        alpha_PZI  = 1.0;
        beta_PZI   = 0.0;
    end

O = a(1); D = a(2); H = a(3); A = a(4);
S = a(5); E = a(6); I = a(7); R = a(8);

PI=params(1);         delta_O=params(2);      mu_H=params(3);
gamma_H=params(4);    H_max=params(5);        delta_H=params(6);
gamma_A=params(7);    delta_A=params(8);      phi_A=params(9);   
T_opt_H = params(10);
T_opt_A = params(10) + params(11);   % T_opt_H + T_gap
S_opt_A = params(12);
S_opt_H = params(12) + params(13);   % S_opt_A + S_gap
T_decay=params(14);
bl_Topt_A=params(15); ab_Topt_A=params(16);   bl_Topt_H=params(17);
ab_Topt_H=params(18); bl_Sopt_A=params(19);   ab_Sopt_A=params(20);
bl_Sopt_H=params(21); ab_Sopt_H=params(22);   alpha_h=params(23);
epsilon=params(24);   omega=params(25);
rho=params(26);       kappa=params(27);       psi=params(28);
delta_D=params(29);   c=params(30);

% cACHED ENVIRONMENTAL FORCING
% rebuilt only when county or the climate-shift arguments change.
persistent CACHE_KEY BRK CF NB DBR TFpp SMpp
cache_key = [county, temp_shift, alpha_PZI, beta_PZI];
if isempty(CACHE_KEY) || ~isequal(CACHE_KEY, cache_key)

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

    switch county
    case 1   % arizona
        temp_data=[38.6; 42.2; 54.8; 59.4; 67.4; 79.5; 81.0; 78.5; 72.4; 58.8; 51.3;...
        41.5; 46.5; 50.0; 53.9; 59.1; 66.8; 77.7; 81.4; 76.5; 74.2; 64.9; 51.7; 44.3; 45.1;...
        52.0; 56.3; 58.4; 62.9; 78.4; 78.6; 80.6; 75.0; 64.5; 48.3; 40.9; 41.8; 50.6; 54.9;...
        58.5; 64.6; 80.3; 82.4; 77.5; 71.6; 66.1; 53.1; 44.7; 42.3; 49.4; 56.6; 59.9; 66.1;...
        79.8; 81.5; 79.1; 72.4; 65.1; 57.6; 46.6; 47.6; 46.7; 52.3; 62.9; 68.5; 78.6; 82.3;...
        80.2; 76.0; 59.9; 49.4; 42.8; 42.4; 40.9; 51.7; 60.3; 60.7; 75.2; 81.9; 81.9; 73.8;...
        60.0; 52.1; 42.2; 43.7; 45.9; 51.0; 59.3; 70.5; 76.8; 82.8; 84.1; 75.6; 66.2; 53.5;...
        42.0; 42.6; 46.5; 49.4; 61.2; 67.9; 80.6; 81.4; 79.5; 74.8; 59.9; 55.8; 45.6; 43.5;...
        44.0; 51.8; 60.5; 68.6; 78.6; 82.2; 79.0; 75.9; 61.8; 46.1; 42.8; 40.3; 41.9; 47.2;...
        58.4; 66.5; 72.4; 85.4; 80.7; 73.6; 64.4; 52.6; 45.4];
        soil_mstr_data=[10.62;9.22;8.26;7.91;8.25;7.71;11.94;10.43;11.66;8.52;12.04;...
        8.76;7.16;6.9;8.03;7.26;7.22;6.88;9.67;12.5;12.95;8.7;7.98;10.2;10.95;8.23;8.67;8.47;...
        10.74;10.34;10.35;9.59;10.03;11.91;9.92;8.87;10.34;7.49;6.66;8.81;8.83;8.16;8.32;11.03;...
        10.42;7.91;9.67;11.41;12;10.17;7.85;8.52;10.04;8.96;12.46;8.01;8.45;7.26;6.84;7.38;7.64;...
        9.06;7.82;5.99;7.16;7.63;11.46;9.36;8.46;14.53;8.8;8.9;10.48;13.67;10.25;9.89;11.96;...
        10.88;7.47;6.54;10.97;7.91;14.44;11.23;8.92;10.21;12.52;10.47;11.24;9.56;6.77;5.54;6.75;...
        7.38;8.08;8.18;9.89;7.85;8.99;7.1;7;7.21;14.84;9.74;9.84;9.69;7.21;10.62;8.14;8.52;8.52;...
        6.77;6.97;8.74;10.66;12.3;10.1;10.64;9.4;10.35;12.34;10.55;12.46;9.84;11.96;10.83;6.61;...
        8.88;9.72;7.75;8.67;9.03];

    case 2   % maricopa
        temp_data=[50;52.9;65;69.8;78.2;88.5;91.4;89.6;83.2;69.2;62.1;52.3;...
        56.5;59.8;64.5;69.8;77.9;87.2;91.3;86.4;84.4;74.7;61.8;53.9;55.1;61.5;...
        67.2;68.8;73;88.1;89.4;92.3;85.6;74.7;58;50.7;51.7;61.8;65.6;69.2;74.7;...
        90.2;93.2;88.8;82.4;76.6;63.6;54.8;52;58.5;66.8;70.7;76.9;89.4;91.8;...
        90.4;82.8;76.2;67.4;56.9;58.4;56.2;62.6;73;78.1;87.1;91.9;90.3;87.4;...
        69.6;59.7;52.5;52.8;50.2;61.4;70.3;71.1;85.6;92.4;92.6;84.2;71;62.2;...
        52.5;53.5;55.7;60.3;69;81.2;86.7;94;94.7;87;76.6;63.9;52.9;53.2;57;59.9;...
        71.6;77.4;89.9;90.2;88.8;84.7;69.9;66.2;55.2;53.7;55;62.5;70.7;78;89;92;...
        89;86;72.4;55.5;51.5;50;52.6;56.8;68.7;76.5;81.7;96;92;84.2;74.9;63.2;55.6];
        soil_mstr_data=[11.19;9.57;9.05;8.3;8.4;8.6;10.31;9.64;10.95;8.72;...
        13.29;8.92;7.68;7.11;8.73;7.78;7.86;8.47;10.07;13.74;15.11;9.01;8.2;...
        10.15;10.2;7.97;8.1;8.49;10.23;9.47;8.95;7.89;9.81;11.29;9.41;8.75;10.84;...
        7.72;6.72;8.7;8.68;8.92;7.67;10.57;8.92;8.19;9.67;10.84;11;11.25;8.09;...
        8.62;9.25;8.84;12.26;8.76;8.04;7.75;7.43;7.89;7.82;8.77;7.47;7.25;7.91;...
        8.98;13.33;10.48;8.17;16.69;9.11;8.62;9.84;13.51;10.12;9.43;10.42;9.92;...
        8.32;7.2;13.61;8.33;14.64;10.86;8.77;10.93;13.42;11.24;11.26;8.67;7.06;...
        7.09;7.46;7.71;8.02;8.8;9.8;7.94;8.14;7.53;7.91;8.81;15.97;12.66;9.59;...
        9.52;7.61;11.6;8.49;8.95;7.88;7.87;8.12;9.31;10.8;12.56;9.97;10.21;9.47;...
        11.1;11.67;10.64;11.91;11.03;11.01;9.89;7.22;7.43;9.54;7.93;8.66;9.77];

    case 3   % pima
        temp_data=[48.0; 49.5; 62.7; 66.7; 74.4; 85.6; 85.3; 83.9; 79.8; 67.1; 60.2;...
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
        soil_mstr_data=[9.94;10.4;8.27;8.04;8.16;8.23;10.48;10.21;10.37;8.27;13.32;...
        9.16;7.62;7.18;8.27;8.11;8.05;7.98;10.59;11.6;12.03;10.55;8.23;10.35;12.34;8.45;...
        8.32;9.19;10.13;11.13;9.25;8.08;12.24;11.52;9.11;9.08;10.78;7.84;6.91;9.45;8.42;...
        9.86;8.24;9.57;10.93;7.81;8.95;10.14;10.71;9.14;6.89;7.94;8.67;8.17;12.31;7.77;7.77;...
        7.36;7.42;8.26;7.21;10.82;8;7.34;8.03;10.14;11.34;9.7;9.35;14.9;8.92;9.8;10.23;13.59;...
        10.56;10.04;10.95;10.3;7.42;8.54;13.23;8.06;14.66;11.59;9.49;10.36;11.7;10.99;10.51;...
        9.04;6.36;6.36;6.86;7.46;8.05;8.45;10.66;8.26;8.38;7.95;8.03;8.88;18.62;12.45;9.39;8.38;...
        7.63;9.82;8.41;8.51;7.73;7.73;7.96;10.1;10.83;12.76;10.19;10.15;8.83;10.62;11.38;10.98;...
        10.49;9.88;10.42;9.39;6.58;8.2;8.69;7.92;8.52;10.4];

    case 4   % pinal
        temp_data=[48.2; 50.5; 62.6; 67.6; 76.5; 87.3; 88.2; 86.7; 81.4; 68.4; 60.7;...
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
        soil_mstr_data= [10.82; 9.64; 9.20; 8.65; 8.65; 8.40; 11.98; 8.05; 9.70;...
        8.48; 12.07; 8.79; 7.53; 6.86; 8.95; 7.40; 7.51; 7.88; 8.81; 10.79; 14.72; 10.25;...
        7.99; 10.15; 11.68; 8.12; 7.78; 9.04; 10.83; 10.48; 9.33; 9.75; 13.02; 11.84; 9.73;...
        8.65; 10.84; 7.70; 6.75; 8.86; 8.33; 9.53; 7.85; 9.88; 9.85; 8.00; 9.60; 10.02; 10.87;...
        8.92; 7.26; 7.86; 8.61; 8.31; 13.30; 9.20; 7.85; 7.50; 7.19; 7.94; 7.67; 9.63; 7.46; 6.74;...
        7.52; 9.43; 11.60; 9.57; 10.68; 14.41; 9.01; 9.05; 9.83; 14.28; 9.55; 9.82; 10.37; 10.31;...
        8.35; 6.86; 11.60; 8.08; 14.76; 11.76; 9.24; 10.30; 11.11; 10.56; 11.07; 8.67; 6.74; 6.69;...
        7.18; 7.55; 8.15; 8.50; 9.84; 7.74; 8.15; 7.18; 7.49; 8.05; 18.35; 10.85; 11.11; 8.74; 7.43;...
        10.29; 9.01; 8.97; 8.48; 7.22; 7.47; 9.72; 9.13; 12.40; 9.67; 10.03; 9.01; 12.06; 11.71; 10.98;...
        10.68; 10.67; 11.82; 10.26; 6.83; 7.90; 9.35; 7.75; 8.99; 10.00];

    otherwise
        error('M3_SF: no region selected or invalid county input');
    end

% apply climate stress tests
    temp_data      = temp_data + temp_shift;
    soil_mstr_data = (alpha_PZI .* (soil_mstr_data - 10)) - beta_PZI + 10;

    TFpp = pchip(tind, temp_data);
    SMpp = pchip(tind, soil_mstr_data);
    BRK  = TFpp.breaks(:);   % identical breaks for both splines
    CF   = [TFpp.coefs, SMpp.coefs];   % 132 x 8
    NB   = numel(BRK);   % 133
    DBR  = (BRK(end) - BRK(1))/(NB-1);   % mean break spacing, for the O(1) guess
    CACHE_KEY = cache_key;
end

% o(1) interval lookup: breaks are ~monthly, so guess then walk
    j = min(max(floor((t - BRK(1))/DBR) + 1, 1), NB-1);
    while j > 1    && t <  BRK(j),   j = j - 1; end
    while j < NB-1 && t >= BRK(j+1), j = j + 1; end
    dt = t - BRK(j);
    TF  = ((CF(j,1)*dt + CF(j,2))*dt + CF(j,3))*dt + CF(j,4);
    S_m = ((CF(j,5)*dt + CF(j,6))*dt + CF(j,7))*dt + CF(j,8);

% eNVIRONMENTAL RESPONSE FUNCTIONS
if TF <= T_opt_A
    F_A_T = exp(-((TF-T_opt_A)^2/bl_Topt_A));
else
    F_A_T = exp(-((TF-T_opt_A)^2/ab_Topt_A));
end

if TF <= T_opt_H
    F_H_T = exp(-((TF-T_opt_H)^2/bl_Topt_H));
else
    F_H_T = exp(-((TF-T_opt_H)^2/ab_Topt_H));
end

if S_m <= S_opt_A
    F_A_S_m = exp(-((S_m-S_opt_A)^2/bl_Sopt_A));
else
    F_A_S_m = exp(-((S_m-S_opt_A)^2/ab_Sopt_A));
end

if S_m <= S_opt_H
    F_H_S_m = exp(-((S_m-S_opt_H)^2/bl_Sopt_H));
else
    F_H_S_m = exp(-((S_m-S_opt_H)^2/ab_Sopt_H));
end

Nt   = S+E+I+R;
decT = (TF/T_decay)*delta_O;   % only delta_O/T_decay is identified

dO = PI - decT*O;
dD = decT*O - (mu_H*H*D) - delta_D*D;
dH = (phi_A*A + gamma_H*D*H*(F_H_T*F_H_S_m))*(1-(H/H_max)) - delta_H*H;
dA = gamma_A*H*(F_A_T*F_A_S_m) - phi_A*A - delta_A*A;

dS = alpha_h*Nt - epsilon*S*A - (omega+c*Nt)*S;
dE = epsilon*S*A - psi*E - (omega+c*Nt)*E;
dI = psi*E - rho*I - kappa*I - (omega+c*Nt)*I;
dR = rho*I - (omega+c*Nt)*R;

dM3_SF = [dO;dD;dH;dA;dS;dE;dI;dR];
end

% mODEL 3 Function NEW NEW NEW NEW NEW NEW NEW NEW
% model 3 function

function dM4_SF_S = M4_SF_S(t,a,params,county,temp_shift,alpha_PZI,beta_PZI)
    if nargin < 5
        temp_shift = 0.0;
        alpha_PZI  = 1.0;
        beta_PZI   = 0.0;
    end

V=a(1); O = a(2); D = a(3); H = a(4); A = a(5);
S= a(6); E= a(7); I= a(8); R= a(9);

delta_O=params(1);      mu_H=params(2);
gamma_H=params(3);      H_max=params(4);        delta_H=params(5);
gamma_A=params(6);      delta_A=params(7);      phi_A=params(8);   
T_opt_H = params(9);
T_opt_A = params(9) + params(10);   % T_opt_H + T_gap
S_opt_A = params(11);
S_opt_H = params(11) + params(12);   % S_opt_A + S_gap
T_decay=params(13);
bl_Topt_A=params(14);   ab_Topt_A=params(15);   bl_Topt_H=params(16);
ab_Topt_H=params(17);   bl_Sopt_A=params(18);   ab_Sopt_A=params(19);
bl_Sopt_H=params(20);   ab_Sopt_H=params(21);   T_hs=params(22);
beta=params(23);        delta_V=params(24);     sigma=params(25);
T_cs=params(26);
alpha=params(27);       S_d_s=params(28);   % T_d_s=params(29);  UNUSED
xtr_c_s=params(30);
alpha_h=params(31);     epsilon=params(32);
omega=params(33);       rho=params(34);         kappa=params(35);
psi=params(36);         delta_D=params(37);     c=params(38);

F_DR_MAX = 100;

% cACHED ENVIRONMENTAL FORCING
% rebuilt only when county or the climate-shift arguments change.
persistent CACHE_KEY BRK CF NB DBR TFpp SMpp
cache_key = [county, temp_shift, alpha_PZI, beta_PZI];
if isempty(CACHE_KEY) || ~isequal(CACHE_KEY, cache_key)

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

    switch county
    case 1   % arizona
        temp_data=[38.6; 42.2; 54.8; 59.4; 67.4; 79.5; 81.0; 78.5; 72.4; 58.8; 51.3;...
        41.5; 46.5; 50.0; 53.9; 59.1; 66.8; 77.7; 81.4; 76.5; 74.2; 64.9; 51.7; 44.3; 45.1;...
        52.0; 56.3; 58.4; 62.9; 78.4; 78.6; 80.6; 75.0; 64.5; 48.3; 40.9; 41.8; 50.6; 54.9;...
        58.5; 64.6; 80.3; 82.4; 77.5; 71.6; 66.1; 53.1; 44.7; 42.3; 49.4; 56.6; 59.9; 66.1;...
        79.8; 81.5; 79.1; 72.4; 65.1; 57.6; 46.6; 47.6; 46.7; 52.3; 62.9; 68.5; 78.6; 82.3;...
        80.2; 76.0; 59.9; 49.4; 42.8; 42.4; 40.9; 51.7; 60.3; 60.7; 75.2; 81.9; 81.9; 73.8;...
        60.0; 52.1; 42.2; 43.7; 45.9; 51.0; 59.3; 70.5; 76.8; 82.8; 84.1; 75.6; 66.2; 53.5;...
        42.0; 42.6; 46.5; 49.4; 61.2; 67.9; 80.6; 81.4; 79.5; 74.8; 59.9; 55.8; 45.6; 43.5;...
        44.0; 51.8; 60.5; 68.6; 78.6; 82.2; 79.0; 75.9; 61.8; 46.1; 42.8; 40.3; 41.9; 47.2;...
        58.4; 66.5; 72.4; 85.4; 80.7; 73.6; 64.4; 52.6; 45.4];
        soil_mstr_data=[10.62;9.22;8.26;7.91;8.25;7.71;11.94;10.43;11.66;8.52;12.04;...
        8.76;7.16;6.9;8.03;7.26;7.22;6.88;9.67;12.5;12.95;8.7;7.98;10.2;10.95;8.23;8.67;8.47;...
        10.74;10.34;10.35;9.59;10.03;11.91;9.92;8.87;10.34;7.49;6.66;8.81;8.83;8.16;8.32;11.03;...
        10.42;7.91;9.67;11.41;12;10.17;7.85;8.52;10.04;8.96;12.46;8.01;8.45;7.26;6.84;7.38;7.64;...
        9.06;7.82;5.99;7.16;7.63;11.46;9.36;8.46;14.53;8.8;8.9;10.48;13.67;10.25;9.89;11.96;...
        10.88;7.47;6.54;10.97;7.91;14.44;11.23;8.92;10.21;12.52;10.47;11.24;9.56;6.77;5.54;6.75;...
        7.38;8.08;8.18;9.89;7.85;8.99;7.1;7;7.21;14.84;9.74;9.84;9.69;7.21;10.62;8.14;8.52;8.52;...
        6.77;6.97;8.74;10.66;12.3;10.1;10.64;9.4;10.35;12.34;10.55;12.46;9.84;11.96;10.83;6.61;...
        8.88;9.72;7.75;8.67;9.03];

    case 2   % maricopa
        temp_data=[50;52.9;65;69.8;78.2;88.5;91.4;89.6;83.2;69.2;62.1;52.3;...
        56.5;59.8;64.5;69.8;77.9;87.2;91.3;86.4;84.4;74.7;61.8;53.9;55.1;61.5;...
        67.2;68.8;73;88.1;89.4;92.3;85.6;74.7;58;50.7;51.7;61.8;65.6;69.2;74.7;...
        90.2;93.2;88.8;82.4;76.6;63.6;54.8;52;58.5;66.8;70.7;76.9;89.4;91.8;...
        90.4;82.8;76.2;67.4;56.9;58.4;56.2;62.6;73;78.1;87.1;91.9;90.3;87.4;...
        69.6;59.7;52.5;52.8;50.2;61.4;70.3;71.1;85.6;92.4;92.6;84.2;71;62.2;...
        52.5;53.5;55.7;60.3;69;81.2;86.7;94;94.7;87;76.6;63.9;52.9;53.2;57;59.9;...
        71.6;77.4;89.9;90.2;88.8;84.7;69.9;66.2;55.2;53.7;55;62.5;70.7;78;89;92;...
        89;86;72.4;55.5;51.5;50;52.6;56.8;68.7;76.5;81.7;96;92;84.2;74.9;63.2;55.6];
        soil_mstr_data=[11.19;9.57;9.05;8.3;8.4;8.6;10.31;9.64;10.95;8.72;...
        13.29;8.92;7.68;7.11;8.73;7.78;7.86;8.47;10.07;13.74;15.11;9.01;8.2;...
        10.15;10.2;7.97;8.1;8.49;10.23;9.47;8.95;7.89;9.81;11.29;9.41;8.75;10.84;...
        7.72;6.72;8.7;8.68;8.92;7.67;10.57;8.92;8.19;9.67;10.84;11;11.25;8.09;...
        8.62;9.25;8.84;12.26;8.76;8.04;7.75;7.43;7.89;7.82;8.77;7.47;7.25;7.91;...
        8.98;13.33;10.48;8.17;16.69;9.11;8.62;9.84;13.51;10.12;9.43;10.42;9.92;...
        8.32;7.2;13.61;8.33;14.64;10.86;8.77;10.93;13.42;11.24;11.26;8.67;7.06;...
        7.09;7.46;7.71;8.02;8.8;9.8;7.94;8.14;7.53;7.91;8.81;15.97;12.66;9.59;...
        9.52;7.61;11.6;8.49;8.95;7.88;7.87;8.12;9.31;10.8;12.56;9.97;10.21;9.47;...
        11.1;11.67;10.64;11.91;11.03;11.01;9.89;7.22;7.43;9.54;7.93;8.66;9.77];

    case 3   % pima
        temp_data=[48.0; 49.5; 62.7; 66.7; 74.4; 85.6; 85.3; 83.9; 79.8; 67.1; 60.2;...
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
        soil_mstr_data=[9.94;10.4;8.27;8.04;8.16;8.23;10.48;10.21;10.37;8.27;13.32;...
        9.16;7.62;7.18;8.27;8.11;8.05;7.98;10.59;11.6;12.03;10.55;8.23;10.35;12.34;8.45;...
        8.32;9.19;10.13;11.13;9.25;8.08;12.24;11.52;9.11;9.08;10.78;7.84;6.91;9.45;8.42;...
        9.86;8.24;9.57;10.93;7.81;8.95;10.14;10.71;9.14;6.89;7.94;8.67;8.17;12.31;7.77;7.77;...
        7.36;7.42;8.26;7.21;10.82;8;7.34;8.03;10.14;11.34;9.7;9.35;14.9;8.92;9.8;10.23;13.59;...
        10.56;10.04;10.95;10.3;7.42;8.54;13.23;8.06;14.66;11.59;9.49;10.36;11.7;10.99;10.51;...
        9.04;6.36;6.36;6.86;7.46;8.05;8.45;10.66;8.26;8.38;7.95;8.03;8.88;18.62;12.45;9.39;8.38;...
        7.63;9.82;8.41;8.51;7.73;7.73;7.96;10.1;10.83;12.76;10.19;10.15;8.83;10.62;11.38;10.98;...
        10.49;9.88;10.42;9.39;6.58;8.2;8.69;7.92;8.52;10.4];

    case 4   % pinal
        temp_data=[48.2; 50.5; 62.6; 67.6; 76.5; 87.3; 88.2; 86.7; 81.4; 68.4; 60.7;...
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
        soil_mstr_data= [10.82; 9.64; 9.20; 8.65; 8.65; 8.40; 11.98; 8.05; 9.70;...
        8.48; 12.07; 8.79; 7.53; 6.86; 8.95; 7.40; 7.51; 7.88; 8.81; 10.79; 14.72; 10.25;...
        7.99; 10.15; 11.68; 8.12; 7.78; 9.04; 10.83; 10.48; 9.33; 9.75; 13.02; 11.84; 9.73;...
        8.65; 10.84; 7.70; 6.75; 8.86; 8.33; 9.53; 7.85; 9.88; 9.85; 8.00; 9.60; 10.02; 10.87;...
        8.92; 7.26; 7.86; 8.61; 8.31; 13.30; 9.20; 7.85; 7.50; 7.19; 7.94; 7.67; 9.63; 7.46; 6.74;...
        7.52; 9.43; 11.60; 9.57; 10.68; 14.41; 9.01; 9.05; 9.83; 14.28; 9.55; 9.82; 10.37; 10.31;...
        8.35; 6.86; 11.60; 8.08; 14.76; 11.76; 9.24; 10.30; 11.11; 10.56; 11.07; 8.67; 6.74; 6.69;...
        7.18; 7.55; 8.15; 8.50; 9.84; 7.74; 8.15; 7.18; 7.49; 8.05; 18.35; 10.85; 11.11; 8.74; 7.43;...
        10.29; 9.01; 8.97; 8.48; 7.22; 7.47; 9.72; 9.13; 12.40; 9.67; 10.03; 9.01; 12.06; 11.71; 10.98;...
        10.68; 10.67; 11.82; 10.26; 6.83; 7.90; 9.35; 7.75; 8.99; 10.00];

    otherwise
        error('M4_SF_S: no region selected or invalid county input');
    end

% apply climate stress tests
    temp_data      = temp_data + temp_shift;
    soil_mstr_data = (alpha_PZI .* (soil_mstr_data - 10)) - beta_PZI + 10;

    TFpp = pchip(tind, temp_data);
    SMpp = pchip(tind, soil_mstr_data);
    BRK  = TFpp.breaks(:);   % identical breaks for both splines
    CF   = [TFpp.coefs, SMpp.coefs];   % 132 x 8
    NB   = numel(BRK);   % 133
    DBR  = (BRK(end) - BRK(1))/(NB-1);   % mean break spacing, for the O(1) guess
    CACHE_KEY = cache_key;
end

% o(1) interval lookup: breaks are ~monthly, so guess then walk
    j = min(max(floor((t - BRK(1))/DBR) + 1, 1), NB-1);
    while j > 1    && t <  BRK(j),   j = j - 1; end
    while j < NB-1 && t >= BRK(j+1), j = j + 1; end
    dt = t - BRK(j);
    TF  = ((CF(j,1)*dt + CF(j,2))*dt + CF(j,3))*dt + CF(j,4);
    S_m = ((CF(j,5)*dt + CF(j,6))*dt + CF(j,7))*dt + CF(j,8);

% eNVIRONMENTAL RESPONSE FUNCTIONS
if TF <= T_opt_A
    F_A_T = exp(-((TF-T_opt_A)^2/bl_Topt_A));
else
    F_A_T = exp(-((TF-T_opt_A)^2/ab_Topt_A));
end

if TF <= T_opt_H
    F_H_T = exp(-((TF-T_opt_H)^2/bl_Topt_H));
else
    F_H_T = exp(-((TF-T_opt_H)^2/ab_Topt_H));
end

if S_m <= S_opt_A
    F_A_S_m = exp(-((S_m-S_opt_A)^2/bl_Sopt_A));
else
    F_A_S_m = exp(-((S_m-S_opt_A)^2/ab_Sopt_A));
end

if S_m <= S_opt_H
    F_H_S_m = exp(-((S_m-S_opt_H)^2/bl_Sopt_H));
else
    F_H_S_m = exp(-((S_m-S_opt_H)^2/ab_Sopt_H));
end

if S_m < S_d_s
    F_dr = min(exp(((S_d_s-S_m)/S_d_s)*xtr_c_s), F_DR_MAX);
else
    F_dr = 1;
end

Nt   = S+E+I+R;
decT = (TF/T_decay)*delta_O;   % hoisted; only delta_O/T_decay is identified

dV = ((1/(1+exp(TF-T_hs)))-(1/(1+exp(TF-T_cs))))*beta*V - delta_V*V;
dO = delta_V*V - decT*O;
dD = decT*O + sigma*V - (mu_H*H*D) - delta_D*D;
dH = (alpha*A*V + phi_A*A + gamma_H*D*H*(F_H_T*F_H_S_m))*(1-(H/H_max)) - delta_H*H*F_dr;
dA = gamma_A*H*(F_A_T*F_A_S_m) - alpha*A*V - phi_A*A - delta_A*A;

dS = alpha_h*Nt - epsilon*S*A - (omega+c*Nt)*S;
dE = epsilon*S*A - psi*E - (omega+c*Nt)*E;
dI = psi*E - rho*I - kappa*I - (omega+c*Nt)*I;
dR = rho*I - (omega+c*Nt)*R;

dM4_SF_S = [dV;dO;dD;dH;dA;dS;dE;dI;dR];
end

% model 4 BBBBBBB

function dM5_SF = M5_SF(t, a, params, county, temp_shift, alpha_PZI, beta_PZI)
    if nargin < 5
        temp_shift = 0.0;
        alpha_PZI = 1.0;
        beta_PZI = 0.0;
    end
    if ~isscalar(t), error('M5_SF: scalar t only (inlined spline lookup)'); end
V=a(1); O = a(2); D = a(3); H = a(4); A = a(5); 
S=a(6); E = a(7); A_H=a(8); I =a(9); R =a(10);

k_ref=params(1);        Q_18=params(2);         T_ref=params(3);      
mu_H=params(4);         gamma_H=params(5);      H_max=params(6);        
delta_H=params(7);      gamma_A=params(8);      delta_A=params(9);      
phi_A=params(10);       T_opt_H=params(11);     T_opt_A=params(11)+params(12);
S_opt_H=params(14)+params(13);     S_opt_A=params(14);     
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
c=params(40);   % conv = params(47);

psi_A = 1.5*psi;

F_DR_MAX = 100;   % cap on the drought multiplier

% cACHED ENVIRONMENTAL FORCING
% rebuilt only when county or the climate-shift arguments change.
persistent CACHE_KEY BRK CF NB DBR TFpp SMpp
cache_key = [county, temp_shift, alpha_PZI, beta_PZI];
if isempty(CACHE_KEY) || ~isequal(CACHE_KEY, cache_key)

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

    switch county
    case 1   % arizona
        temp_data=[38.6; 42.2; 54.8; 59.4; 67.4; 79.5; 81.0; 78.5; 72.4; 58.8; 51.3;...
        41.5; 46.5; 50.0; 53.9; 59.1; 66.8; 77.7; 81.4; 76.5; 74.2; 64.9; 51.7; 44.3; 45.1;...
        52.0; 56.3; 58.4; 62.9; 78.4; 78.6; 80.6; 75.0; 64.5; 48.3; 40.9; 41.8; 50.6; 54.9;...
        58.5; 64.6; 80.3; 82.4; 77.5; 71.6; 66.1; 53.1; 44.7; 42.3; 49.4; 56.6; 59.9; 66.1;...
        79.8; 81.5; 79.1; 72.4; 65.1; 57.6; 46.6; 47.6; 46.7; 52.3; 62.9; 68.5; 78.6; 82.3;...
        80.2; 76.0; 59.9; 49.4; 42.8; 42.4; 40.9; 51.7; 60.3; 60.7; 75.2; 81.9; 81.9; 73.8;...
        60.0; 52.1; 42.2; 43.7; 45.9; 51.0; 59.3; 70.5; 76.8; 82.8; 84.1; 75.6; 66.2; 53.5;...
        42.0; 42.6; 46.5; 49.4; 61.2; 67.9; 80.6; 81.4; 79.5; 74.8; 59.9; 55.8; 45.6; 43.5;...
        44.0; 51.8; 60.5; 68.6; 78.6; 82.2; 79.0; 75.9; 61.8; 46.1; 42.8; 40.3; 41.9; 47.2;...
        58.4; 66.5; 72.4; 85.4; 80.7; 73.6; 64.4; 52.6; 45.4];
        soil_mstr_data=[10.62;9.22;8.26;7.91;8.25;7.71;11.94;10.43;11.66;8.52;12.04;...
        8.76;7.16;6.9;8.03;7.26;7.22;6.88;9.67;12.5;12.95;8.7;7.98;10.2;10.95;8.23;8.67;8.47;...
        10.74;10.34;10.35;9.59;10.03;11.91;9.92;8.87;10.34;7.49;6.66;8.81;8.83;8.16;8.32;11.03;...
        10.42;7.91;9.67;11.41;12;10.17;7.85;8.52;10.04;8.96;12.46;8.01;8.45;7.26;6.84;7.38;7.64;...
        9.06;7.82;5.99;7.16;7.63;11.46;9.36;8.46;14.53;8.8;8.9;10.48;13.67;10.25;9.89;11.96;...
        10.88;7.47;6.54;10.97;7.91;14.44;11.23;8.92;10.21;12.52;10.47;11.24;9.56;6.77;5.54;6.75;...
        7.38;8.08;8.18;9.89;7.85;8.99;7.1;7;7.21;14.84;9.74;9.84;9.69;7.21;10.62;8.14;8.52;8.52;...
        6.77;6.97;8.74;10.66;12.3;10.1;10.64;9.4;10.35;12.34;10.55;12.46;9.84;11.96;10.83;6.61;...
        8.88;9.72;7.75;8.67;9.03];

    case 2   % maricopa
        temp_data=[50;52.9;65;69.8;78.2;88.5;91.4;89.6;83.2;69.2;62.1;52.3;...
        56.5;59.8;64.5;69.8;77.9;87.2;91.3;86.4;84.4;74.7;61.8;53.9;55.1;61.5;...
        67.2;68.8;73;88.1;89.4;92.3;85.6;74.7;58;50.7;51.7;61.8;65.6;69.2;74.7;...
        90.2;93.2;88.8;82.4;76.6;63.6;54.8;52;58.5;66.8;70.7;76.9;89.4;91.8;...
        90.4;82.8;76.2;67.4;56.9;58.4;56.2;62.6;73;78.1;87.1;91.9;90.3;87.4;...
        69.6;59.7;52.5;52.8;50.2;61.4;70.3;71.1;85.6;92.4;92.6;84.2;71;62.2;...
        52.5;53.5;55.7;60.3;69;81.2;86.7;94;94.7;87;76.6;63.9;52.9;53.2;57;59.9;...
        71.6;77.4;89.9;90.2;88.8;84.7;69.9;66.2;55.2;53.7;55;62.5;70.7;78;89;92;...
        89;86;72.4;55.5;51.5;50;52.6;56.8;68.7;76.5;81.7;96;92;84.2;74.9;63.2;55.6];
        soil_mstr_data=[11.19;9.57;9.05;8.3;8.4;8.6;10.31;9.64;10.95;8.72;...
        13.29;8.92;7.68;7.11;8.73;7.78;7.86;8.47;10.07;13.74;15.11;9.01;8.2;...
        10.15;10.2;7.97;8.1;8.49;10.23;9.47;8.95;7.89;9.81;11.29;9.41;8.75;10.84;...
        7.72;6.72;8.7;8.68;8.92;7.67;10.57;8.92;8.19;9.67;10.84;11;11.25;8.09;...
        8.62;9.25;8.84;12.26;8.76;8.04;7.75;7.43;7.89;7.82;8.77;7.47;7.25;7.91;...
        8.98;13.33;10.48;8.17;16.69;9.11;8.62;9.84;13.51;10.12;9.43;10.42;9.92;...
        8.32;7.2;13.61;8.33;14.64;10.86;8.77;10.93;13.42;11.24;11.26;8.67;7.06;...
        7.09;7.46;7.71;8.02;8.8;9.8;7.94;8.14;7.53;7.91;8.81;15.97;12.66;9.59;...
        9.52;7.61;11.6;8.49;8.95;7.88;7.87;8.12;9.31;10.8;12.56;9.97;10.21;9.47;...
        11.1;11.67;10.64;11.91;11.03;11.01;9.89;7.22;7.43;9.54;7.93;8.66;9.77];

    case 3   % pima
        temp_data=[48.0; 49.5; 62.7; 66.7; 74.4; 85.6; 85.3; 83.9; 79.8; 67.1; 60.2;...
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
        soil_mstr_data=[9.94;10.4;8.27;8.04;8.16;8.23;10.48;10.21;10.37;8.27;13.32;...
        9.16;7.62;7.18;8.27;8.11;8.05;7.98;10.59;11.6;12.03;10.55;8.23;10.35;12.34;8.45;...
        8.32;9.19;10.13;11.13;9.25;8.08;12.24;11.52;9.11;9.08;10.78;7.84;6.91;9.45;8.42;...
        9.86;8.24;9.57;10.93;7.81;8.95;10.14;10.71;9.14;6.89;7.94;8.67;8.17;12.31;7.77;7.77;...
        7.36;7.42;8.26;7.21;10.82;8;7.34;8.03;10.14;11.34;9.7;9.35;14.9;8.92;9.8;10.23;13.59;...
        10.56;10.04;10.95;10.3;7.42;8.54;13.23;8.06;14.66;11.59;9.49;10.36;11.7;10.99;10.51;...
        9.04;6.36;6.36;6.86;7.46;8.05;8.45;10.66;8.26;8.38;7.95;8.03;8.88;18.62;12.45;9.39;8.38;...
        7.63;9.82;8.41;8.51;7.73;7.73;7.96;10.1;10.83;12.76;10.19;10.15;8.83;10.62;11.38;10.98;...
        10.49;9.88;10.42;9.39;6.58;8.2;8.69;7.92;8.52;10.4];

    case 4   % pinal
        temp_data=[48.2; 50.5; 62.6; 67.6; 76.5; 87.3; 88.2; 86.7; 81.4; 68.4; 60.7;...
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
        soil_mstr_data= [10.82; 9.64; 9.20; 8.65; 8.65; 8.40; 11.98; 8.05; 9.70;...
        8.48; 12.07; 8.79; 7.53; 6.86; 8.95; 7.40; 7.51; 7.88; 8.81; 10.79; 14.72; 10.25;...
        7.99; 10.15; 11.68; 8.12; 7.78; 9.04; 10.83; 10.48; 9.33; 9.75; 13.02; 11.84; 9.73;...
        8.65; 10.84; 7.70; 6.75; 8.86; 8.33; 9.53; 7.85; 9.88; 9.85; 8.00; 9.60; 10.02; 10.87;...
        8.92; 7.26; 7.86; 8.61; 8.31; 13.30; 9.20; 7.85; 7.50; 7.19; 7.94; 7.67; 9.63; 7.46; 6.74;...
        7.52; 9.43; 11.60; 9.57; 10.68; 14.41; 9.01; 9.05; 9.83; 14.28; 9.55; 9.82; 10.37; 10.31;...
        8.35; 6.86; 11.60; 8.08; 14.76; 11.76; 9.24; 10.30; 11.11; 10.56; 11.07; 8.67; 6.74; 6.69;...
        7.18; 7.55; 8.15; 8.50; 9.84; 7.74; 8.15; 7.18; 7.49; 8.05; 18.35; 10.85; 11.11; 8.74; 7.43;...
        10.29; 9.01; 8.97; 8.48; 7.22; 7.47; 9.72; 9.13; 12.40; 9.67; 10.03; 9.01; 12.06; 11.71; 10.98;...
        10.68; 10.67; 11.82; 10.26; 6.83; 7.90; 9.35; 7.75; 8.99; 10.00];

    otherwise
        error('M5_SF: no region selected or invalid county input');
    end

% apply climate stress tests
    temp_data      = temp_data + temp_shift;
    soil_mstr_data = (alpha_PZI .* (soil_mstr_data - 10)) - beta_PZI + 10;

    TFpp = pchip(tind, temp_data);
    SMpp = pchip(tind, soil_mstr_data);
    BRK  = TFpp.breaks(:);   % identical breaks for both splines
    CF   = [TFpp.coefs, SMpp.coefs];   % 132 x 8
    NB   = numel(BRK);   % 133
    DBR  = (BRK(end) - BRK(1))/(NB-1);   % mean break spacing, for the O(1) guess
    CACHE_KEY = cache_key;
end

% o(1) interval lookup: breaks are ~monthly, so guess then walk
    j = min(max(floor((t - BRK(1))/DBR) + 1, 1), NB-1);
    while j > 1    && t <  BRK(j),   j = j - 1; end
    while j < NB-1 && t >= BRK(j+1), j = j + 1; end
    dt = t - BRK(j);
    TF  = ((CF(j,1)*dt + CF(j,2))*dt + CF(j,3))*dt + CF(j,4);
    S_m = ((CF(j,5)*dt + CF(j,6))*dt + CF(j,7))*dt + CF(j,8);

% apply climate stress tests
% temp_data = temp_data + temp_shift;
% soil_mstr_data = (alpha_PZI .* (soil_mstr_data - 10)) - beta_PZI + 10;

% tFSpchip=pchip(tind,temp_data);
% tFSpline=spline(tind,temp_data);
% tF=ppval(TFSpchip, t);

% s_mpchip=pchip(tind,soil_mstr_data);
% s_mSpline=spline(tind,soil_mstr_data);
% s_m=ppval(S_mpchip, t);

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
% f_dr=exp(-((S_m-S_d_s)^2/bl_S_d_s))*exp(-((TF-T_d_s)^2/ab_T_d_s));
% else
% f_H_dr=1;
% end

% if S_m<S_d_s %&& TF>T_d_s %&& xtr_c_s*(S_d_s/S_m)*(TF/T_d_s)>1
% %F_H_dr=xtr_c_s*(S_d_s/S_m)*(TF/T_d_s);
% %F_dr=exp(((S_d_s-S_m)/S_d_s)*((TF-T_d_s)/T_d_s)*xtr_c_s);
% f_dr=exp(((S_d_s-S_m)/S_d_s)*xtr_c_s);
% else
% f_dr=1;
% end

if S_m < S_d_s
    F_dr = min(exp(((S_d_s-S_m)/S_d_s)*xtr_c_s), F_DR_MAX);
else
    F_dr = 1;
end

Nt = S+E+A_H+I+R;
kT = k_ref*Q_18^((TF-T_ref)/18);   % hoisted; was computed twice

dV = ((1/(1+exp(TF-T_hs)))-(1/(1+exp(TF-T_cs))))*beta*V - delta_V*V;
dO = delta_V*V - kT*O;
dD = kT*O + sigma*V - (mu_H*H*D) - delta_D*D;
dH = (alpha*A*V + phi_A*A + gamma_H*D*H*(F_H_T*F_H_S_m))*(1-(H/H_max)) - delta_H*H*F_dr;
% dA = gamma_A*H*(F_A_T*F_A_S_m) + conv*delta_H*H*(F_dr - 1) - alpha*A*V - phi_A*A - delta_A*A;
dA = gamma_A*H*(F_A_T*F_A_S_m) - alpha*A*V - phi_A*A - delta_A*A;

dS   = alpha_h*Nt - epsilon*S*A - (omega+c*Nt)*S;
dE   = epsilon*S*A - psi*E - psi_A*E - (omega+c*Nt)*E;
dA_H = psi_A*E - rho_A*A_H - (omega+c*Nt)*A_H;
dI   = psi*E - rho_I*I - kappa*I - (omega+c*Nt)*I;
dR   = rho_I*I + rho_A*A_H - (omega+c*Nt)*R;

dM5_SF = [dV;dO;dD;dH;dA;dS;dE;dA_H;dI;dR];
end

% model 4 BBBBBBB OLD

function [dm, mdm, hf, nTot, dbar] = dm_stats(dcells, h)
    dbar = 0;  nTot = 0;
    for q = 1:numel(dcells)
        if isempty(dcells{q}), continue; end
        dbar = dbar + sum(dcells{q});  nTot = nTot + numel(dcells{q});
    end
    if nTot == 0, dm = NaN; mdm = NaN; hf = NaN; dbar = NaN; return; end
    dbar = dbar / nTot;

    g0 = 0;  gk = zeros(h-1,1);
    for q = 1:numel(dcells)
        x = dcells{q};
        if isempty(x), continue; end
        x = x(:) - dbar;  nq = numel(x);
        g0 = g0 + sum(x.^2);
        for k = 1:h-1
            if nq > k, gk(k) = gk(k) + sum(x(1:nq-k).*x(1+k:nq)); end
        end
    end
    g0 = g0 / nTot;  gk = gk / nTot;
    V  = (g0 + 2*sum(gk)) / nTot;
    if V <= 0, V = eps; end   % can happen if the window over-subtracts
    dm  = dbar / sqrt(V);
    hf  = sqrt( (nTot + 1 - 2*h + (h*(h-1))/nTot) / nTot );
    mdm = dm * hf;
end

% level 1 resamples REGIONS with replacement, which is what accounts for the
% ~0.88 correlation of forecast errors across regions. Level 2 resamples
% contiguous blocks of months within each drawn region, which accounts for the
% ~2.8-month integrated autocorrelation time. The null is E[d] = 0, so the
% statistic is recentred before resampling.

function p = boot_p(dcells, nboot, blk)
    dcells = dcells(~cellfun(@isempty, dcells));
    R = numel(dcells);
    if R == 0, p = NaN; return; end
    obs = mean(cell2mat(cellfun(@(x) x(:), dcells, 'UniformOutput', false)));
    cnt = 0;
    for b = 1:nboot
        pick = randi(R, R, 1);
        acc = [];
        for q = 1:R
            x  = dcells{pick(q)}(:) - obs;   % recentre to the null
            nq = numel(x);
            nb = ceil(nq/blk);
            st = randi(max(nq-blk+1,1), nb, 1);
            idx = reshape((st + (0:blk-1))', [], 1);
            idx = idx(idx <= nq);
            acc = [acc; x(idx(1:min(numel(idx),nq)))];   % #ok<AGROW>
        end
        if abs(mean(acc)) >= abs(obs), cnt = cnt + 1; end
    end
    p = (cnt + 1) / (nboot + 1);   % add-one, so p is never exactly 0
end

% lOCAL FUNCTION FOR SECTION 20
% returns the monthly integrated incidence for model m at parameter vector p,
% by calling that model's own objective. This is the quantity the models are
% fitted to, and using the objective guarantees that y0, the solver chain and
% the monthly integration all match the fit exactly.

function S = nb_ic(y, mu, kfree, label)
    y = y(:);  mu = mu(:);
    if numel(y) ~= numel(mu)
        error('nb_ic:len', ...
              '%s: data has %d months, model has %d. The objective returned a short solution.', ...
              label, numel(y), numel(mu));
    end
    if any(~isfinite(mu)) || any(mu <= 0)
        error('nb_ic:mu', '%s: mu must be finite and strictly positive.', label);
    end
    if any(y < 0)
        error('nb_ic:y', '%s: negative counts.', label);
    end
    n = numel(y);

% definition 3 is the objective; definition 1 is the paper's published
% equation, reported alongside so the conclusion can be shown to survive
% either weighting.
    r            = y - mu;
    S.rrmse_mean = sqrt(mean(r.^2)) / mean(y);
    if all(y > 0)
        S.rrmse_obs = sqrt(mean((r ./ y).^2));
    else
        S.rrmse_obs = NaN;   % undefined at a zero count
    end

    nFrac = sum(abs(y - round(y)) > 1e-9);
    if nFrac > 0
        warning('nb_ic:noninteger', ...
            ['%s: %d of %d monthly counts are fractional (weekly-to-monthly ' ...
             'allocation). The NB expression is a quasi-likelihood, not a ' ...
             'probability mass. Rounded-series values printed for comparison.'], ...
            label, nFrac, n);
    end

    opt      = optimset('TolX', 1e-8);
    lk       = fminbnd(@(q) -nb_loglik(exp(q), y, mu), log(1e-3), log(1e6), opt);
    S.kappa  = exp(lk);
    S.logL   = nb_loglik(S.kappa, y, mu);

    p        = kfree + 1;
    S.n      = n;
    S.kfree  = kfree;
    S.p      = p;
    S.aic    = -2*S.logL + 2*p;
    if n - p - 1 > 0
        S.aicc = S.aic + 2*p*(p+1)/(n - p - 1);
    else
        S.aicc = NaN;
    end
    S.bic    = -2*S.logL + p*log(n);

    yr        = round(y);
    lkr       = fminbnd(@(q) -nb_loglik(exp(q), yr, mu), log(1e-3), log(1e6), opt);
    S.kappa_int = exp(lkr);
    S.logL_int  = nb_loglik(S.kappa_int, yr, mu);
    S.aic_int   = -2*S.logL_int + 2*p;
    S.bic_int   = -2*S.logL_int + p*log(n);

    s2           = mean(r.^2);
    S.logL_gauss = -0.5*n*(log(2*pi) + log(s2) + 1);
    S.aic_gauss  = -2*S.logL_gauss + 2*p;

    fprintf('\n%s information criteria (negative binomial, plug-in)\n', label);
    fprintf('  n = %d | free structural k = %d | p = k+1 = %d\n', n, kfree, p);
    fprintf('  RRMSE mean-normalised (objective) : %.6f\n', S.rrmse_mean);
    fprintf('  RRMSE per-observation (paper eq.) : %.6f\n', S.rrmse_obs);
    fprintf('  kappa_hat                         : %.4f\n', S.kappa);
    fprintf('  logL   : %.4f\n', S.logL);
    fprintf('  AIC    : %.4f\n', S.aic);
    fprintf('  AICc   : %.4f\n', S.aicc);
    fprintf('  BIC    : %.4f\n', S.bic);
    fprintf('  rounded series : kappa %.4f | AIC %.4f (%+.2f) | BIC %.4f\n', ...
            S.kappa_int, S.aic_int, S.aic_int - S.aic, S.bic_int);
    fprintf('  Gaussian all-constants, same p : AIC %.4f, so NB is %+.2f\n', ...
            S.aic_gauss, S.aic - S.aic_gauss);
end

function ll = nb_loglik(kappa, y, mu)
    kappa = max(kappa, realmin);
    ll = sum( gammaln(y + kappa) - gammaln(kappa) - gammaln(y + 1) ...
            + kappa .* log(kappa ./ (kappa + mu)) ...
            + y     .* log(mu    ./ (kappa + mu)) );
end

% sINGLE SOURCE OF TRUTH FOR THE PALMER Z-INDEX SERIES
% returns the monthly PZI series (132 values, UNTRANSFORMED) for a county.
% the bounds blocks need it to set LB(S_d_s) from the data; the RHS functions
% need it to build the pchip interpolant. One copy is the point: three
% inside a bounds block would go stale the moment the window is extended
% past 2024.
% data is VERBATIM from the M5_SF switch block, verified byte-identical to
% the M4_SF_S copy. The SSP transform is applied by the CALLER, never here,
% because the bounds are set on the calibration climate (alpha = 1, beta = 0).

function Z = pzi_series(county)
    switch county
    case 1   % arizona
        Z = [10.62;9.22;8.26;7.91;8.25;7.71;11.94;10.43;11.66;8.52;12.04;...
            8.76;7.16;6.9;8.03;7.26;7.22;6.88;9.67;12.5;12.95;8.7;7.98;10.2;10.95;8.23;8.67;8.47;...
            10.74;10.34;10.35;9.59;10.03;11.91;9.92;8.87;10.34;7.49;6.66;8.81;8.83;8.16;8.32;11.03;...
            10.42;7.91;9.67;11.41;12;10.17;7.85;8.52;10.04;8.96;12.46;8.01;8.45;7.26;6.84;7.38;7.64;...
            9.06;7.82;5.99;7.16;7.63;11.46;9.36;8.46;14.53;8.8;8.9;10.48;13.67;10.25;9.89;11.96;...
            10.88;7.47;6.54;10.97;7.91;14.44;11.23;8.92;10.21;12.52;10.47;11.24;9.56;6.77;5.54;6.75;...
            7.38;8.08;8.18;9.89;7.85;8.99;7.1;7;7.21;14.84;9.74;9.84;9.69;7.21;10.62;8.14;8.52;8.52;...
            6.77;6.97;8.74;10.66;12.3;10.1;10.64;9.4;10.35;12.34;10.55;12.46;9.84;11.96;10.83;6.61;...
            8.88;9.72;7.75;8.67;9.03];
    case 2   % maricopa
        Z = [11.19;9.57;9.05;8.3;8.4;8.6;10.31;9.64;10.95;8.72;...
            13.29;8.92;7.68;7.11;8.73;7.78;7.86;8.47;10.07;13.74;15.11;9.01;8.2;...
            10.15;10.2;7.97;8.1;8.49;10.23;9.47;8.95;7.89;9.81;11.29;9.41;8.75;10.84;...
            7.72;6.72;8.7;8.68;8.92;7.67;10.57;8.92;8.19;9.67;10.84;11;11.25;8.09;...
            8.62;9.25;8.84;12.26;8.76;8.04;7.75;7.43;7.89;7.82;8.77;7.47;7.25;7.91;...
            8.98;13.33;10.48;8.17;16.69;9.11;8.62;9.84;13.51;10.12;9.43;10.42;9.92;...
            8.32;7.2;13.61;8.33;14.64;10.86;8.77;10.93;13.42;11.24;11.26;8.67;7.06;...
            7.09;7.46;7.71;8.02;8.8;9.8;7.94;8.14;7.53;7.91;8.81;15.97;12.66;9.59;...
            9.52;7.61;11.6;8.49;8.95;7.88;7.87;8.12;9.31;10.8;12.56;9.97;10.21;9.47;...
            11.1;11.67;10.64;11.91;11.03;11.01;9.89;7.22;7.43;9.54;7.93;8.66;9.77];

    case 3   % pima
        Z = [9.94;10.4;8.27;8.04;8.16;8.23;10.48;10.21;10.37;8.27;13.32;...
            9.16;7.62;7.18;8.27;8.11;8.05;7.98;10.59;11.6;12.03;10.55;8.23;10.35;12.34;8.45;...
            8.32;9.19;10.13;11.13;9.25;8.08;12.24;11.52;9.11;9.08;10.78;7.84;6.91;9.45;8.42;...
            9.86;8.24;9.57;10.93;7.81;8.95;10.14;10.71;9.14;6.89;7.94;8.67;8.17;12.31;7.77;7.77;...
            7.36;7.42;8.26;7.21;10.82;8;7.34;8.03;10.14;11.34;9.7;9.35;14.9;8.92;9.8;10.23;13.59;...
            10.56;10.04;10.95;10.3;7.42;8.54;13.23;8.06;14.66;11.59;9.49;10.36;11.7;10.99;10.51;...
            9.04;6.36;6.36;6.86;7.46;8.05;8.45;10.66;8.26;8.38;7.95;8.03;8.88;18.62;12.45;9.39;8.38;...
            7.63;9.82;8.41;8.51;7.73;7.73;7.96;10.1;10.83;12.76;10.19;10.15;8.83;10.62;11.38;10.98;...
            10.49;9.88;10.42;9.39;6.58;8.2;8.69;7.92;8.52;10.4];
    case 4   % pinal
        Z = [10.82; 9.64; 9.20; 8.65; 8.65; 8.40; 11.98; 8.05; 9.70;...
            8.48; 12.07; 8.79; 7.53; 6.86; 8.95; 7.40; 7.51; 7.88; 8.81; 10.79; 14.72; 10.25;...
            7.99; 10.15; 11.68; 8.12; 7.78; 9.04; 10.83; 10.48; 9.33; 9.75; 13.02; 11.84; 9.73;...
            8.65; 10.84; 7.70; 6.75; 8.86; 8.33; 9.53; 7.85; 9.88; 9.85; 8.00; 9.60; 10.02; 10.87;...
            8.92; 7.26; 7.86; 8.61; 8.31; 13.30; 9.20; 7.85; 7.50; 7.19; 7.94; 7.67; 9.63; 7.46; 6.74;...
            7.52; 9.43; 11.60; 9.57; 10.68; 14.41; 9.01; 9.05; 9.83; 14.28; 9.55; 9.82; 10.37; 10.31;...
            8.35; 6.86; 11.60; 8.08; 14.76; 11.76; 9.24; 10.30; 11.11; 10.56; 11.07; 8.67; 6.74; 6.69;...
            7.18; 7.55; 8.15; 8.50; 9.84; 7.74; 8.15; 7.18; 7.49; 8.05; 18.35; 10.85; 11.11; 8.74; 7.43;...
            10.29; 9.01; 8.97; 8.48; 7.22; 7.47; 9.72; 9.13; 12.40; 9.67; 10.03; 9.01; 12.06; 11.71; 10.98;...
            10.68; 10.67; 11.82; 10.26; 6.83; 7.90; 9.35; 7.75; 8.99; 10.00];
    otherwise
        error('pzi_series:county', ...
              'county must be 1 (AZ), 2 (Maricopa), 3 (Pima) or 4 (Pinal), got %d', county);
    end
    Z = Z(:);
    if numel(Z) ~= 132
        error('pzi_series:len', 'county %d returned %d values, expected 132', county, numel(Z));
    end
end

%% =======================================================================
% shared by SECTION 23 (climate scenarios) and SECTION 24 (baseline), so
% the APV integrals exist in exactly ONE place. Every premium in the
% actuarial manuscript comes through act_premiums; every Lambda comes
% through act_lambda.
% uNITS CONVENTION, stated once and relied on everywhere below.
% trajectories arrive on a DAILY grid in days since the window start.
% all actuarial integrals are evaluated in YEARS: tyr = (t - t(1))/365.
% benefit streams are supplied as an ANNUAL OUTGO RATE in dollars/year,
% so a premium is dollars per person per year directly, with no
% trailing 365 factor to lose track of.
% this convention is verified against three relationships the manuscript
% already reports and which any correct implementation must reproduce:
% pi_D / pi_B  = 59320/10000 = 5.932   (both pure lump sums)
% pi_A / pi_B  = (B_A/B_LS)*(mean I-duration in yr)   -> about 83 days
% pi_C         = pi_A + pi_B + pi_death   (exactly additive)
% act_selfcheck below asserts all three.
%% =======================================================================