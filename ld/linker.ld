/*
 * Linker script cho chương trình bare-metal RISC-V 64-bit
 * Chạy trên máy ảo QEMU 'virt'
 */
ENTRY(_start) /* Chỉ định điểm bắt đầu chương trình là nhãn _start */

MEMORY
{
  /* * Máy ảo 'virt' của QEMU cung cấp RAM bắt đầu từ địa chỉ 0x80000000.
   * Chúng ta sẽ sử dụng 128MB RAM.
   */
  RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 128M /*(gia tri mac dinh va pho bien cua QEMU)*/
}

SECTIONS
{
  . = ORIGIN(RAM); /* Bắt đầu đặt các section từ đầu vùng RAM (bat buoc) */

  .text :
  {
    *(.text.init) /* Section khởi tạo */
    *(.text)      /* Các section mã lệnh khác */
  } > RAM

  .rodata :
  {
    *(.rodata)    /* Section dữ liệu chỉ đọc */
  } > RAM

  .data :
  {
    *(.data)      /* Section dữ liệu đã khởi tạo */
  } > RAM

  .bss :
  {
    *(.bss)       /* Section dữ liệu chưa khởi tạo (sẽ được gán bằng 0) */
  } > RAM

  /* ---- GIẢI PHÁP ----: Định nghĩa vị trí đỉnh của ngăn xếp */
  /* Ngăn xếp sẽ phát triển từ trên xuống dưới, nên chúng ta đặt đỉnh của nó
   * ở địa chỉ cao nhất của RAM.
   */
  _stack_top = ORIGIN(RAM) + LENGTH(RAM); 
  /* là một quyết định kiến trúc có chủ đích, dựa trên nguyên tắc cơ bản về cách ngăn xếp phát triển trong bộ 
   * nhớ, nhằm tạo ra một không gian hoạt động an toàn và tối ưu cho chương trình 
   */
}

