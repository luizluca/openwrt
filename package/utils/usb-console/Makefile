include $(TOPDIR)/rules.mk

PKG_NAME:=usb-console
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/usb-console/Default
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Force USB Console and Built-in Drivers
  HIDDEN:=1
  DEPENDS:= \
    +TARGET_airoha_en7523:usb-console-airoha_en7523 \
    +TARGET_apm821xx:usb-console-apm821xx \
    +TARGET_at91_sama5:usb-console-at91_sama5 \
    +TARGET_at91_sama7:usb-console-at91_sama7 \
    +TARGET_ath79:usb-console-ath79 \
    +TARGET_bcm47xx:usb-console-bcm47xx \
    +TARGET_bcm4908:usb-console-bcm4908 \
    +TARGET_imx_cortexa9:usb-console-imx_cortexa9 \
    +TARGET_mediatek_mt7623:usb-console-mediatek_mt7623 \
    +TARGET_mediatek_mt7629:usb-console-mediatek_mt7629 \
    +TARGET_mpc85xx:usb-console-mpc85xx \
    +TARGET_mxs:usb-console-mxs \
    +TARGET_omap:usb-console-omap \
    +TARGET_ramips:usb-console-ramips \
    +TARGET_siflower_sf21:usb-console-siflower_sf21  
endef

define Package/usb-console
  $(Package/usb-console/Default)
  HIDDEN:=
  DEFAULT:=y
  KCONFIG:= \
    CONFIG_CMDLINE_BOOL=y \
    CONFIG_CMDLINE_EXTEND=y \
    CONFIG_CMDLINE_APPEND=y \
    CONFIG_USB=y \
    CONFIG_USB_COMMON=y \
    CONFIG_USB_OHCI_HCD=y \
    CONFIG_USB_OHCI_HCD_PLATFORM=y \
    CONFIG_USB_EHCI_HCD=y \
    CONFIG_USB_EHCI_ROOT_HUB_TT=y \
    CONFIG_USB_EHCI_TT_NEWSCHED=y \
    CONFIG_USB_EHCI_FSL=y \
    CONFIG_USB_EHCI_HCD_PLATFORM=y \
    CONFIG_USB_SERIAL=y \
    CONFIG_USB_SERIAL_CH341=y \
    CONFIG_USB_SERIAL_CONSOLE=y \
    CONFIG_USB_SERIAL_FTDI_SIO=y \
    CONFIG_USB_SERIAL_PL2303=y
endef

USB_CONSOLE_EXTRACONSOLE := console=ttyUSB0,115200

define Package/usb-console-airoha_en7523
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) rootfstype=squashfs,jffs2)"
  DEPENDS:=@TARGET_airoha_en7523
endef

define Package/usb-console-apm821xx
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) rootfstype=squashfs noinitrd)"
  DEPENDS:=@TARGET_apm821xx
endef

define Package/usb-console-at91_sama5
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) console=ttyS0,115200 initrd=0x21100000,25165824 root=/dev/ram0 rw)"
  DEPENDS:=@TARGET_at91_sama5
endef

define Package/usb-console-at91_sama7
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) console=ttyS0,115200 earlyprintk nocache ignore_loglevel)"
  DEPENDS:=@TARGET_at91_sama7
endef

define Package/usb-console-ath79
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) rootfstype=squashfs,jffs2)"
  DEPENDS:=@TARGET_ath79
endef

define Package/usb-console-bcm47xx
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) noinitrd console=ttyS0,115200)"
  DEPENDS:=@TARGET_bcm47xx
endef

define Package/usb-console-bcm4908
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) earlycon=bcm63xx_uart,0xff800640 console=ttyS0,115200)"
  DEPENDS:=@TARGET_bcm4908
endef

define Package/usb-console-imx_cortexa9
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) pci=nomsi)"
  DEPENDS:=@TARGET_imx_cortexa9
endef

define Package/usb-console-mediatek_mt7623
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) earlyprintk console=ttyS0,115200 rootfstype=squashfs,jffs2)"
  DEPENDS:=@TARGET_mediatek_mt7623
endef

define Package/usb-console-mediatek_mt7629
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) rootfstype=squashfs,jffs2)"
  DEPENDS:=@TARGET_mediatek_mt7629
endef

define Package/usb-console-mpc85xx
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) console=ttyS0,115200)"
  DEPENDS:=@TARGET_mpc85xx
endef

define Package/usb-console-mxs
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) console=ttyAMA0,115200 root=/dev/mmcblk0p2 rw rootwait)"
  DEPENDS:=@TARGET_mxs
endef

define Package/usb-console-omap
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) root=/dev/mmcblk0p2 rootwait console=ttyO2,115200)"
  DEPENDS:=@TARGET_omap
endef

define Package/usb-console-ramips
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) rootfstype=squashfs,jffs2)"
  DEPENDS:=@TARGET_ramips
endef

define Package/usb-console-siflower_sf21
  $(Package/usb-console/Default)
  KCONFIG:=CONFIG_CMDLINE="$(strip $(USB_CONSOLE_EXTRACONSOLE) root=/dev/fit0)"
  DEPENDS:=@TARGET_siflower_sf21
endef

define Package/usb-console/description
  This package injects kernel configurations to force USB and serial adapter
  drivers to be compiled natively (built-in) instead of loadable modules.
  It also prepends "console=ttyUSB0,115200" to the kernel command line
  and installs early preinit scripts to ensure the USB console initializes
  properly during the boot sequence. It also adds hotplug.d to deal with extra
  consoles if present.
endef

define Build/Compile
endef

define Package/usb-console/install
	$(INSTALL_DIR) $(1)/lib/preinit
	$(INSTALL_BIN) ./files/11_usbserial $(1)/lib/preinit/11_usbserial
	#$(INSTALL_BIN) ./files/99_9_usb_console $(1)/lib/preinit/99_9_usb_console
	#$(INSTALL_DIR) $(1)/etc/hotplug.d/tty/
	#$(INSTALL_BIN) ./files/secondary_console.hotplug $(1)/etc/hotplug.d/tty/30-secondary_console.hotplug
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/secondary_console.init $(1)/etc/init.d/secondary-console
endef

$(eval $(call BuildPackage,usb-console))
$(eval $(call BuildPackage,usb-console-airoha_en7523))
$(eval $(call BuildPackage,usb-console-apm821xx))
$(eval $(call BuildPackage,usb-console-at91_sama5))
$(eval $(call BuildPackage,usb-console-at91_sama7))
$(eval $(call BuildPackage,usb-console-ath79))
$(eval $(call BuildPackage,usb-console-bcm47xx))
$(eval $(call BuildPackage,usb-console-bcm4908))
$(eval $(call BuildPackage,usb-console-imx_cortexa9))
$(eval $(call BuildPackage,usb-console-mediatek_mt7623))
$(eval $(call BuildPackage,usb-console-mediatek_mt7629))
$(eval $(call BuildPackage,usb-console-mpc85xx))
$(eval $(call BuildPackage,usb-console-mxs))
$(eval $(call BuildPackage,usb-console-omap))
$(eval $(call BuildPackage,usb-console-ramips))
$(eval $(call BuildPackage,usb-console-siflower_sf21))
