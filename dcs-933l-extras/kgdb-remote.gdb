set serial baud 57600
file /home/luizluca/prog-local/lede/trunk/debug/vmlinux
source /dev/shm/loadable_modules.txt
shell sleep 2
target remote /dev/ttyUSB0
