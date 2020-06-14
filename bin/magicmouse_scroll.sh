#!/bin/env sh

rmmod hid_magicmouse
modprobe hid_magicmouse emulate_3button=0 emulate_scroll_wheel=1 scroll_speed=27
