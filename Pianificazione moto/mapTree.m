classdef mapTree < handle
    properties
        gridSize
        obstacles
        mTree    % tree object
        cellSize
        robotSize
        fun % for node splitting     
        cellSet
        nodeIndexList
        tempParent
        locationTree
        bcTree
    end
    methods
        function obj = mapTree(gridSize, obstacles, cellSize, robotSize)
            obj.gridSize=gridSize;
            obj.cellSize=cellSize;
            obj.obstacles = obstacles;
            obj.robotSize = robotSize;
            obj.fun = @(block_struct) split(block_struct,obj);   
            obj.cellSet = cell.empty(); 
            obj.nodeIndexList = [];
            if isempty(obj.mTree)
                root = cellNode([0,0], gridSize, zeros(gridSize));
                root.obstacleFill(obstacles);
                obj.mTree = tree(root);                
            end
        end
        function obj = splitMap(obj, parent, splitSize)  
            obj.tempParent = parent;        
            % get parent map
            parentMap = obj.getNodeProps(parent.Parent(1)+1).values;
            % apply block function to get a collection of cells
            blockproc(parentMap, [splitSize splitSize], obj.fun);
            for node = obj.cellSet
                % get cell data
                cell = node{1};
                % get cellNode object
                child = cell{2};
                % get parent id       
                parentId = cell{1}.Parent+1;            
                [obj.mTree, obj.nodeIndexList(end+1)]= obj.mTree.addnode(parentId,child);
            end
%             obj.locationTree = obj.sampledTree('location');
%             obj.bcTree = obj.sampledTree('bc');
        end
        function node = getNodeProps(obj, parentId)
            node = obj.mTree.Node{parentId};
        end     
        function t = sampledTree(obj, mode)
            t = tree(obj.mTree,'clear');
            t = t.set(1,obj.prop2str(obj.getNodeProps(1),mode));
            for i = 2:size(t.Node,1)
                node = obj.getNodeProps(i);
                propStr = obj.prop2str(node, mode);
                t = t.set(obj.nodeIndexList(i-1),propStr);                
            end            
        end
        function toString(obj,mode)
            if strcmp(mode, 'location')
                disp(obj.locationTree.tostring)
            elseif strcmp(mode,'bc')
                disp(obj.bcTree.tostring)
            end
        end
        function propStr = prop2str(~,node,mode)
            if strcmp(mode, 'location')
                propStr = '['+string(node.location(1))+','+...
                    string(node.location(2))+']';    
            elseif strcmp(mode, 'bc')
                propStr = '['+string(node.bc(1))+','+...
                    string(node.bc(2))+']';   
            end              
        end
        function makePartition(obj)            
            % take one cell and apply another split
            for i = 2:size(obj.mTree.Node,1)
                % get one cellNode
                node = obj.getNodeProps(i);
                % checks cell size after a split
                if node.dim(1) <= obj.robotSize
                    % if a cell is smaller than the robot marks as invalid
                    node.isValid = 0;              
                elseif node.values == ones(node.dim(1))
                    % if a cell fully contains an obstacle marks as invalid
                    node.isValid = 0;
                elseif ismember(1, node.values) == 0
                    % if a cell doesn't contains an obstacle marks as valid
                    node.isValid = 1;
                else 
                    % splitting phase
                    div = divisors(node.dim(1));
                    splitSize = div(end-1);
                    % checks if a split is feasible
                    if splitSize ~= 1 && splitSize > obj.robotSize
                        % select current parent and make a tree out of it
%                         parentIndex = obj.mTree.Parent(i);
%                         parent = tree(obj.mTree.get(parentIndex));
%                         obj.splitMap(parent, splitSize)
%% TODO: non funziona, loop infinito. 
% idea attuale: creare un nuovo albero a partire da un nodo
% per poi fondere il nuovo albero al rispettivo padre.
                    end
                end
            end

        end                  
    end
end