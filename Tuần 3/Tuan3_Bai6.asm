#Tìm số có giá trị tuyệt đối lớn nhất trong 1 dãy số
.data
	A: .word 1,2,-4,5,-15,6,-135,7,-3,-20
.text
	addi $s5, $zero, 0	# max = 0
	addi $s1, $zero, 0	# i = 0
	addi $s3, $zero, 10	#n = 10
	addi $s4, $zero, 1	#step = 1
	addi $s6, $zero, 0	# $s6 is max
	la $s2, A               # luu dia chi A
loop:
	slt $t2, $s1, $s3
	beq $t2, $zero, endloop
	add $t1, $s1, $s1
	add $t1, $t1, $t1
	add $t1, $t1, $s2
	lw $t0, 0($t1)
	abs $t0, $t0            # lấy gtri tuyệt đối
	slt $t4, $t0, $s6       #kiểm tra số đó bé hơn hay lớn hơn max
	bne $t4, $zero, else    #bé hơn thì nhảy qua else để tiếp tục vòng lặp
	add $s6, $zero, $t0     #lớn hơn thì thay số max bằng số đó
else:
	add $s1, $s1, $s4
	j loop
endloop:
