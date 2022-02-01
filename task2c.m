close all;
clearvars;
clear all;
clc;

fprintf("Task 2\n");

Nodes= [30 70
       350 40
       550 180
       310 130
       100 170
       540 290
       120 240
       400 310
       220 370
       550 380];
   
Links= [1 2
        1 5
        2 3
        2 4
        3 4
        3 6
        3 8
        4 5
        4 8
        5 7
        6 8
        6 10
        7 8
        7 9
        8 9
        9 10];

T= [1  3  1.0 1.0
    1  4  0.7 0.5
    2  7  2.4 1.5
    3  4  2.4 2.1
    4  9  1.0 2.2
    5  6  1.2 1.5
    5  8  2.1 2.5
    5  9  1.6 1.9
    6 10  1.4 1.6];

nNodes= 10;
nLinks= size(Links,1);
nFlows= size(T,1);

co= Nodes(:,1)+j*Nodes(:,2);
L= inf(nNodes);    %Square matrix with arc lengths (in Km)
for i=1:nNodes
    L(i,i)= 0;
end
for i=1:nLinks
    d= abs(co(Links(i,1))-co(Links(i,2)));
    L(Links(i,1),Links(i,2))= d+5; %Km
    L(Links(i,2),Links(i,1))= d+5; %Km
end
L= round(L);  %Km

% Compute up to n paths for each flow:
n= inf;
[sP nSP]= calculatePaths(L,T,n);

tempo= 10;

% Alinea c

fprintf('Alinea c1\n');

[bestEnergy,numSolutions,meanSolutions,values] = energy_hill_climbing(tempo,nNodes,Links,T,L,sP,nSP);

figure(1);
hold on;
plot(sort(values));
fprintf('ENERGY MULTI START HILL CLIMBING:\n');
fprintf('   Best energy = %.2f \n',bestEnergy);
fprintf('   No. of solutions = %d\n',numSolutions);
fprintf('   Av. quality of solutions = %.2f \n',meanSolutions);

fprintf('Alinea c2\n');
tmp = {};
for i=1:nFlows
    for k=1:10
        tmp{i}{k} = sP{i}{k};
    end
end
sP = tmp;
nSP = zeros(1,nFlows) + 10;

[bestEnergy,numSolutions,meanSolutions,values] = energy_hill_climbing(tempo,nNodes,Links,T,L,sP,nSP);

hold on;
plot(sort(values));
fprintf('ENERGY MULTI START HILL CLIMBING:\n');
fprintf('   Best energy = %.2f \n',bestEnergy);
fprintf('   No. of solutions = %d\n',numSolutions);
fprintf('   Av. quality of solutions = %.2f \n',meanSolutions);

fprintf('Alinea c3\n');
tmp = {};
for i=1:nFlows
    for k=1:10
        tmp{i}{k} = sP{i}{k};
    end
end
sP = tmp;
nSP = zeros(1,nFlows) + 5;

[bestEnergy,numSolutions,meanSolutions,values] = energy_hill_climbing(tempo,nNodes,Links,T,L,sP,nSP);

hold on;
plot(sort(values));
fprintf('ENERGY MULTI START HILL CLIMBING:\n');
fprintf('   Best energy = %.2f \n',bestEnergy);
fprintf('   No. of solutions = %d\n',numSolutions);
fprintf('   Av. quality of solutions = %.2f \n',meanSolutions);
title('Energy Multi Start Hill Climbing')
legend({'All','Top 10','Top 5'},'Location','southeast');
hold off;
