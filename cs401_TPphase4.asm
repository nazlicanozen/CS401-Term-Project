.data
.align 2
S0: .half 0x2, 0xF, 0xC, 0x1, 0x5, 0x6, 0xA, 0xD, 0xE, 0x8, 0x3, 0x4, 0x0, 0xB, 0x9, 0x7
S1: .half 0xF, 0x4, 0x5, 0x8, 0x9, 0x7, 0x2, 0x1, 0xA, 0x3, 0x0, 0xE, 0x6, 0xC, 0xD, 0xB
S2: .half 0x4, 0xA, 0x1, 0x6, 0x8, 0xF, 0x7, 0xC, 0x3, 0x0, 0xE, 0xD, 0x5, 0x9, 0xB, 0x2
S3: .half 0x7, 0xC, 0xE, 0x9, 0x2, 0x1, 0x5, 0xF, 0xB, 0x6, 0xD, 0x0, 0x4, 0x8, 0xA, 0x3

S0_i: .half 0xC, 0x3, 0x0, 0xA, 0xB, 0x4, 0x5, 0xF, 0x9, 0xE, 0x6, 0xD, 0x2, 0x7, 0x8, 0x1
S1_i: .half 0xA, 0x7, 0x6, 0x9, 0x1, 0x2, 0xC, 0x5, 0x3, 0x4, 0x8, 0xF, 0xD, 0xE, 0xB, 0x0
S2_i: .half 0x9, 0x2, 0xF, 0x8, 0x0, 0xC, 0x3, 0x6, 0x4, 0xD, 0x1, 0xE, 0x7, 0xB, 0xA, 0x5
S3_i: .half 0xB, 0x5, 0x4, 0xF, 0xC, 0x6, 0x9, 0x0, 0xD, 0x3, 0xE, 0x8, 0x1, 0xA, 0x2, 0x7

pbox_shift: .byte 7, 6, 1, 5, 3, 4, 0, 2    #the shift values of permutation function
inv_pbox_shift: .byte 6, 2, 7, 4, 5, 3, 1, 0   #the shift values of inverse permutation function
enter: .asciiz "\n"

print_main: .asciiz "Printing the P values (main):\n"
print_dec: .asciiz "Printing the P values (decryption):\n"
p1: .asciiz "Enter the 1st value in decimal: "
p2: .asciiz "Enter the 2nd value in decimal: "
p3: .asciiz "Enter the 3rd value in decimal: "
p4: .asciiz "Enter the 4th value in decimal: "
p5: .asciiz "Enter the 5th value in decimal: "
p6: .asciiz "Enter the 6th value in decimal: "
p7: .asciiz "Enter the 7th value in decimal: "
p8: .asciiz "Enter the last value in decimal: "

KEY_EN:	.word	0x2301, 0x6745, 0xAB89, 0xEFCD, 0xDCFE, 0x98BA, 0x5476, 0x1032 # Key K0, K1, ..., K7
IV_EN:	.word	0x3412, 0x7856, 0xBC9A, 0xF0DE # Initial vector IV0, IV1, IV2, IV3
R_EN:	.word	0x8957, 0x112b, 0xed92, 0x2637, 0xe39e, 0x18c7, 0x96dc, 0x42fa # State vector R0, R1, ..., R7
P_EN:	.space 32 #plaintext P
C_EN:	.space 32 #ciphertext C
T_EN:	.space 32 
temp_EN:   .space 12

KEY_DE:	.word	0x2301, 0x6745, 0xAB89, 0xEFCD, 0xDCFE, 0x98BA, 0x5476, 0x1032 # Key K0, K1, ..., K7
IV_DE:	.word	0x3412, 0x7856, 0xBC9A, 0xF0DE # Initial vector IV0, IV1, IV2, IV3
R_DE:	.word	0x8957, 0x112b, 0xed92, 0x2637, 0xe39e, 0x18c7, 0x96dc, 0x42fa # State vector R0, R1, ..., R7
P_DE:	.space 32 #plaintext P_decryption
C_DE:	.word 0x926a, 0xf9f8, 0x5bc5, 0xb575, 0x9707, 0x06a0, 0x3407, 0x33f2
T_DE:	.space 32
temp_DE:   .space 12

