#
#  TOPPERS/ASP Kernel
#      Toyohashi Open Platform for Embedded Real-Time Systems/
#      Advanced Standard Profile Kernel
# 
#  Copyright (C) 2000-2003 by Embedded and Real-Time Systems Laboratory
#                              Toyohashi Univ. of Technology, JAPAN
#  Copyright (C) 2006-2018 by Embedded and Real-Time Systems Laboratory
#              Graduate School of Information Science, Nagoya Univ., JAPAN
# 
#  上記著作権者は，以下の(1)〜(4)の条件を満たす場合に限り，本ソフトウェ
#  ア（本ソフトウェアを改変したものを含む．以下同じ）を使用・複製・改
#  変・再配布（以下，利用と呼ぶ）することを無償で許諾する．
#  (1) 本ソフトウェアをソースコードの形で利用する場合には，上記の著作
#      権表示，この利用条件および下記の無保証規定が，そのままの形でソー
#      スコード中に含まれていること．
#  (2) 本ソフトウェアを，ライブラリ形式など，他のソフトウェア開発に使
#      用できる形で再配布する場合には，再配布に伴うドキュメント（利用
#      者マニュアルなど）に，上記の著作権表示，この利用条件および下記
#      の無保証規定を掲載すること．
#  (3) 本ソフトウェアを，機器に組み込むなど，他のソフトウェア開発に使
#      用できない形で再配布する場合には，次のいずれかの条件を満たすこ
#      と．
#    (a) 再配布に伴うドキュメント（利用者マニュアルなど）に，上記の著
#        作権表示，この利用条件および下記の無保証規定を掲載すること．
#    (b) 再配布の形態を，別に定める方法によって，TOPPERSプロジェクトに
#        報告すること．
#  (4) 本ソフトウェアの利用により直接的または間接的に生じるいかなる損
#      害からも，上記著作権者およびTOPPERSプロジェクトを免責すること．
#      また，本ソフトウェアのユーザまたはエンドユーザからのいかなる理
#      由に基づく請求からも，上記著作権者およびTOPPERSプロジェクトを
#      免責すること．
# 
#  本ソフトウェアは，無保証で提供されているものである．上記著作権者お
#  よびTOPPERSプロジェクトは，本ソフトウェアに関して，特定の使用目的
#  に対する適合性も含めて，いかなる保証も行わない．また，本ソフトウェ
#  アの利用により直接的または間接的に生じたいかなる損害に関しても，そ
#  の責任を負わない．
# 
#  $Id: Makefile 935 2018-04-07 09:23:40Z ertl-hiro $
# 

#
#  ターゲットの指定（Makefile.targetで上書きされるのを防ぐため）
#
all:

#
#  ターゲット略称の定義
#
TARGET = gr_peach_gcc

#
#  プログラミング言語の定義
#
SRCLANG = c++
ifeq ($(SRCLANG),c)
	LIBS = -lc
endif
ifeq ($(SRCLANG),c++)
   USE_CXX = true
#  CXXLIBS = -lstdc++ -lm -lc
#  CXXRTS = cxxrt.o newlibrt.o
endif

#
#  ソースファイルのディレクトリの定義
#
# SRCDIR = ..

#
#  オブジェクトファイル名の拡張子の設定
#
ifneq ($(USE_TRUESTUDIO),true)
OBJEXT = 
else
OBJEXT = elf
endif

#
#  DBGENVはasp3で廃止されている
#  
# DBGENV :=
#
#  カーネルライブラリ（libkernel.a）のディレクトリ名
#  （カーネルライブラリもmake対象にする時は，空に定義する）
#
# KERNEL_LIB = 

#
#  カーネルを関数単位でコンパイルするかどうかの定義
#
KERNEL_FUNCOBJS = 

#
#  TECSを外すかどうかの定義
#
OMIT_TECS = 

#
#  TECS関係ファイルのディレクトリの定義
#
TECSDIR = $(SRCDIR)/tecsgen

