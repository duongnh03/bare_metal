#include "uart.h" // Sử dụng driver UART mới thay vì semihosting

int main() {
    // Khởi tạo phần cứng UART ảo
    uart_init();
    
    // Gửi chuỗi ký tự qua UART
    uart_puts("Hello kitty \n");

    // Vòng lặp vô tận để dừng CPU sau khi đã hoàn thành công việc.
    while (1) {
        // Do nothing
    }

    return 0;
}

