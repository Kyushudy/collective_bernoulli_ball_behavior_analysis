function [e] = sim_4balloon_test()
tic;
for i = 1:10
    try
% l``
x = [5.733637e-03  8.710846e-05  6.094777e-02  1.280106e+00  9.584429e-01  1.415804e-02  7.351463e+00  1.227012e+07  9.542261e+02  1.378716e-04  7.618900e+04  8.190700e+04  3.644500e+04  5.488100e+04  8.267400e+04  1.033700e+04  8.498900e+04  1.273100e+04  5.266700e+04  7.533400e+04  6.884000e+04  7.769500e+04  2.730491e-02  3.032024e-02  1.489993e-01  6.887483e-02];

realworlddata = [0.749644772755327,0.0686578815645776,0.00748711383812277];
load('coefficient_dragq.mat', 'coefficient_dragq');
load('coefficient_sideforceq.mat', 'coefficient_sideforceq');

% % Random seed
% seedX1 = x(11);
% seedY1 = x(12);
% seedZ1 = x(13);
% seedX2 = x(14);
% seedY2 = x(15);
% seedZ2 = x(16);
% seedX3 = x(17);
% seedY3 = x(18);
% seedZ3 = x(19);
% seedX4 = x(20);
% seedY4 = x(21);
% seedZ4 = x(22);

% Random seed
seedX1 = randi(100000);
seedY1 = randi(100000);
seedZ1 = randi(100000);
seedX2 = randi(100000);
seedY2 = randi(100000);
seedZ2 = randi(100000);
seedX3 = randi(100000);
seedY3 = randi(100000);
seedZ3 = randi(100000);
seedX4 = randi(100000);
seedY4 = randi(100000);
seedZ4 = randi(100000);

if istable(x)
    %Noise params
    nV = x.nV;
    nH = x.nH;
    nS = x.nS;
    
    %Flow params
    V0 = x.V0;
    normalScaling = x.normalScaling;
    hd = x.hd;
    theta =  x.theta;

    %Contact params
    k = x.k;
    d = x.d;
    tw = x.tw;
    
else
    %Noise params
    nV = x(1);
    nH = x(2);
    nS = x(3);
    
    %Flow params
    V0 = x(4);
    normalScaling = x(5);
    hd = x(6);
    theta = x(7);

    %Contact modelling
    k = x(8);
    d = x(9);
    tw = x(10);

end


%Known params
rn =  125/2000; %Radius of nozzle in m
Cd = 0.418;
rb = 80/1000;
rb1 = 80/1000;
rb2 = 80/1000;
rb3 = 80/1000;
rb4 = 80/1000;
mb1 = 3/1000; %Balloon mass in kg
mb2 = 3/1000; %Balloon mass in kg
mb3 = 3/1000; %Balloon mass in kg
mb4 = 3/1000; %Balloon mass in kg

% interaction
simOut = sim("simulink_4_balloons",'FastRestart','off','SrcWorkspace'...
    ,'current');

balloon1 = simOut.yout{1}.Values;
balloon2 = simOut.yout{2}.Values;
balloon3 = simOut.yout{3}.Values;
balloon4 = simOut.yout{4}.Values;
X1 = balloon1.x.data;
Y1 = balloon1.y.data;
Z1 = balloon1.z.data;
X2 = balloon2.x.data;
Y2 = balloon2.y.data;
Z2 = balloon2.z.data;
X3 = balloon3.x.data;
Y3 = balloon3.y.data;
Z3 = balloon3.z.data;
X4 = balloon4.x.data;
Y4 = balloon4.y.data;
Z4 = balloon4.z.data;

%%Position
meanZ = realworlddata(1);
varZ = realworlddata(2);
varXY = realworlddata(3);

meanZError = abs(((mean(Z1) + mean(Z2) + mean(Z3) + mean(Z4))/4 - meanZ)/meanZ);
varZError = abs(((var(Z1) + var(Z2) + var(Z3) + var(Z4))/4 - varZ)/varZ);
varXYError = abs(((var(X1) + var(Y1) + var(X2) + var(Y2) + ...
    var(X3) + var(Y3) + var(X4) + var(Y4))/8 - varXY)/varXY);
e = (meanZError + varZError + varXYError)/3;

filename = ['data_4_balloons_l``' num2str(i) '.mat'];
save(filename);
    end
end

toc;

end

