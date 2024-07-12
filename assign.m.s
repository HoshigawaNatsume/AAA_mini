	.data
str0:
	.string "%d"
str:
	.string "'%c'"
str1:
	.string "i="
str2:
	.string "\n"
str3:
	.string "j="
str4:
	.string "k="
str5:
	.string "l="
str6:
	.string "m="

	# label main
	.text
	.global main
main:

	# begin
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#64

	# var i

	# var j

	# var k

	# var l

	# var m

	# i = 8
	mov x8,#8

	# var t0

	# t0 = i + 2
	str x8,[sp, #0]
	mov x9,#2
	add x8,x8,x9

	# j = t0
	str x8,[sp, #40]

	# var t1

	# t1 = i - 3
	ldr x10, [sp, #0]
	mov x11,#3
	sub x10,x10,x11

	# k = t1
	str x10,[sp, #48]

	# l = 'a'
	mov x12,#97

	# var t2

	# t2 = l + 1
	str x12,[sp, #24]
	mov x13,#1
	add x12,x12,x13

	# m = t2
	str x12,[sp, #56]

	# actual L1
	ldr x0, =str1

	# call PRINTS
	str x8,[sp, #8]
	str x10,[sp, #16]
	str x12,[sp, #32]
	bl printf

	# actual i
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

	# actual j
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

	# actual k
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

	# actual L5
	ldr x0, =str5

	# call PRINTS
	bl printf

	# actual l
	ldr x8, [sp, #24]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str
	bl printf

	# actual L2
	ldr x0, =str2

	# call PRINTS
	bl printf

	# actual L6
	ldr x0, =str6

	# call PRINTS
	bl printf

	# actual m
	ldr x8, [sp, #32]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str
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