#
#  トレースログを取得するかどうかの定義
#
ENABLE_TRACE = 

#
#  開発ツール（コンパイラ等）のディレクトリの定義
#
DEVTOOLDIR = 

#
#  ユーティリティプログラムの名称
#
CFG = ruby $(SRCDIR)/cfg/cfg.rb
TECSGEN = ruby $(TECSDIR)/tecsgen.rb

#
#  オブジェクトファイル名の定義
#
OBJNAME = asp
ifdef OBJEXT
	OBJFILE = $(OBJNAME).$(OBJEXT)
	CFG1_OUT = cfg1_out.$(OBJEXT)
else
	OBJFILE = $(OBJNAME)
	CFG1_OUT = cfg1_out
endif

#
#  依存関係ファイルを置くディレクトリの定義
#
DEPDIR = deps

#
#  ターゲット依存部のディレクトリの定義
#
TARGETDIR = $(SRCDIR)/target/$(TARGET)

#
#  ターゲット依存の定義のインクルード
#
include $(TARGETDIR)/Makefile.target

#
#  TECS生成ファイルのディレクトリの定義
#
TECSGENDIR = ./gen
ifndef OMIT_TECS
	TECSGEN_TIMESTAMP = $(TECSGENDIR)/tecsgen.timestamp
	INIT_TECS_COBJ = init_tecs.o
endif

#
#  TECSが生成する定義のインクルード
#
ifndef OMIT_TECS
	GEN_DIR = $(TECSGENDIR)
	-include $(TECSGENDIR)/Makefile.tecsgen
endif

#
#  共通コンパイルオプションの定義
#  -I$(SRCDIR)archを追加(imanishi)
COPTS := $(COPTS) -g -O0 -ggdb
ifndef OMIT_WARNING_ALL
	COPTS := $(COPTS) -Wall
endif
ifndef OMIT_OPTIMIZATION
	COPTS := $(COPTS) -O2
endif
ifdef OMIT_TECS
	CDEFS := -DTOPPERS_OMIT_TECS $(CDEFS)
endif
CDEFS := $(CDEFS) 
INCLUDES := -I. -I$(SRCDIR)/include -I$(SRCDIR)/arch $(INCLUDES) -I$(SRCDIR)
LDFLAGS := $(LDFLAGS) 
CFG1_OUT_LDFLAGS := $(CFG1_OUT_LDFLAGS)
LIBS := $(LIBS) $(CXXLIBS)
CFLAGS = $(COPTS) $(CDEFS) $(INCLUDES)

#
#  アプリケーションプログラムに関する定義
#  include_pathsを追加
# APPLNAME = sample1
# APPLDIR = $(SRCDIR)/sample
# APPL_CFG = sample1.cfg
# APPL_CDL = sample1.cdl

APPL_DIRS = $(APPLDIR) $(SRCDIR)/library
APPL_ASMOBJS := $(APPL_ASMOBJS)
ifdef USE_CXX
	APPL_CXXOBJS := $(APPLNAME).o $(APPL_CXXOBJS)
	APPL_COBJS := $(APPL_COBJS)
else
	APPL_COBJS := $(APPLNAME).o $(APPL_COBJS)
endif
APPL_COBJS := $(APPL_COBJS) log_output.o vasyslog.o t_perror.o strerror.o
# APPL_CFLAGS = 
ifdef APPLDIR
	INCLUDES := $(INCLUDES) $(foreach dir,$(APPLDIR),-I$(dir))
	INCLUDE_PATHS := $(INCLUDE_PATHS)  $(foreach dir,$(APPLDIR),-I$(dir)) 
endif

#
#  システムサービスに関する定義
#  $(SRCDIR)libraryを追加
SYSSVC_DIRS := $(TECSGENDIR) $(SRCDIR)/tecs_kernel \
				$(SYSSVC_DIRS) $(SRCDIR)/syssvc $(SRCDIR)/library
