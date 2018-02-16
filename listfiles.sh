#!/bin/sh
#Header: list_files.sh 2018/02/14 15:00 atelford ship $
#written by Alan Telford Wood Plc 14th Feb 2018
# Script to produce manifest for java files
# for OMCS Cemli Patch version 18.1 onwards
#
# parameters
# 1 directory to start from
# 2 path to Java top to insert
# 3 description to tag into file

# OBJECTIVE: this will create a file name manifest.csv
# which has the following columns:
# col number/description/default or comment
# 1  File Name
# 2  Product xbol
# 3  Description $3
# 4  Object Type  oa_java_type oa_java_class etc
# 5  Language US
# 5  Sequence 0
# 7  Parameters are dependant on the file typek
# 8  Parameter 1 For JAVA DEPLOYMENT_PATH
# 9  Value 1  For JAVA Path from JAVA TOP
# 10 Parameter 2
# 11 Value 2
# 12 Parameter 3
# 13 Value 3
# 14 Parameter 4
# 15 Value 4
# 16 Parameter 5
# 17 Value 5
# 18 Parameter 6
# 19 Value 6
# Parameter 7
# Value 6

#constant variables
JAVA_PATH=$(echo "${PWD//$JAVA_TOP/}")
# remove first char of JAVA_PATH
JAVA_PATH=${JAVA_PATH#?}

# APPLICATION CODE DEFAULT
APPL_CODE=xbol
# Delimiter character
DELIM=,
# Language Code
LANG=US
DPATH=DEPLOYMENT_PATH
LOBTYPE=LOB_TYPE
OBJECT_TYPE=""
PARAMETER_LIST=""
TEMPDIR=oaf_file_zip

if [ ! -d $TEMPDIR ]
then
 mkdir $TEMPDIR
fi 

rm ./$TEMPDIR/*


#function to derive the objct type
get_obj_type() {
 EXTENSION=${FILENAME#*.}     # Right of .
 PARAMETER_LIST=${DELIM}${DPATH}${DELIM}${FILEPATH}

 OBJECT_TYPE=""

 case $EXTENSION in
  class)
  OBJECT_TYPE=oa_java_class
  ;;
  xcfg)
  OBJECT_TYPE=oa_java_type
  ;;
  java)
  OBJECT_TYPE=oa_java_type
  ;;
  xml)
    case $FILENAME in
    *RN.xml)
    ;;
    server.xml)
    OBJECT_TYPE=gen_cp
    ;;
    *PG.xml)
    OBJECT_TYPE=oaf_page
    ;;
    *VO.xml)
    OBJECT_TYPE=oa_java_type
    ;;
    *) 
    OBJECT_TYPE=****xml_object
    ;;
    esac
 esac
}


#Parameters
FILETAG=$3
STARTDIR=$1




#loop through files in the sub directory

for FILE in $(find ./"$STARTDIR" -print) 
do
 if [ ! -d "$FILE"  ]
 then
  FILENAME=$(basename $FILE)
  FILEPATH=$(dirname $FILE)  
  #trim the first char off the path
  FILEPATH=${FILEPATH#?}
  # tag onto java path 
  FILEPATH=${JAVA_PATH}${FILEPATH}
  get_obj_type
  cp $FILE $TEMPDIR

  echo  "${FILENAME}${DELIM}${APPL_CODE}${DELIM}${FILETAG}${DELIM}${OBJECT_TYPE}${DELIM}${LANG}${DELIM}0${PARAMETER_LIST}" >>$TEMPDIR/manifest.csv
 fi

done
ZIPFILE=oaf_file_${FILETAG}.zip
cat $TEMPDIR/manifest.csv 
cd $TEMPDIR
zip $ZIPFILE *
cp $ZIPFILE $INTERFACE_HOME/outgoing 
cd ..
echo "Copied zip file ${ZIPFILE}.zip to outgoing"



