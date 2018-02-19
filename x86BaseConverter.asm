%include "io.inc"
section .data
    %include "input.inc"
section .text
global CMAIN
CMAIN:
    mov ebp, esp
    xor eax, eax ; pun toti registrii utilizati initial pe 0
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx

loop_nums: ; loop-ul ia fiecare numar, in transforma si il transforma in baza ceruta
    mov ebx, [base_array + ecx * 4] ; iau bazele in ordine
    cmp ebx, 2 ; daca o baza nu apartine [2,16]
    jl base_out_of_bounds
    cmp ebx, 16
    jg base_out_of_bounds ; se sare la afisarea mesajului "Baza incorecta"
    
    mov eax, [nums_array + ecx * 4] ; iau numerele in ordine
    
    xor esi, esi ; folosesc esi pentru a numara cate cifre are un numar intr-o baza
 generate_num:
    xor edx, edx ; setez edx pe 0 pt ca deimpartitul e pe 32 de biti si pus in edx:eax
    div ebx ; impart edx:eax la ebx, dar cum edx e 0, de fapt impart eax la ebx
    push edx ; pun restul impartirii pe stiva
    inc esi ; incrementez numarul de cifre 
    cmp eax, 0 ; reiau impartirea, daca nu s-a ajuns la catul 0
    jne generate_num
    
display_num: ; loop-ul face afisarea numarului in baza dorita
    pop edx ; iau cifrele in ordine descrescatoare
    cmp edx, 9 ; daca e o cifra intre 0 si 9, codul sau ascii e numar + 48
    jg letter_digit
    add edx, 48
    PRINT_CHAR dl ; codul ascii incape in dl
    jmp next_digit
letter_digit:
    add edx, 87 ; daca e o cifra intre a si f, codul ei ascii e numar + 87
    PRINT_CHAR dl ; codul ascii incape in dl
next_digit:
    sub esi, 1 ; scad numarul de cifre ce mai trebuie afisate
    cmp esi, 0 ; daca s-au afisat toate cifrele numarului curent
    jne display_num ; trec la convertirea numarului urmator
    
    NEWLINE

    cmp ebx, 2 ; dupa terminarea procesarii unui numar, se sare la numarul urmator
    jge next_number ; astfel evit afisarea de fiecare data a mesajului "Baza incorecta"
    cmp ebx, 16
    jle next_number
    
base_out_of_bounds:
    PRINT_STRING "Baza incorecta" 
    NEWLINE
next_number:
    inc ecx ; se trece la numarul urmator din nums_array
    cmp ecx, [nums]
    jl loop_nums
    
    ret
