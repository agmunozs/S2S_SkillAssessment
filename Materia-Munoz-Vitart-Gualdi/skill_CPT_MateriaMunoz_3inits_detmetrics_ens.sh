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
down=1  #1 for download all data, 0 for not downloading data.
#PATH to CPT root directory
cptdir='/Users/agmunoz/Documents/Angel/CPT/CPT/15.7.8/'
#Weeks to process (a subset of 1-6)
#declare -a weeks=('1')
declare -a weeks=('1' '2' '3' '4' '5' '6')
nla=90 # Nothernmost latitude
sla=-90 # Southernmost latitude
wlo=360 # Westernmost longitude
elo=0 # Easternmost longitude

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
	wget -O t2m_1996-2014_3inits_week1_predictand.tsv 'http://gfs2geo2.ldeo.columbia.edu/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(2-8%20Mar%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/1919/ensotime/%3Agrid/use_as_grid/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(16-22%20Mar%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1920/ensotime/12.0/16/Jan/1938/ensotime/%3Agrid/use_as_grid/appendstream/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(2-8%20Apr%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1939/ensotime/12.0/16/Jan/1957/ensotime/%3Agrid/use_as_grid/appendstream/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
	wget -O t2m_1996-2014_3inits_week2_predictand.tsv 'http://gfs2geo2.ldeo.columbia.edu/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(9-15%20Mar%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/1919/ensotime/%3Agrid/use_as_grid/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(23-29%20Mar%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1920/ensotime/12.0/16/Jan/1938/ensotime/%3Agrid/use_as_grid/appendstream/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(9-15%20Apr%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1939/ensotime/12.0/16/Jan/1957/ensotime/%3Agrid/use_as_grid/appendstream/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
	wget -O t2m_1996-2014_3inits_week3_predictand.tsv 'http://gfs2geo2.ldeo.columbia.edu/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(16-22%20Mar%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/1919/ensotime/%3Agrid/use_as_grid/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/time//T/renameGRID/T/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/0.125/shiftGRID/T/(1996-2014)/VALUES/T/1/index/T/(30%20Mar)/VALUES/.T/.gridvalues/%7B6/%7Bdup/1/add/dup/last/gt/%7Bpop%7Dif%7Drepeat%7Dforall/VALUES/longitude/(X)/renameGRID/latitude/(Y)/renameGRID//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1920/ensotime/12.0/16/Jan/1938/ensotime/%3Agrid/use_as_grid/appendstream/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(16-22%20Apr%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1939/ensotime/12.0/16/Jan/1957/ensotime/%3Agrid/use_as_grid/appendstream/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
	wget -O t2m_1996-2014_3inits_week4_predictand.tsv 'http://gfs2geo2.ldeo.columbia.edu/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(23-29%20Mar%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/1919/ensotime/%3Agrid/use_as_grid/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(6-12%20Apr%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1920/ensotime/12.0/16/Jan/1938/ensotime/%3Agrid/use_as_grid/appendstream/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(23-29%20Apr%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1939/ensotime/12.0/16/Jan/1957/ensotime/%3Agrid/use_as_grid/appendstream/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
	wget -O t2m_1996-2014_3inits_week5_predictand.tsv 'http://gfs2geo2.ldeo.columbia.edu/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/time//T/renameGRID/T/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/0.125/shiftGRID/T/(1996-2014)/VALUES/T/1/index/T/(30%20Mar)/VALUES/.T/.gridvalues/%7B6/%7Bdup/1/add/dup/last/gt/%7Bpop%7Dif%7Drepeat%7Dforall/VALUES/longitude/(X)/renameGRID/latitude/(Y)/renameGRID//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/1919/ensotime/%3Agrid/use_as_grid/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(13-19%20Apr%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1920/ensotime/12.0/16/Jan/1938/ensotime/%3Agrid/use_as_grid/appendstream/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/time//T/renameGRID/T/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/0.125/shiftGRID/T/(1996-2014)/VALUES/T/1/index/T/(30%20Apr)/VALUES/.T/.gridvalues/%7B6/%7Bdup/1/add/dup/last/gt/%7Bpop%7Dif%7Drepeat%7Dforall/VALUES/longitude/(X)/renameGRID/latitude/(Y)/renameGRID//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1939/ensotime/12.0/16/Jan/1957/ensotime/%3Agrid/use_as_grid/appendstream/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
	wget -O t2m_1996-2014_3inits_week6_predictand.tsv 'http://gfs2geo2.ldeo.columbia.edu/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(6-12%20Apr%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/1919/ensotime/%3Agrid/use_as_grid/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(20-26%20Apr%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1920/ensotime/12.0/16/Jan/1938/ensotime/%3Agrid/use_as_grid/appendstream/home/.agmunoz/.ERAi/.6hr/.sfc/.ERAi_6hrly_t2m.nc/.t2m/longitude/(X)/renameGRID/latitude/(Y)/renameGRID/time/(T)/renameGRID/%5BT%5D/24/boxAverage/T/(days%20since%201900-01-01)/streamgridunitconvert/T/.125/shiftGRID/T/(6-12%20May%201996-2014)/RANGE//Celsius/unitconvert/T/name/npts/NewIntegerGRID/replaceGRID/T/7/boxAverage/dup/%5BT%5Daverage/sub/grid%3A//name/(T)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1939/ensotime/12.0/16/Jan/1957/ensotime/%3Agrid/use_as_grid/appendstream/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
	echo Downloading predictors...
	#Download predictors (deterministic ensemble mean --no standardization): 
	wget -O predictor_Week1.tsv 'http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0301_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0315_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/year/19/shiftGRID/appendstream/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0401_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/year/38/shiftGRID/appendstream/grid%3A//name/(year)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/1957/ensotime/%3Agrid/use_as_grid/-999/setmissing_value/time/(week)/renameGRID/year/(T)/renameGRID/lon/(X)/renameGRID/lat/(Y)/renameGRID/week/1/VALUE/%5Bens%5Daverage/week/removeGRID/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
	wget -O predictor_Week2.tsv 'http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0301_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0315_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/year/19/shiftGRID/appendstream/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0401_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/year/38/shiftGRID/appendstream/grid%3A//name/(year)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/1957/ensotime/%3Agrid/use_as_grid/-999/setmissing_value/time/(week)/renameGRID/year/(T)/renameGRID/lon/(X)/renameGRID/lat/(Y)/renameGRID/week/2/VALUE/%5Bens%5Daverage/week/removeGRID/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
	wget -O predictor_Week3.tsv 'http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0301_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0315_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/year/19/shiftGRID/appendstream/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0401_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/year/38/shiftGRID/appendstream/grid%3A//name/(year)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/1957/ensotime/%3Agrid/use_as_grid/-999/setmissing_value/time/(week)/renameGRID/year/(T)/renameGRID/lon/(X)/renameGRID/lat/(Y)/renameGRID/week/3/VALUE/%5Bens%5Daverage/week/removeGRID/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
	wget -O predictor_Week4.tsv 'http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0301_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0315_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/year/19/shiftGRID/appendstream/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0401_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/year/38/shiftGRID/appendstream/grid%3A//name/(year)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/1957/ensotime/%3Agrid/use_as_grid/-999/setmissing_value/time/(week)/renameGRID/year/(T)/renameGRID/lon/(X)/renameGRID/lat/(Y)/renameGRID/week/4/VALUE/%5Bens%5Daverage/week/removeGRID/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
	wget -O predictor_Week5.tsv 'http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0301_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0315_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/year/19/shiftGRID/appendstream/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0401_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/year/38/shiftGRID/appendstream/grid%3A//name/(year)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/1957/ensotime/%3Agrid/use_as_grid/-999/setmissing_value/time/(week)/renameGRID/year/(T)/renameGRID/lon/(X)/renameGRID/lat/(Y)/renameGRID/week/5/VALUE/%5Bens%5Daverage/week/removeGRID/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
	wget -O predictor_Week6.tsv 'http://iridl.ldeo.columbia.edu/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0301_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0315_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/year/19/shiftGRID/appendstream/home/.agmunoz/.SMateria/.data/.temp2m_multis2s_0401_all_rawano_weekly.1996-2014.nc/.temp2m//time/6/NewIntegerGRID/use_as_grid/year/38/shiftGRID/appendstream/grid%3A//name/(year)/def//units/(months%20since%201960-01-01)/def//standard_name/(time)/def//pointwidth/1/def/16/Jan/1901/ensotime/12.0/16/Jan/1957/ensotime/%3Agrid/use_as_grid/-999/setmissing_value/time/(week)/renameGRID/year/(T)/renameGRID/lon/(X)/renameGRID/lat/(Y)/renameGRID/week/6/VALUE/%5Bens%5Daverage/week/removeGRID/-999/setmissing_value/%5BX/Y%5D%5BT%5Dcptv10.tsv'
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
ln -s ../input/t2m_1996-2014_3inits_week${we}_predictand.tsv ../input/predictand_Week${we}.tsv


