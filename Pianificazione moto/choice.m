function logical = choice(m)
robsize=m{2}(1);
matrix=m{1};
dim=size(matrix);
if dim(1)<=2
    logical=0;
elseif matrix==ones(dim)
    logical=0;
elseif matrix==zeros()
    logical=0;
elseif ismember(1,matrix) && sqrt(dim(1))>=robsize
    logical=1;
end
end

