% Local Sensitivity Analysis for the Models
% Forward Sensitivity Analysis (FSA)

clear; clc; close all;

%% 1: Define Initial Conditions and Parameters
% 
fprintf('Setting up the expanded model...\n');
global alpha_h_maricopa omega_maricopa alpha_h_pinal omega_pinal alpha_h_pima omega_pima c_pima alpha_h_AZ omega_AZ c_AZ c_pinal c_maricopa county
alpha_h_maricopa=  0.000500942192598+0.009093982014202; omega_maricopa= 0.009093982014202; c_maricopa= 0.000500942192598/4724819.974562017247081;
alpha_h_pinal=  0.000076238824090+0.013000000; omega_pinal= 0.013000000; c_pinal= 0.000076238824090/5162630.000;
alpha_h_pima= 0.000019432499300+0.011779189791583; omega_pima= 0.011779189791583; c_pima=0.000019432499300/10639930.00;
alpha_h_AZ= 0.000304888503016+0.012996549609670; omega_AZ= 0.012996549609670; c_AZ=0.000304888503016/7853513.125630123540759;

%import/load data
y_pop_data_Maricopa=[3912523,3944859,4094842,4174423,4258019,4307033,4405306,4492261,4420568,4500147,4586431,4585871];
 y_pop_data_Pinal=[389237,392627,400229,409058,420111,432159,444369,457288,462789,480299,503184,516263];
 y_pop_data_AZ=[6594981,6634984,6733840,6832810,6944767,7048088,7158024,7275070,7151502,7272499,7366720,7431344];
 y_pop_data_Pima=[996046.5,998668,1005699,1012028,1018638,1024476,1030517,1036290,1043433,1051707,1063162,1063993];
    t_pop_data=[0,181, 546, 911,1277,1642,2007,2372,2647,3103,3468,3833];

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
alpha_h_b=alpha_h_maricopa;
omega_b=omega_maricopa;
c=c_maricopa;
county=2; %1=AZ, 2=Maricopa, 3=Pima, 4=Pinal

%   Initial Conditions for the state variables  
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
ic_I_M2=y_inf_data(1);
ic_E_M2=ic_I_M2*1.5;
ic_R_M2=ic_I_M2/2;
ic_S_M2=(y_pop_data(1)-ic_I_M2-ic_E_M2-ic_R_M2);
y0_M2=[ic_O_M2;ic_D_M2;ic_H_M2;ic_A_M2;ic_S_M2;ic_E_M2;ic_I_M2;ic_R_M2];

ic_O_M3=40;
ic_D_M3=70;
ic_H_M3=100;%
ic_A_M3=50;%100
ic_I_M3=y_inf_data(1)/1;
ic_E_M3=ic_I_M3*1.5;%y_inf_data(1);
ic_R_M3=ic_I_M3/2;
ic_S_M3=(y_pop_data(1)-ic_I_M3-ic_E_M3-ic_R_M3);
y0_M3=[ic_O_M3;ic_D_M3;ic_H_M3;ic_A_M3;ic_S_M3;ic_E_M3;ic_I_M3;ic_R_M3];

ic_V_M4=5000;
ic_O_M4=40;
ic_D_M4=70;
ic_H_M4=100;%
ic_A_M4=50;%100
ic_I_M4=y_inf_data(1)/1;
ic_E_M4=ic_I_M4*1.5;%y_inf_data(1);
ic_R_M4=ic_I_M4/2;
ic_S_M4=(y_pop_data(1)-ic_I_M4-ic_E_M4-ic_R_M4);
y0_M4=[ic_V_M4;ic_O_M4;ic_D_M4;ic_H_M4;ic_A_M4;ic_S_M4;ic_E_M4;ic_I_M4;ic_R_M4];


ic_V_M5=5000;
ic_O_M5=40;
ic_D_M5=70;
ic_H_M5=100;%
ic_A_M5=50;%100
ic_I_M5=y_inf_data(1)/1;
ic_E_M5=ic_I_M5*1.5;%y_inf_data(1);
ic_A_H_M5=y_inf_data(1);
ic_R_M5=ic_I_M5/2;
ic_S_M5=(y_pop_data(1)-ic_I_M5-ic_A_H_M5-ic_E_M5-ic_R_M5);
y0_M5=[ic_V_M5;ic_O_M5;ic_D_M5;ic_H_M5;ic_A_M5;ic_S_M5;ic_E_M5;ic_A_H_M5;ic_I_M5;ic_R_M5];

%   Parameter Vector  
% Model 1 params.
params_m1pswarm_AZ = [5.000000213974856; 0.099390302013234; 0.003370870497779; 449.999999990966899; 0.000001000000000; 0.013301571126986; 0.000000007540346; 0.012996419644233; 0.010991015603968; 0.000000027774795; 0.059999915200265; 0.000000000038818];
params_m1pswarm_maricopa = [97.165767418699360; 0.000000010001062; 0.000000010514845; 366.991426266461190; 0.000250206239107; 0.009594828259174; 0.000000015389053; 0.009094072912238; 0.025609408790025; 0.000039471600034; 0.000000100009981; 0.000000000106034];
params_m1pswarm_pima = [5.388562613310274; 0.074965810236379; 0.002843893509778; 296.122677525708696; 0.000001000015034; 0.011798740276497; 0.000000015064353; 0.011779072001171; 0.031630655343866; 0.000000028140359; 0.000000180161092; 0.000000000001826];
params_m1pswarm_pinal = [26.290472407474166; 0.094972860707902; 0.000653669593506; 449.999999818803417; 0.000001000000000; 0.013076369586292; 0.000000011886973; 0.012999870000005; 0.015841990671434; 0.000000028030143; 0.059999977763712; 0.000000000014766];
params_m1pswarm_rss_AZ = [];
params_m1pswarm_rss_maricopa=[];
params_m1pswarm_rss_pima=[];
params_m1pswarm_rss_pinal = [];

