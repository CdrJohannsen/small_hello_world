; This is very much based on http://www.muppetlabs.com/~breadbox/software/tiny/teensy.html
; I adapted it to Elf64 using https://irix7.com/techpubs/007-4658-001.pdf as a reference
; I don't actually have any idea what i am doing...
BITS 64
            org     0x08048000

ehdr:                                               ; Elf64 Header
            db      0x7F, "ELF", 2, 1, 1, 0         ;   e_ident
    times 8 db      0
            dw      2                               ;   e_type
            dw      0x3E                               ;   e_machine
            dd      1                               ;   e_version
            dq      _start                          ;   e_entry
            dd      phdr - $$                       ;   e_phoff
            dd      0
            dq      0                               ;   e_shoff
            dd      0                               ;   e_flags
            dw      ehdrsize                        ;   e_ehsize
            dw      phdrsize                        ;   e_phentsize
            dw      1                               ;   e_phnum
            dw      0                               ;   e_shentsize
            dw      0                               ;   e_shnum
            dw      0                               ;   e_shstrndx

ehdrsize      equ     $ - ehdr

phdr:                                               ; Elf64 Program Header
            dd      1                               ;   p_type
            dd      5                               ;   p_flags
            dq      0                               ;   p_offset
            dq      $$                              ;   p_vaddr
            dq      $$                              ;   p_paddr
            dq      filesize                        ;   p_filesz
            dq      filesize                        ;   p_memsz
            dq      0                          ;   p_align

phdrsize      equ     $ - phdr

_start:
    mov     eax, 4              ; write
    mov     ebx, 1              ; to stdout
    mov     ecx, msg            ; msg
    mov     edx, msglen         ; of length msglen
    int     0x80                ; syscall

    mov     eax, 1              ; exit
    mov     ebx, 0              ; exit code 0 (success)
    int     0x80                ; syscall

    msg: db "Hello World!", 10  ; somehow works, i dont understand assembly
    msglen: equ $ - msg         ; maybe i should learn assembly before i do something like this

filesize      equ     $ - $$    ; $ = position of current line, $$ = position of start of segment
