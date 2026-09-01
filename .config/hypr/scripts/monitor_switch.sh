#!/usr/bin/env bash

# Monitor profile controller for Hyprland's Lua configuration API.
#
# Usage:
#   monitor_switch.sh daemon          # startup + hotplug listener
#   monitor_switch.sh menu            # interactive Rofi profile menu
#   monitor_switch.sh status          # Waybar JSON
#   monitor_switch.sh external-only
#   monitor_switch.sh extend
#   monitor_switch.sh extend-left
#   monitor_switch.sh mirror
#   monitor_switch.sh laptop-only

set -u

readonly WALLPAPER="/home/jrp/arch-hyprland-setup/wallpaper2.jpg"
readonly RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
readonly STATE_FILE="$RUNTIME_DIR/hypr-monitor-profile"
readonly LOCK_FILE="$RUNTIME_DIR/hypr-monitor-controller.lock"

monitor_data() {
    hyprctl monitors all -j 2>/dev/null
}

laptop_output() {
    jq -r '[.[] | select(.name | startswith("eDP-"))][0].name // empty'
}

external_outputs() {
    jq -r '.[] | select((.name | startswith("eDP-")) | not) | .name'
}

valid_output_name() {
    [[ "$1" =~ ^[[:alnum:]_.:-]+$ ]]
}

monitor_rule() {
    local output="$1"
    local fields="$2"

    valid_output_name "$output" || return 1
    printf 'hl.monitor({ output = "%s", %s })' "$output" "$fields"
}

apply_lua() {
    local code="$1"
    local result

    if ! result="$(hyprctl eval "$code" 2>&1)"; then
        notify-send -u critical "Monitor profile failed" "$result"
        return 1
    fi
}

apply_wallpaper() {
    if pgrep -x hyprpaper >/dev/null 2>&1; then
        sleep 0.4
        hyprctl hyprpaper wallpaper ",$WALLPAPER" >/dev/null 2>&1 || true
    fi
}

refresh_waybar() {
    pkill -RTMIN+8 waybar 2>/dev/null || true
}

profile_label() {
    case "$1" in
        external-only) printf 'External only' ;;
        extend)        printf 'Extend right' ;;
        extend-left)   printf 'External left' ;;
        mirror)        printf 'Duplicate' ;;
        laptop-only)   printf 'Laptop only' ;;
        *)             printf 'Display' ;;
    esac
}

apply_profile() {
    local profile="$1"
    local data laptop code output position
    local -a externals=()

    data="$(monitor_data)" || return 1
    laptop="$(laptop_output <<<"$data")"
    mapfile -t externals < <(external_outputs <<<"$data")

    if [[ -z "$laptop" ]]; then
        notify-send -u critical "Monitor profile failed" "No laptop display was detected."
        return 1
    fi

    if [[ ${#externals[@]} -eq 0 && "$profile" != "laptop-only" ]]; then
        profile="laptop-only"
        notify-send "Monitor profile" "No external display is connected; using the laptop display."
    fi

    printf '%s\n' "$profile" > "$STATE_FILE"
    code=""

    case "$profile" in
        external-only)
            position="0x0"
            for output in "${externals[@]}"; do
                code+="$(monitor_rule "$output" "mode = \"preferred\", position = \"$position\", scale = 1, mirror = \"\", disabled = false")"$'\n'
                position="auto"
            done
            # Always enable another output before removing the laptop output.
            code+="$(monitor_rule "$laptop" "disabled = true")"
            ;;

        extend)
            code+="$(monitor_rule "$laptop" "mode = \"preferred\", position = \"0x0\", scale = 1, mirror = \"\", disabled = false")"$'\n'
            for output in "${externals[@]}"; do
                code+="$(monitor_rule "$output" "mode = \"preferred\", position = \"auto\", scale = 1, mirror = \"\", disabled = false")"$'\n'
            done
            ;;

        extend-left)
            position="0x0"
            for output in "${externals[@]}"; do
                code+="$(monitor_rule "$output" "mode = \"preferred\", position = \"$position\", scale = 1, mirror = \"\", disabled = false")"$'\n'
                position="auto"
            done
            # The laptop is enabled last so automatic placement puts it to the
            # right of the external display(s).
            code+="$(monitor_rule "$laptop" "mode = \"preferred\", position = \"auto\", scale = 1, mirror = \"\", disabled = false")"$'\n'
            ;;

        mirror)
            code+="$(monitor_rule "$laptop" "mode = \"preferred\", position = \"0x0\", scale = 1, mirror = \"\", disabled = false")"$'\n'
            for output in "${externals[@]}"; do
                code+="$(monitor_rule "$output" "mode = \"preferred\", position = \"0x0\", scale = 1, mirror = \"$laptop\", disabled = false")"$'\n'
            done
            ;;

        laptop-only)
            code+="$(monitor_rule "$laptop" "mode = \"preferred\", position = \"0x0\", scale = 1, mirror = \"\", disabled = false")"$'\n'
            for output in "${externals[@]}"; do
                code+="$(monitor_rule "$output" "disabled = true")"$'\n'
            done
            ;;

        *)
            notify-send -u critical "Monitor profile failed" "Unknown profile: $profile"
            return 2
            ;;
    esac

    apply_lua "$code" || return 1
    apply_wallpaper
    refresh_waybar
    notify-send -t 1800 "Monitor profile" "$(profile_label "$profile")"
}

