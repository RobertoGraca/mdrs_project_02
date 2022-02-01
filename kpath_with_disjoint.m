function [bestPath, secondPath]= kpath_with_disjoint(Alog,T,n)
    nFlows = size(T,1);
    for i=1:nFlows
        [shortestPath, totalCost] = kShortestPath(Alog,T(i,1),T(i,2),n);
        bestPath{i} = shortestPath;
        for k=1:n
            AlogTemp = Alog;
            for j=2:length(bestPath{i}{k})
                row = bestPath{i}{k}(j-1);
                col = bestPath{i}{k}(j);
                AlogTemp(row,col) = inf;
                AlogTemp(col,row) = inf;
            end
            [sP, tC] = kShortestPath(AlogTemp,T(i,1),T(i,2),1);
            secPaths{k} = sP;
        end
        secondPath{i} = secPaths;
    end
end

