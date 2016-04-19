#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

COMMON_FOLDER := device/bn/common

#BOARD_USE_CUSTOM_HWC := true
OMAP_ENHANCEMENT_HWC_EXTENDED_API := true

GAPPS_VARIANT := nano

# inherit from the proprietary versions
-include vendor/ti/omap4/BoardConfigVendor.mk
-include vendor/bn/hd-common/BoardConfigVendor.mk
-include vendor/widevine/arm-generic/BoardConfigVendor.mk

# inherit from omap4
-include hardware/ti/omap4/BoardConfigCommon.mk

# set to allow building from omap4-common
BOARD_VENDOR := bn

TARGET_SPECIFIC_HEADER_PATH := $(COMMON_FOLDER)/include

USE_CAMERA_STUB := true
BOARD_HAVE_FAKE_GPS := true
BOARD_HAVE_BLUETOOTH := true
BOARD_WPAN_DEVICE := true

# This variable is set first, so it can be overridden
# by BoardConfigVendor.mk
BOARD_USES_GENERIC_AUDIO := false

# Never use low-latency audio for ringtones
AUDIO_FEATURE_DEEP_BUFFER_RINGTONE := true

USE_ITTIAM_AAC := true

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(COMMON_FOLDER)/bluetooth
BOARD_HAVE_BLUETOOTH_TI := true

# Wifi
USES_TI_MAC80211                 := true
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wl12xx
BOARD_WLAN_DEVICE                := wl12xx_mac80211
ifdef USES_TI_MAC80211
#WPA_SUPPLICANT_VERSION           := VER_0_8_X_TI
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_wl12xx
BOARD_SOFTAP_DEVICE              := wl12xx_mac80211
else
WPA_SUPPLICANT_VERSION           := VER_0_8_X
endif


# Kernel
BOARD_KERNEL_BASE := 0x80000000
TARGET_NO_RADIOIMAGE := true
TARGET_NO_BOOTLOADER := true
BOARD_KERNEL_PAGESIZE := 4096
TARGET_KERNEL_SOURCE := kernel/omap4/common
ifneq (,$(strip $(wildcard $(TARGET_KERNEL_SOURCE)/arch/arm/configs/android_omap4_defconfig)))
TARGET_KERNEL_CONFIG := android_omap4_defconfig
endif
ifneq (,$(strip $(wildcard $(TARGET_KERNEL_SOURCE)/arch/arm/configs/android_bn-hd_defconfig)))
TARGET_KERNEL_CONFIG := android_bn-hd_defconfig
endif
ifneq (,$(strip $(wildcard $(TARGET_KERNEL_SOURCE)/arch/arm/configs/selinux_defconfig)))
TARGET_KERNEL_SELINUX_CONFIG := selinux_defconfig
endif

BOARD_KERNEL_CMDLINE := androidboot.selinux=permissive

ifneq (,$(strip $(wildcard \
$(TARGET_KERNEL_SOURCE)/drivers/gpu/ion/ion_page_pool.c \
$(TARGET_KERNEL_SOURCE)/drivers/staging/android/ion/ion_page_pool.c)))
export BOARD_USE_TI_LIBION := false
endif

ifeq ($(ARM_EABI_TOOLCHAIN),)
TARGET_KERNEL_CROSS_COMPILE_PREFIX := arm-eabi-
KERNEL_TOOLCHAIN := $(ANDROID_TOOLCHAIN_2ND_ARCH)arm/$(TARGET_KERNEL_CROSS_COMPILE_PREFIX)$(TARGET_GCC_VERSION)/bin
ARM_EABI_TOOLCHAIN := $(KERNEL_TOOLCHAIN)
endif

ARM_CROSS_COMPILE ?= $(KERNEL_CROSS_COMPILE)

EXFAT_KM_PATH ?= $(dir $(wildcard external/*exfat*/Kconfig))

ifneq (,$(EXFAT_KM_PATH))
TARGET_KERNEL_HAVE_EXFAT := true
include $(EXFAT_KM_PATH)/exfat-km.mk
endif

