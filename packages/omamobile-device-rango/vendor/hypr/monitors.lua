-- SPDX-License-Identifier: MIT
-- Pixel 10 Pro Fold (rango, laguna):
-- DSI-1 (DSI0, dc9x00 pipe0): cover google-rgeb 1080x2364@60, scale 2.4, normal
-- DSI-2 (DSI1, dc9x00 pipe1): inner google-rgea 2152x2076@60, scale 2, transform = 3 (upright)
local omarchy_monitor_scale = 2.4
hl.monitor({ output = "DSI-1", mode = "preferred", position = "0x0", scale = omarchy_monitor_scale, disabled = false })
hl.monitor({ output = "DSI-2", mode = "preferred", position = "auto", scale = 2, transform = 3, disabled = false })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

local omarchy_gdk_scale = 2
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

local function activate_cover()
  hl.monitor({ output = "DSI-2", disabled = true })
  hl.monitor({ output = "DSI-1", mode = "preferred", position = "0x0", scale = 2.4, disabled = false })
end

local function activate_inner()
  hl.monitor({ output = "DSI-1", disabled = true })
  hl.monitor({ output = "DSI-2", mode = "preferred", position = "0x0", scale = 2, transform = 3, disabled = false })
end

-- Laguna DT exposes SW_LID on input device "gpio-keys" (bind "Lid Switch" too as fallback)
hl.bind("switch:on:gpio-keys", activate_cover, { locked = true })
hl.bind("switch:off:gpio-keys", activate_inner, { locked = true })
hl.bind("switch:on:Lid Switch", activate_cover, { locked = true })
hl.bind("switch:off:Lid Switch", activate_inner, { locked = true })
