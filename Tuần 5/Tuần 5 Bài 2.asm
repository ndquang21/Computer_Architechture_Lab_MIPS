#Laboratory Exercise 5, Assignment 2
.data
part1: .asciiz "The sum of ("
part2: .asciiz ") and ("
part3: .asciiz ") is ("
part4: .asciiz ")"
.text
 li $s1, 10
 li $s2, 20
 add $t1, $s1, $s2 
 
 li $v0, 4
 la $a0, part1
 syscall 
 
 li $v0, 1
 move $a0, $s1
 syscall 
 
 li $v0, 4
 la $a0, part2
 syscall 
 
 li $v0, 1
 move $a0, $s2
 syscall 
 
 li $v0, 4
 la $a0, part3
 syscall 
 
 li $v0, 1
 move $a0, $t1
 syscall 
 
 li $v0, 4
 la $a0, part4
 syscall 
