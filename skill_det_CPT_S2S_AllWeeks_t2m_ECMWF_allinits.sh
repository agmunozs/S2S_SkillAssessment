#! /bin/bash
#Script to assess raw weekly skill of ECMWF subseasonal temperature forecasts (all inits per month). 
#Author: Á.G. Muñoz (agmunoz@iri.columbia.edu), Andrew W. Robertson and Remi Cousin
#This version: 26 Mar 2018
#First version: 12 Dec 2017
#
#Output:
# + Several skill maps for assessment of deterministic forecast, in the output folder.
# + CPT scripts used to assess skill, in the scripts folder.
# + Downloaded input files, in the input folder.
#Notes:
#0. Old data in the input folder is deleted at the beginning of the process!
#1. All initializations available per month are used, concatenated.
#2. The T coordinate has been faked, so CPT can deal with all the initializations.
#3. Spatial subsetting is now possible in this version of the script. Uncomment lines.
#4. temperature observations are CPC Unified (Chen et al 2008), at 1.5 deg. (Land only)
#5. All weeks can be processed with this version.  

####START OF USER-MODIFIABLE SECTION######

#Weeks(s) to download and assess (modify as needed):
#declare -a wee=('Week1' 'Week2' 'Week3' 'Week4' 'Week5' 'Week6')
declare -a wee=('Week4')  #if just a particular month is desired
#Month(s) to download and assess (modify as needed):
#declare -a mon=('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec')
declare -a mon=('Mar')  #if just a particular month is desired
#Year when hindcasts were produced (must be >=2015 and <=present year)
syear=2017
#S2S Database key
key='017a28e8531cac13efd89be8a7612c4c0754a83606f8f90270d14d84f62c28d7ff7fe8fbfb04c0495ddf938392d0bf3d9617e8b7'
#Number of days to average (use 7 for weekly averages, 14 for biweekly ones)
nda=7
#Spatial domain for predictor
nla1=90 # Nothernmost latitude
sla1=-90 # Southernmost latitude
wlo1=360 # Westernmost longitude
elo1=0 # Easternmost longitude
#Spatial domain for predictand
nla2=90 # Nothernmost latitude
sla2=-90 # Southernmost latitude
wlo2=360 # Westernmost longitude
elo2=0 # Easternmost longitude
#PATH to CPT root directory
cptdir='/Users/agmunoz/Documents/Angel/CPT/CPT/15.7.3/'

####END OF USER-MODIFIABLE SECTION######
####DO NOT CHANGE ANYTHING BELOW THIS LINE####

