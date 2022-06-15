#!/bin/bash

for d in */; do
    if [[ -f "$d/captured.prop" ]]; then
        echo -n > "$d/filtered.prop"
        cat "$d/captured.prop" | while read line; do
            # ignore non-read-only properties (effectively read-only ones may be whitelisted later)
            if [[ "$line" != "[ro."* ]]; then
                continue
            fi
            # ignore ro.bootmode since it varies
            if [[ "$line" == "[ro.bootmode]"* ]]; then
                continue
            fi
            # ignore personally identifying information inappropriately leaked by Samsung devices
            if [[ "$line" = "[ro.ap_serial]"* || "$line" = "[ro.em.did]"* ]]; then
                continue
            fi
            # ignore personally identifying information inappropriately leaked by Xiaomi devices
            if [[ "$line" = "[ro.ril.miui.imei"* || "$line" = "[ro.ril.oem.imei"* || "$line" = "[ro.ril.oem.psno]"* || "$line" = "[ro.ril.oem.sno]"* ]]; then
                continue
            fi
            # ignore ro.boot.* other than whitelisted exceptions not varying based on boot time, etc.
            if [[ "$line" = "[ro.boot."* && \
                    "$line" != "[ro.boot.avb_version]"* && \
                    "$line" != "[ro.boot.baseband]"* && \
                    "$line" != "[ro.boot.boot_devices]"* && \
                    "$line" != "[ro.boot.bootdevice]"* && \
                    "$line" != "[ro.boot.bootloader]"* && \
                    "$line" != "[ro.boot.dynamic_partitions]"* && \
                    "$line" != "[ro.boot.flash.locked]"* && \
                    "$line" != "[ro.boot.hardware]"* && \
                    "$line" != "[ro.boot.hardware.platform]"* && \
                    "$line" != "[ro.boot.hw.soc.rev]"* && \
                    "$line" != "[ro.boot.product.hardware.sku]"* && \
                    "$line" != "[ro.boot.revision]"* && \
                    "$line" != "[ro.boot.secure_boot]"* && \
                    "$line" != "[ro.boot.keymaster]"* && \
                    "$line" != "[ro.boot.vbmeta."* && \
                    "$line" != "[ro.boot.verifiedbootstate]"* && \
                    "$line" != "[ro.boot.veritymode]"* && \
                    "$line" != "[ro.boot.veritymode.managed]"* ]]; then
                continue
            fi
            echo "$line" >> "$d/filtered.prop"
        done
    fi
done
