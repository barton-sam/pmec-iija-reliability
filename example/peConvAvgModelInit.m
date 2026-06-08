%% Initializes All Required Parameters
%   Specifically for "mpm_2LVSC_AvgModel.slx"

%% Converter Electrical Parameters
% Converter Params
fsw = 10e3*0 + 2e3; % Switching frequency (Hz)
Vdc = 1350;  % DC Bus Voltage (V)
Rg = 1.2;     % Gate Resistance (Ohms)

%% IGBT + Diode Loss LUT Initialization
%   Loss LUTs Derived from INFINEON FF1000R17IE4 
%   Datasheet: https://www.infineon.com/assets/row/public/documents/60/49/infineon-ff1000r17ie4-ds-en.pdf
vTest = 900; % Test DC bus voltage used to generate loss tables
rTest = 1.2; % Test Gate resistance used to generate loss tables
numParallel = 4; % Number of devices in parallel

% IGBT Turn-ON Energy 
igbtEonLUT = Simulink.LookupTable;
% Taken Directly from PLECS thermal model

% 25C Data
energyTable1 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.03101	0.05311	0.07554	0.09854	0.1224	0.1474	0.1738	0.2021	0.2327	0.2658	0.302	0.3416	0.3851	0.4331	0.4858	0.5439	0.6079	0.6782	0.7555	0.8401];
% 50C Data
energyTable2 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.03462	0.0593	0.08434	0.11	0.1366	0.1645	0.1941	0.2257	0.2598	0.2968	0.3371	0.3814	0.43	0.4835	0.5424	0.6073	0.6787	0.7573	0.8435	0.938];
% 75C Data
energyTable3 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.03816	0.06537	0.09298	0.1213	0.1506	0.1814	0.2139	0.2488	0.2863	0.3271	0.3717	0.4204	0.474	0.533	0.5979	0.6695	0.7482	0.8348	0.9298	1.034];
% 100C Data
energyTable4 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.04164	0.07133	0.1015	0.1323	0.1643	0.1979	0.2335	0.2715	0.3125	0.357	0.4055	0.4588	0.5173	0.5816	0.6525	0.7305	0.8164	0.9109	1.015	1.128];
% 125C Data
energyTable5 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.04507	0.0772	0.1098	0.1432	0.1779	0.2142	0.2526	0.2938	0.3381	0.3863	0.4389	0.4965	0.5598	0.6294	0.7061	0.7906	0.8835	0.9858	1.098	1.221];
% 150C Data
energyTable6 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.04844	0.08297	0.118	0.1539	0.1912	0.2302	0.2715	0.3157	0.3634	0.4152	0.4717	0.5336	0.6016	0.6765	0.7589	0.8497	0.9496	1.059	1.18	1.312];

igbtEonLUT.Table.Value = cat(3, energyTable1, energyTable2, ...
    energyTable3, energyTable4, energyTable5, energyTable6); 
igbtEonLUT.Breakpoints(1).Value = [0 900]; 
igbtEonLUT.Breakpoints(2).Value = 0:100:2000;
igbtEonLUT.Breakpoints(3).Value = 25:25:150;
igbtEonLUT.Table.FieldName = 'Eon';
igbtEonLUT.Breakpoints(1).FieldName = 'Vdc';
igbtEonLUT.Breakpoints(2).FieldName = 'Ice';
igbtEonLUT.Breakpoints(3).FieldName = 'Tj';
igbtEonLUT.StructTypeInfo.Name = 'igbtEonLUT';

% IGBT Turn-OFF Energy 
igbtEoffLUT = Simulink.LookupTable; 
% Taken Directly from PLECS thermal model

