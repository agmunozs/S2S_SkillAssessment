#! /bin/bash
#Script to produce CCA forecast and assess associated Week23 skill,
# using NCEP subseasonal rainfall  (4 inits per month), vs IMD data. 
#Author: Á.G. Muñoz (agmunoz@iri.columbia.edu), Andrew W. Robertson and Remi Cousin
#This version: 20 Apr 2018, by AWR and AGM
#First version: 12 Dec 2017
#
#Output:
# + Several skill maps for assessment of deterministic forecast, in the output folder.
# + CPT scripts used to assess skill, in the scripts folder.
# + Downloaded input files, in the input folder.
#Notes:
#0. Old data in the input folder is deleted at the beginning of the process!
#1. *Weekly* initializations available per month are used, concatenated.
#2. The T coordinate has been faked, so CPT can deal with all the initializations.
#3. Spatial subsetting is now possible in this version of the script.
#4. Rainfall observations are IMD data (India) at 0.25 deg. (Land only). Definition of weeks HERE follows the IMD definition
#5. Requires pre-computed lead-dependent climo. Hardwired for week23 USING IMD DEFINITION: L1 (9) (23) VALUES. This must match the precomputed climo! 
#6. 4-member perturbed+control mean is used. 
#7. Output files "NCEP23IMD2" - the "2" suffix refers to use of IMD definition of week23
#8. FORECAST VERSION: Trains model on the calendar month containing the forecast start day (not optimal!)
#9. OUTPUT in GrADS format.
#10. NEW: CPT now stops if an error occurs.

####START OF USER-MODIFIABLE SECTION######

# Forecast date
declare -a mon=('Apr') 
fyr=2018 # Forecast year
fday=12 # Forecast day
#Year when hindcasts were produced (must be >=2015 and <=present year)
syear=2017

# Forecast lead interval (hardwired week2-3 using IMD definition)
day1=9 # First daily lead selected. For NCEP model, L1=1 is accum tp after 1 day
day2=23 #'$day1+$nda' #???  This MUST MATCH the climo!
nda=14 # Number of days to average

#Spatial domain for predictor
nla1=32 # Northernmost latitude
sla1=12 # Southernmost latitude
wlo1=74 # Westernmost longitude
elo1=92 # Easternmost longitude
#Spatial domain for predictand
nla2=27 # Northernmost latitude
sla2=22 # Southernmost latitude
wlo2=80 # Westernmost longitude
elo2=89 # Easternmost longitude

#PATH to CPT root directory
cptdir='/Users/agmunoz/Documents/Angel/CPT/CPT/15.7.3/'
#cptdir='/Users/andy/Dropbox/pgm/stats/CPT/CPT15/15.7.3/'

#S2S Database key
#Angel key='XXX'
# AWR key
key='XXX'

####END OF USER-MODIFIABLE SECTION######
####DO NOT CHANGE ANYTHING BELOW THIS LINE####

