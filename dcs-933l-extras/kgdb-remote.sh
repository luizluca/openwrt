#!/bin/sh
#
# Connects to the remote target, setup the kgdb serial interface and trigger debug
#
target=192.168.3.6
ssh -x root@$target 'for mod in /sys/module/*/sections/.text ; do modname=$(basename $(dirname $(dirname "$mod"))); modfile=$(ls /lib/modules/$(uname -r)/ | sed -e "h;s/-/_/g;G;s/\n/\t/" | grep "^$modname.ko" | cut -f2); echo add-symbol-file /home/luizluca/prog-local/lede/trunk/debug/modules/$modfile $(cat $mod); done' > /dev/shm/loadable_modules.txt
ssh -x root@$target "echo ttyS0,57600 > /sys/module/kgdboc/parameters/kgdboc"
ssh -f -x root@$target "echo g > /proc/sysrq-trigger"
