##########################################
#
#  Script add_java_headers.sh
#
#  Alan Telford
#  Script to put OMCS Headers on Java XML
#  Files for Oracle Cemli Patcher
#  And copy from the JDeveloper Home
##########################################

CURRENT_DATE=$(date +"%Y/%m/%d %T")
shopt -o nounset

make_directory() {

echo "make_directory called with $1"

if [ ! -d "$1" ]
then
  mkdir  -p "$1"
  if [ $? -eq 0 ]
  then
     echo "Created $1"
  else
    echo "encountered and error creating $1"
    return 103
  fi
fi
return 0 

}

#writes into the file the header and cemli file type
#
# parameters
# 1.file name (with path)
# 2.cemli file type
write_header() {

cd $1
for FILE in $( find  -print )
do

    FILE=$(cut -c 2-999  <<< $FILE)

    echo looking for ${GIT_JAVA_TOP}${FILE}
	
	EXTENSION=${FILE#*.}      # Right of .

	
	if [  -d "$1/$FILE" ] 
	then
	    make_directory "${GIT_JAVA_TOP}${FILE}"
    else # its not a directory
	  echo "File Extension is $EXTENSION"
	  case $EXTENSION in
      class)
		  echo "copied class file $FILE"
		  cp "$1/${FILE}"  "${GIT_JAVA_TOP}${FILE}"
		  ;;
	  esac
		
	fi

done
}




#section to set up
#home where the GIT resides
GIT_TOP=/c/"R12 Code Mainline"
GIT_JAVA_TOP="${GIT_TOP}/java"

#APPLICATION will be used to create the files under GIT_TOP
APPLICATION=imperium
#JAVA_TOP is used for the target location for cemli patcher
JAVA_TOP=/$JAVA_TOP

#JDEV_TOP is the for my classes in JDeveloper. Code will be copied from
#here into the GIT_JAVA_TOP Area
JDEV_TOP=/C/Oracle/JDEV/jdevhome/jdev/myclasses/xbol/oracle/apps/xbol

#CEMLI TYPES to be used in the zip file creator
BC4J_CEMLI_TYPE=oa_java_type
OAF_PAGE_CEMLI_TYPE=oaf_page


# move to the relevant directory
write_header "$JDEV_TOP"
# iterate through all.xml files using find



  # if the file is of type oaf_page  Match RN.xml or PG.xml
  # then it is an OAF_PATGE_CEMLI_TYPE

  # else use a BC4J_CEMLI_TYPE header
