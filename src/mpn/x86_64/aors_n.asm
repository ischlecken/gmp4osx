dnl  AMD64 mpn_add_n, mpn_sub_n

dnl  Copyright 2003, 2004, 2005, 2007, 2008 Free Software Foundation, Inc.

dnl  This file is part of the GNU MP Library.

dnl  The GNU MP Library is free software; you can redistribute it and/or modify
dnl  it under the terms of the GNU Lesser General Public License as published
dnl  by the Free Software Foundation; either version 3 of the License, or (at
dnl  your option) any later version.

dnl  The GNU MP Library is distributed in the hope that it will be useful, but
dnl  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
dnl  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
dnl  License for more details.

dnl  You should have received a copy of the GNU Lesser General Public License
dnl  along with the GNU MP Library.  If not, see http://www.gnu.org/licenses/.

include(`../config.m4')

C	     cycles/limb
C K8,K9:	 1.5
C K10:		 1.5
C P4:		 ?
C P6 core2: 	 4.9
C P6 corei7:
C P6 atom:	 4

C The inner loop of this code is the result of running a code generation and
C optimization tool suite written by David Harvey and Torbjorn Granlund.

C INPUT PARAMETERS
define(`rp',	`%rdi')
define(`up',	`%rsi')
define(`vp',	`%rdx')
define(`n',	`%rcx')
define(`cy',	`%r8')		C (only for mpn_add_nc)

ifdef(`OPERATION_add_n', `
	define(ADCSBB,	      adc)
	define(func,	      mpn_add_n)
	define(func_nc,	      mpn_add_nc)')
ifdef(`OPERATION_sub_n', `
	define(ADCSBB,	      sbb)
	define(func,	      mpn_sub_n)
	define(func_nc,	      mpn_sub_nc)')

MULFUNC_PROLOGUE(mpn_add_n mpn_add_nc mpn_sub_n mpn_sub_nc)

ASM_START()
	TEXT
	ALIGN(16)
PROLOGUE(func_nc)
	mov	R32(n), R32(%rax)
	and	$3, R32(%rax)
	shr	$2, n
	bt	$0, %r8			C cy flag <- carry parameter
	jz	L(1)
	jmp	L(ent)
EPILOGUE()
	ALIGN(16)
PROLOGUE(func)
	mov	R32(n), R32(%rax)
	shr	$2, n
	jz	L(0)
	and	$3, R32(%rax)

L(ent):	mov	(up), %r8
	mov	8(up), %r9
	dec	n
	jmp	L(mid)

	ALIGN(16)
L(top):	ADCSBB	(vp), %r8
	ADCSBB	8(vp), %r9
	ADCSBB	16(vp), %r10
	ADCSBB	24(vp), %r11
	mov	%r8, (rp)
	lea	32(up), up
	mov	%r9, 8(rp)
	mov	%r10, 16(rp)
	dec	n
	mov	%r11, 24(rp)
	lea	32(vp), vp
	mov	(up), %r8
	mov	8(up), %r9
	lea	32(rp), rp
L(mid):	mov	16(up), %r10
	mov	24(up), %r11
	jnz	L(top)

L(end):	lea	32(up), up
	ADCSBB	(vp), %r8
	ADCSBB	8(vp), %r9
	ADCSBB	16(vp), %r10
	ADCSBB	24(vp), %r11
	lea	32(vp), vp
	mov	%r8, (rp)
	mov	%r9, 8(rp)
	mov	%r10, 16(rp)
	mov	%r11, 24(rp)
	lea	32(rp), rp

	inc	R32(%rax)
	dec	R32(%rax)
	jnz	L(1)
	adc	%eax, %eax
	ret

L(0):	test	R32(%rax), R32(%rax)
L(1):	dec	R32(%rax)
	mov	(up), %r8
	jnz	L(2)
	ADCSBB	(vp), %r8
	mov	%r8, (rp)
	adc	%eax, %eax
	ret

L(2):	dec	R32(%rax)
	mov	8(up), %r9
	jnz	L(3)
	ADCSBB	(vp), %r8
	ADCSBB	8(vp), %r9
	mov	%r8, (rp)
	mov	%r9, 8(rp)
	adc	%eax, %eax
	ret

L(3):	mov	16(up), %r10
	ADCSBB	(vp), %r8
	ADCSBB	8(vp), %r9
	ADCSBB	16(vp), %r10
	mov	%r8, (rp)
	mov	%r9, 8(rp)
	mov	%r10, 16(rp)
	setc	%al
	ret
EPILOGUE()
