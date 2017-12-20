cd $1/xbol
ls -R
if [ -d bin ]
then
 mv bin binary
fi
cp -r * /c/"R12 Code Mainline"
