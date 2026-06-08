function [LC, cHistNew] = getLifeConsumption(temp, A0, A1, T0, lambda, alpha, Ea, kb, C, gamma, kt, cHist)
%GETLIFECONSUMPTION_v2 Returns expected life consumption (LC) for a given 
% temperature time series (temp)
%
% Using the definitions provided in App Note AN 21-001: Power Cycle Model
% for IGBT Product Lines, Wintrich, 2024.
%
% Input Defintions: 
%   temp:   Temperature time series
%   A0:     Technology coefficient
%   A1:     Factor of low deltaT extension
%   T0:     Initial temperature for low deltaT extension [K]
%   lambda: Drop constant of low deltaT extension [K]
%   alpha:  Coffin-Manson exponent
%   Ea:     Activation energy [J]
%   kb:     Boltzmann constant [J/K]
%   C:      Time coefficient
%   gamma:  Time exponent
%   kt:     Chip thickness factor
%
% Output Definitions: 
%   LC:         Estimated device life consumption
%   cHistNew:   Historical data from rainflow counting algorithm (number of
%                   cycles, cycle range, mean value of cycle, cycle start 
%                   & end time)


% Number of cycles to failure definition given in AN 21-001
%   Function broken down by impact
beta = @(deltaT) exp(-(deltaT-T0)/lambda); % Low deltaT behavior
cTerm = @(ton) (C + ton^gamma)/(C+2^gamma); % Time dependency
cTermMax = cTerm(40e-3); % Maximum scaling that can be expected for high cycle frequency
meanTerm = @(Tjm) exp(Ea/(kb*Tjm)); % Mean cycle value dependency

% "Strength Estimation" - Equation provided in Wintrich, 2024. Estimates
% how many cycles a device can endure a given thermal stress condition. 
Nf = @(deltaT, Tjm, ton) A0 * A1^beta(deltaT) * deltaT^(alpha-beta(deltaT)) * meanTerm(Tjm) * min([cTerm(ton) cTermMax]) * kt; 

% Rainflow Counting
%   Struct "c" is made up of the following: 
%   COUNT (number of cycles experienced) | RANGE (cycle amplitude) | MEAN
%   (mean value of cycle, cycle mid-point) | START (cycle start time) | END
%   (cycle end time)
c = rainflow(temp.data, temp.time);
cHistNew = [cHist; c];
cTab = array2table(c,VariableNames=["Count" "Range" "Mean" "Start" "End"]);
ni = cTab.Count; 
deltaT = cTab.Range; 
Tjm = cTab.Mean; 
ton = (cTab.End-cTab.Start); 

% Miner rule: LC = sum(ni/Nfi)
numCycles2failure = zeros(size(ni)); 
for i = 1:length(c)
    numCycles2failure(i) = Nf(deltaT(i), Tjm(i), ton(i));
end
LC = sum(ni./numCycles2failure);

end

