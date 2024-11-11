.text
.align 2

.globl _system_time
.globl play_note
.globl _start

_start:
# put gpt_handling to mtvec
la t0, gpt_handling
csrw mtvec, t0

# initialize program stack and irs stack
la t0, isr_stack_end
csrw mscratch, t0
la sp, sp_stack_end

# initialize gpt
la t0, gpt_start
sb x0, 0(t0)
li t1, 100
sw t1, 8(t0)

# set interrupts to be enabled
csrr t1, mie 
li t2, 0x800
or t1, t1, t2
csrw mie, t1

csrr t1, mstatus
ori t1, t1, 0x8
csrw mstatus, t1

# gpt activation
li t1, 1
sb t1, 0(t0)

jal main

gpt_handling:
# save context
csrrw sp, mscratch, sp
addi sp, sp, -64
sw a0, 0(sp)
sw a1, 4(sp)
sw a2, 8(sp)
sw a3, 12(sp)
sw a4, 16(sp)
sw a5, 20(sp)
sw a6, 24(sp)
sw a7, 28(sp)
sw t0, 32(sp)
sw t1, 36(sp)
sw t2, 40(sp)
sw t3, 44(sp)
sw t4, 48(sp)
sw t5, 52(sp)
sw t6, 56(sp)

# gpt activation
la a0, gpt_start
li a1, 1
sb a1, 0(a0)

# add 100 to system time
la a2, _system_time
lw a1, 0(a2)
addi a1, a1, 100
sw a1, 0(a2)

# set next interrupt
li a1, 100
sw a1, 8(a0)

# restore context
lw a0, 0(sp)
lw a1, 4(sp)
lw a2, 8(sp)
lw a3, 12(sp)
lw a4, 16(sp)
lw a5, 20(sp)
lw a6, 24(sp)
lw a7, 28(sp)
lw t0, 32(sp)
lw t1, 36(sp)
lw t2, 40(sp)
lw t3, 44(sp)
lw t4, 48(sp)
lw t5, 52(sp)
lw t6, 56(sp)
addi sp, sp, 64
csrrw sp, mscratch, sp
mret

# void play_note(int ch, int inst, int note, int vel, int dur); - a0 = ch, a1 = inst, a2 = note, a3 = vel, a4 = dur
play_note:

la t0, midi_start
sh a1, 2(t0)
sb a2, 4(t0)
sb a3, 5(t0)
sh a4, 6(t0)
sb a0, 0(t0)

ret

.data
.align 2
.set gpt_start, 0xFFFF0100
.set midi_start, 0xFFFF0300

.globl _system_time
.set _system_time, 0

.bss
.align 4

.globl isr_stack_end
isr_stack: .skip 1024      
isr_stack_end: 

.globl sp_stack_end
sp_stack: .skip 1024    
sp_stack_end: 