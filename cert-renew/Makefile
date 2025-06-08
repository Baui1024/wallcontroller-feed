include $(TOPDIR)/rules.mk

PKG_NAME:=cert-renew
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/cert-renew
	SECTION:=wallcontroller
	CATEGORY:=Wallcontroller
	TITLE:=Self-signed SSL Certificate Renewal
	DEPENDS:= +openssl-util 
endef

define Package/cert-renew/description
	Installs a script and cron job to automatically renew self-signed SSL certificates on OpenWRT.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/files
	$(CP) ./files/* $(PKG_BUILD_DIR)/files/
	$(call Build/Prepare/Default)
endef

define Build/Compile
	# nothing to compile
endef

define Package/cert-renew/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/cert-renew.sh $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/crontabs
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/files/root $(1)/etc/crontabs/root

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/cert-renew.init $(1)/etc/init.d/cert-renew
endef

$(eval $(call BuildPackage,cert-renew))
