#
# Webserver OpenWRT Package
#

include $(TOPDIR)/rules.mk

PKG_NAME:=webserver
PKG_VERSION:=1.0.5
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Baui1024/wallcontroller_buttons_webserver.git
PKG_SOURCE_VERSION:=master
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_MIRROR_HASH:=skip


PKG_LICENSE:=CC-BY-NC-4.0
PKG_MAINTAINER:=Thomas Bauer <t.bauer_1024@gmx.de>

include $(INCLUDE_DIR)/package.mk

define Package/webserver
	SECTION:=wallcontroller
	CATEGORY:=Wallcontroller
	TITLE:=Web configuration interface for Wall Controller
	DEPENDS:=+python3 +python3-bottle +python3-netifaces +python3-websockets +python3-uci +umdns @KERNEL_DEVMEM +wallcontroller-version
	KCONFIG:= \
		CONFIG_KERNEL_DEVMEM=y
endef

define Package/webserver/description
	A small Python bottle-based web interface for changing IP and network settings on the Onion Omega2S+.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
endef

define Build/Compile
	cd $(PKG_BUILD_DIR)/frontend && npm install
	cd $(PKG_BUILD_DIR)/frontend && npm run build
endef

define Package/webserver/install
	$(INSTALL_DIR) $(1)/usr/bin/webserver
	$(INSTALL_DIR) $(1)/usr/bin/webserver/frontend/
	$(INSTALL_DIR) $(1)/etc/init.d

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/main.py $(1)/usr/bin/webserver/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ip_tool.py $(1)/usr/bin/webserver/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/mt7688gpio.py $(1)/usr/bin/webserver/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/gpio_ip_monitor.py $(1)/usr/bin/webserver/
	$(CP) -r $(PKG_BUILD_DIR)/frontend/dist $(1)/usr/bin/webserver/frontend/

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/webserver.init $(1)/etc/init.d/webserver
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/gpio-ip-monitor.init $(1)/etc/init.d/gpio-ip-monitor
endef

$(eval $(call BuildPackage,webserver))
