---
layout: default
title: FASTQ format data
date: 2023-07-27 00:00:01
nav_order: 5
---

Last update: 20230727

{: .no_toc }
<details open markdown="block">
<summary>Table of contents</summary>
{: .text-delta }
- TOC
{:toc}
</details>

---

## FASTQ format data

### Summary 
* Analysis pipelines must account for the run directory name since it is possible that >1 file has the same filename and thus output may be overwritten.
* WGS data from SMOC is produced currently with Novaseq6000.
* h2030gc fastq file names:
    * `<SAMPLE_ID>_<NGS_ID>_<POOL_ID>_<S#>_<LANE>_<R1|R2>.fastq.gz`
* Illumina fastq header:
    * `@<instrument>:<run number>:<flowcell ID>:<lane>:<tile>:<x-pos>:<y-pos> <read>:<is filtered>:<control number>:<sample number>`
    * For the Undetermined FASTQ files only, the sequence observed in the index read is written to the FASTQ header in place of the sample number. This information can be useful for troubleshooting demultiplexing.

| Element	| Requirements	| Description	| 
|---------------|---------------|---------------|
| @	| @	| Each sequence identifier line starts with @ |
| <instrument>	| Characters allowed: a–z, A–Z, 0–9 and underscore	| Instrument ID |
| <run number>	| Numerical	| Run number on instrument |
| <flowcell ID>	| Characters allowed: a–z, A–Z, 0–9	| 
| Flowcell ID	| <lane>	| Numerical	| Lane number |
| <tile>	| Numerical	| Tile number	| <x_pos>	| Numerical	| X coordinate of cluster	| 
| <y_pos>	| Numerical	| Y coordinate of cluster	| 
| <read>	| Numerical	| Read number. 1 can be single read or Read 2 of paired-end	| 
| <is filtered>	| Y or N	| Y if the read is filtered (did not pass), N otherwise	| 
| <control number>	| Numerical	| 0 when none of the control bits are on, otherwise it is an even number. On HiSeq X systems, control specification is not performed and this number is always 0. |
| <sample number>	| Numerical	| Sample number from sample sheet |



### Details
WGS data from SMOC is produced currently with Novaseq6000.
Files are returned in one directory based on the order and several run directories containing the fastq files.

```
|--- order
   |--- run1
      |- s1_ABC_123_S1_L001_R1.fastq.gz
      |- s1_ABC_123_S1_L001_R2.fastq.gz
   |--- run2
   |--- run3
```

File names are structured as follows:

`<SAMPLE_ID>_<NGS_ID>_<POOL_ID>_<S#>_<LANE>_<R1|R2>.fastq.gz`

where

* `<SAMPLE_ID>`: is the sample ID given in the original sample sheet.
* `<NGS_ID>`: the identifier of the library preparation. Usually does not change unless a new sequencing library needs to be prepared.
* `<POOL_ID>`: the identifier of the pool. Your samples have NA here, as they are not pooled.
* `* <S#>`: 'S' followed by a number given by the sequencer.
* `<LANE>`: flow cell lane
* `*<R1|R2>`: reads R1 and R2 (for paired-end sequencing).

In this way, a library sequenced several times to achieve coverage can have the same name if S# is the same (decided by the sequencer).

The FASTQ files are in directories representing individual runs, for example 221031_A00485_0334_AHNFF5DSX3 is run 334, performed on 31/10/2022 on the Novaseq6000 (A00485) and flow cell AHNFF5DSX3.


## Links
* <https://en.wikipedia.org/wiki/FASTQ_format>
* <https://knowledge.illumina.com/software/general/software-general-reference_material-list/000002211>
* <https://help.basespace.illumina.com/files-used-by-basespace/fastq-files>

