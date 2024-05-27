# Nhân một số bất kỳ với một số là lũy thừa của 2 (x * 2^n) sử dụng phép dịch
.text
 	addi $s1, $zero, 3		#khởi tạo giá trị cần được nhân
 	addi $s2, $zero, 8		#khởi tạo giá trị nhân là lũy thừa của 2
     start:
     loop:
     	sll $s1, $s1, 1			#nhân $s1 với 2 bằng cách dịch trái 1 bit
     	srl $s2, $s2, 1			#chia $s2 cho 2 bằng cách dịch phải 1 bit
     	beq $s2, 1, endloop		#vòng lặp thực hiện khi $s2 (lũy thừa của 2) dịch phải đến bằng 1, khi đó $s1 sẽ là tích cần tìm 
     	j loop
     endloop:
     	
 	