SYSSVC_ASMOBJS := $(SYSSVC_ASMOBJS)
SYSSVC_COBJS := $(SYSSVC_COBJS)  $(TECS_COBJS) \
				$(INIT_TECS_COBJ) $(CXXRTS)
SYSSVC_CFLAGS := $(SYSSVC_CFLAGS)
INCLUDES := $(INCLUDES) -I$(TECSGENDIR) -I$(SRCDIR)/tecs_kernel

#
#  ターゲットファイル
#
.PHONY: all
ifndef OMIT_TECS
all: tecs
	@$(MAKE) check
#	@$(MAKE) check $(OBJNAME).bin
#	@$(MAKE) check $(OBJNAME).srec
else
all: check
#all: check $(OBJNAME).bin
#all: check $(OBJNAME).srec
endif

##### 以下は編集しないこと #####

#
#  コンフィギュレータに関する定義
#
CFG_KERNEL := --kernel asp
CFG_TABS := --api-table $(SRCDIR)/kernel/kernel_api.def \
			--symval-table $(SRCDIR)/kernel/kernel_sym.def $(CFG_TABS)
CFG_ASMOBJS := $(CFG_ASMOBJS)
CFG_COBJS := kernel_cfg.o $(CFG_COBJS)
CFG_OBJS := $(CFG_ASMOBJS) $(CFG_COBJS)
CFG2_OUT_SRCS := kernel_cfg.h kernel_cfg.c $(CFG2_OUT_SRCS)
CFG_CFLAGS := -DTOPPERS_CB_TYPE_ONLY $(CFG_CFLAGS)

#
#  カーネルに関する定義
#
#  KERNEL_ASMOBJS: カーネルライブラリに含める，ソースがアセンブリ言語の
#				   オブジェクトファイル．
#  KERNEL_COBJS: カーネルのライブラリに含める，ソースがC言語で，ソース
#				 ファイルと1対1に対応するオブジェクトファイル．
#  KERNEL_LCSRCS: カーネルのライブラリに含めるC言語のソースファイルで，
#				  1つのソースファイルから複数のオブジェクトファイルを生
#				  成するもの．
#  KERNEL_LCOBJS: 上のソースファイルから生成されるオブジェクトファイル．
#
KERNEL_DIRS := $(KERNEL_DIRS) $(SRCDIR)/kernel
KERNEL_ASMOBJS := $(KERNEL_ASMOBJS)
KERNEL_COBJS := $(KERNEL_COBJS)
KERNEL_CFLAGS := $(KERNEL_CFLAGS) -I$(SRCDIR)/kernel

#
#  カーネルのファイル構成の定義
#
include $(SRCDIR)/kernel/Makefile.kernel
ifdef KERNEL_FUNCOBJS
	KERNEL_LCSRCS := $(KERNEL_FCSRCS)
	KERNEL_LCOBJS := $(foreach file,$(KERNEL_FCSRCS),$($(file:.c=)))
else
	KERNEL_CFLAGS := -DALLFUNC $(KERNEL_CFLAGS)
	KERNEL_COBJS := $(KERNEL_COBJS) \
					$(foreach file,$(KERNEL_FCSRCS),$(file:.c=.o))
endif
ifdef TARGET_OFFSET_TRB
	OFFSET_H = offset.h
endif
ifndef TARGET_KERNEL_TRB
	TARGET_KERNEL_TRB := $(TARGETDIR)/target_kernel.trb
endif
ifndef TARGET_CHECK_TRB
	TARGET_CHECK_TRB := $(TARGETDIR)/target_check.trb
endif
ifndef TARGET_KERNEL_CFG
	TARGET_KERNEL_CFG := $(TARGETDIR)/target_kernel.cfg
endif

