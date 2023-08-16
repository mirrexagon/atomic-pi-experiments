#!/usr/bin/env bash
set -eo pipefail

hostname="$1"
address="$2"
action="$3"

if [ -z "$hostname" -o -z "$address" -o -z "$action" ]; then
    echo "Usage: $0 <hostname> <address> <copy|switch|boot|test|dry-activate|reboot> [extra build options]" >&2
    exit 1
fi

shift 3
set -u

if [ ! \( "$action" = copy -o "$action" = switch -o "$action" = boot -o "$action" = test -o "$action" = dry-activate -o "$action" = reboot \) ]; then
    echo "Action must be one of copy, switch, boot, test, dry-activate, or reboot." >&2
    exit 1
fi

reboot=
if [ "$action" = reboot ]; then
    action=boot
    reboot=1
fi

full_path_to_script="$(readlink -f ${0})"
repo_dir="$(dirname ${full_path_to_script})"

profile_dir=/nix/var/nix/profiles/system

echo "Building and copying system closure..."

system_closure="$(nix build .#nixosConfigurations.${hostname}.config.system.build.toplevel --no-link --json | jq --raw-output .[0].outputs.out)"
echo "System closure built: $system_closure"

nix copy --to ssh://${address} "${system_closure}"

if [ "$action" != copy ]; then
    echo "Setting closure as current system on $address and activating with $action."
    command="sudo nix-env -p $profile_dir --set $system_closure && sudo $profile_dir/bin/switch-to-configuration $action"

    if [ -n "$reboot" ]; then
        echo "Will reboot target."
        command="$command && sudo reboot"
    fi

    ssh -t "$address" "$command"
fi

echo "Done."
