ARCHS = arm64 arm64e
TARGET := iphone:clang:16.4:14.5

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PinAnimPrefs

PinAnimPrefs_EXTRA_FRAMEWORKS = Comet
PinAnimPrefs_FRAMEWORKS = SwiftUI
PinAnimPrefs_FILES = $(shell find Sources/PinAnimPrefs -name '*.swift') $(shell find Sources/PinAnimPrefsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
PinAnimPrefs_SWIFTFLAGS = -ISources/PinAnimPrefsC/include
PinAnimPrefs_INSTALL_PATH = /Library/PreferenceBundles
PinAnimPrefs_CFLAGS = -fobjc-arc

# Rootless / Rootful settings
ifeq ($(THEOS_PACKAGE_SCHEME),"rootless")
	PinAnimPrefs_XCODEFLAGS = SWIFT_ACTIVE_COMPILATION_CONDITIONS="ROOTLESS"
else
	PinAnimPrefs_XCODEFLAGS = SWIFT_ACTIVE_COMPILATION_CONDITIONS=""
endif

include $(THEOS_MAKE_PATH)/bundle.mk