#
#  ソースファイルのあるディレクトリに関する定義
#
vpath %.c $(KERNEL_DIRS) $(SYSSVC_DIRS) $(APPL_DIRS)
vpath %.cpp $(KERNEL_DIRS) $(SYSSVC_DIRS) $(APPL_DIRS)
vpath %.S $(KERNEL_DIRS) $(SYSSVC_DIRS) $(APPL_DIRS)
vpath %.cfg $(APPL_DIRS)
vpath %.cdl $(APPL_DIRS)

#
#  コンパイルのための変数の定義
#
KERNEL_LIB_OBJS = $(KERNEL_ASMOBJS) $(KERNEL_COBJS) $(KERNEL_LCOBJS)
SYSSVC_OBJS = $(SYSSVC_ASMOBJS) $(SYSSVC_COBJS)
APPL_OBJS = $(APPL_ASMOBJS) $(APPL_COBJS) $(APPL_CXXOBJS)
ALL_OBJS = $(START_OBJS) $(APPL_OBJS) $(SYSSVC_OBJS) $(CFG_OBJS) \
											$(END_OBJS) $(HIDDEN_OBJS)
# ALL_LIBS = -lkernel $(LIBS)
ifdef KERNEL_LIB
	ALL_LIBS = $(APPL_LIBS) $(SYSSVC_LIBS) -lkernel $(LIBS)
	LIBS_DEP = $(filter %.a,$(ALL_LIBS)) $(KERNEL_LIB)/libkernel.a 
#	OBJ_LDFLAGS := $(OBJ_LDFLAGS) -L$(KERNEL_LIB)
	LDFLAGS := $(LDFLAGS) -L$(KERNEL_LIB)
	REALCLEAN_FILES := libkernel.a $(REALCLEAN_FILES)
else
	ALL_LIBS = $(APPL_LIBS) $(SYSSVC_LIBS) libkernel.a $(LIBS)
	LIBS_DEP = $(filter %.a,$(ALL_LIBS))
#	OBJ_LDFLAGS := $(OBJ_LDFLAGS) -L.
endif


#
#  tecsgenからCプリプロセッサを呼び出す際のオプションの定義
#
TECS_CPP = $(CC) $(CDEFS) $(INCLUDES) $(SYSSVC_CFLAGS) -D TECSGEN -E

#
#  tecsgenの呼出し
#
.PHONY: tecs
tecs $(TECSGEN_SRCS) $(TECS_HEADERS): $(TECSGEN_TIMESTAMP) ;
$(TECSGEN_TIMESTAMP): $(APPL_CDL) $(TECS_IMPORTS)
	$(TECSGEN) $< -R $(INCLUDES) --cpp "$(TECS_CPP)" -g $(TECSGENDIR)

#check
ifdef TEXT_START_ADDRESS
  LDFLAGS := $(LDFLAGS) -Wl,-Ttext,$(TEXT_START_ADDRESS)
  CFG1_OUT_LDFLAGS := $(CFG1_OUT_LDFLAGS) -Wl,-Ttext,$(TEXT_START_ADDRESS)
endif
ifdef DATA_START_ADDRESS
  LDFLAGS := $(LDFLAGS) -Wl,-Tdata,$(DATA_START_ADDRESS)
  CFG1_OUT_LDFLAGS := $(CFG1_OUT_LDFLAGS) -Wl,-Tdata,$(DATA_START_ADDRESS)
endif
ifdef LDSCRIPT
  LDFLAGS := $(LDFLAGS) -T $(LDSCRIPT)
  CFG1_OUT_LDFLAGS := $(CFG1_OUT_LDFLAGS) -T $(LDSCRIPT)
endif
#
#  カーネルのコンフィギュレーションファイルの生成
#
cfg1_out.c cfg1_out.db: cfg1_out.timestamp ;
cfg1_out.timestamp: $(APPL_CFG) $(TECSGEN_TIMESTAMP)
	$(CFG) --pass 1 $(CFG_KERNEL) $(INCLUDES) $(CFG_TABS) \
						-M $(DEPDIR)/cfg1_out_c.d $(TARGET_KERNEL_CFG) $<

