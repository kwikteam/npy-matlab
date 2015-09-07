

function data = readNPY(filename, varargin)
% Function to read NPY files into matlab. 
% *** Only reads a subset of all possible NPY files, specifically 1- and
% 2-D arrays of certain data types. 
% See https://github.com/kwikteam/npy-matlab/blob/master/npy.ipynb for
% more. 
%
% varargin will allow returning memory-mapped data, in the future.
fid = fopen(filename);

try
    
    magicString = fread(fid, [1 6], 'char=>char');
    
    if ~strcmp(magicString, '“NUMPY')
        error('readNPY:NotNUMPYFile', 'Error: This file does not appear to be NUMPY format.');
    end
    
    majorVersion = fread(fid, [1 1], 'uint8=>uint8');
    minorVersion = fread(fid, [1 1], 'uint8=>uint8');
    headerLength = fread(fid, [1 1], 'uint16=>unit16');
    
    arrayFormat = fread(fid, [1 headerLength], 'char=>char')
    
    dtypesMatlab = {'uint8','uint16','uint32','uint64','int8','int16','int32','int64','single','double'};
    dtypesNPY = {'|u1', '<u2', '<u4', '<u8', '|i1', '<i2', '<i4', '<i8', '<f4', '<f8'};
    
    singleQuotes = find(arrayFormat=='''');
    dtNPY = arrayFormat(singleQuotes(3)+1:singleQuotes(3)+3);
    
    dtMatlab = dtypesMatlab{strcmp(dtNPY, dtypesNPY)};
    
    % parse the shape of the array
    openParen = find(arrayFormat=='(');
    commas = find(arrayFormat==',');
    closeParen = find(arrayFormat==')');
    
    startShape = openParen(1);
    thisComma = commas(find(commas>startShape,1));
    n = 1;
    while thisComma<=closeParen && thisComma>startShape+1
        shape(n) = str2num(arrayFormat(startShape+1:thisComma-1));
        startShape = thisComma;
        thisComma = min(commas(find(commas>startShape,1)), closeParen);
        n = n+1;
    end
        
    % read the data
    data = fread(fid, prod(shape), dtMatlab);
    
    if length(shape)>1
        data = reshape(data, shape(end:-1:1));
        data = permute(data, [length(shape):-1:1]);
    end
    
    fclose(fid);
    
catch me
    fclose(fid);
    rethrow(me);
end
