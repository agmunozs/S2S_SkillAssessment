clear all

kendalls2=dlmread('skillfile_2tier_sst.txt', ' ');
kendalls2=flipud(kendalls2);
kendalls2(kendalls2==0)=NaN;
kendalls1=dlmread('skillfile_1tier_sst.txt', ' ');
kendalls1=flipud(kendalls1);
kendalls1(kendalls1==0)=NaN;

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
title('a) Kendall''s \tau . FLOR 2-tier SST (JJA 1982-2016)')
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
title('b) Kendall''s \tau . FLOR 1-tier SST (JJA 1982-2016)')
h=colorbar;
set(h, 'Position', [.92 .11 .02 .8150])


kendalls2=dlmread('skillfile_2tier_prcp.txt', ' ');
kendalls2=flipud(kendalls2);
kendalls2(kendalls2==0)=NaN;
kendalls1=dlmread('skillfile_1tier_prcp.txt', ' ');
kendalls1=flipud(kendalls1);
kendalls1(kendalls1==0)=NaN;

figure(2);clf
[nr,nc] = size(kendalls2);
subplot(1,2,1); 
pcolor([kendalls2 nan(nr,1); nan(1,nc+1)]);
shading flat;
set(gca, 'clim', [0. 0.06]);
set(gca, 'ydir', 'reverse');
set(gca,'FontSize',15)
xlabel('Initial year'); ylabel('Years used for skill assessment')
set(gca,'XTick',1:4:26)
set(gca,'XTickLabel',{'1982','1986','1990','1994','1998','2002','2006'})
set(gca,'YTick',1:5:26)
set(gca,'YTickLabel',{'35','30','25','20','15','10'})
title('a) Kendall''s \tau . FLOR 2-tier PRCP (JJA 1982-2016)')
subplot(1,2,2); 
pcolor([kendalls1 nan(nr,1); nan(1,nc+1)]);
shading flat;
set(gca, 'clim', [0. 0.06]);
set(gca, 'ydir', 'reverse');
set(gca,'FontSize',15)
xlabel('Initial year'); ylabel('Years used for skill assessment')
set(gca,'XTick',1:4:26)
set(gca,'XTickLabel',{'1982','1986','1990','1994','1998','2002','2006'})
set(gca,'YTick',1:5:26)
set(gca,'YTickLabel',{'35','30','25','20','15','10'})
title('b) Kendall''s \tau . FLOR 1-tier PRCP (JJA 1982-2016)')
h=colorbar;
set(h, 'Position', [.92 .11 .02 .8150])