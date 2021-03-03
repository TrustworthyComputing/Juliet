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
move t1, v0
sw t0, 0(t1)
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
move t2, v0
sw t0, 0(t2)
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
move t4, 0
__L1_MAIN__:
move t5, 32
cmpl v1, t4, t5
move t5, v1
beq t5, zero, __L2_MAIN__
lw t5, 0(t1)
cmpl v1, t4, t5
move t5, v1
beq t5, zero, __Runtime_Error__
cmpl v1, t4, 0
move t5, v1
move t6, 1
sub v1, t6, t5
move t5, v1
beq t5, zero, __Runtime_Error__
add v1, t1, 1
move t5, v1
add v1, t5, t4
move t5, v1
secread t6
sw t6, 0(t5)
add v1, t4, 1
move t4, v1
j __L1_MAIN__
__L2_MAIN__:
lw t5, 0(t3)
move t6, 0
cmpl v1, t6, t5
move t5, v1
beq t5, zero, __Runtime_Error__
cmpl v1, t6, 0
move t5, v1
move t7, 1
sub v1, t7, t5
move t5, v1
beq t5, zero, __Runtime_Error__
add v1, t3, 1
move t5, v1
add v1, t5, t6
move t5, v1
pubread t6
econst t6, t6
sw t6, 0(t5)
lw t5, 0(t3)
move t6, 1
cmpl v1, t6, t5
move t5, v1
beq t5, zero, __Runtime_Error__
cmpl v1, t6, 0
move t5, v1
move t7, 1
sub v1, t7, t5
move t5, v1
beq t5, zero, __Runtime_Error__
add v1, t3, 1
move t5, v1
add v1, t5, t6
move t5, v1
pubread t6
econst t6, t6
sw t6, 0(t5)
lw t5, 0(t2)
move t6, 0
cmpl v1, t6, t5
move t5, v1
beq t5, zero, __Runtime_Error__
cmpl v1, t6, 0
move t5, v1
move t7, 1
sub v1, t7, t5
move t5, v1
beq t5, zero, __Runtime_Error__
add v1, t2, 1
move t5, v1
add v1, t5, t6
move t5, v1
lw t6, 0(t3)
move t7, 0
cmpl v1, t7, t6
move t6, v1
beq t6, zero, __Runtime_Error__
cmpl v1, t7, 0
move t6, v1
move t8, 1
sub v1, t8, t6
move t6, v1
beq t6, zero, __Runtime_Error__
add v1, t3, 1
move t6, v1
add v1, t6, t7
move t6, v1
lw t6, 0(t6)
sw t6, 0(t5)
lw t5, 0(t2)
move t6, 1
cmpl v1, t6, t5
move t5, v1
beq t5, zero, __Runtime_Error__
cmpl v1, t6, 0
move t5, v1
move t7, 1
sub v1, t7, t5
move t5, v1
beq t5, zero, __Runtime_Error__
add v1, t2, 1
move t5, v1
add v1, t5, t6
move t5, v1
lw t6, 0(t3)
move t7, 1
cmpl v1, t7, t6
move t6, v1
beq t6, zero, __Runtime_Error__
cmpl v1, t7, 0
move t6, v1
move t8, 1
sub v1, t8, t6
move t6, v1
beq t6, zero, __Runtime_Error__
add v1, t3, 1
move t3, v1
add v1, t3, t7
move t3, v1
lw t3, 0(t3)
sw t3, 0(t5)
move t3, 0
move t4, t3
__L3_MAIN__:
move t3, 32
cmpl v1, t4, t3
move t3, v1
beq t3, zero, __L4_MAIN__
lw t3, 0(t2)
move t5, 1
cmpl v1, t5, t3
move t3, v1
beq t3, zero, __Runtime_Error__
cmpl v1, t5, 0
move t3, v1
move t6, 1
sub v1, t6, t3
move t3, v1
beq t3, zero, __Runtime_Error__
add v1, t2, 1
move t3, v1
add v1, t3, t5
move t3, v1
lw t3, 0(t3)
move t0, t3
lw t3, 0(t2)
move t5, 1
cmpl v1, t5, t3
move t3, v1
beq t3, zero, __Runtime_Error__
cmpl v1, t5, 0
move t3, v1
move t6, 1
sub v1, t6, t3
move t3, v1
beq t3, zero, __Runtime_Error__
add v1, t2, 1
move t3, v1
add v1, t3, t5
move t3, v1
lw t5, 0(t2)
move t6, 0
cmpl v1, t6, t5
move t5, v1
beq t5, zero, __Runtime_Error__
cmpl v1, t6, 0
move t5, v1
move t7, 1
sub v1, t7, t5
move t5, v1
beq t5, zero, __Runtime_Error__
add v1, t2, 1
move t5, v1
add v1, t5, t6
move t5, v1
lw t5, 0(t5)
lw t6, 0(t2)
move t7, 1
cmpl v1, t7, t6
move t6, v1
beq t6, zero, __Runtime_Error__
cmpl v1, t7, 0
move t6, v1
move t8, 1
sub v1, t8, t6
move t6, v1
beq t6, zero, __Runtime_Error__
add v1, t2, 1
move t6, v1
add v1, t6, t7
move t6, v1
lw t6, 0(t6)
move t7, 1
esll v1, t6, t7
move t6, v1
lw t7, 0(t2)
move t8, 1
cmpl v1, t8, t7
move t7, v1
beq t7, zero, __Runtime_Error__
cmpl v1, t8, 0
move t7, v1
move t9, 1
sub v1, t9, t7
move t7, v1
beq t7, zero, __Runtime_Error__
add v1, t2, 1
move t7, v1
add v1, t7, t8
move t7, v1
lw t7, 0(t7)
move t8, 15
eslr v1, t7, t8
move t7, v1
eor v1, t6, t7
move t6, v1
exor v1, t5, t6
move t5, v1
lw t6, 0(t2)
move t7, 1
cmpl v1, t7, t6
move t6, v1
beq t6, zero, __Runtime_Error__
cmpl v1, t7, 0
move t6, v1
move t8, 1
sub v1, t8, t6
move t6, v1
beq t6, zero, __Runtime_Error__
add v1, t2, 1
move t6, v1
add v1, t6, t7
move t6, v1
lw t6, 0(t6)
move t7, 8
esll v1, t6, t7
move t6, v1
lw t7, 0(t2)
move t8, 1
cmpl v1, t8, t7
move t7, v1
beq t7, zero, __Runtime_Error__
cmpl v1, t8, 0
move t7, v1
move t9, 1
sub v1, t9, t7
move t7, v1
beq t7, zero, __Runtime_Error__
add v1, t2, 1
move t7, v1
add v1, t7, t8
move t7, v1
lw t7, 0(t7)
move t8, 8
eslr v1, t7, t8
move t7, v1
eor v1, t6, t7
move t6, v1
eand v1, t5, t6
move t5, v1
lw t6, 0(t2)
move t7, 1
cmpl v1, t7, t6
move t6, v1
beq t6, zero, __Runtime_Error__
cmpl v1, t7, 0
move t6, v1
move t8, 1
sub v1, t8, t6
move t6, v1
beq t6, zero, __Runtime_Error__
add v1, t2, 1
move t6, v1
add v1, t6, t7
move t6, v1
lw t6, 0(t6)
move t7, 2
esll v1, t6, t7
move t6, v1
lw t7, 0(t2)
move t8, 1
cmpl v1, t8, t7
move t7, v1
beq t7, zero, __Runtime_Error__
cmpl v1, t8, 0
move t7, v1
move t9, 1
sub v1, t9, t7
move t7, v1
beq t7, zero, __Runtime_Error__
add v1, t2, 1
move t7, v1
add v1, t7, t8
move t7, v1
lw t7, 0(t7)
move t8, 14
eslr v1, t7, t8
move t7, v1
eor v1, t6, t7
move t6, v1
exor v1, t5, t6
move t5, v1
lw t6, 0(t1)
move t7, 31
sub v1, t7, t4
move t7, v1
cmpl v1, t7, t6
move t6, v1
beq t6, zero, __Runtime_Error__
cmpl v1, t7, 0
move t6, v1
move t8, 1
sub v1, t8, t6
move t6, v1
beq t6, zero, __Runtime_Error__
add v1, t1, 1
move t6, v1
add v1, t6, t7
move t6, v1
lw t6, 0(t6)
exor v1, t5, t6
move t5, v1
sw t5, 0(t3)
lw t3, 0(t2)
move t5, 0
cmpl v1, t5, t3
move t3, v1
beq t3, zero, __Runtime_Error__
cmpl v1, t5, 0
move t3, v1
move t6, 1
sub v1, t6, t3
move t3, v1
beq t3, zero, __Runtime_Error__
add v1, t2, 1
move t3, v1
add v1, t3, t5
move t3, v1
sw t0, 0(t3)
add v1, t4, 1
move t4, v1
j __L3_MAIN__
__L4_MAIN__:
lw t0, 0(t2)
move t1, 0
cmpl v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, t1, 0
move t0, v1
move t3, 1
sub v1, t3, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, t2, 1
move t0, v1
add v1, t0, t1
move t0, v1
lw t0, 0(t0)
print t0
lw t0, 0(t2)
move t1, 1
cmpl v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, t1, 0
move t0, v1
move t3, 1
sub v1, t3, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, t2, 1
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

