.data
.align 2
S0: .half 0x2, 0xF, 0xC, 0x1, 0x5, 0x6, 0xA, 0xD, 0xE, 0x8, 0x3, 0x4, 0x0, 0xB, 0x9, 0x7
S1: .half 0xF, 0x4, 0x5, 0x8, 0x9, 0x7, 0x2, 0x1, 0xA, 0x3, 0x0, 0xE, 0x6, 0xC, 0xD, 0xB
S2: .half 0x4, 0xA, 0x1, 0x6, 0x8, 0xF, 0x7, 0xC, 0x3, 0x0, 0xE, 0xD, 0x5, 0x9, 0xB, 0x2
S3: .half 0x7, 0xC, 0xE, 0x9, 0x2, 0x1, 0x5, 0xF, 0xB, 0x6, 0xD, 0x0, 0x4, 0x8, 0xA, 0x3

pbox_shift: .byte 7, 6, 1, 5, 3, 4, 0, 2    #the shift values of permutation function

f_test_input:	.word 0xBBAA, 0x1111  #test inputs for F(x) function
f_test_output: 	.word 0xA9E8, 0x1516  #test outputs for F(x) function

f_error: .asciiz "Error in F(x) function test: output does not match expected output\n"
w_error: .asciiz "Error in W(x) function test: output does not match expected output\n"
enter: .asciiz "\n"

IV:    .word 0x3412, 0x7856, 0xBC9A, 0xF0DE  # Initial vector IV0, IV1, IV2, IV3
KEY:   .word 0x2301, 0x6745, 0xAB89, 0xEFCD, 0xDCFE, 0x98BA, 0x5476, 0x1032 # Key K0, K1, ..., K7
R:     .space 32   # State vector R0, R1, ..., R7

.text
.globl main
main:
    #testing the functions (linear and permutation)
    jal test_f_function
    jal test_w_function
    jal init
    
    li $v0, 10       #syscall for exit
    syscall

#LINEAR FUNCTION
linear_function:
    addi $sp, $sp, -24
    sw $t2, 0($sp)
    sw $t3, 4($sp)
    sw $t4, 8($sp)
    sw $t5, 12($sp)
    sw $t6, 16($sp)
    sw $t7, 20($sp)

    move $t0, $a0

    sll $t2, $t0, 6    #X << 6
    srl $t3, $t0, 10   #X >> (16 - 6)
    or $t2, $t2, $t3   
    andi $t2, $t2, 0xFFFF

    srl $t4, $t0, 6    #X >> 6
    sll $t5, $t0, 10   #X << (16 - 6)
    or $t4, $t4, $t5   
    andi $t4, $t4, 0xFFFF

    xor $t6, $t0, $t2  #X ^ (X << 6)
    xor $v0, $t6, $t4  #(X ^ (X << 6)) ^ (X >> 6)
    andi $v0, $v0, 0xFFFF
   
    lw $t2, 0($sp)
    lw $t3, 4($sp)
    lw $t4, 8($sp)
    lw $t5, 12($sp)
    lw $t6, 16($sp)
    lw $t7, 20($sp)
    addi $sp, $sp, 24
     
    jr $ra


#PERMUTATION FUNCTION
permute_function:
    #X is in $a0
    li $v0, 0            
    li $t1, 8            #counter(loop) = 8
    la $t0, pbox_shift   
    li $t3, 0            #counter(bit position)

permute_loop:
    srlv $t4, $a0, $t3   #shifting the input right by the current bit position
    andi $t4, $t4, 1     #getting the least significant bit (because the current bit is now there)
    lb $t5, 0($t0)       #t5 = new shifting value from pbox_shift
    sllv $t4, $t4, $t5   #shifting (t5 times) the extracted bit (t4) to its new position
    or $v0, $v0, $t4     

    addi $t3, $t3, 1 	  #counter(bit position)++
    addi $t0, $t0, 1 	  #pbox_shift address++
    bne $t3, $t1, permute_loop   #if t3(bit position) != t1(loop = 8); repeat loop
    jr $ra          	  #else...

