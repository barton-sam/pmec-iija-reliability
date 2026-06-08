% Parameters used to estimate number of cycles to failure
%
% Parameters taken from Arendt, 2024: 
% https://assets.danfoss.com/documents/latest/444233/AB501650017495en-000201.pdf

A0 = 2.9e9; % Technology Coefficient
A1 = 60; % Factor of low deltaT extension
T0 = 40; % Initial temperature for low deltaT extension [K]
lam = 17; % Drop constant of low deltaT extension [K]
alpha = -4.3; % Coffin-Manson exponent
Ea = 4.5e-20; % Activation energy [J]
kb = 1.38e-23; % Boltzmann constant [J/K]
C = 1; % Time coefficient
gamma = -0.75; % Time exponent
kt = 0.65; % Chip thickness factor