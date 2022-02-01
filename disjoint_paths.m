function [bestPath, secondPath]= disjoint_paths(Alog,T)
    nFlows = size(T,1);
    for i=1:nFlows
        AlogTemp = Alog;
        [shortestPath, totalCost] = kShortestPath(Alog,T(i,1),T(i,2),1);
        bestPath{i} = shortestPath;

        for j=2:length(shortestPath{1})
            row = shortestPath{1}(j-1);
            col = shortestPath{1}(j);
            AlogTemp(row,col) = inf;
        end
        [sP, tC] = kShortestPath(AlogTemp,T(i,1),T(i,2),1);
        secondPath{i} = sP;
    end
end

