%batch
% note, as of Feb 2017 (third minor revision) this only worked with an
% external monitor attached (weirdly) ? but probably easy to fix.
lead path
coords=[12.02   -1.53   1.91
    20.0    5.8     0.5
    12.8    -5.7    -0.8
    5.6     34.2    3.0   % x for MD in MNI temporarily set to 6 mm for better cut of SCC (in line 49, mapresults2mni_youngonly_sag).
    3       16      2
    14      6       -6
    5.0     -4.0     0
    4.4     9.8     7.2
    6.5     2.7     4.5
    15.0    6.4     0
    5.6, 12. -1.5]; % added may 2018 as active contact in AD.


labels={'PD_STN','Dyt_GPi','ET_VIM','MD_SCC','OCD_NAc','OCD_ALIC','TS_CMPVVOI','AD_FORNIX','ADD_NAc','ET_GUIOT','AD_FX_ACTIVE'};

reltos=[2,2,2,2,2,1,2,2,1,3,2];

trasags=[1,1,1,2,1,1,1,2,1,1,2];
dims=[10,10,7,20,10,10,7,20,10,7,20];

atlases={'DISTAL (Ewert 2016)'
    'DISTAL (Ewert 2016)'
    'MorelAtlasMNI152 (Jakab 2012)'
    'Depression_and_striatum'
    'Depression_and_striatum'
    'ATAG_Nonlinear (Keuken 2014)'
    'Chakravaty 2010_colin_original_abbr'
    'Chakravaty 2010_colin_original_abbr'
    'Depression_and_striatum'
    'MorelAtlasMNI152 (Jakab 2012)'
    'DISTAL (Ewert 2017)'};

meanages=[59,32,66.2,50.11,37,35,40.33,68.2,37.7,50,68.2];

showscattergauss=[1,1];

for img=[11]; %1:size(coords,1);
    
    % define ptcohort here.
    try
        ptcohort=ea_getIXI_IDs(30,meanages(img));
    catch
        ptcohort=[];
    end
    generate_dataresults_youngonly_agematched(coords(img,:),labels{img},reltos(img),trasags(img),dims(img),atlases{img},ptcohort,showscattergauss);
    
end