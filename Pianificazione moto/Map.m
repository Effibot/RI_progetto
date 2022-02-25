classdef Map <handle
    properties
        gridSize
        cells
        obstacles
        grid
        cellsize
    end
    methods
        function obj=Map(gridSize,obstacles,cellsize)
            obj.gridSize=gridSize;
            obj.grid = zeros(gridSize(1),gridSize(2));
            obj.cellsize=cellsize;
            for i=1:size(obstacles,1)
                x=obstacles(i,1);
                y=obstacles(i,2);
                r=obstacles(i,3);
                obj.grid(x,y)=1;
                obj.grid(fix(-r/2)+x-1:fix(r/2)+x+1,fix(-r/2)+y-1:fix(r/2)+y+1)=1;
            end

        end
        function obj=populateMap(obj,cellsize)
%             for i=1:cellsize:obj.gridSize(1)
%                 
%             end
            fun = @(block_struct) f(block_struct.data);
            ret=blockproc(obj.grid,[cellsize cellsize],fun);
            obj.grid=ret;
        end
        function obj=makecells(obj,dimRobot)
            if obj.cellSizs==dimRobot+1
                return
            elseif isValid()
            end
        end
    end
end