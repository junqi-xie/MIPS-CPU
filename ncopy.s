		lui $at, 0
		ori $sp, $at, 0x7c	# stack pointer
main:	lui $at, 0
		ori $gp, $at, 0xa0	# I/O port addresses
		lw $a0, 0($gp)
		sll $a0, $a0, 2		# src = input1 * 4
		lw $a2, 4($gp)		# len = input2
		sll $t0, $a2, 2
		add $a1, $a0, $t0	# dst = input1 + len * 4
		sw $a0, 16($gp)		# output1 = src
		sw $a1, 20($gp)		# output2 = dst
		jal ncopy			# ncopy(src, dst, len)
		sw $v0, 24($gp)		# output3 = count
finish:	j main
ncopy:	addi $sp, $sp, -4	# allocate space for $s0
		sw $s0, 4($sp)		# save $s0
		xor $v0, $v0, $v0	# count = 0;
		and $t0, $a2, $a2	# len <= 0?
		beq $t0, $0, Done	# if so, goto Done:
Loop:	lw $s0, 0($a0)		# read val from src...
		sw $s0, 0($a1)		# ...and store it to dst
		slti $t0, $s0, 1	# val <= 0?
		bne $t0, $0, Npos	# if so, goto Npos:
		addi $v0, $v0, 1	# count++
Npos:	addi $a2, $a2, -1	# len--
		addi $a0, $a0, 4	# src++
		addi $a1, $a1, 4	# dst++
		and $t0, $a2, $a2	# len > 0?
		bne $t0, $0, Loop	# if so, goto Loop:
Done:	lw $s0, 4($sp)		# restore $s0
		addi $sp, $sp, 4	# free space for $s0
		jr $ra
Handle:	j Handle			# Overflow handler
