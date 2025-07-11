---
layout: default
title: HPC infrastructure
date: 2023-06-16 00:00:01
nav_order: 5
---
Last update: 20230616

## Hardware
Example comparisons

### sciCORE <https://scicore.ch/using-scicore/hpc-resources/>

**Cluster BioMedIT**
* Total nodes 15
* Total cores 976 total, 200 user
* Total RAM 6 TB
* Total GPUs 8
* Inter-connect Eth 100G
* Total Disk 900 TB

**Cluster sciCORE**
* Total nodes 215
* Total cores 13632
* Total RAM 73 TB
* Total GPUs 80
* Inter-connect Eth 100G, Infiniband
* Total Disk 11 PB

### EPFL <https://www.epfl.ch/research/facilities/scitas/jed/>
* Peak performance Rpeak: 2’322 TFLOPs
* Total RAM: 233,5 TB
* Storage: 350 TB
* The cluster is composed of 419 compute nodes, each with
	* 2 Intel(R) Xeon(R) Platinum 8360Y processors running at 2.4 GHz, with 36 cores each (72 cores per machine),
	* 3 TB of SSD disk
* for a total of 30’240 cores (including the frontend node)
* 375 nodes have 512 GB of RAM,
* 42 nodes have 1 TB of RAM,
* 2 nodes have 2 TB of RAM
	* approx 250 TB total

## HPC documentation
sciCORE uses SLURM workload manager <https://slurm.schedmd.com/overview.html>

Examples of documentation on simimlar infrastructure.
* NIH Biowulf <https://hpc.nih.gov>
* For the sciCORE cluster: <https://wiki.biozentrum.unibas.ch/display/scicore/sciCORE+user+guide>
* For using SLURM: <https://wiki.biozentrum.unibas.ch/display/scicore/SLURM+user+guide>
* EPFL SCITAS: <https://www.epfl.ch/research/facilities/scitas/documentation/>

## Acknowledgements
* sciCORE: "Calculations were performed at sciCORE (http://scicore.unibas.ch/) scientific computing core facility at University of Basel."
* sciCORE/SIB: "Calculations were performed at sciCORE (http://scicore.unibas.ch/) scientific computing core facility at University of Basel, with support by the SIB Swiss Institute of Bioinformatics."

## Data stream
Read about where the data is generated, how it comes fro BioMedIT and how the responsibility of management is controlled here: 
[Data stream](data_stream.html)
