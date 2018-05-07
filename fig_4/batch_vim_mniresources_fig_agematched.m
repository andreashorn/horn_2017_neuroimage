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
    'Thalamic fMRI Networks 7 (Choi 2012)'
    'Zhang Thalamic Atlas (Zhang 2008)'
    'NAc'};

    
for img=7;
    generate_dataresults_youngonly_mniresources_agematched(coords(img,:),labels{img},reltos(img),trasags(img),dims(img),atlases{img}); 
end