function [best_energy,num_solutions,mean_solutions,allValues] = energy_random(tempo,nNodes,Links,T,L,sP,nSP)
    nFlows= size(T,1);
    nLinks= size(Links,1);
    %Optimization algorithm resorting to the random strategy:
    t= tic;
    bestEnergy= inf;
    sol= zeros(1,nFlows);
    allValues= [];
    while toc(t)<tempo
        continuar = true;
        while continuar
            continuar = false;
            for i=1:nFlows
                sol(i) = randi(nSP(i));
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
                continuar = true;
            end
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

