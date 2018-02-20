#! /bin/bash
#Script to automate the download of S2S ECMF rainfall deterministic hindcasts and observations 
#for WEEK3, and execution of CPT to assess associated uncalibrated skill.
#Author: Á.G. Muñoz (agms@princeton.edu)
#
#Output:
# + Several skill maps for assessment of deterministic forecast, in the output folder.
# + CPT scripts used to assess skill, in the scripts folder.
# + Downloaded input files, in the input folder.
#Notes:
#0. Old data in the input folder is deleted at the beginning of the process!
#1. A simple average of all initializations available per month is used.
#2. The date appearing in the CPT file is just a reference, indicating it's Week3 of that month.
#3. Right now there's no spatial subsetting (it uses the entire world). This could be easily added to the DL link.
#4. Rainfall observations are CPC Unified (Chen et al 2008).

####START OF USER-MODIFIABLE SECTION######

#Month(s) to download and assess (modify as needed):
declare -a mon=('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec')
#declare -a mon=('Dec')  #if just a particular month is desired
#Year when hindcasts were produced (must be >=2015 and <=present year)
syear=2016
#S2S Database key
key='017a28e8531cac13efd89be8a7612c4c0754a83606f8f90270d14d84f62c28d7ff7fe8fbfb04c0495ddf938392d0bf3d9617e8b7'
#PATH to CPT root directory
cptdir='/Users/agmunoz/Documents/Angel/CPT/CPT/15.7.3/'

####END OF USER-MODIFIABLE SECTION######
####DO NOT CHANGE ANYTHING BELOW THIS LINE####

