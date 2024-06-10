.data
	mes: .asciiz "Nhap so nguyen: "
.text
    	li $v0, 4           	# Sử dụng syscall 4 (in chuỗi)
    	la $a0, mes      	# Đưa địa chỉ của chuỗi mes vào $a0
    	syscall             	# Gọi syscall để in chuỗi	
	
	li $v0, 5
	syscall
	
	move $t9, $v0		# lưu số nguyên vừa nhập vào $t9
	
# Lặp để tìm và in ra các số hoàn hảo nhỏ hơn N
    	li $s0, 1           # Bắt đầu duyệt từ số 1
    	loop1:
        beq $s0, $t9, end_loop  # Nếu $s0 == N, kết thúc vòng lặp

        # Gọi hàm sum_of_divisors để tính tổng các ước số của $t0
        move $t8, $s0           # Đưa giá trị $s0 vào $t8
        jal sum_of_divisors     # Gọi hàm sum_of_divisors
        move $t1, $v0           # Lưu kết quả (tổng các ước số) vào $t1

        # Kiểm tra nếu $t1 == $t0 thì $t0 là số hoàn hảo
        beq $t1, $s0, print_perfect_number

        addi $s0, $s0, 1        # Tăng $t0 lên 1
        j loop1                  # Lặp lại vòng lặp

    print_perfect_number:
       
         # In ra số hoàn hảo $t0
        li $v0, 1               # Sử dụng syscall 1 (in số nguyên)
        move $a0, $t0          	# Di chuyển số hoàn hảo $t0 vào $a0
        syscall                 # Gọi syscall để in số nguyên
        li $v0, 11               # Sử dụng syscall 4 (in chuỗi)
        la $a0, '\n'         	# Đưa địa chỉ của chuỗi newline vào $a0
        syscall                 # Gọi syscall để xuống dòng

        addi $s0, $s0, 1        # Tăng $t0 lên 1
        j loop1                  # Lặp lại vòng lặp

    end_loop:
        li $v0, 10              # Sử dụng syscall 10 (kết thúc chương trình)
        syscall                 # Gọi syscall để kết thúc chương trình
	

# Hàm con để tính tổng các ước số của một số nguyên dương
	sum_of_divisors:
    # $t9: số nguyên dương cần tính tổng ước số
    # $v0: tổng các ước số của số đang xét
   	li $v0, 0       # Khởi tạo tổng ước số = 0
    	li $t0, 1       # Bắt đầu duyệt từ 1
    	loop2:
        beq $t0, $t8, end_sum   # Nếu $t0 == $t8, kết thúc vòng lặp
        div $t8, $t0            # Chia $t8 cho $t0
        mfhi $t1                # Lấy phần dư của phép chia (lưu vào $t1)
        beq $t1, $zero, add_sum # Nếu phần dư = 0, là ước số
        j next_iteration        # Nhảy đến vòng lặp tiếp theo
    	add_sum:
        add $v0, $v0, $t0       # Cộng $t0 vào tổng các ước số
    	next_iteration:
        addi $t0, $t0, 1        # Tăng $t0 lên 1
        j loop2                  # Lặp lại vòng lặp
	end_sum:
        jr $ra                  # Trả về