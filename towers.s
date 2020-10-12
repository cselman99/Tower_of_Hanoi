.arch armv6
	.fpu vfp
	.text

@ print function is complete, no modifications needed
    .global	print
print:
	stmfd	sp!, {r3, lr}
	mov	r3, r0
	mov	r2, r1
	ldr	r0, startstring
	mov	r1, r3
	bl	printf
	ldmfd	sp!, {r3, pc}

startstring:
	.word	string0
@ ------------------------------------------------
    .global	towers    
towers:
	/* Save callee-saved registers to stack */
	push {ip, lr}

	/* Save a copy of all 3 incoming parameters */
	push {r0, r1, r2} /* 3 parameters */
	push {r4}
	
	@ r0 = numDiscs
	@ r1 = start
	@ r2 = goal
	@ r4 = peg
	@ r5 = steps

if:
	/* Compare numDisks with 2 or (numDisks - 2)*/
	/* Check if less than, else branch to else */
	cmp r0, #2
	bgt else
	/* set print function's start to incoming start */
	mov r0, r1
	/* set print function's end to goal */
	mov r1, r2
	/* call print function */
	bl print
	/* Set return register to 1 */
	mov r0, #1
	/* branch to endif */
	add r5, r5, r0
	bl endif
else:
	/* Use a callee-saved varable for temp and set it to 6 */
	mov r4, #6
	/* Subract start from temp and store to itself */
	sub r4, r4, r1
	/* Subtract goal from temp and store to itself (temp = 6 - start - goal)*/
	sub r4, r4, r2
	/* subtract 1 from original numDisks and store it to numDisks parameter */
	sub r0, r0, #1
	/* Set end parameter as temp */
	mov r2, r4
	/* Call towers function */
	bl towers
	
	/* Save result to callee-saved register for total steps */
	/* Set numDiscs parameter to 1 */
	mov r6, r0
	mov r0, #1
	/* Set start parameter to original start */
	ldr r1, [r1, #12]
	/* Set goal parameter to original goal */
	ldr r2, [r2, #8]
	/* Call towers function */
	bl towers
	/* Add result to total steps so far */
	
	/* Set numDisks parameter to original numDisks - 1 */
	sub r0, r6, #1
	/* set start parameter to temp */
	mov r1, r4
	/* set goal parameter to original goal */
	ldr r2, [r2, #8]
	/* Call towers function */
	bl towers
	/* Add result to total steps so far and save it to return register */

	mov r0, r5
	bx lr

endif:
	/* Restore Registers */
	pop {r4}
	pop {r0, r1, r2}
	pop {ip, pc}

	bx lr

@ Function main is complete, no modifications needed
    .global	main
main:
	str	lr, [sp, #-4]!
	sub	sp, sp, #20
	ldr	r0, printdata
	bl	printf
	ldr	r0, printdata+4
	add	r1, sp, #12
	bl	scanf
	ldr	r0, [sp, #12] /* parameter: numDiscs */
	mov	r1, #1 /* parameter: start */
	mov	r2, #3 /* parameter: goal */
	mov r5, #0 /* added step */
	bl	towers
	str	r0, [sp]
	ldr	r0, printdata+8
	ldr	r1, [sp, #12]
	mov	r2, #1
	mov	r3, #3
	bl	printf
	mov	r0, #0
	add	sp, sp, #20
	ldr	pc, [sp], #4
end:

printdata:
	.word	string1
	.word	string2
	.word	string3

string0:
	.asciz	"Move from peg %d to peg %d\n"
string1:
	.asciz	"Enter number of discs to be moved: "
string2:
	.asciz	"%d"
	.space	1
string3:
	.ascii	"\n%d discs moved from peg %d to peg %d in %d steps."
	.ascii	"\012\000"
