econst t0, 0
econst t1, 0
econst t2, 0
move t3, 20
secread t4
move t0, t4
secread t4
move t1, t4
move t4, 2
__L1_MAIN__:
cmpleq v1, t4, t3
move t5, v1
beq t5, zero, __L2_MAIN__
econst t5, t4
emult v1, t1, t5
move t1, v1
ecmpeq v1, t5, t0
move t5, v1
econst t6, 0
emux t5, t5, t1, t6
eor v1, t2, t5
move t2, v1
add v1, t4, 1
move t4, v1
j __L1_MAIN__
__L2_MAIN__:
answer t2
