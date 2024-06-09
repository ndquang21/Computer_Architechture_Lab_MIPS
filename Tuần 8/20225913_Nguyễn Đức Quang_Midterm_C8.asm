.data
str: .space 100   # max 100 ki tu
mes_1: .asciiz "Nhap chuoi: "
mes_2: .asciiz "So chu hoa: "
mes_3: .asciiz "\nSo chu thuong: "
mes_4: .asciiz "\nSo chu so: "
mes_5: .asciiz "\n"

.text
main:
    	# in mes_1
    	li $v0, 4
    	la $a0, mes_1
    	syscall

    	li $v0, 8
    	la $a0, str
    	li $a1, 100   	# max 100 ki tu
    	syscall

    	la $a0, str
    	jal dem_hoa
    	move $s0, $v0   # $s0 = so luong chu hoa

    	la $a0, str
    	jal dem_thuong
    	move $s1, $v0   #  $s1 = so luong chu thuong 

    	la $a0, str
    	jal dem_so
    	move $s2, $v0   # $s2 = so luong chu so

    	li $v0, 4
    	la $a0, mes_2
    	syscall
    	li $v0, 1
    	move $a0, $s0
    	syscall

    	li $v0, 4
    	la $a0, mes_3
    	syscall
    	li $v0, 1
    	move $a0, $s1
    	syscall

    	li $v0, 4
    	la $a0, mes_4
    	syscall
    	li $v0, 1
    	move $a0, $s2
    	syscall

    	li $v0, 12
    	la $a0, '\n'
    	syscall

    	li $v0, 10	#exit
    	syscall

dem_hoa:
    	li $v0, 0          # kq=0
    	li $t0, 0x41       # ASCII of 'A'
    	li $t1, 0x5A       # ASCII of 'Z'

loop_hoa:
    	lb $t2, ($a0)      # doc ki tu
    	beq $t2, $zero, hoa_ket_thuc  	# neu gap ki tu ket thuc -> dung lap 
    	blt $t2, $t0, hoa_tiep  	# if < 'A' bo qua
    	bgt $t2, $t1, hoa_tiep  	# if > 'Z' bo qua
    	addi $v0, $v0, 1   # +1
hoa_tiep:
    	addi $a0, $a0, 1   # i++
    	j loop_hoa
hoa_ket_thuc:
    	jr $ra


dem_thuong:
    	li $v0, 0          # kq=0
    	li $t0, 0x61       # mã ASCII của 'a'
    	li $t1, 0x7A       # mã ASCII của 'z'

loop_thuong:
    	lb $t2, ($a0)      # doc ki tu
    	beq $t2, $zero, thuong_ket_thuc  	# neu gap ki tu ket thuc -> dung lap
    	blt $t2, $t0, thuong_tiep  	# if < 'a' bo qua
    	bgt $t2, $t1, thuong_tiep  	# if > 'z' bo qua
    	addi $v0, $v0, 1   # kq++
thuong_tiep:
    	addi $a0, $a0, 1   # i++
    	j loop_thuong
thuong_ket_thuc:
    	jr $ra
    	

dem_so:
    	li $v0, 0          # kq 0
    	li $t0, 0x30       # ASCII of '0'
    	li $t1, 0x39       # ASCII of '9'

loop_so:
    	lb $t2, ($a0)      # doc ki tu
    	beq $t2, $zero, so_ket_thuc  	# neu gap ki tu ket thuc -> dung lap
    	blt $t2, $t0, so_tiep  		# if < '0' bo qua
    	bgt $t2, $t1, so_tiep  		# if > '9' bo qua
    	addi $v0, $v0, 1   # kq++
so_tiep:
    	addi $a0, $a0, 1   # i++
    	j loop_so
so_ket_thuc:
    	jr $ra
