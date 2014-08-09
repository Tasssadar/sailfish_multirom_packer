BASE_DIR="$1"
SYSTEMD_SYSTEM_MOUNT_LINK="${BASE_DIR}/sailfishos/etc/systemd/system/local-fs.target.wants/system.mount"
SYSTEMD_SYSTEM_MOUNT="${BASE_DIR}/sailfishos/lib/systemd/system/system.mount"
SCRIPT_DIR="/tmp/script"
ROOTFS_SAILFISH="${BASE_DIR}/sailfishos"
ANDROID_SYSTEM="${BASE_DIR}/system"

fail() {
    echo $1 1>&2
    exit 1
}

# disable mounting of real /system partition
( rm "$SYSTEMD_SYSTEM_MOUNT_LINK" && rm "$SYSTEMD_SYSTEM_MOUNT" ) || fail "Failed to remove $SYSTEMD_SYSTEM_MOUNT_LINK"

# move android's /system inside the rootfs
mv "${ANDROID_SYSTEM}" "${ROOTFS_SAILFISH}/" || fail "Failed to move android's /system into rootfs"