% 25C Data
energyTable1 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.0287	0.0479	0.06709	0.08627	0.1054	0.1246	0.1438	0.1629	0.1821	0.2013	0.2204	0.2396	0.2588	0.2779	0.2971	0.3163	0.3354	0.3546	0.3738	0.3929];
% 50C Data
energyTable2 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.03116	0.05201	0.07285	0.09367	0.1145	0.1353	0.1561	0.1769	0.1977	0.2186	0.2394	0.2602	0.281	0.3018	0.3226	0.3434	0.3642	0.385	0.4058	0.4266];
% 75C Data
energyTable3 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.03417	0.05702	0.07986	0.1027	0.1255	0.1483	0.1712	0.194	0.2168	0.2396	0.2624	0.2852	0.308	0.3309	0.3537	0.3765	0.3993	0.4221	0.4449	0.4677];
% 100C Data
energyTable4 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.03777	0.06304	0.08829	0.1135	0.1388	0.164	0.1892	0.2144	0.2397	0.2649	0.2901	0.3153	0.3406	0.3658	0.391	0.4162	0.4414	0.4667	0.4919	0.5171];
% 125C Data
energyTable5 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.04205	0.07019	0.0983	0.1264	0.1545	0.1826	0.2107	0.2387	0.2668	0.2949	0.323	0.3511	0.3792	0.4072	0.4353	0.4634	0.4915	0.5195	0.5476	0.5757];
% 150C Data
energyTable6 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.04708	0.07857	0.11	0.1415	0.1729	0.2044	0.2358	0.2673	0.2987	0.3302	0.3616	0.393	0.4245	0.4559	0.4873	0.5188	0.5502	0.5816	0.6131	0.6445];

igbtEoffLUT.Table.Value = cat(3, energyTable1, energyTable2, ...
    energyTable3, energyTable4, energyTable5, energyTable6); 
igbtEoffLUT.Breakpoints(1).Value = [0 900]; 
igbtEoffLUT.Breakpoints(2).Value = 0:100:2000;
igbtEoffLUT.Breakpoints(3).Value = 25:25:150;
igbtEoffLUT.Table.FieldName = 'Eoff';
igbtEoffLUT.Breakpoints(1).FieldName = 'Vdc';
igbtEoffLUT.Breakpoints(2).FieldName = 'Ice';
igbtEoffLUT.Breakpoints(3).FieldName = 'Tj';
igbtEoffLUT.StructTypeInfo.Name = 'igbtEoffLUT';

% IGBT ON Voltage
igbtVonLUT = Simulink.LookupTable; 
% Taken directly from PLECS model
igbtVonLUT.Table.Value  = [ 0.9372	1.104	1.229	1.342	1.448	1.549	1.646	1.74	1.831	1.92	2.007	2.093	2.177	2.259	2.341	2.421	2.5	    2.579	2.656	2.733	2.809
                            0.8909	1.075	1.214	1.34	1.458	1.571	1.68	1.785	1.887	1.987	2.085	2.181	2.276	2.369	2.46	2.551	2.64	2.728	2.816	2.902	2.988
                            0.8502	1.051	1.204	1.343	1.473	1.598	1.718	1.835	1.948	2.059	2.168	2.275	2.38	2.483	2.585	2.686	2.785	2.884	2.981	3.077	3.172
                            0.8139	1.031	1.198	1.35	1.493	1.63	1.762	1.89	2.015	2.137	2.256	2.374	2.49	2.604	2.716	2.827	2.937	3.045	3.153	3.259	3.364
                            0.7814	1.015	1.196	1.361	1.517	1.666	1.81	1.95	2.086	2.219	2.35	2.479	2.605	2.73	2.853	2.974	3.095	3.213	3.331	3.448	3.563
                            0.7521	1.003	1.198	1.376	1.545	1.706	1.862	2.014	2.162	2.306	2.449	2.588	2.726	2.862	2.996	3.128	3.259	3.388	3.517	3.644	3.769];
igbtVonLUT.Breakpoints(1).Value = 25:25:150; % Junction Temperature
igbtVonLUT.Breakpoints(2).Value = 0:100:2000; % Device Current
igbtVonLUT.Table.FieldName = 'Vce';
igbtVonLUT.Breakpoints(1).FieldName = 'Tj';
igbtVonLUT.Breakpoints(2).FieldName = 'Ice';
igbtVonLUT.StructTypeInfo.Name = 'igbtVonLUT';

% Diode Turn-OFF Energy
diodeEoffLUT = Simulink.LookupTable; 
% Directly from PLECS model

