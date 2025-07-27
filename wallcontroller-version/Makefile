# Wallcontroller Firmware Version Package
#

include $(TOPDIR)/rules.mk

PKG_NAME:=wallcontroller-version
PKG_VERSION:=1.0.5
PKG_RELEASE:=1

PKG_MAINTAINER:=Thomas Bauer <t.bauer_1024@gmx.de>
PKG_LICENSE:=CC-BY-NC-4.0

include $(INCLUDE_DIR)/package.mk

define Package/wallcontroller-version
	SECTION:=wallcontroller
	CATEGORY:=Wallcontroller
	TITLE:=Wallcontroller Firmware Version
endef

define Package/wallcontroller-version/description
	Meta package that defines the firmware version for the Wallcontroller system.
	This package creates version information files in /etc/wallcontroller/.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./files/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	# Nothing to compile - this is a data-only package
endef

define Package/wallcontroller-version/install
	$(INSTALL_DIR) $(1)/etc/wallcontroller
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/version.json $(1)/etc/wallcontroller/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/release_notes.txt $(1)/etc/wallcontroller/
endef

$(eval $(call BuildPackage,wallcontroller-version))
