clear; clc; close all;

peConvAvgModelInit; % Initializes power electornic converter parameters
pmsgModelnit; % Initializes PMSG parameters

wi = 2*pi*1; % Pole frequency for derivative estimate

% Standard WEC-Sim Protocol 
wecSimInputFile; 
wecSim

%% Analyze life consumption of power electronics
data = load('output\RM3_rackAndPinion_w_PEC_matlabWorkspace.mat'); % Load Data

% Parse IGBT and Diode temperature time series
igbtTemp.time = data.simout.deviceTemp.igbtTemp.Time; 
igbtTemp.data = data.simout.deviceTemp.igbtTemp.Data(:,1) + 273.15; % Convert C to K
diodeTemp.time = data.simout.deviceTemp.diodeTemp.Time; 
diodeTemp.data = data.simout.deviceTemp.diodeTemp.Data(:,1) + 273.15; % Convert C to K

lcParamInit; % Initializes life consumption estimation parameters

% Analyze life consumption of IGBT and Diode
[igbtLC, ~] = getLifeConsumption(igbtTemp, A0, A1, T0, lam, alpha, Ea, kb, C, gamma, kt, []);
[diodeLC, ~] = getLifeConsumption(diodeTemp, A0, A1, T0, lam, alpha, Ea, kb, C, gamma, kt, []);