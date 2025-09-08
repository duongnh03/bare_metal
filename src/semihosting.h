#ifndef SEMIHOSTING_H
#define SEMIHOSTING_H

// --- BƯỚC 1: KHAI BÁO HÀM ASSEMBLY BÊN NGOÀI ---
// Khai báo sự tồn tại của hàm 'semihosting_call' được viết trong file start.S.
// Hàm này là cầu nối an toàn nhất để thực hiện lệnh 'sbreak'.
extern long semihosting_call(long op_code, const void* arg_block);


// --- BƯỚC 2: ĐỊNH NGHĨA HÀM WRAPPER TRONG C (PHIÊN BẢN GỠ LỖI) ---

// Định nghĩa mã lệnh cho thao tác in MỘT KÝ TỰ (SYS_WRITEC)
// Đây là thao tác semihosting đơn giản nhất.
#define SYS_WRITEC 0x03

// Hàm này chuẩn bị các tham số và gọi hàm assembly 'semihosting_call'
// để in MỘT ký tự duy nhất.
static inline void semihosting_putc(char c) {
    // Đối với SYS_WRITEC, tham số thứ hai (thanh ghi a1) phải là
    // địa chỉ của ký tự cần in.
    semihosting_call(SYS_WRITEC, &c);
}

#endif // SEMIHOSTING_H


