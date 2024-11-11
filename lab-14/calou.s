.text

.globl _start
.globl main
.globl play_note
.globl _system_time

_start:
    la t0, gpt_isr              #
    csrw mtvec, t0              #

    la t0, isr_stack_end        # base da pilha
    csrw mscratch, t0           # 

    csrr t1, mie                # 
    li t2, 0x800                #
    or t1, t1, t2               # 
    csrw mie, t1                # 

    csrr t1, mstatus            # Habilita interrupções
    ori t1, t1, 0x8             # 
    csrw mstatus, t1            # 

    la t0, base_GPT             # generate interrupt after 100ms
    li t1, 100                  # 
    sw t1, 0x08(t0)             # 

    jal main

    jal exit

gpt_isr:
# Generate interrupts every 100 ms

    # Salvar o contexto
    csrrw sp, mscratch, sp      # Troca sp com mscratch
    addi sp, sp, -64            # Aloca espaço na pilha da ISR
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)

    la a0, base_GPT             # triggers the GPT
    li a1, 1                    # 
    sb a1, 0X00(a0)             # 

    read:
        lb a1, 0x00(a0)         # wait the read
        bnez a1, read           #

    lw a1, 0x04(a0)             # time of the last momment 
    la a2, _system_time         # reading by GPT
    sw a1, 0x00(a2)             # 

    li a1, 100                  # external interruption
    sw a1, 0x08(a0)             # after 100ms

    lw a2, 8(sp)
    lw a1, 4(sp)
    lw a0, 0(sp)

    addi sp, sp, 64             # Desaloca espaço da pilha da ISR
    csrrw sp, mscratch, sp      # Troca sp com mscratch
    mret                        # Retorna da interrupção

play_note:
# Access the MIDI Synthesizer peripheral through MMIO
#
# Input:    a0: ch: channel
#           a1: inst: instrument ID 
#           a2: note: musical note
#           a3: vel: note velocity 
#           a4: dur: note duration 

    la t0, base_MIDI
    sb a0, 0x00(t0)
    sh a1, 0x02(t0)
    sb a2, 0x04(t0)
    sb a3, 0x05(t0)
    sh a4, 0x06(t0)

    ret

exit:
# Calls exit syscall to finish execution.
#
# Input:    a0: return code

    li a7, 93
    ecall

.data
.set base_GPT, 0xFFFF0100
.set base_MIDI, 0xFFFF0300

.globl _system_time
.set _system_time, 0

.bss
.align 4
isr_stack: .skip 0x100
isr_stack_end: