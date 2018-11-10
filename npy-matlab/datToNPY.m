

function datToNPY(inFilename, outFilename, dataType, shape, varargin)
% function datToNPY(inFilename, outFilename, shape, dataType, [fortranOrder, littleEndian])
%
% make a NPY file from a flat binary file, given that you know the shape,
% dataType, ordering, and endianness of the flat binary file. 
% 
% The point here is you don't want to read in all the data from the
% existing binary file - instead you can just create the appropriate header
% and then concatenate it with the data. 
%
% ** completely untested

if ~isempty(varargin)
    fortranOrder = varargin{1}; % must be true/false
    littleEndian = varargin{2}; % must be true/false
else
    fortranOrder = true;
    littleEndian = true;
end

header = constructNPYheader(dataType, shape, fortranOrder, littleEndian);

% ** TODO: need to put the header into a temp file instead, in case the
% outFilename is the same as the inFilename (and then delete the temp file
% later)
fid = fopen(tempFilename, 'w');
fwrite(fid, header, 'uint8');
fclose(fid)

str = computer;
switch str
    case {'PCWIN', 'PCWIN64'}
        [~,~] = system(sprintf('copy /b %s+%s %s', tempFilename, inFilename, outFilename));
    case {'GLNXA64', 'MACI64'}
        [~,~] = system(sprintf('cat %s %s > %s', tempFilename, inFilename, outFilename));
        
    otherwise
        fprintf(1, 'I don''t know how to concatenate files for your OS, but you can finish making the NPY youself by concatenating %s with %s.\n', tempFilename, inFilename);
end
    
