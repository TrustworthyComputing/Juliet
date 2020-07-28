# Juliet Assembly Language

| Instruction         | Description |
|---------------------|-------------|
| eadd ri, rj, rk     | ri = rj + rk |
| emul ri, rj, rk     | ri = rj * rk |
| emux ri, rj, rk, rl | ri = rj * rl + rk * !rl |
| econst ri, A        | ri = Encrypt(A) |
| enot ri, rj         | ri = !rj |
| eand ri, rj, rk     | ri = rj & rk |
| enand ri, rj, rk    | ri = !(rj & rk) |
| eor ri, rj, rk      | ri = rj | rk |
| enor ri, rj, rk     | ri = !(rj | rk) |
| exor ri, rj, rk     | ri = rj ^ rk |
| exnor ri, rj, rk    | ri = !(rj ^ rk) |
| not ri, A           | ri = !A |
| and ri, rj, A       | ri = rj & A |
| nand ri, rj, A      | ri = !(rj & A) |
| or ri, rj, A        | ri = rj | A |
| nor ri, rj, A       | ri = !(rj | A) |
| xor ri, rj, A       | ri = rj ^ A |
| xnor ri, rj, A      | ri = !(rj ^ A) |
| add ri, rj, A       | ri = rj + A |
| sub ri, rj, A       | ri = rj - A |
| umull ri, rj, A     | ri = rj * A, keep least significant bits (operands unsigned) |
| umulh ri, rj, A     | ri = rj * A, keep most significant bits (operands unsigned) |
| smulh ri, rj, A     | ri = rj * A, keep most significant bits (operands signed) |
| udiv ri, rj, A      | ri = rj / A (operands unsigned) |
| umod ri, rj, A      | ri = rj % A (operands unsigned) |
| shl ri, rj, A       | ri = rj << A |
| shr ri, rj, A       | ri = rj >> A |
| jmp A               | pc = A |
| cjmp A              | pc = A if flag == 1 |
| mov ri, A           | ri = A |
| cmov ri, A          | ri = A if flag == 1 |
| store A, ri         | mem[A] = ri |
| load ri, A          | ri = mem[A] |
| read ri, A          | Consume next word from public tape if A == 0, else consume next value from private tape |
| cmpe ri, A          | flag = (ri == A) |
| cmpa ri, A          | flag = (ri > A) (operands unsigned) |
| cmpg ri, A          | flag = (ri > A) (operands signed) |
| cmpae ri, A         | flag = (ri >= A) (operands unsigned) |
| cmpge ri, A         | flag = (ri >= A) (operands signed) |
| prnt ri             | print ri |
| halt ri             | return ri |
| chalt ri            | return ri if flag == 1 | 
