.intel_syntax noprefix                      # use the intel syntax, not AT&T syntax. do not prefix registers with %

.section .data                              # memory variables
msg: .asciz "Enter integer number: "        # message will appear to the user
input: .asciz "%d"                          # string that will be used for scanf parameter
output: .asciz "The sum is: %f\n"           # string that will be used for printf parameter
n: .int 0                                   # the variable n which we will get from user using scanf
result: .double 0.0                         # the variable will store final value in each loop itreation and will be printed ,is initialized to 0
r:.double 0.0                               # the variable will store value of equation untill put it in result variable 
s:.double 1.0                               # the variable will take values from 1 to n and increase in each loop itreation by 1 ,is initialized to 1
one:.double 1.0                             # the variable is initialized to 1 to use in divide opertion in equation

.section .text                              # instructions

.global _main                               # make _main accessible from external
_main:                                      # the label indicating the start of the program
   push OFFSET msg                          # push to stack the first parameter to printf
   call _printf                             # call printf
   add esp,4                                # pop the parameter by adding 4 to esp(top of stack)


   push OFFSET n                            # push to stack the second parameter to scanf (the address of the integer variable n)
   push OFFSET input                        # push to stack the first parameter to scanf
   call _scanf                              # call scanf, it will use the two parameters on the top of the stack in the reverse order
   add esp, 8                               # pop the above two parameters from the stack by increasing 8(2*4) to esp(top of stack)

   mov ecx, n                               # ecx(used as a loop counter) <- n (the number of iterations)

   
loop6:                                      # the label indicating the start of the loop
   finit                                     # initialize floating-point unit after checking error conditions,empty stack
   fld qword ptr one                         # push 1 to the floating point stack (st0)
   fdiv qword ptr s                          # pop the floating point stack top (1), divide it over s and push the result (1/s)
   fdiv qword ptr s                          # pop the floating point stack top (1/s), divide it over s and push the result ((1/S)/s=1/s^2)
   fadd qword ptr s                          # pop the floating point stack top (1/s^2), add it to r and push the result (s+1/s^2)
   fstp qword ptr r                          # pop the floating point stack top (s+1/s^2) into the memory variable r
  
   fld qword ptr result                      # push result variable to the floating point stack (st0)
   fadd qword ptr r                          # pop the floating point stack top result, add it to r and push the result 
   fstp qword ptr result                     # pop the floating point stack top r into the memory variable result

   fld qword ptr s                           # push s variable to the floating point stack (st0)
   fadd qword ptr one                        # pop the floating point stack top s, add it to 1 and push the result (s+1)
   fstp qword ptr s                          # pop the floating point stack top (s+1) into the memory variable s
 

   loop loop6                                # end of loop
  
   push [result+4]                          # push to stack the high 32-bits of the second parameter to printf (the double at label result)
   push result                              # push to stack the low 32-bits of the second parameter to printf (the double at label result)
   push OFFSET output                       # push to stack the first parameter to printf
   call _printf                             # call printf
   add esp, 12                              # pop the above two parameters

ret                                         # end the main function
