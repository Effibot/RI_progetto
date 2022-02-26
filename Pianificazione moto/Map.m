classdef Map <handle
    properties
        gridSize
        cell
        obstacles
        grid
        cellsize
        cellRobot
        fun
    end
    methods
        function obj=Map(gridSize,obstacles,cellsize,cellRobot)
            obj.gridSize=gridSize;
            obj.grid = zeros(gridSize(1),gridSize(2));
            obj.cellsize=cellsize;
            obj.obstacles = obstacles;
            obj.cellRobot=cellRobot;
            obj.fun = @(block_struct) f(block_struct,obj);
            for i=1:size(obstacles,1)
                x=obstacles(i,1);
                y=obstacles(i,2);
                r=obstacles(i,3);
                obj.grid(x,y)=1;
                obj.grid(fix(-r/2)+x-1:fix(r/2)+x+1,fix(-r/2)+y-1:fix(r/2)+y+1)=1;
            end

        end
        function obj=populateMap(obj,cellsize)
            obj.cell=cells.empty;
%             fun = @(block_struct) f(block_struct,obj);
            ret=blockproc(obj.grid,[cellsize cellsize],obj.fun);
            obj.grid=ret;
        end
        function obj= addCell(obj,data)
            if isempty(findobj(obj.cell,'bc',data.bc))
            obj.cell(end+1)=data;
            end
        end
        function obj=makecells(obj,dimRobot)
            if obj.cellSizs==dimRobot+1
                return
            elseif isValid()
            end
        end
        function map = drawCell(obj)
            map=obj.grid;
            figure;
            for c=obj.cell
                disp(c.values);
                map(sub2ind(size(map),c.borderList(:,1),c.borderList(:,2)))=0;
            end
        end
        function findCollision(obj)
            for i=obj.cell
               % disp(i.values);
                if i.dim<=obj.cellRobot %Se suddivisione mi porta ad una cella più picocla del robot->scarto
                    i.isValid=0;
                elseif i.values==ones(i.dim)%Se la cella è composta da tutti 1->ostacolo->scarto
                    i.isValid=0;
                elseif  ismember(1,i.values)==0%se la cella è composta da tutti 0->no ostacolo->valida
                    i.isValid =1;
                    obj.addCell(i);
                else %Caso in cui bisogna decomporre la cella->presenza di 1 e 0
                    if isempty(obj.cell)
                        div=divisors(obj.cellsize(1));
                        div=div(end-2);
                    else
                    div=divisors(i.dim(1));
                    div=div(end-1);
                    end
                    if div~=1 && div>=obj.cellRobot
                        if i.location==[11,41]
                            disp("CHEPPALLEE");
                        end
                    celladim=div;
                    blockproc(i.values,[celladim celladim],obj.fun);
                    end
                end
            end
        end
    end
end
