
# Copyright (C) 2016 Onion Corporation
# 
# Author: Lazar Demin  <lazar@onion.io>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=omega2-ctrl-wallcontroller
PKG_VERSION:=0.4.1
PKG_RELEASE:=1


PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Baui1024/omega2-ctrl
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_MIRROR_HASH:=skip

include $(INCLUDE_DIR)/package.mk


# application package
define Package/$(PKG_NAME)
	SECTION:=wallcontroller
	CATEGORY:=Wallcontroller
	SUBMENU:=Utilities
	TITLE:=Utility to control the Omega2's low-level hardware
endef

define Package/$(PKG_NAME)/description
Utility to control the Omega2's low-level hardware
endef


#TARGET_LIB += -lpthread -lcurl -loniondebug -ljson-c -lubus -lubox -lblobmsg_json -luci
TARGET_CFLAGS += $(FPIC) 

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LIB="$(TARGET_LIB)"
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	# install the binary
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/omega2-ctrl $(1)/usr/bin/
endef



$(eval $(call BuildPackage,$(PKG_NAME)))
