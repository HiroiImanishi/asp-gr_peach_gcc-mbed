#
#  ターゲットの指定（Makefile.targetで上書きされるのを防ぐため）
#
all:

#
#  アプリケーションファイル
#
APPLDIR = ../../webcamera
APPLNAME = webcamera
USE_CXX = true
APPL_CFG = $(APPLNAME).cfg
USE_TRUESTUDIO = true

DEBUG = true
OMIT_OPTIMIZATION = true

#
#  MBEDライブラリのディレクトリの定義
#
MBED_LIB_DIR = ../../../mbed-lib

#
#  ASPソースファイルのディレクトリの定義
#
SRCDIR = ../../../asp-1.9.2-utf8

#
#  MBEDライブラリのビルド
#
include $(MBED_LIB_DIR)/common/Makefile.cmn
include $(MBED_LIB_DIR)/mbed-src/Makefile.src
include $(MBED_LIB_DIR)/EthernetInterface/Makefile.eif
include $(MBED_LIB_DIR)/mbed-rpc/Makefile.rpc
include $(MBED_LIB_DIR)/HttpServer_snapshot/Makefile.hss
include $(MBED_LIB_DIR)/FATFileSystem/Makefile.ffs
include $(MBED_LIB_DIR)/i2c/Makefile.i2c
include $(MBED_LIB_DIR)/GR-PEACH_video/Makefile.gpv
include $(MBED_LIB_DIR)/GraphicsFramework/Makefile.gfw
include ../Makefile.mbd

#
#  ASPカーネルライブラリ
#
KERNEL_LIB = .
include ../Makefile.asp

$(ALL_OBJ): kernel_cfg.h