% 25C Data
energyTable1 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.03009	0.04788	0.06175	0.07323	0.08299	0.09142	0.09877	0.1052	0.1109	0.1159	0.1203	0.1241	0.1275	0.1304	0.1329	0.135	0.1367	0.1382	0.1393	0.1401];
% 50C Data
energyTable2 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.0336	0.05346	0.06895	0.08177	0.09267	0.1021	0.1103	0.1175	0.1238	0.1294	0.1343	0.1386	0.1423	0.1456	0.1484	0.1507	0.1527	0.1543	0.1555	0.1565];
% 75C Data
energyTable3 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.03842	0.06113	0.07884	0.09349	0.106	0.1167	0.1261	0.1343	0.1416	0.148	0.1536	0.1585	0.1628	0.1665	0.1696	0.1723	0.1746	0.1764	0.1778	0.1789];
% 100C Data
energyTable4 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.04488	0.07141	0.09211	0.1092	0.1238	0.1364	0.1473	0.157	0.1654	0.1729	0.1794	0.1851	0.1901	0.1945	0.1982	0.2013	0.204	0.2061	0.2077	0.209];
% 125C Data
energyTable5 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.05338	0.08494	0.1096	0.1299	0.1472	0.1622	0.1752	0.1867	0.1968	0.2056	0.2134	0.2202	0.2262	0.2313	0.2357	0.2395	0.2426	0.2451	0.2471	0.2486];
% 150C Data
energyTable6 = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
                0	0.06438	0.1024	0.1321	0.1567	0.1776	0.1956	0.2113	0.2251	0.2373	0.248	0.2573	0.2656	0.2727	0.279	0.2843	0.2888	0.2926	0.2956	0.298	0.2998];

diodeEoffLUT.Table.Value = cat(3, energyTable1, energyTable2, ...
    energyTable3, energyTable4, energyTable5, energyTable6); 
diodeEoffLUT.Breakpoints(1).Value = [0 900];
diodeEoffLUT.Breakpoints(2).Value = 0:100:2000;
diodeEoffLUT.Breakpoints(3).Value = 25:25:150;
diodeEoffLUT.Table.FieldName = 'Eoff';
diodeEoffLUT.Breakpoints(1).FieldName = 'Vdc';
diodeEoffLUT.Breakpoints(2).FieldName = 'If';
diodeEoffLUT.Breakpoints(3).FieldName = 'Tj';
diodeEoffLUT.StructTypeInfo.Name = 'diodeEoffLUT';

% Diode ON Voltage
diodeVonLUT = Simulink.LookupTable; 
diodeVonLUT.Table.Value = [ 0.7079	1.026	1.176	1.295	1.397	1.489	1.573	1.65	1.723	1.792	1.858	1.921	1.981	2.039	2.096	2.15	2.203	2.254	2.304	2.353	2.401
                            0.635	0.9768	1.14	1.269	1.38	1.48	1.571	1.656	1.735	1.811	1.883	1.951	2.017	2.081	2.142	2.202	2.26	2.316	2.371	2.425	2.477
                            0.5744	0.9359	1.11	1.248	1.367	1.474	1.572	1.662	1.748	1.829	1.906	1.98	2.051	2.119	2.185	2.25	2.312	2.373	2.432	2.49	2.546
                            0.5231	0.9015	1.085	1.231	1.357	1.47	1.574	1.67	1.761	1.847	1.928	2.007	2.082	2.155	2.225	2.294	2.36	2.425	2.488	2.549	2.609
                            0.4793	0.8722	1.064	1.217	1.349	1.468	1.577	1.678	1.773	1.864	1.95	2.033	2.112	2.189	2.263	2.335	2.405	2.473	2.539	2.604	2.667
                            0.4415	0.8471	1.046	1.205	1.343	1.467	1.581	1.687	1.786	1.881	1.971	2.057	2.14	2.22	2.298	2.373	2.447	2.518	2.587	2.655	2.722];
diodeVonLUT.Breakpoints(1).Value = 25:25:150;
diodeVonLUT.Breakpoints(2).Value = 0:100:2000;
diodeVonLUT.Table.FieldName = 'Vf';
diodeVonLUT.Breakpoints(1).FieldName = 'Tj';
diodeVonLUT.Breakpoints(2).FieldName = 'If';
diodeVonLUT.StructTypeInfo.Name = 'diodeVonLUT';

clear energyTable1 energyTable2

% Scale Turn-on/-off Energy Considering Gate Resistance
%   Assuming Linear Scaling
igbtEonLUT.Table.Value      = igbtEonLUT.Table.Value * Rg/rTest;
igbtEoffLUT.Table.Value     = igbtEoffLUT.Table.Value * Rg/rTest;
diodeEoffLUT.Table.Value    = diodeEoffLUT.Table.Value * Rg/rTest;

%% New Thermals
T0 = 25; 