.text
.globl main
main:
    #getting p values and printing each
    la $s1, P_EN

    #1st
    li $v0, 4       
    la $a0, p1
    syscall
    li $v0, 5
    syscall
    sw $v0, 0($s1)

    #2nd
    li $v0, 4      
    la $a0, p2
    syscall
    li $v0, 5
    syscall
    sw $v0, 4($s1)

    #3rd
    li $v0, 4      
    la $a0, p3
    syscall
    li $v0, 5
    syscall
    sw $v0, 8($s1)

    #4th
    li $v0, 4      
    la $a0, p4
    syscall
    li $v0, 5
    syscall
    sw $v0, 12($s1)

    #5th
    li $v0, 4      
    la $a0, p5
    syscall
    li $v0, 5
    syscall
    sw $v0, 16($s1)

    #6th
    li $v0, 4      
    la $a0, p6
    syscall
    li $v0, 5
    syscall
    sw $v0, 20($s1)

    #7th
    li $v0, 4      
    la $a0, p7
    syscall
    li $v0, 5
    syscall
    sw $v0, 24($s1)

    #8th
    li $v0, 4      
    la $a0, p8
    syscall
    li $v0, 5
    syscall
    sw $v0, 28($s1)

    li $v0, 4      
    la $a0, print_main
    syscall
    la $s1, P_EN
    #1
    li $v0, 34
    lw $a0, 0($s1)
    syscall
    li $v0, 4       	
    la $a0, enter
    syscall
    #2
    li $v0, 34
    lw $a0, 4($s1)
    syscall
    li $v0, 4       	
    la $a0, enter
    syscall
    #3
    li $v0, 34
    lw $a0, 8($s1)
    syscall
    li $v0, 4       	
    la $a0, enter
    syscall
    #4
    li $v0, 34
    lw $a0, 12($s1)
    syscall
    li $v0, 4       	
    la $a0, enter
    syscall
    #5
    li $v0, 34
    lw $a0, 16($s1)
    syscall
    li $v0, 4       	
    la $a0, enter
    syscall
    #6
    li $v0, 34
    lw $a0, 20($s1)
    syscall
    li $v0, 4       	
    la $a0, enter
    syscall
    #7
    li $v0, 34
    lw $a0, 24($s1)
    syscall
    li $v0, 4       	
    la $a0, enter
    syscall
    #8
    li $v0, 34
    lw $a0, 28($s1)
    syscall
    li $v0, 4       	
    la $a0, enter
    syscall
    
    jal encryption_init
    jal decryption_init
     
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
    
    
#INVERSE LINEAR FUNCTION
inv_linear_function:
    addi $sp, $sp, -24
    sw $t2, 0($sp)
    sw $t3, 4($sp)
    sw $t4, 8($sp)
    sw $t5, 12($sp)
    sw $t6, 16($sp)
    sw $t7, 20($sp)

    #FIRST PART
    move $t0, $a0
    sll $t2, $t0, 10    #Y << 10
    srl $t3, $t0, 6   #Y >> (16 - 10)
    or $t2, $t2, $t3   
    andi $t2, $t2, 0xFFFF

    srl $t4, $t0, 10    #Y >> 10
    sll $t5, $t0, 6   #Y << (16 - 10)
    or $t4, $t4, $t5   
    andi $t4, $t4, 0xFFFF

    xor $t6, $t0, $t2  #Y ^ (Y << 10)
    xor $v0, $t6, $t4  #Z = (Y ^ (Y << 10)) ^ (Y >> 10)
    andi $v0, $v0, 0xFFFF
   

   #SECOND PART
    move $t0, $v0
    sll $t2, $t0, 4    #Z << 4
    srl $t3, $t0, 12   #Z >> (16 - 4)
    or $t2, $t2, $t3   
    andi $t2, $t2, 0xFFFF

    srl $t4, $t0, 4    #Z >> 4
    sll $t5, $t0, 12   #Z << (16 - 4)
    or $t4, $t4, $t5   
    andi $t4, $t4, 0xFFFF

    xor $t6, $t0, $t2  #Z ^ (Z << 4)
    xor $v0, $t6, $t4  #x = (Z ^ (Z << 4)) ^ (Z >> 4)
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
    
    
#INVERSE PERMUTATION FUNCTION
inv_permute_function:
    #X is in $a0
    li $v0, 0            
    li $t1, 8            #counter(loop) = 8
    la $t0, inv_pbox_shift   
    li $t3, 0            #counter(bit position)

