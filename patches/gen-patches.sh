#!/bin/sh

set -xe
set -o pipefail

fetch -o server.py.orig \
    https://github.com/QubesOS/qubes-app-linux-pdf-converter/raw/refs/heads/main/qubespdfconverter/server.py
fetch -o client.py.orig \
    https://github.com/QubesOS/qubes-app-linux-pdf-converter/raw/refs/heads/main/qubespdfconverter/client.py

diff -u server.py.orig server.py > server.py.patch || :
diff -u client.py.orig client.py > client.py.patch || :