p_vec_M1 = params_m1pswarm_pinal;


% Model 2 params.
params_m2pswarm_pinal = [486.459502119280387; 0.265661792427023; 0.008324617361831; 0.059236544140716; 273.592618174392442; 0.186420845132248; 0.000146994330715; 0.000227777529742; 0.000009701592462; 0.013076151736099; 0.000000098462392; 0.013000034175653; 0.046396678714305; 0.000350174083736; 0.093196691768260; 0.050081874291348; 0.000000000014769];
params_m2pswarm_pima = [1999.960396988704588; 0.487091582457780; 0.000000102447824; 0.000000013895684; 210.005320246146056; 0.000242857347208; 0.020526112385457; 0.195044218833187; 0.000008885989897; 0.011798504391759; 0.000000597141011; 0.011779307537755; 0.071427627967263; 0.000358733558199; 0.190825360897621; 0.030643610473123; 0.000000000001826];
params_m2pswarm_maricopa = [12.009184077970165; 0.000012479444954; 0.064297691388861; 0.059557086198422; 278.877918641923316; 0.000179721829940; 0.052922519969899; 0.103105927945381; 0.000000238747516; 0.009594828257558; 0.000000078634049; 0.009094072061152; 0.051809932800508; 0.000273135217063; 0.120418480147931; 0.059999253816849; 0.000000000106034];
params_m2pswarm_AZ = [29.274639606083220; 0.000022025443199; 0.045867906986940; 0.007734782897665; 210.037612376230697; 0.000146924878005; 0.100000000000000; 0.160043337065191; 0.000000000100000; 0.013301504007152; 0.000000074612543; 0.012996440452383; 0.051557237876289; 0.000007581047130; 0.164509987653159; 0.060000000000000; 0.000000000038821]; 
params_m2pswarm_rss_AZ = [];
params_m2pswarm_rss_maricopa=[];
params_m2pswarm_rss_pima=[];
params_m2pswarm_rss_pinal = [];

p_vec_M2=params_m2pswarm_pima;


% Model 3 params.
params_m3pswarm_AZ = [928.800826598053277; 0.223896506636758; 0.022779648263965; 0.013093136144223; 370.567252745030657; 0.078322771038972; 0.059373049030822; 0.000875046105468; 0.000078563276998; 65.557253579930276; 87.830316624641128; 10.946815678600590; 6.513247178028903; 64.447655717351225; 607.596936812160379; 61.963488845020329; 650.280480887803151; 81.397382101077554; 3.770034387293375; 5.663506833080457; 0.000000000000000; 18.265581194928931; 0.013301557545234; 0.000000057316351; 0.012996613029619; 0.013523139056581; 0.000000027768000; 0.016935861259442; 0.054007817390369; 0.000000000038819];  
params_m3pswarm_maricopa = [34.797283575249359; 0.010203121559188; 0.097154638162951; 0.011673223319976; 447.561915692615457; 0.010297748461996; 0.020152709106333; 0.002349495951927; 0.000022366115277; 84.772441132492517; 87.155187499276835; 10.107537752214565; 7.587674369063744; 57.232303263497691; 351.524532950856212; 86.349419383388252; 336.668493135102892; 98.578307730516599; 1.000000000000000; 6.896671542445246; 0.000000000000000; 19.924336902493064; 0.009594832293388; 0.000000067148175; 0.009094072916825; 0.032277583928722; 0.000210210554235; 0.031243876542251; 0.048856904466807; 0.000000000106018]; 
params_m3pswarm_pima = [681.487151265097168; 0.146417785594639; 0.000901320994652; 0.054515154249054; 345.228586092589182; 0.023762065711746; 0.093819451588098; 0.001928900015723; 0.000100000000000; 65.003749465564127; 79.752451256037531; 10.362091966534251; 9.973067028012782; 57.562438469085301; 323.115800962983371; 87.825544194349519; 684.874761286274406; 99.136491055698954; 14.719010062441672; 0.409618604053320; 0.000000000000000; 2.645282221454207; 0.011798691646151; 0.000000001552076; 0.011779079748868; 0.010455375875152; 0.000201237088547; 0.020577911873073; 0.023021704733093; 0.000000000001827];
params_m3pswarm_pinal = [];
params_m3pswarm_rss_AZ = [];
params_m3pswarm_rss_maricopa=[];
params_m3pswarm_rss_pima=[];
params_m3pswarm_rss_pinal = [];

p_vec_M3=params_m3pswarm_pima;


% Model 4 params.
params_m4pswarm_AZ = [];
params_m4pswarm_maricopa=[0.000012248841562; 0.002755384784146; 0.059774113441846; 316.030264253547159; 0.004883048158971; 0.014005231621580; 0.004762092658768; 0.000000271957330; 81.445031815708461; 87.802054923843102; 12.751705685920436; 8.691019929284831; 55.008980119412229; 545.344754901688475; 99.539711623585987; 436.706929825225245; 85.699874198011017; 19.912013353578292; 3.264382790936637; 2.634502716114889; 7.999697027148411; 79.437110349958928; 0.029999465728748; 0.012218811228280; 0.000000000016249; 60.864962338865368; 0.000000000604163; 7.104685324601907; 31.000000000000000; 19.925691708181642; 0.009594852944538; 0.000000045660277; 0.009094072571648; 0.025731998466955; 0.000046817981383; 0.029410878162346; 0.022903568681974; 0.000000000106013];
params_m4pswarm_pima = [];
params_m4pswarm_pinal = [];
params_m4pswarm_rss_AZ = [];
params_m4pswarm_rss_maricopa=[];
params_m4pswarm_rss_pima=[];
params_m4pswarm_rss_pinal = [];

