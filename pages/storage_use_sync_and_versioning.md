---
layout: default
math: mathjax
title: Storage, usage, and Git practices
nav_order: 5
---

Last update: 20250727
# Storage, usage, and Git practices

* TOC
{:toc}

---

We maintain a structured, auditable setup for managing all data, source code, and project files. This approach balances local development flexibility with reliable centralised storage and offsite backup. 

Daily work happens in `~/so`, versioned with Git and synced to the NAS. Snapshots and offsite backups run in the background. Large datasets stay on the NAS with high-speed link if required. Very large data is processed on HPC. This page explains how the system works and how to use it.

---

### Working directory: `~/so`

Each team member works locally in the `~/so` directory, which is two-way synced with the NAS path `/volume1/so`. This pulls in source code, documents, releases, test datasets, and other active materials.

* ✅ Synced with offsite and cloud backups
* ✅ Synced bidirectionally between local and NAS
* ✅ Suitable for day-to-day development and collaboration
* ⚠️  Deletions are propagated across systems
* ❌ Snapshots with NAS but are not synced back to local machines

Typical synced structure:

```
~/so/
├── src/
├── docs/
├── release/
├── netlify-backend/
├── media/
├── org/
└── web/
```

---

### Central NAS data store: `/volume1/data_big`

Large static datasets, reference genomes, media assets, and derived outputs are stored exclusively on the NAS under `/volume1/data_big`. These are not included in sync operations and must be accessed over the network.

* ✅ Accessible via LAN, mount, or SSH
* ❌ Not auto synced to desktop
* ✅ Snapshotted for recovery

Example layout:

```
/volume1/data_big/
├── data/
├── db/
├── davinci_video_production/
├── ollama/
└── #recycle/
```

---

### Snapshots

Snapshots are created automatically on the NAS once per month and retained by count (not date). These are lightweight, incremental, and only use additional space when files are changed or deleted.

* ✅ Stored locally on NAS (`.snapshot` or `@snapshot`)
* ✅ Recoverable even if files are deleted from both NAS and local sync
* ❌ Not visible or synced to local machines

To recover a file manually:

```bash
cp /volume1/so/.snapshot/snapshot_20250701/docs/notes/overview.md /volume1/so/docs/notes/
```

---

### Git version control

All source code, structured documents, and defined project datasets are versioned in Git. Repositories are linked to the GitHub organisation for traceability and reproducibility. A set of shared scripts helps validate Git usage across the entire `~/so` tree.

Example output from a Git check:

```bash
$ sh org/script/check_git_init.sh

Git repo checklist:

-- ./org                 📁 container
✅ ./org/script          🌐 git@github.com:switzerlandomics/org-script.git

-- ./docs                📁 container
✅ ./docs/notes          🌐 git@github.com:switzerlandomics/docs-notes.git
✅ ./docs/resources      🌐 git@github.com:switzerlandomics/docs-resources.git

❌ ./media               ⚠️  none
❌ ./media/house_art     ⚠️  none
```


```bash
sh org/script/check_git_status.sh
Checking git status for projects in ./ ...

Project: script
  Path: ~/so/org/script
  Last commit: 2025-07-16 13:56:50 +0200
  Ahead of remote by: 0 commits
  Behind remote by: 0 commits
  ⚠️  Uncommitted changes exist!
```

Notes:

* ✅ All critical folders must be Git-initialised with a valid remote
* ⚠️  Non-versioned folders are intentional (e.g. raw media or exploratory work)
* 📁 "Container" folders group multiple Git repositories but are not tracked themselves

---

### Connection speed

⚡ When connected via LAN1 (10GbE over Thunderbolt), `/volume1/data_big` provides fast access to large datasets - typically ~1 Gbps (≈110 MB/s) when using a standard Thunderbolt-to-Gigabit Ethernet adapter. This adapter caps throughput to 1 Gbps, but a true 10 GbE interface is available and supported by the NAS for significantly higher speeds if needed.

For even greater performance, our NAS supports SSDs via M.2 NVMe slots, which can be configured for high-speed caching or dedicated SSD storage volumes. This is useful for working with large datasets or video projects where read/write speed is a bottleneck.

---

### Summary

Onsite + cloud:

| Path                      | Sync’d | Git-tracked | Snapshotted | Purpose                        |
| ------------------------- | ------ | ----------- | ----------- | ------------------------------ |
| `~/so/src/quant_db`       | ✅      | ✅           | ✅           | Active source code             |
| `~/so/media/video_assets` | ✅      | ❌           | ✅           | Raw, unversioned media         |
| `/volume1/data_big/db`    | ❌      | ❌           | ✅           | Reference or derived datasets  |
| `.snapshot/`              | ❌      | ❌           | ✅           | Local to NAS for recovery only |

Onsite mirrored to offsite.

---

This layered setup provides fast access for day-to-day work, robust backup through snapshots, and rigorous auditability through Git. All new folders intended for collaboration or long-term relevance should either be versioned in Git or stored in `/volume1/data_big`.

