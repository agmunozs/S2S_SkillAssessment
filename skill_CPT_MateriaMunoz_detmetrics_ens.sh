#!/bin/bash
#Script to automate the pre-processing of S2S data (Materia-Muñoz paper) 
#for Weeks 3-6, and execution of CPT to assess associated skill.
#Author: Á.G. Muñoz (agms@princeton.edu)
#
#Output:
# + Ignorance and 2AFC maps, for assessment of probabilistic skill, in the output folder.
# + CPT scripts used to assess skill, in the scripts folder.
# + Downloaded input files, in the input folder.
#Notes:
#1. Old data in the input folder is deleted if downloading data (down=1)!
#2. A simple average of all ensemble members is used.
#3. Temperature observations are ERA interim.

####START OF USER-MODIFIABLE SECTION######
#Downloading data?
down=1   #1 for download all data, 0 for not downloading data.
#PATH to CPT root directory
cptdir='/Users/agmunoz/Documents/Angel/CPT/CPT/15.7.3/'
#Weeks to process (a subset of 3-6)
declare -a weeks=('3' '4' '5' '6')
nla=90 # Nothernmost latitude
sla=-90 # Southernmost latitude
wlo=0 # Westernmost longitude
elo=360 # Easternmost longitude

####END OF USER-MODIFIABLE SECTION######
####DO NOT CHANGE ANYTHING BELOW THIS LINE####

