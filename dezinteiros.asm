;nasm -f elf dezinteiros.asm; ld dezinteiros.o -o dezinteiros
section .data
; Iniciar variáveis com dados definidos.
msg_int             db      10, "Digite um valor inteiro: "
tam_msg_int         equ     $ - msg_int

msg_digitados       db      10, "Números digitados: "
tam_msg_digitados   equ     $ - msg_digitados

msg_opcao           db      10, "1 - Pares",10, "2 - Ímpares",10, "3 - Maior e menor",10, "4 - Soma total",10, "5 - Média de todos",10, "Opção: ",0
tam_msg_opcao       equ	    $ - msg_opcao

msg_sao_pares       db      10, "São números pares: "
tam_msg_sao_pares   equ     $ - msg_sao_pares

msg_num_pares       db      10, "Número de pares: "
tam_msg_num_pares   equ     $ - msg_num_pares

msg_sao_impares     db      10, "Número de impares: "
tam_msg_sao_impares equ     $ - msg_sao_impares

msg_num_impares     db      10, "Número de ímpares: "
tam_msg_num_impares equ     $ - msg_num_impares

msg_maior_menor     db      10, "Maior e menor valor: "
tam_msg_maior_menor equ     $ - msg_maior_menor

msg_soma_total      db      10, "Soma total dos valores: "
tam_msg_soma_total  equ     $ - msg_soma_total

msg_media_todos     db      10, "Média dos valores: "
tam_msg_media_todos equ     $ - msg_media_todos

msg_resp            db      10, "Resposta: "
tam_msg_resp        equ     $ - msg_resp

msg_erro            db      10, "Comando inválido! Fim da execução.",10
tam_msg_erro        equ     $ - msg_erro

virgula             db      ", "
tam_virgula         equ     $ - virgula

nova_linha          db      10
tam_nova_linha      equ     $ - nova_linha

num_int             db      10
num_int_salvos      db      0
numero_de_pares     db      0
numero_de_impares   db      0
maior_valor         dw      0
menor_valor         dw      999
auxiliar            db      0
soma_total          dw      0
media_total         dw      0

section .bss
; Alocar espaço para variáveis.
valor_atual         resb    4   ; um byte para cada dígito e um byte para o enter.
dez_valores         resw    10  ; uma word (dois bytes) para cada um dos dez inteiros.
opcao               resb    2   ; um byte para o valor da opção e o último para o enter.
resposta            resb    4   ; um byte para cada dígito da resposta e um para o enter.
resto               resb    4
section .text
global _start
_start:
; [IMPRIME: "Digite um valor inteiro: "]
    mov ecx, msg_int
    mov edx, tam_msg_int
    call imprime_mensagem
    
; [RECEBE: Um dos dez inteiros e salva em 'valor_atual'.]
    mov ecx, valor_atual
    mov edx, 4
    call recebe_valor

; [SALVA: O valor digitado em uma posição de 'dez_valores'.]
    call salva_valor_digitado
    
; [VERIFICA: Se já leu os 10 valores.]
    mov al, byte[num_int]
    dec al
    mov byte[num_int], al
    cmp al, 0
    jne _start
    
; [IMPRIME: Todos os valores digitados]
    mov ecx, msg_digitados
    mov edx, tam_msg_digitados
    call imprime_mensagem
    
    call imprime_todos_valores

escolhe_opcao: 
    mov ecx, nova_linha 
    mov edx, tam_nova_linha 
    call imprime_mensagem

; [IMPRIME: "Opções"]   
    mov ecx, msg_opcao
    mov edx, tam_msg_opcao
    call imprime_mensagem

; [RECEBE: Opção]
    mov ecx, opcao
    mov edx, 2          ; 1 byte pro valor da opção (1, 2, 3, 4 ou 5) e 1 byte para o enter.
    call recebe_valor
    
; [VERIFICA: Qual opção foi digitada]
    mov al, byte[opcao]
    cmp al, '1'
    je pares
    cmp al, '2'
    je impares
    cmp al, '3'
    je maior_e_menor
    cmp al, '4'
    je soma
    cmp al, '5'
    je media_de_todos
    
    jmp erro

