################################################################################
#
# libmediaart
#
################################################################################

LIBMEDIAART_VERSION_MAJOR = 1.9
LIBMEDIAART_VERSION = $(LIBMEDIAART_VERSION_MAJOR).5
LIBMEDIAART_SOURCE = libmediaart-$(LIBMEDIAART_VERSION).tar.xz
LIBMEDIAART_SITE = \
	http://ftp.gnome.org/pub/gnome/sources/libmediaart/$(LIBMEDIAART_VERSION_MAJOR)
LIBMEDIAART_LICENSE = LGPL-2.1+
LIBMEDIAART_LICENSE_FILES = COPYING.LESSER
LIBMEDIAART_INSTALL_STAGING = YES
LIBMEDIAART_DEPENDENCIES = libglib2 $(TARGET_NLS_DEPENDENCIES)
LIBMEDIAART_CONF_OPTS = -Dunit_tests=false
LIBMEDIAART_LDFLAGS = $(TARGET_NLS_LIBS)

ifeq ($(BR2_PACKAGE_LIBMEDIAART_BACKEND_GDK_PIXBUF),y)
LIBMEDIAART_DEPENDENCIES += gdk-pixbuf
LIBMEDIAART_CONF_OPTS += -Dimage_library=gdk-pixbuf
else ifeq ($(BR2_PACKAGE_LIBMEDIAART_BACKEND_QT),y)
# qt5 needs c++11 (since qt-5.7)
LIBMEDIAART_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++11"
LIBMEDIAART_DEPENDENCIES += qt5base
LIBMEDIAART_CONF_OPTS += -Dimage_library=qt5
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
LIBMEDIAART_LDFLAGS += -latomic
endif
endif

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
LIBMEDIAART_CONF_OPTS += -Dintrospection=true
LIBMEDIAART_DEPENDENCIES += host-vala gobject-introspection
else
LIBMEDIAART_CONF_OPTS += -Dintrospection=false
endif

$(eval $(meson-package))
