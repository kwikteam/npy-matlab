

%% Test the readNPY function with given data
dtypes = {'uint8','uint16','uint32','uint64','int8','int16','int32','int64','float32','float64'};
figure; 
for d = 1:length(dtypes)
    
    data = readNPY(['data/sine_' dtypes{d} '.npy']); 
    
    subplot(length(dtypes),1,d)
    plot(data)
    title(dtypes{d});
    
end


figure; 
for d = 1:length(dtypes)
    
    data = readNPY(['data/chelsea_' dtypes{d} '.npy']); 
    data(1:3,1:3,:)
    subplot(length(dtypes),1,d)
    imagesc(double(data)./255)
    title(dtypes{d});
    
end


%% test readNPY and writeNPY
dtypes = {'uint8','uint16','uint32','uint64','int8','int16','int32','int64','float32','float64'};

figure; 
for d = 1:length(dtypes)
    
    data = readNPY(['data/sine_' dtypes{d} '.npy']); 
    writeNPY(data, ['data/matlab_sine_' dtypes{d} '.npy']); 
    data = readNPY(['data/matlab_sine_' dtypes{d} '.npy']); 
    
    subplot(length(dtypes),1,d)
    plot(data)
    title(dtypes{d});
    
end


figure; 
for d = 1:length(dtypes)
    
    data = readNPY(['data/chelsea_' dtypes{d} '.npy']); 
    writeNPY(data, ['data/matlab_chelsea_' dtypes{d} '.npy']);
    data = readNPY(['data/matlab_chelsea_' dtypes{d} '.npy']);
    
    data(1:3,1:3,:)
    subplot(length(dtypes),1,d)
    imagesc(double(data)./255)
    title(dtypes{d});
    
end