-- SPDX-License-Identifier: MIT
-- Pixel 10 Pro XL (mustang, laguna):
-- DSI-1 (VeriSilicon dc9x00 pipe0): google-mtea 1344x2992@60 -> 420x935 logical at scale 3.2
local omarchy_monitor_scale = 3.2
hl.monitor({ output = "DSI-1", mode = "preferred", position = "0x0", scale = omarchy_monitor_scale, disabled = false })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

local omarchy_gdk_scale = 3
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
