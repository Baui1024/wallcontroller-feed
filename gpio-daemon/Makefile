#
# GPIO Daemon OpenWRT Package
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gpio-daemon
PKG_VERSION:=1.0.19
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Baui1024/wallcontroller_buttons_api.git
PKG_SOURCE_VERSION:=master
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_MIRROR_HASH:=skip


PKG_LICENSE:=CC-BY-NC-4.0
PKG_MAINTAINER:=Thomas Bauer <t.bauer_1024@gmx.de>

include $(INCLUDE_DIR)/package.mk


define Package/gpio-daemon	
	SECTION:=wallcontroller
	CATEGORY:=Wallcontroller
	TITLE:=GPIO WebSocket Control Daemon
	DEPENDS:=+python3 +python3-websockets +python3-gpiod +omega2-ctrl-wallcontroller +kmod-leds-pca963x +kmod-i2c-mt7628 @KERNEL_DEVMEM
	KCONFIG:= \
		CONFIG_KERNEL_DEVMEM=y
endef

define Package/gpio-daemon/description
	A Python daemon that exposes GPIO control over a WebSocket interface.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
endef

define Build/Compile
	# No compilation required for Python
endef

define Package/gpio-daemon/install
	$(INSTALL_DIR) $(1)/usr/bin/gpio-daemon
	$(INSTALL_DIR) $(1)/etc/init.d

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/main.py $(1)/usr/bin/gpio-daemon/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/start.sh $(1)/usr/bin/gpio-daemon/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/mt7688gpio.py $(1)/usr/bin/gpio-daemon/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/led.py $(1)/usr/bin/gpio-daemon/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/button.py $(1)/usr/bin/gpio-daemon/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/gpio-daemon.init $(1)/etc/init.d/gpio-daemon
endef

$(eval $(call BuildPackage,gpio-daemon))
