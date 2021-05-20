FROM ubuntu:focal-20210416

MAINTAINER Jordi Huguet <jhuguet@barcelonabeta.org>

ARG DEBIAN_FRONTEND=noninteractive

LABEL description="CAT12 r1743 docker image"
LABEL maintainer="jhuguet@barcelonabeta.org"

# set the working directory
WORKDIR /root

# install dependencies and prereqs
RUN apt-get update \
 && apt-get -y install wget nano unzip libxext6 libxt6 moreutils \
 && apt-get clean

# install Matlab MCR at /opt/mcr
ENV MATLAB_VERSION R2017b
ENV MCR_VERSION v93
RUN mkdir /tmp/mcr_install \
 && mkdir /opt/mcr \
 && wget --progress=bar:force -P /tmp/mcr_install https://ssd.mathworks.com/supportfiles/downloads/R2017b/deployment_files/R2017b/installers/glnxa64/MCR_R2017b_glnxa64_installer.zip \
 && unzip -q /tmp/mcr_install/MCR_R2017b_glnxa64_installer.zip -d /tmp/mcr_install \
 && /tmp/mcr_install/install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent
ENV MCRROOT /opt/mcr/${MCR_VERSION}

# install SPM12 Standalone at /opt/spm
ENV SPM_VERSION 12
ENV SPM_REVISION r7771
ENV MCR_INHIBIT_CTF_LOCK 1
ENV SPM_HTML_BROWSER 0
RUN wget --progress=bar:force -P /tmp http://www.neuro.uni-jena.de/cat12/cat12_latest_${MATLAB_VERSION}_MCR_Linux.zip \
 && unzip -q /tmp/cat12_latest_${MATLAB_VERSION}_MCR_Linux.zip -d /opt \
 && mv /opt/MCR_Linux /opt/spm \
 && /opt/spm/run_spm12.sh ${MCRROOT} quit \
 && chmod +x /opt/spm/spm12 /opt/spm/*.sh \
 && rm -rf /tmp/*
ENV PATH="${PATH}:/opt/spm/standalone"
ENV SPMROOT /opt/spm

# install CAT12 as MCR toolbox at /opt/spm
ENV CAT_VERSION 12
ENV CAT_REVISION r1733
#RUN wget --progress=bar:force -P /tmp http://www.neuro.uni-jena.de/cat12/cat12_${CAT_REVISION}.zip \
# && unzip -q /tmp/cat12_${CAT_REVISION}.zip -d /opt/mcr \
# && rm -rf /tmp/* /opt/mcr/*MACOSX*

ENTRYPOINT ["cat_standalone.sh"]