clear
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Script to automate the pre-processing of S2S data for the Materia-Muñoz paper
echo for Weeks 3-6, and execution of CPT to assess associated skill
echo Authors: Á.G. Muñoz -agms@princeton.edu-, S. Materia -stefano.materia@cmcc.it-
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo
echo
#Prepare folders
echo Creating working folders, if not already there...
mkdir -p input
mkdir -p output
mkdir -p scripts
rm -Rf scripts/*

#Set up some parameters
export CPT_BIN_DIR=${cptdir}

if [ $down -eq 1 ]; then
	rm -Rf input/*predictand.tsv input/*predictor.tsv  #comment if deletion of old input files is not desired.
	cd input
	echo Downloading predictands...
	#Download predictands
	wget -O t2m_1996-2014_Mar1_week3_predictand.tsv http://iridl.ldeo.columbia.edu/home/.agmunoz/.ERAi/.ERAi_6hrly_t2m.nc/.t2m/longitude/%28X%29/renameGRID/latitude/%28Y%29/renameGRID/time/%28T%29/renameGRID/X/${elo}/${wlo}/RANGEEDGES/Y/${sla}/${nla}/RANGEEDGES/%5BT%5D/24/boxAverage/T/%28days%20since%201900-01-01%29/streamgridunitconvert/T/.125/shiftGRID/T/%2816-22%20Mar%201996-2014%29/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/T/name//julian_day/ordered%5B19/Mar/1996/dmy2jd/19/Mar/1997/dmy2jd/19/Mar/1998/dmy2jd/19/Mar/1999/dmy2jd/19/Mar/2000/dmy2jd/19/Mar/2001/dmy2jd/19/Mar/2002/dmy2jd/19/Mar/2003/dmy2jd/19/Mar/2004/dmy2jd/19/Mar/2005/dmy2jd/19/Mar/2006/dmy2jd/19/Mar/2007/dmy2jd/19/Mar/2008/dmy2jd/19/Mar/2009/dmy2jd/19/Mar/2010/dmy2jd/19/Mar/2011/dmy2jd/19/Mar/2012/dmy2jd/19/Mar/2013/dmy2jd/19/Mar/2014/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv
	wget -O t2m_1996-2014_Mar1_week4_predictand.tsv http://iridl.ldeo.columbia.edu/home/.agmunoz/.ERAi/.ERAi_6hrly_t2m.nc/.t2m/longitude/%28X%29/renameGRID/latitude/%28Y%29/renameGRID/time/%28T%29/renameGRID/X/${elo}/${wlo}/RANGEEDGES/Y/${sla}/${nla}/RANGEEDGES/%5BT%5D/24/boxAverage/T/%28days%20since%201900-01-01%29/streamgridunitconvert/T/.125/shiftGRID/T/%2823-29%20Mar%201996-2014%29/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/T/name//julian_day/ordered%5B26/Mar/1996/dmy2jd/26/Mar/1997/dmy2jd/26/Mar/1998/dmy2jd/26/Mar/1999/dmy2jd/26/Mar/2000/dmy2jd/26/Mar/2001/dmy2jd/26/Mar/2002/dmy2jd/26/Mar/2003/dmy2jd/26/Mar/2004/dmy2jd/26/Mar/2005/dmy2jd/26/Mar/2006/dmy2jd/26/Mar/2007/dmy2jd/26/Mar/2008/dmy2jd/26/Mar/2009/dmy2jd/26/Mar/2010/dmy2jd/26/Mar/2011/dmy2jd/26/Mar/2012/dmy2jd/26/Mar/2013/dmy2jd/26/Mar/2014/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv
	wget -O t2m_1996-2014_Mar1_week5_predictand.tsv http://iridl.ldeo.columbia.edu/home/.agmunoz/.ERAi/.ERAi_6hrly_t2m.nc/.t2m/longitude/%28X%29/renameGRID/latitude/%28Y%29/renameGRID/time/%28T%29/renameGRID/X/${elo}/${wlo}/RANGEEDGES/Y/${sla}/${nla}/RANGEEDGES/%5BT%5D/24/boxAverage/T/%28days%20since%201960-01-01%29/streamgridunitconvert/T/.125/shiftGRID/a:/T/%2830-31%20Mar%201996-2014%29/RANGE/:a:/T/%281-5%20Apr%201996-2014%29/RANGE/:a/appendstream//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/name//julian_day/ordered%5B2/Apr/1996/dmy2jd/2/Apr/1997/dmy2jd/2/Apr/1998/dmy2jd/2/Apr/1999/dmy2jd/2/Apr/2000/dmy2jd/2/Apr/2001/dmy2jd/2/Apr/2002/dmy2jd/2/Apr/2003/dmy2jd/2/Apr/2004/dmy2jd/2/Apr/2005/dmy2jd/2/Apr/2006/dmy2jd/2/Apr/2007/dmy2jd/2/Apr/2008/dmy2jd/2/Apr/2009/dmy2jd/2/Apr/2010/dmy2jd/2/Apr/2011/dmy2jd/2/Apr/2012/dmy2jd/2/Apr/2013/dmy2jd/2/Apr/2014/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv
	wget -O t2m_1996-2014_Mar1_week6_predictand.tsv http://iridl.ldeo.columbia.edu/home/.agmunoz/.ERAi/.ERAi_6hrly_t2m.nc/.t2m/longitude/%28X%29/renameGRID/latitude/%28Y%29/renameGRID/time/%28T%29/renameGRID/X/${elo}/${wlo}/RANGEEDGES/Y/${sla}/${nla}/RANGEEDGES/%5BT%5D/24/boxAverage/T/%28days%20since%201900-01-01%29/streamgridunitconvert/T/.125/shiftGRID/T/%286-12%20Apr%201996-2014%29/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/T/name//julian_day/ordered%5B9/Apr/1996/dmy2jd/9/Apr/1997/dmy2jd/9/Apr/1998/dmy2jd/9/Apr/1999/dmy2jd/9/Apr/2000/dmy2jd/9/Apr/2001/dmy2jd/9/Apr/2002/dmy2jd/9/Apr/2003/dmy2jd/9/Apr/2004/dmy2jd/9/Apr/2005/dmy2jd/9/Apr/2006/dmy2jd/9/Apr/2007/dmy2jd/9/Apr/2008/dmy2jd/9/Apr/2009/dmy2jd/9/Apr/2010/dmy2jd/9/Apr/2011/dmy2jd/9/Apr/2012/dmy2jd/9/Apr/2013/dmy2jd/9/Apr/2014/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv
	echo Downloading predictors...
#	#Download predictors (deterministic ensemble mean --standardized): 
#	wget -O t2m_1996-2014_Mar1_std_ensmean_week3_predictor.tsv http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.temp2m_multis2s_0301_all_ano_weekly.1996-2014.nc/.temp2m/lon/-12/45/RANGE/lon/%28X%29/renameGRID/lat/30/75/RANGE/lat/%28Y%29/renameGRID//units/%28sigma%29/def/time/%2819%20Mar%201996%29/VALUE/time/-12/shiftGRID/time/removeGRID/%5Bens%5Daverage/year/%281%29/%2819%29/RANGE/year//T/renameGRID/T/name/npts/NewIntegerGRID/replaceGRID/T/name//julian_day/ordered%5B19/Mar/1996/dmy2jd/19/Mar/1997/dmy2jd/19/Mar/1998/dmy2jd/19/Mar/1999/dmy2jd/19/Mar/2000/dmy2jd/19/Mar/2001/dmy2jd/19/Mar/2002/dmy2jd/19/Mar/2003/dmy2jd/19/Mar/2004/dmy2jd/19/Mar/2005/dmy2jd/19/Mar/2006/dmy2jd/19/Mar/2007/dmy2jd/19/Mar/2008/dmy2jd/19/Mar/2009/dmy2jd/19/Mar/2010/dmy2jd/19/Mar/2011/dmy2jd/19/Mar/2012/dmy2jd/19/Mar/2013/dmy2jd/19/Mar/2014/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv
#	wget -O t2m_1996-2014_Mar1_std_ensmean_week4_predictor.tsv http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.temp2m_multis2s_0301_all_ano_weekly.1996-2014.nc/.temp2m/lon/-12/45/RANGE/lon/%28X%29/renameGRID/lat/30/75/RANGE/lat/%28Y%29/renameGRID//units/%28sigma%29/def/time/%2826%20Mar%201996%29/VALUE/time/-12/shiftGRID/time/removeGRID/%5Bens%5Daverage/year/%281%29/%2819%29/RANGE/year//T/renameGRID/T/name/npts/NewIntegerGRID/replaceGRID/T/name//julian_day/ordered%5B26/Mar/1996/dmy2jd/26/Mar/1997/dmy2jd/26/Mar/1998/dmy2jd/26/Mar/1999/dmy2jd/26/Mar/2000/dmy2jd/26/Mar/2001/dmy2jd/26/Mar/2002/dmy2jd/26/Mar/2003/dmy2jd/26/Mar/2004/dmy2jd/26/Mar/2005/dmy2jd/26/Mar/2006/dmy2jd/26/Mar/2007/dmy2jd/26/Mar/2008/dmy2jd/26/Mar/2009/dmy2jd/26/Mar/2010/dmy2jd/26/Mar/2011/dmy2jd/26/Mar/2012/dmy2jd/26/Mar/2013/dmy2jd/26/Mar/2014/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv
#	wget -O t2m_1996-2014_Mar1_std_ensmean_week5_predictor.tsv http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.temp2m_multis2s_0301_all_ano_weekly.1996-2014.nc/.temp2m/lon/-12/45/RANGE/lon/%28X%29/renameGRID/lat/30/75/RANGE/lat/%28Y%29/renameGRID//units/%28sigma%29/def/time/%282%20Apr%201996%29/VALUE/time/-12/shiftGRID/time/removeGRID/%5Bens%5Daverage/year/%281%29/%2819%29/RANGE/year//T/renameGRID/T/name/npts/NewIntegerGRID/replaceGRID/T/name//julian_day/ordered%5B2/Apr/1996/dmy2jd/2/Apr/1997/dmy2jd/2/Apr/1998/dmy2jd/2/Apr/1999/dmy2jd/2/Apr/2000/dmy2jd/2/Apr/2001/dmy2jd/2/Apr/2002/dmy2jd/2/Apr/2003/dmy2jd/2/Apr/2004/dmy2jd/2/Apr/2005/dmy2jd/2/Apr/2006/dmy2jd/2/Apr/2007/dmy2jd/2/Apr/2008/dmy2jd/2/Apr/2009/dmy2jd/2/Apr/2010/dmy2jd/2/Apr/2011/dmy2jd/2/Apr/2012/dmy2jd/2/Apr/2013/dmy2jd/2/Apr/2014/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv
#	wget -O t2m_1996-2014_Mar1_std_ensmean_week6_predictor.tsv http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.temp2m_multis2s_0301_all_ano_weekly.1996-2014.nc/.temp2m/lon/-12/45/RANGE/lon/%28X%29/renameGRID/lat/30/75/RANGE/lat/%28Y%29/renameGRID//units/%28sigma%29/def/time/%289%20Apr%201996%29/VALUE/time/-12/shiftGRID/time/removeGRID/%5Bens%5Daverage/year/%281%29/%2819%29/RANGE/year//T/renameGRID/T/name/npts/NewIntegerGRID/replaceGRID/T/name//julian_day/ordered%5B9/Apr/1996/dmy2jd/9/Apr/1997/dmy2jd/9/Apr/1998/dmy2jd/9/Apr/1999/dmy2jd/9/Apr/2000/dmy2jd/9/Apr/2001/dmy2jd/9/Apr/2002/dmy2jd/9/Apr/2003/dmy2jd/9/Apr/2004/dmy2jd/9/Apr/2005/dmy2jd/9/Apr/2006/dmy2jd/9/Apr/2007/dmy2jd/9/Apr/2008/dmy2jd/9/Apr/2009/dmy2jd/9/Apr/2010/dmy2jd/9/Apr/2011/dmy2jd/9/Apr/2012/dmy2jd/9/Apr/2013/dmy2jd/9/Apr/2014/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv
	#Download predictors (deterministic ensemble mean --no standardization): 
	wget -O t2m_1996-2014_Mar1_nostd_ensmean_week3_predictor.tsv http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.temp2m_multis2s_0301_all_rawano_weekly.1996-2014.nc/.temp2m/lon/${elo}/${wlo}/RANGE/lon/%28X%29/renameGRID/lat/${sla}/${nla}/RANGE/lat/%28Y%29/renameGRID//units/%28sigma%29/def/time/%2819%20Mar%201996%29/VALUE/time/-12/shiftGRID/time/removeGRID/%5Bens%5Daverage/year/%281%29/%2819%29/RANGE/year//T/renameGRID/T/name/npts/NewIntegerGRID/replaceGRID/T/name//julian_day/ordered%5B19/Mar/1996/dmy2jd/19/Mar/1997/dmy2jd/19/Mar/1998/dmy2jd/19/Mar/1999/dmy2jd/19/Mar/2000/dmy2jd/19/Mar/2001/dmy2jd/19/Mar/2002/dmy2jd/19/Mar/2003/dmy2jd/19/Mar/2004/dmy2jd/19/Mar/2005/dmy2jd/19/Mar/2006/dmy2jd/19/Mar/2007/dmy2jd/19/Mar/2008/dmy2jd/19/Mar/2009/dmy2jd/19/Mar/2010/dmy2jd/19/Mar/2011/dmy2jd/19/Mar/2012/dmy2jd/19/Mar/2013/dmy2jd/19/Mar/2014/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv
	wget -O t2m_1996-2014_Mar1_nostd_ensmean_week4_predictor.tsv http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.temp2m_multis2s_0301_all_rawano_weekly.1996-2014.nc/.temp2m/lon/${elo}/${wlo}/RANGE/lon/%28X%29/renameGRID/lat/${sla}/${nla}/RANGE/lat/%28Y%29/renameGRID//units/%28sigma%29/def/time/%2826%20Mar%201996%29/VALUE/time/-12/shiftGRID/time/removeGRID/%5Bens%5Daverage/year/%281%29/%2819%29/RANGE/year//T/renameGRID/T/name/npts/NewIntegerGRID/replaceGRID/T/name//julian_day/ordered%5B26/Mar/1996/dmy2jd/26/Mar/1997/dmy2jd/26/Mar/1998/dmy2jd/26/Mar/1999/dmy2jd/26/Mar/2000/dmy2jd/26/Mar/2001/dmy2jd/26/Mar/2002/dmy2jd/26/Mar/2003/dmy2jd/26/Mar/2004/dmy2jd/26/Mar/2005/dmy2jd/26/Mar/2006/dmy2jd/26/Mar/2007/dmy2jd/26/Mar/2008/dmy2jd/26/Mar/2009/dmy2jd/26/Mar/2010/dmy2jd/26/Mar/2011/dmy2jd/26/Mar/2012/dmy2jd/26/Mar/2013/dmy2jd/26/Mar/2014/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv
	wget -O t2m_1996-2014_Mar1_nostd_ensmean_week5_predictor.tsv http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.temp2m_multis2s_0301_all_rawano_weekly.1996-2014.nc/.temp2m/lon/${elo}/${wlo}/RANGE/lon/%28X%29/renameGRID/lat/${sla}/${nla}/RANGE/lat/%28Y%29/renameGRID//units/%28sigma%29/def/time/%282%20Apr%201996%29/VALUE/time/-12/shiftGRID/time/removeGRID/%5Bens%5Daverage/year/%281%29/%2819%29/RANGE/year//T/renameGRID/T/name/npts/NewIntegerGRID/replaceGRID/T/name//julian_day/ordered%5B2/Apr/1996/dmy2jd/2/Apr/1997/dmy2jd/2/Apr/1998/dmy2jd/2/Apr/1999/dmy2jd/2/Apr/2000/dmy2jd/2/Apr/2001/dmy2jd/2/Apr/2002/dmy2jd/2/Apr/2003/dmy2jd/2/Apr/2004/dmy2jd/2/Apr/2005/dmy2jd/2/Apr/2006/dmy2jd/2/Apr/2007/dmy2jd/2/Apr/2008/dmy2jd/2/Apr/2009/dmy2jd/2/Apr/2010/dmy2jd/2/Apr/2011/dmy2jd/2/Apr/2012/dmy2jd/2/Apr/2013/dmy2jd/2/Apr/2014/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv
	wget -O t2m_1996-2014_Mar1_nostd_ensmean_week6_predictor.tsv http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.temp2m_multis2s_0301_all_rawano_weekly.1996-2014.nc/.temp2m/lon/${elo}/${wlo}/RANGE/lon/%28X%29/renameGRID/lat/${sla}/${nla}/RANGE/lat/%28Y%29/renameGRID//units/%28sigma%29/def/time/%289%20Apr%201996%29/VALUE/time/-12/shiftGRID/time/removeGRID/%5Bens%5Daverage/year/%281%29/%2819%29/RANGE/year//T/renameGRID/T/name/npts/NewIntegerGRID/replaceGRID/T/name//julian_day/ordered%5B9/Apr/1996/dmy2jd/9/Apr/1997/dmy2jd/9/Apr/1998/dmy2jd/9/Apr/1999/dmy2jd/9/Apr/2000/dmy2jd/9/Apr/2001/dmy2jd/9/Apr/2002/dmy2jd/9/Apr/2003/dmy2jd/9/Apr/2004/dmy2jd/9/Apr/2005/dmy2jd/9/Apr/2006/dmy2jd/9/Apr/2007/dmy2jd/9/Apr/2008/dmy2jd/9/Apr/2009/dmy2jd/9/Apr/2010/dmy2jd/9/Apr/2011/dmy2jd/9/Apr/2012/dmy2jd/9/Apr/2013/dmy2jd/9/Apr/2014/dmy2jd/%5DNewGRID/replaceGRID/T//pointwidth/7/def/pop/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv
	cd ..
fi


#Start loop
for we in "${weeks[@]}"
do
#Create CPT script
cd scripts
echo ---------------------------------------------------
echo Producing CPT scripts for Week $we ...

rm -Rf ../input/predictand_Week${we}.tsv
rm -Rf ../input/predictor_Week${we}.tsv
ln -s ../input/t2m_1996-2014_Mar1_week${we}_predictand.tsv ../input/predictand_Week${we}.tsv

#First the standardized anomalies case
cat  <<< '#!/bin/bash 
'${cptdir}'CPT.x <<- END
614 # Opens GCM validation
1 # Opens X input file
../input/predictor_Week'${we}'.tsv
'${nla}' # Nothernmost latitude
'${sla}' # Southernmost latitude
'${wlo}' # Westernmost longitude
'${elo}' # Easternmost longitude

2 # Opens Y input file
../input/predictand_Week'${we}'.tsv
'${nla}' # Nothernmost latitude
'${sla}' # Southernmost latitude
'${wlo}' # Westernmost longitude
'${elo}' # Easternmost longitude

4 # X training period
1996 # First year of X training period
5 # Y training period
1996 # First year of Y training period

531 # Goodness index
3 # Kendalls tau

7 # Option: Lenght of training period
19 # Lenght of training period 
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
../output/t2m_Kendallstau_noMOS_std_Week'${we}'.txt

#######BUILD MODEL  !!!!!
311 # Cross-validation

#131 # select output format
#3 # GrADS format
# Save forecast results
#111 # output results
# save as GrADS

413 # cross-validated skill maps
2 # save Spearmans Correlation
../output/t2m_Spearman_noMOS_std_Week'${we}'.txt

413 # cross-validated skill maps
3 # save 2AFC score
../output/t2m_2AFC_noMOS_std_Week'${we}'.txt

413 # cross-validated skill maps
10 # save 2AFC score
../output/t2m_RocBelow_noMOS_std_Week'${we}'.txt

413 # cross-validated skill maps
11 # save 2AFC score
../output/t2m_RocAbove_noMOS_std_Week'${we}'.txt

#0 # Stop saving  (not needed in newest version of CPT)

0 # Exit
END
' > noMOSSkill_std_t2m_Week${we}.cpt 


#Now the no standardization case
cat  <<< '#!/bin/bash 
'${cptdir}'CPT.x <<- END
614 # Opens GCM validation
1 # Opens X input file
../input/predictor_Week'${we}'.tsv
'${nla}' # Nothernmost latitude
'${sla}' # Southernmost latitude
'${wlo}' # Westernmost longitude
'${elo}' # Easternmost longitude

2 # Opens Y input file
../input/predictand_Week'${we}'.tsv
'${nla}' # Nothernmost latitude
'${sla}' # Southernmost latitude
'${wlo}' # Westernmost longitude
'${elo}' # Easternmost longitude

4 # X training period
1996 # First year of X training period
5 # Y training period
1996 # First year of Y training period

531 # Goodness index
3 # Kendalls tau

7 # Option: Lenght of training period
19 # Lenght of training period 
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
../output/t2m_Kendallstau_noMOS_nostd_Week'${we}'.txt

#######BUILD MODEL  !!!!!
311 # Cross-validation

#131 # select output format
#3 # GrADS format
# Save forecast results
#111 # output results
# save as GrADS

413 # cross-validated skill maps
2 # save Spearmans Correlation
../output/t2m_Spearman_noMOS_nostd_Week'${we}'.txt

413 # cross-validated skill maps
3 # save 2AFC score
../output/t2m_2AFC_noMOS_nostd_Week'${we}'.txt

413 # cross-validated skill maps
10 # save 2AFC score
../output/t2m_RocBelow_noMOS_nostd_Week'${we}'.txt

413 # cross-validated skill maps
11 # save 2AFC score
../output/t2m_RocAbove_noMOS_nostd_Week'${we}'.txt

#0 # Stop saving  (not needed in newest version of CPT)

0 # Exit
END
' > noMOSSkill_nostd_t2m_Week${we}.cpt 


#Execute CPT and produce skill maps
echo ---------------------------------------------------
echo Executing CPT and producing skill maps for Week $we ...
chmod 755 noMOSSkill_std_t2m_Week${we}.cpt 
chmod 755 noMOSSkill_nostd_t2m_Week${we}.cpt 

#Run for standardized anomalies
ln -s ../input/t2m_1996-2014_Mar1_std_ensmean_week${we}_predictor.tsv ../input/predictor_Week${we}.tsv
./noMOSSkill_std_t2m_Week${we}.cpt 

#Run for no-standardized anomalies
rm -Rf ../input/predictor_Week${we}.tsv
ln -s ../input/t2m_1996-2014_Mar1_nostd_ensmean_week${we}_predictor.tsv ../input/predictor_Week${we}.tsv
./noMOSSkill_nostd_t2m_Week${we}.cpt 

rm -Rf ../input/predictand_Week${we}.tsv
rm -Rf ../input/predictor_Week${we}.tsv
cd ..

echo Done with Week $we !! Check output folder for results.
echo
echo
done

