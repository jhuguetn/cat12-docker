CAT12-docker
============
Ready-to-use Docker image with the standalone version of the
[Computational Anatomy Toolbox](http://www.neuro.uni-jena.de/cat/) (CAT) toolbox
for [SPM](https://www.fil.ion.ucl.ac.uk/spm/). No MATLAB license required.

Find the image in Docker Hub [here](https://hub.docker.com/r/jhuguetn/cat12).

Components
----------
* Ubuntu 20.04 LTS (Focal Fossa)
* MATLAB Compiler Runtime R2017b (version 9.3)
* SPM12 standalone version (SPM12 r7771)
* CAT12 toolbox (CAT12.8 r1904)

Usage
-----
```bash
 docker pull jhuguetn/cat12
 ...
 docker run -v /data:/data jhuguetn/cat12 -b /data/matlab_batch_script.m /data/img.nii
```

Example (segmentation of T1w image)
-----
```bash
 docker run -it --rm -v `pwd`/data:/data jhuguetn/cat12 \
 -b /opt/spm/standalone/cat_standalone_segment.txt \
 /data/my_dataset/sub-0001/anat/sub-0001_T1w.nii
```

Credits
-------
Jordi Huguet ([BarcelonaBeta Brain Research Center](http://barcelonabeta.org))