p_vec_M4 = params_m4pswarm_maricopa;


%Model 5 params.
params_m5pswarm_AZ = [];
params_m5pswarm_maricopa= [0.019512032058800; 3.498725750391695; 79.653776227041035; 0.097806495255086; 0.019992035348106; 422.427310336405242; 0.006847719815021; 0.098539301493923; 0.006490567951868; 0.000002926090050; 82.009745921919830; 83.943372079590574; 12.245769258226961; 7.719798193489918; 696.773124111514562; 53.362011110600520; 493.360484541273252; 98.406196756217511; 2.133369041550432; 7.977525941935307; 5.425753795860905; 7.918787650960449; 83.313264280267887; 0.019975584333302; 0.002824686281497; 0.000000000691471; 74.010836609711163; 0.000000001230182; 7.042855387175551; 95.000000000000000; 19.742780497265141; 0.009595002326041; 0.000000012223498; 0.009093956864998; 0.022985256047066; 0.000060314554319; 0.045886628790181; 0.004730305873437; 0.020568056721161; 0.000000000106021];
params_m5pswarm_pima = [];
params_m5pswarm_pinal = [];
params_m5pswarm_rss_AZ = [];
params_m5pswarm_rss_maricopa=[];
params_m5pswarm_rss_pima=[];
params_m5pswarm_rss_pinal = [];

p_vec_M5 = params_m5pswarm_maricopa;

%Time Span for Simulation
tspan = [0 4017];

%% 2: Config/Run Sensitivity Analysis
fprintf('Configuring and running Forward Sensitivity Analysis...\n');

%: Create and configure ode 
F = ode;
F.ODEFcn = @M5_SF; 
%F.ODEFcn = @M4_SF_S;         % Assign ODE function
%F.ODEFcn = @M3_SF;
%F.ODEFcn = @M2_SF;
%F.ODEFcn = @M1_SF_T;
F.InitialValue = y0_M5;        % Assign ICs
F.Parameters = p_vec_M5;       % Assign parameter values
p_vec=p_vec_M5;
% 2: Enable Forward Sensitivity Analysis 
F.Sensitivity = odeSensitivity;

%3: Solve the augmented system 
sol = solve(F, tspan(1), tspan(2));

fprintf('Analysis complete. Processing results...\n');

%%  3: Process and Visualize Results
% 
% This section extracts the solution and sensitivity data, calculates the
% normalized sensitivities, and creates plots.

%Extract Results from  'sol' 
time_vec = sol.Time;
y_sol = sol.Solution;           % Solution matrix: 10 states (rows) x N_time (cols)
sens_raw = sol.Sensitivity;     % Raw sensitivity array: 10 states x 38 params x N_time

%Plot the Model Dynamics 
state_names_M1 = {'D', 'H', 'S', 'I', 'R'};
%D = a(1); H = a(2); S=a(3); I=a(4); R=a(5); 
state_names_M2 = {'O', 'D', 'H', 'A', 'S', 'E', 'I', 'R'}; 
% O = a(1); D = a(2); H = a(3); A = a(4); 
% S = a(5); E = a(6);I = a(7); R = a(8);
state_names_M3 = {'O', 'D', 'H', 'A', 'S', 'E', 'I', 'R'};
% O = a(1); D = a(2); H = a(3); A = a(4); 
% S = a(5); E = a(6); I = a(7); R = a(8);
state_names_M4 = {'V', 'O', 'D', 'H', 'A', 'S', 'E', 'I', 'R'};
%V=a(1); O = a(2); D = a(3); H = a(4); A = a(5); 
% S= a(6); E= a(7); I= a(8); R= a(9);
state_names_M5 = {'V', 'O', 'D', 'H', 'A', 'S', 'E', 'A_H', 'I', 'R'};
% V=a(1); O = a(2); D = a(3); H = a(4); A = a(5); 
% S=a(6); E = a(7); A_H=a(8); I =a(9); R =a(10);
state_names=state_names_M5;
figure('Name', 'Model State Dynamics');
plot(time_vec, y_sol, 'LineWidth', 2);
title('Dynamics of Model States Over Time');
xlabel('Time (days)');
ylabel('State Value');
legend(state_names, 'Location', 'best');
grid on;
axis tight;

% Calculate Normalized Sensitivities 
% Formula: S_norm = (dy/dp) * (p/y)
num_states = size(y_sol, 1);
num_params = length(p_vec);
sens_norm = zeros(size(sens_raw)); % Pre-allocate for speed

for i = 1:num_states
    for j = 1:num_params
        raw_ij = squeeze(sens_raw(i, j, :));
        state_i_series = y_sol(i, :);
        param_j_val = p_vec(j);
        sens_norm(i, j, :) = raw_ij'.* (param_j_val./ (state_i_series + eps));
    end
end


%  Visualize a Subset of Normalized Sensitivities 

