#!/bin/sh

set -e

COMMIT=`head -1 -- CommitId`

git clone git@github.com:QubesOS/qubes-app-linux-pdf-converter.git wrkdir
git -C wrkdir checkout "${COMMIT}"
