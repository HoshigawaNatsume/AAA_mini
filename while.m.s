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
	sub sp,sp,#64

	# var i

	# i = 1
	mov x8,#1

	# label L2
	str x8,[sp, #0]
L2:

	# var t0

	# t0 = (i < 10)
	ldr x8, [sp, #0]
	mov x9,#10
    cmp x8,x9
	cset x28, lt

	# ifz t0 goto L3
	str x8,[sp, #8]
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

	# var t1

	# t1 = i + 1
	ldr x8, [sp, #0]
	mov x9,#1
	add x8,x8,x9

	# i = t1
	str x8,[sp, #16]

	# goto L2
	str x8,[sp, #0]
	mov x27, #0
	cmp x28, x27
	b L2

	# label L3
L3:

	# end
	mov x0,#0
	add sp,sp,#64
	ldp x29, x30, [sp], #16
	ret
