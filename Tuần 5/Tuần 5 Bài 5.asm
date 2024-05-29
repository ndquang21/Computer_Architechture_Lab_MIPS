.data
     string: .space 20 
     rvstring: .space 20
.text
      li $s0, 0
      la $a1, string
      la $a2, rvstring
   L1: 				#vòng lặp để nhập ký tự
     li $v0, 12			# nhập từng ký tự
     syscall
     beq $v0, 0x0000000a, reverse_string         #nếu = enter thì kết thúc nhập
     add $t1, $s0, $a1 		# lưu các ký tự vừa nhập vào string
     add $t2, $zero, $v0	
     sb $t2, 0($t1) 		
     beq $s0, 19, reverse_string      # nếu nhập đến 20 ký tự thì kết thúc nhập
     nop
     add $s0,$s0,1 		
     j L1 			
     nop
   reverse_string:
     li $s0, 0
     li $s1, 0
     L2: 
       add $t1, $s0, $a1	# duyệt đến ký tự cuối cùng trong chuỗi 
       lb $t2, 0($t1)
       beq $t2, 0, L3	# nếu duyệt đến null thì đã xong và nhảy đến L3
       add, $s0, $s0, 1
       j L2
    L3:		                # vòng lặp lưu các ký tự theo chiều ngược lại thành chuỗi rvstring	
       sub $s0, $s0, 1		# bắt đầu lưu từ ký tự cuối cùng và trừ 1 dần
       add $t1, $s0, $a1
       add $t3, $s1, $a2
       add $s1, $s1, 1
       lb $t2, 0($t1)
       sb $t2, 0($t3)
       beq $s0, 0, print
       j L3
    print:   #in chuỗi ngược
       li $v0, 4
       la $a0, rvstring
       syscall  
   end:
