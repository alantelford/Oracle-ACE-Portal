##########################################################################
#
# SHELL SCRIPT   Symbolic Links setup for CM Scripts ..
#
# DESCRIPTION   Shell Script to create symbolic links ..
########################################################################### 
########################################################################### 
# $Header: CreateSymLinks.sh 200.4 2015/09/07 09:38 sumandal noship $
echo ''
echo `date`
echo ''
echo ' Create Symbolic Links  '
echo ''
echo ' Removing old links     '
echo ''
rm -rf $XBOL_TOP/bin/GCXEFTALERT
#
echo ' Creating New links     '
echo ''
ln -fs $FND_TOP/bin/fndcpesr GCXEFTALERT
#
echo ''
echo done on `date`
echo ''