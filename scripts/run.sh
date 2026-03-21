#!/bin/sh

PUCK_RESOLUTION="${PUCK_RESOLUTION:-300}"
PUCK_BATCH="${PUCK_BATCH:-50}"
PUCK_COMPRESSION="${PUCK_COMPRESSION:-1}"
PUCK_COMPRESSION_WITH_GRAYSCALE="${PUCK_COMPRESSION_WITH_GRAYSCALE:-0}"
PUCK_COMPRESSION_RESOLUTION="${PUCK_COMPRESSION_RESOLUTION:-72}"

cd /pdfconverter

chown -R noroot:noroot /data

su-exec noroot ./client.py -i \
    -b "${PUCK_BATCH}" \
    -r "${PUCK_RESOLUTION}" \
    /data/file.pdf

if [ "${PUCK_COMPRESSION}" != 0 ]; then
    shrinkpdf_flags=

    if [ "${PUCK_COMPRESSION_WITH_GRAYSCALE}" != 0 ]; then
        shrinkpdf_flags="-g"
    fi

    su-exec noroot shrinkpdf ${shrinkpdf_flags} \
        -r "${PUCK_COMPRESSION_RESOLUTION}" \
        -o "/data/file.compressed.pdf" \
        /data/file.trusted.pdf
    mv /data/file.compressed.pdf /data/file.trusted.pdf
fi

chmod 640 /data/file.trusted.pdf
chown noroot:noroot /data/file.trusted.pdf
