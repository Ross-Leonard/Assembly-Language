TITLE Linked List program (LList.asm)

;Greg McGlathery
;sorts names and scores using a linked list

INCLUDE IRVINE32.inc

.data
     cr              eQU         13                                  ;carriage return
     Lf              eQU         10                                  ;line feed 
     nULL            eQU         0                                   ;null
     infile          dword       ?                                   ;output file handle
     infiledesc      byte        "input.txt",nULL                    
     outfile         dword       ?                                   
     outfiledesc     byte        "results.txt",nULL                  
     mystr           byte        1000 dup(?)                         
     endl            byte        cr,Lf,nULL                          
     head            dword       0                                   
     prev            dword       0                                   
     current         dword       0                                   
     max             dword       ?                                   
     offset1         equ         20                                  
     offset2         equ         24                                  
     offset3         equ         28                                  
     myLabel         byte        "Sorted Linked List",nULL           
     spacer          byte        ": ",nULL                           

.code
MAIN PROC
    push    ebp                                             
    mov     ebp,esp                                        

    call    infileIt                                     
    lea     esi,max                                    
getmax:
        mov     eax,infile                                 
        mov     edx,esi                                    
        mov     ecx,1                                      
        call    readfromfile                                
        cmp     byte ptr [esi],13                          
        je      setMax                                
        inc     esi                                         
        jmp     getmax 
setMax:
        mov     byte ptr [esi],NULL                           
        lea     esi,max                                
        call    AtoI                                   
        mov     max,eax                                
        lea     edi,mystr
insert:
        cmp     eax,NULL                                      
        je      getOut                                     
        mov     esi,edi                                    
nameIt:
        call    readIn                                    
        cmp     byte ptr [esi],'a'                     
        jge     toUpper                              
        jmp     nameIt                                
toUpper:
        and     byte ptr [esi],5fh              
setname:
        inc     esi                                    
        call    readIn                                 
        cmp     byte ptr [esi],'a'                     
        jl      nullify                             
        jmp     setname                             
nullify:
        mov     byte ptr [esi],NULL                    
        mov     esi,edi                             
        add     esi,offset1
grade:
        call    readIn     
        cmp     byte ptr [esi],'0'
        jl      grade             
        cmp     byte ptr [esi],'9'
        jg      grade             
setIt:
        inc     esi
        call    readIn
        cmp     byte ptr [esi],'0'   
        jl      percent
        cmp     byte ptr [esi],'9' 
        jg      percent            
        jmp     setIt              
percent:
        push    eax                
        mov     byte ptr [esi],NULL   
        mov     esi,edi            
        add     esi,offset1        
        call    AtoI               
        mov     esi,edi            
        mov     dword ptr offset1[esi],eax    
        pop     eax                           
linkIt:
        push    esi                           
        push    eax                              
        mov     [prev],NULL                         
        mov     esi,[head]                       
        mov     [current],esi                    
        jmp     trav                           
trav:
        cmp     [head],NULL                       
        je      setHead                        
        cmp     [current],NULL                    
        je      nEnd                            
        mov     esi,[current]                     
        mov     eax,dword ptr offset1[esi]     
        cmp     dword ptr offset1[edi],eax     
        jg      nPrior                           
        mov     [prev],esi                         
        push    edi                                 
        mov     edi,dword ptr offset2[esi]      
        mov     [current],edi                      
        pop     edi                                 
        jmp     trav                        
setHead:
        mov     [head],edi                         
        jmp     linky                           
nHead:
        mov     esi,[head]                         
        mov     dword ptr offset2[edi],esi      
        mov     [head],edi                      
        jmp     linky                           
nPrior:
        cmp     esi,[head]                      
        je      nHead                          
        mov     esi,[prev]                     
        mov     dword ptr offset2[esi],edi     
        mov     esi,[current]                  
        mov     dword ptr offset2[edi],esi     
        jmp     linky                          
nEnd:
        mov     [current],edi                  
        mov     esi,[prev]                        
        mov     dword ptr offset2[esi],edi      
        jmp     linky                           
linky:
        pop     eax                                    
        pop     esi                                     
        add     edi,offset3                         
        jmp     insert                                    
getOut:
        call    closefile                                  
        call    outfileIt                               
        mov     edi,[head]                                
        call    printIt                                  
        call    closefile                                   
        pop     ebp                                        
        
        INVOKE EXITPROCESS,NULL                                               
MAIN ENDP

infileIt PROC
    push    ebp                                             
    mov     ebp,esp                                        
    push    eax                                            
    push    edx                                            
    lea     edx,infiledesc                              
    call    openinputfile                               
    mov     infile,eax                                  
    pop     edx                                         
    pop     eax                                         
    pop     ebp                                         
    ret                                                 
