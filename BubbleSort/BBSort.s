.data
arr:  .word 2, 3, 7, 4, 1
.text
main:
	la   s0, arr
	mv   t3, s0
	addi s1, s1, 4
	addi t0, zero, -1
	jal  ra, bbsort

	mv   t0, zero
	addi s1, s1, 1
	mv   s0, t3
	j    print

bbsort:
	addi sp, sp, -12
	sw   ra, 8(sp)
	sw   s1, 4(sp)
	sw   s0, 0(sp)
oloop:
	addi t0, t0, 1
	mv   t1, zero
	sub  t2, s1, t0
	blt  t0, s1, iloop
	addi sp, sp, 12
	jr   ra
iloop:
	mv   s0, t3
	bge  t1, t2, oloop
	slli t4, t1, 2
	add  s0, s0, t4
	lw   a2, 0(s0)
	lw   a3, 4(s0)
	addi t1, t1, 1
	blt  a2, a3, swap
	j    iloop
swap:
	sw   a2, 4(s0)
	sw   a3, 0(s0)
	j    iloop

print: 
	bge  t0, s1, end
	lw   a0, 0(s0)
	li   a7, 1
	ecall
	addi t0, t0, 1
	addi s0, s0, 4
	j    print
end:
