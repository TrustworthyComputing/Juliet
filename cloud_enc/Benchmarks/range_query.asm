move t0, 0
move t1, 0
econst t2, 0
econst t3, 0
pubread t4
move t0, t4
pubread t4
move t1, t4
secread t4
move t2, t4
econst t0, t0
ecmpleq v1, t0, t2
move t0, v1
econst t1, t1
ecmpleq v1, t2, t1
move t1, v1
eand v1, t0, t1
move t0, v1
move t3, t0
answer t3
