cd $1/xbol
if [ -d bin ]
then
 mv bin binary
fi
cp -r * /c/"gateway_stash/xbol"
