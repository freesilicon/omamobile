<!-- SPDX-License-Identifier: MIT -->
# omamobile-device-rango

Omamobile userspace support package for the Google Pixel 10 Pro Fold (codename `rango`, Tensor G5 / `laguna`). It continues the read-only UFS storage guard in Arch (including LUN 4 `sde` `zoned_device`), configures USB gadget networking, disables lid-switch suspend in `systemd-logind`, provides the live-verified dual-display `SW_LID` Hyprland monitor config (`DSI-1` cover `1080x2364@60` `scale = 2.4`, `DSI-2` inner `2152x2076@60` `scale = 2` **`transform = 3`**) and `omamobile-rango-lid-sync` helper, and ships the non-secret owner-extracted firmware manifest.

It does not mark a boot slot successful, enable radio/charger/camera units at boot, or ship any proprietary firmware blobs (`CONTRIBUTING.md` §7).

| Path | Installs to | What it does |
| --- | --- | --- |
| `vendor/udev/rules.d/10-omamobile-storage.rules` | `/usr/lib/udev/rules.d` | Hides `sda` (`MODE="0000"`), `sd[b-e]` (including LUN 4 `sde` zoned_device), and every Android partition except `userdata` from desktop tools |
| `vendor/udev/rules.d/70-omamobile-dma-heap.rules` | `/usr/lib/udev/rules.d` | Grants `video` / `uaccess` permissions on `/dev/dma_heap/{system,reserved,default_cma_region}` |
| `vendor/systemd/network/20-usb-gadget.network` | `/usr/lib/systemd/network` | Configures `usb0` (`172.16.42.1/24`, gateway `172.16.42.2`, `Metric=2000`) |
| `vendor/systemd/logind.conf.d/10-omamobile-lid.conf` | `/usr/lib/systemd/logind.conf.d` | Prevents `systemd-logind` from suspending when the fold is closed |
| `vendor/systemd/logind.conf.d/10-omamobile-power-key.conf` | `/usr/lib/systemd/logind.conf.d` | Keeps a short power press handled by Omarchy instead of powering off |
| `vendor/systemd/system.conf.d/10-omamobile-reboot-watchdog.conf` | `/usr/lib/systemd/system.conf.d` | Sets `RebootWatchdogSec=1min` so shutdown hangs recover cleanly |
| `vendor/systemd/system/omamobile-modem.service.d/10-laguna-no-start.conf` | `/usr/lib/systemd/system/omamobile-modem.service.d` | Keeps modem starter disabled by default until Laguna `cpif` lands and owner opts in (zero NV/EFS writes) |
| `vendor/systemd/system/omamobile-sitd.service.d/10-device-modem.conf` | `/usr/lib/systemd/system/omamobile-sitd.service.d` | Opt-in `omamobile-sitd-policy` (`Requisite=omamobile-modem.service`, gated on `/etc/omamobile/laguna-modem-enable` + `/dev/umts_ipc0`) so `omamobile-modem-sit` installs cleanly without auto-starting |
| `vendor/NetworkManager/conf.d/10-omamobile-usb.conf` | `/usr/lib/NetworkManager/conf.d` | Keeps NetworkManager off `usb0` |
| `uwsm/env.d/omamobile-laguna-graphics` | `/usr/share/uwsm/env.d` | Defaults to `llvmpipe`/`kms_swrast` (+ `AQ_NO_AUX_RENDERER=1` without a render node); opt-in PowerVR Volcanic via `/etc/omamobile/pvr-volcanic-enable` |
| `vendor/hypr/monitors.lua` | `/usr/share/omamobile/device-rango/hypr/monitors.lua` | Live-verified Hyprland Lua dual-display & `SW_LID` fold switching (`DSI-1` cover `scale = 2.4`, `DSI-2` inner `scale = 2`, `transform = 3`) |
| `bin/omamobile-rango-lid-sync` | `/usr/bin/omamobile-rango-lid-sync` | Queries `EV_SW SW_LID` (`evtest --query`) and synchronizes `DSI-1`/`DSI-2` via `hyprctl eval` |
| `vendor/firmware-manifest.tsv` | `/usr/share/omamobile/device-rango/firmware-manifest.tsv` | Clean-room manifest of owner-extracted firmware (`edgetpu-buenos.fw`, `dive_interp_rv64.bin`, `rgx.fw.signed`, Wi-Fi/BT/AoC) — zero blobs committed |
| `etc/omamobile-mirrorlist` | `/etc/pacman.d/omamobile-mirrorlist` | `[omamobile]` repository mirrorlist (same bytes as cheetah) |
| `omamobile-device-rango.install` | pacman hook | Adds `[omamobile]` to `pacman.conf` before `[omarchy]` |
| `src/reboot-to.c` | `/usr/bin/reboot-to` | Reboot with a bootloader reason (`reboot-to bootloader`) |
| `device.conf` | `/usr/share/omamobile/device.conf` | Device descriptor matching `device/rango/device.conf` |

`./build [DIR]` compiles `reboot-to`, `./install DESTDIR [DIR]` stages all files, and `./test/all` validates the package offline.