$(CFG1_OUT): $(START_OBJS) cfg1_out.o $(END_OBJS) $(HIDDEN_OBJS)
	$(LINK) $(CFLAGS) $(CFG1_OUT_LDFLAGS) -o $(CFG1_OUT) \
						$(START_OBJS) cfg1_out.o $(LIBS) $(END_OBJS)

cfg1_out.syms: $(CFG1_OUT)
	$(NM) -n $(CFG1_OUT) > cfg1_out.syms

cfg1_out.srec: $(CFG1_OUT)
	$(OBJCOPY) -O srec -S $(CFG1_OUT) cfg1_out.srec

$(CFG2_OUT_SRCS) cfg2_out.db: kernel_cfg.timestamp ;
kernel_cfg.timestamp: cfg1_out.db cfg1_out.syms cfg1_out.srec
	$(CFG) --pass 2 $(CFG_KERNEL) $(INCLUDES) -T $(TARGET_KERNEL_TRB)

#
#  オフセットファイル（offset.h）の生成規則
#
$(OFFSET_H): offset.timestamp ;
offset.timestamp: cfg1_out.db cfg1_out.syms cfg1_out.srec
	$(CFG) --pass 2 -O $(CFG_KERNEL) $(INCLUDES) -T $(TARGET_OFFSET_TRB) \
				--rom-symbol cfg1_out.syms --rom-image cfg1_out.srec

#
#  カーネルライブラリファイルの生成
#
libkernel.a: $(OFFSET_H) $(KERNEL_LIB_OBJS)
	rm -f libkernel.a
	$(AR) -rcs libkernel.a $(KERNEL_LIB_OBJS)
	$(RANLIB) libkernel.a

#
#  特別な依存関係の定義
#
tBannerMain.o: $(filter-out tBannerMain.o,$(ALL_OBJS)) $(LIBS_DEP)

#
#  全体のリンク
#
$(OBJFILE): $(ALL_OBJS) $(LIBS_DEP)
	$(LINK) $(CFLAGS) $(LDFLAGS) $(OBJ_LDFLAGS) -o $(OBJFILE) \
			$(START_OBJS) $(APPL_OBJS) $(SYSSVC_OBJS) $(CFG_OBJS) \
			$(ALL_LIBS) $(END_OBJS)

#
#  シンボルファイルの生成
#
$(OBJNAME).syms: $(OBJFILE)
	$(NM) -n $(OBJFILE) > $(OBJNAME).syms

#
#  バイナリファイルの生成
#
$(OBJNAME).bin: $(OBJFILE)
	$(OBJCOPY) -O binary -S $(OBJFILE) $(OBJNAME).bin

#
#  Sレコードファイルの生成
#
$(OBJNAME).srec: $(OBJFILE)
	$(OBJCOPY) -O srec -S $(OBJFILE) $(OBJNAME).srec

#
#  エラーチェック処理
#
.PHONY: check
check: check.timestamp ;
check.timestamp: cfg2_out.db $(OBJNAME).syms $(OBJNAME).srec
	$(CFG) --pass 3 $(CFG_KERNEL) -O $(INCLUDES) -T $(TARGET_CHECK_TRB) \
				--rom-symbol $(OBJNAME).syms --rom-image $(OBJNAME).srec
	@echo "configuration check passed"

#
#  コンパイル結果の消去
#
.PHONY: clean
clean:
ifneq ($(USE_TRUESTUDIO),true)
	rm -f $(LIB).a $(ALL_OBJ) $(DEPS)
	rm -f \#* *~ *.o $(DEPDIR)/*.d $(CLEAN_FILES) check.timestamp
	rm -f $(OBJFILE) $(OBJNAME).syms $(OBJNAME).srec $(OBJNAME).bin
	rm -f kernel_cfg.timestamp $(CFG2_OUT_SRCS) cfg2_out.db
	rm -f offset.timestamp $(OFFSET_H)
	rm -f cfg1_out.syms cfg1_out.srec $(CFG1_OUT)
	rm -f cfg1_out.timestamp cfg1_out.c cfg1_out.db
	rm -rf $(TECSGENDIR)
