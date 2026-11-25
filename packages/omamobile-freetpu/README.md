<!-- SPDX-License-Identifier: MIT -->
# omamobile-freetpu

Clean-room Arch Linux ARM (`aarch64`) package for Google Tensor G5 (`laguna`) EdgeTPU userspace runtime, `FreeTile BUENOS_A0` emitter, bare-metal runner, and non-root `/dev/edgetpu-soc` udev rules.

## Upstream Contract Alignment (Track P5-A)

- **Repository / Branch:** `saariuslystoned/freetpu`, branch `feat/freetile-buenos-wire`
- **Pinned Commit:** `66e73ef6c54f8a23c0d987844f16d5c5787da201`
- **License:** Apache-2.0 (see [`LICENSE`](LICENSE))
- **Provides:** `libopenbuenos`, `freetpu`, `freetile`
- **Build:** Pure C++17 via CMake + Ninja (`-DCMAKE_POSITION_INDEPENDENT_CODE=ON`, `-DOPENBUENOS_ENABLE_FREETILE=ON`, `-DOPENBUENOS_FREETILE_DEFAULT_ON=OFF`, `-DOPENBUENOS_BUILD_TESTS=ON`, `-DOPENBUENOS_INSTALL_SELFTEST=ON`, `-DOPENBUENOS_WERROR=OFF`, `-DFREETPU_RUNTIME_WERROR=OFF`). Zero LLVM/MLIR/Python and zero proprietary Google libraries.
- **Installed Artifacts:**
  - `/usr/lib/libopenbuenos.a` (embeds FreeTile `BUENOS_A0`; consumers link `-lopenbuenos`)
  - `/usr/include/openbuenos.h`, `/usr/include/freetpu/edgetpu_buenos_uapi.h`
  - `/usr/lib/cmake/openbuenos/*`
  - `/usr/bin/tpu_soc_probe`, `/usr/bin/openbuenos_selftest`, `/usr/bin/tpu_baremetal_runner`
  - `/usr/lib/udev/rules.d/99-edgetpu.rules` (`0660`, `GROUP="video"`, `TAG+="uaccess"` for `misc/edgetpu-soc` and `dma_heap/system`)
  - `/usr/share/licenses/omamobile-freetpu/LICENSE`
- **Runtime Emitter Switch:**
  - `OPENBUENOS_FREETILE=1` activates the FreeTile `BUENOS_A0` emitter with automatic fallback to `ob_gemm_emitter` for unsupported shapes/epilogues (`OPENBUENOS_FREETILE=0` default unless built with `-DOPENBUENOS_FREETILE_DEFAULT_ON=ON`).
- **Firmware Policy (Zero Blobs Packaged):**
  - Neither `edgetpu-buenos.fw` nor `dive_interp_rv64.bin` is committed or packaged (`CONTRIBUTING.md` §7).
  - Extract `google/edgetpu-buenos.fw` from the owner's factory image with `tools/extract-vendor-firmware -d mustang` (or `-d rango`), and extract `ext[1]` (`dive_interp_rv64.bin`) locally on the owner's machine.
  - Runtime probes `/usr/lib/firmware/google/dive_interp_rv64.bin`, `/lib/firmware/google/dive_interp_rv64.bin`, `/usr/share/omamobile/tpu/dive_interp_rv64.bin`, and `OPENBUENOS_DIVE_INTERP_PATH`.
