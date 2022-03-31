function bc = getbcprop(nodeList, prop)
    obsList = findobj(nodeList,'prop',prop);
    listLength = size(obsList, 1);
    bc = zeros(listLength, 2);
    for i = 1:listLength
        bc(i,:) = obsList(i).bc;
    end
end