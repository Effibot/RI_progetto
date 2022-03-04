classdef rectNode<handle

    properties
        bc %baricentro
        adj %lista adiacente
        dim %dimensione
        perim %perimetro
        lc  %indice nella mappa in alto a sinistra
        corner %lista degli spigoli
        rect
        id
        % r = non attraversabile
        % g = attraversabile
        % y = indecisa per il passo corrente
        prop
        value
        father
        child
    end

    methods
        function obj = rectNode(bc, lc, dim, corner,id, value)
            obj.bc=bc;
            obj.lc=lc;
            obj.dim=dim;
            obj.adj=[];
            obj.corner = corner;
            obj.id=id;
            obj.prop = 'y';
            obj.value = value;
            obj.father = rectNode.empty(0,1);
            obj.child = rectNode.empty(0,1);
        end

        function setAdj(obj,adj)
            obj.adj(end+1)=adj;
        end
        function setParent(obj, parent)
            obj.father = parent;
        end
        function addChildren(obj, node)
            obj.child(end+1) = node;
        end
        function addChildrenList(obj, nodeList)
            obj.child = nodeList;
        end
        function childList = getChildren(obj)
            childList = obj.child;            
        end
        function child = getChild(obj, num)
            child = obj.child(num);
        end
    end
end

