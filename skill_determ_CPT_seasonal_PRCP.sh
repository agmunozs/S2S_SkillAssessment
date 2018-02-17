#! /bin/bash
#Script to assess skill of seasonal PRCP deterministic hindcasts and observations 
#Author: Á.G. Muñoz (agmunoz@iri.columbia.edu)
#
#Output:
# + Several skill maps for assessment of deterministic forecast, in the output folder.
# + CPT scripts used to assess skill, in the scripts folder.
# + Downloaded input files, in the input folder.
#Notes:
#1. Old data in the input folder is deleted at the beginning of the process!
#2. Right now there's no spatial subsetting (it uses the domain prescribed by the DL). This could be easily fixed.
#4. Rainfall observations are CPC Unified (Chen et al 2008).

####START OF USER-MODIFIABLE SECTION######

iystart=1982 # first initial year
iyend=2007   # last initial year

ytstart=10   # first length of training window
ytend=35     # last length of training window
#Spatial domain for predictor
nla1=90 # Nothernmost latitude
sla1=-90 # Southernmost latitude
wlo1=-180 # Westernmost longitude
elo1=180 # Easternmost longitude
#Spatial domain for predictand
nla2=90 # Nothernmost latitude
sla2=-90 # Southernmost latitude
wlo2=-180 # Westernmost longitude
elo2=180 # Easternmost longitude
#PATH to CPT root directory
cptdir='/Users/agmunoz/Documents/Angel/CPT/CPT/15.7.3/'

####END OF USER-MODIFIABLE SECTION######
####DO NOT CHANGE ANYTHING BELOW THIS LINE####

clear
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Script to assess skill of seasonal PRCP deterministic hindcasts and observations
echo Project: Tier2 FLOR
echo Author: Á.G. Muñoz - agmunoz@iri.columbia.edu
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo
echo
#Prepare folders
echo Creating working folders, if not already there...
mkdir -p input
mkdir -p output
mkdir -p scripts
rm -Rf scripts/*

cd input
#Set up some parameters
export CPT_BIN_DIR=${cptdir}

#Start loop
viscount=-1
for y in $(seq ${iystart} ${iyend})            #ranging for all initial years
do
let viscount++
ytend2=$(($ytend-$viscount))
for i in $(seq ${ytstart} ${ytend2})       #ranging for all sensible training lengths 
do
	echo Length of training window $i of init year $y


#Create CPT script
cd ../scripts
echo ---------------------------------------------------
echo Producing CPT scripts for training length $i of year $y...

  
cat  <<< '#!/bin/bash 
'${cptdir}'CPT.x <<- END
614 # Opens GCM validation
1 # Opens X input file
../input/PRCP_FLOR_1tier_JJA_1982-2017.tsv
'${nla1}' # Nothernmost latitude
'${sla1}' # Southernmost latitude
'${wlo1}' # Westernmost longitude
'${elo1}' # Easternmost longitude

2 # Opens Y input file
../input/PRCP_CPCUnif_JJA_1982-2017.tsv
'${nla2}' # Nothernmost latitude
'${sla2}' # Southernmost latitude
'${wlo2}' # Westernmost longitude
'${elo2}' # Easternmost longitude

4 # X training period
'$y' # First year of X training period
5 # Y training period
'$y' # First year of Y training period

531 # Goodness index
3 # Kendalls tau

7 # Option: Lenght of training period
'${i}' # Lenght of training period 
8 # Option: Length of cross-validation window
5 # Enter length

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
../output/PRCP_Kendallstau_1TIER_y'${y}'_train'${i}'.txt

#######BUILD MODEL  !!!!!
311 # Cross-validation

#131 # select output format
#3 # GrADS format
# Save forecast results
#111 # output results
# save as GrADS

#413 # cross-validated skill maps
#2 # save Spearmans Correlation
#../output/PRCP_Spearman_1TIER_y'${y}'_train'${i}'.txt

#413 # cross-validated skill maps
#3 # save 2AFC score
#../output/PRCP_2AFC_1TIER_y'${y}'_train'${i}'.txt

#413 # cross-validated skill maps
#10 # save 2AFC score
#../output/PRCP_RocBelow_1TIER_y'${y}'_train'${i}'.txt

#413 # cross-validated skill maps
#11 # save 2AFC score
#../output/PRCP_RocAbove_1TIER_y'${y}'_train'${i}'.txt

#0 # Stop saving  (not needed in newest version of CPT)

0 # Exit
END
' > 1TIERSkill_PRCP_y${y}_train${i}.cpt 

#Execute CPT and produce skill maps
echo ---------------------------------------------------
echo Executing CPT and producing skill maps for training length $i of year $y...
chmod 755 1TIERSkill_PRCP_y${y}_train${i}.cpt  
./1TIERSkill_PRCP_y${y}_train${i}.cpt > cpt_y${y}_train${i}.log 

cd ../input

echo Done with training length $i of year $y!! Check output folder for results.
echo
echo
done
done