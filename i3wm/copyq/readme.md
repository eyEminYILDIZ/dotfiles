# CopyQ on Ubuntu 24.04 with i3 on X11.

1. Install

sudo apt update
sudo apt install copyq xdotool
xdotool lets CopyQ paste into the active window when you press Enter.

2. First run and autostart

Start it once:
copyq &
Add this line to ~/.config/i3/config so it starts with i3:
exec --no-startup-id copyq

3. i3 keybinding to open the list

Add this line to ~/.config/i3/config. Check that $mod+v isn't already used in that file.
bindsym $mod+v exec --no-startup-id copyq toggle
Reload i3 with $mod+Shift+r.

4. Optional: make the list float

Without this, i3 tiles the CopyQ window. Add these lines to the same config file:
for_window [class="copyq"] floating enable, resize set 700 500, move position center
Reload i3 again.

5. CopyQ settings

Right-click the tray icon and choose Preferences (or press Ctrl+P in the CopyQ window).

- General: tick Autostart if it's offered (you can skip it, since i3 handles that).
- History: set Maximum number of items to something like 500. Tick Automatically paste or Paste to current window (the wording varies by version).
- Layout: untick Show tree for tabs and the toolbar if you want a minimal window.
- Shortcuts: check the Global tab. You can set the show/hide shortcut here instead of using the i3 binding. Pick one of the two, not both.

6. Daily use (no mouse)

1. Copy things normally with Ctrl+C.
2. Press $mod+v to open the history.
3. Type to filter, then use ↑/↓ to move.
4. Press Enter to paste into the previous window.
5. Alt+1 to Alt+9 picks an item by its number.
6. Ctrl+P pins an item, Delete removes it, and Esc closes the list.

7. Test

Copy "one", "two" and "three" in a text editor. Press $mod+v and select "one", aste into the editor.

If Enter doesn't paste automatically, xdotool is missing, or auto-paste is off
