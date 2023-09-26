move s4, 0
move t1, 0
move t2, 0
econst t3, 0
econst t4, 0
econst t5, 0
move s3, 0
move t7, 0
move s2, 0
move s0, 0
move t9, 0
move s1, 0
pubread t8
move s3, t8
pubread t8
move t7, t8
pubread t8
move s2, t8
mult v1, s3, t7
move t8, v1
cmpl v1, t8, 0
move t6, v1
move t0, 1
sub v1, t0, t6
move t6, v1
beq t6, zero, __Runtime_Error__
add v1, t8, 1
move t0, v1
move v0, hp
add hp, hp, t0
move t0, v0
sw t8, 0(t0)
move s0, t0
mult v1, t7, s2
move t0, v1
cmpl v1, t0, 0
move t6, v1
move t8, 1
sub v1, t8, t6
move t6, v1
beq t6, zero, __Runtime_Error__
add v1, t0, 1
move t6, v1
move v0, hp
add hp, hp, t6
move t6, v0
sw t0, 0(t6)
move t9, t6
mult v1, s3, s2
move t0, v1
cmpl v1, t0, 0
move t6, v1
move t8, 1
sub v1, t8, t6
move t6, v1
beq t6, zero, __Runtime_Error__
add v1, t0, 1
move t6, v1
move v0, hp
add hp, hp, t6
move t6, v0
sw t0, 0(t6)
move s1, t6
move t0, 0
move s4, t0
__L1_MAIN__:
mult v1, s3, t7
move t0, v1
cmpl v1, s4, t0
move t0, v1
beq t0, zero, __L2_MAIN__
lw t0, 0(s0)
cmpl v1, s4, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s4, 0
move t0, v1
move t6, 1
sub v1, t6, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s0, 1
move t0, v1
add v1, t0, s4
move t0, v1
secread t6
sw t6, 0(t0)
add v1, s4, 1
move s4, v1
j __L1_MAIN__
__L2_MAIN__:
move t0, 0
move s4, t0
__L3_MAIN__:
mult v1, t7, s2
move t0, v1
cmpl v1, s4, t0
move t0, v1
beq t0, zero, __L4_MAIN__
lw t0, 0(t9)
cmpl v1, s4, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s4, 0
move t0, v1
move t6, 1
sub v1, t6, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, t9, 1
move t0, v1
add v1, t0, s4
move t0, v1
secread t6
sw t6, 0(t0)
add v1, s4, 1
move s4, v1
j __L3_MAIN__
__L4_MAIN__:
move t0, 0
move s4, t0
__L5_MAIN__:
mult v1, s3, s2
move t0, v1
cmpl v1, s4, t0
move t0, v1
beq t0, zero, __L6_MAIN__
lw t0, 0(s1)
cmpl v1, s4, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s4, 0
move t0, v1
move t6, 1
sub v1, t6, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s1, 1
move t0, v1
add v1, t0, s4
move t0, v1
econst t6, 0
sw t6, 0(t0)
add v1, s4, 1
move s4, v1
j __L5_MAIN__
__L6_MAIN__:
move t0, 0
move s4, t0
__L7_MAIN__:
cmpl v1, s4, s3
move t0, v1
beq t0, zero, __L8_MAIN__
move t0, 0
move t1, t0
__L9_MAIN__:
cmpl v1, t1, s2
move t0, v1
beq t0, zero, __L10_MAIN__
move t0, 0
move t2, t0
__L11_MAIN__:
cmpl v1, t2, t7
move t0, v1
beq t0, zero, __L12_MAIN__
lw t0, 0(s1)
mult v1, s4, s2
move t6, v1
add v1, t6, t1
move t6, v1
cmpl v1, t6, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, t6, 0
move t0, v1
move t8, 1
sub v1, t8, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s1, 1
move t0, v1
add v1, t0, t6
move t0, v1
lw t0, 0(t0)
move t3, t0
lw t0, 0(s0)
mult v1, s4, t7
move t6, v1
add v1, t6, t2
move t6, v1
cmpl v1, t6, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, t6, 0
move t0, v1
move t8, 1
sub v1, t8, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s0, 1
move t0, v1
add v1, t0, t6
move t0, v1
lw t0, 0(t0)
move t4, t0
lw t0, 0(t9)
mult v1, t2, s2
move t6, v1
add v1, t6, t1
move t6, v1
cmpl v1, t6, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, t6, 0
move t0, v1
move t8, 1
sub v1, t8, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, t9, 1
move t0, v1
add v1, t0, t6
move t0, v1
lw t0, 0(t0)
move t5, t0
lw t0, 0(s1)
mult v1, s4, s2
move t6, v1
add v1, t6, t1
move t6, v1
cmpl v1, t6, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, t6, 0
move t0, v1
move t8, 1
sub v1, t8, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s1, 1
move t0, v1
add v1, t0, t6
move t0, v1
emult v1, t4, t5
move t4, v1
eadd v1, t3, t4
move t3, v1
sw t3, 0(t0)
move t0, 1
add v1, t2, t0
move t0, v1
move t2, t0
j __L11_MAIN__
__L12_MAIN__:
move t0, 1
add v1, t1, t0
move t0, v1
move t1, t0
j __L9_MAIN__
__L10_MAIN__:
move t0, 1
add v1, s4, t0
move t0, v1
move s4, t0
j __L7_MAIN__
__L8_MAIN__:
move t0, 0
move s4, t0
__L13_MAIN__:
mult v1, s3, s2
move t0, v1
cmpl v1, s4, t0
move t0, v1
beq t0, zero, __L14_MAIN__
lw t0, 0(s1)
cmpl v1, s4, t0
move t0, v1
beq t0, zero, __Runtime_Error__
cmpl v1, s4, 0
move t0, v1
move t1, 1
sub v1, t1, t0
move t0, v1
beq t0, zero, __Runtime_Error__
add v1, s1, 1
move t0, v1
add v1, t0, s4
move t0, v1
lw t0, 0(t0)
print t0
move t0, 1
add v1, s4, t0
move t0, v1
move s4, t0
j __L13_MAIN__
__L14_MAIN__:
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
answer t0

__Runtime_Error__:
		move t0, 0xffffffffffffffff
		answer t0

