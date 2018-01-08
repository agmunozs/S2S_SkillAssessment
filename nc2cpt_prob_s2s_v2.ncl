; *********************************************************
; NCL Script for reading gridded probabilities in a  
; NetCDF file with s2s forecasts, and writing that
; in CPTv>=10 format
; Angel G. Munoz (agms@princeton.edu)
; Princeton U.
; and
; International Research Institute for Climate and
; Society (IRI). Columbia University
;-----------------------------------------------------------
; Notes:
; + Based on a previous script developed for the Latin
;   American Observatory (www.ole2.org) in 2011
; + This script writes the verification file for CPT (i.e.,
; the 3 categories file with probabilities and -1 for missing values
; Requires: 
; + BN: gridded probabilities for the below-normal category
; + AN: gridded probabilities for the above-normal category
; + Usually the NC file is computed in the IRIDL, so lat,lon,time
;   are named Y,X and T, respectively. Change otherwise.
; Output:
; + CPT verification file, with 3 categories 
; Others:
; Example for the DL link that produces the files:
; *********************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"



begin
;**********************************************************
; Begin of user modification section
;**********************************************************
  diri   = "./"
  diro   = "./"
  fili   = "infile.nc";                   
  fName  = diri+fili       
  filen  = diro+"outfile.txt"
  vari   = "t2m"
  varname= "Probability"         
  units  = "%" 

;**********************************************************
; End of user modification section
;**********************************************************

  fi     =addfile(fName,"r")
  lon    =fi->X
  lat    =fi->Y(::-1)
  time   =fi->T
  timei  =time;  Need to get coordinates and attributes
  timef  =time;  Need to get coordinates and attributes
  timei  =time-3;
  timef  =time+3
  ;timei@calendar = "julian"
  ;timef@calendar = "julian"
  ;time@units    = "days since 1960-01-01"
  datei   =cd_calendar(timei,0)
  datef   =cd_calendar(timef,0)
  yeari   =tointeger(datei(:,0))
  yearf   =tointeger(datef(:,0))
  moni    =tointeger(datei(:,1))
  monf    =tointeger(datef(:,1))
  dayi    =tointeger(datei(:,2))
  dayf    =tointeger(datef(:,2))

  ntim  = dimsizes(yeari)
  ;dim   = dimsizes(vseas)
  ;ntim2 = dim(1)
 
  nlat  = dimsizes(lat)
  mlon  = dimsizes(lon)

;**********************************************************

wlon=new((/1/), "string")
wlat=new(nlat, "string")

;**********************************************************
; Write data in CPTv=>10 format
;**********************************************************
system("rm -Rf "+filen)

  asciiwrite("algo", "xmlns:cpt=http://iri.columbia.edu/CPT/v10/")
  system("cat algo >>"+filen)
  asciiwrite("algo", "cpt:ncats=3")
  system("cat algo >>"+filen)

if(moni(0).eq.monf(0)) then    ;we just need to test it for 0 as all should be the same
  samemon=1
  else
  samemon=0
end if

do it=0,ntim-1
 do ic=1,3 ; categories
 if (ic.eq.1) then 
 	vseas  = fi->BN
 	print("Below Normal")
   else if (ic.eq.2) then
   		an = fi->AN
   		bn = fi->BN
   		vseas  = 100 - an - bn
   		print("Normal")
   else if (ic.eq.3) then 
   		vseas  = fi->AN
   		print("Above Normal")
   end if
   end if
 end if
  print("processing: "+yeari(it)); + " " +moni(it))

  if(samemon.ne.0) then
	asciiwrite("algo", "cpt:field="+vari+", cpt:C="+ic+", cpt:clim_prob=0.333333333333, cpt:T="+yeari(it)+"-"+sprinti("%2.2i",moni(it))+"-"+sprinti("%2.2i",dayi(it))+"/"+sprinti("%2.2i",dayf(it))+", cpt:nrow="+nlat+", cpt:ncol="+mlon+", cpt:row=Y, cpt:col=X, cpt:units="+units+", cpt:missing=-1.0")
   else
	asciiwrite("algo", "cpt:field="+vari+", cpt:C="+ic+", cpt:clim_prob=0.333333333333, cpt:T="+yeari(it)+"-"+sprinti("%2.2i",moni(it))+"-"+sprinti("%2.2i",dayi(it))+"/"+yearf(it)+"-"+sprinti("%2.2i",monf(it))+"-"+sprinti("%2.2i",dayf(it))+", cpt:nrow="+nlat+", cpt:ncol="+mlon+", cpt:row=Y, cpt:col=X, cpt:units="+units+", cpt:missing=-1.0")
  end if
  
	system("cat algo >>"+filen)
	wlon = "        "  
	do nl=0,mlon-1        
            wlon = wlon + sprintf("%7.2f   ",lon(nl))
 	end do
 	asciiwrite("algo",wlon)
	system("cat algo >>"+filen)


  do nl=0,nlat-1        
       wlat(nl) = sprintf("%7.1f ",lat(nl))
    do ml=0,mlon-1
	 wlat(nl) = wlat(nl) + sprintf("%7.2f   ", vseas(nl,ml,it))
    end do
  end do
 	asciiwrite("algo",wlat)
	system("cat algo >>"+filen)

 end do  ;categories (ic)
end do   ;time (it)

system("rm -Rf algo")
system("unix2dos "+filen)
end
