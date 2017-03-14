clc;
clear all;
close all;
format long;

%% Set Variables

% Load Lunar Cycle Data file 
load('MarsData')

h= 1/(24*60);       % minutes in a day
Days = 50;           % days mars to complete an orbit 
PerDay = 3;                 % Number of values to take per day

% Set vector containing Initial Conditions of Earth and moon
InitCond = [Xm;Ym;Zm;Xd;Yd;Zd;Xp;Yp;Zp;VXm;VYm;VZm;VXd;VYd;VZd;VXp;VYp;VZp];

% Inline functions for radial distances
Rsm = @(V) sqrt((V(1)^2)+(V(2)^2)+(V(3)^2));
Rsd = @(V) sqrt((V(4)^2)+(V(5)^2)+(V(6)^2));
Rsp = @(V) sqrt((V(7)^2)+(V(8)^2)+(V(9)^2));
Rmd = @(V) sqrt((((V(1)-V(4))^2)+((V(2)-V(5))^2)+((V(3)-V(6))^2)));
Rmp = @(V) sqrt((((V(1)-V(7))^2)+((V(2)-V(8))^2)+((V(3)-V(9))^2)));
Rdp = @(V) sqrt((((V(4)-V(7))^2)+((V(5)-V(8))^2)+((V(6)-V(9))^2)));

% Inline Functions of Acceleration Equations for Earth and Moon in X, Y and
% Z directions
MarsX = @(V) ((-((CS*V(1))/((Rsm(V))^3)) - ((CD*(V(1)-V(4)))/((Rmd(V))^3))) - ((CP*(V(1)-V(7)))/((Rmp(V))^3)));
MarsY = @(V) ((-((CS*V(2))/((Rsm(V))^3)) - ((CD*(V(2)-V(5)))/((Rmd(V))^3))) - ((CP*(V(2)-V(8)))/((Rmp(V))^3)));
MarsZ = @(V) ((-((CS*V(3))/((Rsm(V))^3)) - ((CD*(V(3)-V(6)))/((Rmd(V))^3))) - ((CP*(V(3)-V(9)))/((Rmp(V))^3)));

DeimosX = @(V) ((-((CS*V(4))/((Rsd(V))^3)) - ((CM*(V(4)-V(1)))/((Rmd(V))^3))) - ((CP*(V(4)-V(7)))/((Rdp(V))^3)));
DeimosY = @(V) ((-((CS*V(5))/((Rsd(V))^3)) - ((CM*(V(5)-V(2)))/((Rmd(V))^3))) - ((CP*(V(5)-V(8)))/((Rdp(V))^3)));
DeimosZ = @(V) ((-((CS*V(6))/((Rsd(V))^3)) - ((CM*(V(6)-V(3)))/((Rmd(V))^3))) - ((CP*(V(6)-V(9)))/((Rdp(V))^3)));

PhobosX = @(V) ((-((CS*V(7))/((Rsp(V))^3)) - ((CM*(V(7)-V(1)))/((Rmp(V))^3))) - ((CD*(V(7)-V(4)))/((Rdp(V))^3)));
PhobosY = @(V) ((-((CS*V(8))/((Rsp(V))^3)) - ((CM*(V(8)-V(2)))/((Rmp(V))^3))) - ((CD*(V(8)-V(5)))/((Rdp(V))^3)));
PhobosZ = @(V) ((-((CS*V(9))/((Rsp(V))^3)) - ((CM*(V(9)-V(3)))/((Rmp(V))^3))) - ((CD*(V(9)-V(6)))/((Rdp(V))^3)));

% Inline function containing velocities of earth, followed by velocities of
% moon and then the acceleration equations for the earth and then moon
dV = @(V) [V(10);V(11);V(12);V(13);V(14);V(15);V(16);V(17);V(18);
            MarsX(V);MarsY(V);MarsZ(V);...
            DeimosX(V);DeimosY(V);DeimosZ(V);...
            PhobosX(V);PhobosY(V);PhobosZ(V)];

% Run Runge-Kutta function to find next positions and velocities of earth
% and moon       
V = RungeKutta(h,InitCond,dV,Days);

% Step size used calculates positions and velocities for  every hour in the
% day (ie 24 values)                
% Return 3 values for positions and velocities of earth and moon per day
k = 1;
   for j = 1:PerDay*Days
        v(:,j) = V(:,k);
        k = k+480;
   end
   
% Inital Visualisation
figure(1)
view(3)
hold on;
xlabel('X'); ylabel('Y'); zlabel('Z'); title('Initial Visualisation of Mars and its Moons');
plot3(0,0,0,'ro');
plot3(v(1,:),v(2,:),v(3,:),'b');
plot3(v(4,:),v(5,:),v(6,:),'k');
plot3(v(7,:),v(8,:),v(9,:),'m');
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
position = zeros(trange,3,4);
 
% x y z positions of the Sun in position(:,:,1) 
position(:,1,1) = 0;
position(:,2,1) = 0;
position(:,3,1) = 0;
 
% x y z positions of the Mars in position(:,:,2) 
position(:,1,2) = [v(1,:)]';
position(:,2,2) = [v(2,:)]';
position(:,3,2) = [v(3,:)]';
 
% x y z positions of the Deimos in position(:,:,3) 
position(:,1,3) = [v(4,:)]';
position(:,2,3) = [v(5,:)]';
position(:,3,3) = [v(6,:)]';
 
% x y z positions of the Phobos in position(:,:,3) 
position(:,1,4) = [v(7,:)]';
position(:,2,4) = [v(8,:)]';
position(:,3,4) = [v(9,:)]';

% radius of each body, all scaled by a factor of 10
ObjectRadius = [4.64913e-03 3389.9/AU 6.2/AU 11.2667/AU]'*20;

% Orbit Colours
OrbitColour = ones(4,3);
OrbitColour(1,:)= [0.82 0.41 0.12];     % sun - orange
OrbitColour(2,:) = [1 0 0];             % Mars -red
OrbitColour(3,:) = [0.8  0.8  0.8];     % deimos - grey
OrbitColour(4,:) = [1 1 0];             % phobos - yellow

% Various details of bodies - Tilt, Spin and Light Source
AxialTilt=[0 25.19 0.897 0.046];
ObjectSpin=[0 1 0 0];
ObjectLight=[1 0 0 0];
ObjectDetails=[AxialTilt; ObjectSpin; ObjectLight;];


% Set textures to be used for objects (sun, earth and moon)
ObjectTexture = char('euvisdoCarringtonMap.jpg', 'mars.jpg', 'deimos.jpg', 'phobos.jpg');

M = LunarAnimation(position, ObjectRadius, OrbitColour, ObjectTexture, ObjectDetails);
movie2avi(M,'Mars.avi', 'compression', 'None');     % Save animation as AVI