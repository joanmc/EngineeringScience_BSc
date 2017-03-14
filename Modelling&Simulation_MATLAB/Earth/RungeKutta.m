function [V] = RungeKutta(h, IC, dV, days)
% [V] = RungeKutta(h, IC, dV, days)
%
% Solves equations for motion of the earth and moon, with the moon
% orbiting the earth and the earth orbiting the sun.
%
% Systems of equations are solved using the fourth Order Runge-Kutta 
% method.
%   
% [V] is the matrix ouput containing the x y and z positions and velocities
% of the bodies in the form:
% [Xe; Ye; Ze; Xm; Ym; Zm; VXe; VYe; VZe; VXm; VYm; VZm]
% where each column contains the nth solution where n = 1,2,3,...
% The subscript 'e' and 'm' here relate to the Earth and Moon respectively.
%
% [h] is the step size
%
% [IC] is a 12x1 matrix containing the initial conditions which are the
% starting positions and velocities of the earth and moon. These are in the
% same format as 'X' and are normalised to Astronomical Units (AU) in
% distance and Earth days in time. This matrix forms the first column of
% 'V'.
%
% [dV] contains the matrix of the inline functions that are the derivatives
% of its corresponding 'V'.
% [VXe; VYe; VZe; VXm; VYm; VZm; AXe; AYe; AZe; AXm; AYm; AZm]
% Here any variable starting with V correspondds to a velocity and A
% corresponds to an acceleration
%
% [days] is the number of days on earth we want to run the simulation for

% Authors: Sara Lolatte, Joan McCarthy, Ailis Muldoon
% $Revision: 5 $ $Date: 2015/04/22 09:22:03 $

if (nargin>4)||(nargin<4)
    error('Number of input arguments must be 4'); 
elseif h<0    
     error('Step size, h, must be greater than zero');
elseif days<0
     error('Number of days must be greater than zero');
elseif ~iscolumn(IC)
    error('Initial conditions mustbe input as a column vector');
end

% Runge Kutta Method
columns = days/h;
rows=length(IC);
V = zeros(rows,columns);
V(:,1) = IC;
w1 = 1/6; w2 = 2/6; w3 = 2/6; w4 = 1/6;
a1 = 1/2; a2 = 1/2; a3 = 1;

for i = 1:columns
    k1=h*dV(V(:,i));
    k2=h*dV(V(:,i)+(a1*k1));
    k3=h*dV(V(:,i)+(a2*k2));
    k4=h*dV(V(:,i)+(a3*k3)); 

    V(:,i+1) = V(:,i)+((w1*k1)+(w2*k2)+(w3*k3)+(w4*k4));
end

end