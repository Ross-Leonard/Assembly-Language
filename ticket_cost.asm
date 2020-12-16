TITLE profit table        (table.asm)

; Greg McGlathery
; CS 340
; This program generates a profit table and produces the best ticket price
; to maximize profit

INCLUDE Irvine32.inc

.data

LF   EQU 10
CR   EQU 13
NULL EQU 0

endl		        byte      CR,LF,NULL
outfileDesc     dword     ?
outfile         byte      "results.txt",NULL
negate	        byte      "-",NULL
dcmal		        byte      ".",NULL
zero		        byte      "0",NULL
price           dword     485
patrons         dword     160
expenses	      dword     100
bestPrice	      dword     0
bestProfit      dword     0
myString		    byte      16 dup(0),NULL
dollar	        dword     ?
cents		        dword     ?
product		      dword     ?
header          byte      "                        Plays",CR,CR,LF,NULL
myLabel         byte      "Ticket Price              Patrons                Profit",CR,CR,LF,NULL
profLabel       byte      CR,CR,"The best ticket price is ",NULL
dollarSign      byte      "$",NULL
spacer3		      byte      "                  ",NULL
spacer2		      byte      "                    ",NULL
spacer		      byte      "   ",NULL

.code
main proc
     lea edx,outfile                              ;sequence for creating outfile
     call CreateOutputFile
     mov outfileDesc,eax                          

     lea esi,header                               ;load esi with header label
     call WTF; print title                        ;print it

     lea esi,myLabel                              ;load esi with myLabel
     call WTF; print header                       ;print it

start:
     lea esi,spacer                               
     call WTF; print spacer                       ;print spacer

     mov eax,price                                
     call writeDollar                             ;print price

     lea esi,spacer2
     call WTF                                     ;print second spacer

     mov ch,16;                                   ;move into 8 bit register value 16
     lea esi,myString
     call BlankOut                                

     mov eax,patrons
     call ItoA
     call WTF                                     ;print patrons

     lea esi,spacer3
     call WTF                                     ;print third spacer

     call profitCalc                              ;call PROC that calculates profit

     mov eax,ecx                                  ;move profit to eax
     call writeDollar                             ;print profit with writeDollar proc

     lea esi,endl
     call WTF                                     ;prints new line

     mov eax,expenses
     add eax,9
     mov expenses,eax                             ;inc expense by 9 cents

     mov eax,patrons
     add eax,16
     mov patrons,eax                              ;increase patrons by 16

     mov eax,price
     add eax,-10
     mov price,eax                                ;decrease price by 10 cents

     cmp eax,225
     jge start                                    ;check if ticket price is below $2.25

     lea esi,profLabel                            ;load and print profit label
     call WTF

     mov eax,bestPrice                            ;load and print the best price
     call writeDollar

exit
main endp

profitCalc proc
     mov eax,price                                ;move initial price to eax
     mov ebx,patrons                              ;move into ebx patrons value
     imul ebx                                     ;multiply the two
     mov ecx,eax                                  ;move into ecx

     mov eax,expenses                             ;load expenses into eax
     mov ebx,patrons                              ;load patrons into ebx
     imul ebx                                     ;multiply the two

     sub ecx,eax                                  ;subtracting leaves the profit in ecx

     mov eax,bestProfit                           ;move this value into bestProfit
     cmp eax,ecx                                  ;cmp old bestProfit with new profit
     jg OutOfHere                                 ;is new profit higher than old?
                                                  ;if not, getoutofhere
     mov bestProfit,ecx                           ;if so, update bestProfit to new value

     mov eax,price                                ;move price into eax
     mov bestPrice,eax

OutOfHere: 
     ret
profitCalc endp

writeDollar proc
     sub ebx,ebx                                  ;zero ebx
     cmp eax,-1
     jg positive                                  ;check if price is negative

     mov ebx,-1                                   ;load ebx with -1 to turn into positive number
     imul ebx                                     ;convert negate to positive

     mov product,eax                              ;move eax into product

     lea esi,negate                               ;load esi with negate string
     call WTF                                     ;print negative sign                     

     mov eax,product                              ;move product to eax

positive:
     sub edx,edx                                  ;clean out edx for division
     mov ecx,100                                  
     div ecx                                      ;eax has dollar,edx has cents

     mov dollar,eax
     mov cents,edx

     lea esi,dollarSign

     call WTF                                     ;print dollar sign

     mov eax,dollar
     
     mov ch,16 
     lea esi,myString
     call BlankOut

     call ItoA
     call WTF                                     ;print dollar value

     lea esi,dcmal
     call WTF                                     ;print decimal value

     mov eax,cents
     cmp eax,10                                   ;cmp eax,10
     jge pCents
     lea esi,zero
     call WTF                                     ;print the zero

     mov eax,cents
pCents:
     mov ch,16; 
     lea esi,myString
     call BlankOut

     call ItoA
     call WTF                                     ;print cents
     ret
writeDollar endp

BlankOut proc
start:
     mov cl,' '
     mov[esi],cl
     inc esi
     dec ch
     cmp ch,0
     jne start   
     ret
BlankOut endp

ItoA proc
next:
     mov edx,0
     mov ecx,10

     idiv ecx
     add dl,'0'
     dec esi
     mov[esi],dl
     cmp eax,0
     jne next
     ret
ItoA endp

WTF proc
     mov bl,NULL
nextChar:
     mov eax,outfileDesc
     mov edx,esi
     mov ecx,1
     call WriteToFile
     add esi,1
     cmp[esi],bl; check if null
     jne nextChar
     ret
WTF endp

end main
