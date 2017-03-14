Xm = 8.424150721785798E-01;  
Ym = 1.222598843926465E+00;  
Zm = 4.941077138901599E-03;
VXm = -1.098994452300823E-02;  
VYm = 9.132121162838278E-03;  
VZm =  4.610929659494698E-04;
Xd = 8.424926760520768E-01;  
Yd = 1.222732909234070E+00; 
Zd =  4.916893967038022E-03;
VXd = -1.157966196592827E-02;  
VYd =  9.531246869327046E-03; 
VZd = 7.807360872199656E-04;
Xp =  8.424066400672897E-01;  
Yp = 1.222536953162029E+00;  
Zp =  4.940709227440207E-03;
VXp = -9.882207567727947E-03;  
VYp = 9.002731056216415E-03; 
VZp = -7.792712522862012E-05;

Ms = 1.9891E30;
Mm = 6.4185E23;
Md = 1.4762E15;
Mp = 1.0659E16;
G = 6.67e-11;
AU = 149597870700;
TU = 86400; % seconds in a day
CS = (G*Ms*TU^2)/(AU^3);
CM = (G*Mm*TU^2)/(AU^3);
CD = (G*Md*TU^2)/(AU^3);
CP = (G*Mp*TU^2)/(AU^3);

save('MarsData')