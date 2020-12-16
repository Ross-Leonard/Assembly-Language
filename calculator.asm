TITLE calculator        (calculator.asm)

;Greg McGlathery
;CS 340
;This is a simple calculator program

INCLUDE Irvine32.inc

.data
CR             EQU       10
LF             EQU       13
NULL           EQU       0
myStr          byte      16 dup(0)
               byte      CR,LF,NULL
khar           byte      0
myLabel        byte      "          Calculator Program"
               byte      CR,LF
               byte      "Enter equations here.  To move to next equation, enter '='"
               byte      CR,LF
               byte      "Enter 'Q' to exit"
               byte      CR,LF,NULL
endl           byte      CR,LF,NULL
outfile        dword     ?
filename       byte      "results.txt",NULL

.code
main PROC
     lea       edx,myLabel         ;load and write my label
     call      WriteString
     call      WTF
     lea       edx,filename        ;process for creating output file
     call      CreateOutputFile
     mov       outfile,eax         

next:
     lea       esi,myStr           ;load myStr to esi for reading
     call      readIn              ;Receive input from user
     lea       edx,endl            ;print end line
     call      WriteString         
     cmp       al,'Q'         
     je        GetOut              ;leave if Q
     cmp       al,'q'
     je        GetOut              ;or q
     lea       esi,myStr           ;load esi with myStr for writing
     call      WTF                 ;print input to file
     lea       esi,myStr           ;load esi for ascii conversion
     call      AtoI                
     mov       ebx,eax             ;store first number in ebx
     call      operand
     call      aryBegin            ;point to beginning of array
     call      AtoI                
     cmp       cl,'+'              ;these are our comparisions
     je        addIt               
     cmp       cl,'-'              ;check for subtraction
     je        subIt
     cmp       cl,'*'              ;check for multiplication
     je        mult
     cmp       cl,'/'              ;check for division
     je        divIt
addIt:     
     add       eax,ebx             ;add ebx to eax
     jmp       cleanup             
subIt:
     sub       ebx,eax             ;sub eax from ebx
     mov       eax,ebx             ;move ebx into eax
     jmp       cleanup
mult:
     imul      eax,ebx             ;mul eax and ebx
     jmp       cleanup
divIt:
     mov       ecx,eax             
     mov       eax,ebx             
     sub       edx,edx
     idiv      ecx                 ;divide eax by ecx
cleanup:
     lea       esi,myStr
     mov       ch,16
     call      BlankOut            
     call      ItoA
     call      WTF                 
     lea       esi,myStr
     mov       ch,16
     call      BlankOut            
     lea       esi,myStr
     mov       ch,16
     call      BlankOut
     sub       eax,eax
     sub       ebx,ebx
     mov       ecx,1
     sub       edx,edx
     sub       esi,esi            
     jmp       next
GetOut:
     exit
main ENDP

aryBegin     PROC                
next:
          inc       esi
          mov       edx,NULL
          mov       dl,[esi]
          cmp       dl,' '
          je        next
          ret
aryBegin     ENDP

AtoI      PROC
          mov eax,NULL
nextDigit:
          mov edx,NULL
          mov dl,[esi]
          cmp dl,'0'
          jl  GetOut          ;digit must be positive
          cmp dl,'9'          ;digit must be less than or equal to 9
          jg GetOut             
          add dl,-'0'
          imul eax,10
          add eax,edx
          inc esi
          jmp nextDigit
GetOut:
          ret
AtoI ENDP

WTF PROC
          mov bl,NULL
next:
          mov eax,outfile
          mov edx,esi
          mov ecx,1
          call WriteToFile
          add esi,1
          cmp[esi],bl              ;null check
          jne next
          ret
WTF   ENDP

readIn       PROC
next:
          call ReadChar
          call WriteChar
          mov khar,al              ;save char
          mov[esi],al
          inc esi
          cmp al,'='               
          je  GetOut               ;terminates equation line
          cmp al,'Q'               ;look for 'Q'
          je  GetOut               ;leave if equal
          cmp al,'q'               ;look for 'q'
          je GetOut                ;leave if equal
          jmp next                 
GetOut:
          ret
readIn       ENDP

readOut   PROC
          mov ch,16
          lea esi,myStr
          call BlankOut
          call ItoA
          mov edx,esi
          call WriteString
          ret
readOut   ENDP

BlankOut  PROC
next:
          mov cl,' '
          mov[esi],cl
          inc esi
          dec ch
          cmp ch,NULL
          jne next
          ret
BlankOut ENDP

ItoA      PROC
next:
          mov edx,NULL
          mov ecx,10
          idiv ecx
          add dl,'0'
          dec esi
          mov[esi],dl
          cmp eax,NULL
          jne next
          ret
ItoA      ENDP

operand    PROC
          lea  esi,myStr
          mov  ecx,NULL
next:
          mov  cl,[esi]
          cmp  cl,'+'
          je   GetOut
          cmp  cl,'-'
          je   GetOut
          cmp  cl,'*'
          je   GetOut
          cmp  cl,'/'
          je   GetOut
          inc  esi
          jmp  next
GetOut:
          ret
operand    ENDP

end main
