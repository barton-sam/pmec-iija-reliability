%% PMSG Parameters
% --- MS PMSG parameters --- 
pmsg.R = 1.097e-3; % Stator phase resistance [Ohms]
pmsg.Lq = 0.256e-3; % q-axis stator phase inductance [H]
pmsg.Ld = 0.256e-3; % d-axis stator phase inductance [H]
pmsg.lambda = 0.947*sqrt(2); % Rotor magnetic flux linkage [Wb?]
pmsg.pp = 8; % Machine pole pairs [-]
% pmsg.wRated = wt.lambdaOpt*wt.uRated/wt.R * gb.N1/gb.N2*0 + 46.4891; % Ideal rated pmsg speed [rad/s]
pmsg.wRated = 46.4891;
pmsg.vRated = 477; % Stator rated voltage (LL,RMS) [V]
pmsg.iRated = 3302*sqrt(2); % Stator rated current (A)
pmsg.tRated = pmsg.pp * pmsg.lambda * pmsg.iRated; 
% pmsg.tRated = pmsg.pp * pmsg.lambda/sqrt(2) * pmsg.iRated/sqrt(2); 


% --- LS PMSG parameters --- 
% pmsg.R = 0.821e-3; 
% pmsg.Ld = 1.573e-3; 
% pmsg.Lq = 1.573e-3; 
% pmsg.lambda = 5.826; 
% pmsg.pp = 26; 
% pmsg.wRated = 18 * pi/30; 
% pmsg.vRated = 477; 
