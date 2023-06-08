LEDS_MENU:=LED modules

define KernelPackage/leds-reset
  SUBMENU:=$(LEDS_MENU)
  TITLE:=reset controller LED support
  DEPENDS:= @TARGET_ath79
  KCONFIG:=CONFIG_LEDS_RESET=m
  FILES:=$(LINUX_DIR)/drivers/leds/leds-reset.ko
  AUTOLOAD:=$(call AutoLoad,60,leds-reset,1)
endef

define KernelPackage/leds-reset/description
 Kernel module for LEDs on reset lines
endef

$(eval $(call KernelPackage,leds-reset))


NETWORK_DEVICES_MENU:=Network Devices

define KernelPackage/ag71xx
  SUBMENU:=$(NETWORK_DEVICES_MENU)
  TITLE:=Atheros AR7XXX/AR9XXX built-in ethernet mac support
  KCONFIG:=CONFIG_AG71XX \
	   CONFIG_AG71XX_DEBUG_FS=y
  FILES:=$(LINUX_DIR)/drivers/net/ethernet/atheros/ag71xx/ag71xx.ko \
	 $(LINUX_DIR)/drivers/net/ethernet/atheros/ag71xx/ag71xx_mdio.ko
  AUTOLOAD:=$(call AutoLoad,50,ag71xx ag71xx_mdio,1)
endef

define KernelPackage/ag71xx/description
  Atheros AR7XXX/AR9XXX built-in ethernet mac support
endef

$(eval $(call KernelPackage,ag71xx))
