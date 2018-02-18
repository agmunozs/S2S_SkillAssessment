% Matlab script to plot skill diagrams via CPT output
% AG Munoz (IRI Columbia U) - agmunoz@iri.columbia.edu
% Project: FLOR 2Tiers vs 1Tier
% First edition: Feb 14, 2018 
% Notes: 
% + See https://github.com/agmunozs/S2S_SkillAssessment

%%%%%START%%%%%%%%%%%%
clear all

kendalls2=importdata('skillfile_2tier_sst.txt', ' ');
kendalls2=rot90(kendalls2);
%kendalls2(kendalls2==0)=NaN;
kendalls2(kendalls2<0)=0;
kendalls1=importdata('skillfile_1tier_sst.txt', ' ');
kendalls1=rot90(kendalls1);
%kendalls1(kendalls1==0)=NaN;
kendalls1(kendalls1<0)=0;

figure(1);clf
[nr,nc] = size(kendalls2);
subplot(1,2,1); 
pcolor([kendalls2 nan(nr,1); nan(1,nc+1)]);
shading flat;
set(gca, 'clim', [0.1 0.25]);
set(gca, 'ydir', 'reverse');
set(gca,'FontSize',15)
xlabel('Initial year'); ylabel('Years used for skill assessment')
set(gca,'XTick',1:4:26)
set(gca,'XTickLabel',{'1982','1986','1990','1994','1998','2002','2006'})
set(gca,'YTick',1:5:26)
set(gca,'YTickLabel',{'35','30','25','20','15','10'})
title('a) Global SST 2-tier (JJA - Init: Apr)')
h=colorbar;
set(h, 'Position', [.92 .11 .02 .8150])
axes('Position',[.35 .7 .1 .2])
box on
histogram(kendalls2,'BinWidth',.015,'Normalization','probability','FaceColor',[0.5 0.5 0.5])
xlabel(' Kendall''s \tau'); ylabel('Relative frequency')
set(gca,'ylim',[0 0.40]);
set(gca,'xlim',[0.15 0.3]);

subplot(1,2,2); 
pcolor([kendalls1 nan(nr,1); nan(1,nc+1)]);
shading flat;
set(gca, 'clim', [0.1 0.25]);
set(gca, 'ydir', 'reverse');
set(gca,'FontSize',15)
xlabel('Initial year'); ylabel('Years used for skill assessment')
set(gca,'XTick',1:4:26)
set(gca,'XTickLabel',{'1982','1986','1990','1994','1998','2002','2006'})
set(gca,'YTick',1:5:26)
set(gca,'YTickLabel',{'35','30','25','20','15','10'})
title('b) Global SST 1-tier (JJA - Init: Apr)')
axes('Position',[.79 .7 .1 .2])
box on
histogram(kendalls1,'BinWidth',.015,'Normalization','probability','FaceColor',[0.5 0.5 0.5])
xlabel(' Kendall''s \tau'); ylabel('Relative frequency')
set(gca,'ylim',[0 0.40]);
set(gca,'xlim',[0.15 0.3]);

kendalls2=importdata('skillfile_2tier_prcp_land.txt', ' ');
kendalls2=rot90(kendalls2);
%kendalls2(kendalls2==0)=NaN;
kendalls2(kendalls2<0)=0;
kendalls1=importdata('skillfile_1tier_prcp_land.txt', ' ');
kendalls1=rot90(kendalls1);
%kendalls1(kendalls1==0)=NaN;
kendalls1(kendalls1<0)=0;

figure(2);clf
[nr,nc] = size(kendalls2);
subplot(1,2,1); 
pcolor([kendalls2 nan(nr,1); nan(1,nc+1)]);
shading flat;
set(gca, 'clim', [0. 0.1]);
set(gca, 'ydir', 'reverse');
set(gca,'FontSize',15)
xlabel('Initial year'); ylabel('Years used for skill assessment')
set(gca,'XTick',1:4:26)
set(gca,'XTickLabel',{'1982','1986','1990','1994','1998','2002','2006'})
set(gca,'YTick',1:5:26)
set(gca,'YTickLabel',{'35','30','25','20','15','10'})
title('c) Land PRCP 2-tier (JJA - Init: Apr)')
h=colorbar;
set(h, 'Position', [.92 .11 .02 .8150])
axes('Position',[.35 .7 .1 .2])
box on
histogram(kendalls2,'BinWidth',.006,'Normalization','probability','FaceColor',[0.5 0.5 0.5])
xlabel(' Kendall''s \tau'); ylabel('Relative frequency')
set(gca,'ylim',[0 0.40]);
set(gca,'xlim',[0. 0.06]);

