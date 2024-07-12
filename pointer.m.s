	.data
str0:
	.string "%d"
str:
	.string "'%c'"
str1:
	.string "\n"

	# label main
	.text
	.global main
main:

	# begin
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#32

	# var l

	# var m

	# var p

	# l = 1
	mov x8,#1

	# m = 2
	mov x9,#2
	str x9, [x1]
	# actual l
	str x8,[sp, #0]
	ldr x8,[sp,#0] 
	mov x0,x8 

	# call PRINTN
	str x9,[sp, #8]
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L1
	ldr x0, =str1

	# call PRINTS
	bl printf

	# actual &m
	ldr x8, [sp, #8]
	ldr x8,[sp,#8] 
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L1
	ldr x0, =str1

	# call PRINTS
	bl printf

	# p = &m
	ldr x8, [sp, #8]
	add x26, sp, #8
	str x26,[sp,#16]

	# *p = l
	ldr x9, [sp, #0]
	ldr x26,[sp,#16]
	str x9, [x26]

	# actual &m
	ldr x8,[sp,#8] 
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L1
	ldr x0, =str1

	# call PRINTS
	bl printf

	# end
	mov x0,#0
	add sp,sp,#32
	ldp x29, x30, [sp], #16
	ret
