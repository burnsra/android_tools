function g_prop {
    echo "Creating g.prop file..."
    echo "# begin addon properties" > ./system/etc/g.prop
    echo "ro.addon.type=gapps" >> ./system/etc/g.prop
    echo "ro.addon.platform=$GAPPS_BRANCH" >> ./system/etc/g.prop
    echo "ro.addon.version=gapps-$GAPPS_BRANCH-$GAPPS_DATE" >> ./system/etc/g.prop
    echo "# end addon properties" >> ./system/etc/g.prop
}

export GAPPS_SOURCE=$WORKSPACE/projects/proprietary_vendor_google
export TOOLS_SOURCE=$WORKSPACE/projects/android_tools

if [ ! -d $GAPPS_SOURCE ]
then
	echo "GAPPS_SOURCE doesn't exist.  Please verify the path to the project."
	return
fi

if [ ! -d $TOOLS_SOURCE ]
then
	echo "TOOLS_SOURCE doesn't exist.  Please verify the path to the project."
	return
fi

cd $GAPPS_SOURCE
export GAPPS_BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
export GAPPS_DATE=`date -u +%Y%m%d`
export GAPPS_FILE="gapps-$GAPPS_BRANCH-$GAPPS_DATE.zip"
export GAPPS_FILE_SIGNED="gapps-$GAPPS_BRANCH-$GAPPS_DATE-signed.zip"

if [ -f $HOME/Android/$GAPPS_FILE ]
then
	echo "Removing previous file..."
	rm $HOME/Android/$GAPPS_FILE
fi

cd $GAPPS_SOURCE

g_prop

echo "Creating zip file..."
zip -q -r $HOME/Android/$GAPPS_FILE . -x "./.git/*" "./.project" "*.DS_Store*" "./.gitignore" "./README.md"
echo "Signing zip file..."
java -jar $TOOLS_SOURCE/bin/signapk.jar $TOOLS_SOURCE/security/testkey.x509.pem $TOOLS_SOURCE/security/testkey.pk8 $HOME/Android/$GAPPS_FILE $HOME/Android/$GAPPS_FILE_SIGNED
echo "Generating zip file MD5..."
echo `md5 $HOME/Android/$GAPPS_FILE_SIGNED` > $HOME/Android/$GAPPS_FILE_SIGNED.md5sum
echo "Extracting zip file..."
unzip -o -q $HOME/Android/$GAPPS_FILE_SIGNED -d $GAPPS_SOURCE
echo "Cleaning up..."
rm $HOME/Android/$GAPPS_FILE
cd $HOME
echo "Google applications file is ready ($GAPPS_FILE_SIGNED)"