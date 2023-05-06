TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard
TWEAK_NAME = PinAnim

$(TWEAK_NAME)_FILES = $(shell find Sources/$(TWEAK_NAME) -name '*.swift') $(shell find Sources/$(TWEAK_NAME)C -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
$(TWEAK_NAME)_SWIFTFLAGS = -ISources/$(TWEAK_NAME)C/include
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -ISources/$(TWEAK_NAME)C/include
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = SpringBoardUIServices
${TWEAK_NAME}_ORION_DEFAULT_BACKEND = Internal


# Rootless / Rootful settings
ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
	${TWEAK_NAME}_XCODEFLAGS = SWIFT_ACTIVE_COMPILATION_CONDITIONS="ROOTLESS"
else
	${TWEAK_NAME}_XCODEFLAGS = SWIFT_ACTIVE_COMPILATION_CONDITIONS=""
endif

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk
SUBPROJECTS += pinanimprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

