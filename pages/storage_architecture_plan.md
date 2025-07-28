---
layout: default
math: mathjax
title: Storage architecture plan
nav_order: 5
---

Last update: 20250727
# Storage architecture plan

* TOC
{:toc}

---

This page documents the planning for physical data storage and backup architecture.

➡️ See [Storage, usage, and Git practices](storage_use_sync_and_versioning) for how we work with project folders, sync, and versioning day to day.

Here we provide the details of one pice of hardware in use; a Ugreen NASync DXP4800 Plus with RAID 5 for reliable onsite storage, combined with selective offsite backups (e.g. Backblaze B2) for critical data. This setup provides fast local access, resilience against hardware failure, and secure long-term protection without vendor lock-in. The document outlines the directory structure, NAS configuration, and storage planning rationale as a reference for maintaining a scalable and auditable data environment.

## Storage

```
├── src/                     # local git projects (synced to NAS, pushed to GitHub)
│   ├── project1/
│   │   ├── analysis/
│   │   ├── scripts/
│   │   ├── latex/
│   │   ├── README.md
│   │   └── .git/
│   │
│   ├── project2/
│   │
│   ├── systematic_review/   # separate repo just for a stand alone paper
│   │   ├──  latex/
│   │   ├──  figures/
│   │   ├──  README.md
│   │   └── .git/
│   └── ...
│
├── data/                    # large datasets (mostly stored on NAS, copy locally if needed)
│   ├── project1/
│   │   ├── raw/             # not in git, synced to NAS
│   │   ├── processed/       # not in git, synced to NAS
│   │   ├── release/         # cleaned data for public release (upload to Zenodo, Figshare, etc.)
│   │   └── working/         # local scratch (NOT synced) - saved elsewhere when finished (raw, processed) for NAS sync
│   │
│   ├── project2/
│   └── ...
│
├── media/                   # media files (mostly stored on NAS, copy locally if needed)
│   ├── documents/
│   ├── graphics/
│   ├── videos/
│   │   └── working/         # local scratch (NOT synced) - saved elsewhere when finished (raw, processed) for NAS sync
│
└── docs/                    # company documentation (synced to NAS)
│   ├──  business_plan.md
│   ├──  marketing_notes.md
│   └──  ...
│
└── finance/
    └── ...
```

## System overview

All work is organised under `~/so/` on the local hardware, structured into subfolders for code, data, media, and documentation. A local NAS, connected via ethernet to the office mesh Wi-Fi network, provides central storage and backup. The NAS syncs automatically with selected local folders, ensuring data redundancy and protection against hardware failures.


### Code and projects (`/src/`)

The `/src/` directory contains all software development projects, including analysis scripts and LaTeX or Markdown for writing academic papers. These projects are managed with local git commits and pushed to GitHub for version control and collaboration, while also being synchronised to the NAS for backup.

### Data (`/data/`)

Large datasets reside under `/data/`. Most data remain stored on the NAS to save local disk space, but can be copied locally when running compute-intensive tools. 
Keeping a clear auditable structure. 
Within each project’s data folder:

- `raw/` and `processed/` (or equivalent) directories hold the main files.
- `release/` is prepared for public sharing through repositories like Zenodo, Figshare, EGA, customer products.
- `working/` serves as local scratch space for temporary files during analysis, providing faster performance for intermediate steps before results are saved back to the NAS.


### Media (`/media/`)

The `/media/` directory houses content that we generate such as documents, books, graphics, and video projects. Smaller files sync continuously with the NAS. As with analysis `data/`, for large media work such as videos, raw footage is copied locally into the `working/` subfolder to ensure fast read and write speeds during editing, and completed projects are then archived back to the NAS for long-term storage.
No sensitive data or critical IP.

### Documentation (`/docs/`)

The `/docs/` folder stores company-level documentation and internal materials, all synced to the NAS to keep critical records safe and accessible. 
Keeping a clear auditable structure. 

### Finance (`/finance/`)

Equivalent to `/docs/` with a dedicated space.
Keeping a clear auditable structure. 


### Offsite backup with Backblaze B2

In addition to local and NAS storage, the system uses Backblaze B2 for offsite backup. The NAS connects to Backblaze B2 via Hyper Backup tool, which automatically schedules encrypted backups of selected folders (such as `/src/`, `/data/`, `/media/`, and `/docs/`). This ensures that all critical files are protected against physical disasters like fire, theft, or catastrophic hardware failure.

Hyper Backup allows versioning, so older copies of files can be restored if needed. The cost is low, typically around $5 per terabyte per month. Scratch folders like `working/` in both `/data/` and `/media/` are not included in these backups, as they are meant for temporary local use and cleared when projects are complete.

