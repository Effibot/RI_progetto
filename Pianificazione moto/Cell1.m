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
    end
    
    methods
        function obj = Cell1(value,idx,dim)
            %CELL1 Construct an instance of this class
            %   Detailed explanation goes here
            obj.value = value;
            obj.idx=idx;
            obj.dim=dim;
            obj.children=Cell1.empty;
            obj.obstacles=Cell1.empty;
            obj.father=Cell1.empty;
        end
        function obj = addChildren(obj,child,father)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.children(end+1)=child;
            if ~isempty(father)
            obj.father(end+1)=father;
            end
        end
        
    end
end

