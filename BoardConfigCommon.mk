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

GAPPS_VARIANT := nano

# inherit from the proprietary versions
-include vendor/ti/omap4/BoardConfigVendor.mk
-include vendor/bn/hd-common/BoardConfigVendor.mk
-include vendor/widevine/arm-generic/BoardConfigVendor.mk

# inherit from omap4
-include hardware/ti/omap4/BoardConfigCommon.mk

-include hardware/ti/wpan/BoardConfigCommon.mk

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
BOARD_HAVE_BLUETOOTH_TI := true

# Wifi
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wl12xx
BOARD_WLAN_DEVICE                := wl12xx_mac80211
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_wl12xx
WPA_SUPPLICANT_VERSION           := VER_0_8_X

# Binder API version
TARGET_USES_64_BIT_BINDER := true

# Kernel
BOARD_KERNEL_BASE := 0x80000000
TARGET_NO_RADIOIMAGE := true
TARGET_NO_BOOTLOADER := true
BOARD_KERNEL_PAGESIZE := 4096
TARGET_KERNEL_SOURCE := kernel/ti/omap4
TARGET_KERNEL_CONFIG := nookhd_defconfig
TARGET_KERNEL_VARIANT_CONFIG := $(notdir $(wildcard \
    $(TARGET_KERNEL_SOURCE)/arch/arm/configs/$(TARGET_DEVICE)_defconfig))
TARGET_KERNEL_SELINUX_CONFIG := $(notdir $(wildcard \
    $(TARGET_KERNEL_SOURCE)/arch/arm/configs/selinux_defconfig))

BOARD_KERNEL_CMDLINE := androidboot.selinux=permissive

ifneq (,$(strip $(wildcard \
$(TARGET_KERNEL_SOURCE)/arch/arm/boot/dts/*bn-hd*.dts* \
$(TARGET_KERNEL_SOURCE)/arch/arm/boot/dts/*nookhd*.dts* \
$(TARGET_KERNEL_SOURCE)/arch/arm/boot/dts/*ovation*.dts \
$(TARGET_KERNEL_SOURCE)/arch/arm/boot/dts/*hummingbird*.dts)))
BOARD_KERNEL_IMAGE_NAME := zImage-dtb
endif

ifneq (,$(strip $(wildcard \
$(TARGET_KERNEL_SOURCE)/drivers/gpu/ion/ion_page_pool.c \
$(TARGET_KERNEL_SOURCE)/drivers/staging/android/ion/ion_page_pool.c)))
export BOARD_USE_TI_LIBION := false
endif

ifeq ($(ARM_EABI_TOOLCHAIN),)
TARGET_KERNEL_CROSS_COMPILE_PREFIX := arm-eabi-
KERNEL_TOOLCHAIN := $(subst linux-androideabi,eabi,$(ANDROID_TOOLCHAIN))
ifeq ($(wildcard $(KERNEL_TOOLCHAIN)),)
KERNEL_TOOLCHAIN := $(subst $(TARGET_GCC_VERSION),4.8,$(KERNEL_TOOLCHAIN))
endif
ifeq ($(wildcard $(KERNEL_TOOLCHAIN)),)
TARGET_KERNEL_CROSS_COMPILE_PREFIX := arm-none-eabi-
KERNEL_TOOLCHAIN :=
endif
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

# Don't dex preopt apps to avoid I/O congestion due to paging larger sized
# pre-compiled .odex files as opposed to background generated interpret-only
# odex files. Also, save on precious system space.
WITH_DEXPREOPT_BOOT_IMG_AND_SYSTEM_SERVER_ONLY := true

# Configure jemalloc for low-memory
MALLOC_SVELTE := true

# Use clang platform builds
USE_CLANG_PLATFORM_BUILD := true

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
RECOVERY_GRAPHICS_FORCE_SINGLE_BUFFER := true
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
# For bigger CWM font
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_15x24.h\"
RECOVERY_NAME := EMMC CWM-based recovery
TARGET_NO_SEPARATE_RECOVERY := true

# SELinux stuff
BOARD_SEPOLICY_DIRS += device/bn/common/sepolicy
BOARD_SEPOLICY_M4DEFS += vensys=\(vendor\|system/vendor\)

DEVICE_MANIFEST_FILE += $(COMMON_FOLDER)/manifest.xml

# TWRP stuff
TW_NO_REBOOT_BOOTLOADER := true
TW_NO_REBOOT_RECOVERY := true
RECOVERY_SDCARD_ON_DATA := true
TW_BRIGHTNESS_PATH := /sys/class/backlight/lcd-backlight/brightness
TW_MAX_BRIGHTNESS := 254
TW_INCLUDE_CRYPTO := true
TW_CUSTOM_BATTERY_PATH := /sys/class/power_supply/bq27500-0
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
ifneq (,$(strip $(wildcard bootable/recovery-twrp/twrp.cpp)))
RECOVERY_VARIANT := twrp
endif
