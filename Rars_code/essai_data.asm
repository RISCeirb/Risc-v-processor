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
    addi   x10, zero, 10
    

test_R:
	
    add x1, x1 ,x2
    add x1, x1 ,x3
    add x1, x1 ,x4
    addi x0, x0, 0
    addi x0, x0, 0
    add x2, x5, x1
     
    
    
test_I:

test_Load:
	la      t0, array
	lw      x1, 0(t0)             
   	addi    x11, x1, 1
    	add 	x12, x1, x11
    	addi   	x1, zero, 1
    	add     x13, x12, x11
    	add     x14, x1, x1      
    
end: 
    j       end 

.data 
    array:      .word 4 2 1 5 4 7 3
    size:       .word 7
