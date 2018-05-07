X=ea_getIXI_IDs(30,50.11); % DBS TRD
X=[X,ea_getIXI_IDs(30,59)]; % DBS PD
X=[X,ea_getIXI_IDs(30,59)]; % Caire STN
X=[X,ea_getIXI_IDs(30,32)]; % Starr GPi
X=[X,ea_getIXI_IDs(30,66.2)]; % Papavasiliou ET
X=[X,ea_getIXI_IDs(30,50.11)]; % Hamani Cg25
X=[X,ea_getIXI_IDs(30,37)]; % Franzini NAc
X=[X,ea_getIXI_IDs(30,35)]; % Anderson ALIC
X=[X,ea_getIXI_IDs(30,40.33)]; % Ackermanns Ce
X=[X,ea_getIXI_IDs(30,68.2)]; % Ponce Fornix
X=[X,ea_getIXI_IDs(30,37.7)]; % Müller NAc

keyboard
X=unique(X);