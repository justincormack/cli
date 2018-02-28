#
# Compile the Windows resources into the sources
#

SCRIPTDIR="$PSScriptRoot"
# shellcheck source=/go/src/github.com/docker/cli/scripts/build/.variables
. $SCRIPTDIR/../build/.variables

RESOURCES=$SCRIPTDIR/../winresources

TEMPDIR=C:\Temp

WINDRES=windres

# Generate a Windows file version of the form major,minor,patch,build (with any part optional)
VERSION_QUAD="$VERSION" -Replace "^([0-9.]*).*$",'$1' -Replace "\.",","

# Pass version and commit information into the resource compiler
if ( "$VERSION" -eq $null )       {defs+=" -D DOCKER_VERSION=`"$VERSION`""}
if ( "$VERSION_QUAD" -eq $null )  {defs+=" -D DOCKER_VERSION_QUAD=$VERSION_QUAD"}
if ( "$GITCOMMIT" -eq $null)      {defs+=" -D DOCKER_COMMIT=`"$GITCOMMIT`""}

function makeres {
	"$WINDRES" `
		-i "$RESOURCES\$args[1]" `
		-o "$args[3]" `
		-F "$args[2]" `
		--use-temp-file `
		-I "$TEMPDIR" `
		${defs}
}

makeres docker.rc pe-x86-64 rsrc_amd64.syso
makeres docker.rc pe-i386   rsrc_386.syso
