close all;
clearvars;
clear all;
clc;

fprintf("Task 1\n");

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



% Alinea a
fprintf('Alinea a\n');

% Compute up to n paths for each flow:
n= inf;
[sP, nSP]= calculatePaths(L,T,n);
for i=1:nFlows
    fprintf('Flow from %d to %d - %d paths\n',T(i,1),T(i,2),length(sP{i}));
end

% Alinea b

fprintf('Alinea b1\n');
tempo= 10;
[bestLoad,numSolutions,meanSolutions,values] = link_load_random(tempo,nNodes,Links,T,sP,nSP);

figure(1);
hold on;
plot(sort(values));
fprintf('RANDOM:\n');
fprintf('   Best load = %.2f Gbps\n',bestLoad);
fprintf('   No. of solutions = %d\n',numSolutions);
fprintf('   Av. quality of solutions = %.2f Gbps\n',meanSolutions);

fprintf('Alinea b2\n');

tmp = {};
for i=1:nFlows
    for k=1:10
        tmp{i}{k} = sP{i}{k};
    end
end
sP = tmp;
nSP = zeros(1,nFlows) + 10;

tempo= 10;
[bestLoad,numSolutions,meanSolutions,values] = link_load_random(tempo,nNodes,Links,T,sP,nSP);

hold on;
plot(sort(values));
fprintf('RANDOM for 10 best paths:\n');
fprintf('   Best load = %.2f Gbps\n',bestLoad);
fprintf('   No. of solutions = %d\n',numSolutions);
fprintf('   Av. quality of solutions = %.2f Gbps\n',meanSolutions);



fprintf('Alinea b3\n');

tmp = {};
for i=1:nFlows
    for k=1:5
        tmp{i}{k} = sP{i}{k};
    end
end
sP = tmp;
nSP = zeros(1,nFlows) + 5;

tempo= 10;
[bestLoad,numSolutions,meanSolutions,values] = link_load_random(tempo,nNodes,Links,T,sP,nSP);

hold on;
plot(sort(values));
fprintf('RANDOM for 5 best paths:\n');
fprintf('   Best load = %.2f Gbps\n',bestLoad);
fprintf('   No. of solutions = %d\n',numSolutions);
fprintf('   Av. quality of solutions = %.2f Gbps\n',meanSolutions);
title('Link Load Random');
legend({'All','Top 10','Top 5'},'Location','northwest');
hold off;