function [best_energy,num_solutions,mean_solutions,allValues] = energy_greedy_randomized(tempo,nNodes,Links,T,L,sP,nSP)
    nFlows= size(T,1);
    nLinks= size(Links,1);
    %Optimization algorithm resorting to the random greedy strategy:
    t= tic;
    bestEnergy= inf;
    sol= zeros(1,nFlows);
    allValues= [];
    while toc(t)<tempo
        ax2= randperm(nFlows);
        sol= zeros(1,nFlows);
        for i= ax2
            k_best= 0;
            best= inf;
            for k= 1:nSP(i)
                sol(i)= k;
                Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
                load= max(max(Loads(:,3:4)));
                energy = 0;
                if load <= 10
                    for a=1:nLinks
                        if(Loads(a,3)+Loads(a,4) > 0)
                            energy = energy + L(Loads(a,1),Loads(a,2));
                        end
                    end
                else
                    energy = inf;
                end
                if energy<best
                    k_best= k;
                    best= energy;
                end
             end
             sol(i)= k_best;
        end
        Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
        load= max(max(Loads(:,3:4)));
        energy = 0;
        if load <= 10
            for i=1:nLinks
                if(Loads(i,3)+Loads(i,4) > 0)
                    energy = energy + L(Loads(i,1),Loads(i,2));
                end
            end
        else
            energy = inf;
        end
        allValues= [allValues energy];
        if energy<bestEnergy
            bestSol= sol;
            bestEnergy= energy;
        end
    end
    best_energy = bestEnergy;
    num_solutions = length(allValues);
    mean_solutions = mean(allValues);
end