clear
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Script to assess raw weekly skill of ECMWF subseasonal temperature forecasts - all inits per month. 
echo Authors: Á.G. Muñoz, Andrew W. Robertson and Remi Cousin @ IRI - Earth Institute - Columbia U.
echo Email: agmunoz@iri.columbia.edu 
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo
echo
#Prepare folders
echo Creating working folders, if not already there...
mkdir -p input
mkdir -p output
mkdir -p scripts
#rm -Rf input/model_*.tsv input/obs_*.tsv  #comment if deletion of old input files is not desired.
rm -Rf scripts/*

cd input
#Set up some parameters
export CPT_BIN_DIR=${cptdir}

#Start week loop
for we in "${wee[@]}"
do
#define leads depending on the selected week
case "$we" in
Week1)  Li=0 ; Lf=7
    ;;
Week2)  Li=7 ; Lf=14
    ;;
Week3)  Li=14 ; Lf=21
    ;;
Week4)  Li=21 ; Lf=28
   ;;
Week5)  Li=28 ; Lf=35
   ;;
Week6)  Li=35 ; Lf=42
   ;;
esac

#Start month loop
for mo in "${mon[@]}"
do

#Download hindcasts (ECMF for now)
#  url='https://iridl.ldeo.columbia.edu/expert/SOURCES/.ECMWF/.S2S/.ECMF/.reforecast/.perturbed/.2m_above_ground/.2t/X/'${wlo1}'/'${elo1}'/RANGE/Y/'${sla1}'/'${nla1}'/RANGE/LA/(21)/(28)/VALUES/S/('${mo}'%20'$syear')/VALUES/%5BLA%5D//keepgrids/average/-999/setmissing_value/hdate/('$(($syear-20))')/('$(($syear-1))')/RANGE/dup/%5Bhdate%5Daverage/sub/%5BM%5Daverage/hdate//pointwidth/0/def/-6/shiftGRID/hdate/(days%20since%201960-01-01)/streamgridunitconvert/S/(days%20since%20'$syear'-01-01)/streamgridunitconvert/S//units//days/def/LA/hdate/add/add/0/RECHUNK/LA/removeGRID//name//T/def/2/%7Bexch%5BS/hdate%5D//I/nchunk/NewIntegerGRID/replaceGRIDstream%7Drepeat/use_as_grid/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12./16/Jan/2060/ensotime/%3Agrid/use_as_grid/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
  url='https://iridl.ldeo.columbia.edu/expert/SOURCES/.ECMWF/.S2S/.ECMF/.reforecast/.perturbed/.2m_above_ground/.2t/LA/('${Li}')/('${Lf}')/RANGE/S/('${mo}'%20'$syear')/VALUES/%5BLA%5D//keepgrids/average/-999/setmissing_value/hdate/('$(($syear-20))')/('$(($syear-1))')/RANGE/dup/%5Bhdate%5Daverage/sub/%5BM%5Daverage/hdate//pointwidth/0/def/-6/shiftGRID/hdate/(days%20since%201960-01-01)/streamgridunitconvert/S/(days%20since%20'$syear'-01-01)/streamgridunitconvert/S//units//days/def/LA/hdate/add/add/0/RECHUNK/LA/removeGRID//name//T/def/2/%7Bexch%5BS/hdate%5D//I/nchunk/NewIntegerGRID/replaceGRIDstream%7Drepeat/use_as_grid/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12./16/Jan/2060/ensotime/%3Agrid/use_as_grid/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'

  echo ---------------------------------------------------
  echo Downloading hindcasts and observations for ${we} and ${mo} ...
  echo $url
  curl -g --fail -k -b '__dlauth_id='$key'' ''$url'' > model_t2m_${we}_${mo}.tsv

#Download observations
#  url='http://iridl.ldeo.columbia.edu/expert/SOURCES/.ECMWF/.S2S/.ECMF/.reforecast/.perturbed/.2m_above_ground/.2t/X/'${wlo2}'/'${elo2}'/RANGE/Y/'${sla2}'/'${nla2}'/RANGE/LA/(21)/(28)/VALUES/S/('${mo}'%20'$syear')/VALUES/%5BLA%5D//keepgrids/average/c%3A//name//water_density/def/998/(kg/m3)/%3Ac/div//mm/unitconvert/-999/setmissing_value/hdate/('$(($syear-20))')/('$(($syear-1))')/RANGE/dup/%5Bhdate%5Daverage/sub/%5BM%5Daverage/hdate//pointwidth/0/def/-6/shiftGRID/hdate/(days%20since%201960-01-01)/streamgridunitconvert/S/(days%20since%20'$syear'-01-01)/streamgridunitconvert/S//units//days/def/LA/hdate/add/add/0/RECHUNK/LA/removeGRID//name//T/def/2/%7Bexch%5BS/hdate%5D//I/nchunk/NewIntegerGRID/replaceGRIDstream%7Drepeat/use_as_grid/SOURCES/.NOAA/.NCEP/.CPC/.UNIFIED_T2M/.GAUGE_BASED/.GLOBAL/.v1p0/.RETRO/.rain/SOURCES/.NOAA/.NCEP/.CPC/.UNIFIED_T2M/.GAUGE_BASED/.GLOBAL/.v1p0/.REALTIME/.rain/appendstream/X/'${wlo1}'/'${elo1}'/RANGE/Y/'${sla1}'/'${nla1}'/RANGE/T/0.5/shiftGRID/T/'${nda}'/runningAverage/'${nda}'.0/mul/T/2/index/.T/SAMPLE/dup%5BT%5Daverage/sub/-999/setmissing_value/nip/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12./16/Jan/2060/ensotime/%3Agrid/use_as_grid/%5BX/Y%5D%5BT%5Dcptv10.tsv'
  url='https://iridl.ldeo.columbia.edu/expert/SOURCES/.ECMWF/.S2S/.ECMF/.reforecast/.perturbed/.2m_above_ground/.2t/LA/('${Li}')/('${Lf}')/RANGE/S/('${mo}'%20'$syear')/VALUES/%5BLA%5D//keepgrids/average/-999/setmissing_value/hdate/('$(($syear-20))')/('$(($syear-1))')/RANGE/dup/%5Bhdate%5Daverage/sub/%5BM%5Daverage/hdate//pointwidth/0/def/-6/shiftGRID/hdate/(days%20since%201960-01-01)/streamgridunitconvert/S/(days%20since%20'$syear'-01-01)/streamgridunitconvert/S//units//days/def/LA/hdate/add/add/0/RECHUNK/LA/removeGRID//name//T/def/2/%7Bexch%5BS/hdate%5D//I/nchunk/NewIntegerGRID/replaceGRIDstream%7Drepeat/use_as_grid/SOURCES/.ECMWF/IRIONLY/.ERA-Interim/.SIX-HOURLY/.2m_above_ground/.t2m/T/0.125/shiftGRID/T/1/boxAverage/T/'${nda}'/runningAverage/'${nda}'.0/mul/T/2/index/.T/SAMPLE/dup/[T]average/sub/-999/setmissing_value/nip/grid://name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/2060/ensotime/:grid/use_as_grid/%5BX/Y%5D%5BT%5Dcptv10.tsv'

  echo $url
  curl -g --fail -k -b '__dlauth_id='$key'' ''$url'' > obs_t2m_${we}_${mo}.tsv

#Create CPT script
  cd ../scripts
  echo ---------------------------------------------------
  echo Producing CPT scripts for ${we} and ${mo} ...

cat  <<< '#!/bin/bash 
'${cptdir}'CPT.x <<- END
614 # Opens GCM validation
1 # Opens X input file
../input/model_t2m_'${we}'_'${mo}'.tsv
90 # Nothernmost latitude
-90 # Southernmost latitude
0 # Westernmost longitude
360 # Easternmost longitude

2 # Opens Y input file
../input/obs_t2m_'${we}'_'${mo}'.tsv
90 # Nothernmost latitude
-90 # Southernmost latitude
0 # Westernmost longitude
360 # Easternmost longitude

4 # X training period
1901 # First year of X training period
5 # Y training period
1901 # First year of Y training period

531 # Goodness index
3 # Kendalls tau

7 # Option: Lenght of training period
160 # Lenght of training period 
8 # Option: Length of cross-validation window
5 # Enter length

#542 # Turn ON zero bound for Y data  -for *t2m* this is on by default!
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
../output/T2M_ECMWF_Kendallstau_raw_'${we}'_'${mo}'.txt

#######BUILD MODEL  !!!!!
311 # Cross-validation

#131 # select output format
#3 # GrADS format
# Save forecast results
#111 # output results
# save as GrADS

413 # cross-validated skill maps
2 # save Spearmans Correlation
../output/T2M_ECMWF_Spearman_raw_'${we}'_'${mo}'.txt

413 # cross-validated skill maps
3 # save 2AFC score
../output/T2M_ECMWF_2AFC_raw_'${we}'_'${mo}'.txt

413 # cross-validated skill maps
10 # save 2AFC score
../output/T2M_ECMWF_RocBelow_raw_'${we}'_'${mo}'.txt

413 # cross-validated skill maps
11 # save 2AFC score
../output/T2M_ECMWF_RocAbove_raw_'${we}'_'${mo}'.txt

#0 # Stop saving  (not needed in newest version of CPT)

0 # Exit
END
' > RawSkill_ECMWF_t2m_${we}_${mo}.cpt 

#Execute CPT and produce skill maps
  echo ---------------------------------------------------
  echo Executing CPT and producing skill maps for ${we} and ${mo} ...
  chmod 755 RawSkill_ECMWF_t2m_${we}_${mo}.cpt 
  ./RawSkill_ECMWF_t2m_${we}_${mo}.cpt #| grep Error

  cd ../input

  echo Done with ${we} and ${mo} !! Check output folder for results.
  echo
  echo
done   #month loop

done   #week loop