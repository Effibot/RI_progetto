classdef Cell1<handle
    %CELL1 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        children
        father
        value
        idx
    end
    
    methods
        function obj = Cell1(value,idx)
            %CELL1 Construct an instance of this class
            %   Detailed explanation goes here
            obj.value = value;
            obj.idx=idx;
            obj.children=Cell1.empty;
        end
        
        function obj = addChildren(obj,child)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.children(end+1)=child;
        end
    end
end

