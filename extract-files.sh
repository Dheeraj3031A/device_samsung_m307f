#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/lib*/libsec-ril.so)
            xxd -p -c0 "${2}" | sed "s/800e40f9e10316aa820c8052e30315aa/800e40f9e10316aa820c8052080080d2/g" | xxd -r -p > "${2}".patched
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
