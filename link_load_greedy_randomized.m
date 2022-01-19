function [best_load,num_solutions,mean_solutions,allValues] = link_load_greedy_randomized(tempo,nNodes,Links,T,sP,nSP)
    nFlows= size(T,1);
    %Optimization algorithm resorting to the random greedy strategy:
    t= tic;
    bestLoad= inf;
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
                if load<best
                    k_best= k;
                    best= load;
                end
             end
             sol(i)= k_best;
        end
        Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
        load= max(max(Loads(:,3:4)));
        allValues= [allValues load];
        if load<bestLoad
            bestSol= sol;
            bestLoad= load;
        end
    end
    best_load = bestLoad;
    num_solutions = length(allValues);
    mean_solutions = mean(allValues);
end

