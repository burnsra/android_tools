export TOOLS_SOURCE=$WORKSPACE/projects/android_tools

if [ ! -d $TOOLS_SOURCE ]
then
	echo "TOOLS_SOURCE doesn't exist.  Please verify the path to the project."
	return
fi

export INPUT_FILE="$1"
export OUTPUT_FILE="$2"

echo "Signing zip file..."
java -jar $TOOLS_SOURCE/bin/signapk.jar $TOOLS_SOURCE/security/testkey.x509.pem $TOOLS_SOURCE/security/testkey.pk8 $1 $2
echo "Signed file is ready ($2)"