clear
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Script to assess raw Week23 skill of NCEP subseasonal rainfall forecasts - all inits per month, against IMD data. 
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
rm -Rf input/model_*.tsv input/obs_*.tsv  #comment if deletion of old input files is not desired.
rm -Rf scripts/*
day1f=$(($day1+1))

cd input
#Set up some parameters
export CPT_BIN_DIR=${cptdir}

#Start month loop
for mo in "${mon[@]}"
do

  echo ---------------------------------------------------
  echo Downloading hindcasts and observations for ${mo} ...
  
#Download hindcasts (NCEP)
# modified pre XYL selection for speedup
# here with  .wk23IMDclimo 

url='http://iridl.ldeo.columbia.edu/SOURCES/.ECMWF/.S2S/.NCEP/.reforecast/.perturbed/.sfc_precip/.tp/X/'${wlo1}'/'${elo1}'/RANGE/Y/'${sla1}'/'${nla1}'/RANGE/L1/'${day1}'/'${day2}'/VALUES/%5BL1%5Ddifferences/SOURCES/.ECMWF/.S2S/.NCEP/.reforecast/.control/.sfc_precip/.tp/X/'${wlo1}'/'${elo1}'/RANGE/Y/'${sla1}'/'${nla1}'/RANGE/L1/'${day1}'/'${day2}'/VALUES/%5BL1%5Ddifferences//M//ids/ordered/%5B4%5D/NewGRID/addGRID/appendstream/%5B/X/Y/M/L1/S/%5D/REORDER/2/RECHUNK/S/%280000%201%20Jan%201999%29/%280000%2031%20Dec%202010%29/RANGEEDGES/S/%28T%29/renameGRID/%5BM%5Daverage/home/.awr/.S2S/.NCEP/.wk23IMDclimo/.tp/%5BT%5D1.0/regridLinear/sub/T/%28Jan%29/VALUES/T/7/STEP/L1/T/add/0/RECHUNK//name//T2/def/2/%7Bexch%5BL1/T%5D//I/nchunk/NewIntegerGRID/replaceGRIDstream%7Drepeat/use_as_grid/T2/%28T%29/renameGRID/grid://name/%28T%29/def//units/%28months%20since%201960-01-01%29/def//standard_name/%28time%29/def//pointwidth/1/def/16/Jan/1901/ensotime/12./16/Jan/1955/ensotime/:grid/use_as_grid/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'


  echo $url
  curl -g -k -b '__dlauth_id='$key'' ''$url'' > model_precip_${mo}.tsv

#Download forecast file

url='http://iridl.ldeo.columbia.edu/home/.awr/.S2S/.NCEP/.wk23IMDclimo/.tp/L1/removeGRID/c%3A//name//water_density/def/998/(kg/m3)/%3Ac/div//mm/unitconvert/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.6_hourly_rotating/.FLXF/.surface/.PRATE/S/(0000%20'${fday}'%20'${mon}'%20'${fyr}')/VALUES/X/55/105/RANGE/Y/0/43/RANGE/S/(T)/renameGRID/%5BM%5Daverage/%5BL%5D1/0.0/boxAverage/L/'${day1f}'/'${day2}'/RANGEEDGES/%5BL%5Daverage/%5BX/Y%5DregridAverage/c%3A//name//water_density/def/998/(kg/m3)/%3Ac/div/(mm/day)/unitconvert/14/mul//units/(mm)/def/-999/setmissing_value/T/16/shiftGRID/exch/%5BT%5D1.0/regridLinear/sub/X/'${wlo1}'/'${elo1}'/RANGE/Y/'${sla1}'/'${nla1}'/RANGE/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/1/Jan/2001/ensotime/12.0/1/Jan/2001/ensotime/%3Agrid/addGRID/T//pointwidth/0/def/pop//name/(tp)/def//units/(kg%20m-2)/def//long_name/(precipitation_amount)/def/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
#url='http://iridl.ldeo.columbia.edu/home/.awr/.S2S/.NCEP/.wk23IMDclimo/.tp/L1/removeGRID/c%3A//name//water_density/def/998/(kg/m3)/%3Ac/div//mm/unitconvert/SOURCES/.NOAA/.NCEP/.EMC/.CFSv2/.6_hourly_rotating/.FLXF/.surface/.PRATE/S/(0000%2012%20Apr%202018)/VALUES/X/55/105/RANGE/Y/0/43/RANGE/S/(T)/renameGRID/%5BM%5Daverage/%5BL%5D1/0.0/boxAverage/L/'${day1f}'/'${day2}'/RANGEEDGES/%5BL%5Daverage/%5BX/Y%5DregridAverage/c%3A//name//water_density/def/998/(kg/m3)/%3Ac/div/(mm/day)/unitconvert/14/mul//units/(mm)/def/-999/setmissing_value/T/16/shiftGRID/exch/%5BT%5D1.0/regridLinear/sub/X/'${wlo1}'/'${elo1}'/RANGE/Y/'${sla1}'/'${nla1}'/RANGE/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/1/Jan/2001/ensotime/12.0/1/Jan/2001/ensotime/%3Agrid/addGRID/T//pointwidth/0/def/pop//name/(tp)/def//units/(kg%20m-2)/def//long_name/(precipitation_amount)/def/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
  echo $url
  curl -g -k -b '__dlauth_id='$key'' ''$url'' > modelfcst_precip_${mo}.tsv

#Download observations
#
url='http://iridl.ldeo.columbia.edu/SOURCES/.ECMWF/.S2S/.NCEP/.reforecast/.perturbed/.sfc_precip/.tp/X/'${wlo1}'/'${elo1}'/RANGE/Y/'${sla1}'/'${nla1}'/RANGE/S/(0000%201%20Jan%201999)/(0000%2031%20Dec%202010)/RANGEEDGES/S/(T)/renameGRID/%5BM%5Daverage/L1/('${day1}')/('${day2}')/VALUES/%5BL1%5Ddifferences/home/.awr/.S2S/.NCEP/.wk23IMDclimo/.tp/%5BT%5D1.0/regridLinear/sub/T/('${mo}')/VALUES/T/7/STEP/L1/T/add/0/RECHUNK//name//T2/def/2/%7Bexch%5BL1/T%5D//I/nchunk/NewIntegerGRID/replaceGRIDstream%7Drepeat/use_as_grid/T2/(T)/renameGRID/SOURCES/.IMD/.RF0p25/.gridded/.daily/.v1901-2015/.rf/T/(days%20since%201960-01-01)/streamgridunitconvert/T/14/runningAverage/14.0/mul/T/2/index/.T/SAMPLE/-999/setmissing_value/nip/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12./16/Jan/1955/ensotime/%3Agrid/use_as_grid/%5BX/Y%5D%5BT%5Dcptv10.tsv'

  echo $url
  curl -g -k -b '__dlauth_id='$key'' ''$url'' > obs_precip_${mo}.tsv

#Create CPT script
  cd ../scripts
  echo ---------------------------------------------------
  echo Producing CPT scripts for ${mo} ...

cat  <<< '#!/bin/bash 
'${cptdir}'CPT.x <<- END
611 # Opens CCA
1 # Opens X input file
../input/model_precip_'${mo}'.tsv
'${nla1}' # Nothernmost latitude
'${sla1}' # Southernmost latitude
'${wlo1}' # Westernmost longitude
'${elo1}' # Easternmost longitude

1    # Minimum number of modes
10 # Maximum number of modes

3 # Opens forecast (X) file
../input/modelfcst_precip_'${mo}'.tsv

2 # Opens Y input file
../input/obs_precip_'${mo}'.tsv
'${nla2}' # Nothernmost latitude
'${sla2}' # Southernmost latitude
'${wlo2}' # Westernmost longitude
'${elo2}' # Easternmost longitude

1    # Minimum number of modes
10 # Maximum number of modes

1    # Minimum number of CCA modes
5    # Maximum number of CCAmodes

4 # X training period
1901 # First year of X training period
5 # Y training period
1901 # First year of Y training period

571 #Error option
3   # Stop CPT if error occurs 

531 # Goodness index
3 # Kendalls tau

7 # Option: Lenght of training period
55 # Lenght of training period 
8 # Option: Length of cross-validation window
3 # Enter length

541 # Turn ON Transform predictand data
542 # Turn ON zero bound for Y data
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

#554 # Transformation seetings
#1   #Empirical distribution


# Cross-validation
112 # save goodness index
../output/PRCP_Kendallstau_CCA_'${mo}'.txt

#######BUILD MODEL AND VALIDATE IT  !!!!!
311 # Cross-validation

131 # select output format
3 # GrADS format


413 # cross-validated skill maps
2 # save Spearmans Correlation
../output/PRCP_Spearman_CCA_'${mo}'

413 # cross-validated skill maps
3 # save 2AFC score
../output/PRCP_2AFC_CCA_'${mo}'

413 # cross-validated skill maps
10 # save 2AFC score
../output/PRCP_RocBelow_CCA_'${mo}'

413 # cross-validated skill maps
11 # save 2AFC score
../output/PRCP_RocAbove_CCA_'${mo}'

#######FORECAST(S)  !!!!!
455 # Probabilistic (3 categories) maps
111 # Output results
501 # Forecast probabilities
../output/PRCP_CCAFCST_PROB_'${mon}'
#502 # Forecast odds
0 #Exit submenu

#0 # Stop saving  (not needed in newest version of CPT)

0 # Exit
END
' > CCA_SkillandForecast_NCEP23IMD2_precip_${mo}.cpt 

#Execute CPT and produce skill maps
  echo ---------------------------------------------------
  echo Executing CPT and producing skill maps for ${mo} ...
  chmod 755 CCA_SkillandForecast_NCEP23IMD2_precip_${mo}.cpt 
  ./CCA_SkillandForecast_NCEP23IMD2_precip_${mo}.cpt #| grep Error

  cd ../input

  echo Done with ${mo} !! Check output folder for results.
  echo
  echo
done
