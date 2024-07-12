	.data
str0:
	.string "%d"
str:
	.string "'%c'"
str1:
	.string "\n"

	# var i
i:
	.word 0

	# var j
j:
	.word 0

	# var k
k:
	.word 0

p:
	.word 0

	# label main
	.text
	.global main
main:

	# begin
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#64

	# var l

	# var m

	# var n

	# l = 1
	mov x8,#1

	# m = 2
	mov x9,#2

	# n = 3
	mov x10,#3

	# actual l
	str x8,[sp, #0]
	mov x0,x8 

	# call PRINTN
	str x9,[sp, #8]
	str x10,[sp, #16]
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual m
	ldr x8, [sp, #8]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual n
	ldr x8, [sp, #16]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L1
	ldr x0, =str1

	# call PRINTS
	bl printf

	# var t0

	# actual n
	ldr x8, [sp, #16]
	mov x2,x8 

	# actual m
	ldr x9, [sp, #8]
	mov x1,x9 

	# actual l
	ldr x10, [sp, #0]
	mov x0,x10 

	# t0 = call func
	bl func

	# n = t0
	str x0, [sp, #24]
	ldr x8, [sp, #24]

	# actual i
	ldr x9, =i
	ldr x9, [x9]
	mov x0,x9 

	# call PRINTN
	str x8,[sp, #16]
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual j
	ldr x8, =j
	ldr x8, [x8]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual k
	ldr x8, =k
	ldr x8, [x8]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L1
	ldr x0, =str1

	# call PRINTS
	bl printf

	# actual n
	ldr x8, [sp, #16]
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
	add sp,sp,#64
	ldp x29, x30, [sp], #16
	ret

	# label func
func:

	# begin
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#64

	# formal o
	str x0,[sp,#0]
	# formal p
	str x1,[sp,#8]
	# formal q
	str x2,[sp,#16]
	# actual o
	ldr x8, [sp, #0]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual p
	ldr x8, [sp, #8]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual q
	ldr x8, [sp, #16]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L1
	ldr x0, =str1

	# call PRINTS
	bl printf

	# i = o
	ldr x8, [sp, #0]
	ldr x7, =i
	str x8, [x7]

	# j = p
	ldr x9, [sp, #8]
	ldr x7, =j
	str x9, [x7]

	# k = q
	ldr x10, [sp, #16]
	ldr x7, =k
	str x10, [x7]

	# actual i
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual j
	ldr x8, =j
	ldr x8, [x8]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual k
	ldr x8, =k
	ldr x8, [x8]
	mov x0,x8 

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
