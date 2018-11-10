

% Example implementation of memory mapping an NPY file using readNPYheader

filename = 'data/chelsea_float64.npy';

[arrayShape, dataType, fortranOrder, littleEndian, totalHeaderLength, npyVersion] = readNPYheader(filename);

figure;

if fortranOrder
    f = memmapfile(filename, 'Format', {dataType, arrayShape, 'd'}, 'Offset', totalHeaderLength);
    image(f.Data.d)
    
else
    % Note! In this case, the dimensions of the array will be transposed,
    % e.g. an AxBxCxD array becomes DxCxBxA. 
    f = memmapfile(filename, 'Format', {dataType, arrayShape(end:-1:1), 'd'}, 'Offset', totalHeaderLength);
    
    tmp = f.Data.d;
    img = permute(tmp, length(arrayShape):-1:1); % note here you have to reverse the dimensions. 
    image(img./255)
end