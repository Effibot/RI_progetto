function ret = f(val,obj)
dim=val.blockSize;
location = val.location;
values = val.data;
newCell = cells(location,dim,values);
obj.addCell(newCell);
ret = val.data;
ret(:,:)=abs(ret(:,:)-1);
disp(values);
end
