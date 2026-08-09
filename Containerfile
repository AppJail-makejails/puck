ARG FREEBSD_RELEASE
ARG PYVER

FROM ghcr.io/appjail-makejails/python:${FREEBSD_RELEASE}-${PYVER}

ARG PYVER
ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="Puck" \
    org.opencontainers.image.description="Convert untrusted PDF files into trusted ones" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/puck" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/puck" \
    org.opencontainers.image.licenses="GPLv2" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

WORKDIR /pdfconverter

RUN set -xe; \
    \
    pkg update; \
    pkg install -U \
        FreeBSD-utilities \
        FreeBSD-pam \
        FreeBSD-libmagic \
        py${PYVER}-click \
        py${PYVER}-pillow \
        py${PYVER}-tqdm \
        py${PYVER}-python-magic \
        shrinkpdf \
        GraphicsMagick-nox11 \
        poppler-utils \
        su-exec-static \
        libreoffice \
        git-tiny \
        tesseract \
        tesseract-data \
        py${PYVER}-pymupdf \
        python; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*

COPY patches/*.patch patches/CommitId .

RUN set -xe; \
    \
    umask 0022; \
    \
    git clone https://github.com/QubesOS/qubes-app-linux-pdf-converter; \
    COMMIT=`head -1 -- "CommitId"`; \
    git -C qubes-app-linux-pdf-converter checkout "${COMMIT}"; \
    \
    cp -a qubes-app-linux-pdf-converter/qubespdfconverter/ .; \
    \
    for patch in *.patch; do \
        patch < "${patch}"; \
    done; \
    \
    rm -rf qubes-app-linux-pdf-converter tests CommitId; \
    rm -f *.patch *.orig
