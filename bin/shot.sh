#!/bin/env sh

scrot -q 40 -s -e 'xclip -selection clipboard -t image/png -i $f'
