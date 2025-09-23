#include "uart.h"

// Hàm khởi tạo UART (hiện tại chưa cần làm gì phức tạp)
void uart_init() {
    // Trong môi trường QEMU, UART thường đã được cấu hình sẵn.
    // Nếu làm trên phần cứng thật, chúng ta sẽ cần cài đặt baud rate,
    // số bit, parity... ở đây bằng cách ghi vào các thanh ghi LCR, DLL, DLM.
}

// Hàm gửi một ký tự qua UART
void uart_putc(char c) {
    // --- Sử dụng "Bản Đồ" đã định nghĩa trong uart.h ---

    // Chuyển đổi địa chỉ số thành con trỏ để có thể truy cập
    // 'volatile' báo cho trình biên dịch rằng giá trị này có thể thay đổi
    // bất ngờ từ bên ngoài, không được tối ưu hóa việc đọc/ghi.
    volatile uint8_t* lsr = (uint8_t*)UART_LSR; // Thanh ghi Line Status
    volatile uint8_t* thr = (uint8_t*)UART_THR; // Thanh ghi Transmit Holding

    // Đợi cho đến khi bit "Transmitter Holding Register Empty" (THRE)
    // trong thanh ghi LSR được bật lên 1.
    // Điều này đảm bảo rằng bộ truyền đã sẵn sàng nhận dữ liệu mới.
    // Vòng lặp while này sẽ chạy liên tục cho đến khi điều kiện đúng.
    while ((*lsr & LSR_TX_EMPTY) == 0) {
        // Không làm gì cả, chỉ đợi. Đây gọi là polling.
    }

    // Khi bộ truyền đã sẵn sàng, ghi ký tự cần gửi vào thanh ghi THR.
    *thr = c;
}

// Hàm gửi cả một chuỗi ký tự
void uart_puts(const char* s) {
    // Lặp qua từng ký tự của chuỗi
    while (*s) {
        // Gọi hàm uart_putc để gửi từng ký tự một
        uart_putc(*s);
        s++; // Chuyển sang ký tự tiếp theo
    }
}