#CPT script
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
1901 # First year of X training period
5 # Y training period
1901 # First year of Y training period

531 # Goodness index
3 # Kendalls tau

7 # Option: Lenght of training period
57 # Lenght of training period 
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

131 # select output format
3 # GrADS format
# Save forecast results
#111 # output results
# save as GrADS

413 # cross-validated skill maps
2 # save Spearmans Correlation
../output/t2m_Spearman_noMOS_nostd_Week'${we}'

413 # cross-validated skill maps
3 # save 2AFC score
../output/t2m_2AFC_noMOS_nostd_Week'${we}'

413 # cross-validated skill maps
10 # save 2AFC score
../output/t2m_RocBelow_noMOS_nostd_Week'${we}'

413 # cross-validated skill maps
11 # save 2AFC score
../output/t2m_RocAbove_noMOS_nostd_Week'${we}'

#0 # Stop saving  (not needed in newest version of CPT)

0 # Exit
END
' > noMOSSkill_nostd_t2m_Week${we}.cpt 


#Execute CPT and produce skill maps
echo ---------------------------------------------------
echo Executing CPT and producing skill maps for Week $we ...
chmod 755 noMOSSkill_nostd_t2m_Week${we}.cpt 

#Run
#rm -Rf ../input/predictor_Week${we}.tsv
./noMOSSkill_nostd_t2m_Week${we}.cpt 

rm -Rf ../input/predictand_Week${we}.tsv
#rm -Rf ../input/predictor_Week${we}.tsv
cd ..

echo Done with Week $we !! Check output folder for results.
echo
echo
done

