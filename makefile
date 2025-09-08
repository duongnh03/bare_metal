# Tên file thực thi cuối cùng
TARGET = app

# Tiền tố của bộ công cụ RISC-V
TOOL_PREFIX = riscv64-unknown-elf-


#===========================================================================

# Các công cụ
CC = $(TOOL_PREFIX)gcc #Trình biên dịch C (riscv64-unknown-elf-gcc).
AS = $(TOOL_PREFIX)as  #Trình biên dịch Assembly (riscv64-unknown-elf-as).
LD = $(TOOL_PREFIX)ld  #Trình liên kết (riscv64-unknown-elf-ld).
OBJDUMP = $(TOOL_PREFIX)objdump #Công cụ để xem thông tin về file object.
GDB = $(TOOL_PREFIX)gdb         #trinh go loi.

#===========================================================================


QEMU = qemu-system-riscv64
#Trình giả lập QEMU để chạy chương trình


#===========================================================================

QEMU_FLAGS = -nographic -machine virt -m 128M -bios none

#-nographic                                : Vô hiệu hóa giao diện đồ họa.
#-machine virt                             : Chọn máy ảo là virt
#-m 128M                                   : Cấp phát 128MB RAM.
#-bios none                                : Đây là một thay đổi quan trọng, ngăn QEMU nạp firmware mặc định để tránh xung đột địa chỉ.

#===========================================================================


CFLAGS = -march=rv64gc -mabi=lp64d -mcmodel=medany -fno-pie -g -O0 -ffreestanding -nostdlib
ASFLAGS = -march=rv64gc -mabi=lp64d -mcmodel=medany -fno-pie -g

#-march=rv64gc -mabi=lp64d                 : Chỉ định kiến trúc và giao diện ABI.
#-mcmodel=medany                           : Thay đổi cơ bản từ medlow sang medany, cho phép chương trình lớn hơn.
#-fno-pie -g -O0 -ffreestanding -nostdlib  : Vô hiệu hóa mã độc lập vị trí, bật debug, tối ưu hóa mức 0, và không sử dụng thư viện chuẩn.

LDFLAGS = -T ld/linker.ld -nostdlib -g # Cờ cho trình liên kết

#T ld/linker.ld                            : Chỉ định sử dụng file script liên kết linker.ld để kiểm soát bố cục bộ nhớ.
#nostdlib -g   							   : Không liên kết với các thư viện chuẩn, và bật debug.


#===========================================================================



# Đường dẫn
SRC_DIR = src
LD_DIR = ld
BUILD_DIR = build

# Tìm tất cả các file nguồn .c và .S/.s
C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
S_SOURCES = $(wildcard $(SRC_DIR)/*.s)

# Tạo danh sách các file object (.o) tương ứng
OBJECTS =  $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SOURCES))
OBJECTS += $(patsubst $(SRC_DIR)/%.S, $(BUILD_DIR)/%.o, $(filter %.S, $(S_SOURCES)))
OBJECTS += $(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.o, $(filter %.s, $(S_SOURCES)))


# File ELF cuối cùng
ELF_FILE = $(BUILD_DIR)/$(TARGET).elf

#===========================================================================

# Target mặc định khi gõ 'make'
all: $(ELF_FILE)

# Quy tắc để liên kết các file object thành file ELF
$(ELF_FILE): $(OBJECTS)
	@echo "Linking..."
# Sử dụng ld trực tiếp để kiểm soát hoàn toàn quá trình liên kết
	@$(LD) -o $@ $(OBJECTS) $(LDFLAGS)
	@echo "Build successful: $@"

# Quy tắc để biên dịch file .c thành .o
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(BUILD_DIR)
	@echo "Compiling C: $<"
	@$(CC) $(CFLAGS) -c $< -o $@

# Thêm quy tắc để biên dịch file .s (viết thường)
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(BUILD_DIR)
	@echo "Assembling: $<"
	@$(CC) $(ASFLAGS) -c $< -o $@

#===========================================================================

# Chạy chương trình trên QEMU với semihosting
run: $(ELF_FILE)
	@echo "Running with QEMU..."
	@$(QEMU) $(QEMU_FLAGS) -kernel $(ELF_FILE) -semihosting

# Chạy QEMU ở chế độ debug, chờ GDB kết nối
debug: $(ELF_FILE)
	@echo "Starting QEMU in debug mode. Waiting for GDB on :1234..."
	@$(QEMU) $(QEMU_FLAGS) -kernel $(ELF_FILE) -semihosting -S -s

# Dọn dẹp các file đã build
clean:
	@echo "Cleaning build files..."
	@rm -rf $(BUILD_DIR)

# Khai báo các target không phải là file
.PHONY: all run debug clean

