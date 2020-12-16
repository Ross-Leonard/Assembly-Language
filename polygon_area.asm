TITLE profit polygon        (polygon.asm)

; Greg McGlathery
; CS 340
; This program calculates the area of various polygons

INCLUDE Irvine32.inc

CR				    EQU		13
LF				    EQU		10
NULL				  EQU		0
coordLength		EQU		8
yi				    EQU		4
xp1				    EQU		8
yp1				    EQU		12

.data
endl				byte			CR,LF,NULL
shp1				dword		0,0,0,4,8,4,8,0,0,0
shp2				dword		0,0,12,4,12,0,0,0
shp3				dword		0,0,0,8,9,6,9,-2,0,0
shp4				dword		0,0,2,4,-2,6,3,6,4,10,5,6,10,6,6,4,7,0,4,3,0,0
shp5				dword		0,0,6,7,16,3,24,7,21,-1,16,1,14,-4,11,-1,4,-2,8,2,0,0
shp1Len			dword		4
shp2Len			dword		3
shp3Len			dword		4
shp4Len			dword		10
shp5Len			dword		11
label1			byte			"The area of Shape 1 is:  ",NULL
label2			byte			"The area of Shape 2 is: ",NULL
label3			byte			"The area of Shape 3 is: ",NULL
label4			byte			"The area of Shape 4 is: ",NULL
label5			byte			"The area of Shape 5 is: ",NULL
appendStr		byte			" square units.",NULL
sum				  dword		0
num1				dword		0
num2				dword		0
ans			    byte			3	dup(?),NULL
ansLen			dword		3
fileName		byte			"results.txt",NULL
outFile			dword		?


.code 
main PROC

		lea		edx,fileName
		call		CreateOutputFile
		mov		outFile,eax

		lea		edi,label1		;for shape 1
		call		WTF				;Write it to file
		lea		edi,shp1			;load edi with array for shape 1
		mov		ecx,shp1Len		;load total vector of polygon into ecx
		call		findArea			;findArea PROC
		lea		edi,ans			;load answer into edi
		call		BlankOut			
		call		ItoA
		call		WTF
		lea		edi,appendStr
		call		WTF
		lea		edi,endl
		call		WTF

		lea		edi,label2		;for shape 2
		call		WTF				;write to file
		lea		edi,shp2			;load shape 2 array
		mov		ecx,shp2Len		;load vector of shape 2
		call		findArea			;call findArea proc
		lea		edi,ans			
		call		BlankOut
		call		ItoA
		lea		edi,ans
		call		WTF
		lea		edi,appendStr
		call		WTF
		lea		edi,endl
		call		WTF

		lea		edi,label3		;for shape 3
		call		WTF				;Write to file
		lea		edi,shp3			;load shape 3 array
		mov		ecx,shp3Len		;load vector of shape 3
		call		findArea			;call findArea proc
		lea		edi,ans
		call		BlankOut
		call		ItoA
		lea		edi,ans
		call		WTF
		lea		edi,appendStr
		call		WTF
		lea		edi,endl
		call		WTF

		lea		edi,label4		;for shape 4
		call		WTF				;Write to file
		lea		edi,shp4			;load shape 4 array
		mov		ecx,shp4Len		;load vector for shape 4
		call		findArea			;call findArea proc
		lea		edi,ans
		call		BlankOut
		call		ItoA
		lea		edi,ans
		call		WTF
		lea		edi,appendStr
		call		WTF
		lea		edi,endl
		call		WTF

		lea		edi,label5		;for shape 5
		call		WTF				;Write to file
		lea		edi,shp5			;load shape 5 array
		mov		ecx,shp5Len		;load vector for shape 5
		call		findArea			;call findArea proc
		lea		edi,ans
		call		BlankOut
		call		ItoA
		lea		edi,ans
		call		WTF
		lea		edi,appendStr
		call		WTF
		lea		edi,endl
		call		WTF

exit

main ENDP

findArea PROC

		mov		sum,0
first:	mov		eax,[edi+xp1]		;calculates first num in sequence
		mov		ebx,[edi+yi]
		imul		ebx
		mov		num1,eax

		mov		eax,[edi]
		mov		ebx,[edi+yp1]
		imul		ebx
		mov		num2,eax

		mov		eax,num1
		sub		eax,num2
		add		sum,eax			;add to our sum

		add		edi,coordLength	;next coord
		loop		first			;back to first

		mov		eax,sum
		cmp		eax,0
		jl		negative
		jge		positive

negative:	mov		edx,0
		mov		ebx,-1
		imul		ebx

positive:	mov		ebx,2
		idiv		ebx

		ret
findArea		ENDP

ItoA PROC	
			push	eax			;for value preservation
			push	ebx
			push	ecx
			push	edx

			mov		ebx,10
next:		mov		edx,0
			idiv		ebx
			add		dl,30h
			dec		edi
			mov		[edi],dl
			cmp		eax,0
			jne		next

			pop		edx
			pop		ecx
			pop		ebx
			pop		eax
			ret
ItoA ENDP

WriteLine PROC
			push	eax
			push	ebx
next:		mov		al,[edi]
			cmp		al,NULL
			je		OutOfHere
			inc		edi
			call		WriteChar
			jmp		next
OutOfHere:	pop		ebx
			pop		eax
			ret
WriteLine ENDP

BlankOut PROC
			push		eax
			push		ecx
			mov		ecx,0
			mov		al,' '
next:		mov		[edi],al
			inc		edi
			inc		ecx
			cmp		ecx,ansLen
			jne		next
			pop		ecx
			pop		eax
			ret
BlankOut ENDP

WTF PROC
			push		eax
			push		ebx
			push		ecx
			push		edx
nextC:		mov		al,[edi]
			cmp		al,NULL
			je		LeaveHere
			mov		eax,outFile
			mov		ecx,1
			mov		edx,edi
			inc		edi
			call		WriteToFile
			jmp		nextC			
LeaveHere:
			pop		edx
			pop		ecx
			pop		ebx
			pop		eax
			ret
WTF ENDP

END main
