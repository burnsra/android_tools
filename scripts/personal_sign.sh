export PERSONAL_SOURCE=$WORKSPACE/android/workspace/proprietary_vendor_personal
export TOOLS_SOURCE=$WORKSPACE/projects/android_tools

if [ ! -d $PERSONAL_SOURCE ]
then
	echo "PERSONAL_SOURCE doesn't exist.  Please verify the path to the project."
	return
fi

if [ ! -d $TOOLS_SOURCE ]
then
	echo "TOOLS_SOURCE doesn't exist.  Please verify the path to the project."
	return
fi

cd $PERSONAL_SOURCE
export PERSONAL_BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
export PERSONAL_DATE=`date -u +%Y%m%d`
export PERSONAL_FILE="personal-$PERSONAL_BRANCH-$PERSONAL_DATE.zip"
export PERSONAL_FILE_SIGNED="personal-$PERSONAL_BRANCH-$PERSONAL_DATE-signed.zip"

if [ -f $HOME/Android/$PERSONAL_FILE ]
then
	echo "Removing previous file..."
	rm $HOME/Android/$PERSONAL_FILE
fi

cd $PERSONAL_SOURCE

echo "Obtaining 3rd party applications..."
curl -L -o $PERSONAL_SOURCE/system/app/RomManager.apk -O -L http://download.clockworkmod.com/recoveries/RomManager.apk
echo "Creating zip file..."
zip -q -r $HOME/Android/$PERSONAL_FILE . -x "./.git/*" "./.project" "*.DS_Store*" "./.gitignore" "./README.md"
echo "Signing zip file..."
java -jar $TOOLS_SOURCE/bin/signapk.jar $TOOLS_SOURCE/security/testkey.x509.pem $TOOLS_SOURCE/security/testkey.pk8 $HOME/Android/$PERSONAL_FILE $HOME/Android/$PERSONAL_FILE_SIGNED
echo "Generating zip file MD5..."
echo `md5 $HOME/Android/$PERSONAL_FILE_SIGNED` > $HOME/Android/$PERSONAL_FILE_SIGNED.md5sum
echo "Extracting zip file..."
unzip -o -q $HOME/Android/$PERSONAL_FILE_SIGNED -d $PERSONAL_SOURCE
echo "Cleaning up..."
rm $HOME/Android/$PERSONAL_FILE
cd $HOME
echo "Personal applications file is ready ($PERSONAL_FILE_SIGNED)"