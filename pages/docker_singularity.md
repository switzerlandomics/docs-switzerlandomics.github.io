---
layout: default
title: Docker with singularity
nav_order: 5
---

Last update: 20240828

# Downloading Docker images using Singularity

The following method is used on BioMedIT sciCORE for running docker images. 

You can use Singularity to download Docker images from public Docker registries. This is the list of accessible Docker registries:

- [Docker Hub](https://hub.docker.com/)
- [Quay.io](https://quay.io/)
- [GCR.io](https://gcr.io/)
- [Google Container Registry](https://cloud.google.com/container-registry/)

Those Docker registries are accessible using a proxy so you should modify your pull command to use the internal proxy. See some examples below:

## Download Docker Image from Dockerhub

The command to execute in an environment with unrestricted internet access to download the freesurfer image from Dockerhub would be "singularity pull docker://freesurfer/freesurfer:7.3.1" but we have to modify the pull command to add our proxy url (bm-soft.scicore.unibas.ch:444). See the example below:

```bash
singularity pull docker://bm-soft.scicore.unibas.ch:444/freesurfer/freesurfer:7.3.1
```

## Download Biocontainer Docker Images

The [Biocontainers project](https://biocontainers.pro/) provides a curated list of container images with many bioinformatics tools. You can download the biocontainer images like this:

```bash
singularity pull docker://bm-soft.scicore.unibas.ch:444/biocontainers/blast:2.2.31
```

## Download Big Docker Images

It can happen that your container image is too big to fit in local disk when pulling it. If that's the case you can use the environment variables SINGULARITY_TMPDIR and SINGULARITY_CACHEDIR e.g.

```bash
mkdir $HOME/tmp/
mkdir $HOME/tmp/cache
SINGULARITY_TMPDIR=$HOME/tmp/ SINGULARITY_CACHEDIR=$HOME/tmp/cache singularity pull docker://bm-soft.scicore.unibas.ch:444/freesurfer/freesurfer:7.3.1
```

