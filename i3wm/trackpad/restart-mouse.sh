sudo modprobe -r psmouse && \
sudo modprobe  psmouse && \
xinput set-prop "Synaptics TM3383-002" "libinput Tapping Enabled" 1

