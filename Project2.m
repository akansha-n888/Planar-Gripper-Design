%% MEC411 Project 2
% ploted calculations are shown for connected links 2 and 4
% values for links 3 and 5 are the same as 2 and 4 bc the system is
% symmetric
clear all;
close all;
%% Design Paramters
% Max Design Conditions: 150H x 250L x 200W (mm)
r2= 70;         
r3= 70;
r4= 57;
r5 = 57;
r1 = r2 + r4;       % r1 < 250 mm

% links are assumed to have 0 mass
% so no inertial effects
m2 = 0;         
m3 = 0;         
m4 =0;          
m5 = 0;  

% force from given cup
Fcupx = 10/2; 
Fcupy = (0.002*9.8)/2;
%% Iterate for theta2 & theta4
% given the design, theta2 can rotate btwn 0 and 90 deg
% assuming that 0 deg is along r1
% given the design, theta4 can rotate btwn -90 and 90 deg
% assuming that 0 deg is along r1
XB_YB = [];
XA_YA = [];
A33_list = [];
A34_list = [];
A65_list = [];
A66_list = [];
theta = [];
for theta4 = 0:1:60
    for theta2 = 56:1:90
        % xb and yb distances wrt to theta2
        xb = r2*cos(theta2);
        yb = r2*sin(theta2);
        XB_YB = [XB_YB;xb yb];
        % for polar plot
        A33 = -r2*sin(theta2);
        A34 = r2*cos(theta2);
        A33_list = [A33_list;A33];
        A34_list = [A34_list;A34];
        
        % xa and ya distances wrt to theta2
        xa = xb + r4*cos(theta4);
        ya = yb - r4*sin(theta4);
        XA_YA = [XA_YA; xa ya];
        % for polar plot
        A65 = r4*sin(theta4);
        A66 = r4*cos(theta4);
        A65_list = [A65_list;A65];
        A66_list = [A66_list;A66];
        
        theta = [theta;theta2];
    end
    
end
%% Plots (distance)
% plot of distances wrt to theta2
figure
plot(XB_YB(:,1),XB_YB(:,2))
title('Horizontal & Vertical Distance Plot for R2')
xlabel('xb')
ylabel('yb')
hold on
% plot of distances wrt to theta4
figure
plot(XA_YA(:,1),XA_YA(:,2))
title('Horizontal & Vertical Distance Plot for R4')
xlabel('xa')
ylabel('ya')
%% Dynamic Analysis (Motion Equations)
% motion equations are from derived calcs for links 2 and 4
% all masses of links are 0
i = 0;
Fs_data = [];
Ms_data = [];
while (i < length(A33_list))
    i = i+1;
    A33 = A33_list(i);
    A34 = A34_list(i);
    A65 = A65_list(i);
    A66 = A66_list(i);
    
    A10 = [-1 0 1 0 0 0 0 0];
    A20 =  [0 -1 0 1 0 0 0 0];
    A30 = [0 0 A33 A34 0 0 1 0];
    A40 = [0 0 -1 0 1 0 0 0];
    A50 = [0 0 0 -1 0 1 0 0];
    A60 = [0 0 0 0 A65 A66 0 1];
    A70 = [0 0 0 0 1 0 0 0];
    A80 = [0 0 0 0 0 1 0 0];

    A = [A10; A20; A30;A40;A50;A60;A70;A80];
    B = [0 0 0 0 0 0 Fcupx Fcupy]';
    X = linsolve(A,B);

    % From Solving Linear Eqns in Matrix Form
    F12x = X(1);
    F12y = X(2);
    F42x = X(3);
    F42y = X(4);
    Fc4x = X(5);
    Fc4y = X(6);
    M12 = X(7);
    M42 = X(8);

    % Shaking Force
    % idk about this part is it --> abs(((F12x+F42x)^2 +(F12y+F42y)^2)^(1/2))
    Fs = abs(((F12x)^2 +(F12y)^2)^(1/2));
    Fs_data = [Fs_data;Fs];
    % Shaking Moment
    % idk about this part is it --> M12 + M42
    Ms = M12;
    Ms_data = [Ms_data; Ms];
end
%% Shaking Moment and Shaking Force Polar Plots
figure
polarplot(theta,Fs_data)
title('Shaking Force Polar Plot')
hold on
figure
polarplot(theta,Ms_data)
title('Shaking Moment Polar Plot')