inv_permute_loop:
    srlv $t4, $a0, $t3   #shifting the input right by the current bit position
    andi $t4, $t4, 1     #getting the least significant bit (because the current bit is now there)
    lb $t5, 0($t0)       #t5 = new shifting value from pbox_shift
    sllv $t4, $t4, $t5   #shifting (t5 times) the extracted bit (t4) to its new position
    or $v0, $v0, $t4     

    addi $t3, $t3, 1 	  #counter(bit position)++
    addi $t0, $t0, 1 	  #pbox_shift address++
    bne $t3, $t1, inv_permute_loop   #if t3(bit position) != t1(loop = 8); repeat loop

    jr $ra          	  #else...
    
    
#SMALL TABLE
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
  
    
#INVERSE SMALL TABLE  
inv_small_table:
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
    la $t2, S0_i
    la $t3, S1_i
    la $t4, S2_i
    la $t5, S3_i

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
    
    
#INVERSE F(x) FUNCTION
inv_f_function:
    #argument (input): $a0
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $s0, 8($sp)
    
    addi $sp, $sp, -16
    sw $t3, 0($sp)
    sw $t2, 4($sp)
    sw $t1, 8($sp)
    sw $t0, 12($sp)
    
    jal  inv_linear_function     #L(S(x2 || x3 || P(x0 || x1))) -> $v0    
    
    move $a0, $v0
    jal  inv_small_table 	#S(x2 || x3 || P(x0 || x1)) -> $v0
    
    andi $t3, $v0, 0x000F   #z3 = t3
    srl  $t2, $v0, 4
    andi $t2, $t2, 0x000F   #z2 = t2
    srl  $t1, $v0, 8
    andi $t1, $t1, 0x000F   #z1 = t1
    srl  $t0, $v0, 12
    andi $t0, $t0, 0x000F   #z0 = t0
    
    sll  $t4, $t0, 4
    or   $s1, $t4, $t1      #t4 = z2 || z3

    sll  $t4, $t2, 4
    or   $t4, $t4, $t3      #t4 = z2 || z3
    move $a0, $t4
    jal  inv_permute_function   #P(z2 || z3) -> $v0
    
    sll  $v0, $v0, 8
    or $v0, $v0, $s1
    

    sw $t3, 0($sp)
    sw $t2, 4($sp)
    sw $t1, 8($sp)
    sw $t0, 12($sp)
    addi $sp, $sp, 16

    lw $a0, 4($sp)
    lw $ra, 0($sp)
    lw $s0, 8($sp)
    addi $sp, $sp, 12
    
    jr $ra
    
 

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
    
    
#INVERSE W(x) FUNCTION
inv_w_function:
    #arguments (inputs): $a0 (X), $a1 (A), $a2 (B)
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)

    jal inv_f_function         #F(X ^ A) -> $v0
    
    li $t0, 0
    li $t1, 0
    li $t2, 0
    li $t3, 0
    li $t4, 0
    li $t5, 0
    li $t6, 0
    li $t7, 0
    
    lw $a2, 12($sp)
    xor $a0, $v0, $a2     #t1 = F(X) ^ B
    jal inv_f_function         #F(F(X ^ A) ^ B) -> $v0
    
    lw $a1, 8($sp)
    xor $v0, $v0, $a1
    
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 16

    jr $ra
    
    
    

