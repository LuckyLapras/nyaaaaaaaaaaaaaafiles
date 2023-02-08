#!/bin/bash

export LC_ALL=C
#DEFAULT_OUTPUT=$(pactl info|sed -n -e 's/^.*Default Sink: //p')
#pactl load-module module-null-sink sink_name=chromium
#pactl load-module module-null-sink sink_name=desktop_audio
#pactl set-default-sink desktop_audio
#pactl load-module module-loopback source=desktop_audio.monitor sink=alsa_output.pci-0000_0a_00.3.analog-stereo
#pactl load-module module-loopback source=chromium.monitor sink=alsa_output.pci-0000_0a_00.3.analog-stereo
pactl load-module module-loopback source=alsa_input.pci-0000_0a_00.3.analog-stereo sink=alsa_output.pci-0000_0a_00.3.analog-stereo latency=5msec
#pactl load-module module-null-sink sink_name=cum
#pactl load-module module-loopback source=cum.monitor sink=alsa_output.pci-0000_0a_00.3.analog-stereo