state_to_plot_idx = 9;            %m1=4, m2=7, m3=7, m4=8, m5=9
params_to_plot_idx = num_params; 
% Define names for parameters 
param_names_M5 = {'k_{ref}','Q_{10}','T_{ref}', '\mu_H', '\gamma_H', 'H_{max}',...
    '\delta_H','\gamma_A', '\delta_A', '\phi_A', 'T_{opt_H}', 'T_{opt_A}',...
    'S_{opt_H}', 'S_{opt_A}', 'bl_{Top_A}', 'ab_{Top_A}','bl_{Top_H}', 'ab_{Top_H}',...
    'bl_{Sop_A}', 'ab_{Sop_A}','bl_{Sop_H}', 'ab_{Sop_H}', 'T_{hs}', '\beta',...
    '\delta_V', '\sigma','T_{cs}', '\alpha', 'S_{ds}', 'T_{ds}', ...
    'xtr_{cs}', '\alpha_h','\epsilon', '\omega', '\rho_I', '\kappa', ...
    '\psi','\delta_D','\rho_{A_H}','c'};  
% k_ref=params(1);        Q_18=params(2);         T_ref=params(3);      
% mu_H=params(4);         gamma_H=params(5);      H_max=params(6);        
% delta_H=params(7);      gamma_A=params(8);      delta_A=params(9);      
% phi_A=params(10);       T_opt_H=params(11);     T_opt_A=params(12);
% S_opt_H=params(13);     S_opt_A=params(14);     
% bl_Topt_A=params(15);   ab_Topt_A=params(16);   bl_Topt_H=params(17); 
% ab_Topt_H=params(18);   bl_Sopt_A=params(19);   ab_Sopt_A=params(20); 
% bl_Sopt_H=params(21);   ab_Sopt_H=params(22);   T_hs=params(23);
% beta=params(24);        delta_V=params(25);
% sigma=params(26);       T_cs=params(27); 
% alpha=params(28);       S_d_s=params(29);       T_d_s=params(30); 
% xtr_c_s=params(31);
% alpha_h=params(32);     epsilon=params(33);     
% omega=params(34);       rho_I=params(35);         kappa=params(36);
% psi=params(37);        delta_D=params(38);      rho_A=params(39);
% c=params(40);
param_names_M4 = {'\delta_O', '\mu_H', '\gamma_H', 'H_{max}', '\delta_H','\gamma_A',... 
    '\delta_A', '\phi_A',  'T_{op_H}', 'T_{op_A}','S_{op_H}', 'S_{op_A}',...
    'T_{decay}', 'bl_{Top_A}', 'ab_{Top_A}','bl_{Top_H}', 'ab_{Top_H}', 'bl_{Sop_A}',...
    'ab_{Sop_A}','bl_{Sop_H}', 'ab_{Sop_H}', 'T_{hs}', '\beta', '\delta_V',...
    '\sigma','T_{cs}', '\alpha', 'S_{ds}', 'T_{ds}', 'xtr_{cs}',...
    '\alpha_h', '\epsilon', '\omega', '\rho', '\kappa','\psi',...
    '\delta_D','c'};
% delta_O=params(1);      mu_H=params(2);
% gamma_H=params(3);      H_max=params(4);        delta_H=params(5);
% gamma_A=params(6);      delta_A=params(7);      phi_A=params(8);
% T_opt_H=params(9);     T_opt_A=params(10);
% S_opt_H=params(11);     S_opt_A=params(12);     T_decay=params(13);
% bl_Topt_A=params(14);   ab_Topt_A=params(15);   bl_Topt_H=params(16); 
% ab_Topt_H=params(17);   bl_Sopt_A=params(18);   ab_Sopt_A=params(19); 
% bl_Sopt_H=params(20);   ab_Sopt_H=params(21);   T_hs=params(22);
% beta=params(23);        delta_V=params(24);     sigma=params(25); 
% T_cs=params(26); 
% alpha=params(27);       S_d_s=params(28);       T_d_s=params(29); 
% xtr_c_s=params(30);
% alpha_h=params(31);        epsilon=params(32);     
% omega=params(33);        rho=params(34);     kappa=params(35);
% psi=params(36);       delta_D=params(37);    c=params(38);  
param_names_M3={'\Pi','\delta_O', '\mu_H', '\gamma_H', 'H_{max}', '\delta_H',...
    '\gamma_A', '\delta_A', '\phi_A', 'T_{opt_H}', 'T_{opt_A}','S_{opt_H}',...
    'S_{opt_A}', 'T_{decay}', 'bl_{Top_A}', 'ab_{Top_A}','bl_{Top_H}', 'ab_{Top_H}',...
    'bl_{Sop_A}', 'ab_{Sop_A}', 'bl_{Sop_H}', 'ab_{Sop_H}', '\alpha_h','\epsilon',...
    '\omega', '\rho', '\kappa', '\psi','\delta_D','c'};
% PI=params(1);         delta_O=params(2); mu_H=params(3);
% gamma_H=params(4);    H_max=params(5); delta_H=params(6);
% gamma_A=params(7);    delta_A=params(8); phi_A=params(9);
% T_opt_H=params(10); T_opt_A=params(11);
% S_opt_H=params(12);   S_opt_A=params(13); T_decay=params(14);
% bl_Topt_A=params(15); ab_Topt_A=params(16); bl_Topt_H=params(17); 
% ab_Topt_H=params(18); bl_Sopt_A=params(19); ab_Sopt_A=params(20); 
% bl_Sopt_H=params(21); ab_Sopt_H=params(22);  alpha_h=params(23);      
% epsilon=params(24);   omega=params(25);        
% rho=params(26);       kappa=params(27);         psi=params(28);
% delta_D=params(29);    c=params(30);
param_names_M2={'\Pi','\delta_O','\mu_H','\gamma_H','H_{max}','\delta_H',...
    '\gamma_A','\delta_A','\phi_A','\alpha_h','\epsilon','\omega',...
    '\rho','\kappa','\psi','\delta_D','c'};
