function [best_load, best_sol] = disjoint_hill_climbing(time,nNodes,Links,T,sP1,sP2,nSP)
    nFlows= size(T,1);
    %Optimization algorithm with multi start hill climbing:
    t= tic;
    bestLoad= inf;
    allValues= [];
    while toc(t) < time
        
        %GREEDY RANDOMIZED:
        ax2= randperm(nFlows);
        sol= zeros(1,nFlows);
        for i= ax2
            k_best= 0;
            best= inf;
            for k= 1:nSP(i)
                sol(i)= k;
                Loads= calculateLinkLoads1to1Adapted(nNodes,Links,T,sP1{i},sP2{i},sol);
                load= max(max(Loads(:,3:4)));
                if load<best
                    k_best= k;
                    best= load;
                end
            end
            sol(i)= k_best;
        end

        Loads= calculateLinkLoads1to1Adapted(nNodes,Links,T,sP1{i},sP2{i},sol);
        load= best;
        
        %HILL CLIMBING:
        continuar= true;
        while continuar
            i_best= 0;
            k_best= 0;
            best= load;
            for i= 1:nFlows
                for k= 1:nSP(i)
                    if k~=sol(i)
                        aux= sol(i);
                        sol(i)= k;
                        Loads= calculateLinkLoads1to1Adapted(nNodes,Links,T,sP1{i},sP2{i},sol);
                        load1= max(max(Loads(:,3:4)));
                        if load1<best
                            i_best= i;
                            k_best= k;
                            best= load1;
                        end
                        sol(i)= aux;
                    end
                end
            end
            if i_best>0
                sol(i_best)= k_best;
                load= best;
            else
                continuar= false;
            end
        end
        allValues= [allValues load];
        if load<bestLoad
            bestSol= sol;
            bestLoad= load;
        end
    end
    best_load = bestLoad;
    best_sol = bestSol;
    num_solutions = length(allValues);
    mean_solutions = mean(allValues);
end