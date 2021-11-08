	.text
	.file	"main.c"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%fs:40, %rax
	movq	%rax, 16(%rsp)
	movl	$0, 12(%rsp)
	leaq	.L.str(%rip), %rdi
	leaq	12(%rsp), %rsi
	xorl	%eax, %eax
	callq	__isoc99_scanf@PLT
	movl	12(%rsp), %edx
	movl	$1, %eax
	cmpl	$1, %edx
	je	.LBB0_5
# %bb.1:
	leal	-1(%rdx), %eax
	addl	$-2, %edx
	movl	%eax, %ecx
	andl	$7, %ecx
	cmpl	$7, %edx
	jae	.LBB0_7
# %bb.2:
	movl	$1, %edx
	movl	$1, %esi
	jmp	.LBB0_3
.LBB0_7:
	andl	$-8, %eax
	negl	%eax
	movl	$1, %edx
	movl	$1, %esi
	.p2align	4, 0x90
.LBB0_8:                                # =>This Inner Loop Header: Depth=1
	addl	%esi, %edx
	addl	%edx, %esi
	addl	%esi, %edx
	addl	%edx, %esi
	addl	%esi, %edx
	addl	%edx, %esi
	addl	%esi, %edx
	addl	%edx, %esi
	addl	$8, %eax
	jne	.LBB0_8
.LBB0_3:
	movl	%esi, %eax
	testl	%ecx, %ecx
	je	.LBB0_5
	.p2align	4, 0x90
.LBB0_4:                                # =>This Inner Loop Header: Depth=1
	movl	%edx, %eax
	addl	%esi, %eax
	movl	%esi, %edx
	movl	%eax, %esi
	addl	$-1, %ecx
	jne	.LBB0_4
.LBB0_5:
	movq	%fs:40, %rcx
	cmpq	16(%rsp), %rcx
	jne	.LBB0_9
# %bb.6:
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.LBB0_9:
	.cfi_def_cfa_offset 32
	callq	__stack_chk_fail@PLT
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d"
	.size	.L.str, 3

	.ident	"clang version 12.0.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __stack_chk_fail