small_table:
    addi $sp, $sp, -32
    sw $t2, 0($sp)
    sw $t3, 4($sp)
    sw $t4, 8($sp)
    sw $t5, 12($sp)
    sw $t6, 16($sp)
    sw $t7, 20($sp)
    sw $s0, 24($sp)
    sw $s1, 28($sp)
    
    #loading address of S-boxes
    la $t2, S0
    la $t3, S1
    la $t4, S2
    la $t5, S3

    move $v0, $a0 #loading value to v0 from a0

    andi $t7, $v0, 0xF000   #x0 = (X >> 12) & 0xF
    srl $t7, $t7, 12
    andi $s0, $v0, 0x0F00   #x1 = (X >> 8) & 0xF
    srl $s0, $s0, 8
    andi $s1, $v0, 0x00F0   #x2 = (X >> 4) & 0xF
    srl $s1, $s1, 4
    andi $t6, $v0, 0x000F   #x3 = X & 0xF

    #finding the corresponding addresses for X (= x0 || x1 || x2 || x3) value
    sll $t7, $t7, 1
    add $t2, $t2, $t7
    sll $s0, $s0, 1
    add $t3, $t3, $s0
    sll $s1, $s1, 1
    add $t4, $t4, $s1
    sll $t6, $t6, 1
    add $t5, $t5, $t6

    lh $t7, 0($t2)       #s0 = S0[x0]
    lh $s0, 0($t3)       #s1 = S1[x1]
    lh $s1, 0($t4)       #s2 = S2[x2]
    lh $t6, 0($t5)       #s3 = S3[x3]
    sll $t7, $t7, 12     #s0 << 12
    sll $s0, $s0, 8      #s1 << 8
    sll $s1, $s1, 4      #s2 << 4
    or $t7, $t7, $s0     #s0 | s1
    or $t7, $t7, $s1     #(s0 | s1) | s2
    or $t7, $t7, $t6     #(s0 | s1 | s2) | s3

    move $v0, $t7
    
    lw $t7, 20($sp)
    lw $t2, 0($sp)
    lw $t3, 4($sp)
    lw $t4, 8($sp)
    lw $t5, 12($sp)
    lw $t6, 16($sp)
    lw $s0, 24($sp)
    lw $s1, 28($sp)
    addi $sp, $sp, 32
    jr $ra

#F(x) FUNCTION
f_function:
    #argument (input): $a0
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    
    andi $t3, $a0, 0x000F   #x3 = t3
    srl  $t2, $a0, 4
    andi $t2, $t2, 0x000F   #x2 = t2
    srl  $t1, $a0, 8
    andi $t1, $t1, 0x000F   #x1 = t1
    srl  $t0, $a0, 12
    andi $t0, $t0, 0x000F   #x0 = t0
    
    addi $sp, $sp, -16
    sw $t3, 0($sp)
    sw $t2, 4($sp)
    sw $t1, 8($sp)
    sw $t0, 12($sp)
    
    sll  $t4, $t0, 4
    or   $t4, $t4, $t1      #t4 = x0 || x1
    move $a0, $t4
    jal  permute_function   #P(x0 || x1) -> $v0
    
    lw $t3, 0($sp)
    lw $t2, 4($sp)
    lw $t1, 8($sp)
    lw $t0, 12($sp)
    
    sll  $t5, $t2, 4
    or   $t5, $t5, $t3  #t5 = x2 || x3
    sll  $t5, $t5, 8
    or   $t5, $t5, $v0  #t5 = x2 || x3 || P(x0 || x1)

    move $a0, $t5
    jal  small_table 	#S(x2 || x3 || P(x0 || x1)) -> $v0
	
    lw $t3, 0($sp)
    lw $t2, 4($sp)
    lw $t1, 8($sp)
    lw $t0, 12($sp)
    addi $sp, $sp, 16
	
    move $a0, $v0
    jal  linear_function     #L(S(x2 || x3 || P(x0 || x1))) -> $v0
    
    lw $a0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

#TESTING F(x) FUNCTION
test_f_function:
    addi $sp, $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $ra, 12($sp)

    la $s0, f_test_input         #s0 = the address of f_test_input array
    la $s1, f_test_output        #s1 = the address of f_test_output array
    li $s2, 0x0002  #counter = 2

f_test_loop:
    lw $a0, 0($s0)   #a0 = the current X value from f_test_input array (s0)

    jal f_function   
    move $t4, $v0    #t4 = the result of F(X)
    lw $t5, 0($s1)   #t5 = the expected output corresponding to X
    bne $t4, $t5, f_function_error   #if outputs don't match...
    addi $s0, $s0, 4 #else, moving to next test values
    addi $s1, $s1, 4   

    subi $s2, $s2, 1 #counter--
    bne $s2, $zero, f_test_loop   #if counter != 0; repeat loop
    
    #all F(X) function tests passed
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

