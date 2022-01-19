function [best_load,num_solutions,mean_solutions,allValues] = link_load_random(tempo,nNodes,Links,T,sP,nSP)
    nFlows= size(T,1);
    %Optimization algorithm resorting to the random strategy:
    t= tic;
    bestLoad= inf;
    sol= zeros(1,nFlows);
    allValues= [];
    while toc(t)<tempo
        for i=1:nFlows
            sol(i) = randi(nSP(i));
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

