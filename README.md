Creates an installation .mrom file from SailfishOS install zip and
a system.tar.gz file.

## Preparation
Add `system.tar.gz` to your device's subfolder (e.g. `devices/hammerhead/`).
This is an archive with contents of `/system` partition. The easiest way
to create it is install the desired Android ROM and tar its `/system` partition
with this command:

    cd /system
    tar --numeric-owner -czf ../system.tar.gz *

## Usage
Just run the script with path to the SailfishOS ZIP as an argument. **You need
to be in the same folder as the script!**

    ./build_mrom.sh sailfishos.zip

You can also select the target device and destination file:

    ./build_mrom.sh --dev=hammerhead --dest=result.mrom sailfishos.zip