% PI=params(1);           delta_O=params(2);      mu_H=params(3);
% gamma_H=params(4);      H_max=params(5);        delta_H=params(6);
% gamma_A=params(7);      delta_A=params(8);      phi_A=params(9);
% alpha_h=params(10);    
% epsilon=params(11);     omega=params(12);       rho=params(13);
% kappa=params(14);       psi=params(15);     delta_D=params(16);
% c=params(17);
param_names_M1={'\delta_O','\mu_H', '\gamma_H', 'H_{max}', '\delta_H', '\alpha_h',...
    '\epsilon', '\omega', '\rho', '\kappa','\delta_D','c'};
% O=params(1);         mu_H=params(2);       gamma_H=params(3); 
% H_max=params(4);     delta_H=params(5);    alpha_h=params(6);      
% epsilon=params(7);   omega=params(8);      rho=params(9);
% kappa=params(10);    delta_D=params(11);   c=params(12);

param_names=param_names_M5;

figure('Name', 'Subset of Normalized Sensitivities');
sgtitle(sprintf('Normalized Sensitivity of State ''%s'' to Selected Parameters', state_names{state_to_plot_idx}), 'FontSize', 16, 'FontWeight', 'bold');

tl = tiledlayout('flow', 'TileSpacing', 'compact', 'Padding', 'compact');
for j = params_to_plot_idx
    nexttile;
    plot(time_vec, squeeze(sens_norm(state_to_plot_idx, j, :)), 'LineWidth', 2);
    title(sprintf('Parameter: %s', param_names{j}), 'Interpreter', 'tex');
    grid on;
    xlabel('Time (days)');
    ylabel('Normalized Sensitivity');
end

fprintf('Visualization complete.\n');

%% 4 : Bar Graph for State 'I' Sensitivity
% calculates the integrated normalized sensitivity for each parameter's effect on I and plots results
fprintf('Creating colored sensitivity bar graph for State ''I''...\n');

% Define the state of interest
state_I_idx = 9;   %m1=4, m2=7, m3=7, m4=8, m5=9
state_name_for_title = ["I"];

% Calculate Integrated Absolute Normalized Sensitivity for I
num_params = length(p_vec);
sensitivity_for_I = zeros(num_params, 1);

% Loop through each parameter
for j = 1:num_params
    % Extract the normalized sensitivity vector for State 'I'
    Sj_norm_for_I = squeeze(sens_norm(state_I_idx, j, :));
    
    % Handle any potential NaN or Inf values from normalization
    Sj_norm_for_I(isnan(Sj_norm_for_I) | isinf(Sj_norm_for_I)) = 0;

    % Integrate the absolute normalized sensitivity over time.
    sensitivity_for_I(j) = trapz(time_vec, abs(Sj_norm_for_I));
