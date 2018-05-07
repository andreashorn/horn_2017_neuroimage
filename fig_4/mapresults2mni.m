function plotresults
load results_ea_normalize_ants
load('lg/LEAD_groupanalysis.mat');


measures={'mni_hcp','mni_ppmicontrol','mni_ppmipd','mni_dbspd','mni_tal2mni','mni_tal2icbm_spm','mni_mnimeasure'};
cohorts={'Tal2MNI','Tal2ICBM','MNI-measured','Young','Age Matched','Disease-Matched','Severity-Matched'};

%determine rough mean point for fov and height of cuts..

for meas=1:length(measures)
    try
        mnpt(meas,:)=results.([measures{meas},'_mean']);
    catch
        mnpt(meas,:)=results.([measures{meas},'']);
    end
end



mnpt=ea_nanmean(mnpt,1);




leaddir=[fileparts(which('lead')),filesep];
V=spm_vol([leaddir,'templates',filesep,'mni_hires.nii']);

bb = spm_get_bbox(V, 'fv');


%load([leaddir,'atlases',filesep,'Chakravaty 2010_colin_original',filesep,'atlas_index.mat']);
load([leaddir,'atlases',filesep,'andy_subcortical',filesep,'atlas_index.mat']);
%load([leaddir,'atlases',filesep,'ATAG_Nonlinear (Keuken 2014)',filesep,'atlas_index.mat']);

load options

[~,slice]=ea_writeplanes(options, mnpt(3),1,V,'off', 0,atlases);

slice=(slice-min(slice(:)))/(max(slice(:))-min(slice(:))); % set 0 to 1

slice=flip(slice,1);

cuts=figure;
axis equal
hold on



im=imagesc(slice);
im.XData=[bb(1,1),bb(2,1)];
im.YData=[bb(1,2),bb(2,2)];
ax=gca;
% ax.XLim=[bb(1,1),bb(2,1)];
% ax.YLim=[bb(1,2),bb(2,2)];
ax.XLim=[mnpt(1)-15,mnpt(1)+15];
ax.YLim=[mnpt(2)-15,mnpt(2)+15];
%axis ij
set(ax,'position',[0,0,1,1],'units','normalized');
clrs=round(linspace(1,64,length(measures)));
clrs=1:10;
ht=uitoolbar(cuts);
jetlist=lines;
cnt=1;


for meas=1:length(measures)
    
    for pt=1:size(results.(measures{meas}),1)
        p{meas}(pt)=plot(results.(measures{meas})(pt,1),results.(measures{meas})(pt,2),'*','MarkerEdgeColor',jetlist(clrs(meas),:),'MarkerFaceColor',jetlist(clrs(meas),:),'MarkerSize',15);
       
    end
    
   
    
    colorbuttons(cnt)=uitoggletool(ht,'CData',ea_get_icn('atlas',jetlist(clrs(meas),:)),'TooltipString',measures{meas},'OnCallback',{@resvisible,p{meas},'on'},'OffCallback',{@resvisible,p{meas},'off'},'State','on');
    
    cnt=cnt+1;
    
    if size(results.(measures{meas}),1)>3 % plot gaussian as well
        gauss=d2gauss(results.(measures{meas})(:,2),results.(measures{meas})(:,1));
        %gauss=flip(gauss,1);
        colorgauss=zeros([size(gauss),3]);
        for dim=1:3
        colorgauss(:,:,dim)=jetlist(clrs(meas),dim);
        end
        bbg=[ea_nanmin(results.(measures{meas})(:,1))-5,ea_nanmax(results.(measures{meas})(:,1)+5);
            ea_nanmin(results.(measures{meas})(:,2))-5,ea_nanmax(results.(measures{meas})(:,2))+5];
        gf{meas}=imagesc(colorgauss);
        gf{meas}.XData=[bbg(1,1),bbg(1,2)];
        gf{meas}.YData=[bbg(2,1),bbg(2,2)];
        gf{meas}.AlphaData=(gauss/max(gauss(:)))*0.7;
       colorbuttons(cnt)=uitoggletool(ht,'CData',ea_get_icn('atlas',jetlist(clrs(meas),:)),'TooltipString',measures{meas},'OnCallback',{@resvisible,gf{meas},'on'},'OffCallback',{@resvisible,gf{meas},'off'},'State','on');
     cnt=cnt+1;
     
     
     
     %% plot contour as well
     
     
     c{meas}=imagesc(colorgauss);
     c{meas}.XData=[bbg(1,1),bbg(1,2)];
     c{meas}.YData=[bbg(2,1),bbg(2,2)];
     cgauss=gauss;
     cgauss(cgauss<0.25*max(gauss(:)))=0;
     cgauss(cgauss>0.3*max(gauss(:)))=0;
     
     c{meas}.AlphaData=cgauss>0;
     
     
     
%      [con]=contour(gauss>(0.9*max(gauss(:))),1);
%      
%      c{meas}=plot(con(1,2:end),con(2,2:end));
%           c{meas}.XData=c{meas}.XData-min(c{meas}.XData);
%           c{meas}.XData=c{meas}.XData/max(c{meas}.XData);
%           c{meas}.XData=c{meas}.XData*(bbg(1,2)-bbg(1,1));
%           c{meas}.XData=c{meas}.XData+bbg(1,1);
%           
%           c{meas}.YData=c{meas}.YData-min(c{meas}.YData);
%           c{meas}.YData=c{meas}.YData/max(c{meas}.YData);
%           c{meas}.YData=c{meas}.YData*(bbg(2,2)-bbg(2,1));
%           c{meas}.YData=c{meas}.YData+bbg(2,1);
%           
%           [bbg(1,1),bbg(1,2)];
%         c{meas}.YData=[bbg(2,1),bbg(2,2)];
        
%        c{meas}.LineColor=jetlist(clrs(meas),:);
      colorbuttons(cnt)=uitoggletool(ht,'CData',ea_get_icn('atlas',jetlist(clrs(meas),:)),'TooltipString',measures{meas},'OnCallback',{@resvisible,c{meas},'on'},'OffCallback',{@resvisible,c{meas},'off'},'State','on');
     cnt=cnt+1;
    end
end


function resvisible(h,u,obj,cmd)
set(obj(:),'visible',cmd);




function cell=sub2space(cell) % replaces subscores with spaces
for c=1:length(cell)
cell{c}(cell{c}=='_')=' ';
end



function P_Gaussian=d2gauss(var1,var2)
Data = [var1,var2];
Data(isnan(Data(:,1)),:)=[];
Data(isnan(Data(:,2)),:)=[];
X = linspace(min(var1)-5,max(var1)+5,750);
Y = linspace(min(var2)-5,max(var2)+5,750);

D = length(Data(1,:));
Mu = mean(Data);
Sigma = cov(Data);
P_Gaussian = zeros(length(X),length(Y));
for i=1:length(X)
   for j=1:length(Y)
       x = [X(i),Y(j)];
       P_Gaussian(i,j) = 1/((2*pi)^(D/2)*sqrt(det(Sigma)))...
                    *exp(-1/2*(x-Mu)*Sigma^-1*(x-Mu)');
   end
end