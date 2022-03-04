function nodeList = getAllNode(node, nodeList)
    list = node.getChildren();
    if ~isempty(list)
        nodeList = [nodeList, list];        
        for n = list
            nodeList = getAllNode(n, nodeList);
        end    
    end 
end