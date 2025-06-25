
# Copyright (C) 2023 Onion Corporation
# 
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dt-overlay
PKG_VERSION:=1.0
PKG_RELEASE:=5
KERNEL_BUILD_DIR ?= $(BUILD_DIR)/linux-$(BOARD)$(if $(SUBTARGET),_$(SUBTARGET))
LINUX_DIR ?= $(KERNEL_BUILD_DIR)/linux-$(LINUX_VERSION)
DTC=$(LINUX_DIR)/scripts/dtc/dtc

include $(INCLUDE_DIR)/package.mk

define Package/dt-overlay/default
	TITLE:=dt-overlay
	SECTION:=wallcontroller
	CATEGORY:=Wallcontroller
	SUBMENU:=Utilities
	TITLE:=DT Overlay
endef

define Package/dt-overlay
	$(Package/dt-overlay/default)
endef

define Package/dt-overlay/description
	 DT Overlay
endef

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) src $(PKG_BUILD_DIR)
endef

define Build/Compile
	true
endef

define Package/dt-overlay/install
	true
endef

define BuildDtbo

  define Package/dt-overlay-$(1)
	$(Package/dt-overlay/default)
	TITLE+= ($(1) DTBO)
	DEPENDS+=dt-overlay $(2)
  endef

  define Package/dt-overlay-$(1)/description
	$(3)
  endef

  define Package/dt-overlay-$(1)/install
	$(INSTALL_DIR) $$(1)/lib/firmware/device-tree/overlays/
	$(DTC) -b 0 -@ -O dtb $(PKG_BUILD_DIR)/src/$(1).dts -o $(PKG_BUILD_DIR)/src/$(1).dtbo
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/src/$(1).dtbo $$(1)/lib/firmware/device-tree/overlays/$(1).dtbo
  endef

  define Package/dt-overlay-$(1)/postinst
	#!/bin/sh

	if [ -z "$$$${IPKG_INSTROOT}" ]; then
		if ! cat /proc/mounts | grep -q config; then
			echo "Mounting configfs..."
			mount -t configfs none /sys/kernel/config
		fi

		mkdir -p /sys/kernel/config/device-tree/overlays/$(1)
		cat /lib/firmware/device-tree/overlays/$(1).dtbo > /sys/kernel/config/device-tree/overlays/$(1)/dtbo
	fi
  endef

  $$(eval $$(call BuildPackage,dt-overlay-$(1)))

endef

$(eval $(call BuildPackage,dt-overlay))
$(eval $(call BuildDtbo,sw-spi,+kmod-mmc-spi +kmod-spi-bitbang +kmod-spi-dev +kmod-spi-gpio,Provides SW SPI))
$(eval $(call BuildDtbo,sw-spi-alt,+kmod-mmc-spi +kmod-spi-bitbang +kmod-spi-dev +kmod-spi-gpio,Provides SW SPI on easily accessible GPIOs))
$(eval $(call BuildDtbo,w1-gpio,+kmod-w1 +kmod-w1-master-gpio +kmod-w1-slave-therm,Provides One Wire GPIO))
$(eval $(call BuildDtbo,pca9635,+kmod-leds-pca963x,pca9635))