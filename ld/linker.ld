/*
 * Kịch bản cho Linker (Linker Script)
 * Nhiệm vụ:
 * 1. Định nghĩa điểm bắt đầu của chương trình (_start).
 * 2. Mô tả bản đồ bộ nhớ của hệ thống (chỉ có RAM).
 * 3. Sắp xếp các section (như .text, .rodata) vào đúng vị trí trong RAM.
 * 4. Định nghĩa các ký hiệu (symbol) quan trọng, ví dụ như đỉnh của ngăn xếp.
 */

ENTRY(_start)

MEMORY
{
  /* Hệ thống có 128MB RAM bắt đầu từ địa chỉ 0x80000000 */
  RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS
{
  /* Section chứa mã lệnh thực thi */
  .text :
  {
    *(.text.init) /* Đảm bảo mã khởi động nằm ở đầu tiên */
    *(.text .text.*)
  } > RAM

  /* Section chứa dữ liệu chỉ đọc (hằng số) */
  .rodata :
  {
    *(.rodata .rodata.*)
  } > RAM

  /* Section chứa dữ liệu đã được khởi tạo */
  .data :
  {
    *(.data .data.*)
  } > RAM

  /* Section chứa dữ liệu chưa được khởi tạo (sẽ được gán giá trị 0) */
  .bss :
  {
    *(.bss .bss.*)
  } > RAM

  /*
   * Định nghĩa một ký hiệu trỏ đến đỉnh của RAM.
   * Mã assembly khởi động sẽ sử dụng ký hiệu này để thiết lập Stack Pointer.
   */
  _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}

