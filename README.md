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
* CAT12 toolbox (CAT12.8 r1933)

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
 -b /opt/spm/standalone/cat_standalone_segment.m \
 /data/my_dataset/sub-0001/anat/sub-0001_T1w.nii
```

Example using singularity (longitudinal segmentation)
----

You need to make sure to map `$HOME/.matlab` if you are running in contained
mode, because the MCR will write into that folder.

```bash
singularity build cat12-latest.sif docker://jhuguetn/cat12:latest
singularity run --cleanenv --contain \
  -B $PWD:/data \
  -B $HOME/.matlab \
  cat12-latest.sif \
  -s /opt/spm -m /opt/mcr/v93 -b /opt/spm/standalone/cat_standalone_segment_long.m /data/my_dataset/sub-01/ses-0{1,2,3}/anat/sub-01_T1w.nii
```

Credits
-------
Jordi Huguet ([BarcelonaBeta Brain Research Center](http://barcelonabeta.org))
