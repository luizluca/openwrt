#!/bin/sh
#
# Load ov740 firmware
#

FIRMWARE=/lib/firmware/ov780spi_fw.bin
DEV=/dev/spidev1.0

die() {
	local err=$1; shift
	warn "$@"
	exit $err
}

warn() {
	echo "$@" >&2
}

which spi-config || die 1 "spi-config not found! Please install spi-tools"
which spi-pipe || die 1 "spi-pipe not found! Please install spi-tools"

# TODO: Lock SPI? Can we lock dev file?

# TODO: What is the system clock rate?
SYSTEM_CLOCK_RATE=133333248 # 133Mhz? From where I get this?

echo "in" > /sys/class/gpio/ov780_boot_in/direction

# TODO: 1 or 0?
echo 1 > /sys/class/gpio/ov780_spi_out/value

# Default state: /dev/spidev1.0: mode=3, lsb=0, bits=8, speed=10000000
# TODO: spi-config seems to be buggy or spidev is not working.
#       Defined configs does not show in "-q"
spi-config -d $DEV -l 0 -m 3 -s $((SYSTEM_CLOCK_RATE / 128)) ||
	die 1 "Failed to setup spidev1.0"

# TODO: sequence of set/unset (values are unknown)?
echo 0 > /sys/class/gpio/chip_reset/value
sleep 1 # should be 0.2
echo 1 > /sys/class/gpio/chip_reset/value
sleep 1 # should be 0.2
echo 0 > /sys/class/gpio/chip_reset/value
# should be 0.1
sleep 1

# TODO: Booted? 0 or 1?
booted=$(cat /sys/class/gpio/ov780_boot_in/value)

if [ "$booted" == 0 ] ; then
	{	
		# TODO discover header
		# TODO should we send it in a individual spi-pipe?
		echo -n "8 unknown bytes..."
		cat "$FIRMWARE"
	} | spi-pipe -d $DEV -b 4096
else
	# TODO: hum?
	return #?
fi

ok=false
for try in $(seq 10); do
	booted=$(cat /sys/class/gpio/ov780_boot_in/value)
	if [ "$booted" == 1 ]; then
		echo "Firmware ready!"
		break
	fi
done
if ! $ok; then
	die 1 "Failed to load firmware!"
fi

spi-config -d $DEV -l 0 -m 3 -s $((SYSTEM_CLOCK_RATE / 2)) ||
	die 1 "Failed to setup spidev1.0"

# Change the direction for what? Another consumer?
echo "out" > /sys/class/gpio/ov780_boot_in/direction
echo 1 > /sys/class/gpio/ov780_boot_in/value

# TODO: Unlock SPI?
