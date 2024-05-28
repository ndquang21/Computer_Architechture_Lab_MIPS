# Nhân một số bất kỳ với một số là lũy thừa của 2 (x * 2^n) sử dụng phép dịch
.text
 	addi $s1, $zero, 3		#khởi tạo giá trị cần được nhân
 	addi $s2, $zero, 8		#khởi tạo giá trị nhân là lũy thừa của 2
 	li   $t0, 1			#biến kiểm tra
     start:
     loop:
     	sll $s1, $s1, 1			#nhân $s1 với 2 bằng cách dịch trái 1 bit
     	sll $t0, $t0, 1			#nhân biến kiểm tra với 2 bằng cách dịch trái 1 bit
     	beq $t0, $s2, endloop		#kiểm tra xem biến kiểm tra đã bằng $s2 chưa, nếu rồi thì tức là đã nhân xong và endloop
     	j loop
     endloop:
     	
 	