pares:
; Para saber o número de pares é simples: divide por dois, se não houver resto é par.
    mov ecx, msg_sao_pares
    mov edx, tam_msg_sao_pares
    call imprime_mensagem
    
    mov ebx, 0x0
    mov byte[auxiliar], bl
    
    _pares:
    mov bl, byte[auxiliar]
    
    cmp bl, 20
    je _pares_fim
        
    mov ax, word[dez_valores + ebx]
    add bl, 2
    mov byte[auxiliar], bl
    
    mov edx, 0
    mov ecx, 2
    div ecx         ; divide o eax/ecx -> resto fica edx
    
    cmp edx, 0
    jne _pares      ; pula para outro número porque esse número não é par.
    
    mov al, byte[numero_de_pares]
    inc al
    mov byte[numero_de_pares], al
    
    mov bl, byte[auxiliar]
    sub bl, 2
    mov ax, word[dez_valores + ebx]
    
    call imprime_um_valor
    
    mov ecx, virgula
    mov edx, tam_virgula
    call imprime_mensagem
    
    jmp _pares
    
    _pares_fim:
    mov ecx, msg_num_pares
    mov edx, tam_msg_num_pares
    call imprime_mensagem
    
    mov eax, 0x0
    mov al, byte[numero_de_pares]
    call imprime_um_valor
    
    jmp escolhe_opcao

impares:
; Para saber se é ímpar, divide por dois e se houver resto é ímpar.
    mov ecx, msg_num_impares
    mov edx, tam_msg_num_impares
    call imprime_mensagem
    
    mov ebx, 0x0
    mov byte[auxiliar], bl
    
    _impares:
    mov bl, byte[auxiliar]
    
    cmp bl, 20
    je _impares_fim
        
    mov ax, word[dez_valores + ebx]
    add bl, 2
    mov byte[auxiliar], bl
    
    mov edx, 0
    mov ecx, 2
    div ecx         ; divide o eax/ecx -> resto fica edx
    
    cmp edx, 0
    je _impares     ; pula para outro número porque esse número não é par.
    
    mov al, byte[numero_de_impares]
    inc al
    mov byte[numero_de_impares], al
    
    mov bl, byte[auxiliar]
    sub bl, 2
    mov ax, word[dez_valores + ebx]
    
    call imprime_um_valor
    
    mov ecx, virgula
    mov edx, tam_virgula
    call imprime_mensagem
    
    jmp _impares
    
    _impares_fim:
    mov ecx, msg_num_impares
    mov edx, tam_msg_num_impares
    call imprime_mensagem
    
    mov eax, 0x0
    mov al, byte[numero_de_impares]
    call imprime_um_valor

    jmp escolhe_opcao   

    
maior_e_menor:
; Percorer todos os valores subtraindo cada um deles e armazenando qual é o maior.
    mov ecx, msg_maior_menor
    mov edx, tam_msg_maior_menor
    call imprime_mensagem

    mov ebx, 0x0
    mov byte[auxiliar], bl

     _maior:
;[RECEBE: um valor dos dez_inteiros.]
    mov bl, byte[auxiliar]
    mov ax, word[dez_valores + ebx]        
    
; [COMPARA: cx menos ax, se o resultado der negativo, ax é maior e deve se tornar o maior_valor, senão mantém o maior_valor atual. ]
    mov cx, word[maior_valor]
    cmp cx, ax
    jg cx_maior_que_ax                      ; jg => jump if greater (pula se positivo).

; [DEFINE: ax agora é o maior valor, pois não realizou o jump. ]
    mov word[maior_valor], ax

    cx_maior_que_ax:
; [COMPARA: cx menos ax, se o resultado der positivo, ax é menor e portanto deve se tornar o menor_valor, senão mantém o menor_valor atual. ]
    mov cx, word[menor_valor]
    cmp cx, ax
    jl cx_menor_que_ax                      ; jl => jump if less (pula se menor).

; [DEFINE: ax agora é o menor valor, pois não realizou o jump. ]
    mov word[menor_valor], ax

    cx_menor_que_ax:    
; [VERIFICA: se já percorreu os dez_inteiros]
    mov bl, byte[auxiliar]
    add bl, 2
    mov byte[auxiliar], bl
    cmp bl, 20
    jne _maior

; [IMPRIME: o maior e o menor valor separados por vírgula. ]
    mov eax, 0x0
    mov ax, word[maior_valor]
    call imprime_um_valor

    mov ecx, virgula
    mov edx, tam_virgula
    call imprime_mensagem

    mov ax, word[menor_valor]
    call imprime_um_valor

; [FIM: voltar para a escolha das opções. ]
    jmp escolhe_opcao


soma:
; Simplesmente percorrer os valores e somando cada um deles.
    mov ecx, msg_soma_total         
    mov edx, tam_msg_soma_total
    call imprime_mensagem
 
    mov ebx, 0x0                ; zera registrador ebx
    mov byte[auxiliar], bl     ; move bl que tem 0 agora para byte[somatotal]
    mov word[soma_total], bx

 _soma:
 ;[RECEBE: um valor dos dez_inteiros.]
    mov bl, byte[auxiliar]     ; move pro bl o byte[somatotal] que agora é 0
    mov ax, word[dez_valores + ebx]  ;move primeiro valor pro ax

;[SOMA: o valor recebido dos dez_inteiros com a variável soma_total.]
     mov cx, word[soma_total]    ;move pro registrador cx a word[somatotal]
     add cx, ax                 ;adiciona o primeiro valor que esta em ax ao registrador cx que tem 0
     mov word[soma_total], cx    ; move o valor somado de cx devolta para word[somatotal]
       

; [VERIFICA: se já percorreu os dez_inteiros]
    mov bl, byte[auxiliar]
    add bl, 2
    mov byte[auxiliar], bl
    cmp bl, 20
    jne _soma

; [IMPRIME: a soma total após percorrer todos os valores]
    mov eax, 0x0
    mov ax, word[soma_total];somatotal
    call imprime_um_valor2

; [FIM: voltar para a escolha das opções. ]
    jmp escolhe_opcao
    
media_de_todos:
; Utiliza a 'soma_total' e divide por dez.
    mov ecx, msg_media_todos
    mov edx, tam_msg_media_todos
    call imprime_mensagem

    mov ebx, 0x0                ; zera registrador ebx
    mov byte[auxiliar], bl     ; move bl que tem 0 agora para byte[somatotal]
    mov word[soma_total], bx    ; move bx que tem 0 para word[soma_total]

 _media:
 ;[RECEBE: um valor dos dez_inteiros.]
    mov bl, byte[auxiliar]     ; move pro bl o byte[somatotal] que agora é 0
    mov ax, word[dez_valores + ebx]  ;move primeiro valor pro ax

;[SOMA: o valor recebido dos dez_inteiros com a variável soma_total.]
     mov cx, word[soma_total]    ;move pro registrador cx a word[somatotal]
     add cx, ax                 ;adiciona o primeiro valor que esta em ax ao registrador cx que tem 0
     mov word[soma_total], cx    ; move o valor somado de cx devolta para word[somatotal]
       

; [VERIFICA: se já percorreu os dez_inteiros]
    mov bl, byte[auxiliar]
    add bl, 2
    mov byte[auxiliar], bl
    cmp bl, 20
    jne _media

; [DIVIDE: a soma_total por 10]
    mov edx, 0x0
    mov ecx, 0x0
    mov eax, 0x0
    mov ax, word[soma_total]
    mov ebx, 10
    div bx              ;ax/bx, ou seja, soma_total/10 e o resultado fica em ax
    
;[IMPRIME: a média que está em ax devido a instrução de divisão que salva o resultado de ax]
    call imprime_um_valor

    mov ecx, virgula
    mov edx, tam_virgula
    call imprime_mensagem
    
    mov edx, 0
    mov ecx, 2
    div ecx      

    jmp escolhe_opcao
    
; [ROTINAS]
imprime_mensagem:
; A mensagem e o tamanho da mensagem devem estar em ecx e edx respectivamente.
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret
    
