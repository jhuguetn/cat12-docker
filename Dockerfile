FROM octomike/matlab-compiler-runtime:9.3-core

MAINTAINER Jordi Huguet <jhuguet@barcelonabeta.org>

ARG DEBIAN_FRONTEND=noninteractive

LABEL description="CAT12 standalone docker image"
LABEL maintainer="jhuguet@barcelonabeta.org"

# set the working directory
WORKDIR /root

# install dependencies and prereqs
ENV DEBIAN_FRONTEND noninteractive

# install MCR/standalone version of SPM12 plus CAT12 at /opt/spm
ENV MATLAB_VERSION R2017b
ENV MCR_VERSION v93
ENV MCRROOT /opt/mcr/${MCR_VERSION}
ENV SPM_VERSION 12
ENV SPM_REVISION r7771
ENV MCR_INHIBIT_CTF_LOCK 1
ENV SPM_HTML_BROWSER 0
ENV CAT_VERSION 12.8.1
ENV CAT_REVISION r2042
ENV CAT_FULLVERSION CAT${CAT_VERSION}_${CAT_REVISION}
RUN wget --progress=bar:force -P /tmp http://www.neuro.uni-jena.de/cat12/${CAT_FULLVERSION}_${MATLAB_VERSION}_MCR_Linux.zip \
 && unzip -q /tmp/${CAT_FULLVERSION}_${MATLAB_VERSION}_MCR_Linux.zip -d /opt \
 && mv /opt/${CAT_FULLVERSION}_${MATLAB_VERSION}_MCR_Linux /opt/spm \
 && /opt/spm/run_spm12.sh ${MCRROOT} --version \
 && chmod +x /opt/spm/spm12 /opt/spm/*.sh \
 && chmod +x /opt/spm/spm12_mcr/home/gaser/gaser/spm/spm12/toolbox/cat12/CAT.glnx86/CAT_* \
 && rm -rf /tmp/*
RUN cp /opt/spm/spm12_mcr/home/gaser/gaser/spm/spm12/toolbox/cat12/cat_long_main.txt /opt/spm/spm12_mcr/home/gaser/gaser/spm/spm12/toolbox/cat12/cat_long_main.m
ENV PATH="${PATH}:/opt/spm/standalone"
ENV SPMROOT /opt/spm


ENTRYPOINT ["cat_standalone.sh"]
