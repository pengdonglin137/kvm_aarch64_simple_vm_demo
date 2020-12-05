APP ?= guest
VIRT ?= simple_virt
QUIET ?= @
OPT_LEVEL ?= 0

# Other switches the user should not normally need to change:
ARCH = armv8-a
DEBUG_FLAGS = -g

ifeq ($(QUIET),@)
PROGRESS = @echo Compiling $<...
endif

VIRT_CC = aarch64-linux-gnu-gcc
CC = aarch64-elf-gcc
OBJDUMP = aarch64-elf-objdump
OBJCOPY= aarch64-elf-objcopy
SRC_DIR = guest_src
VIRT_SRC_DIR= virt_src
ASM_DIR = asm
OBJ_DIR = obj
VIRT_OBJ_DIR = obj_virt

INCLUDES = -I./kernel_header/include -I./include/

define EOL =

endef

RM_FILES = $(foreach file,$(1),rm -f $(file)$(EOL))
RM_DIRS = $(foreach dir,$(1),rm -rf $(dir)$(EOL))

DEPEND_FLAGS = -MD -MF $@.d
CPPFLAGS_EXTRA += -ffunction-sections -fdata-sections -nostdinc
CPPFLAGS = $(DEFINES) $(INCLUDES) $(DEPEND_FLAGS) $(CPPFLAGS_EXTRA)
CFLAGS = $(DEBUG_FLAGS) -O$(OPT_LEVEL)
ASFLAGS = $(DEBUG_FLAGS)
LDFLAGS_EXTRA += -nostdlib
LDFLAGS = -Tgcc.ld -Wl,--gc-sections,-Map=$(APP).map $(LDFLAGS_EXTRA)
TARGET_ARCH = -march=$(ARCH)

APP_C_SRC := $(wildcard $(SRC_DIR)/*.c)
APP_S_SRC := $(wildcard $(ASM_DIR)/*.S)
VIRT_C_SRC := $(wildcard $(VIRT_SRC_DIR)/*.c)
OBJ_FILES := $(APP_C_SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o) \
             $(APP_S_SRC:$(ASM_DIR)/%.S=$(OBJ_DIR)/%.o)
VIRT_OBJ_FILES := $(VIRT_C_SRC:$(VIRT_SRC_DIR)/%.c=$(VIRT_OBJ_DIR)/%.o)
DEP_FILES := $(OBJ_FILES:%=%.d) $(VIRT_OBJ_FILES:%=%.d)

.phony: all clean

all: $(APP) $(VIRT)
	cp $(APP).bin $(VIRT) ../../share

$(APP): $(OBJ_FILES) gcc.ld
	@echo Linking $@
	$(QUIET) $(CC) $(TARGET_ARCH) $(LDFLAGS) -o $@ $(OBJ_FILES)
	$(QUIET) $(OBJDUMP) -D $@ > $@.dump
	$(QUIET) $(OBJCOPY) -O binary $@ $@.bin
	@echo Done.

$(VIRT): $(VIRT_OBJ_FILES)
	@echo Linking $@
	$(QUIET) $(VIRT_CC) -o $@ $(VIRT_OBJ_FILES)
	@echo Done.

clean:
	$(call RM_DIRS,$(OBJ_DIR))
	$(call RM_DIRS,$(VIRT_OBJ_DIR))
	$(call RM_FILES,$(APP) $(VIRT) $(APP).map $(APP).map $(APP).bin $(APP).dump)

$(OBJ_DIR):
	mkdir $@

$(VIRT_OBJ_DIR):
	mkdir $@

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(PROGRESS)
	$(QUIET) $(CC) -c $(TARGET_ARCH) $(CPPFLAGS) $(CFLAGS) -o $@ $<

$(VIRT_OBJ_DIR)/%.o : $(VIRT_SRC_DIR)/%.c | $(VIRT_OBJ_DIR)
	$(PROGRESS)
	$(QUIET) $(VIRT_CC) -c $(INCLUDES) -o $@ $<

$(OBJ_DIR)/%.o : $(ASM_DIR)/%.S | $(OBJ_DIR)
	$(PROGRESS)
	$(QUIET) $(CC) -c $(TARGET_ARCH) $(CPPFLAGS) $(ASFLAGS) -o $@ $<

# Make sure everything is rebuilt if this makefile is changed
$(OBJ_FILES) $(APP) $(VIRT): Makefile
