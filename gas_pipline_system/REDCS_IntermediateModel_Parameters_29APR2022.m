%**************************************************************************
% REDCS: Intermediate-Fidelity Pipeline Model for FSU
%
% Model parameter population script to be used with model verion:
%                        REDCS_Pipeline_IntermediateModel_FSU_29APR2022.slx
%
%**************************************************************************
% N. Candelino, GE Global Research Center, 29APR2022


% Environmental Parameters
Enthalpy = 41;      % Enthalpy [kJ/kg]
PT_EXT = 7.2;       % Well Gas Pressure [MPa]
gamma = 1.2;        % Heat Capacity Ratio
% EP001 = 
% EP002 = 
% EP003 = 
% EP004 = 
% EP005 = 
% EP006 = 
% EP007 = 
% EP008 = 
% EP009 = 
% EP010 = 
EP011 = 0.8;        % Gas Compressibility Factor (Z)
% EP012 = 
% EP013 = 
% EP014 = 
% EP015 = 
% EP016 = 1;
EP017 = 6;          % Upstream Gas Pressure     [MPa]
EP018 = 20;         % Gas Temperature           [degC]
EP019 = 5.5;        % Downstream Gas Pressure   [MPa]
EP020 = 21.9;       % Node 4 Mass Flow Input    [kg/s]
EP021 = Enthalpy;     % Node 4 Enthalpy         [kJ/kg]
EP022 = 13.1;       % Node 6 Mass Flow Input    [kg/s]
EP023 = Enthalpy;
EP024 = 54.2;       % Node 7 Mass Flow Input    [kg/s]
EP025 = Enthalpy;
EP026 = 13.4;       % Node 8 Mass Flow Input    [kg/s]
EP027 = Enthalpy; 
EP028 = 0.5;        % Node 9 Mass Flow Input    [kg/s]
EP029 = Enthalpy;
EP030 = 20;         % Ambient Temperature       [degC]

% Simscape Pipe Parameters
roughness = 15e-6;  % Pipe interior surface roughness [m]

% Upstream Compressor Input
LEG_DEMAND_3A(1) = 925;     % Upstream pressure for sim. startup [PSIG]
LEG_DEMAND_3A(2) = 1050;    % Upstream pressure setpoint [PSIG]

% Downstream Compressor Input
LEG_DEMAND_10A(1) = 875;    % Downstream pressure for sim. startup [PSIG]
LEG_DEMAND_10A(2) = 950;    % Downstream pressure setpoint [PSIG]

% Valve Parameters
OPEN = 1;
CLOSED = 0;
ValveThresh = 0.001; % Isolation Valves OPEN if input >= ValveThresh

% Initial Valve Positions
ZR2000 = OPEN;
ZR2110 = CLOSED;
ZR2400 = OPEN;
ZR2401 = 100*OPEN;  %For partially open use percent
ZR2510 = CLOSED;
ZR2600 = OPEN;
ZR2601 = 100*OPEN;  %For partially open use percent
ZR2700 = OPEN;
ZR2701 = 100*OPEN;  %For partially open use percent
ZR2800 = OPEN;
ZR2801 = 100*OPEN;  %For partially open use percent
ZR2900 = OPEN;
ZR2901 = 100*OPEN;  %For partially open use percent
ZR3900 = OPEN;
ZR4500 = OPEN;
ZR5600 = OPEN;
ZR7800 = CLOSED;

%Compressor Model Parameters
r1 = 0.05;              % Inlet blade radius [m]
r2 = 0.325;             % Rotor blade radius [m]
sigma = 0.90;           % Slip factor
B1 = 45;                % Inlet blade angle [deg]
%B2 = 70;               % Rotor blade angle [deg]
Ac = (pi/4)*0.6096^2;   % Inlet (Outlet) Cross-sectional Area [m^2]
Lc = 20;                % Compressor Length [m]
J = 5;                  % Compressor Shaft Interia [kg.m^2]
kf = 0.05;              % Gas friction coefficient