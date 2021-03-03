move t0, 0
move t1, 10
cmpl v1, t1, 0
move t2, v1
move t3, 1
sub v1, t3, t2
move t2, v1
beq t2, zero, __Runtime_Error__
add v1, t1, 1
move t2, v1
move v0, hp
add hp, hp, t2
move t2, v0
sw t1, 0(t2)
move t0, t2
lw t1, 0(t0)
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
add v1, t0, 1
move t1, v1
add v1, t1, t2
move t1, v1
secread t2
sw t2, 0(t1)
lw t1, 0(t0)
move t2, 9
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t3, 1
sub v1, t3, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, t0, 1
move t1, v1
add v1, t1, t2
move t1, v1
lw t2, 0(t0)
econst t3, 0
cmpl v1, t3, t2
move t2, v1
beq t2, zero, __Runtime_Error__
cmpl v1, t3, 0
move t2, v1
move t4, 1
sub v1, t4, t2
move t2, v1
beq t2, zero, __Runtime_Error__
add v1, t0, 1
move t2, v1
add v1, t2, t3
move t2, v1
lw t2, 0(t2)
econst t3, 2
emult v1, t2, t3
move t2, v1
sw t2, 0(t1)
lw t1, 0(t0)
print t1
lw t1, 0(t0)
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
add v1, t0, 1
move t1, v1
add v1, t1, t2
move t1, v1
lw t1, 0(t1)
print t1
lw t1, 0(t0)
move t2, 9
cmpl v1, t2, t1
move t1, v1
beq t1, zero, __Runtime_Error__
cmpl v1, t2, 0
move t1, v1
move t3, 1
sub v1, t3, t1
move t1, v1
beq t1, zero, __Runtime_Error__
add v1, t0, 1
move t0, v1
add v1, t0, t2
move t0, v1
lw t0, 0(t0)
print t0
move t0, 0
answer t0

__Runtime_Error__:
		move t0, 0xffffffffffffffff
		answer t0

