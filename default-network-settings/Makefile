include $(TOPDIR)/rules.mk

PKG_NAME:=default-network-settings
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/default-network-settings
  SECTION:=wallcontroller
  CATEGORY:=Wallcontroller
  TITLE:=Wallcontroller Hostname Setter
  DEPENDS:=+uci
endef

define Package/default-network-settings/description
  Automatically sets the hostname on first boot using the last 4 hex digits of the MAC address.
endef

define Build/Compile
    # Nothing to compile
endef

define Package/default-network-settings/install
    $(INSTALL_DIR) $(1)/etc/uci-defaults
    $(INSTALL_BIN) ./files/etc/uci-defaults/99-set-default-network $(1)/etc/uci-defaults/99-set-default-network
endef

$(eval $(call BuildPackage,default-network-settings))
