clc;
clear all;
close all;
format long;

%% Set Variables

% Load Lunar Cycle Data file 
load('LunarCyclesData')

h = 1/24;                       % step size - one hour of a day
LunarCycle = 27.3217;           % length of one lunar cycle in days
N = 3;                          % Number of lunar cycles required
Days = (ceil(LunarCycle)*N);    % Calculate number of days that Runge-Kutta
                                % will run for
PerDay = 3;                     % Number of values to take per day

% Set vector containing Initial Conditions of Earth and moon
InitCond = [Xe;Ye;Ze;Xm;Ym;Zm;VXe;VYe;VZe;VXm;VYm;VZm];

% Inline functions for radial distances
Res = @(V) sqrt((V(1)^2)+(V(2)^2)+(V(3)^2));
Rms = @(V) sqrt((V(4)^2)+(V(5)^2)+(V(6)^2));
Rem = @(V) sqrt((((V(4)-V(1))^2)+((V(5)-V(2))^2)+((V(6)-V(3))^2)));

% Inline Functions of Acceleration Equations for Earth and Moon in X, Y and
% Z directions
EarthX = @(V) (-((CS*V(1))/((Res(V))^3)) - ((CM*(V(1)-V(4)))/((Rem(V))^3)));
EarthY = @(V) (-((CS*V(2))/((Res(V))^3)) - ((CM*(V(2)-V(5)))/((Rem(V))^3)));
EarthZ = @(V) (-((CS*V(3))/((Res(V))^3)) - ((CM*(V(3)-V(6)))/((Rem(V))^3)));

MoonX = @(V) (-((CS*V(4))/((Rms(V))^3)) - ((CE*(V(4)-V(1)))/((Rem(V))^3)));
MoonY = @(V) (-((CS*V(5))/((Rms(V))^3)) - ((CE*(V(5)-V(2)))/((Rem(V))^3)));
MoonZ = @(V) (-((CS*V(6))/((Rms(V))^3)) - ((CE*(V(6)-V(3)))/((Rem(V))^3)));

% Inline function containing velocities of earth, followed by velocities of
% moon and then the acceleration equations for the earth and then moon
dV = @(V) [V(7);V(8);V(9);V(10);V(11);V(12);...
            EarthX(V);EarthY(V);EarthZ(V);...
            MoonX(V);MoonY(V);MoonZ(V)];

% Run Runge-Kutta function to find next positions and velocities of earth
% and moon       
V = RungeKutta(h,InitCond,dV,Days);

% Step size used calculates positions and velocities for  every hour in the
% day (ie 24 values)                
% Return 3 values for positions and velocities of earth and moon per day
k = 1;
   for j = 1:PerDay*Days
        v(:,j) = V(:,k);
        k = k+(24/PerDay);
   end
   
% Inital Visualisation
figure(1)
view(3)
hold on;
xlabel('X'); ylabel('Y'); zlabel('Z'); title('Initial Visualisation of Sun, Earth and Moon');
plot3(0,0,0,'ro');
plot3(v(1,:),v(2,:),v(3,:),'b');
plot3(v(4,:),v(5,:),v(6,:),'k');
%legend('Sun','Moon','Earth');
hold off;

save('v.mat');
clc
clear all

%% Animation

load('v');
% set required values
% Find range of t - number of columns in a row of v (the results from the
% Runge-Kutta)  
[rubbish trange] = size(v(1,:));
% Create 3 vectors (of size trange x 3) to hold the positions of the earth,
% sun and moon (ie the x, y and z coordinates)
position = zeros(trange,3,3);
 
% x y z positions of the Sun in position(:,:,1) 
position(:,1,1) = 0;
position(:,2,1) = 0;
position(:,3,1) = 0;
 
% x y z positions of the Earth in position(:,:,2) 
position(:,1,2) = [v(1,:)]';
position(:,2,2) = [v(2,:)]';
position(:,3,2) = [v(3,:)]';
 
% x y z positions of the Moon in position(:,:,3) 
position(:,1,3) = [v(4,:)]';
position(:,2,3) = [v(5,:)]';
position(:,3,3) = [v(6,:)]';
 
% radius of each body, all scaled by a factor of 10
ObjectRadius = [4.64913e-03 4.258757e-05 1.161467e-05]'*10;

% Orbit Colours
OrbitColour = ones(3,3);
OrbitColour(1,:)= [0.82 0.41 0.12];     % sun - orange
OrbitColour(2,:) = [0.25 0.25 0.9];     % earth - blue
OrbitColour(3,:) = [0.8  0.8  0.8];     % moon - grey

% Various details of bodies - Tilt, Spin and Light Source
AxialTilt=[0 23.44 1.54];
ObjectSpin=[0 1 0];
ObjectLight=[1 0 0];
ObjectDetails=[AxialTilt; ObjectSpin; ObjectLight;];

% Reflection of each object
ObjectReflect = zeros(3,2);
ObjectReflect(1,:) = [1 0];
ObjectReflect(2,:) = [0.6 0.3];
ObjectReflect(3,:) = [1 0];

% Set textures to be used for objects (sun, earth and moon)
ObjectTexture = char('euvisdoCarringtonMap.jpg', 'download.jpg', 'images2.jpg');

M = LunarAnimation(position, ObjectRadius, OrbitColour, ObjectTexture, ObjectDetails, PerDay);
movie2avi(M,'LunarAnimation.avi', 'compression', 'None');     % Save animation as AVI