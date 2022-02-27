function ret = split(val, obj)
dim = val.blockSize;
location = val.location;
values = val.data;
newCellNode = cellNode(location, dim, values);
obj.cellSet{end+1} = {obj.tempParent,newCellNode};
ret = val.data;
% ret(:,:)=abs(ret(:,:)-1);
% disp(values);
end
