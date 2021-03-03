move t0, 0
move t1, 0
econst t2, 7
econst s0, 0
econst t4, 0
econst t5, 0
move t6, 50
cmpl v1, t6, 0
move t7, v1
move t8, 1
sub v1, t8, t7
move t7, v1
beq t7, zero, __Runtime_Error__
add v1, t6, 1
move t7, v1
move v0, hp
add hp, hp, t7
move t7, v0
sw t6, 0(t7)
move t0, t7
cmpl v1, t6, 0
move t7, v1
move t8, 1
sub v1, t8, t7
move t7, v1
beq t7, zero, __Runtime_Error__
add v1, t6, 1
move t7, v1
move v0, hp
add hp, hp, t7
move t7, v0
sw t6, 0(t7)
move t1, t7
move t7, 0
__L1_MAIN__:
cmpl v1, t7, t6
move t8, v1
beq t8, zero, __L2_MAIN__
lw t8, 0(t0)
cmpl v1, t7, t8
move t8, v1
beq t8, zero, __Runtime_Error__
cmpl v1, t7, 0
move t8, v1
move t9, 1
sub v1, t9, t8
move t8, v1
beq t8, zero, __Runtime_Error__
add v1, t0, 1
move t8, v1
add v1, t8, t7
move t8, v1
secread t9
sw t9, 0(t8)
lw t8, 0(t1)
cmpl v1, t7, t8
move t8, v1
beq t8, zero, __Runtime_Error__
cmpl v1, t7, 0
move t8, v1
move t3, 1
sub v1, t3, t8
move t8, v1
beq t8, zero, __Runtime_Error__
add v1, t1, 1
move t3, v1
add v1, t3, t7
move t3, v1
secread t8
sw t8, 0(t3)
add v1, t7, 1
move t7, v1
j __L1_MAIN__
__L2_MAIN__:
move t3, 0
__L3_MAIN__:
cmpl v1, t3, t6
move t7, v1
beq t7, zero, __L4_MAIN__
lw t7, 0(t0)
cmpl v1, t3, t7
move t7, v1
beq t7, zero, __Runtime_Error__
cmpl v1, t3, 0
move t7, v1
move t8, 1
sub v1, t8, t7
move t7, v1
beq t7, zero, __Runtime_Error__
add v1, t0, 1
move t7, v1
add v1, t7, t3
move t7, v1
lw t7, 0(t7)
move t4, t7
lw t7, 0(t1)
cmpl v1, t3, t7
move t7, v1
beq t7, zero, __Runtime_Error__
cmpl v1, t3, 0
move t7, v1
move t8, 1
sub v1, t8, t7
move t7, v1
beq t7, zero, __Runtime_Error__
add v1, t1, 1
move t7, v1
add v1, t7, t3
move t7, v1
lw t7, 0(t7)
move t5, t7
ecmpeq v1, t4, t2
move t4, v1
econst t7, 0
emux t4, t4, t5, t7
eor v1, s0, t4
move s0, v1
add v1, t3, 1
move t3, v1
j __L3_MAIN__
__L4_MAIN__:
answer s0

__Runtime_Error__:
		move t0, 0xffffffffffffffff
		answer t0

