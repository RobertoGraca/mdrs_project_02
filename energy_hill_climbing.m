function [best_energy,num_solutions,mean_solutions,allValues] = energy_hill_climbing(tempo,nNodes,Links,T,L,sP,nSP)
    nFlows= size(T,1);
    nLinks= size(Links,1);
    %Optimization algorithm with multi start hill climbing:
    t= tic;
    bestEnergy= inf;
    allValues= [];
    while toc(t)<tempo
        %GREEDY RANDOMIZED:
        continuar= true;
        while continuar
            continuar= false;
            ax2= randperm(nFlows);
            sol= zeros(1,nFlows);
            for i= ax2
                k_best= 0;
                best= inf;
                for k= 1:nSP(i)
                    sol(i)= k;
                    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
                    load= max(max(Loads(:,3:4)));
                    if load <= 10
                        energy= 0;
                        for a= 1:nLinks
                            if Loads(a,3)+Loads(a,4)>0
                                energy= energy + L(Loads(a,1),Loads(a,2));
                            end
                        end
                    else
                        energy= inf;
                    end
                    if energy<best
                        k_best= k;
                        best= energy;
                    end            
                end
                if k_best>0
                    sol(i)= k_best;
                else
                    continuar= true;
                    break;
                end
            end
        end 
        energy= best;
        
        %HILL CLIMBING:
        continuar= true;
        while continuar
            i_best= 0;
            k_best= 0;
            best= energy;
            for i= 1:nFlows
                for k= 1:nSP(i)
                    if k~=sol(i)
                        aux= sol(i);
                        sol(i)= k;
                        Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
                        load1= max(max(Loads(:,3:4)));
                        if load1 <= 10
                            energy1= 0;
                            for a= 1:nLinks
                                if Loads(a,3)+Loads(a,4)>0
                                    energy1= energy1 + L(Loads(a,1),Loads(a,2));
                                end
                            end
                        else
                            energy1= inf;
                        end
                        if energy1<best
                            i_best= i;
                            k_best= k;
                            best= energy1;
                        end
                        sol(i)= aux;
                    end
                end
            end
            if i_best>0
                sol(i_best)= k_best;
                energy= best;
            else
                continuar= false;
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