### Summary

This setup ensures that software is always run locally from desktops (e.g. Mac) for speed and control, while data and media can reside on the NAS unless local speed is required. Scratch folders in both `/data/` and `/media/` provide local-only working space for tasks needing high performance, keeping the main storage system organised and efficient. Meanwhile, Backblaze B2 provides a secure, offsite layer of protection for long-term data safety.

### NAS and RAID config

We use RAID 5 to balance redundancy and capacity for a compact research team. This provides protection against a single disk failure while maximising usable storage capacity. In case of a disk failure, the plan is to replace the failed drive and allow RAID to rebuild from parity. Additional safety comes from offsite backups to Backblaze B2, and from code and documents stored in remote repositories like GitHub, ensuring important media and data can be restored if needed. For now, RAID 5 is sufficient, with the option to switch to RAID 6 in the future if the project expands or data becomes more critical. Currently, our datasets are calculated from public resources which can be reproduced if necessary.

For a project of < 10 TB:

| Model                              | CHF  | Drives     | RAID Config | Usable Space | CHF per usable TB |
|------------------------------------|------|------------|-------------|--------------|-------------------|
| DS224+ (2×8 TB)                    | 753  | 2 × 8 TB   | RAID 1      | 8 TB         | ~CHF 94 / TB      |
| DS423+ (4×4 TB)                    | 919  | 4 × 4 TB   | RAID 5      | ~12 TB       | ~CHF 76 / TB      |
| DS423+ (4×4 TB)                    | 919  | 4 × 4 TB   | RAID 6      | ~8 TB        | ~CHF 115 / TB     |
| DS923+ (4×4 TB)                    | 1029 | 4 × 4 TB   | RAID 5      | ~12 TB       | ~CHF 86 / TB      |
| Ugreen DXP4800 Plus (4×4 TB)       | 1029 | 4 × 4 TB   | RAID 5      | ~12 TB       | ~CHF 86 / TB      |
| Ugreen DXP4800 Plus (3×8 TB)       | 1119 | 3 × 8 TB   | RAID 5      | ~16 TB       | ~CHF 70 / TB      |

Spending:
- Ugreen NASync DXP4800 Plus chassis: CHF 588.–  
- WD Red Plus 8 TB drives × 3: CHF 177.– each → CHF 531.–
- **NAS Total**: CHF 1119.–
- Apple Thunderbolt to Gigabit Ethernet Adapter (MD463ZM/A): CHF 14.89 + CHF 4.20 shipping → **Total** CHF 19.09

---

#### Ugreen NASync DXP4800 Plus

The **Ugreen NASync DXP4800 Plus** is a modern NAS offering high hardware performance and flexibility:

* **CPU:** Intel Pentium Gold 8505, 5 cores / 6 threads, up to 4.40 GHz
* **RAM:** 8 GB DDR5 (expandable up to 64 GB)
* **Drive bays:** 4 × SATA (2.5″ / 3.5″) + 2 × M.2 NVMe
* **Maximum storage capacity:** up to 104 TB (4 × 26 TB drives)
* **Network ports:** 1 × 10GbE + 1 × 2.5GbE
* **RAID support:** 0, 1, 5, 6, 10, JBOD
* **Connectivity:** HDMI 4K, SD card reader, multiple USB ports (USB-A, USB-C)
* **Weight:** 6.02 kg
* **Dimensions:** 25.75 × 17.80 × 17.80 cm
* **Country of origin:** China
* **Release date:** 7 October 2024

Unlike Synology, Ugreen allows the use of **third-party drives** without vendor lock-in, which reduces future costs and provides flexibility in hardware upgrades. It also features built-in 10GbE networking for high-speed transfers, and offers significant headroom for RAM and CPU-intensive workloads, making it well-suited for future data growth and heavier operations.

---

#### Synology models for reference

While Synology remains a leader in NAS software (DSM) and integrated cloud services, their hardware offers comparatively modest specifications:

* Lower base RAM (2–4 GB), expandable only on some models
* Often requires purchase of additional cards for 10GbE networking
* Potential future restrictions on third-party drives, increasing long-term costs
* Excellent software ecosystem, with mature support for cloud backups like Backblaze B2

---

### Decision

Given the combination of hardware power, freedom from vendor lock-in, built-in 10GbE networking, and expandability, we have chosen the **Ugreen NASync DXP4800 Plus** as the NAS platform. While Synology remains an excellent solution for those prioritising a mature software environment, Ugreen offers superior hardware value and flexibility, which aligns better with the performance and cost-efficiency goals of the project.

---

