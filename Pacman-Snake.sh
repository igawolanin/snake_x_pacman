#!/bin/sh
printf '\033c\033]0;%s\a' Pacman-Snake
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Pacman-Snake.x86_64" "$@"
