close all;
clearvars;
clear all;
clc;

fprintf("Task 3\n");

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

mAvPath = mostAvailablePath(Alog,T,1);

%% Alínea a)

fprintf("Alínea a)\n");

for i=1:nFlows
    availability = 1;
    for j=2:length(mAvPath{i}{1})
        row = mAvPath{i}{1}(j-1);
        col = mAvPath{i}{1}(j);
        availability = availability * A(row,col);
    end
    fprintf("Most Available Path in Flow %d: %d",i,mAvPath{i}{1}(1));
    for j= 2:length(mAvPath{i}{1})
        fprintf("-%d",mAvPath{i}{1}(j));
    end
    fprintf("\nAvailability: %0.5f \n\n",availability);
end
%% Alinea b)

fprintf("Alínea b)\n");
[bestPath, secondPath] = disjoint_paths(Alog,T);
serviceAvailability = 0;
for i=1:nFlows
    availabilityBest = 1;
    availabilitySecond = 1;
    fprintf("Flow %d:\n",i);
    fprintf("\tBest Path: %d",bestPath{i}{1}(1));
    for j= 2:length(bestPath{i}{1})
            fprintf("-%d",bestPath{i}{1}(j));
    end
    
    fprintf("\tAlternative path: %d",secondPath{i}{1}(1));
    if ~isempty(secondPath{i})
        for j= 2:length(secondPath{i}{1})
                fprintf("-%d",secondPath{i}{1}(j));
        end
    else
        fprintf("No alternative found!!!");
    end

    for j=2:length(bestPath{i}{1})
        availabilityBest = availabilityBest * A(bestPath{i}{1}(j-1),bestPath{i}{1}(j));
    end
    fprintf("\n\tAvailability for best path: %0.5f%%\n",availabilityBest*100);
    for j=2:length(secondPath{i}{1})
        availabilitySecond = availabilitySecond * A(secondPath{i}{1}(j-1),secondPath{i}{1}(j));
    end
    fprintf("\tAvailability for second path: %0.5f%%\n",availabilitySecond*100);
    pairAvailability = 1-((1-availabilityBest) * (1-availabilitySecond));
    fprintf("\tPair Availability: %0.5f%%\n\n",pairAvailability*100);
    serviceAvailability = serviceAvailability + pairAvailability;
end
fprintf("Service Availability: %0.5f%%\n\n",(serviceAvailability/nFlows)*100);

%% Alínea c)

fprintf("\nAlínea c)\n");
Loads= calculateLinkLoads1plus1(nNodes,Links,T,bestPath,secondPath)
totalLoad= sum(sum(Loads(:,3:4)));
fprintf("Protection 1+1 Total Bandwidth: %0.3f Gbps\n",totalLoad);
maxLoad= max(max(Loads(:,3:4)));
fprintf("Protection 1+1 Highest Bandwidth: %0.3f Gbps\n\n",maxLoad);

for l=1:nLinks
    if Loads(l,3) > 10 || Loads(l,4) > 10
        fprintf("Link between %d and %d do not have enough capacity\n",Loads(l,1),Loads(l,2));
    end
end

%% Alínea d)

fprintf("\nAlínea d)\n");
Loads= calculateLinkLoads1to1(nNodes,Links,T,bestPath,secondPath)
totalLoad= sum(sum(Loads(:,3:4)));
fprintf("Protection 1:1 Total Load: %0.3f Gbps\n",totalLoad);
maxLoad= max(max(Loads(:,3:4)));
fprintf("Protection 1:1 Highest Bandwidth: %0.3f Gbps\n\n",maxLoad);

for l=1:nLinks
    if Loads(l,3) > 10 || Loads(l,4) > 10
        fprintf("Link between %d and %d do not have enough capacity\n",Loads(l,1),Loads(l,2));
    end
end

