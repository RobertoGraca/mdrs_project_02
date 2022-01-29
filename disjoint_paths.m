function [djPath]= disjoint_paths(Alog,T)
    nFlows= size(T,1);
    AlogTemp = Alog;
    for i=1:nFlows
        [shortestPath, totalCost] = kShortestPath(Alog,T(i,1),T(i,2),1);
        djPath{i} = shortestPath;

        for j=2:length(shortestPath)
            row = shortestPath(j-1);
            col = shortestPath(j);
            row
            col
            AlogTemp(row,col) = inf;
        end
        AlogTemp
        [shortestPath, totalCost] = kShortestPath(AlogTemp,T(i,1),T(i,2),2);
        djPath{i} = shortestPath;
    end
end