#ENCRYPTION
encryption_init: 

   addi $sp, $sp, -36
   sw $s0, 0($sp)
   sw $s1, 4($sp)
   sw $s2, 8($sp)
   sw $s3, 12($sp)
   sw $s4, 16($sp)
   sw $s5, 20($sp)
   sw $s6, 24($sp)
   sw $s7, 28($sp)
   sw $ra, 32($sp)
   
   la $s0, KEY_EN	#s0: address of KEY
   la $s2, P_EN 	#s2: address of P
   la $s3, C_EN 	#s3: address of C
   la $s5, R_EN 	#s5: address of R
   li $s1, 0 	#loop counter i = 0
   la $s6, T_EN	#s6: address of T
   la $s7, temp_EN	#s7: address of t
    
encryption_init_loop: 

   #FIRST PART: tX registers
   #t0 = W((R0 + P) mod 2^16, L(K0 ^ R0),L(K1 ^ R1))
   lw $t4, 0($s5)	#load from R
   lw $t5, 0($s2)	#load from P 
   
   add $t7, $t4, $t5 	#t7 = R0 + P
   andi $t7, $t7, 0xFFFF #t7 = (R0 + P) mod 2^16
  
   lw $t6, 0($s0) 	#load from KEY 
   xor $t6, $t6, $t4 	#t6 = K0 ^ R0 
   move $a0, $t6
   jal linear_function  
   move $a1, $v0 	#a1 = L(K0 ^ R0) 
   move $a0, $t7 
      
   lw $t6, 4($s0) 	#t6 = K1
   lw $t4, 4($s5) 	#t4 = R1
   xor $t6, $t6, $t4 	#t6 = K1 ^ R1  
   move $a0, $t6
   jal linear_function
   move $a2, $v0 	#a2 = L(K1 ^ R1)
   move $a0, $t7
   
   jal w_function
   move $t0, $v0
   sw $t0, 0($s7)
   
   #t1 = W((R1 + t0) mod 2^16, L(K2 ^ R2), L(K3 ^ R3))
   lw $t4, 4($s5) 	#t4 = R1
   add $t7, $t4, $t0 	#t7 = R1 + t0
   andi $t7, $t7, 0xFFFF #t7 = (R1 + t0) mod 2^16
   
   lw $t6, 8($s0) 	#t6 = K2
   lw $t4, 8($s5)	#t4 = R2
   xor $t6, $t6, $t4 	#t6 = K2 ^ R2
   move $a0, $t6
   jal linear_function
   move $a1, $v0 	#a1 = L(K2 ^ R2)
   move $a0, $t7 
   
   lw $t6, 12($s0) 	#t6 = K3
   lw $t4, 12($s5)	#t4 = R3
   xor $t6, $t6, $t4 	#t6 = K3 ^ R3
   move $a0, $t6
   jal linear_function
   move $a2, $v0 	#a2 = L(K3 ^ R3))
   move $a0, $t7 
   
   jal w_function
   move $t1, $v0
   sw $t1, 4($s7)

   #t2 = W((R2 + t1) mod 2^16,L(K4 ? R4),L(K5 ? R5))
   lw $t4, 8($s5) 	#load from R
   add $t7, $t4, $t1 
   andi $t7, $t7, 0xFFFF #t7 = (R2 + t1) mod 2^16
   
   lw $t6, 16($s0) 	#t6 = K4
   lw $t4, 16($s5) 	#t4 = R4
   xor $t6, $t6, $t4 	#t6 = K4 ^ R4
   move $a0, $t6
   jal linear_function
   move $a1, $v0 	#L(K4 ^ R4)
   move $a0, $t7
   
   lw $t6, 20($s0) 	#t6 = K5
   lw $t4, 20($s5) 	#t4 = R5
   xor $t6, $t6, $t4 	#t6 = K5 ^ R5
   move $a0, $t6
   jal linear_function
   move $a2, $v0 	#a2 = L(K5 ^ R5)
   move $a0, $t7
  
   jal w_function
   move $t2, $v0
   sw $t2, 8($s7)
   
   #SECOND PART: CIPHERTEXT
   lw $t4, 12($s5) 	#t4 = R3
   add $t7, $t4, $t2 	#t7 = R3 + t2
   andi $t7, $t7, 0xFFFF #t7 = (R3 + t2) mod 2^16
   
   lw $t6, 24($s0) 	#t6 = K6
   lw $t4, 24($s5) 	#t4 = R6
   xor $t6, $t6, $t4 	#t6 = K6 ^ R6
   move $a0, $t6
   jal linear_function
   move $a1, $v0 	#a1 = L(K6 ^ R6)
   move $a0, $t7
   
   lw $t6, 28($s0) 	#t6 = K7
   lw $t4, 28($s5) 	#t4 = R7
   xor $t6, $t6, $t4 	#t6 = K7 ^ R7
   move $a0, $t6
   jal linear_function
   move $a2, $v0 	#a2 = L(K7 ^ R7)
   move $a0, $t7
   
   jal w_function
   move $t6, $v0 	#t6 = W((R3 + t2) mod 2^16, L(K6 ^ R6), L(K7 ^ R7))
   lw $t4, 0($s5) 	#t4 = R0
   add $t6, $t6, $t4 
   andi $t6, $t6, 0xFFFF #t6 = W((R3 + t2) mod 2^16, L(K6 ^ R6), L(K7 ^ R7)) + R0 mod 2^16 
   sw $t6, 0($s3) 	#t6 = Cx
   
   
   #THIRD PART: Tx VALUES
   lw $t0, 0($s7)
   lw $t1, 4($s7)
   lw $t2, 8($s7)
   
   lw $t4, 0($s5) 	#t4 = R0
   add $s4, $t4, $t2
   andi $s4, $s4, 0xFFFF #s4 = (R0 + t2) mod 2^16
   sw $s4, 0($s6) 	#T0 = (R0 + t2) mod 2^16
   
   lw $t4, 4($s5) 	#t4 = R1
   add $s4, $t4, $t0
   andi $s4, $s4, 0xFFFF 
   sw $s4, 4($s6) 	#T1 = (R1 + t0) mod 2^16
   
   lw $t4, 8($s5) 	#t4 = R2
   add $s4, $t4, $t1 
   andi $s4, $s4, 0xFFFF #s4 = (R2 + t1) mod 2^16
   sw $s4, 8($s6) 	#T2 = (R2 + t1) mod 2^16
   
   lw $t4, 0($s5) 	#t4 = R0
   lw $t5, 12($s5) 	#t5 = R3
   add $s4, $t5, $t4 	#s4 = R3 + R0
   add $s4, $s4, $t2
   add $s4, $s4, $t0
   andi $s4, $s4, 0xFFFF
   sw $s4, 12($s6)
   
   lw $t4, 0($s5) 	#t4 = R0 
   lw $t5, 12($s5) 	#t5 = R3
   add $s4, $t5, $t4 	#s4 = R3 + t0
   add $s4, $s4, $t2
   add $s4, $s4, $t0
   andi $s4, $s4, 0xFFFF
   lw $t4, 16($s5) 	#t4 = R4
   xor $s4, $t4, $s4
   sw $s4, 16($s6) 	#T4 = R4 ^ ((R3 + R0 + t2 + t0) mod 2^16)
   
   lw $t4, 4($s5) 	#t4 = R1
   add $s4, $t4, $t0 	#s4 = (R1 + t0) mod 2^16
   andi $s4, $s4, 0xFFFF
   lw $t4, 20($s5) 	#t4 = R5
   xor $s4, $t4, $s4
   sw $s4, 20($s6) 	#T5 = R5 ^ ((R1 + t0) mod 2^16)
   
   lw $t4, 8($s5)	#t4 = R2
   add $s4, $t4, $t1 	#s4 = (R2 + t1) mod 2^16
   andi $s4, $s4, 0xFFFF
   lw $t4, 24($s5) 	#t4 = R6
   xor $s4, $t4, $s4
   sw $s4, 24($s6) 	#T6 = R6 ^ ((R2 + t1) mod 2^16)
   
   lw $t4, 0($s5) 	#t4 = R0
   add $s4, $t4, $t2
   andi $s4, $s4, 0xFFFF
   lw $t4, 28($s5) 	#t4 = R7
   xor $s4, $t4, $s4 
   sw $s4, 28($s6) 	#T7 = R7 ^ ((R0 + t2) mod 2^16)

   lw $t3, 0($s6)
   sw $t3, 0($s5)
   lw $t3, 4($s6)
   sw $t3, 4($s5)
   lw $t3, 8($s6)
   sw $t3, 8($s5)
   lw $t3, 12($s6)
   sw $t3, 12($s5)
   lw $t3, 16($s6)
   sw $t3, 16($s5)
   lw $t3, 20($s6)
   sw $t3, 20($s5)
   lw $t3, 24($s6)
   sw $t3, 24($s5)
   lw $t3, 28($s6)
   sw $t3, 28($s5)
   
   addi $s2, $s2, 4
   addi $s3, $s3, 4
   addi $s1, $s1, 1
 
   beq $s1, 8, exit_encrypt
   
   j encryption_init_loop
   
