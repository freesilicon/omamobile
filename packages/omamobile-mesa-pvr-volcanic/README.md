<!-- SPDX-License-Identifier: MIT -->
# omamobile-mesa-pvr-volcanic

Draft opt-in Arch Linux ARM package for the experimental upstream Mesa `src/imagination/` PowerVR Volcanic (`DXT-48-1536`, `BVNC 71.2.2448.1212`, `RGX_CR_CORE_ID = 0x00470002099004bc`) Vulkan ICD on Google Tensor G5 (`laguna`: `mustang` and `rango`).

## Side-by-Side `llvmpipe` Fallback Contract

- **No conflict with `mesa` or `vulkan-panfrost`:** builds only `-Dvulkan-drivers=imagination` (`-Dgallium-drivers=`, `-Degl=disabled`, `-Dgbm=disabled`, `-Dgles2=disabled`) and packages ONLY:
  - `/usr/lib/libvulkan_powervr_mesa.so`
  - `/usr/share/vulkan/icd.d/powervr_mesa_icd.aarch64.json`
  - `/usr/lib/libpowervr_noop_drm_shim.so` (when built)
  - `/usr/share/omamobile/pvr-volcanic/env.sh`
- **Safe default preserved:** stock `mesa` (`llvmpipe` / `kms_swrast`) stays untouched for Hyprland and Omarchy. `PVR_I_WANT_A_BROKEN_VULKAN_DRIVER=1` is never enabled by default; opt in per shell via `source /usr/share/omamobile/pvr-volcanic/env.sh`.
- **Aligned with Phase 4 Track P4-B:** pins Mesa branch `feat/pvr-volcanic-dxt-48-1536` head `3878e8ae548bb8e9938082d2ce7d01c0df52c3cb` over base `b3f74d47c018a809ed7ffdcc97377fbbfdd59f80` (see [`patches/README.md`](patches/README.md)).
- **Zero proprietary firmware:** `rgx.fw.signed` is extracted by the owner from their own factory image via `tools/extract-vendor-firmware` (`CONTRIBUTING.md` §7).
