ARG FREEBSD_RELEASE
ARG PYVER

FROM ghcr.io/appjail-makejails/python:${FREEBSD_RELEASE}-${PYVER}

ARG PYVER

LABEL org.opencontainers.image.title="Puck" \
    org.opencontainers.image.description="Convert untrusted PDF files into trusted ones" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/puck" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/puck" \
    org.opencontainers.image.licenses="GPLv2" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

WORKDIR /pdfconverter

RUN pkg update && \
    pkg install -y FreeBSD-utilities py${PYVER}-click py${PYVER}-pillow py${PYVER}-tqdm shrinkpdf GraphicsMagick-nox11 poppler-utils su-exec-static && \
    pkg clean -a && \
    rm -rf /var/cache/pkg/* /var/db/pkg/repos/* && \
    fetch https://github.com/QubesOS/qubes-app-linux-pdf-converter/raw/refs/heads/main/qubespdfconverter/server.py && \
    fetch https://github.com/QubesOS/qubes-app-linux-pdf-converter/raw/refs/heads/main/qubespdfconverter/client.py

COPY patches/client.py.patch patches/server.py.patch .

RUN patch < client.py.patch && \
    patch < server.py.patch && \
    rm -f *.patch *.orig && \
    sed -i '' -Ee "s/%%PYVER%%/${PYVER%${PYVER#?}}.${PYVER#?}/g" client.py server.py && \
    chmod 0555 client.py server.py
