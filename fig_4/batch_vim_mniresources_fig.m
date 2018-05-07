%batch

coords=[    12.8    -5.7    -0.8
    12.8    -5.7    -0.8
    12.8    -5.7    -0.8
    12.8    -5.7    -0.8
    12.8    -5.7    -0.8
        12.8    -5.7    -0.8
        12.8    -5.7    -0.8];


labels={'VIM_Chakravarty','VIM_Morel','VIM_AICHA','VIM_Behrens','VIM_Yeo','VIM_Zhang','VIM_Bigbrain'};

reltos=[2,2,2,2,2,2,2];

trasags=[1,1,1,1,1,1,1];
dims=[20,20,20,20,20,20,20];

atlases={'Chakravaty 2010_colin_original_abbr'
    'MorelAtlasICBM2009b'
    'AICHA_nuclei (Joliot 2015)'
    'Oxford Thalamic Connectivity Atlas (Behrens 2003)'
    '1000subjects_TightThalamus_clusters007_ref'
    'Zhang Thalamic Atlas (Zhang 2008)'
    'Depression'};

    
for img=6;
    generate_dataresults_youngonly_mniresources(coords(img,:),labels{img},reltos(img),trasags(img),dims(img),atlases{img}); 
end