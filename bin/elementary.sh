#!/bin/sh
# This script created by AQEMU
/usr/bin/qemu-system-x86_64  -soundhw ac97 -machine accel=kvm -smp cpus=2 -m 2048 -hda "/home/alexcleac/VM/elementary.raw" -boot once=c,menu=off -nic user -rtc base=localtime -name "Elementary OS" -display gtk -sdl -vga virtio $*
