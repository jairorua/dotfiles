#!/usr/bin/env bash

# Define monitor names
LAPTOP="eDP-1"
EXTERNAL="HDMI-A-1"

function handle_monitors {
    # Check if the external monitor is connected
    if hyprctl monitors all | grep -q "Monitor $EXTERNAL"; then
        # External is connected: enable external, disable laptop
        hyprctl keyword monitor "$EXTERNAL, preferred, auto, 1"
        hyprctl keyword monitor "$LAPTOP, disable"
    else
        # External is disconnected: enable laptop
        hyprctl keyword monitor "$LAPTOP, preferred, auto, 1"
    fi
    
    # Optional: If you notice your Waybar disappears after switching monitors,
    # uncomment the next two lines to restart it automatically.
    # killall waybar
    # waybar & disown
}

# Run once on startup to set the correct initial state
handle_monitors

# Listen to Hyprland's socket for hotplug events
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    if [[ "$line" == monitoradded* ]] || [[ "$line" == monitorremoved* ]]; then
        # Slight delay to let Hyprland register the hardware before switching
        sleep 0.5
        handle_monitors
    fi
done
