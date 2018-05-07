%batch

coords=[12.02   -1.53   1.91
    20.0    5.8     0.5
    12.8    -5.7    -0.8
    5.6     34.2    3.0
    3       16      2
    14      6       -6
    5.0     -4.0     0
    4.4     9.8     7.2
    6.5     2.7     4.5
    15.0    6.4     0];


labels={'PD_STN','Dyt_GPi','ET_VIM','MD_SCC','OCD_NAc','OCD_ALIC','TS_CMPVVOI','AD_FORNIX','ADD_NAc','ET_GUIOT'};

reltos=[2,2,2,2,2,1,2,2,1,3];

trasags=[1,1,1,2,1,1,1,2,1,1];
dims=[10,10,7,20,10,10,7,20,10,7];

atlases={'DISTAL_manual'
    'DISTAL_manual'
    'MorelAtlasMNI152 (Jakab 2012)'
    'Depression_and_striatum'
    'Depression_and_striatum'
    'ATAG_Nonlinear (Keuken 2014)'
    'Chakravaty 2010_colin_original_abbr'
    'Chakravaty 2010_colin_original_abbr'
    'Depression_and_striatum'
    'MorelAtlasMNI152 (Jakab 2012)'};

    
for img=[7,9]; %1:size(coords,1);
    generate_dataresults_youngonly(coords(img,:),labels{img},reltos(img),trasags(img),dims(img),atlases{img});
    
end