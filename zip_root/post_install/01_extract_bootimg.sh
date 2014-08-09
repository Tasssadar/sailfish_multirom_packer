ROOT_DIR="$2"
BOOTIMG="/tmp/script/hybris-boot.img"
BBOOTIMG_BIN="/tmp/script/bbootimg"
TMPDIR="/tmp/script/"
PATCHED_INIT="/tmp/script/sailfishos-init"

fail() {
    echo $1 1>&2
    exit 1
}

extract_initrd() {
    mkdir "$2"
    cd "$2" || fail "Failed to extract initrd"
    zcat "$1" | cpio -i || fail "Failed to extract initrd"
}

pack_initrd() {
    ( find . ! -name . | sort | cpio --quiet -o -H newc ) | gzip > "$1" || fail "Failed to pack initrd to $1"
}

cd "$TMPDIR"
$BBOOTIMG_BIN -x $BOOTIMG || fail "Failed to extract ${BOOTIMG}!"
cp zImage "${ROOT_DIR}/zImage" || fail "Failed to copy zImage to root dir"

extract_initrd "${TMPDIR}/initrd.img" "initrd"

# copy patched init
cp "$PATCHED_INIT" init
chmod 755 init

pack_initrd "${ROOT_DIR}/initrd.img"
