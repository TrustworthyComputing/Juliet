move t0, 2
move s1, 2
move t2, 0
move t2, 2
move t3, 0
move s0, 0
econst s2, 0
econst t6, 0
econst s3, 0
econst t8, 0
move t9, 0
move t4, 0
econst t4, t0
econst t1, s1
emult v1, t4, t1
move t1, v1
cmpl v1, t1, 0
move t4, v1
move t5, 1
sub v1, t5, t4
move t4, v1
beq t4, zero, __Runtime_Error__
add v1, t1, 1
move t4, v1
move v0, hp
add hp, hp, t4
move t4, v0
sw t1, 0(t4)
cmpl v1, t2, 0
move t1, v1
move t5, 1
sub v1, t5, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, t2, 1
move t1, v1
move v0, hp
add hp, hp, t1
move t1, v0
sw t2, 0(t1)
cmpl v1, s1, 0
move t5, v1
move t7, 1
sub v1, t7, t5
move t5, v1
beq t5, zero, __Runtime_Error__
add v1, s1, 1
move t5, v1
move v0, hp
add hp, hp, t5
move s4, v0
sw s1, 0(s4)
cmpl v1, s1, 0
move t7, v1
move t5, 1
sub v1, t5, t7
move t7, v1
beq t7, zero, __Runtime_Error__
add v1, s1, 1
move t5, v1
move v0, hp
add hp, hp, t5
move s5, v0
sw s1, 0(s5)
cmpl v1, s1, 0
move t7, v1
move t5, 1
sub v1, t5, t7
move t7, v1
beq t7, zero, __Runtime_Error__
add v1, s1, 1
move t5, v1
move v0, hp
add hp, hp, t5
move s6, v0
sw s1, 0(s6)
__L1_MAIN__:
cmpl v1, s0, s1
move t7, v1
beq t7, zero, __L2_MAIN__
lw t7, 0(s4)
cmpl v1, s0, t7
move t7, v1
beq t7, zero, __Runtime_Error__
cmpl v1, s0, 0
move t7, v1
move t5, 1
sub v1, t5, t7
move t7, v1
beq t7, zero, __Runtime_Error__
add v1, s4, 1
move t5, v1
add v1, t5, s0
move t5, v1
econst t7, 0
sw t7, 0(t5)
add v1, s0, 1
move s0, v1
j __L1_MAIN__
__L2_MAIN__:
move t5, 0
move s0, t5
__L3_MAIN__:
cmpl v1, s0, s1
move t5, v1
beq t5, zero, __L4_MAIN__
move t5, 0
move t3, t5
__L5_MAIN__:
cmpl v1, t3, t0
move t5, v1
beq t5, zero, __L6_MAIN__
mult v1, s0, t0
move t5, v1
move t9, t5
add v1, t9, t3
move t9, v1
lw t5, 0(t4)
cmpl v1, t9, t5
move t5, v1
beq t5, zero, __Runtime_Error__
cmpl v1, t9, 0
move t5, v1
move t7, 1
sub v1, t7, t5
move t5, v1
beq t5, zero, __Runtime_Error__
add v1, t4, 1
move t5, v1
add v1, t5, t9
move t5, v1
secread t7
sw t7, 0(t5)
add v1, t3, 1
move t3, v1
j __L5_MAIN__
__L6_MAIN__:
add v1, s0, 1
move s0, v1
j __L3_MAIN__
__L4_MAIN__:
move t5, 0
move s0, t5
__L7_MAIN__:
cmpl v1, s0, t2
move t5, v1
beq t5, zero, __L8_MAIN__
lw t5, 0(t1)
cmpl v1, s0, t5
move t5, v1
beq t5, zero, __Runtime_Error__
cmpl v1, s0, 0
move t5, v1
move t7, 1
sub v1, t7, t5
move t5, v1
beq t5, zero, __Runtime_Error__
add v1, t1, 1
move t5, v1
add v1, t5, s0
move t5, v1
secread t7
sw t7, 0(t5)
add v1, s0, 1
move s0, v1
j __L7_MAIN__
__L8_MAIN__:
move t2, 0
move s0, t2
__L9_MAIN__:
cmpl v1, s0, s1
move t2, v1
beq t2, zero, __L10_MAIN__
econst t2, 1
move t8, t2
move t2, 0
move t3, t2
__L11_MAIN__:
cmpl v1, t3, t0
move t2, v1
beq t2, zero, __L12_MAIN__
mult v1, s0, t0
move t2, v1
move t9, t2
add v1, t9, t3
move t9, v1
lw t2, 0(t1)
cmpl v1, t3, t2
move t2, v1
beq t2, zero, __Runtime_Error__
cmpl v1, t3, 0
move t2, v1
move t5, 1
sub v1, t5, t2
move t2, v1
beq t2, zero, __Runtime_Error__
add v1, t1, 1
move t2, v1
add v1, t2, t3
move t2, v1
lw t2, 0(t2)
emult v1, t8, t2
move t2, v1
move t8, t2
lw t2, 0(t4)
cmpl v1, t9, t2
move t2, v1
beq t2, zero, __Runtime_Error__
cmpl v1, t9, 0
move t2, v1
move t5, 1
sub v1, t5, t2
move t2, v1
beq t2, zero, __Runtime_Error__
add v1, t4, 1
move t2, v1
add v1, t2, t9
move t2, v1
lw t2, 0(t2)
emult v1, t8, t2
move t2, v1
move t8, t2
lw t2, 0(s4)
cmpl v1, s0, t2
move t2, v1
beq t2, zero, __Runtime_Error__
cmpl v1, s0, 0
move t2, v1
move t5, 1
sub v1, t5, t2
move t2, v1
beq t2, zero, __Runtime_Error__
add v1, s4, 1
move t2, v1
add v1, t2, s0
move t2, v1
lw t2, 0(t2)
move s2, t2
eadd v1, s2, t8
move s2, v1
lw t2, 0(s4)
cmpl v1, s0, t2
move t2, v1
beq t2, zero, __Runtime_Error__
cmpl v1, s0, 0
move t2, v1
move t5, 1
sub v1, t5, t2
move t2, v1
beq t2, zero, __Runtime_Error__
add v1, s4, 1
move t2, v1
add v1, t2, s0
move t2, v1
sw s2, 0(t2)
add v1, t3, 1
move t3, v1
j __L11_MAIN__
__L12_MAIN__:
add v1, s0, 1
move s0, v1
j __L9_MAIN__
__L10_MAIN__:
move t0, 0
move s0, t0
__L13_MAIN__:
cmpl v1, s0, s1
move t0, v1
beq t0, zero, __L14_MAIN__
lw t0, 0(s5)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s5, 1
move t0, v1
add v1, t0, s0
move t0, v1
lw t1, 0(s4)
cmpl v1, s0, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, s0, 0
move t1, v1
move t2, 1
sub v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, s4, 1
move t1, v1
add v1, t1, s0
move t1, v1
lw t1, 0(t1)
sw t1, 0(t0)
lw t0, 0(s5)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s5, 1
move t0, v1
add v1, t0, s0
move t0, v1
lw t0, 0(t0)
move s2, t0
lw t0, 0(s4)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s4, 1
move t0, v1
add v1, t0, s0
move t0, v1
lw t0, 0(t0)
emult v1, s2, t0
move t0, v1
move s2, t0
lw t0, 0(s4)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s4, 1
move t0, v1
add v1, t0, s0
move t0, v1
lw t0, 0(t0)
emult v1, s2, t0
move t0, v1
move s2, t0
lw t0, 0(s5)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s5, 1
move t0, v1
add v1, t0, s0
move t0, v1
sw s2, 0(t0)
lw t0, 0(s4)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s4, 1
move t0, v1
add v1, t0, s0
move t0, v1
lw t0, 0(t0)
emult v1, s2, t0
move t0, v1
move s2, t0
lw t0, 0(s4)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s4, 1
move t0, v1
add v1, t0, s0
move t0, v1
lw t0, 0(t0)
emult v1, s2, t0
move t0, v1
move s2, t0
lw t0, 0(s6)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s6, 1
move t0, v1
add v1, t0, s0
move t0, v1
sw s2, 0(t0)
econst t0, 48
econst t1, 240
eadd v1, t0, t1
move t0, v1
move s2, t0
lw t0, 0(s4)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s4, 1
move t0, v1
add v1, t0, s0
move t0, v1
lw t0, 0(t0)
move t6, t0
econst t0, 120
emult v1, t6, t0
move t0, v1
move t6, t0
lw t0, 0(s5)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s5, 1
move t0, v1
add v1, t0, s0
move t0, v1
lw t0, 0(t0)
move s3, t0
econst t0, 10
emult v1, s3, t0
move t0, v1
move s3, t0
eadd v1, s2, t6
move s2, v1
esub v1, s2, s3
move s2, v1
lw t0, 0(s6)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s6, 1
move t0, v1
add v1, t0, s0
move t0, v1
lw t0, 0(t0)
eadd v1, s2, t0
move t0, v1
move s2, t0
lw t0, 0(s4)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s4, 1
move t0, v1
add v1, t0, s0
move t0, v1
sw s2, 0(t0)
add v1, s0, 1
move s0, v1
j __L13_MAIN__
__L14_MAIN__:
move t0, 0
move s0, t0
__L15_MAIN__:
cmpl v1, s0, s1
move t0, v1
beq t0, zero, __L16_MAIN__
lw t0, 0(s4)
cmpl v1, s0, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s0, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s4, 1
move t0, v1
add v1, t0, s0
move t0, v1
lw t0, 0(t0)
print t0
add v1, s0, 1
move s0, v1
j __L15_MAIN__
__L16_MAIN__:
lw t0, 0(s4)
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
add v1, s4, 1
move t0, v1
add v1, t0, t1
move t0, v1
lw t0, 0(t0)
answer t0

__Runtime_Error__:
		move t0, 0xffffffffffffffff
		answer t0

