FROM ubuntu:focal-20210416

ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="CAT12 Docker" \
      org.opencontainers.image.description="CAT12 standalone Docker image" \
      org.opencontainers.image.authors="Jordi Huguet <jhuguet@barcelonabeta.org>"

# set the working directory
WORKDIR /root

# set runtime / build parameters
ARG MATLAB_VERSION=R2023b
ARG MCR_VERSION=v232
ARG SPM_VERSION=25
ARG SPM_REVISION=25.01.02
ARG CAT_VERSION=12.9
ARG CAT_REVISION=r2665
ARG CAT_FULLVERSION=CAT12.9

ENV MATLAB_VERSION=${MATLAB_VERSION} \
    MCR_VERSION=${MCR_VERSION} \
    MCRROOT=/opt/mcr/${MCR_VERSION} \
    SPM_VERSION=${SPM_VERSION} \
    SPM_REVISION=${SPM_REVISION} \
    MCR_INHIBIT_CTF_LOCK=1 \
    SPM_HTML_BROWSER=0 \
    CAT_VERSION=${CAT_VERSION} \
    CAT_REVISION=${CAT_REVISION} \
    CAT_FULLVERSION=${CAT_FULLVERSION} \
    SPMROOT=/opt/spm \
    CAT_PATH=/opt/spm/spm25_mcr/home/ubuntu/Desktop/spm12/toolbox/cat12 \
    PATH=/opt/spm/standalone:${PATH}

# install dependencies and prereqs
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    nano \
    unzip \
    libxext6 \
    libxt6 \
    moreutils \
 && rm -rf /var/lib/apt/lists/*

# install Matlab MCR at /opt/mcr
RUN mkdir -p /tmp/mcr_install /opt/mcr \
 && wget --progress=bar:force -P /tmp/mcr_install https://ssd.mathworks.com/supportfiles/downloads/R2023b/Release/10/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2023b_Update_10_glnxa64.zip \
 && unzip -q /tmp/mcr_install/MATLAB_Runtime_R2023b_Update_10_glnxa64.zip -d /tmp/mcr_install \
 && /tmp/mcr_install/install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent \
 && mv -v /opt/mcr/${MATLAB_VERSION} /opt/mcr/${MCR_VERSION} \
 && rm -rf /tmp/mcr_install

# install MCR/standalone version of SPM plus CAT12 at /opt/spm
RUN mkdir -p /tmp/cat_install \
 && wget --progress=bar:force -P /tmp/cat_install https://www.neuro.uni-jena.de/cat12/${CAT_FULLVERSION}_${MATLAB_VERSION}_MCR_Linux.zip \
 && unzip -q /tmp/cat_install/${CAT_FULLVERSION}_${MATLAB_VERSION}_MCR_Linux.zip -d /opt \
 && mv /opt/${CAT_FULLVERSION}_${MATLAB_VERSION}_MCR_Linux /opt/spm \
 && /opt/spm/run_spm25.sh "${MCRROOT}" --version \
 && find "${CAT_PATH}/CAT.glnx86" -type f -name "CAT_*" -exec chmod 755 {} \; \
 && find /opt/spm -type f -name "*.sh" -exec chmod 755 {} \; \
 && find /opt/spm -type f -name "*.m" -exec chmod 644 {} \; \
 && rm -rf /tmp/cat_install

ENTRYPOINT ["/opt/spm/standalone/cat_standalone.sh"]