% Manufacturer provided Foster Thermal models. Need to convert to Cauer for
% more accurate modeling purposes. 
igbtFosterRthVec = [0.0008	0.0037	0.017	0.0025];
igbtFosterTauVec = [0.0008	0.013	0.05	0.6]; 
igbtFosterCthVec = igbtFosterTauVec ./ igbtFosterRthVec;
[igbtRth, igbtCth] = ee_getCauerFromFoster(igbtFosterRthVec, ...
    igbtFosterCthVec);

diodeFosterRthVec = [0.003	0.0115	0.03	0.0035];
diodeFosterTauVec = [0.0008	0.013	0.05	0.6];
diodeFosterCthVec = diodeFosterTauVec ./ diodeFosterRthVec; 
[diodeRth, diodeCth] = ee_getCauerFromFoster(diodeFosterRthVec, ...
    diodeFosterCthVec);

% Designating state space model parameters
%   Using the form: dx_dt = Ax + Bu; y = Cx + Du
R = igbtRth; 
C = igbtCth; 
igbtAmtx = [
    -1/(R(1)*C(1))      1/(R(1)*C(1))      0;
     1/(R(1)*C(2)) -(1/(R(1)*C(2))+1/(R(2)*C(2))) 1/(R(2)*C(2));
     0                  1/(R(2)*C(3))    -(1/(R(2)*C(3)) + 1/(R(3)*C(3)))
];
igbtB1mtx = [1/C(1); 0; 0];
igbtB2mtx = [0; 0; 1/(R(3)*C(3))];
igbtCmtx = [1 0 0; 0 0 0; 0 0 1];

igbtA = blkdiag(igbtAmtx, igbtAmtx, igbtAmtx, igbtAmtx, igbtAmtx, igbtAmtx);
igbtB = blkdiag(igbtB1mtx, igbtB1mtx, igbtB1mtx, igbtB1mtx, igbtB1mtx, igbtB1mtx);
igbtB1 = blkdiag(igbtB1mtx, igbtB1mtx, igbtB1mtx, igbtB1mtx, igbtB1mtx, igbtB1mtx);
igbtB2 = blkdiag(igbtB2mtx, igbtB2mtx, igbtB2mtx, igbtB2mtx, igbtB2mtx, igbtB2mtx);
igbtC = blkdiag(igbtCmtx, igbtCmtx, igbtCmtx, igbtCmtx, igbtCmtx, igbtCmtx);

R = diodeRth; 
C = diodeCth; 
diodeAmtx = [
    -1/(R(1)*C(1))      1/(R(1)*C(1))      0;
     1/(R(1)*C(2)) -(1/(R(1)*C(2))+1/(R(2)*C(2))) 1/(R(2)*C(2));
     0                  1/(R(2)*C(3))    -(1/(R(2)*C(3)) + 1/(R(3)*C(3)))
];

diodeB1mtx = [1/C(1); 0; 0];
diodeB2mtx = [0; 0; 1/(R(3)*C(3))];
diodeCmtx = [1 0 0; 0 0 0; 0 0 1];

diodeA = blkdiag(diodeAmtx, diodeAmtx, diodeAmtx, diodeAmtx, diodeAmtx, diodeAmtx);
diodeB = blkdiag(diodeB1mtx, diodeB1mtx, diodeB1mtx, diodeB1mtx, diodeB1mtx, diodeB1mtx);
diodeB1 = blkdiag(diodeB1mtx, diodeB1mtx, diodeB1mtx, diodeB1mtx, diodeB1mtx, diodeB1mtx);
diodeB2 = blkdiag(diodeB2mtx, diodeB2mtx, diodeB2mtx, diodeB2mtx, diodeB2mtx, diodeB2mtx);
diodeC = blkdiag(diodeCmtx, diodeCmtx, diodeCmtx, diodeCmtx, diodeCmtx, diodeCmtx);

% Heat sink thermal resistance/capacitance (K/W, J/K, respectively)
% NOMINAL CONDITIONS: heatSinkTau = 20, heatSinkRth = 1e-3
heatSinkTau = 20; 
heatSinkRth =1.25e-3; 
heatSinkCth = heatSinkTau/heatSinkRth; 

hsAmtx = -1/heatSinkCth * numParallel * (6/igbtRth(3) + 6/diodeRth(3));
hsBmtx = 1/heatSinkRth * numParallel * [ones(1,6)*1/igbtRth(3) ones(1,6)*1/diodeRth(3)];