clear
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Script to automate the download of NMME seasonal rainfall deterministic hindcasts and observations,
echo and to execute CPT to assess associated uncalibrated skill
echo Author: Á.G. Muñoz - agmunoz@iri.columbia.edu
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo
echo
#Prepare folders
echo Creating working folders, if not already there...
mkdir -p input
mkdir -p output
mkdir -p scripts
rm -Rf input/model_*.tsv input/obs_*.tsv  #comment if deletion of old input files is not desired.
rm -Rf scripts/*

cd input
#Set up some parameters
export CPT_BIN_DIR=${cptdir}

#Start loop
for mo in "${mon[@]}"
do
#Download hindcasts (ECMF for now)
  url='http://iridl.ldeo.columbia.edu/SOURCES/.ECMWF/.S2S/.ECMF/.reforecast/.perturbed/.sfc_precip/.tp/L/(14)/(21)/VALUES/S/(%20'${mo}'%20'$syear')/VALUES/%5BS%5Daverage/%5BL%5Ddifferences/L/removeGRID/c%3A//name//water_density/def/998/(kg/m3)/%3Ac/div//mm/unitconvert/-999/setmissing_value/hdate/('$(($syear-20))')/('$(($syear-1))')/RANGE/hdate//T/renameGRID/T/name//julian_day/ordered%5B18/'${mo}'/'$(($syear-20))'/dmy2jd/18/'${mo}'/'$(($syear-19))'/dmy2jd/18/'${mo}'/'$(($syear-18))'/dmy2jd/18/'${mo}'/'$(($syear-17))'/dmy2jd/18/'${mo}'/'$(($syear-16))'/dmy2jd/18/'${mo}'/'$(($syear-15))'/dmy2jd/18/'${mo}'/'$(($syear-14))'/dmy2jd/18/'${mo}'/'$(($syear-13))'/dmy2jd/18/'${mo}'/'$(($syear-12))'/dmy2jd/18/'${mo}'/'$(($syear-11))'/dmy2jd/18/'${mo}'/'$(($syear-10))'/dmy2jd/18/'${mo}'/'$(($syear-9))'/dmy2jd/18/'${mo}'/'$(($syear-8))'/dmy2jd/18/'${mo}'/'$(($syear-7))'/dmy2jd/18/'${mo}'/'$(($syear-6))'/dmy2jd/18/'${mo}'/'$(($syear-5))'/dmy2jd/18/'${mo}'/'$(($syear-4))'/dmy2jd/18/'${mo}'/'$(($syear-3))'/dmy2jd/18/'${mo}'/'$(($syear-2))'/dmy2jd/18/'${mo}'/'$(($syear-1))'/dmy2jd/%5DNewGRID//pointwidth/7/def/replaceGRID/%5BM%5Daverage/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
  echo $url
  echo ---------------------------------------------------
  echo Downloading hindcasts and observations for ${mo} ...
  curl -k -b '__dlauth_id='$key'' $url > model_precip_${mo}.tsv

#Download observations
#  url='http://iridl.ldeo.columbia.edu/expert/SOURCES/.NOAA/.NCEP/.CPC/.UNIFIED_PRCP/.GAUGE_BASED/.GLOBAL/.v1p0/.RETRO/.rain/T/0.5/shiftGRID/SOURCES/.NOAA/.NCEP/.CPC/.UNIFIED_PRCP/.GAUGE_BASED/.GLOBAL/.v1p0/.REALTIME/.rain/T/0.5/shiftGRID/appendstream/a%3A/T/(15-21%20'${mo}'%20'$(($syear-20))'-'$(($syear-1))')/RANGE/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/%3Aa%3A/T/(17-23%20'${mo}'%20'$(($syear-20))'-'$(($syear-1))')/RANGE/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/add/%3Aa%3A/T/(22-28%20'${mo}'%20'$(($syear-20))'-'$(($syear-1))')/RANGE/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/add/%3Aa%3A/T/(24-30%20'${mo}'%20'$(($syear-20))'-'$(($syear-1))')/RANGE/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/add/%3Aa%3A/T/(28-31%20'${mo}'%20'$(($syear-20))'-'$(($syear-1))')/RANGE/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/add/%3Aa%3A/T/(1-4%20'${mon[$mo2]}'%20'$(($syear-20))'-'$(($syear-1))')/RANGE/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/add/%3Aa%3A/T/(1-7%20'${mon[$mo2]}'%20'$(($syear-20))'-'$(($syear-1))')/RANGE/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/add/%3Aa%3A/T/(5-11%20'${mon[$mo2]}'%20'$(($syear-20))'-'$(($syear-1))')/RANGE/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/add/%3Aa%3A/T/(8-14%20'${mon[$mo2]}'%20'$(($syear-20))'-'$(($syear-1))')/RANGE/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/add/%3Aa/8/div/T/name//julian_day/ordered%5B18/'${mo}'/'$(($syear-20))'/dmy2jd/18/'${mo}'/'$(($syear-19))'/dmy2jd/18/'${mo}'/'$(($syear-18))'/dmy2jd/18/'${mo}'/'$(($syear-17))'/dmy2jd/18/'${mo}'/'$(($syear-16))'/dmy2jd/18/'${mo}'/'$(($syear-15))'/dmy2jd/18/'${mo}'/'$(($syear-14))'/dmy2jd/18/'${mo}'/'$(($syear-13))'/dmy2jd/18/'${mo}'/'$(($syear-12))'/dmy2jd/18/'${mo}'/'$(($syear-11))'/dmy2jd/18/'${mo}'/'$(($syear-10))'/dmy2jd/18/'${mo}'/'$(($syear-9))'/dmy2jd/18/'${mo}'/'$(($syear-8))'/dmy2jd/18/'${mo}'/'$(($syear-7))'/dmy2jd/18/'${mo}'/'$(($syear-6))'/dmy2jd/18/'${mo}'/'$(($syear-5))'/dmy2jd/18/'${mo}'/'$(($syear-4))'/dmy2jd/18/'${mo}'/'$(($syear-3))'/dmy2jd/18/'${mo}'/'$(($syear-2))'/dmy2jd/18/'${mo}'/'$(($syear-1))'/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/7/mul//units/(mm)/def/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
  url='https://iridl.ldeo.columbia.edu/expert/SOURCES/.ECMWF/.S2S/.ECMF/.reforecast/.perturbed/.sfc_precip/.cp/L/(15)(21)RANGE/S/(%20'${mo}'%20'$syear')/VALUES/S/first/secondtolast/RANGE/hdate/('$(($syear-20))')('$(($syear-1))')/RANGE/hdate//pointwidth/0/def/-6/shiftGRID/hdate/(days%20since%201960-01-01)streamgridunitconvert/S/(days%20since%20'$syear'-01-01)streamgridunitconvert/S//units//days/def/L/hdate/add/add/SOURCES/.NOAA/.NCEP/.CPC/.UNIFIED_PRCP/.GAUGE_BASED/.GLOBAL/.v1p0/.RETRO/.rain/SOURCES/.NOAA/.NCEP/.CPC/.UNIFIED_PRCP/.GAUGE_BASED/.GLOBAL/.v1p0/.REALTIME/.rain/appendstream/exch/T/sample-along[L]sum[S]average/hdate/(T)renameGRID/T/name//julian_day/ordered%5B18/'${mo}'/'$(($syear-20))'/dmy2jd/18/'${mo}'/'$(($syear-19))'/dmy2jd/18/'${mo}'/'$(($syear-18))'/dmy2jd/18/'${mo}'/'$(($syear-17))'/dmy2jd/18/'${mo}'/'$(($syear-16))'/dmy2jd/18/'${mo}'/'$(($syear-15))'/dmy2jd/18/'${mo}'/'$(($syear-14))'/dmy2jd/18/'${mo}'/'$(($syear-13))'/dmy2jd/18/'${mo}'/'$(($syear-12))'/dmy2jd/18/'${mo}'/'$(($syear-11))'/dmy2jd/18/'${mo}'/'$(($syear-10))'/dmy2jd/18/'${mo}'/'$(($syear-9))'/dmy2jd/18/'${mo}'/'$(($syear-8))'/dmy2jd/18/'${mo}'/'$(($syear-7))'/dmy2jd/18/'${mo}'/'$(($syear-6))'/dmy2jd/18/'${mo}'/'$(($syear-5))'/dmy2jd/18/'${mo}'/'$(($syear-4))'/dmy2jd/18/'${mo}'/'$(($syear-3))'/dmy2jd/18/'${mo}'/'$(($syear-2))'/dmy2jd/18/'${mo}'/'$(($syear-1))'/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop//units/(mm)def/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
  echo $url
  #curl -k ''$url'' > obs_precip_${mo}.tsv
  curl -g -k -b '__dlauth_id='$key'' ''$url'' > obs_precip_${mo}.tsv

#Create CPT script
  cd ../scripts
  echo ---------------------------------------------------
  echo Producing CPT scripts for ${mo} ...

cat  <<< '#!/bin/bash 
'${cptdir}'CPT.x <<- END
614 # Opens GCM validation
1 # Opens X input file
../input/model_precip_'${mo}'.tsv
90 # Nothernmost latitude
-90 # Southernmost latitude
0 # Westernmost longitude
359 # Easternmost longitude

2 # Opens Y input file
../input/obs_precip_'${mo}'.tsv
90 # Nothernmost latitude
-90 # Southernmost latitude
0 # Westernmost longitude
360 # Easternmost longitude

4 # X training period
1996 # First year of X training period
5 # Y training period
1996 # First year of Y training period

531 # Goodness index
3 # Kendalls tau

7 # Option: Lenght of training period
20 # Lenght of training period 
8 # Option: Length of cross-validation window
3 # Enter length

#542 # Turn ON zero bound for Y data
545 # Turn ON synchronous predictors
#561 # Turn ON p-values for skill maps

544 # Missing value options
-999 # Missing value X flag:
10 # Maximum % of missing values
10 # Maximum % of missing gridpoints
1 # Number of near-neighbours
4 # Missing value replacement : best-near-neighbours
-999 # Y missing value flag
10 # Maximum % of missing values
10 # Maximum % of missing stations
1 # Number of near-neighours
4 # Best near neighbour


# Cross-validation
112 # save goodness index
../output/PRCP_Kendallstau_raw_'${mo}'.txt

#######BUILD MODEL  !!!!!
311 # Cross-validation

#131 # select output format
#3 # GrADS format
# Save forecast results
#111 # output results
# save as GrADS

413 # cross-validated skill maps
2 # save Spearmans Correlation
../output/PRCP_Spearman_raw_'${mo}'.txt

413 # cross-validated skill maps
3 # save 2AFC score
../output/PRCP_2AFC_raw_'${mo}'.txt

413 # cross-validated skill maps
10 # save 2AFC score
../output/PRCP_RocBelow_raw_'${mo}'.txt

413 # cross-validated skill maps
11 # save 2AFC score
../output/PRCP_RocAbove_raw_'${mo}'.txt

#0 # Stop saving  (not needed in newest version of CPT)

0 # Exit
END
' > RawSkill_precip_Week3_${mo}.cpt 

#Execute CPT and produce skill maps
  echo ---------------------------------------------------
  echo Executing CPT and producing skill maps for ${mo} ...
  chmod 755 RawSkill_precip_Week3_${mo}.cpt 
  ./RawSkill_precip_Week3_${mo}.cpt 

  cd ../input

  echo Done with ${mo} !! Check output folder for results.
  echo
  echo
done