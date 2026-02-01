# SPDX-License-Identifier: GPL-2.0-or-later

include $(TOPDIR)/rules.mk

PKG_NAME:=rtl8365mb-firmware
PKG_RELEASE:=1
PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/package.mk

define Package/rtl8365mb-firmware
  SECTION:=firmware
  CATEGORY:=Firmware
  DEPENDS:=@
  DEFAULT:=n
  TITLE:=RTL8365MB firwware files
endef

define Package/rtl8365mb-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/realtek/rtl8365mb/
	$(INSTALL_DATA) files/rtl8365mb-dw8051-sgmii-init.bin \
		$(1)/lib/firmware/realtek/rtl8365mb/rtl8365mb-dw8051-sgmii-init.bin
endef

define Package/rtl8365mb-firmware/description
  This package contains firmware for switches supported by rtl8465mb driver

  Currently, it only contains the (H)SGMII init code
endef

define Build/Compile
endef

$(eval $(call BuildPackage,rtl8365mb-firmware))
