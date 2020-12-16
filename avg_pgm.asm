TITLE Sum, Average, Largest Number        (avg_pgm.asm)

; Greg McGlathery
; CS 340
; This program takes an array and performs various calculatios
; Finds the average of the array, sum, remainder, and find the largest

INCLUDE Irvine32.inc

.data
ary		dword	50, -20, 35
		dword	14,  45,  -37
		dword	82,  134,  83
		dword	59, -24,  1
		dword	-19,  30,  55
		dword	81,  74,  83
		dword	0
sum		dword	?
avg		dword	?
remain	dword	?
large	dword	?
cnt		dword	0			;0 is sentinel value
cnter	dword	18
NULL		EQU		0
CR		EQU		10
LF		EQU		13

endl byte CR,LF,NULL
sumMsg byte "Sum = ",NULL
avgMsg byte "Average = ",NULL
remMsg byte "Remainder = ",NULL
lrgMsg byte "Largest = ",NULL

ans byte 8 DUP(?)				;setting up array 

.code
main PROC
		sub eax,eax			;puts 0 in eax
		mov ebx,0				;sentinel value
		call sumIt			;call sumIt proc
		mov sum,eax			;store value in sum
		
		call avgIt			;call avgIt

		sub eax,eax			;zero register
		sub ebx,ebx			;zero register
		
		call findLarge			;findLarge PROC

		lea esi,sumMsg			;print sum label
		call WriteLine

		mov eax,sum			;moving sum into eax
		call ItoA				;integer to ASCII PROC
		lea esi,ans			;for printing sum
		call WriteLine
		lea esi,endl
		call WriteLine

		lea esi,avgMsg			;print avg label
		call WriteLine
		mov eax,avg			;for average
		call ItoA
		lea esi,ans
		call WriteLine
		lea esi,endl
		call WriteLine

		lea esi,remMsg			;print remainder label
		call WriteLine
		mov eax,remain			;for remainder value
		call ItoA
		lea esi,ans
		call WriteLine
		lea esi,endl
		call WriteLine

		lea esi,lrgMsg			;print largest label
		call WriteLine
		mov eax,large			;for largest value
		call ItoA
		lea esi,ans
		call WriteLine
		lea esi,endl
		call WriteLine

	exit
main ENDP

sumIt PROC
		mov	esi, offset ary		;address of array
next:	add eax,[esi]				;indirect addressing
		add esi,4					;bump array
		cmp ebx,[esi]				;compare to see if we hit sentinel value
		jne next
		ret
sumIt ENDP

avgIt PROC
		mov ebx,eax			;sum is in eax, we move sum into ebx
		mov eax,cnter			;into eax we move our counter
next:	sub ebx,cnter			;take from sum the value of counter
		add cnt,1				;bump our counter for average.  How many times did we sub 18 from sum?
		cmp ebx,eax			;compare new sum of ebx to eax(18)
		jge next				;is our new sum greater than 18?  if yes, loop to next
		add remain,ebx			;if it isn't, move into remain the value of ebx, which is our remainder
		mov ebx,cnt			;move dividend to register ebx	
		mov avg,ebx			;move ebx to average

		ret
avgIt ENDP

findLarge PROC
		sub ebx,ebx
		sub eax,eax
		mov	esi, offset ary	;address of array
		mov eax,[esi]
		mov large,eax

run:		sub eax,eax		;start with 0
		add esi,4			;bump to next index
		mov eax,[esi]		;move index value to eax
		cmp eax,large		;compare if eax is larger than largest value thus far
		jge lg			;jump if greater than or equal to lg
		cmp eax,large		
		jle check			;jump if less than or equal to check if sentinel value

lg:		mov large,eax		;move value of eax to large
		add esi,4			;bump stack
		mov eax,[esi]		;move new value to eax
		cmp eax,large		;compare new eax to large value
		jge lg			;if greater than or equal repeat
		cmp eax,large
		jle check			;jump if less than or equal to check if sentinel value

check:	cmp ebx,[esi]	
		jne run

		ret
findLarge ENDP

WriteLine PROC
next:	mov al,[esi]			;pulls first index character
		cmp al,NULL			;is that character = to NULL?
		je ex				;if so, jump to ex, call BlankOut and ret
		call WriteChar			;if not, use Irvine's WriteChar proc to print character
		add esi,1				;bump index of array
		jmp next				;loop back to next

ex:		call BlankOut		
		ret
WriteLine ENDP

BlankOut PROC
		mov ecx,8				;counter for array size, will be decremented
		lea esi,ans			;address of answer array stored on esi
		mov al,' '			;moving blank into al
next:	mov[esi],al			;moving into first position of array a blank
		add esi,1				;bumping index of array
		add ecx,-1			;decrementing counter
		cmp ecx,0				;have we used our 8 bytes?
		jne next				;if not, loop to next, if yes, ret and end PROC

		ret			
BlankOut ENDP

ItoA PROC
		mov ecx,10			;For idiv, signed integer division
next:	cmp eax,0				;is our number no longer divisible by ecx(10)?
		je ex				;if yes, jump to ex and ret
		mov edx,0				;move into register edx the value 0
		idiv ecx				;idiv always from 'a' register; eax,ax..
		add dl,'0'			;into low 'd' register we add character 0, converting the number to ASCII
		add esi,-1			;to put us into the array
		mov [esi],dl			;moving remainder from idiv into index of esi
		jmp next				;repeat

ex:		ret
ItoA ENDP

END main
