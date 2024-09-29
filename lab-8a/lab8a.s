/*
a3 = tamanho horizontal (comprimento); a4 = tamanho vertical (largura)
a5 = file descriptor; a6 = ponteiro para imagem

*/

.bss
    .align 2
    input_address: .skip 0x4001C

.data
    .align 2
    input_file: .asciz "image.pgm"

.text
    .align 2
open_file:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open
    ecall


read:
    la a1, input_address #  buffer to write the data
    li a2, 262172  # size
    li a7, 63 # syscall read (63)
    ecall

    mv a5, a1
    addi a5, a5, 3
    j set_size

to_integer:
    li t0, 0
    li t4, 32
    li t5, 10

    loop:
    lbu t1, (a1)
    beq t1, t4, end_loop
    beq t1, t5, end_loop
    mul t0, t0, t5
    addi t1, t1, -48
    add t0, t0, t1
    addi a1, a1, 1
    j loop

    end_loop:
    addi a1, a1, 1
    jalr x0, 0(a0)

set_size: # process image size
    mv a1, a5
    jal a0, to_integer
    mv a3, t0
    jal a0, to_integer
    mv a4, t0
    mv a5, a1

    mv a0, a3
    mv a1, a4
    li a7, 2201 # syscall setCanvasSize (2201)
    ecall

    addi a5, a5, 4
    j process_image

set_pixel:
    process_rgb:
    mv t5, t2
    slli t5, t5, 8
    add t5, t5, t2
    slli t5, t5, 8
    add t5, t5, t2
    slli t5, t5, 8
    addi t5, t5, 0xFF

    mv a0, t0 # x coordinate = t0
    mv a1, t1 # y coordinate = t1
    mv a2, t5 # pixel of color t2
    li a7, 2200 # syscall setPixel (2200)
    ecall

    jalr x0, 0(t6)

process_image:
    # initialize x and y
    li t0, 0
    li t1, 0
    # loop of pixel setting
    mv t3, a3
    mv t4, a4
    do:
        lbu t2, (a5)
        addi a5, a5, 1
        jal t6, set_pixel
        addi t0, t0, 1
        blt t0, t3, do
        addi t1, t1, 1
        li t0, 0
        blt t1, t4, do

/* "The setScaling syscall can be used to scale the resulting image,
    in order to inspect the resulting image. However, it must not be 
    used when running with the assistant."
*/


close_file:
    mv a0, a5            # file descriptor (fd) 3
    li a7, 57            # syscall close
    ecall