infileIt ENDP

outfileIt PROC
    push    ebp                                             
    mov     ebp,esp                                        
    push    eax                                            
    push    edx                                            
    lea     edx,outfiledesc                                
    call    createoutputfile                               
    mov     outfile,eax                                    
    pop     edx                                            
    pop     eax                                            
    pop     ebp                                            
    ret                                                    
outfileIt ENDP

AtoI PROC
         push    ebp                                             
         mov     ebp,esp                                        
         push    ecx                                            
         mov     ecx,10                                         
         mov     eax,NULL                                       
         mov     ebx,NULL                                       
next:
        mov     bl,[esi]                                   
        cmp     bl,30h                                     
        jl      getOut                                     
        cmp     bl,39h                                     
        jg      getOut                                     
        xor     bl,'0'                                     
        imul    ecx                                        
        add     eax,ebx                                    
        inc     esi                                        
        jmp     next                                       
getOut:
        pop     ecx                                        
        pop     ebp                                        
        ret                                                
AtoI ENDP

ItoA PROC
    push    ebp                                            
    mov     ebp,esp                                        
    push    ebx                                            
    push    edx                                            
    mov     edi,esi                                        
    mov     ebx,10                                         
next:
        cmp     eax,NULL                                   
        je      reverse                                    
        mov     edx,NULL                                   
        idiv    ebx                                        
        xor     dl,'0'                                     
        mov     [esi],dl                                   
        inc     esi                                        
        jne     next                                       
reverse:
        dec     esi                                       
        cmp     edi,esi                                   
        jg      getOut                                    
        mov     al,[esi]                                  
        mov     bl,[edi]                                  
        mov     [edi],al                                  
        mov     [esi],bl                                  
        inc     edi                                       
        jmp     reverse                                          
getOut:
        pop     edx                                       
        pop     ebx                                       
        pop     ebp                                       
        ret                                               
ItoA ENDP

readIn PROC
    push    ebp                                             
    mov     ebp,esp                                        
    push    ecx                                            
    push    edx                                            
    mov     eax,infile                                     
    mov     edx,esi                                        
    mov     ecx,1                                          
    call    readfromfile                                   
    pop     edx                                            
    pop     ecx                                            
    pop     ebp                                            
    ret                                                    
readIn ENDP

WTF PROC
    push    ebp                                             
    mov     ebp,esp                                        
    push    ebx                                            
    push    ecx                                            
    push    edx                                            
next:
        cmp     byte ptr [esi],NULL                           
        je      getOut                                      
        mov     eax,outfile                                
        mov     edx,esi                                    
        mov     ecx,1                                      
        call    Writetofile                                
        inc     esi                                        
        jmp     next                                       
getOut:
        pop     edx                                        
        pop     ecx                                        
        pop     ebx                                        
        pop     ebp                                        
        ret                                                
WTF ENDP

printIt PROC
        push    ebp                                             
        mov     ebp,esp                                        
        push    eax                                                
        lea     esi,myLabel                                
        call    WTF                                        
        lea     esi,endl                                
        call    WTF                                     
        lea     esi,endl                                
        call    WTF                                     
next:
        cmp     edi,NULL                                     
        je      getOut                                      
        mov     esi,edi                       
        call    WTF                           
        lea     esi,spacer                    
        call    WTF                           
        mov     esi,edi                       
        add     esi,offset1                   
        mov     eax,[esi]                     
        call    percentIt                     
        mov     [esi],eax                     
        push    edi                           
        call    ItoA                          
        pop     edi                           
        mov     esi,edi                                                     
        add     esi,offset1                   
        call    WTF                           
        lea     esi,endl                      
        call    WTF                           
        mov     esi,edi                       
        add     esi,offset2                   
        mov     edi,dword ptr [esi]           
        jmp     next                          
getOut:
        pop     eax                               
        pop     ebp                               
        ret                                       
printIt ENDP

endline PROC
    push    ebp                                             
    mov     ebp,esp                                        
    push    esi                                            
    lea     esi,endl                                    
    call    WTF                                             
    pop     esi                                             
    pop     ebp                                             
    ret                                                     
endline ENDP

percentIt PROC
    push    ebp                                             
    mov     ebp,esp                                        
    push    ebx                                            
    push    edx                                            
    xor     edx,edx                                        
    mov     ebx,100                                        
    imul    ebx                                            
    xor     edx,edx                                        
    mov     ebx,[max]                                  
    idiv    ebx                                        
    pop     edx                                        
    pop     ebx                                        
    pop     ebp                                        
    ret                                                
percentIt ENDP

end MAIN
