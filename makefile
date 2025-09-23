# --- Tên file thực thi cuối cùng ---
TARGET = app

# --- Cấu hình Cross-Compiler ---
CROSS_COMPILE = riscv64-unknown-elf-
CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
# LD không còn được sử dụng, CC sẽ đảm nhiệm việc liên kết

# --- Thư mục ---
BUILD_DIR = build
SRC_DIR = src
LD_DIR = ld

# --- Cờ biên dịch và liên kết ---
CFLAGS = -march=rv64gc -mabi=lp64d -mcmodel=medany -ffreestanding -nostdlib -O2 -g
ASFLAGS = -march=rv64gc -mabi=lp64d -g
LDFLAGS = -T $(LD_DIR)/linker.ld -nostdlib -g

# --- Cấu hình QEMU ---
QEMU = qemu-system-riscv64
QEMU_FLAGS = -machine virt -m 128M -nographic -bios none

# --- Tìm các file nguồn ---
C_SRCS     = $(wildcard $(SRC_DIR)/*.c)
S_CAP_SRCS = $(wildcard $(SRC_DIR)/*.S)
S_LOW_SRCS = $(wildcard $(SRC_DIR)/*.s)

# Chuyển đổi đường dẫn file nguồn sang đường dẫn file object (ĐÃ SỬA LỖI)
C_OBJS     = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SRCS))
S_CAP_OBJS = $(patsubst $(SRC_DIR)/%.S, $(BUILD_DIR)/%.o, $(S_CAP_SRCS))
S_LOW_OBJS = $(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.o, $(S_LOW_SRCS))

# Kết hợp tất cả các file object
OBJS = $(C_OBJS) $(S_CAP_OBJS) $(S_LOW_OBJS)

.PHONY: all clean run debug

all: $(BUILD_DIR)/$(TARGET).elf

# Quy tắc liên kết cuối cùng (SỬ DỤNG CC THAY VÌ LD)
$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
	@echo "Linking..."
	@$(CC) $(LDFLAGS) -o $@ $^

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
# qemu-system-riscv64 -machine virt -m 128M -nographic -bios none -kernel build/app.elf

# Chạy QEMU ở chế độ debug
debug: all
	@echo "Starting QEMU in Debug Mode. Waiting for GDB on :1234..."
	@$(QEMU) $(QEMU_FLAGS) -kernel $(BUILD_DIR)/$(TARGET).elf -S -s

