.eqv MONITOR_SCREEN 0x10010000
.eqv RED 0x00FF0000
.eqv GREEN 0x0000FF00
.eqv BLUE 0x000000FF
.eqv WHITE 0x00FFFFFF
.eqv YELLOW 0x00FFFF00
.eqv PINK 0x00FF9999
.eqv BLUENHAT 0x007799FF
.text
 li $k0, MONITOR_SCREEN
 li $s0, 0
 li $s1, 0
 li $s3, 1 #đếm dòng
 li $s4, 4
 li $s2, 2  
loop1:
 li $t0, PINK
 add $t1, $k0, $s0
 sw $t0, 0($t1)
 addi $s1, $s1, 1
 
 div $s1, $s4
 mfhi $s6
 bne $s6, 0, tiep1
 div $s3, $s2
 mfhi $s6 
 beq $s6, 1, con
 addi $s0, $s0, -4
 addi $s3, $s3, 1
 j tiep1
 con:
 addi $s0, $s0, 4
 addi $s3, $s3, 1
 
 
 tiep1:
 addi $s0, $s0, 8
 beq $s1, 32, continue1
 j loop1
 continue1:
 
 li $k0, MONITOR_SCREEN
 li $s0, 4
 li $s1, 0
 li $s3, 1
 loop2:
 li $t0, BLUENHAT
 add $t1, $k0, $s0
 sw $t0, 0($t1)
 addi $s1, $s1, 1
 
 div $s1, $s4
 mfhi $s6
 bne $s6, 0, tiep2
 div $s3, $s2
 mfhi $s6 
 beq $s6, 0, con1
 addi $s0, $s0, -4
 addi $s3, $s3, 1
 j tiep2
 con1:
 addi $s0, $s0, 4
 addi $s3, $s3, 1
 
 
 tiep2:
 addi $s0, $s0, 8
 beq $s1, 32, continue2
 j loop2
 continue2:
 li $v0, 0
 syscall