subplot(1,2,2); 
pcolor([kendalls1 nan(nr,1); nan(1,nc+1)]);
shading flat;
set(gca, 'clim', [0. 0.1]);
set(gca, 'ydir', 'reverse');
set(gca,'FontSize',15)
xlabel('Initial year'); ylabel('Years used for skill assessment')
set(gca,'XTick',1:4:26)
set(gca,'XTickLabel',{'1982','1986','1990','1994','1998','2002','2006'})
set(gca,'YTick',1:5:26)
set(gca,'YTickLabel',{'35','30','25','20','15','10'})
title('d) Land PRCP 1-tier (JJA - Init: Apr)')
axes('Position',[.79 .7 .1 .2])
box on
histogram(kendalls1,'BinWidth',.006,'Normalization','probability','FaceColor',[0.5 0.5 0.5])
xlabel(' Kendall''s \tau'); ylabel('Relative frequency')
set(gca,'ylim',[0 0.40]);
set(gca,'xlim',[0. 0.06]);

kendalls2=importdata('skillfile_2tier_prcp.txt', ' ');
kendalls2=rot90(kendalls2);
%kendalls2(kendalls2==0)=NaN;
kendalls2(kendalls2<0)=0;
kendalls1=importdata('skillfile_1tier_prcp.txt', ' ');
kendalls1=rot90(kendalls1);
%kendalls1(kendalls1==0)=NaN;
kendalls1(kendalls1<0)=0;

figure(3);clf
[nr,nc] = size(kendalls2);
subplot(1,2,1); 
pcolor([kendalls2 nan(nr,1); nan(1,nc+1)]);
shading flat;
set(gca, 'clim', [0. 0.1]);
set(gca, 'ydir', 'reverse');
set(gca,'FontSize',15)
xlabel('Initial year'); ylabel('Years used for skill assessment')
set(gca,'XTick',1:4:26)
set(gca,'XTickLabel',{'1982','1986','1990','1994','1998','2002','2006'})
set(gca,'YTick',1:5:26)
set(gca,'YTickLabel',{'35','30','25','20','15','10'})
title('e) Global PRCP 2-tier (JJA - Init: Apr)')
h=colorbar;
set(h, 'Position', [.92 .11 .02 .8150])
axes('Position',[.35 .7 .1 .2])
box on
histogram(kendalls2,'BinWidth',.007,'Normalization','probability','FaceColor',[0.5 0.5 0.5])
xlabel(' Kendall''s \tau'); ylabel('Relative frequency')
set(gca,'ylim',[0 0.40]);
set(gca,'xlim',[0.04 0.11]);

subplot(1,2,2); 
pcolor([kendalls1 nan(nr,1); nan(1,nc+1)]);
shading flat;
set(gca, 'clim', [0. 0.1]);
set(gca, 'ydir', 'reverse');
set(gca,'FontSize',15)
xlabel('Initial year'); ylabel('Years used for skill assessment')
set(gca,'XTick',1:4:26)
set(gca,'XTickLabel',{'1982','1986','1990','1994','1998','2002','2006'})
set(gca,'YTick',1:5:26)
set(gca,'YTickLabel',{'35','30','25','20','15','10'})
title('f) Global PRCP 1-tier (JJA - Init: Apr)')
axes('Position',[.79 .7 .1 .2])
box on
histogram(kendalls1,'BinWidth',.007,'Normalization','probability','FaceColor',[0.5 0.5 0.5])
xlabel(' Kendall''s \tau'); ylabel('Relative frequency')
set(gca,'ylim',[0 0.40]);
set(gca,'xlim',[0.04 0.11]);