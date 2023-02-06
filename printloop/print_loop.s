// An Assembly programm for the AArch64 (Mac OS) that prints 
// all the capital letters of the English alphabet in a loop using "write" system call 
//
// X29 frame pointer register
// X30 link register (return address)

.global	_start			// Provide program starting address to linker
.align	2				// It's 2^2, which means that an address of an instruction is
						// multiple of 4 (ARM instruction has 4 byte size)
_start: 
	stp		x29, x30, [sp, #-16]! 	// According to the "Procedure Call Standard for the Arm® 64-bit Architecture (AArch64)":
									// ...Additionally, at any point at which memory is accessed via SP, the hardware requires that
									// • SP mod 16 = 0. The stack must be quad-word aligned...
	mov		x29, sp					// According to the "Procedure Call Standard for the Arm® 64-bit Architecture (AArch64)":
									// ...Conforming code shall construct a linked list of stack-frames. 
									// Each frame shall link to the frame of its caller by means of a frame 
									// record of two 64-bit values on the stack (independent of the data model)...	
	sub		sp, sp, #16				// Make room for the local variable (address of the string)

	mov		x4, #65 	// begin: ascii "A"
	mov		x5, #91 	// end: ascii "Z"
loop:	
	str		x4, [sp]	// Put the string (that consists of one char) into the stack so that we can get it's address
	mov		x0, sp		// Pass the address of the string as a first argument
	mov		x1, #1		// Pass the length of the string (one char = 1)
	bl		print		// Branch to the "print" function and save the return address into X30

	add		x4, x4, #1	// Build the next string (that actually is only one char)
	cmp		x4, x5		// Check if the current string equals to the "end" string
	bne		loop		// Go to the beginning of the loop if the strings are not equal (if Z flag is not 1)

// Print "\n" in the end
	mov		x4, #10		// ascii "\n"
	str		x4, [sp]
	mov		x0, sp		
	mov		x1, #1		
	bl		print

	add		sp, sp, #16				
	ldp		x29, x30, [sp], #16	
	mov		x0, #0					// return value (exit status)
	ret	

// Arguments:
// x0 - address of the string to print
// x1 - length of the string
print:
	stp		x29, x30, [sp, #-16]!
	mov		x29, sp
	stp		x0, x1, [sp, #-16]!		// Preserve registers that are going to be used 
	stp		x2, x16, [sp, #-16]!	// in the print function

// Arguments for a system call
// x0 - writable stream number (here StdOut)
// x1 - address of the string
// x2 - length of the string
// x16 - Unix "write" syscall number
	mov		x0, #1			// 1 = StdOut
	ldr		x1, [sp, #16] 	// Get the address of the string passed as argument (x0)
	ldr		x2, [sp, #24]	// Get the length of the string passed as argument (x1)
	mov		x16, #4			// Unix "write" system call
	svc		#0x80			// Call kernel to output the string

	ldp		x2, x16, [sp], #16		// Restore registers back
	ldp		x0, x1, [sp], #16	
	ldp		x29, x30, [sp], #16	
	ret