exit_encrypt:   
   lw $s0, 0($sp)
   lw $s1, 4($sp)
   lw $s2, 8($sp)
   lw $s3, 12($sp)
   lw $s4, 16($sp)
   lw $s5, 20($sp)
   lw $s6, 24($sp)
   lw $s7, 28($sp)
   lw $ra, 32($sp)
   addi $sp, $sp, 36
   
   jr $ra
   
    
#DECRYPTION
decryption_init: 
   addi $sp, $sp, -32
   sw $s0, 0($sp)
   sw $s1, 4($sp)
   sw $s2, 8($sp)
   sw $s3, 12($sp)
   sw $s4, 16($sp)
   sw $s5, 20($sp)
   sw $s6, 24($sp)
   sw $s7, 28($sp)
   
   la $s0, KEY_DE	#s0: address of KEY
   la $s2, P_DE 		#s2: address of P
   la $s3, C_EN 		#s3: address of C
   la $s5, R_DE 		#s5: address of R
   li $s1, 0 		#loop counter i = 0
   la $s6, T_DE		#s6: address of T
   la $s7, temp_DE	#s7: address of t

decryption_init_loop: 

   #FIRST PART: tX registers
   # t2 ? (W?1((C ?R0) mod 216,L(K6 ?R6),L(K7 ?R7))?R3) mod 216)
   lw $t4, 0($s5)	#load from R
   lw $t5, 0($s3)	#load from C 
   
   sub $t7, $t5, $t4 	#t7 = C - R0
   andi $t7, $t7, 0xFFFF #t7 = (C - R0) mod 2^16
   
   
   
   lw $t4, 24($s5)  	#t4 = R6
   lw $t6, 24($s0) 	#load from KEY 
   xor $t6, $t6, $t4 	#t6 = K6 ^ R6
   move $a0, $t6
   
   jal linear_function  
   move $a1, $v0 	#a1 = L(K6 ^ R6) 
   move $a0, $t7 
      
   lw $t6, 28($s0) 	#t6 = K7
   lw $t4, 28($s5) 	#t4 = R7
   xor $t6, $t6, $t4 	#t6 = K7 ^ R7
   move $a0, $t6
   
   jal linear_function
   move $a2, $v0 	#a2 = L(K7 ^ R7)
   move $a0, $t7
   
   jal inv_w_function
   lw $t6, 12($s5)
   sub $v0, $v0, $t6
   andi $v0, $v0, 0xFFFF
   move $t2, $v0
   sw $t2, 8($s7)

   
   # t1 ? (W?1(t2,L(K4 ?R4),L(K5 ?R5))?R2) mod 216
   move $t7, $t2
   
   lw $t6, 16($s0) 	#t6 = K4
   lw $t4, 16($s5)	#t4 = R4
   xor $t6, $t6, $t4 	#t6 = K4 ^ R4
   move $a0, $t6
   
   jal linear_function
   move $a1, $v0 	#a1 = L(K4 ^ R4)
   move $a0, $t7 
   
   lw $t6, 20($s0) 	#t6 = K5
   lw $t4, 20($s5)	#t4 = R5
   xor $t6, $t6, $t4 	#t6 = K5 ^ R5
   move $a0, $t6
   
   jal linear_function	
   move $a2, $v0 	#a2 = L(K5 ^ R5)? R2
   move $a0, $t7  
   
   jal inv_w_function
   lw $t6, 8($s5)
   sub $v0, $v0, $t6
   andi $v0, $v0, 0xFFFF
   move $t1, $v0
   sw $t1, 4($s7)
   
   

   # t0 ? (W?1(t1,L(K2 ?R2),L(K3 ?R3))?R1) mod 216
   move $t7, $t1
   
   lw $t6, 8($s0) 	#t6 = K2
   lw $t4, 8($s5) 	#t4 = R2
   xor $t6, $t6, $t4 	#t6 = K2 ^ R2
   move $a0, $t6
   
   jal linear_function
   move $a1, $v0 	#L(K4 ^ R4)
   move $a0, $t7
   
   lw $t6, 12($s0) 	#t6 = K3
   lw $t4, 12($s5) 	#t4 = R3
   xor $t6, $t6, $t4 	#t6 = K3 ^ R3
   move $a0, $t6
   
   jal linear_function
   move $a2, $v0 	#a2 = L(K5 ^ R5)
   move $a0, $t7
  
   jal inv_w_function
   lw $t6, 4($s5)
   sub $v0, $v0, $t6
   andi $v0, $v0, 0xFFFF
   move $t0, $v0
   sw $t0, 0($s7)
   

   
   
   
   #SECOND PART: PLAINTEXT
   move $t7, $t0
   
   lw $t6, 0($s0) 	#t6 = K0
   lw $t4, 0($s5) 	#t4 = R0
   xor $t6, $t6, $t4 	#t6 = K0 ^ R0
   move $a0, $t6
   
   jal linear_function
   move $a1, $v0 	#a1 = L(K0 ^ R0)
   move $a0, $t7
   
   lw $t6, 4($s0) 	#t6 = K1
   lw $t4, 4($s5) 	#t4 = R1
   xor $t6, $t6, $t4 	#t6 = K1 ^ R1
   move $a0, $t6
   
   jal linear_function
   move $a2, $v0 	#a2 = L(K1 ^ R1) - R0
   move $a0, $t7
   
   jal inv_w_function
   lw $t6, 0($s5)
   sub $v0, $v0, $t6
   andi $v0, $v0, 0xFFFF
   move $t6, $v0 	#t6 = W((R3 + t2) mod 2^16, L(K6 ^ R6), L(K7 ^ R7)) 
   sw $t6, 0($s2) 	#t6 = Px
   
   
   #THIRD PART: Tx VALUES
   lw $t0, 0($s7)
   lw $t1, 4($s7)
   lw $t2, 8($s7)
   
   lw $t4, 0($s5) 	#t4 = R0
   add $s4, $t4, $t2
   andi $s4, $s4, 0xFFFF #s4 = (R0 + t2) mod 2^16
   sw $s4, 0($s6) 	#T0 = (R0 + t2) mod 2^16
   
   lw $t4, 4($s5) 	#t4 = R1
   add $s4, $t4, $t0
   andi $s4, $s4, 0xFFFF 
   sw $s4, 4($s6) 	#T1 = (R1 + t0) mod 2^16
   
   lw $t4, 8($s5) 	#t4 = R2
   add $s4, $t4, $t1 
   andi $s4, $s4, 0xFFFF #s4 = (R2 + t1) mod 2^16
   sw $s4, 8($s6) 	#T2 = (R2 + t1) mod 2^16
   
   lw $t4, 0($s5) 	#t4 = R0
   lw $t5, 12($s5) 	#t5 = R3
   add $s4, $t5, $t4 	#s4 = R3 + R0
   add $s4, $s4, $t2
   add $s4, $s4, $t0
   andi $s4, $s4, 0xFFFF
   sw $s4, 12($s6)
   
   lw $t4, 0($s5) 	#t4 = R0 
   lw $t5, 12($s5) 	#t5 = R3
   add $s4, $t5, $t4 	#s4 = R3 + t0
   add $s4, $s4, $t2
   add $s4, $s4, $t0
   andi $s4, $s4, 0xFFFF
   lw $t4, 16($s5) 	#t4 = R4
   xor $s4, $t4, $s4
   sw $s4, 16($s6) 	#T4 = R4 ^ ((R3 + R0 + t2 + t0) mod 2^16)
   
   lw $t4, 4($s5) 	#t4 = R1
   add $s4, $t4, $t0 	#s4 = (R1 + t0) mod 2^16
   andi $s4, $s4, 0xFFFF
   lw $t4, 20($s5) 	#t4 = R5
   xor $s4, $t4, $s4
   sw $s4, 20($s6) 	#T5 = R5 ^ ((R1 + t0) mod 2^16)
   
   lw $t4, 8($s5)	#t4 = R2
   add $s4, $t4, $t1 	#s4 = (R2 + t1) mod 2^16
   andi $s4, $s4, 0xFFFF
   lw $t4, 24($s5) 	#t4 = R6
   xor $s4, $t4, $s4
   sw $s4, 24($s6) 	#T6 = R6 ^ ((R2 + t1) mod 2^16)
   
   lw $t4, 0($s5) 	#t4 = R0
   add $s4, $t4, $t2
   andi $s4, $s4, 0xFFFF
   lw $t4, 28($s5) 	#t4 = R7
   xor $s4, $t4, $s4 
   sw $s4, 28($s6) 	#T7 = R7 ^ ((R0 + t2) mod 2^16)

   lw $t3, 0($s6)
   sw $t3, 0($s5)
   lw $t3, 4($s6)
   sw $t3, 4($s5)
   lw $t3, 8($s6)
   sw $t3, 8($s5)
   lw $t3, 12($s6)
   sw $t3, 12($s5)
   lw $t3, 16($s6)
   sw $t3, 16($s5)
   lw $t3, 20($s6)
   sw $t3, 20($s5)
   lw $t3, 24($s6)
   sw $t3, 24($s5)
   lw $t3, 28($s6)
   sw $t3, 28($s5)
   
   addi $s2, $s2, 4
   addi $s3, $s3, 4
   addi $s1, $s1, 1
 
   beq $s1, 8, print_decrypt
   
   j decryption_init_loop


print_decrypt:
    li $v0, 4      
    la $a0, print_dec
    syscall
   la $s3, P_DE 	#s3: address of P_de
   li $t7, 0	#counter = 0

print_decrypt_loop:
    beq $t7, 8, exit_decrypt	#if counter == 8, go to exit
    
    lw $t1, 0($s3)
    li $v0, 34		#syscall for hexadecimal printing
    move $a0, $t1
    syscall
    li $v0, 4       	#syscall for "\n" printing
    la $a0, enter
    syscall
    
    addi $s3, $s3, 4	#moving to the next val of C
    addi $t7, $t7, 1	#counter++
    j print_decrypt_loop
   
exit_decrypt:   
   lw $s0, 0($sp)
   lw $s1, 4($sp)
   lw $s2, 8($sp)
   lw $s3, 12($sp)
   lw $s4, 16($sp)
   lw $s5, 20($sp)
   lw $s6, 24($sp)
   sw $s7, 28($sp)
   addi $sp, $sp, 32
   
   li $v0, 10       #syscall for exit
   syscall

