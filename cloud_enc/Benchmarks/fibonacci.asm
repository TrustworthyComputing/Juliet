econst t0, 0
econst t1, 0
econst t2, 0
econst t3, 0
econst t4, 0
move t5, 20
secread t6
move t3, t6
secread t6
move t0, t6
secread t6
move t1, t6
eadd v1, t0, t1
move t6, v1
move t2, t6
move t6, 1
__L1_MAIN__:
cmpleq v1, t6, t5
move t7, v1
beq t7, zero, __L2_MAIN__
econst t7, t6
ecmpeq v1, t7, t3
move t7, v1
emult v1, t7, t2
move t7, v1
eadd v1, t4, t7
move t4, v1
eadd v1, t0, t1
move t7, v1
move t2, t7
move t0, t1
move t1, t2
add v1, t6, 1
move t6, v1
j __L1_MAIN__
__L2_MAIN__:
answer t4
