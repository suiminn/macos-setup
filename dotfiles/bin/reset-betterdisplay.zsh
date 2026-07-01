#!/bin/zsh

if pgrep -x "BetterDisplay" >/dev/null; then
    killall "BetterDisplay" 2>/dev/null
fi

bundle_id=$(osascript -e 'id of app "BetterDisplay"' 2>/dev/null)
if [[ -z "${bundle_id}" ]]; then
    exit 1
fi

plist_key=$(
    defaults read "${bundle_id}" 2>/dev/null \
    | grep -Eo 'Paddle-Better[[:space:]]*Display-[0-9]{6}-SD|Paddle-BetterDisplay-[0-9]{6}-SD' \
    | head -n 1
)

app_support_dir="$HOME/Library/Application Support/BetterDisplay"
if [[ -d "${app_support_dir}" ]]; then
    rm -f "${app_support_dir}"/*.(padl|spadl)(N)
fi

if [[ -n "${plist_key}" ]]; then
    defaults delete "${bundle_id}" "${plist_key}" 2>/dev/null
fi

open -a "BetterDisplay"
