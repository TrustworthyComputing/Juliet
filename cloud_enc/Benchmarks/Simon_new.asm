move t0, 32
cmpl v1, t0, 0
move t1, v1
move t2, 1
sub v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, t0, 1
move t1, v1
move v0, hp
add hp, hp, t1
move s2, v0
sw t0, 0(s2)
move t0, 2
cmpl v1, t0, 0
move t2, v1
move t3, 1
sub v1, t3, t2
move t2, v1
beq t2, zero, __Runtime_Error__
add v1, t0, 1
move t2, v1
move v0, hp
add hp, hp, t2
move s0, v0
sw t0, 0(s0)
move t0, 2
cmpl v1, t0, 0
move t3, v1
move t4, 1
sub v1, t4, t3
move t3, v1
beq t3, zero, __Runtime_Error__
add v1, t0, 1
move t3, v1
move v0, hp
add hp, hp, t3
move t3, v0
sw t0, 0(t3)
econst t0, 0
econst t4, 0
econst t5, 0
econst t6, 0
move t7, 0
move s1, 0
__L1_MAIN__:
move t9, 32
cmpl v1, s1, t9
move t9, v1
beq t9, zero, __L2_MAIN__
lw t9, 0(s2)
cmpl v1, s1, t9
move t9, v1
beq t9, zero, __Runtime_Error__
cmpl v1, s1, 0
move t9, v1
move t2, 1
sub v1, t2, t9
move t9, v1
beq t9, zero, __Runtime_Error__
add v1, s2, 1
move t2, v1
add v1, t2, s1
move t2, v1
secread t9
sw t9, 0(t2)
add v1, s1, 1
move s1, v1
j __L1_MAIN__
__L2_MAIN__:
lw t2, 0(t3)
move t9, 0
cmpl v1, t9, t2
move t2, v1
beq t2, zero, __Runtime_Error__
cmpl v1, t9, 0
move t2, v1
move t8, 1
sub v1, t8, t2
move t2, v1
beq t2, zero, __Runtime_Error__
add v1, t3, 1
move t2, v1
add v1, t2, t9
move t2, v1
pubread t8
econst t8, t8
sw t8, 0(t2)
lw t2, 0(t3)
move t8, 1
cmpl v1, t8, t2
move t2, v1
beq t2, zero, __Runtime_Error__
cmpl v1, t8, 0
move t2, v1
move t9, 1
sub v1, t9, t2
move t2, v1
beq t2, zero, __Runtime_Error__
add v1, t3, 1
move t2, v1
add v1, t2, t8
move t2, v1
pubread t8
econst t8, t8
sw t8, 0(t2)
lw t2, 0(s0)
move t8, 0
cmpl v1, t8, t2
move t2, v1
beq t2, zero, __Runtime_Error__
cmpl v1, t8, 0
move t2, v1
move t9, 1
sub v1, t9, t2
move t2, v1
beq t2, zero, __Runtime_Error__
add v1, s0, 1
move t2, v1
add v1, t2, t8
move t2, v1
lw t8, 0(t3)
move t9, 0
cmpl v1, t9, t8
move t8, v1
beq t8, zero, __Runtime_Error__
cmpl v1, t9, 0
move t8, v1
move t1, 1
sub v1, t1, t8
move t8, v1
beq t8, zero, __Runtime_Error__
add v1, t3, 1
move t1, v1
add v1, t1, t9
move t1, v1
lw t1, 0(t1)
sw t1, 0(t2)
lw t1, 0(s0)
move t2, 1
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t8, 1
sub v1, t8, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s0, 1
move t1, v1
add v1, t1, t2
move t1, v1
lw t2, 0(t3)
move t8, 1
cmpl v1, t8, t2
move t2, v1
beq t2, zero, __Runtime_Error__
cmpl v1, t8, 0
move t2, v1
move t9, 1
sub v1, t9, t2
move t2, v1
beq t2, zero, __Runtime_Error__
add v1, t3, 1
move t2, v1
add v1, t2, t8
move t2, v1
lw t2, 0(t2)
sw t2, 0(t1)
move t1, 0
move s1, t1
__L3_MAIN__:
move t1, 32
cmpl v1, s1, t1
move t1, v1
beq t1, zero, __L4_MAIN__
lw t1, 0(s0)
move t2, 1
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t3, 1
sub v1, t3, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s0, 1
move t1, v1
add v1, t1, t2
move t1, v1
lw t1, 0(t1)
move t0, t1
lw t1, 0(s0)
move t2, 1
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t3, 1
sub v1, t3, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s0, 1
move t1, v1
add v1, t1, t2
move t1, v1
lw t1, 0(t1)
move t2, 1
esll v1, t1, t2
move t1, v1
move t4, t1
lw t1, 0(s0)
move t2, 1
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t3, 1
sub v1, t3, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s0, 1
move t1, v1
add v1, t1, t2
move t1, v1
lw t1, 0(t1)
move t2, 15
eslr v1, t1, t2
move t1, v1
move t5, t1
eor v1, t4, t5
move t1, v1
move t4, t1
lw t1, 0(s0)
move t2, 1
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t3, 1
sub v1, t3, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s0, 1
move t1, v1
add v1, t1, t2
move t1, v1
lw t1, 0(t1)
move t2, 8
esll v1, t1, t2
move t1, v1
move t5, t1
lw t1, 0(s0)
move t2, 1
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t3, 1
sub v1, t3, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s0, 1
move t1, v1
add v1, t1, t2
move t1, v1
lw t1, 0(t1)
move t2, 8
eslr v1, t1, t2
move t1, v1
move t6, t1
eor v1, t5, t6
move t1, v1
move t5, t1
eand v1, t4, t5
move t1, v1
move t4, t1
lw t1, 0(s0)
move t2, 0
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t3, 1
sub v1, t3, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s0, 1
move t1, v1
add v1, t1, t2
move t1, v1
lw t1, 0(t1)
exor v1, t4, t1
move t1, v1
move t4, t1
lw t1, 0(s0)
move t2, 1
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t3, 1
sub v1, t3, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s0, 1
move t1, v1
add v1, t1, t2
move t1, v1
lw t1, 0(t1)
move t2, 2
esll v1, t1, t2
move t1, v1
move t5, t1
lw t1, 0(s0)
move t2, 1
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t3, 1
sub v1, t3, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s0, 1
move t1, v1
add v1, t1, t2
move t1, v1
lw t1, 0(t1)
move t2, 14
eslr v1, t1, t2
move t1, v1
move t6, t1
eor v1, t5, t6
move t1, v1
move t5, t1
exor v1, t4, t5
move t1, v1
move t4, t1
move t1, 31
sub v1, t1, s1
move t1, v1
move t7, t1
lw t1, 0(s2)
cmpl v1, t7, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t7, 0
move t1, v1
move t2, 1
sub v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s2, 1
move t1, v1
add v1, t1, t7
move t1, v1
lw t1, 0(t1)
exor v1, t4, t1
move t1, v1
move t4, t1
lw t1, 0(s0)
move t2, 1
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t3, 1
sub v1, t3, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s0, 1
move t1, v1
add v1, t1, t2
move t1, v1
sw t4, 0(t1)
lw t1, 0(s0)
move t2, 0
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t3, 1
sub v1, t3, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s0, 1
move t1, v1
add v1, t1, t2
move t1, v1
sw t0, 0(t1)
add v1, s1, 1
move s1, v1
j __L3_MAIN__
__L4_MAIN__:
lw t0, 0(s0)
move t1, 0
cmpl v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, t1, 0
move t0, v1
move t2, 1
sub v1, t2, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s0, 1
move t0, v1
add v1, t0, t1
move t0, v1
lw t0, 0(t0)
print t0
lw t0, 0(s0)
move t1, 1
cmpl v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, t1, 0
move t0, v1
move t2, 1
sub v1, t2, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s0, 1
move t0, v1
add v1, t0, t1
move t0, v1
lw t0, 0(t0)
print t0
econst t0, 0
answer t0

__Runtime_Error__:
		move t0, 0xffffffffffffffff
		answer t0

