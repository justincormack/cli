if ($VERSION -eq $null) {$VERSION="unknown-version"}
# unfortunately if you bind a path into a container, git currently does not work
if ($GITCOMMIT -eq $null) {
	Copy-Item ${pwd} -Destination C:\Temp -Recurse
	$GITCOMMIT=$(git -C C:\Temp rev-parse --short HEAD)
	Remove-Item C:\Temp -Recurse -Force
}
$BUILDTIME=$(Get-Date ([datetime]::UtcNow) -format "yyyy-MM-ddTHH:mm:ss.ffff+00:00")

if ("${PLATFORM}" -ne $null) {
	$PLATFORM_LDFLAGS="-X `"github.com/docker/cli/cli.PlatformName=${PLATFORM}`""
}

$LDFLAGS="`
    -w `
    ${PLATFORM_LDFLAGS} `
    -X `"github.com/docker/cli/cli.GitCommit=${GITCOMMIT}`" `
    -X `"github.com/docker/cli/cli.BuildTime=${BUILDTIME}`" `
    -X `"github.com/docker/cli/cli.Version=${VERSION}`" `
    ${LDFLAGS} `
"

if ($GOOS -eq $null) {$GOOS=$(go env GOHOSTOS)}
if ($GOARCH -eq $null) {$GOARCH=$(go env GOHOSTARCH)}
if ($GOOS -eq "windows") {$SUFFIX=".exe"}
$TARGET="build/docker-${GOOS}-${GOARCH}${SUFFIX}"
$SOURCE="github.com/docker/cli/cmd/docker"
