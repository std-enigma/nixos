-- Managed by NixOS. Personal additions go in ~/.config/hypr/local.lua.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.config({
    input = { kb_layout = "us", touchpad = { natural_scroll = true } },
    general = { gaps_in = 5, gaps_out = 10, border_size = 2, layout = "dwindle" },
    decoration = { rounding = 12, blur = { enabled = true, size = 3, passes = 2 } },
    misc = { disable_hyprland_logo = true },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm finalize")
    hl.exec_cmd("uwsm app -- noctalia")
    hl.exec_cmd("xdg-user-dirs-update")
end)

local function command(key, cmd)
    hl.bind(key, hl.dsp.exec_cmd(cmd))
end
command("SUPER + Return", "uwsm app -- kitty")
command("SUPER + E", "uwsm app -- thunar")
command("SUPER + B", "uwsm app -- firefox")
command("SUPER + Space", "noctalia msg panel-toggle launcher")
command("SUPER + S", "noctalia msg panel-toggle control-center")
command("SUPER + comma", "noctalia msg settings-toggle")
command("SUPER + L", "noctalia msg session lock")
command("SUPER + SHIFT + E", "uwsm stop")
command("Print", "noctalia msg screenshot-region")
command("ALT + Tab", "noctalia msg window-switcher hold")
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))

for _, direction in ipairs({ "left", "right", "up", "down" }) do
    hl.bind("SUPER + " .. direction, hl.dsp.focus({ direction = direction }))
end
for workspace = 1, 10 do
    local key = tostring(workspace % 10)
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

for key, action in pairs({
    XF86AudioRaiseVolume = "volume-up",
    XF86AudioLowerVolume = "volume-down",
    XF86AudioMute = "volume-mute",
    XF86MonBrightnessUp = "brightness-up",
    XF86MonBrightnessDown = "brightness-down",
}) do
    command(key, "noctalia msg " .. action)
end
command("XF86AudioPlay", "playerctl play-pause")
command("XF86AudioNext", "playerctl next")
command("XF86AudioPrev", "playerctl previous")

-- Do not animate shell surfaces twice.
hl.layer_rule({
    name = "noctalia",
    match = { namespace = "^noctalia-.*$" },
    no_anim = true,
    blur = true,
    ignore_alpha = 0.5,
})

local configHome = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
local override = configHome .. "/hypr/local.lua"
local file = io.open(override, "r")
if file then
    file:close()
    dofile(override)
end
