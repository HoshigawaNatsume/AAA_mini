	.data
str0:
	.string "%d"
str1:
	.string "\n"

	# var i
i:
	.word 0

	# label main
	.text
	.global main
main:
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#64

	# begin

	# var l

	# var n

	# l = 3
	mov x0,#3

	# i = 1
	mov x1,#1
	ldr x7, =i
	str x1, [x7]

	# var t0

	# actual i
	mov x1,x1 

	# actual l
	str x0,[sp, #0]
	mov x0,x0 

	# t0 = call func
	bl func

	# n = t0
	str x0, [sp, #16]
	ldr x0, [sp, #16]

	# actual n
	str x0,[sp, #8]
	mov x0,x0 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# end
	mov x0,#0
	add sp,sp,#64
	ldp x29, x30, [sp], #16
	ret

	# label func
func:
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#64

	# begin

	# formal o

	# formal p

	# actual o
	**str x1, [sp, #0]
	mov x0,x0 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L1
	ldr x0, =str1

	# call PRINTS
	bl printf

	# actual p
	ldr x0, [sp, #8]
	mov x0,x0 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L1
	ldr x0, =str1

	# call PRINTS
	bl printf

	# return 999
	mov x0,#999
	add sp,sp,#64
	ldp x29, x30, [sp], #16
	ret

	# end