#ERROR - F FUNCTION TESTING
f_function_error:
    #printing error message and exit
    li $v0, 4        #syscall for printing string
    la $a0, f_error
    syscall

    li $v0, 10       #syscall for exit
    syscall

#W(x) FUNCTION
w_function:
    #arguments (inputs): $a0 (X), $a1 (A), $a2 (B)
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)

    xor $t0, $a0, $a1      #t0 = X ^ A
    move $a0, $t0
    jal f_function         #F(X ^ A) -> $v0

    xor $t1, $v0, $a2      #t1 = F(X ^ A) ^ B
    move $a0, $t1
    jal f_function         #F(F(X ^ A) ^ B) -> $v0

    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 16
    
    jr $ra

test_w_function:
    addi $sp, $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $ra, 12($sp)

    #arguments of function
    li $s0, 0xbbaa       #X
    li $s1, 0xcccc       #A
    li $s2, 0xdddd       #B

    #W(X, A, B)
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal w_function       #W(X, A, B) -> $v0

    #checking the result
    li $t5, 0xf0ad       #expected result
    bne $v0, $t5, w_function_error   #if outputs don't match...

    #all tests passed
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

#ERROR - W FUNCTION TESTING
w_function_error:
    #printing error message and exit
    li $v0, 4        #syscall for printing string
    la $a0, w_error
    syscall

    li $v0, 10       #syscall for exit
    syscall

#INITIALIZATION
init: 

#1ST LOOP OF INITIALIZATION
first_init: 
    la $t0, IV    #t0 = address of IV
    la $t1, R     #t1 = address of R
    li $t2, 0     #counter = 0 - 1st loop
    
    
first_init_loop:
    beq $t2, 8, second_init  	#if counter == 8, go to second part
    lw $t3, 0($t0)           	#loading from IV
    sw $t3, 0($t1)          	#storing to R
    addi $t0, $t0, 4		#moving to the next val of IV
    addi $t1, $t1, 4      	#moving to the next val of R
    addi $t2, $t2, 1       	#counter++

    li $t4, 4
    rem $t5, $t2, $t4      #t5 = t2 % 4
    beq $t5, 0, reset_iv   #if t2 % 4 == 0, reset IV address
    
    j first_init_loop

reset_iv:
    la $t0, IV  #reset IV address to the beginning
    j first_init_loop

#2ND LOOP OF INITIALIZATION
second_init:
    addi $sp, $sp, -20
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)

    la $t4, IV    #t4 = address of IV
    la $s2, R     #s2 = address of R
    la $t6, KEY	  #t6 = address of KEY
    li $t7, 0     #counter = 0 - 2nd loop
   
