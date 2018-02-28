#
# Build a static binary for the host OS/ARCH
#

. ./scripts/build/.variables.ps1

echo "Building $TARGET"
go build -o "${TARGET}" --ldflags "${LDFLAGS}" "${SOURCE}"

cp "${TARGET}" build/docker.exe
