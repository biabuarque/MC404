.bss
.align 2
isr_stack:       
.skip 1024      
isr_stack_end: 
sp_stack:   
.skip 1024    
sp_stack_end: 

.text
.align 2

.set gpt_start, 0xffff0100
.set gpt_time, 0xffff0104
.set gpt_generate, 0xffff0108
.set midi_ch, 0xffff0300
.set midi_id, 0xffff0302
.set midi_note, 0xffff0304
.set midi_vel, 0xffff0305
.set midi_dur, 0xffff0306

.globl _system_time
_system_time: .word 0

.globl _start
_start:
# initialize program stack and irs stack
la t0, isr_stack_end
csrw mscratch, t0
la sp, sp_stack_end

# initialize gpt
li a0, gpt_start
li a1, 1
sw a1, 0(a0)
li a0, gpt_generate
li a1, 100
sw a1, 0(a0)

# put gpt_handling to mtvec
la t0, gpt_handling
csrw mtvec, t0
# set interrupts to be enabled
csrr t1, mie 
li t2, 0x800
csrw mie, t1
csrr t1, mstatus
ori t1, t1, 0x8
csrw mstatus, t1

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
sw ra, 60(sp)

# treat exception
la a0, _system_time
lw a1, 0(a0)
addi a1, a1, 100
sw a1, 0(a0)

# set next interrupt
li a0, gpt_generate
li a1, 100
sw a1, 0(a0)

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
lw ra, 60(sp)
csrrw sp, mscratch, sp
mret

.globl play_note # void play_note(int ch, int inst, int note, int vel, int dur); - a0 = ch, a1 = inst, a2 = note, a3 = vel, a4 = dur
play_note:
addi sp, sp, -4
sw t0, 0(sp)

mv t0, a0
li a0, midi_ch
sw t0, 0(a0)

li a0, midi_id
sw a1, 0(a0)

li a0, midi_note
sw a2, 0(a0)

li a0, midi_vel
sw a3, 0(a0)

li a0, midi_dur
sw a4, 0(a0)

lw t0, 0(sp)
addi sp, sp, 4
ret
