move t0, 20
move t1, 1
econst t2, t0
econst t1, t1
eadd v1, t2, t1
move t1, v1
cmpl v1, t1, 0
move t2, v1
move t3, 1
sub v1, t3, t2
move t2, v1
add v1, t1, 1
move t2, v1
move v0, hp
add hp, hp, t2
move t2, v0
sw t1, 0(t2)
move t1, 1
econst t3, t0
econst t1, t1
eadd v1, t3, t1
move t1, v1
cmpl v1, t1, 0
move t3, v1
move t4, 1
sub v1, t4, t3
move t3, v1
add v1, t1, 1
move t3, v1
move v0, hp
add hp, hp, t3
move t3, v0
sw t1, 0(t3)
move t1, 1
econst t4, t0
econst t1, t1
eadd v1, t4, t1
move t1, v1
cmpl v1, t1, 0
move t4, v1
move t5, 1
sub v1, t5, t4
move t4, v1
add v1, t1, 1
move t4, v1
move v0, hp
add hp, hp, t4
move t4, v0
sw t1, 0(t4)
move t1, 0
__L1_MAIN__:
move t5, 1
add v1, t0, t5
move t5, v1
cmpl v1, t1, t5
move t5, v1
beq t5, zero, __L2_MAIN__
lw t5, 0(t3)
cmpl v1, t1, t5
move t5, v1
cmpl v1, t1, 0
move t5, v1
move t6, 1
sub v1, t6, t5
move t5, v1
add v1, t3, 1
move t5, v1
add v1, t5, t1
move t5, v1
secread t6
sw t6, 0(t5)
lw t5, 0(t4)
cmpl v1, t1, t5
move t5, v1
cmpl v1, t1, 0
move t5, v1
move t7, 1
sub v1, t7, t5
move t5, v1
add v1, t4, 1
move t5, v1
add v1, t5, t1
move t5, v1
secread t7
sw t7, 0(t5)
lw t5, 0(t2)
cmpl v1, t1, t5
move t5, v1
cmpl v1, t1, 0
move t5, v1
move t8, 1
sub v1, t8, t5
move t5, v1
add v1, t2, 1
move t5, v1
add v1, t5, t1
move t5, v1
lw t8, 0(t3)
cmpl v1, t1, t8
move t8, v1
cmpl v1, t1, 0
move t8, v1
move t9, 1
sub v1, t9, t8
move t8, v1
add v1, t3, 1
move t8, v1
add v1, t8, t1
move t8, v1
lw t8, 0(t8)
sw t8, 0(t5)
add v1, t1, 1
move t1, v1
j __L1_MAIN__
__L2_MAIN__:
move t1, 2
__L3_MAIN__:
mult v1, t1, t1
move t3, v1
move t5, 1
add v1, t0, t5
move t5, v1
cmpl v1, t3, t5
move t3, v1
beq t3, zero, __L4_MAIN__
move t3, 2
mult v1, t3, t1
move t3, v1
__L5_MAIN__:
move t5, 1
add v1, t0, t5
move t5, v1
cmpl v1, t3, t5
move t5, v1
beq t5, zero, __L6_MAIN__
lw t5, 0(t2)
cmpl v1, t3, t5
move t5, v1
cmpl v1, t3, 0
move t5, v1
move t6, 1
sub v1, t6, t5
move t5, v1
add v1, t2, 1
move t5, v1
add v1, t5, t3
move t5, v1
lw t6, 0(t4)
cmpl v1, t3, t6
move t6, v1
cmpl v1, t3, 0
move t6, v1
move t7, 1
sub v1, t7, t6
move t6, v1
add v1, t4, 1
move t6, v1
add v1, t6, t3
move t6, v1
lw t6, 0(t6)
sw t6, 0(t5)
add v1, t3, t1
move t3, v1
j __L5_MAIN__
__L6_MAIN__:
add v1, t1, 1
move t1, v1
j __L3_MAIN__
__L4_MAIN__:
move t1, 2
__L7_MAIN__:
move t3, 1
add v1, t0, t3
move t3, v1
cmpl v1, t1, t3
move t3, v1
beq t3, zero, __L8_MAIN__
lw t3, 0(t2)
cmpl v1, t1, t3
move t3, v1
cmpl v1, t1, 0
move t3, v1
move t4, 1
sub v1, t4, t3
move t3, v1
add v1, t2, 1
move t3, v1
add v1, t3, t1
move t3, v1
lw t3, 0(t3)
emult v1, t1, t3
move t3, v1
print t3
add v1, t1, 1
move t1, v1
j __L7_MAIN__
__L8_MAIN__:
move t0, 0
answer t0