end
% M1_sens_AZ= [882.345621392022849; 889.618811610937428; 891.657140483316084; 1654.935019521881259; 4.380774654671449; 74465.685214740646188; 3960.569873639402886; 74878.218656401295448; 1794.174549332015431; 0.004547452690156; 2.014462669516251; 1559.192584367983727];
% M1_sens_maricopa=[871.327561502457002; 1.547684048912200; 872.051075314432410; 2397.749677999076084; 617.736490772508205; 44394.535018797614612; 3979.203857589063773; 43104.631349481642246; 2893.381655657007286; 4.477014440659675; 0.067705909761483; 2144.356967613258348];
% M1_sens_pima=[399.727268343713035; 404.452473848070667; 404.473325014233183; 2481.041386198739929; 3.579680186557340; 93870.291584033577237; 3985.014244917727865; 94795.846410884536454; 2909.093404911280231; 0.002606766329101; 0.000004098082561; 14.992965134464614];
% M1_sens_pinal=[885.026307831452982; 884.737650274224734; 886.841994333026378; 1719.369426136936454; 4.281354042538503; 102777.696230398374610; 3971.974188483724902; 103959.757215824414743; 2174.593619751894948; 0.003873097753449; 2.079174223655297; 50.622992551830613];
% M1_sens_mean=(M1_sens_AZ+M1_sens_maricopa+M1_sens_pima+M1_sens_pinal)/4;
% M2_sens_AZ=[747.689467326350155; 735.691395005731920; 813.298495101737558; 821.653254514404011; 1968.583651178489845; 372.577909234904496; 3975.905658811105695; 3971.153853956147941; 0.000053624439378; 75532.518664542440092; 3978.744076593472073; 74895.525937432888895; 3183.873144900706393; 0.471806846377564; 306.374888523411073; 8.229748133361719; 1558.698769528102957];
% M2_sens_maricopa=[812.840795236599888; 807.353517598134204; 1125.880977596781122; 1132.899534854465173; 2073.904596650052099; 450.611807091250398; 3969.709783994758709; 3961.806674542926430; 0.106509589600567; 44574.007171995937824; 3974.128161470322993; 43116.765992201304471; 3363.479626459083192; 17.853353566814654; 304.105646297855571; 6.930991514271039; 2143.864446904689430];
% M2_sens_pima=[1538.552804771636374; 1.656476751737515; 0.619901984318967; 1538.601134318769482; 2262.826306715983264; 1032.050793902117675; 3978.296528809823030; 3986.471965620366973; 1.452332886310981; 94153.435828808316728; 3988.271662999725322; 94799.586100413798704; 3430.361523137638869; 17.469697867554178; 240.800703500473986; 1511.924445327952299; 14.974236642453873];
% M2_sens_pinal=[35.562503238820398; 0.260168039897518; 34.840500395830688; 35.883358700496245; 2348.690505175799899; 35.542069680700038; 2383.814482270531244; 1089.269813271562953; 46.394610991519080; 103202.929484338237671; 3967.193857913384818; 103963.424028491703211; 3101.845277873178929; 23.717248963806320; 508.634392123742430; 0.780016300035729; 50.540693656848731];
% M2_sens_mean=(M2_sens_AZ+M2_sens_maricopa+M2_sens_pima+M2_sens_pinal)/4;
% M3_sens_AZ=[1.910306357770489; 0.491341226286876; 1.770883309867972; 1.923295352010750; 2.835558322404147; 8.957656461182797; 4.819141605364969; 16.530690101768514; 1.350050560780631; 27.051999233406917; 36.279305361617389; 32.961270138293543; 40.258151938261427; 0.491340989288492; 7.911936266718308; 0.000000000000000; 0.876651330525035; 3.056387959423486; 0.000000000000000; 12.496786383361174; 0.000000000000000; 0.014968087848884; 248.277942755096035; 177.021226264285616; 454.214494707049312; 128.919148147212468; 0.000264743107244; 107.683513615133094; 0.389734640959466; 8.985938777176955];
% M3_sens_maricopa=[2850.990936640165273; 139.350301268593114; 2880.210882637412396; 2851.819751408108914; 510.320256504405506; 3314.095524732607828; 3644.071161779189424; 3401.229972391248339; 19.403340099067751; 8258.419095761684730; 8095.430913402866281; 2537.897430745497331; 8691.159836970085962; 139.349407181417234; 1268.226788248115554; 224.267087840426200; 645.502007122240229; 400.919230636041334; 46.472656981868738; 1430.376036951881815; 0.000000000000000; 320.549533617145187; 43640.732621505070711; 3946.034485737437990; 43105.594418067674269; 3063.883669863103478; 20.045429883669073; 959.961098800093737; 37.484692873127770; 2144.197175234988208;];
% M3_sens_pima=[0.820177129093458; 0.002523963883247; 0.654779436106625; 0.820174903805287; 153.274654476719832; 121.139936027793738; 157.363992808626222; 22.325233551436845; 0.325687806280341; 20.529201930225220; 587.564730343074643; 1160.629589670194946; 834.739744642213168; 0.002524710124625; 98.058158263485353; 12.771858562367139; 0.010457738933925; 3.151701587475487; 17.775423796383770; 19.541434320449568; 0.000000000000000; 0.000355092562532; 392.106364412617950; 171.288622033769826; 682.622392901346075; 174.615845360869315; 3.361162381295252; 104.107831748321686; 0.210934319297946; 0.105672973847995];
% M3_sens_pinal=[];
% M3_sens_mean=(M3_sens_AZ+M3_sens_maricopa+M3_sens_pima)/3;
% M3_sens_mean=(M3_sens_AZ+M3_sens_maricopa+M3_sens_pima+M3_sens_pinal)/4;
% M4_sens_AZ=;
% M4_sens_maricopa=[1467.003493185986372; 1683.405183931631200; 1606.479081277956084; 1964.830604334529198; 2576.568756686327106; 3804.854003101436319; 3725.229230686517440; 0.126122025593533; 9020.655824587027382; 8518.865371008367219; 17673.117221321648685; 7851.937633846726385; 1467.000508332615937; 1486.726677410181992; 128.537868572084960; 759.888967558393233; 537.689202165430288; 65.213081387257915; 726.664764740299006; 1473.498055510664244; 70.852423453354774; 32370.382017259984423; 11317.399355539513635; 10380.914855304239609; 0.000107296122624; 35150.527734749281080; 0.335160087036295; 5697.467075556603959; 0.000000000000000; 50.272628569442873; 43421.963088447133487; 3932.150342896109123; 43105.010928804142168; 2910.073883114421278; 5.314990855901113; 998.120405758769834; 48.858025219281160; 2144.192128287993910];
% M4_sens_pima=[];
% M4_sens_pinal=
% M4_sens_mean=(M4_sens_AZ+M4_sens_maricopa+M4_sens_pima+M4_sens_pinal)/4;
% M5_sens_AZ=[];
% M5_sens_maricopa=[304.919017646134478; 267.247993996274545; 1689.899689609176221; 3056.472428735311496; 3054.689134022521102; 758.850786231307666; 3639.883432561001428; 4161.431327845444684; 4042.364199753226785; 5.298708704099178; 12366.628563748454326; 11032.279177154548961; 23150.068775632509642; 8728.244161080439881; 1173.509769755082289; 635.310638614750133; 496.752666238762345; 780.440041856625612; 26.717345137650259; 1273.220552352116556; 2761.538933225025175; 134.824957408009340; 151849.203578839427792; 15365.252886279631639; 12134.319669185872044; 0.000734820283980; 134028.864432702161139; 12.370170928740354; 7362.766005551420676; 0.000000000000000; 25.114452663061979; 41931.580981068349502; 4173.936487684720305; 41520.215380527544767; 2820.605163814071147; 7.424687785676422; 478.616456704443181; 2.480841266587523; 0.001093398742357; 2201.407986778835493];
% M5_sens_pima=[];
% M5_sens_pinal=[];
% M5_sens_mean=(M5_sens_AZ+M5_sens_maricopa+M5_sens_pima+M5_sens_pinal)/4;
fprintf('sensitivity_for_I = [%s%.15f];\n', sprintf('%.15f; ', sensitivity_for_I(1:end-1),sensitivity_for_I(end)),'\n',' ');

