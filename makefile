# --- Tên file thực thi cuối cùng ---
TARGET = app

# --- Cấu hình Cross-Compiler ---
CROSS_COMPILE = riscv64-unknown-elf-
CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld

# --- Thư mục ---
BUILD_DIR = build
SRC_DIR = src
LD_DIR = ld

# --- Cờ biên dịch và liên kết ---
CFLAGS = -march=rv64gc -mabi=lp64d -mcmodel=medany -ffreestanding -nostdlib -O2 -g
ASFLAGS = -march=rv64gc -mabi=lp64d -mcmodel=medany -g
LDFLAGS = -T $(LD_DIR)/linker.ld -nostdlib -g

# --- Cấu hình QEMU (ĐÃ LOẠI BỎ -semihosting) ---
QEMU = qemu-system-riscv64
QEMU_FLAGS = -machine virt -m 128M -nographic -bios none

# --- Tìm các file nguồn (ĐÃ THÊM uart.c) ---
C_SRCS = $(wildcard $(SRC_DIR)/*.c)
S_SRCS = $(wildcard $(SRC_DIR)/*.S) $(wildcard $(SRC_DIR)/*.s)
OBJS = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SRCS))
OBJS += $(patsubst $(SRC_DIR)/%.S, $(BUILD_DIR)/%.o, $(S_SRCS))
OBJS += $(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.o, $(S_SRCS))

.PHONY: all clean run

all: $(BUILD_DIR)/$(TARGET).elf

# Quy tắc liên kết cuối cùng
$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
	@echo "Linking..."
	@$(LD) $(LDFLAGS) -o $@ $^

# Quy tắc biên dịch file C
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@echo "Compiling C: $<"
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c $< -o $@

# Quy tắc biên dịch file Assembly
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.S
	@echo "Assembling: $<"
	@mkdir -p $(@D)
	@$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s
	@echo "Assembling: $<"
	@mkdir -p $(@D)
	@$(AS) $(ASFLAGS) $< -o $@

# Dọn dẹp
clean:
	@echo "Cleaning build files..."
	@rm -rf $(BUILD_DIR)

# Chạy với QEMU
run: all
	@echo "Running with QEMU..."
	@$(QEMU) $(QEMU_FLAGS) -kernel $(BUILD_DIR)/$(TARGET).elf

