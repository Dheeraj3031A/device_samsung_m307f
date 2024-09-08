#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/lib64/hw/android.hardware.gnss@2.1-impl.so|vendor/lib64/hw/vendor.samsung.hardware.gnss@2.0-impl.so)
            "${PATCHELF}" --remove-needed libhidltransport.so "${2}"
            ;;
        vendor/bin/hw/rild)
            "${PATCHELF}" --replace-needed libril.so libril-samsung.so "${2}"
            ;;
        vendor/lib*/libsec-ril.so|vendor/lib64/libsec-ril-dsds.so)
            "${PATCHELF}" --replace-needed libril.so libril-samsung.so "${2}"
            xxd -p -c0 "${2}" | sed "s/600e40f9820c805224008052e10315aae30314aa/600e40f9820c805224008052e10315aa030080d2/g" | xxd -r -p > "${2}".patched
            mv "${2}".patched "${2}"
            ;;
    esac
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=m307f
export DEVICE_COMMON=m30s-common
export VENDOR=samsung

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