current_profile() {
    local data profile

    data="$(monitor_data)" || {
        printf 'unknown'
        return
    }

    if [[ -z "$(external_outputs <<<"$data")" ]]; then
        printf 'laptop-only'
    elif [[ -r "$STATE_FILE" ]]; then
        IFS= read -r profile < "$STATE_FILE"
        printf '%s' "$profile"
    else
        printf 'external-only'
    fi
}

show_status() {
    local profile label tooltip

    profile="$(current_profile)"
    label="$(profile_label "$profile")"
    printf -v tooltip \
        'Monitor profile: %s\nLeft click: choose profile\nRight click: external only' \
        "$label"

    jq -cn \
        --arg text "󰍹" \
        --arg tooltip "$tooltip" \
        --arg class "$profile" \
        '{text: $text, tooltip: $tooltip, class: $class}'
}

show_menu() {
    local selection profile

    selection="$(printf '%s\n' \
        '󰍹  External only (default)' \
        '󰹑  Extend — external on right' \
        '󰹑  Extend — external on left' \
        '󰍺  Duplicate / mirror' \
        '󰌢  Laptop only' |
        rofi -dmenu -i -p 'Monitor profile')" || return 0

    case "$selection" in
        *'External only'*)      profile="external-only" ;;
        *'external on right'*)  profile="extend" ;;
        *'external on left'*)   profile="extend-left" ;;
        *'Duplicate / mirror'*) profile="mirror" ;;
        *'Laptop only'*)        profile="laptop-only" ;;
        *) return 0 ;;
    esac

    apply_profile "$profile"
}

handle_hotplug() {
    local data profile
    data="$(monitor_data)" || return 1

    if [[ -n "$(external_outputs <<<"$data")" ]]; then
        profile="$(current_profile)"
        apply_profile "$profile"
    else
        apply_profile laptop-only
        # The next external connection should again default to external-only.
        printf '%s\n' external-only > "$STATE_FILE"
    fi
}

run_daemon() {
    local socket line

    exec 9>"$LOCK_FILE"
    flock -n 9 || return 0

    # A new Hyprland session always defaults to external-only when docked.
    printf '%s\n' external-only > "$STATE_FILE"
    handle_hotplug

    socket="$RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE:?}/.socket2.sock"
    while true; do
        while IFS= read -r line; do
            case "$line" in
                monitoradded*|monitorremoved*)
                    sleep 0.6
                    handle_hotplug
                    ;;
            esac
        done < <(socat -U - "UNIX-CONNECT:$socket")
        sleep 1
    done
}

case "${1:-daemon}" in
    daemon)           run_daemon ;;
    menu)             show_menu ;;
    status)           show_status ;;
    external-only)    apply_profile external-only ;;
    extend)           apply_profile extend ;;
    extend-left)      apply_profile extend-left ;;
    mirror|duplicate) apply_profile mirror ;;
    laptop-only)      apply_profile laptop-only ;;
    *)
        printf 'Usage: %s {daemon|menu|status|external-only|extend|extend-left|mirror|laptop-only}\n' "$0" >&2
        exit 2
        ;;
esac
