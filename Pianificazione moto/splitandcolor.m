function [M, nodeList] = splitandcolor(map, robotsize, toSave, toShow)
    % graphically split the map and return the list of all nodes also.
    decomp(map, robotsize, 0.9);
    dim = size(map.value);
    currdim = dim(1)/2;
    M = 255 * repmat(uint8(map.value), 1, 1, 3);
    Mtemp = map.value;
    nodeList = getAllNode(map, []);
    id = 0;
    while(currdim >= robotsize)
        mapList = findobj(nodeList, 'dim', currdim);
        for i = 1:size(mapList,1)
            % TODO: consider to set id only to g and r nodes
            mapList(i).id = id+1;
            id = id+1;
            corner = mapList(i).corner;
            color=[];
            switch mapList(i).prop
                case 'y'
                    color = [255, 160, 0];
                case 'g'
                    color = [0,255,0];
                case 'r'
                    color = [255,0,0];
            end
            M(corner(1,1):corner(1,2),corner(2,1):corner(2,3)) = mapList(i).value;
            if toShow
                imshow(M)
            end
            M(corner(1,1):corner(1,2),corner(2,1):corner(2,3),1)=color(1);
            %         Mtemp(corner(1,1):corner(1,2),corner(2,1):corner(2,3)) = 0;
            if toShow
                imshow(M)
            end
            M(corner(1,1):corner(1,2),corner(2,1):corner(2,3),2)=color(2);
            %         Mtemp(corner(1,1):corner(1,2),corner(2,1):corner(2,3))=0;
            if toShow
                imshow(M)
            end
            M(corner(1,1):corner(1,2),corner(2,1):corner(2,3),3)=color(3);
            %         Mtemp(corner(1,1):corner(1,2),corner(2,1):corner(2,3))=0;
            if toShow
                imshow(M)
            end
            M(corner(1,1):corner(1,2),corner(2,1),:)=0;
            Mtemp(corner(1,1):corner(1,2),corner(2,1))=0;
            M(corner(1,1),corner(2,1):corner(2,3),:)=0;
            Mtemp(corner(1,1),corner(2,1):corner(2,3))=0;
            %
            M(corner(1,3):corner(1,4),corner(2,3),:)=0;
            Mtemp(corner(1,3):corner(1,4),corner(2,3))=0;
            M(corner(1,2),corner(2,2):corner(2,4),:)=0;
            Mtemp(corner(1,2),corner(2,2):corner(2,4))=0;

            if corner(2,3)==dim(1)
                M(corner(1,1):corner(1,2),corner(2,3),:)=0;
                Mtemp(corner(1,1):corner(1,2),corner(2,3))=0;
            end
            if corner(1,2) == dim(1)
                M(corner(1,2),corner(2,1):corner(2,3),:)=0;
                Mtemp(corner(1,2),corner(2,1):corner(2,3))=0;
            end
            if toSave
                filename = "mapimage/cell"+num2str(mapList(i).id)+".jpg";
                imwrite(M,filename,'jpg');
            end
        end
        currdim = currdim/2;
    end
end