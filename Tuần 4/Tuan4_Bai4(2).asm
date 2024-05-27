#kiểm tra một phép cộng có overflow không bằng cách xét dấu của tổng ( nếu cùng dấu với số hạng thì không còn nếu khác thì có overflow)
.text
     start:
     li $t0, 0              	#khởi tạo overflow ( 1: có,  0: không)
     addi $s1, $zero, 14	#khởi tạo $s1
     addi $s2, $zero, -2 	#khởi tạo $s2
     addu $s3, $s1, $s2		#$s3 = $s1 + $s2
     xor $t1, $s1, $s2        	#kiểm tra $s1 và $s2 có cùng dấu ko, xor $s1 và $s2 ra $t1 là một chuỗi bit 
     				#(XOR: bit khác nhau thì output = 1; cùng bit thì output = 0)
     				#bit trọng số lớn nhất = 1 thì $t1 âm, = 0 thì $t1 dương => nếu $s1, $s2 cùng dấu thì dương, trái dấu thì âm
     bltz $t1, EXIT             #so sánh $t1 với 0, nếu âm (nghĩa là trái dấu) thì EXIT vì tổng 2 số trái dấu chắc chắn không có overflow và $t0 = 0
     xor $t2, $s3, $s1 		#xor $s1 (số hạng) với $s3 (tổng) để kiểm tra tổng có cùng dấu số hạng hay không (tương tự như xor ở trên)
     bltz $t2, OVERFLOW		#nếu trái dấu => xảy ra overflow và nhảy đến OVERFLOW
     j EXIT			
OVERFLOW: 
     li $t0, 1
EXIT:     

     
