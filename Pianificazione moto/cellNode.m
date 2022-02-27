classdef cellNode < handle
    properties
        bc
        dim
        isValid
        location
        values
        borderList        
    end
    
    methods
        function obj = cellNode(location,dim,values)
            obj.dim=dim;
            obj.location=location;
            obj.values=values;
            obj.bc=setCellbc(obj);
            obj.isValid=1;
            obj.borderList=getBorderList(obj);

        end
        function obj = markCell(obj, value)
            obj.isValid = value;
        end        
        function bc = setCellbc(obj)
            offsetX=obj.location(1)+obj.dim(1)-1;
            offsetY=obj.location(2)+obj.dim(2)-1;
            x_bc=(obj.location(1)+offsetX)/2;
            y_bc=(obj.location(2)+offsetY)/2;
            bc=fix([x_bc,y_bc]);
        end
        function ret = getBorderList(obj)
            
            offsetX=obj.location(1)+obj.dim(1)-1;
            offsetY=obj.location(2)+obj.dim(2)-1;
            indXLeft=obj.location(1):offsetX;
            indYLeft=obj.location(2)*ones(size(indXLeft));
            leftBorder= [indXLeft',indYLeft'];
            
            indYUP = obj.location(2):offsetY;
            indXUP = obj.location(1)*ones(size(indYUP));
            upBorder=[indXUP',indYUP'];
            
            indYRight = offsetY*ones(size(leftBorder,1),1);
            rightBorder = [leftBorder(:,1) indYRight];
            
            indXBot = offsetX*ones(size(upBorder,1),1);
            botBorder = [indXBot upBorder(:,2)];
            
            ret=[upBorder;rightBorder;botBorder;leftBorder];
        end
        function obj = obstacleFill(obj, obstacles)
            % Obstacle Filling
            grid = obj.values;
            for i=1:size(obstacles,1)
                x=obstacles(i,1);
                y=obstacles(i,2);
                r=obstacles(i,3);
                grid(x,y)=1;
                grid(fix(-r/2)+x-1:fix(r/2)+x+1,...
                    fix(-r/2)+y-1:fix(r/2)+y+1)=1;
            end
            obj.values = grid;
        end       
    end
end

