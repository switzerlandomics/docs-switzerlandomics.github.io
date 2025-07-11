---
layout: default
title: BWA
<!-- date: 2023-07-27 00:00:01 -->
nav_order: 5
---

# BWA
Last update: 20230727

* GATK: (How to) Map reads to a reference with alternate contigs like GRCH38 <https://gatk.broadinstitute.org/hc/en-us/articles/360037498992--How-to-Map-reads-to-a-reference-with-alternate-contigs-like-GRCH38>

SMOC data arrives in multiple batches to ensure read depth, etc.,
resulting in multiple sets of FASTQ files per sample all of which should have distinct read group IDs (RGID).
Therefore at some points we must compile all reads for a single subject.

The following is from GATK, which we will also perform:
> (like at the) Broad Institute, we run the initial steps of the pre-processing workflow (mapping and sorting) separately on each individual read group. Then we merge the data to produce a single BAM file for each sample (aggregation); this is done conveniently at the same time that we do the duplicate marking, by running Mark Duplicates on all read group BAM files for a sample at the same time. Then we run Base Recalibration on the aggregated per-sample BAM files. See the worked-out example below for more details.

* GATK: How should I pre-process data from multiplexed sequencing and multi-library designs? <https://gatk.broadinstitute.org/hc/en-us/articles/360035889471-How-should-I-pre-process-data-from-multiplexed-sequencing-and-multi-library-designs->
* GATK: Read groups <https://gatk.broadinstitute.org/hc/en-us/articles/360035890671>


## Read groups

Meaning of the read group fields required by GATK

* ID = Read group identifier 
	* This tag identifies which read group each read belongs to, so each read group's ID must be unique. It is referenced both in the read group definition line in the file header (starting with @RG) and in the RG:Z tag for each read record. Note that some Picard tools have the ability to modify IDs when merging SAM files in order to avoid collisions. In Illumina data, read group IDs are composed using the flowcell name and lane number, making them a globally unique identifier across all sequencing data in the world. 
	* Use for BQSR: ID is the lowest denominator that differentiates factors contributing to technical batch effects: therefore, a read group is effectively treated as a separate run of the instrument in data processing steps such as base quality score recalibration (unless you have PU defined), since they are assumed to share the same error model.
* PU = Platform Unit 
	* The PU holds three types of information, the {FLOWCELL_BARCODE}.{LANE}.{SAMPLE_BARCODE}. The {FLOWCELL_BARCODE} refers to the unique identifier for a particular flow cell. The {LANE} indicates the lane of the flow cell and the {SAMPLE_BARCODE} is a sample/library-specific identifier. Although the PU is not required by GATK but takes precedence over ID for base recalibration if it is present. In the example shown earlier, two read group fields, ID and PU, appropriately differentiate flow cell lane, marked by .4, a factor that contributes to batch effects.
* SM = Sample 
	* The name of the sample sequenced in this read group. GATK tools treat all read groups with the same SM value as containing sequencing data for the same sample, and this is also the name that will be used for the sample column in the VCF file. Therefore it is critical that the SM field be specified correctly. When sequencing pools of samples, use a pool name instead of an individual sample name.
* PL = Platform/technology used to produce the read 
	* This constitutes the only way to know what sequencing technology was used to generate the sequencing data. Valid values: ILLUMINA, SOLID, LS454, HELICOS and PACBIO.
* LB = DNA preparation library identifier 
	* MarkDuplicates uses the LB field to determine which read groups might contain molecular duplicates, in case the same DNA library was sequenced on multiple lanes.


## Our method for creating read group info

NovaSeq SMPC fastq filename
* `<SAMPLE_ID>_<NGS_ID>_<POOL_ID>_<S#>_<LANE>_<R1|R2>.fastq.gz`

NovaSeq SMOC fastq header
* `@<instrument>:<run number>:<flowcell ID>:<lane>:<tile>:<x-pos>:<y-pos> <read>:<is filtered>:<control number>:<sample number>`

Read group definitions
* ID = Read group identifier
* SM = Sample
* PL = Platform/technology used to produce the read
* PU = Platform Unit
* LB = DNA preparation library identifier

Read group sources
* ID = sample_id , e.g. AAA073_NGS000033312_NA_S20_L004
* SM = sample_id regex field 1, e.g. AAA073
* PL = Machine and library method, e.g. "NovaSeq6000_WGS_TruSeq", hardcoded - automate later
* PU = {FLOWCELL_BARCODE}.{LANE}.{SAMPLE_BARCODE} which we can derive from fastq header 1 regex fields: 3.4., and sample_id regex field 1-2.
* LB = sample_id regex field 1-2

```
sm=$(echo ${sample_id} | awk -F '_' '{print $1}')
pu=$(zcat ${FILE1} | awk 'NR==1 {split($1,a,":"); print a[3] "." a[4] "." "'$sm'"}')
lb=$(echo ${sample_id} | awk -F '_' '{print $1 "_" $2}')
pl="NovaSeq6000_WGS_TruSeq"

echo "ID = ${sample_id}"
echo "SM = ${sm}"
echo "PL = ${pl}"
echo "PU = ${pu}"
echo "LB = ${lb}"

`rg="@RG\tID:${sample_id}\tSM:${sm}\tPL:${pl}\tPU:${pu}\tLB:${lb}"`
bwa mem \
        ${REF} \
        ${FILE1} \
        ${FILE2} \
        -R $rg \
        -v 1 -M -t 8 |\
        samtools view --threads 8 -O BAM -o ${output_file}
```

Check read group e.g.`samtools view -H file.bam | grep '^@RG'`.
We can also use logs to see if we have any read group collision which should be unique.

