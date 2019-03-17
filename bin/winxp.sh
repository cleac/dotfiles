#!/bin/sh
# This script created by AQEMU
/usr/bin/qemu-system-x86_64 -soundhw ac97 -machine accel=kvm -m 512 -cdrom "/home/alexcleac/Завантажене/OS/en_windows_xp_professional_with_service_pack_3_x86_cd_vl_x14-73974.iso" -hda "/home/alexcleac/VM/winxp.raw" -boot once=cd,menu=off -nic user -rtc base=localtime -name "Windows XP" -display gtk -sdl  $*
