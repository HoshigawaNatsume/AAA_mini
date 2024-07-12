	.data
str0:
	.string "%d"
str:
	.string "'%c'"
str1:
	.string "a[0]= "
str2:
	.string "\n"
str3:
	.string "a[1]= "
str4:
	.string "b= "

	# label main
	.text
	.global main
main:

	# begin
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#32

	# var a[2]

	# var b

	# a[0] = 0
	mov x8,#0
	str x8, [sp,#0]
	# a[1] = 1
	mov x9,#1
	str x9, [sp,#8]
	# b = 3
	mov x10,#3

	# actual L1
	ldr x0, =str1

	# call PRINTS
	str x10,[sp, #16]
	bl printf

	# actual a[0]
	ldr x8,[sp,#0]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L2
	ldr x0, =str2

	# call PRINTS
	bl printf

	# actual L3
	ldr x0, =str3

	# call PRINTS
	bl printf

	# actual a[1]
	ldr x8,[sp,#8]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L2
	ldr x0, =str2

	# call PRINTS
	bl printf

	# actual L4
	ldr x0, =str4

	# call PRINTS
	bl printf

	# actual b
	ldr x8, [sp, #16]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L2
	ldr x0, =str2

	# call PRINTS
	bl printf

	# end
	mov x0,#0
	add sp,sp,#32
	ldp x29, x30, [sp], #16
	ret
