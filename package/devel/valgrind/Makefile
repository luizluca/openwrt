#
# Copyright (C) 2006-2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=valgrind
PKG_VERSION:=3.12.99
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=http://valgrind.org/downloads/
PKG_HASH:=67ca4395b2527247780f36148b084f5743a68ab0c850cb43e4a5b4b012cf76a1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/liquid-mirror/valgrind.git
PKG_SOURCE_DATE:=2017-03-17
PKG_SOURCE_VERSION:=49adeb25704bbddfd6437e45b6750ae1430be069
PKG_MIRROR_HASH:=2b85bd5bacaa577354770c1ebceb6a8bad35410002ff329d3bcd3e975774c8b3

PKG_MAINTAINER:=Felix Fietkau <nbd@nbd.name>
PKG_LICENSE:=GPL-2.0+

PKG_FIXUP = autoreconf
PKG_INSTALL := 1
PKG_BUILD_PARALLEL := 1
PKG_USE_MIPS16:=0
PKG_SSP:=0

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel.mk

define Package/valgrind
  SECTION:=devel
  CATEGORY:=Development
  DEPENDS:=@mips||mipsel||i386||x86_64||powerpc||arm_v7 +libpthread +librt
  TITLE:=debugging and profiling tools for Linux
  URL:=http://www.valgrind.org
endef

define Package/valgrind/default
  $(Package/valgrind)
  DEPENDS := valgrind
endef

define Package/valgrind-cachegrind
  $(Package/valgrind/default)
  TITLE += (cache profiling)
endef

define Package/valgrind-callgrind
  $(Package/valgrind/default)
  TITLE += (callgraph profiling)
endef

define Package/valgrind-drd
  $(Package/valgrind/default)
  TITLE += (thread error detection)
endef

define Package/valgrind-massif
  $(Package/valgrind/default)
  TITLE += (heap profiling)
endef

define Package/valgrind-helgrind
  $(Package/valgrind/default)
  TITLE += (thread debugging)
endef

define Package/valgrind-vgdb
  $(Package/valgrind/default)
  TITLE += (GDB interface)
endef

define Package/valgrind/description
	Valgrind is an award-winning suite of tools for debugging and
	profiling Linux programs. With the tools that come with Valgrind,
	you can automatically detect many memory management and threading
	bugs, avoiding hours of frustrating bug-hunting, making your
	programs more stable. You can also perform detailed profiling,
	to speed up and reduce memory use of your programs.
endef

CPU := $(patsubst x86_64,amd64,$(patsubst x86,i386,$(patsubst um,$(ARCH),$(LINUX_KARCH))))

CONFIGURE_VARS += \
	UNAME_R=$(LINUX_VERSION)

ifeq ($(ARCH),x86_64)
	CONFIGURE_ARGS += \
		--enable-only64bit
	BITS := 64bit
else
	CONFIGURE_ARGS += \
		--enable-only32bit
	BITS := 32bit
endif

CONFIGURE_ARGS += \
	--enable-tls \
	--without-x \
	--without-mpicc \
	--without-uiout \
	--disable-valgrindmi \
	--disable-tui \
	--disable-valgrindtk \
	--without-included-gettext \
	--with-pagesize=4 \

https://github.com/liquid-mirror/VEX.git

define Download/libVEX
  VERSION:=06d81f616c51aa72ddea863784c5c07d645b8d23
  SUBDIR:=VEX
  PROTO:=git
  URL:=https://github.com/liquid-mirror/VEX.git
  DATE:=2017-03-17
  FILE:=VEX-$(PKG_VERSION)-$$(VERSION).tar.gz
  MIRROR_HASH:=0b3e2ca015eb9a7dc7e42c40bbdd8f98dc84e7f0742a6dc17a2c817deda1b73c
endef
$(eval $(call Download,libVEX))

define Build/Prepare
	$(call Build/Prepare/Default)
	$(call Build/Prepare/libVEX)
endef

define Build/Prepare/libVEX
	$(eval $(call Download,libVEX))
	gzip -dc $(DL_DIR)/$(FILE) | tar -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)
endef

define Package/valgrind/install	
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/valgrind* $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib/valgrind
	$(CP) \
		./files/default.supp \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/none-* \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/vgpreload_core*.so \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/$(CPU)-*.xml \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/$(BITS)-core*.xml \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/$(BITS)-linux*.xml \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/memcheck-* \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/vgpreload_memcheck*.so \
		$(1)/usr/lib/valgrind/
endef

define Package/valgrind-cachegrind/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/cg_* $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib/valgrind
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/cachegrind-* \
		$(1)/usr/lib/valgrind/
endef

define Package/valgrind-callgrind/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/callgrind* $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib/valgrind
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/callgrind-* \
		$(1)/usr/lib/valgrind/
endef

define Package/valgrind-drd/install
	$(INSTALL_DIR) $(1)/usr/lib/valgrind
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/drd-* \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/vgpreload_drd*.so \
		$(1)/usr/lib/valgrind/
endef

define Package/valgrind-massif/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/ms_print $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib/valgrind
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/massif-* \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/vgpreload_massif*.so \
		$(1)/usr/lib/valgrind/
endef

define Package/valgrind-helgrind/install
	$(INSTALL_DIR) $(1)/usr/lib/valgrind
	$(CP) \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/helgrind-* \
		$(PKG_INSTALL_DIR)/usr/lib/valgrind/vgpreload_helgrind*.so \
		$(1)/usr/lib/valgrind/
endef

define Package/valgrind-vgdb/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/vgdb $(1)/usr/bin/
endef

$(eval $(call BuildPackage,valgrind))
$(eval $(call BuildPackage,valgrind-cachegrind))
$(eval $(call BuildPackage,valgrind-callgrind))
$(eval $(call BuildPackage,valgrind-drd))
$(eval $(call BuildPackage,valgrind-massif))
$(eval $(call BuildPackage,valgrind-helgrind))
$(eval $(call BuildPackage,valgrind-vgdb))
