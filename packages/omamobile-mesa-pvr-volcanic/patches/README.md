<!-- SPDX-License-Identifier: MIT -->
# Phase 4 PowerVR Volcanic (`DXT-48-1536`) Patch Hook

Drop exported `git format-patch` files (`0001-*.patch`..`0005-*.patch`) from Mesa branch `feat/pvr-volcanic-dxt-48-1536` into this directory to build against upstream Mesa base commit `b3f74d47c018a809ed7ffdcc97377fbbfdd59f80`, or point `MESA_PVR_VOLCANIC_SRC` directly at a local checkout of commit `3878e8ae548bb8e9938082d2ce7d01c0df52c3cb`.

## Pinned Phase 4 Commit Series (`b3f74d47c018..3878e8ae548b`)

| Order | Commit SHA | Subject |
| --- | --- | --- |
| 1 | `d94589c2cdbdcaaec6b1d87fee749a7770c7f028` | `pvr/common: add Volcanic arch and DXT-48-1536 (71.2.2448.1212) device info` |
| 2 | `0120e85caad56012d06cf69c237e0fd4a920bd73` | `pvr/vulkan: wire Volcanic multi-arch dispatch, CSB, formats, and Stage G1 quirks` |
| 3 | `9406394992cdbd1802ea75bbed81e9626dd3a7e7` | `pco: add Volcanic DXT-48-1536 target metadata and guard Rogue encoder` |
| 4 | `b644eb034a6707cfdf94a300731142785298130b` | `pvr/tests: add Volcanic DXT-48-1536 device info, csbgen, and compiler tests` |
| 5 | `3878e8ae548bb8e9938082d2ce7d01c0df52c3cb` | `pvr/common: separate DXT-48-1536 num_raster_pipes (2) from num_isp_ipp_pipes (24)` |

Every patch in this hook is applied cleanly with `patch --fuzz=0 -Np1`. No proprietary firmware (`rgx.fw.signed`) is bundled here; see `tools/extract-vendor-firmware` and `CONTRIBUTING.md` §7.
