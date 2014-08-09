#!/bin/sh
BOOT_FILE="hybris-boot.img"

SAILFISH_ZIP=""
DEST_FILE=""
DEVICE="hammerhead"

fail() {
    echo $1 1>&2
    exit 1
}

cleanup_zip_root() {
    rm -rf zip_root/rom
    rm -f zip_root/manifest.txt
    rm -rf zip_root/root_dir
    rm -f zip_root/post_install/$BOOT_FILE
    mkdir zip_root/root_dir
    mkdir zip_root/rom
}

link_device_files() {
    ([ -f "devices/${1}/manifest.txt" ]) || fail "Couldn't find devices/${1}/manifest.txt"
    ([ -f "devices/${1}/rom_info.txt" ]) || fail "Couldn't find devices/${1}/rom_info.txt"
    ([ -f "devices/${1}/system.tar.gz" ]) || fail "Couldn't find devices/${1}/system.tar.gz"
    ln -s "../devices/${1}/manifest.txt" zip_root/ || fail "Failed to link manifest.txt for device $1"
    ln -s "../../devices/${1}/rom_info.txt" zip_root/root_dir/ || fail "Failed to link rom_info.txt for device $1"
    ln -s "../../devices/${1}/system.tar.gz" zip_root/rom/ || fail "Failed to link rom_info.txt for device $1"
}

find_rootfs() {
    res="$(unzip -Z -1 "$1" | grep -m 1 'sailfishos-.*\.tar\..*')"
    echo "$res"
}

extract_rootfs() {
    rootfs="$(find_rootfs "$1")"
    ([ -n "$rootfs" ]) || fail "Failed to find rootfs file in the installation ZIP file."
    echo "Repacking rootfs $rootfs..."
    unzip -p "$1" "$rootfs" | bzip2 -d | gzip > zip_root/rom/sailfishos.tar.gz || fail "Failed to repack rootfs!"
}

extract_bootimg() {
    echo "Extracting bootimg..."
    unzip -p "$1" "$BOOT_FILE" > "zip_root/post_install/$BOOT_FILE" || fail "Failed to extract boot img!"
}

build_mrom_file() {
    dest="$1"
    if [ -z "$dest" ]; then
        dest="../sailfishos-${DEVICE}-$(date +%Y%m%d%H%M).mrom"
    fi
    ( cd zip_root && zip -r0 "$dest" * ) || fail "Failed to build mrom file!"
    echo "Done, file $dest is ready!"
}

for arg in "$@"; do
    case $arg in
        --dest=*)
            DEST_FILE="${arg#--dest=}"
            ;;
        --dev=*)
            DEVICE="${arg#--dev=}"
            ;;
        --help|-h)
            echo "Usage: $0 [ARGS] PATH_TO_SAILFISH_ZIP"
            echo "       --dev=<device> -- device name. Default: hammerhead"
            echo "       --dest=<path>  -- path to destination mrom file. sailfishos-<DEVICE>-YYYYMMDDHHMM.mrom by default."
            exit 0
            ;;
        *)
            SAILFISH_ZIP="$arg"
            ;;
    esac
done

([ -d "zip_root" ]) || fail "Failed to find ./zip_root directory!"
([ -f "$SAILFISH_ZIP" ]) || fail "Invalid path to Sailfish ZIP: $SAILFISH_ZIP"

cleanup_zip_root
link_device_files "$DEVICE"
extract_rootfs "$SAILFISH_ZIP"
extract_bootimg "$SAILFISH_ZIP"
build_mrom_file "$DEST_FILE"