second_init_loop:
    #FIRST PART OF 2ND LOOP: W FUNCTION
    beq $t7, 4, print_init  #if counter == 4, exit the loop
    
    lw $t5, 0($s2)
    #t0
    add $a0, $t5, $t7		#a0 = R(i)0 + i
    andi $a0, $a0, 0xFFFF 	#a0 mod 2^16
    lw $a1, 4($t6)		#a1 = K1
    lw $a2, 12($t6)		#a2 = K3
    jal w_function		#W(a0,a1,a2) -> v0
    move $t0, $v0		#t0 = v0
    
    addi $sp, $sp, -16
    sw $t0, 0($sp)
    
    lw $t5, 4($s2)
    #t1
    add $a0, $t5, $t0		#a0 = R(i)1 + t0
    andi $a0, $a0, 0xFFFF 	#a0 mod 2^16
    lw $a1, 20($t6)		#a1 = K5
    lw $a2, 28($t6)		#a2 = K7
    jal w_function		#W(a0,a1,a2) -> v0
    move $t1, $v0		#t1 = v0
    
    sw $t1, 4($sp)
    
    lw $t5, 8($s2)
    #t2
    add $a0, $t5, $t1		#a0 = R(i)2 + t1
    andi $a0, $a0, 0xFFFF  	#a0 mod 2^16
    lw $a1, 0($t6)		#a1 = K0
    lw $a2, 8($t6)		#a2 = K2
    jal w_function		#W(a0,a1,a2) -> v0
    move $t2, $v0		#t2 = v0

    sw $t2, 8($sp)
    
    lw $t5, 12($s2)
    #t3
    add $a0, $t5, $t2		#a0 = R(i)3 + t2
    andi $a0, $a0, 0xFFFF 	#a0 mod 2^16
    lw $a1, 16($t6)		#a1 = K4
    lw $a2, 24($t6)		#a2 = K6
    jal w_function		#W(a0,a1,a2) -> v0
    move $t3, $v0		#t3 = v0
    
    sw $t3, 12($sp)
    
    
    #SECOND PART OF 2ND LOOP: CIRCULAR SHIFT
    la $s2, R     #loading address of R
    
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    lw $t3, 12($sp)
    addi $sp, $sp, 16
    
    lw $t5, 0($s2)		 
    add $s1, $t5, $t3		#s1 = R(i)0 + t3
    andi $s1, $s1, 0xFFFF	#s1 mod 2^16
    sll $s3, $s1, 7		#s1<<<7
    srl $s4, $s1, 9
    or $s1, $s4, $s3
    andi $s1, $s1, 0xFFFF
    sw $s1, 0($s2)		# R(i+1)0 = s1
    
    lw $t5, 4($s2)
    add $s1, $t5, $t0		#s1 = R(i)1 + t0
    andi $s1, $s1, 0xFFFF	#s1 mod 2^16
    srl $s3, $s1, 4		#s1>>>4
    sll $s4, $s1, 12
    or $s1, $s4, $s3
    andi $s1, $s1, 0xFFFF
    sw $s1, 4($s2)		# R(i+1)1 = s1
    
    lw $t5, 8($s2)
    add $s1, $t5, $t1		#s1 = R(i)2 + t1
    andi $s1, $s1, 0xFFFF	#s1 mod 2^16
    sll $s3, $s1, 2		#s1<<<2
    srl $s4, $s1, 14
    or $s1, $s4, $s3
    andi $s1, $s1, 0xFFFF
    sw $s1, 8($s2)		# R(i+1)2 = s1

    lw $t5, 12($s2)
    add $s1, $t5, $t2		#s1 = R(i)3 + t2
    andi $s1, $s1, 0xFFFF	#s1 mod 2^16
    srl $s3, $s1, 9		#s1>>>9
    sll $s4, $s1, 7
    or $s1, $s4, $s3
    andi $s1, $s1, 0xFFFF
    sw $s1, 12($s2)		# R(i+1)3 = s1

    
    #THIRD PART OF 2ND LOOP: XOR
    la $s2, R
    
    lw $t5, 16($s2)  	#t5 = R(i)4
    lw $s1, 12($s2)	#s1 = R(i+1)3
    xor $s1, $s1, $t5	#s1 = R(i)4 ^ R(i+1)3
    sw $s1, 16($s2)	#R(i+1)4 = s1
    
    lw $t5, 20($s2)	#t5 = R(i)5
    lw $s1, 4($s2)	#s1 = R(i+1)1
    xor $s1, $s1, $t5	#s1 = R(i)5 ^ R(i+1)1
    sw $s1, 20($s2)	#R(i+1)5 = s1
    
    lw $t5, 24($s2)	#t5 = R(i)6
    lw $s1, 8($s2)	#s1 = R(i+1)2
    xor $s1, $s1, $t5	#s1 = R(i)6 ^ R(i+1)2
    sw $s1, 24($s2)	#R(i+1)6 = s1
    
    lw $t5, 28($s2)	#t5 = R(i)7
    lw $s1, 0($s2)	#s1 = R(i+1)0
    xor $s1, $s1, $t5	#s1 = R(i)7 ^ R(i+1)0
    sw $s1, 28($s2)	#R(i+1)7 = s1
    
    addi $t7, $t7, 1	#counter++
    j second_init_loop
    
print_init:
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    addi $sp, $sp, 20
    li $t7, 0	#counter = 0
    la $t5, R	#t5 = address of R
    
print_init_loop:
    beq $t7, 8, exit	#if counter == 8, go to exit
    lw $t1, 0($t5)
    li $v0, 34		#syscall for hexadecimal printing
    move $a0, $t1
    syscall
    li $v0, 4       	#syscall for "\n" printing
    la $a0, enter
    syscall
    
    addi $t5, $t5, 4	#moving to the next val of R
    addi $t7, $t7, 1	#counter++
    j print_init_loop
     
exit:    	    
    li $v0, 10       #syscall for exit
    syscall