ifndef KERNEL_LIB
	rm -f libkernel.a
endif
	rm -f makeoffset.s offset.h
else
	-rm -f $(LIB).a $(ALL_OBJ) $(DEPS)
	-rm -f \#* *~ *.o $(DEPDIR)/*.d $(CLEAN_FILES) check.timestamp
	-rm -f $(OBJFILE) $(OBJNAME).syms $(OBJNAME).srec $(OBJNAME).bin
	-rm -f kernel_cfg.timestamp $(CFG2_OUT_SRCS) cfg2_out.db
	-rm -f offset.timestamp $(OFFSET_H)
	-rm -f cfg1_out.syms cfg1_out.srec $(CFG1_OUT)
	-rm -f cfg1_out.timestamp cfg1_out.c cfg1_out.db
	-rm -rf $(TECSGENDIR)
ifndef KERNEL_LIB
	-rm -f libkernel.a
endif
	-rm -f makeoffset.s offset.h
endif


.PHONY: cleankernel
cleankernel:
ifneq ($(USE_TRUESTUDIO),true)
	rm -f $(OFFSET_H) $(KERNEL_LIB_OBJS)
	rm -f $(KERNEL_LIB_OBJS:%.o=$(DEPDIR)/%.d)
else
	-rm -f $(OFFSET_H) $(KERNEL_LIB_OBJS)
	-rm -f $(KERNEL_LIB_OBJS:%.o=$(DEPDIR)/%.d)
endif


.PHONY: cleandep
cleandep:
	if ! [ -f Makefile.depend ]; then \
		rm -f kernel_cfg.timestamp $(CFG2_OUT_SRCS); \
		rm -f cfg1_out.c cfg1_out.o $(CFG1_OUT) cfg1_out.syms cfg1_out.srec; \
		rm -f makeoffset.s offset.h; \
	fi
	rm -f Makefile.depend

.PHONY: realclean
ifneq ($(USE_TRUESTUDIO),true)
realclean: cleandep clean
	rm -f $(REALCLEAN_FILES)
else
realclean: cleandep clean
	-rm -f $(REALCLEAN_FILES)
endif

#
#  コンフィギュレータが生成したファイルのコンパイルルールの定義
#
#  コンフィギュレータが生成したファイルは，共通のコンパイルオプション
#  のみを付けてコンパイルする．
#
ALL_CFG_COBJS = $(CFG_COBJS) cfg1_out.o
ALL_CFG_ASMOBJS = $(CFG_ASMOBJS)

$(ALL_CFG_COBJS): %.o: %.c
	$(CC) -c -MD -MP -MF $(DEPDIR)/$*.d $(CFLAGS) $(CFG_CFLAGS) $<

ifneq ($(USE_TRUESTUDIO),true)
$(ALL_CFG_COBJS:.o=.s): %.s: %.c
	$(CC) -S $(CFLAGS) $(CFG_CFLAGS) $<
endif
$(ALL_CFG_ASMOBJS): %.o: %.S
	$(CC) -c -MD -MP -MF $(DEPDIR)/$*.d $(CFLAGS) $(CFG_CFLAGS) $<