%  Sort Results for Better Visualization 
%[sorted_sensitivity_I, sort_idx_I] = sort(M3_sens_mean, 'descend');
[sorted_sensitivity_I, sort_idx_I] = sort(sensitivity_for_I, 'descend');
sorted_param_names_I = param_names(sort_idx_I);

%  Create the Bar Graph with Different Colors 
figure('Name', 'Normalized Parameter Sensitivity Ranking for State I');

num_bars = length(sorted_sensitivity_I);
colors = hsv(num_bars); % Generate a set of distinct colors

hold on; 
for i = 1:num_bars  %add 2 to 1 to skip first 2
    % Plot each bar individually and set its 'FaceColor'
    bar(i, sorted_sensitivity_I(i), 'FaceColor', colors(i,:));
end
hold off;

%Add Labels
title('Model 5 Normalized Parameter Sensitivity for Infected Humans ', 'FontSize', 24);
ylabel({'Integrated Absolute Normalized Sensitivity'}, 'FontSize', 20);
%xlabel('Model Parameters', 'FontSize', 20);
grid on;
axis tight;

ax = gca; % Get handle to current axes
sorted_param_names_I=sorted_param_names_I(1:end); %add 2 to 1 to skip first 2
ax.XTick = 1:num_params;  %add 2 to 1 to skip first 2
ax.XTickLabel = sorted_param_names_I;
ax.XTickLabelRotation = 60;

tick_pos = ax.XTick;
labels = ax.XTickLabel;
% 3. REMOVE THE DEFAULT LABELS
ax.XTickLabel = [];
% 4. CALCULATE Y-POSITION FOR NEW LABELS (just below the axis)
y_pos = ax.YLim(1) - 0.01 * diff(ax.YLim); % Adjust '0.05' to move up/down
% 5. ADD NEW, SHIFTED LABELS USING THE TEXT() FUNCTION
x_offset = -0.1; % A negative value shifts left (units are relative to the x-axis)
for i = 1:length(tick_pos)
    % Add the offset to the original tick position
    new_x_pos = tick_pos(i) + x_offset; 
    text(new_x_pos, y_pos, labels{i}, ...
         'HorizontalAlignment', 'right','FontSize', 24, ... % Center the label on the NEW position
         'Rotation', 80);
end

% ax.XAxis.FontSize = 30; 
 ax.YAxis.FontSize = 8;
% xl = ax.XLabel; % Get the handle for the X-axis label
% % 4. DEFINE HOW MUCH TO SHIFT IT DOWN
% % This value is a fraction of the total Y-axis height.
% % 0.1 means shifting it down by an amount equal to 10% of the plot's height.
% shift_fraction = 0.01;
% % 5. CALCULATE THE SHIFT IN DATA UNITS
% y_range = diff(ax.YLim); % Get the total height of the y-axis
% offset = shift_fraction * y_range;
% % 6. APPLY THE NEW POSITION
% % The Position property is an [x, y, z] vector. We just subtract the
% % offset from the 2nd element (the y-coordinate).
% xl.Position(2) = xl.Position(2) - offset;

fprintf('Colored bar graph for State I created successfully.\n');


%%  5 : 0-1 Scaled Bar Graph for I

fprintf('Creating 0-1 scaled and colored bar graph for ''I''...\n');

% Scale the Sorted Sensitivity Values to a 0-1 Range 
scaled_sensitivity_I = sorted_sensitivity_I / max(sorted_sensitivity_I);

%  Create the Bar Graph with Different Colors
figure('Name', 'Relative Parameter Sensitivity for State I (Scaled & Colored)');

num_bars = length(scaled_sensitivity_I);
colors = parula(num_bars); % Generate a set of distinct colors

hold on; % Hold the plot to draw multiple bars
for i = 1:num_bars
    % Plot each bar individually and set its 'FaceColor'
    bar(i, scaled_sensitivity_I(i), 'FaceColor', colors(i,:));
end
hold off; % Release the plot

% Add  Labels  
title(sprintf('Relative Parameter Sensitivity for State ''%s''', state_name_for_title), 'FontSize', 16);
ylabel('Relative Integrated Sensitivity (Scaled to Max = 1)', 'FontSize', 12);
xlabel('Model Parameters', 'FontSize', 12);
grid on;
ylim([0 1.05]); % Set y-axis limit to just above 1.0

set(gca, 'XTick', 1:num_params, 'XTickLabel', sorted_param_names_I);
set(gca, 'XTickLabelRotation', 90); % Rotates the labels

fprintf('Scaled and colored bar graph for State I created successfully.\n');


%% 6: Find Max Percent-for-Percent Sensitivity
% What is the maximum percentage change in I that can be caused by a 1% change in each parameter at any single point in time?"

fprintf('Calculating maximum sensitivities for ''I''...\n');

%   Define the state of interest  
% For your M1 model, y0_M1=[D; H; S; I; R], %m1=4, m2=8 ,m3=8, m4=9, m5=10
state_I_idx = 4;
state_name_for_title = 'I';
num_params = length(p_vec);

%   Find the Maximum Absolute Normalized Sensitivity for State 'I'  
max_percent_sensitivity = zeros(num_params, 1);

% Loop through each parameter
for j = 1:num_params
    % Extract the normalized sensitivity vector for State 'I'
    Sj_norm_for_I = squeeze(sens_norm(state_I_idx, j, :));
    
    % Handle any potential NaN or Inf values from normalization
    Sj_norm_for_I(isnan(Sj_norm_for_I) | isinf(Sj_norm_for_I)) = 0;

    % Find the peak absolute value in the time series
    max_percent_sensitivity(j) = max(abs(Sj_norm_for_I));
end

