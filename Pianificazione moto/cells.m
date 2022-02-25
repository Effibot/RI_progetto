classdef cells
    %CELLS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bc
        id
        dim
        isValid
    end
    
    methods
        function obj = cells(bc,id,dim)
            %CELLS Construct an instance of this class
            %   Detailed explanation goes here
            obj.bc=bc;
            obj.id=id;
            obj.dim=dim;
        end
        
        function outputArg = setdisp(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

