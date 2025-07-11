---
layout: default
title: Data stream
nav_order: 5
---
<!-- date: 2023-06-16 00:00:01 -->

# Data stream
Last update: 20230616

## Omic data sources
* The Swiss Multi-Omics Center (SMOC)
	* <http://smoc.ethz.ch>.

## SMOC has 3 branches
* CGAC - Genomics.
* CPAC - Proteotyping.
* CMAC - Metabolomics & Lipidomics.

## Where the facilities are
* CGAC is from [Health2030 genome center](https://www.health2030genome.ch) Geneva.
* CMAC is from [ETHZ Metabolomics & Biophysics](https://fgcz.ch/omics_areas/met.html) Zurich.
* CPAC is from [ETHZProteomics](https://fgcz.ch/omics_areas/prot.html) Zurich.

## Naming convention
* BiomedIT portal data transfer uses the names:
	* CGAC = health_2030_genome_center
	* CMAC = phrt_cmac
	* CPAC = phrt_cpac

## Examples of omic tech and output

{: .note }
The following are place-holder links until we write up pages specfic to our usage.

* <https://lawlessgenomics.com/topic/omics-mc-hilic>
* <https://lawlessgenomics.com/topic/omics-mc-lc>
* <https://lawlessgenomics.com/topic/omics-proteomics>
* <https://lawlessgenomics.com/topic/omics-rplc>
* <https://lawlessgenomics.com/topic/omics-targeted>

## BioMedIT
Read about the high-performance-computing (HPC) infrastructure here: 
[HPC infrastructure](hpc.html)

## How data is collected and stored
Omic data that we will ultimately use is collected and hosted under the following hierarchy.

* The [Swiss Personalised Health Network (SPHN)](https://sphn.ch).
* Branch of SPHN: [Data Coordination Center (DCC)](https://sphn.ch/network/data-coordination-center/).
* DCC is also a part of [Swiss Institute of Bioinformatics (SIB)](https://www.sib.swiss/personalized-health-informatics).
* The data is to be stored and processed on [BioMedIT network](https://www.biomedit.ch).
* Our tenant on BioMedIT is called MOMIC and this is on the [sciCORE infrastructure](https://scicore.ch).

{: .note}
While the SPHN organisation hierarchy is illustrated based on the final storage location for the omic data belonging to this project, there are many other branches of SPHN not shown. It is also worth noting that ethical and legal responsibilities of data access may rest on the ethics/consent form signatories, such as individual project leaders.

### SPHN and BioMedIT
> The Swiss Personalized Health Network (SPHN) is a national initiative under the leadership of the Swiss Academy of Medical Sciences (SAMS). In collaboration with the SIB Swiss Institute of Bioinformatics it contributes to the development, implementation and validation of coordinated data infrastructures in order to make health-relevant data interoperable and shareable for research in Switzerland.
> BioMedIT is an integral part of SPHN and was developed along the needs of SPHN funded projects.
> SPHN and BioMedIT are funded by the Swiss Government through the ERI-dispatches (2017-2020 and 2021-2024).
(from <https://www.biomedit.ch>)

### BioMedIT structure
> The three BioMedIT sites (nodes) form a shared security zone, such that once data is brought into the platform, it can be accessed and processed on any of the nodes. Projects from research consortia or single researchers wishing to use sensitive data are set up as research projects on one of the nodes in a BioMedIT project-specific environment, called a 'B-space'.
> Research groups can access their B-spaces via the BioMedIT Portal, where they can manage users and encryption keys, initiate data transfers and access support and other tools and services offered by BioMedIT.
> Researchers securely access the system using two factor authentication, and extract only nonsensitive or aggregated research results while leaving the sensitive data in the platform. 
(from <https://www.biomedit.ch>)

## Accessing BioMedIT
> BioMedIT is open to all Swiss universities, research institutes, hospitals, service providers and other interested partners. In addition, and specifically within the framework of the two Swiss national initiatives SPHN and PHRT, the BioMedIT Network can be used for mono- and multi-site, individual and collaborative research projects. BioMedIT is a project of the SIB Swiss Institute of Bioinformatics
(from <https://www.biomedit.ch>)

![Alt text](https://www.biomedit.ch/.imaging/mte/biomedit-theme/large/dam/Illustrations/biomedit-network/BioMedIT-Graphic---SIB-3-line_with-title_Large.png/jcr:content/BioMedIT%20Graphic%20-%20SIB%203%20line_with%20title_Large.png "biomedit image")
