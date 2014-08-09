BASE_DIR="$1"
ROOTFS_SAILFISH="${BASE_DIR}/sailfishos"
ROOTFS_SAILFISH_DEST="${BASE_DIR}/data/.stowaways/"

fail() {
    echo $1 1>&2
    exit 1
}

mkdir -p "$ROOTFS_SAILFISH_DEST"
mv "$ROOTFS_SAILFISH" "$ROOTFS_SAILFISH_DEST" || fail "Failed to move sailfish rootfs!"
