.section .text.init
.global _start

_start:
    # 1. Khởi tạo con trỏ ngăn xếp (Stack Pointer - sp)
    #    'la' (load address) là một lệnh giả (pseudo-instruction)
    #    nó sẽ được assembler chuyển thành các lệnh auipc và addi
    #    để nạp địa chỉ của _stack_top vào thanh ghi sp.
    la sp, _stack_top

    # 2. Nhảy đến hàm main() trong C
    #    'jal' (jump and link) sẽ nhảy đến hàm main và lưu địa chỉ
    #    quay về (return address) vào thanh ghi ra (x1).
    jal main

    # 3. Vòng lặp vô tận
    #    Nếu hàm main có lỡ return, chúng ta sẽ giữ CPU ở đây
    #    để nó không chạy vào vùng nhớ rác.
hang:
    j hang

# --- HÀM SEMIHOSTING BẰNG ASSEMBLY ---
# Đây là hàm mới, được gọi từ C, để thực hiện lời gọi hệ thống.
# Nó nhận các tham số qua thanh ghi a0 và a1 theo đúng quy ước ABI.
.global semihosting_call
semihosting_call:
    # Các tham số đã được C compiler đặt sẵn vào a0 và a1.
    # Chỉ cần thực hiện lệnh sbreak.
    sbreak
    # Quay trở về hàm C đã gọi nó.
    ret

