include $(TOPDIR)/rules.mk

PKG_NAME:=usb-console
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/usb-console
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Force USB Console and Built-in Drivers
  DEFAULT:=y
  # The KCONFIG variable injects these directly into the Linux .config
  KCONFIG:= \
    CONFIG_CMDLINE="console=ttyUSB0,115200 rootfstype=squashfs,jffs2" \
    CONFIG_CMDLINE_EXTEND=y \
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

define Package/usb-console/description
  This package injects kernel configurations to force USB and serial adapter
  drivers to be compiled natively (built-in) instead of loadable modules.
  It also prepends "console=ttyUSB0,115200" to the kernel command line
  and installs early preinit scripts to ensure the USB console initializes
  properly during the boot sequence.
endef

define Build/Compile
endef

define Package/usb-console/install
	$(INSTALL_DIR) $(1)/lib/preinit
	$(INSTALL_BIN) ./files/11_usbserial $(1)/lib/preinit/11_usbserial
	$(INSTALL_BIN) ./files/99_9_usb_console $(1)/lib/preinit/99_9_usb_console
endef

$(eval $(call BuildPackage,usb-console))
