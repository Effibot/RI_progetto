classdef Cell1<handle
    %CELL1 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        children
        father
        value
        idx
        obstacles
        dim
        allchildren
        bc
    end
    
    methods
        function obj = Cell1(value,idx,dim)
            %CELL1 Construct an instance of this class
            %   Detailed explanation goes here
            obj.value = value;
            obj.idx=idx;
            obj.dim=dim;
            obj.children=Cell1.empty;
            obj.obstacles=double.empty;
            obj.allchildren=Cell1.empty;
            obj.getBc(idx,dim);
        end
        function getBc(obj,idx,dim)
            obj.bc=[fix(idx(1)+dim/2),fix(dim+idx(2)/2)];
        end
        function obj = addChildren(obj,child,father)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.children(end+1)=child;
            child.father=father;
        end
        function obj=setAllChildren(obj,child)
            ma=child;
            val=false;
            while ma.dim~=64 
                ma=ma.father;
                val=true;
            end
            if val==true
            obj.allchildren(end+1)=child;
            end
        end
        
    end
end