% Sort Results  
[sorted_max_sens, sort_idx_max] = sort(max_percent_sensitivity, 'descend');
sorted_param_names_max = param_names(sort_idx_max);

%  Display in a Table 
fprintf('\n  Maximum Sensitivity Results for State ''%s''  \n', state_name_for_title);
fprintf('This table shows the maximum percent change in the state for a 1%% change in the parameter.\n\n');
results_table = array2table(sorted_max_sens*100, 'RowNames', sorted_param_names_max, 'VariableNames', {'Max_Impact_Percent'});
disp(results_table);


% Bar Graph of Max Values  
figure('Name', 'Maximum Percent-for-Percent Sensitivity');
bar(sorted_max_sens);
title(sprintf('Maximum %% Change in State ''%s'' for a 1%% Parameter Change', state_name_for_title));
ylabel('Maximum Absolute Normalized Sensitivity');
xlabel('Model Parameters');
grid on;
set(gca, 'XTick', 1:num_params, 'XTickLabel', sorted_param_names_max, 'XTickLabelRotation', 90);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL 0.3 Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dpop_fit = pop_fit_3(t,a,params)
N=a(1);
alpha_h=params(1);  omega=params(2); N_max=params(3);

dN=(alpha_h+omega)*N-(omega+(alpha_h/N_max)*N)*N; %c=((alpha_h+omega)-omega)/N_max=alpha_h/N_max
%or 
%dN=alpha_h*N-(alpha_h*N*N)/N_max;

dpop_fit=[dN];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL 1 Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Model 1 function  
function dM1_SF_T = M1_SF_T(t,a,params)
D = a(1); H = a(2); S=a(3); I=a(4); R=a(5); 

O=params(1);         mu_H=params(2);       gamma_H=params(3); 
H_max=params(4);     delta_H=params(5);    alpha_h=params(6);      
epsilon=params(7);   omega=params(8);      rho=params(9);
kappa=params(10);    delta_D=params(11);   c=params(12);

%dD=O-mu_H*D*H;
dD=O-mu_H*D*H-delta_D*D;
dH=gamma_H*D*H*(1-(H/H_max))-delta_H*H;

dS=alpha_h*(S+I+R)-epsilon*S*H-(omega+c*(S+I+R))*S;
dI=epsilon*S*H-rho*I-kappa*I-(omega+c*(S+I+R))*I;
dR=rho*I-(omega+c*(S+I+R))*R;


dM1_SF_T=[dD;dH;dS;dI;dR];
end









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL 2 Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dM2_SF = M2_SF(t,a,params)
O = a(1); D = a(2); H = a(3); A = a(4); 
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

dS=alpha_h*(S+I+R)-epsilon*S*A-(omega+c*(S+E+I+R))*S;
dE=epsilon*S*A-psi*E-(omega+c*(S+E+I+R))*E;
dI=psi*E-rho*I-kappa*I-(omega+c*(S+E+I+R))*I;
dR=rho*I-(omega+c*(S+E+I+R))*R;

dM2_SF=[dO;dD;dH;dA;dS;dE;dI;dR];
end









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL 3 Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Model 3 function
function dM3_SF = M3_SF(t,a,params)
O = a(1); D = a(2); H = a(3); A = a(4); 
S = a(5); E = a(6); I = a(7); R = a(8);
global county
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
delta_D=params(29);    c=params(30);

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

dS=alpha_h*(S+E+I+R)-epsilon*S*A-(omega+c*(S+E+I+R))*S;
dE=epsilon*S*A-psi*E-(omega+c*(S+E+I+R))*E;
dI=psi*E-rho*I-kappa*I-(omega+c*(S+E+I+R))*I;
dR=rho*I-(omega+c*(S+E+I+R))*R;

%dS=alpha_h*(S+E+I+R)-epsilon*S*A-(omega+c*(S+E+I+R))*S;

dM3_SF=[dO;dD;dH;dA;dS;dE;dI;dR];
end












%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%MODEL 4 SIMPLIFIED FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dM4_SF_S = M4_SF_S(t,a,params)
V=a(1); O = a(2); D = a(3); H = a(4); A = a(5); 
S= a(6); E= a(7); I= a(8); R= a(9);
global county
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
psi=params(36);       delta_D=params(37);    c=params(38);  

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

dS=alpha_h*(S+E+I+R)-epsilon*S*A-(omega+c*(S+E+I+R))*S;
dE=epsilon*S*A-psi*E-(omega+c*(S+E+I+R))*E;
dI=psi*E-rho*I-kappa*I-(omega+c*(S+E+I+R))*I;
dR=rho*I-(omega+c*(S+E+I+R))*R;


dM4_SF_S=[dV;dO;dD;dH;dA;dS;dE;dI;dR];
end









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MODEL 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function dM5_SF = M5_SF(t,a,params)
V=a(1); O = a(2); D = a(3); H = a(4); A = a(5); 
S=a(6); E = a(7); A_H=a(8); I =a(9); R =a(10);
global county
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
c=params(40);

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

dS=alpha_h*(S+E+A_H+I+R)-epsilon*S*A-(omega+c*(S+E+A_H+I+R))*S;
dE=epsilon*S*A-psi*E-(omega+c*(S+E+A_H+I+R))*E;
dA_H=(1-psi)*E-rho_A*A_H-(omega+c*(S+E+A_H+I+R))*A_H;
dI=psi*E-rho_I*I-kappa*I-(omega+c*(S+E+A_H+I+R))*I;
dR=rho_I*I+rho_A*A_H-(omega+c*(S+E+A_H+I+R))*R;


dM5_SF=[dV;dO;dD;dH;dA;dS;dE;dA_H;dI;dR];
end