recebe_valor:
; A variável que recebera o que for digitado e o tamanho devem estar em ecx e edx respectivamente.
    mov eax, 3
    mov ebx, 1
    int 0x80
    ret
    
salva_valor_digitado:
    mov ebx, 0x00
    
    mov eax, 0x00    
    mov al, byte[valor_atual]
    sub al, '0'
    imul eax, 100
    
    add ebx, eax
    
    mov eax, 0x00
    mov al, byte[valor_atual + 1]
    sub al, '0'
    imul eax, 10
    
    add ebx, eax
    
    mov eax, 0x00
    mov al, byte[valor_atual + 2]
    sub al, '0'
    
    add ebx, eax
     
    mov eax, 0x0
    mov al, byte[num_int_salvos]
    mov word[dez_valores + eax], bx
    add al, 2
    mov byte[num_int_salvos], al
    
    ret
    
imprime_todos_valores:
    mov ebx, 0x0
    mov eax, 0x0
    mov bl, byte[auxiliar]
    
    mov ax, word[dez_valores + ebx]
    add bl, 2
    mov byte[auxiliar], bl
    call imprime_um_valor
    
    mov ecx, virgula
    mov edx, tam_virgula
    call imprime_mensagem
    
    mov bl, byte[auxiliar]    
    cmp bl, 20
    jne imprime_todos_valores
    
    ret
    
imprime_um_valor:
; O valor a ser impresso deve estar em eax.
 
; [DIVIDE: ax/100]
    mov edx, 0x0		; zera o edx
    mov bl, 100 		; move 100 para bl
    div bl			; divide AX/BL
    add al, '0'			; transforma em hexa
    mov byte[resposta], al	; move para o resultado
    mov bl, ah			; move o resto para bl

; [DIVIDE: ax/10]
    mov eax, 0x0		; zera o eax
    mov al, bl			; move o resto (em bl) para al
    mov bl, 10			; move 10 para bl
    div bl			; divide AL/BL
    add al, '0'			; transforma em hexa	
    mov byte[resposta+1], al	; move para o resultado

; [SOMA: ah é o resto da divisão de ax/10]
    add ah, '0'			; transforma em hexa	
    mov byte[resposta+2], ah	; move para o resultado
    
; [IMPRIME: a variável resposta.]
    mov ecx, resposta
    mov edx, 3
    call imprime_mensagem

    ret

imprime_um_valor2:
; O valor a ser impresso deve estar em eax.

; [DIVIDE: ax/1000]
    mov edx, 0x0        ; zera o edx
    mov bx, 1000         ; move 1000 para bx
    div bx          ; divide AX/BX(o dx está zerado)
    add al, '0'         ; transforma em hexa
    mov byte[resposta], al  ; move para o resultado
    mov ax, dx          ; move o resto para ax

; [DIVIDE: ax/100]
    mov edx, 0x0        ; zera o edx
    mov bl, 100         ; move 100 para bl
    div bl          ; divide AX/BL
    add al, '0'         ; transforma em hexa
    mov byte[resposta+1], al  ; move para o resultado
    mov bl, ah          ; move o resto para bl

; [DIVIDE: ax/10]
    mov eax, 0x0        ; zera o eax
    mov al, bl          ; move o resto (em bl) para al
    mov bl, 10          ; move 10 para bl
    div bl          ; divide AL/BL
    add al, '0'         ; transforma em hexa    
    mov byte[resposta+2], al    ; move para o resultado

; [SOMA: ah é o resto da divisão de ax/10]
    add ah, '0'         ; transforma em hexa    
    mov byte[resposta+3], ah    ; move para o resultado
    
; [IMPRIME: a variável resposta.]
    mov ecx, resposta
    mov edx, 4
    call imprime_mensagem

    ret
    
erro:
; [IMPRIME: "Comando inválido! Fim da execução."]
    mov ecx, msg_erro
    mov edx, tam_msg_erro
    call imprime_mensagem
    
    jmp fim

fim:
    mov ecx, nova_linha
    mov edx, tam_nova_linha
    call imprime_mensagem
    
    mov eax, 1
    int 0x80

