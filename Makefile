#
# Copyright (c) 2021 Yu Wang <wangyucn@gmail.com>
# Copyright (c) 2021 billsq <billsq@billsq.me>
#
# This is free software, licensed under MIT
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tinyPortMapper
PKG_VERSION:=20200818.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/wangyu-/$(PKG_NAME)/tar.gz/$(PKG_VERSION)?
PKG_HASH:=094aef3fa0646fe3d0418f87767c1dd24ba1a80518f1e8a7cae2783aed88e732

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=billsq <billsq@billsq.me>

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/tinyPortMapper
	SECTION:=net
	CATEGORY:=Network
	TITLE:=Port Mapping/Forwarding Utility
	URL:=https://github.com/wangyu-/tinyPortMapper
	DEPENDS:= +libstdcpp +librt +bind-dig
endef

define Package/tinyPortMapper/description
	 A Lightweight High-Performance Port Mapping/Forwarding Utility using epoll, Supports both TCP and UDP
endef

MAKE_FLAGS += cross

define Build/Prepare
	$(PKG_UNPACK)
	sed -i 's/cc_cross=.*/cc_cross=$(TARGET_CXX)/g' $(PKG_BUILD_DIR)/makefile
	sed -i '/\gitversion/d' $(PKG_BUILD_DIR)/makefile
	echo 'const char * const gitversion = "$(PKG_VERSION)";' > $(PKG_BUILD_DIR)/git_version.h
	$(Build/Patch)
endef

define Package/tinyPortMapper/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tinymapper_cross $(1)/usr/bin/tinymapper

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/tinymapper-config $(1)/etc/config/tinymapper

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/tinymapper-init $(1)/etc/init.d/tinymapper
endef

$(eval $(call BuildPackage,tinyPortMapper))
