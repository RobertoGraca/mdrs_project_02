function [mAvPath]= calculateMostAvailablePath(Alog,T,n)
    nFlows= size(T,1);
    for i=1:nFlows
        [shortestPath, totalCost] = kShortestPath(Alog,T(i,1),T(i,2),n);
        mAvPath{i} = shortestPath;
    end
end

