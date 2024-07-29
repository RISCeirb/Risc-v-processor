# Programa: Data dependance

.text
main:
    addi   x1, zero, 1          
    addi   x2, zero, 2        
    addi   x3, zero, 3          
    addi   x4, zero, 4
    addi   x5, zero, 5          
    addi   x6, zero, 6
    addi   x7, zero, 7          
    addi   x8, zero, 8  
    addi   x9, zero, 9          
    addi   x10, zero, 2047
    

test_R:
	
    add x11, x1, x2
    sub x12 , x2, x1
    sll x13, x10, x1
    slt x14, x1, x10
    sltu x15, x1, x10
    xor x16, x10, x1
    srl x17, x10, x1
    sra  x18, x10, x1
    or  x19, x10, x9
    and  x20, x10, x9
    
test_I:

test_Load:
	la      t0, array
	lw      x21, 0(t0)             
    lh      x22, 4(t0)
    lhu     x23, 8(t0)             
    lb     	x24, 12(t0)
    lbu     x25, 16(t0)             
    	
test_Store:

	sw      x6, 0(t0)
    	sh      x7, 4(t0)
    	sb      x8, 8(t0)
    	sb      x8, 8(t0)
    	
    
end: 
    j       end 

.data 
    array:      .word 4 65535 65535 65535 65535 65535 7
    size:       .word 7
