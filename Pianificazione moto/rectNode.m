classdef rectNode<handle

    properties
        bc %baricentro
        adj %lista adiacente
        dim %dimensione
        perim %perimetro
        lc%indice nella mappa in alto a sinistra
        corner %lista degli spigoli
        rect
        id
    end
    
    methods
        function obj = rectNode(bc, lc, dim, corner,id)
            obj.bc=bc;
            obj.lc=lc;
            obj.dim=dim;
            obj.adj=[];
            obj.corner = corner;
            obj.id=id;
        end
        
        function setAdj(obj,adj)
            obj.adj(end+1)=adj;
        end
    end
end

