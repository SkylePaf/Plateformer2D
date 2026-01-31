#!/bin/sh
printf '\033c\033]0;%s\a' Platformer2D1_1
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Platformer2D1_1.x86_64" "$@"
