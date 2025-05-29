

function writeNPYshaped(var, filename, shape)
% function writeNPY(var, filename, shape)
%
% Only writes little endian, fortran (column-major) ordering; only writes
% with NPY version number 1.0.
%
% shape is the size of the array as in the NPY file.  You need this to
% override matlab's convention, e.g. (10, 1)rather than (10,).
% if not specified, defaults to matlab's size(var)

if nargin<3
    shape = size(var);
end

if prod(shape)~=prod(size(var))
    error('shape input does not matach number of elements in var')
end

dataType = class(var);

header = constructNPYheader(dataType, shape);

fid = fopen(filename, 'w');
fwrite(fid, header, 'uint8');
fwrite(fid, var, dataType);
fclose(fid);


end

