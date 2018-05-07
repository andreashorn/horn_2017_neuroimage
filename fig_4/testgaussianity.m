labels={'PD_STN','Dyt_GPi','ET_VIM','MD_SCC','OCD_NAc','OCD_ALIC','TS_CMPVVOI','AD_FORNIX','ADD_NAc','ET_GUIOT'};
cnt=1;
for lab=1:length(labels)
    
    load(['results_ea_normalize_ants',labels{lab}]);
    
    
    XYZ=results.mni_hcp;
    
    for dim=1:3
      [h(cnt),p(cnt),stats]=chi2gof(XYZ(:,dim));
      if h(cnt)
         disp([labels{lab},' dim ',num2str(dim),' not Gaussian.']); 
      end
       % figure, hist(XYZ(:,dim))
       cnt=cnt+1;
    end
    
end


