; Function Prologue
; Setting up the stack and allocating space for local variables
0x400957:  push    rbp
0x400958:  mov     rbp, rsp
0x40095b:  push    rbx
0x40095c:  sub     rsp, 0x28

; The function signature:
;   valid_serial(char* string, int serial)
;
; And they are moved into local variables:
;   char* string
;   int serial
0x400960:  mov     qword [rbp-0x28], rdi
0x400964:  mov     dword [rbp-0x2c], esi

; There is one more local variable:
;   int local_variable_AA = 0x4141;
    0x400967:  mov     dword [rbp-0x18], 0x4141
; This is the index within the for loop:
;   for (int i = 0; i < 0x500; i++)

    0x40096e:  mov     dword [rbp-0x14], 0x0
    0x400975:  jmp     0x4009ab

; This is where the manipulation takes place
;   local_variable_AA += str[i % strlen(str)];
    0x400977:  mov     eax, dword [rbp-0x14]    ; eax = i
    0x40097a:  movsxd  rbx, eax                 ; eax = i
    0x40097d:  mov     rax, qword [rbp-0x28]    ; rax = string
    0x400981:  mov     rdi, rax                 ; rdi = string
    0x400984:  call    strlen                   ; strlen(string)
    0x400989:  mov     rcx, rax                 ; rcx = strlen(string)
    0x40098c:  mov     rax, rbx                 ; rax = i
    0x40098f:  mov     edx, 0x0                 ; edx = 0
    0x400994:  div     rcx                      ; rax = i / strlen(string)
                                                ; rdx = i % strlen(string)
    0x400997:  mov     rax, qword [rbp-0x28]    ; rax = string
    0x40099b:  add     rax, rdx                 ; rax = string + i % strlen(string)
    0x40099e:  movzx   eax, byte [rax]          ; eax = string[i % strlen(string)]
    0x4009a1:  movzx   eax, al                  ;
    0x4009a4:  add     dword [rbp-0x18], eax    ; local_variable_AA += string[i % strlen(string)]
    0x4009a7:  add     dword [rbp-0x14], 0x1    ; i++
    0x4009ab:  cmp     dword [rbp-0x14], 0x4ff  ; i < 0x500
    0x4009b2:  jle     0x400977                 ; loop
    0x4009b4:  mov     eax, dword [rbp-0x18]    ; eax = local_variable_AA
    0x4009b7:  cmp     eax, dword [rbp-0x2c]    ; compare local_variable_AA and serial
    0x4009ba:  sete    al                       ; return 1 if true
    0x4009bd:  movzx   eax, al                  ; return bool as 32 bit value (zero extended)

    
; The stack is cleaned up and we return
    0x4009c0:  add     rsp, 0x28
    0x4009c4:  pop     rbx
    0x4009c5:  pop     rbp
    0x4009c6:  retn

; ----------------------------------------------------;
; ----------------------------------------------------;

; int valid_serial(char* string, int serial) {
;   int local_variable_AA = 0x4141;
;   for (int i = 0; i < 0x500; i++) {
;     local_variable_AA += string[i % strlen(string)];
;   }
;   
;   return (local_variable_AA == serial);
; }
