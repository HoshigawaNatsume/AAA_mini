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

	# label main
	.text
	.global main
main:

	# begin
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#16

	# var a[2]

	# a[0] = 0
	mov x8,#0
	str x8, [sp,#0]
	# a[1] = 1
	mov x9,#1
	str x9, [sp,#8]
	# actual a
	add x26,sp,#0
	mov x0,x26 

	# call func
	bl func

	# actual L1
	ldr x0, =str1

	# call PRINTS
	bl printf

	# actual a
	add x26,sp,#0
	mov x0,x26 

	# call PRINTN
	ldr x1,[x0]
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

	# actual a
	add x26,sp,#8
	mov x0,x26 

	# call PRINTN
	ldr x1,[x0]
	ldr x0, =str0
	bl printf

	# actual L2
	ldr x0, =str2

	# call PRINTS
	bl printf

	# end
	mov x0,#0
	add sp,sp,#16
	ldp x29, x30, [sp], #16
	ret

	# label func
func:

	# begin
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#16

	# formal x
	str x0,[sp,#0]
	# x[0] = 10
	mov x8,#10
	ldr x26, [sp, #0]
	str x8, [x26]

	# end
	mov x0,#0
	add sp,sp,#16
	ldp x29, x30, [sp], #16
	ret
