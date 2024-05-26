.text
     start:
     li $t0,0            #No Overflow is default status
     addi $s1, $zero, -10
     addi $s2, $zero, -10
     addu $s3,$s1,$s2    # s3 = s1 + s2
     xor $t1,$s1,$s2     #Test if $s1 and $s2 have the same sign
     bltz $t1,EXIT       #If not, exit
     bltz $s1,NEGATIVE   #Test if $s1 and $s2 is negative?
     bgtz $s3,EXIT       #Test if $s3 is positive
                         # if $s3 < 0 then the result is overflow
     j OVERFLOW
NEGATIVE:
     bltz $s3, EXIT      # if $s3 < 0 then the result is not overflow
                         # if $s3 > 0 then the result is not overflow
OVERFLOW:
     li $t0,1            #the result is overflow
EXIT:
