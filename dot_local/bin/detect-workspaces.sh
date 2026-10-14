#!/usr/bin/env bash
set -uo pipefail

HYPR_DIR="$HOME/.config/hypr"
PROJECT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../.." && pwd)"
PROFILE_MAP="$HYPR_DIR/monitor-profile-map.conf"
DEFAULT_MONITORS="$PROJECT_DIR/dot_config/hypr/monitors-default.conf"
DEFAULT_WORKSPACES="$PROJECT_DIR/dot_config/hypr/workspaces-default.conf"
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
STATE_FILE="$RUNTIME_DIR/hypr-octavius-monitor-signature-$UID"
CONFIG_STATE_FILE="$RUNTIME_DIR/hypr-octavius-monitor-config-$UID"
LOCK_FILE="$RUNTIME_DIR/hypr-octavius-monitor-profile-$UID.lock"

mkdir -p "$HYPR_DIR/workspace-profiles" 2>/dev/null || true
exec 9>"$LOCK_FILE"
flock -w 35 9 || exit 0

snapshot=""
previous=""
stable_count=0
for ((attempt = 0; attempt < 30; attempt++)); do
    current="$(hyprctl monitors all -j 2>/dev/null | jq -c '
        [.[] | select(.disabled == false) |
            {name, description, width, height, refreshRate, scale}
        ] | sort_by(.name)' 2>/dev/null || true)"

    if [[ -n "$current" && "$current" != "[]" ]]; then
        if [[ "$current" == "$previous" ]]; then
            ((stable_count += 1))
        else
            previous="$current"
            stable_count=1
        fi

        if ((stable_count >= 3)); then
            snapshot="$current"
            break
        fi
    else
        previous=""
        stable_count=0
    fi
    sleep 1
done

if [[ -z "$snapshot" ]]; then
    logger -t octavius-monitor-profile \
        "No stable active-monitor list; keeping the current profile" 2>/dev/null || true
    exit 0
fi

descriptions="$(jq -r '.[].description' <<<"$snapshot")"
profile=""
ambiguous=0
if [[ -r "$PROFILE_MAP" ]]; then
    while IFS='|' read -r candidate pattern; do
        candidate="${candidate%%#*}"
        [[ -z "$candidate" || -z "${pattern:-}" ]] && continue
        [[ "$candidate" =~ ^[A-Za-z0-9_-]+$ ]] || continue

        if grep -Eiq -- "$pattern" <<<"$descriptions"; then
            if [[ -n "$profile" && "$profile" != "$candidate" ]]; then
                ambiguous=1
                break
            fi
            profile="$candidate"
        fi
    done < "$PROFILE_MAP"
fi

if ((ambiguous)); then
    profile=""
    logger -t octavius-monitor-profile \
        "Monitor profile map matched multiple profiles; using generic defaults" \
        2>/dev/null || true
fi

monitor_source="$DEFAULT_MONITORS"
workspace_source="$DEFAULT_WORKSPACES"
if [[ -n "$profile" ]]; then
    local_monitors="$HYPR_DIR/monitors-$profile.conf"
    local_workspaces="$HYPR_DIR/workspace-profiles/$profile.conf"
    [[ -r "$local_monitors" ]] && monitor_source="$local_monitors"
    [[ -r "$local_workspaces" ]] && workspace_source="$local_workspaces"
fi

if [[ ! -r "$monitor_source" || ! -r "$workspace_source" ]]; then
    logger -t octavius-monitor-profile \
        "A selected profile or generic fallback file is missing" 2>/dev/null || true
    exit 1
fi

link_changed=0
if [[ "$(readlink -f "$monitor_source" 2>/dev/null || true)" != \
      "$(readlink -f "$HYPR_DIR/monitors.conf" 2>/dev/null || true)" ]]; then
    ln -sfn "$monitor_source" "$HYPR_DIR/monitors.conf"
    link_changed=1
fi
if [[ "$(readlink -f "$workspace_source" 2>/dev/null || true)" != \
      "$(readlink -f "$HYPR_DIR/workspaces.conf" 2>/dev/null || true)" ]]; then
    ln -sfn "$workspace_source" "$HYPR_DIR/workspaces.conf"
    link_changed=1
fi

monitor_identity="$(readlink -f "$monitor_source")|$(stat -c '%Y' "$monitor_source")"
workspace_identity="$(readlink -f "$workspace_source")|$(stat -c '%Y' "$workspace_source")"
desired_config="$monitor_identity"$'\n'"$workspace_identity"
config_changed=0
if ((link_changed)) || [[ ! -r "$CONFIG_STATE_FILE" ]] ||
   [[ "$(<"$CONFIG_STATE_FILE")" != "$desired_config" ]]; then
    config_changed=1
fi

signature_changed=0
if [[ ! -r "$STATE_FILE" ]] ||
   [[ "$(<"$STATE_FILE")" != "$snapshot" ]]; then
    signature_changed=1
fi

if ((config_changed)); then
    if ! hyprctl reload; then
        logger -t octavius-monitor-profile \
            "Hyprland reload failed after selecting profile ${profile:-default}" \
            2>/dev/null || true
        exit 1
    fi
    printf '%s\n' "$desired_config" > "$CONFIG_STATE_FILE"
fi

printf '%s\n' "$snapshot" > "$STATE_FILE"

if ! pgrep -x waybar >/dev/null 2>&1; then
    "$HOME/.local/bin/start-waybar" >/dev/null 2>&1 &
    disown || true
fi

if ((config_changed || signature_changed)); then
    if [[ -x "$HYPR_DIR/start-wall.sh" ]]; then
        "$HYPR_DIR/start-wall.sh" >/dev/null 2>&1 &
        disown || true
    fi
    logger -t octavius-monitor-profile \
        "Applied ${profile:-generic} profile for the active monitor set" \
        2>/dev/null || true
fi
