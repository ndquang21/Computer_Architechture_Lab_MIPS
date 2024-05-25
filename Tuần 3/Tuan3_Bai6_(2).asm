.data
     A: .word 1,4,12,54,34,65,87,23,54,86
.text
     addi $s1, $zero, 10    # n
     addi $s3, $zero, 0     # i
     addi $s6, $zero, 0     # max number
     addi $s4, $zero, 1     # step = 1
     la $s2, A              # array A' address
loop: 
     slt $t2, $s3, $s1      # i < n ? 1:0
     beq $t2, $zero, endloop
     add $t1, $s3, $s3
     add $t1, $t1, $t1
     add $t1, $t1, $s2
     lw  $t0, 0($t1)
     abs $t0, $t0
     slt $t3, $t0, $s6
     bne $t3, $zero, else
     add $s6, $zero, $t0
else:
     add $s3, $s3, $s4
     j loop
endloop:          