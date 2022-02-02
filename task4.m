close all;
clearvars;
clear all;
clc;

fprintf("Task 4\n");

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

MTBF= (450*365*24)./L;
A= MTBF./(MTBF + 24);
A(isnan(A))= 0;

Alog = -log(A);
fprintf("\nAlínea a)\n");
[bestPath, secondPath] = kpath_with_disjoint(Alog,T,10);
for i=1:nFlows  
    

    fprintf("Flow %d:\n",i);
    for k=1:10
        availabilityBest = 1;
        availabilitySecond = 1;
        fprintf("\tPath %d: %d",k,bestPath{i}{k}(1));
        for j= 2:length(bestPath{i}{k})
            fprintf("-%d",bestPath{i}{k}(j));
            availabilityBest = availabilityBest * A(bestPath{i}{k}(j-1),bestPath{i}{k}(j));
        end
        fprintf("\t\tAlternative: ");
        if ~isempty(secondPath{i}{k})
            fprintf("%d",secondPath{i}{k}{1}(1));
            for j=2:length(secondPath{i}{k}{1})
                fprintf("-%d",secondPath{i}{k}{1}(j));
                availabilitySecond = availabilitySecond * A(secondPath{i}{k}{1}(j-1),secondPath{i}{k}{1}(j));
            end
        else
            fprintf("No alternative Found!!!");
            availabilitySecond = 0;
        end
        pairAvailability = 1-((1-availabilityBest) * (1-availabilitySecond));
        fprintf("\t\tPair Availability: %0.5f%%",pairAvailability*100);
        fprintf("\n");
    end
end

%% Alínea b)
time = 30;
nSP = ones(1,10) .* 10;
serviceAvailability = 0;
fprintf("\nAlínea b)\n");
[best_load, best_sol, values] = disjoint_hill_climbing(time,nNodes,Links,T,bestPath,secondPath,nSP);

for i=1:nFlows
    availabilityBest = 1;
    availabilitySecond = 1;
    fprintf("Flow %d:\n",i);
    fprintf("\tBest Pair: %d",bestPath{i}{best_sol(i)}(1));
    for j= 2:length(bestPath{i}{best_sol(i)})
        fprintf("-%d",bestPath{i}{best_sol(i)}(j));
        availabilityBest = availabilityBest * A(bestPath{i}{best_sol(i)}(j-1),bestPath{i}{best_sol(i)}(j));
    end
    fprintf("\t\tAlternative: %d",secondPath{i}{best_sol(i)}{1}(1));
    for j= 2:length(secondPath{i}{best_sol(i)}{1})
        fprintf("-%d",secondPath{i}{best_sol(i)}{1}(j));
        availabilitySecond = availabilitySecond * A(secondPath{i}{best_sol(i)}{1}(j-1),secondPath{i}{best_sol(i)}{1}(j));
    end

    pairAvailability = 1-((1-availabilityBest) * (1-availabilitySecond));
    serviceAvailability = serviceAvailability + pairAvailability;
    fprintf("\n\tPair Availability: %0.5f%%",pairAvailability*100);
    fprintf("\n");
end
fprintf("\nAverage Service Availability: %0.5f%%\n",(serviceAvailability/nFlows)*100);
fprintf("Highest Required Bandwidth: %0.3f Gbps\n",best_load);
plot(sort(values));