#
#  依存関係ファイルのインクルード
#
-include $(DEPDIR)/*.d

#
#  開発ツールのコマンド名の定義
#
ifeq ($(TOOL),gcc)
	#
	#  GNU開発環境用
	#
	ifdef GCC_TARGET
		GCC_TARGET_PREFIX = $(GCC_TARGET)-
	else
		GCC_TARGET_PREFIX =
	endif
	CC := $(GCC_TARGET_PREFIX)gcc
	CXX := $(GCC_TARGET_PREFIX)g++
	AS := $(GCC_TARGET_PREFIX)as
	LD := $(GCC_TARGET_PREFIX)ld
	AR := $(GCC_TARGET_PREFIX)ar
	NM := $(GCC_TARGET_PREFIX)nm
	RANLIB := $(GCC_TARGET_PREFIX)ranlib
	OBJCOPY := $(GCC_TARGET_PREFIX)objcopy
	OBJDUMP := $(GCC_TARGET_PREFIX)objdump
endif

ifdef DEVTOOLDIR
	CC := $(DEVTOOLDIR)/$(CC)
	CXX := $(DEVTOOLDIR)/$(CXX)
	AS := $(DEVTOOLDIR)/$(AS)
	LD := $(DEVTOOLDIR)/$(LD)
	AR := $(DEVTOOLDIR)/$(AR)
	NM := $(DEVTOOLDIR)/$(NM)
	RANLIB := $(DEVTOOLDIR)/$(RANLIB)
	OBJCOPY := $(DEVTOOLDIR)/$(OBJCOPY)
	OBJDUMP := $(DEVTOOLDIR)/$(OBJDUMP)
endif

ifdef USE_CXX
	LINK = $(CXX)
else
	LINK = $(CC)
endif

#
#  コンパイルルールの定義
#  KERNEL_AUX_COBJS,KERNEL_ALL_COBJSはasp3では定義されていない
#KERNEL_ALL_COBJS = $(KERNEL_COBJS) $(KERNEL_AUX_COBJS)

#$(KERNEL_ALL_COBJS): %.o: %.c
#	$(CC) -c $(CFLAGS) $(KERNEL_CFLAGS) $<
$(KERNEL_COBJS): %.o: %.c
	$(CC) -c -MD -MP -MF $(DEPDIR)/$*.d $(CFLAGS) $(KERNEL_CFLAGS) $<
ifneq ($(USE_TRUESTUDIO),true)
$(KERNEL_COBJS:.o=.s): %.s: %.c
	$(CC) -S $(CFLAGS) $(KERNEL_CFLAGS) $<
endif

$(KERNEL_LCOBJS): %.o:
	$(CC) -DTOPPERS_$(*F) -o $@ -c -MD -MP -MF $(DEPDIR)/$*.d \
									$(CFLAGS) $(KERNEL_CFLAGS) $<

$(KERNEL_LCOBJS:.o=.s): %.s:
	$(CC) -DTOPPERS_$(*F) -o $@ -S $(CFLAGS) $(KERNEL_CFLAGS) $<

$(KERNEL_ASMOBJS): %.o: %.S
	$(CC) -c -MD -MP -MF $(DEPDIR)/$*.d $(CFLAGS) $(KERNEL_CFLAGS) $<

$(SYSSVC_COBJS): %.o: %.c
	$(CC) -c -MD -MP -MF $(DEPDIR)/$*.d $(CFLAGS) $(SYSSVC_CFLAGS) $<

ifneq ($(USE_TRUESTUDIO),true)
$(SYSSVC_COBJS:.o=.s): %.s: %.c
	$(CC) -S $(CFLAGS) $(SYSSVC_CFLAGS) $<
endif

$(SYSSVC_ASMOBJS): %.o: %.S
	$(CC) -c -MD -MP -MF $(DEPDIR)/$*.d $(CFLAGS) $(SYSSVC_CFLAGS) $<

$(APPL_COBJS): %.o: %.c
	$(CC) -c -MD -MP -MF $(DEPDIR)/$*.d $(CFLAGS) $(APPL_CFLAGS) $<

ifneq ($(USE_TRUESTUDIO),true)
	$(APPL_COBJS:.o=.s): %.s: %.c
	$(CC) -S $(CFLAGS) $(APPL_CFLAGS) $<
endif

$(APPL_CXXOBJS): %.o: %.cpp
	$(CXX) -c -MD -MP -MF $(DEPDIR)/$*.d $(CFLAGS) $(APPL_CXXFLAGS) $<

ifneq ($(USE_TRUESTUDIO),true)
$(APPL_CXXOBJS:.o=.s): %.s: %.cpp
	$(CXX) -S $(CFLAGS) $(APPL_CXXFLAGS) $<
endif

$(APPL_ASMOBJS): %.o: %.S
	$(CC) -c -MD -MP -MF $(DEPDIR)/$*.d $(CFLAGS) $(APPL_CXXFLAGS) $<

#
#  デフォルトコンパイルルールを上書き
#
%.o: %.c
	@echo "*** Default compile rules should not be used."
	$(CC) -c -MD -MP -MF $(DEPDIR)/$*.d $(CFLAGS) $<

%.s: %.c
	@echo "*** Default compile rules should not be used."
	$(CC) -S $(CFLAGS) $<

%.o: %.cpp
	@echo "*** Default compile rules should not be used."
	$(CXX) -c -MD -MP -MF $(DEPDIR)/$*.d $(CFLAGS) $<

%.s: %.cpp
	@echo "*** Default compile rules should not be used."
	$(CXX) -S $(CFLAGS) $<

%.o: %.S
	@echo "*** Default compile rules should not be used."
	$(CC) -c -MD -MP -MF $(DEPDIR)/$*.d $(CFLAGS) $<


$(warning -----------------変数一覧---------------------------)
$(warning LINK = $(LINK))
$(warning CXX = $(CXX))
$(warning START_OBJS = $(START_OBJS))
$(warning END_OBJS = $(END_OBJS))
$(warning HIDDEN_OBJS = $(HIDDEN_OBJS))
$(warning TEXT_START_ADDRESS = $(TEXT_START_ADDRESS))
$(warning DATA_START_ADDRESS = $(DATA_START_ADDRESS))
$(warning dir = $(dir))
$(warning APPLDIR = $(APPLDIR))
$(warning INCLUDES = $(INCLUDES))
$(warning INCLUDE_PATHS = $(INCLUDE_PATHS))
$(warning CFLAGS = $(CFLAGS))
$(warning COPTS = $(COPTS)) 
$(warning CDEFS = $(CDEFS))
$(warning LDFLAGS = $(LDFLAGS))
$(warning OBJ_LDFLAGS = $(OBJ_LDFLAGS))
$(warning LDSCRIPT = $(LDSCRIPT))
$(warning CFG1_OUT_LDFLAGS = $(CFG1_OUT_LDFLAGS))
$(warning CFG1_OUT = $(CFG1_OUT))
$(warning LIBS = $(LIBS))
$(warning OBJFILE = $(OBJFILE))
$(warning APPL_CFLAGS = $(APPL_CFLAGS))
$(warning APPL_CXXFLAGS = $(APPL_CXXFLAGS))
$(warning APPL_COBJS = $(APPL_COBJS))
$(warning APPL_CXXOBJS = $(APPL_CXXOBJS))
$(warning KERNEL_CFLAGS = $(KERNEL_CFLAGS))
$(warning CFG_CFLAGS = $(CFG_CFLAGS))
$(warning SYSSVC_CFLAGS = $(SYSSVC_CFLAGS))
$(warning SYSSVC_COBJS = $(SYSSVC_COBJS))
$(warning KERNEL_FCSRCS = $(KERNEL_FCSRCS))
$(warning KERNEL_ASMOBJS = $(KERNEL_ASMCOBJS))
$(warning KERNEL_COBJS = $(KERNEL_COBJS))
$(warning KERNEL_LCOBJS = $(KERNEL_LCOBJS))
$(warning KERNEL_AUX_COBJS = $(KERNEL_AUX_COBJS))
$(warning KERNEL_LIB_OBJS = $(KERNEL_LIB_OBJS))
$(warning KERNEL_LIB = $(KERNEL_LIB))
$(warning ALL_LIBS = $(ALL_LIBS))
$(warning CXXRTS = $(CXXRTS))
$(warning TECSDIR = $(TECSDIR))
$(warning ------------------------------------------)