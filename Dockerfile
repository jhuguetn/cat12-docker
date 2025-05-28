FROM ubuntu:focal-20210416

MAINTAINER Jordi Huguet <jhuguet@barcelonabeta.org>

ARG DEBIAN_FRONTEND=noninteractive

LABEL description="CAT12 standalone docker image"
LABEL maintainer="jhuguet@barcelonabeta.org"

# set the working directory
WORKDIR /root

# install dependencies and prereqs
RUN apt-get update \
 && apt-get -y install wget nano unzip libxext6 libxt6 moreutils \
 && apt-get clean

# install Matlab MCR at /opt/mcr
ENV MATLAB_VERSION R2023b
ENV MCR_VERSION v232
RUN mkdir /tmp/mcr_install \
 && mkdir /opt/mcr \
 && wget --progress=bar:force -P /tmp/mcr_install https://ssd.mathworks.com/supportfiles/downloads/R2023b/Release/10/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2023b_Update_10_glnxa64.zip \
 && unzip -q /tmp/mcr_install/MATLAB_Runtime_R2023b_Update_10_glnxa64.zip -d /tmp/mcr_install \
 && /tmp/mcr_install/install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent \
 && mv -v /opt/mcr/${MATLAB_VERSION} /opt/mcr/${MCR_VERSION}
ENV MCRROOT /opt/mcr/${MCR_VERSION}

# install MCR/standalone version of SPM plus CAT12 at /opt/spm
ENV SPM_VERSION 25
ENV SPM_REVISION 25.01.02
ENV MCR_INHIBIT_CTF_LOCK 1
ENV SPM_HTML_BROWSER 0
ENV CAT_VERSION 12.9
ENV CAT_REVISION r2665
ENV CAT_FULLVERSION CAT${CAT_VERSION}
ENV CAT_PATH /opt/spm/spm25_mcr/home/ubuntu/Desktop/spm12/toolbox/cat12
#RUN wget --progress=bar:force -P /tmp https://github.com/ChristianGaser/cat12/releases/download/${CAT_VERSION}/${CAT_FULLVERSION}_${MATLAB_VERSION}_MCR_Linux.zip \
RUN wget --progress=bar:force -P /tmp https://www.neuro.uni-jena.de/cat12/${CAT_FULLVERSION}_${MATLAB_VERSION}_MCR_Linux.zip \
 && unzip -q /tmp/${CAT_FULLVERSION}_${MATLAB_VERSION}_MCR_Linux.zip -d /opt \
 && mv /opt/${CAT_FULLVERSION}_${MATLAB_VERSION}_MCR_Linux /opt/spm \
 && /opt/spm/run_spm25.sh ${MCRROOT} --version \
 && chmod +x ${CAT_PATH}/CAT.glnx86/CAT_* \
 #&& cp -v ${CAT_PATH}/cat_long_main.txt ${CAT_PATH}/cat_long_main.m \
 && rm -rf /tmp/*
ENV PATH="${PATH}:/opt/spm/standalone"
ENV SPMROOT /opt/spm


ENTRYPOINT ["cat_standalone.sh"]
