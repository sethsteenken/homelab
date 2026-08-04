#!/bin/bash

DISCORD_URL="DISCORD_WEBHOOK_URL_HERE"

send_to_discord() {
    local message="$1"
    local timestamp=$(date +"%H:%M:%S")
    local full_message="$message [$timestamp]"
    curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$full_message\"}" "$DISCORD_URL"
}

case $1 in
    # --- TIMER EXPIRATION ---
    early-shutdown)
        send_to_discord "⚠️ **UPS Update:** On battery for some time. Initializing early shutdown."
        /usr/local/bin/shutdown-unas.sh
        ;;

    shutdown)
        /usr/local/bin/shutdown-udm.sh
        ;;

    # --- INSTANT DISCORD STATE NOTIFICATIONS ---
    discord-online)
        send_to_discord "✅ **UPS Update:** Power restored!"
        ;;
    discord-onbatt)
        send_to_discord "🔋 **UPS Alert:** Power lost! UPS is running on battery."
        ;;
    discord-lowbatt)
        send_to_discord "🚨 **UPS Critical:** UPS battery is low! Initializing system shutdown."
        ;;
    discord-commok)
        send_to_discord "🟢 **UPS Update:** Communications online!"
        ;;
    discord-commbad)
        send_to_discord "🔴 **UPS Warning:** Communications lost!"
        ;;
    discord-nocomm)
        send_to_discord "⚫ **UPS Alert:** No communications with UPS!"
        ;;
    discord-noparent)
        send_to_discord "⚫ **UPS Alert:** No parent UPS detected!"
        ;;
    discord-replbatt)
        send_to_discord "🗑️ **UPS Update:** Replacement battery installed."
        ;;
    discord-shutdown)
        send_to_discord "💀 **UPS Shutdown:** Full system shutdown initiated."
        ;;
    discord-fsd)
        send_to_discord "☣️ **UPS Critical:** Forced Shutdown (FSD) initiated."
        ;;
    *)
        logger -t upssched "Unknown event received: $1"
        ;;
esac