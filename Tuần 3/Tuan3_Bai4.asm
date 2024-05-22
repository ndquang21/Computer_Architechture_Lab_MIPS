.text
   addi $s1, $zero, 5   #i
   addi $s2, $zero, 6   #j
   addi $s4, $zero, 3   #m
   addi $s5, $zero, 4   #n
   addi $t1, $zero, 1   #x
   addi $t2, $zero, 1   #y
   addi $t3, $zero, 1   #z
   add  $s3, $s1, $s2   # i + j
   add  $s6, $s4, $s5   # m + n
start: 
   slt $t0,$s6,$s3      # m + n < i + j 
   beq $t0,$zero,else   # branch to else if i + j <= m + n 
   addi $t1,$t1,1       # then part: x=x+1 
   addi $t3,$zero,1     # z=1 
   j endif              # skip “else” part 
else: addi $t2,$t2,-1   # begin else part: y=y-1 
      add $t3,$t3,$t3   # z=2*z 
endif: