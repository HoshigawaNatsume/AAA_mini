	.data
str0:
	.string "%d"
str:
	.string "'%c'"
str1:
	.string "a= "
str2:
	.string "\n"
str3:
	.string "b= "
str4:
	.string "x= "

	# label main
	.text
	.global main
main:

	# begin
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#64

	# var a

	# var b

	# var x

	# a = 1
	mov x8,#1

	# b = 2
	mov x9,#2

	# actual L1
	ldr x0, =str1

	# call PRINTS
	str x8,[sp, #0]
	str x9,[sp, #8]
	bl printf

	# actual a
	ldr x8, [sp, #0]
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

	# actual b
	ldr x8, [sp, #8]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L2
	ldr x0, =str2

	# call PRINTS
	bl printf

	# actual b
	# address
	add x26, sp, #8
	mov x1,x26 

	# actual a
	# address
	add x26, sp, #0
	mov x0,x26 

	# call func
	bl func

	# actual L1
	ldr x0, =str1

	# call PRINTS
	bl printf

	# actual a
	ldr x8, [sp, #0]
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

	# actual b
	ldr x8, [sp, #8]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L2
	ldr x0, =str2

	# call PRINTS
	bl printf

	# var t0

	# actual b
	ldr x8, [sp, #8]
	mov x1,x8 

	# actual a
	ldr x9, [sp, #0]
	mov x0,x9 

	# t0 = call func1
	bl func1

	# x = t0
	str x0, [sp, #24]
	ldr x8, [sp, #24]

	# actual L1
	ldr x0, =str1

	# call PRINTS
	str x8,[sp, #16]
	bl printf

	# actual a
	ldr x8, [sp, #0]
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

	# actual b
	ldr x8, [sp, #8]
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

	# actual x
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
	add sp,sp,#64
	ldp x29, x30, [sp], #16
	ret

	# label func
func:

	# begin
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#64

	# formal &c
	str x0,[sp,#0]
	# formal &d
	str x1,[sp,#8]
	# c = 20
	mov x8,#20
	str x8, [x0]
	# d = 10
	mov x9,#10
	str x9, [x1]
	# end
	mov x0,#0
	add sp,sp,#64
	ldp x29, x30, [sp], #16
	ret

	# label func1
	str x8,[sp, #0]
	str x9,[sp, #8]
func1:

	# begin
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#64

	# formal e
	str x0,[sp,#0]
	# formal f
	str x1,[sp,#8]
	# e = 100
	mov x8,#100

	# f = 200
	mov x9,#200

	# return 99
	mov x0,#99
	add sp,sp,#64
	ldp x29, x30, [sp], #16
	ret

	# end
