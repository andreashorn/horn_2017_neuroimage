% comp riva-posse hamani warps
Lx=5.98*7+6.86*10;
Rx=6.14*7+5.34*10;
Ly=25.61*7+26.53*10;
Ry=26.21*7+25.63*10;
Lz=-8.11*7+-7.80*10;
Rz=-6.04*7+-7.46*10;
Rxyz=[Rx,Ry,Rz]/17;
Lxyz=[Lx,Ly,Lz]/17;
load results_ea_normalize_antsMD_SCC

RD=pdist([results.mni_hcp_mean',Rxyz']');
LD=pdist([results.mni_hcp_mean',Lxyz']');
Rdiffs=abs([results.mni_hcp_mean-Rxyz]);
Ldiffs=abs([results.mni_hcp_mean-Lxyz]);