# Filesystem
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 15728640
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 704643072
BOARD_USERDATAIMAGE_PARTITION_SIZE := 13824409600
BOARD_CACHEIMAGE_PARTITION_SIZE := 486539264
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_VOLD_MAX_PARTITIONS := 32
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/devices/virtual/android_usb/android0/f_mass_storage/lun%d/file"

# Disable journaling on system.img to save space
BOARD_SYSTEMIMAGE_JOURNAL_SIZE := 0

# Only pre-optimize the boot image
WITH_DEXPREOPT_BOOT_IMG_ONLY := true

# Configure jemalloc for low-memory
MALLOC_SVELTE := true

# Use clang platform builds
USE_CLANG_PLATFORM_BUILD := true

# adb has root
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.secure=0 \
    ro.allow.mock.location=1 \
    ro.debuggable=1

# Graphics
USE_OPENGL_RENDERER := true
TARGET_USES_OVERLAY := true
TARGET_USES_ION := true
# cache opts 12x & 32x defaults
MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024
# anything taller/wider bypasses HWC
#MAX_VIRTUAL_DISPLAY_DIMENSION := 1920
# distribute wake events, from Nexus 5
VSYNC_EVENT_PHASE_OFFSET_NS := 7500000
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 5000000
#PRESENT_TIME_OFFSET_FROM_VSYNC_NS := 3200000
# set if the target supports FBIO_WAITFORVSYNC
TARGET_HAS_WAITFORVSYNC := true
#TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true
#BOARD_USE_MHEAP_SCREENSHOT := true
TARGET_USES_OPENGLES_FOR_SCREEN_CAPTURE := true

# HDMI
BOARD_USES_NEW_HDMI := true
#BOARD_USES_GSC_VIDEO := true
BOARD_USES_CEC := true

# Set to true for platforms with 32 byte L2 cache line.
ARCH_ARM_HAVE_32_BYTE_CACHE_LINES := true
# Allowing unaligned access for NEON memory instructions.
ARCH_ARM_NEON_SUPPORTS_UNALIGNED_ACCESS := true

TARGET_BOOTANIMATION_HALF_RES := true

#TARGET_RECOVERY_PRE_COMMAND := "echo 'recovery' > /bootdata/BCB; sync"

# Misc.
BOARD_NEEDS_CUTILS_LOG := true

BOARD_HARDWARE_CLASS += $(OMAP4_NEXT_FOLDER)/cmhw

# XZ OTAs for smaller downloads
WITH_LZMA_OTA := true

# Not quite ready for Toybox
WITH_BUSYBOX_LINKS := true

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_UMS_LUNFILE := "/sys/devices/virtual/android_usb/android0/f_mass_storage/lun/file"
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
# For bigger CWM font
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_15x24.h\"
RECOVERY_NAME := EMMC CWM-based recovery
TARGET_NO_SEPARATE_RECOVERY := true

# SELinux stuff
BOARD_SEPOLICY_DIRS += device/bn/common/sepolicy

# Include an expanded selection of fonts
EXTENDED_FONT_FOOTPRINT := true

# TWRP stuff
TW_NO_REBOOT_BOOTLOADER := true
TW_NO_REBOOT_RECOVERY := true
TW_INTERNAL_STORAGE_PATH := "/data/media/0"
TW_INTERNAL_STORAGE_MOUNT_POINT := "data"
RECOVERY_SDCARD_ON_DATA := true
TW_EXTERNAL_STORAGE_PATH := "/sdcard"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "sdcard"
TW_DEFAULT_EXTERNAL_STORAGE := true
TW_BRIGHTNESS_PATH := /sys/class/backlight/lcd-backlight/brightness
TW_MAX_BRIGHTNESS := 254
TW_INCLUDE_CRYPTO := true
TW_CUSTOM_BATTERY_PATH := /sys/class/power_supply/bq27500-0
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
ifneq (,$(strip $(wildcard bootable/recovery-twrp/twrp.cpp)))
RECOVERY_VARIANT := twrp
endif
