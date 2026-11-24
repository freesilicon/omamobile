<!-- SPDX-License-Identifier: MIT -->
# Pixel 10 Pro Fold (`rango`) bring-up notes

Stage 0 read-only findings for **Google Pixel 10 Pro Fold (`rango`, SoC `laguna` / Tensor G5)** captured from an unlocked, Magisk-rooted stock Android 17 device (`CP3A.261005.005`, bootloader `deepspace-17.4-16119390`, kernel `6.6.127-android15-8`, active `slot=_b`), cross-linked with Pixel 10 Pro XL tracking issue [#18](https://github.com/derekross/omamobile/issues/18). Nothing was written, flashed, or rebooted.

Conventions match `CONTRIBUTING.md` §5.1 / §5.3 and `device/mustang/NOTES.md`:
- **`[V]`**: Directly observed in live `/sys/firmware/fdt`, `/proc/*`, `/sys/*`, `bootctl`, `dumpsys`, or read-only partition checksums/listings (AI-assisted capture analysis; raw captures and private identifiers kept strictly offline outside git).
- **`[I]`**: Inference or unverified detail needing Stage 1 / kernel-source verification.

---

## 1. Identity, Build, and Silicon State

- **Board & SoC** `[V]`:
  - `ro.product.device = rango`, `ro.boot.hardware.platform = laguna`, `ro.soc.model = Tensor G5`.
  - Root DT `model = "RANGO MP based on LGA"`, `compatible = "google,lga-rango", "google,lga"`, `#address-cells = <2>`, `#size-cells = <2>`.
  - `board_id = 0x70606`, `board_rev = 0x10000`, `ro.boot.hardware.revision = MP1.0`, `ro.boot.dtbo_idx = 10` (`lga-rango-mp.dtbo`).
  - `/chosen/plat`: `platform = 0x7`, `product = 0x6` (`mustang` is `0x5`), `stage = 0x6`, `major = 0x1`, `minor = 0x0`, `variant = 0x0`.
- **Silicon Revision (`B0`)** `[V]`:
  - `/soc_compatible/B0`: `description = "LGA B0"`, `product_id = <0x5>`, `major = <0x1>`, `minor = <0x0>`, `pkg_mode = <0x0>`, `ro.boot.hw.soc.rev = 2`, `/ehld-coreinstr` live.

---

## 2. Shared Laguna SoC Blocks (`rango` vs `mustang`)

- **CPUs & RAM** `[V]`: Identical 8-core `cluster0` layout (`2x 0xd80` + `5x 0xd87` + `1x 0xd82`, `BogoMIPS = 76.80`, `arm64.nomte`) and eight 2 GiB `/memory@*` banks (`0x80000000` and `0x880000000`..`0xb80000000`, **16 GiB total**, live `MemTotal: 15948928 kB`, `CmaTotal: 663552 kB`).
- **`reserved-memory` & `/proc/iomem`** `[V]`: Zero structural differences vs `mustang` across all 52 `reserved-memory` nodes (including `tpu_fw@9fc00000` 20 MiB, `gpu_fw@b9f00000` 33 MiB, `abl@be000000` 16 MiB `no-map`, `sec_dram@f7000000`, `bl31_dram@ffe00000`, `pkvm_guest_firmware@8af00000`, `gsa-gme@a2400000`).
- **GPU** `[V]`: **PowerVR D-Series DXT-48-1536**, OpenGL ES 3.2 `build 25.3@6908880` (`pvrsrvkm.ko`, `gpu0@34800000`, `rgx` `0x34f00000`).
- **Clocks, PM, MBA, GIC/GIA, Watchdogs, UART, USB** `[V]`: Identical CPM MBA (`cpm_clk`, `power_controller`, `cpm_rst`, `cpm_irq`), `arm,gic-v3` (`0x5880000`/`0x5900000`, `#interrupt-cells = <4>`) + `google,*-gia`, `watchdog_cl0@200c4000` & `cl1@200c5000`, `serial0` (`/uart@db61000`, `lsion_cli16_uart`, `0xdb62000`, direct `GIC_SPI 688`, AP debug console), `serial2` (`/uart@3a321000`, `lsioe_cli9_uart`, `0x3a322000`, live Modem UART `/dev/ttyS2` behind `lsioe` GIA), `usb3@c450000` + `usb_phy@c410000`, and `buenos@500000` (`google,edgetpu-laguna`) + `tpu_smmu@36200000` + `gsa-ns@e010000`.

---

## 3. Foldable-Specific Hardware (`rango` vs `mustang`)

- **Dual Displays (`DSI1` Inner + `DSI0` Cover)** `[V]`:
  - Both `dsi2host` controllers are active on `rango` under `/sswrp_dpu@ec00000` (`verisilicon,dc9x00` `0xee00000`):
    - **Inner foldable panel (`panel@0` on `dsi2host@3f8000` / `0xeff8000`)**: `panel-gs-rgea` (`google,gs-rgea`, `panel_id = 0x48c09009`, `/chosen` `"2152x2076@60:60"`, live `2076x2152` @ `120 Hz` ARR, `ROTATION_90`).
    - **Outer cover panel (`panel@1` on `dsi2host@3d8000` / `0xefd8000`)**: `panel-gs-rgeb` (`google,gs-rgeb`, `panel_id = 0x46a0a00a`, `1080x2364` @ `120/60 Hz`).
  - No `simple-framebuffer` or splash node exists in stock `/chosen` or `/reserved-memory` (`SIMPLEFB_TRIG_CON` stays unset).
- **Dual SPI Touch Controllers** `[V]`:
  - Inner: `/spi@db21000/touchscreen@0` (`0xdb23000`, `st,fst2`, `fst2.ko`, `2076x2152`, `st_fts_c13.ubin`).
  - Cover: `/spi@db31000/touchscreen@0` (`0xdb33000`, `synaptics,tcm-spi`, `syna_touch.ko`, `goog,offload-device-name = "outer"`, `synaptics.img`).
- **Hall / Fold Sensor, Keys & Fingerprint** `[V]`:
  - `/hall_sensor`: `compatible = "hall,drv5032"` on CPM pinctrl (`0x5280000` pin `0x38`, `XCPM_EINT_16`; stock DT carries typo property `staus = "ok"`).
  - `/gpio_keys`: Power (`0x30`), Volume Down (`0x33`), Volume Up (`0x34`) on CPM pinctrl.
  - Fingerprint: `goodixfp` (`goodix,fingerprint`) instead of `mustang`'s ultrasonic `qcom,qbt-handler`.

---

## 4. Storage Layout & Slot A Recovery Gate (`rango` 1 TB Zoned UFS)

- **UFS LUNs (`sda`–`sde`)** `[V]`: Adds LUN 4 (`/dev/block/sde` -> `zoned_device`, `host-managed`, ~903.1 GiB) alongside `sda` (~49.9 GiB main + `userdata` ~32.4 GiB), `sdb`/`sdc` (64 MiB Slot A/B early firmware), and `sdd` (4 MiB `devinfo`, `pinfo`, `blenv`, `mfg_data`, `rdbl`). `device/rango/device.conf` keeps `UFS_RW_LUNS` unset so `sdb`/`sdc`/`sdd`/`sde` remain read-only at the block layer (`UFS_RW="boot_b init_boot_b vendor_boot_b vendor_kernel_boot_b dtbo_b userdata"`).
- **CRITICAL SLOT A WARNING** `[V]`: Captured `bootctl` reports Slot A (`_a`) `is-slot-bootable = 0` (`UNBOOTABLE`) and `abl_a` (`deepspace-17.4-16025385`) is older than `abl_b` (`deepspace-17.4-16119390`), with `_a != _b` across all early bootloader/firmware partitions. Per `CONTRIBUTING.md` §3.1 and `docs/RELEASES.md` §3, sync Slot A to `16119390` via full OTA and back up NV/calibration partitions before any Slot B flash.
