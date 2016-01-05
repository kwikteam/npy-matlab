

function [arrayShape, dataType, fortranOrder, littleEndian, totalHeaderLength, npyVersion] = readNPYheader(filename)
% function [arrayShape, dataType, fortranOrder, littleEndian, ...
%       totalHeaderLength, npyVersion] = readNPYheader(fid)
%
% parse the header of a .npy file and return all the info contained
% therein.
%
% Based on spec at http://docs.scipy.org/doc/numpy-dev/neps/npy-format.html

fid = fopen(filename);

try
    
    dtypesMatlab = {'uint8','uint16','uint32','uint64','int8','int16','int32','int64','single','double'};
    dtypesNPY = {'u1', 'u2', 'u4', 'u8', 'i1', 'i2', 'i4', 'i8', 'f4', 'f8'};
    
    
    magicString = fread(fid, [1 6], 'char=>char');
    
    if ~strcmp(magicString, '“NUMPY')
        error('readNPY:NotNUMPYFile', 'Error: This file does not appear to be NUMPY format based on the header.');
    end
    
    majorVersion = fread(fid, [1 1], 'uint8=>uint8');
    minorVersion = fread(fid, [1 1], 'uint8=>uint8');
    
    npyVersion = [majorVersion minorVersion];
    
    headerLength = fread(fid, [1 1], 'uint16=>unit16');
    
    totalHeaderLength = 10+headerLength;
    
    arrayFormat = fread(fid, [1 headerLength], 'char=>char');
    
    % to interpret the array format info, we make some pretty strict
    % assumptions about it:
    % - has three fields: descr, fortran_order, and shape
    % - all arguments open with colon and close with comma
    % - descr argument is surrounded by single quotes and terminated by comma
    % - fortran_order argument is either 'True' or not
    % - shape argument is enclosed in parens
    
    descrPlace = strfind(arrayFormat, 'descr');
    openQuote = find(1:length(arrayFormat)>descrPlace+5 & arrayFormat=='''');
    closeQuote = find(1:length(arrayFormat)>openQuote(1) & arrayFormat=='''');
    dtNPY = arrayFormat(openQuote(1)+1:closeQuote(1)-1);
    
    % singleQuotes = find(arrayFormat=='''');
    % dtNPY = arrayFormat(singleQuotes(3)+1:singleQuotes(3)+3);
    
    littleEndian = ~strcmp(dtNPY(1), '>');
    
    dataType = dtypesMatlab{strcmp(dtNPY(2:3), dtypesNPY)};
    
    
    orderPlace = strfind(arrayFormat, 'fortran_order');
    comma = find(1:length(arrayFormat)>orderPlace+14 & arrayFormat==',');
    fortranOrder = ~isempty(strfind(arrayFormat(orderPlace+14:comma-1), 'True'));
    
    
    shapePlace = strfind(arrayFormat, 'shape');
    openParen =  find(1:length(arrayFormat)>shapePlace+5 & arrayFormat=='(');
    closeParen =  find(1:length(arrayFormat)>openParen+1 & arrayFormat==')');
    arrayShape = str2num(arrayFormat(openParen+1:closeParen-1));
    
    % parse the shape of the array
    % openParen = find(arrayFormat=='(');
    % commas = find(arrayFormat==',');
    % closeParen = find(arrayFormat==')');
    %
    % startShape = openParen(1);
    % thisComma = commas(find(commas>startShape,1));
    % n = 1;
    % while thisComma<=closeParen && thisComma>startShape+1
    %     shape(n) = str2num(arrayFormat(startShape+1:thisComma-1));
    %     startShape = thisComma;
    %     thisComma = min(commas(find(commas>startShape,1)), closeParen);
    %     n = n+1;
    % end
    
    fclose(fid);
    
catch me
    fclose(fid);
    rethrow(me);
end
