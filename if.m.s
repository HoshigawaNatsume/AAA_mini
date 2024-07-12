	.data
str0:
	.string "%d"
str1:
	.string "!="
str2:
	.string "=="
str3:
	.string "\n"

	# label main
	.text
	.global main
main:

	# begin
	stp x29, x30, [sp, #-16]!
	sub sp,sp,#64

	# var i

	# var j

	# i = 123
	mov x8,#123

	# j = 222
	mov x9,#222

	# var t0

	# t0 = (i != j)
	str x8,[sp, #0]
    cmp x8,x9
	cset x28, ne

	# ifz t0 goto L3
	str x8,[sp, #16]
	str x9,[sp, #8]
	mov x27, #0
	cmp x28, x27
	b.eq L3

	# actual i
	ldr x10, [sp, #0]
	mov x0,x10 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L1
	ldr x0, =str1

	# call PRINTS
	bl printf

	# actual j
	ldr x8, [sp, #8]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# goto L4
	mov x27, #0
	cmp x28, x27
	b L4

	# label L3
L3:

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

	# actual j
	ldr x8, [sp, #8]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# label L4
L4:

	# i = 999
	mov x8,#999

	# actual L5
	ldr x0, =str3

	# call PRINTS
	str x8,[sp, #0]
	bl printf

	# actual i
	ldr x8, [sp, #0]
	mov x0,x8 

	# call PRINTN
	mov x1, x0
	ldr x0, =str0
	bl printf

	# actual L5
	ldr x0, =str3

	# call PRINTS
	bl printf

	# end
	mov x0,#0
	add sp,sp,#64
	ldp x29, x30, [sp], #16
	ret
