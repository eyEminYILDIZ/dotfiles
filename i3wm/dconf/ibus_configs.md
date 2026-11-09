# IBUS Related Configurations

## Hide the IBUS Tray Icon

```sh
# Hide the IBus input-language icon ("EN") from the system tray
gsettings set org.freedesktop.ibus.panel show-icon-on-systray false

# Check the current value
gsettings get org.freedesktop.ibus.panel show-icon-on-systray

# Undo (show the icon again)
gsettings set org.freedesktop.ibus.panel show-icon-on-systray true
```

If the icon doesn't disappear right away, run ibus restart.
