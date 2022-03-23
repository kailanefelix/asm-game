org 0x7e00
jmp 0x0000:start

;Textos menu
titulo      db 'Duolingo da Olivia Rodrigo', 0
coracao     db 3, 0
jogar       db 'Jogar (1)', 0
instrucoes  db 'Tutorial (2)', 0
grupo       db 'Grupo (3)', 0

; menu musicas:
titulo2      db 'Escolha sua musica preferida', 0
musica1      db 'Good 4 U (1)', 0
musica2      db 'Deja vu (2)', 0
musica3      db 'Drivers License (3)', 0
esc          db 'Pressione ESC para voltar ao menu inicial :)', 0


;instrucoes
instrucao1 db 'Quer aprender ingles e nao cansa de ouvir SOUR?', 0
instrucao2 db 'Tente traduzir os trechos das musicas da princesa do pop', 0
instrucao3 db 'Para cada caractere errado, voce perde pontos', 0
instrucao4 db 'Atencao no tempo!', 0
instrucao5 db 'Pressione ESC para voltar ao menu inicial :)', 0

;grupo
nome1 db 'Kailane Felix', 0
nome2 db 'Luisa Mendes', 0
nome3 db 'Camila Xavier', 0
escgrupo db 'Pressione ESC para voltar ao menu inicial :)', 0

; trechos em ingles
texto1 db 'Well, good for you, you look happy and healthy,', 0
texto11 db 'not me, if you ever cared to ask', 0
texto2 db 'I made the jokes you tell to her when shes with you.', 0
texto22 db 'Do you get deja vu?', 0
texto3 db 'Cause you said forever, now I drive alone past your street', 0


; traduçoes
trad1 db 'Bem, bom pra voce, voce parece feliz e saudavel, eu nao, nao que voce se importasse em perguntar', 0
trad2 db 'Eu fiz as piadas que voce conta pra ela quando ela esta com voce. Voce tem deja vu?', 0
trad3 db 'Porque voce disse que seria pra sempre, agora eu dirijo sozinha pela sua rua', 0
points dw 0



pontuacao db '  Sua pontuacao  ', 0
score2 db 'Tente de novo, aprender ingles as vezes pode ser brutal...', 0
score4 db 'Ok! Good for you...', 0
score3 db 'Muito bom! I hope you are happy :)', 0
score5 db 'Uau! Voce foi incrivel. jealousy, jealousy', 0
score6 db 'Pressione ESC para voltar :)', 0


print_string:
    lodsb
    mov ah, 0xe
    mov bh, 0
    mov bl, 0xf
    int 10h

    cmp al, 0
    jne print_string
    ret

print_score:

    push 12 ;
    mov cl, 10 ; 10 como divisor

    mov ah, 02h ; cursor
    mov bh, 0   ; pagina
    mov dl, 38
    mov dh, 5
    int 10h


    mov ax, word [points]
    push_stack:
    div cl ;
    add ah, 48 ; transforma em caracter
    push ax ; manda pra pilha
    xor ah,ah ; limpa ah
    cmp al, 0 ; acabou
    je pop_stack
    jmp push_stack

    pop_stack:
    pop ax
    cmp ax, 12
    je flag_volta
	mov al, ah

    mov ah, 0eh ; setar o cursor
    mov bh, 0   ; pagina
    int 10h

    jmp pop_stack


input:
    push dx     ; salva o que tem em dh e dl

    mov ah, 02h
    int 1aH     ; interrupcao que lida com o tempo do sistema

    cmp dh, 30
    jge score

    pop dx

    lodsb   ; si para al
    cmp al, 0
    je score

    mov cl , al ; guardando

    mov ah, 0   ;  ah para a chamada do input
    int 16h     ; interrupcao para ler o caractere e armazenar em al

    cmp al, 8
    je backspace

    cmp al, cl ; compara o caracter do texto salvo e o caracter inserido

    je verde
    jne vermelho

seta_cursor:
    cmp dl, 69
    je controle_direita
    retorno_c_d:
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    inc dl
    int 10h
    cmp bl, 2
    je aqui_verde
    jmp aqui_vermelho

    controle_direita:
    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dl, 20
    inc dh
    int 10h
    jmp retorno_c_d


printa_char:
    mov cx, 1
    mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
    mov bh, 0   ; seta a pagina
    int 10h
    cmp bl, 2
    je  printa_verde
    jmp printa_vermelho

backspace:
    cmp dl, 20
    je controle_esquerda

    printa_espaco:
        mov al, ' '
        mov cx, 1
        mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
        mov bh, 0   ; seta a pagina
        mov bl, 15  ; seta a cor do caractere
        int 10h

        dec dl
        mov ah, 02h ; setar o cursor
        mov bh, 0   ; pagina
        int 10h

        dec si
        dec si

        jmp input

    controle_esquerda:
        cmp dh, 5
        je input

        mov al, ' '
        mov cx, 1
        mov ah, 09h ; codigo para printar caractere apenas onde esta o cursor
        mov bh, 0   ; seta a pagina
        mov bl, 15  ; seta a cor do caractere como branco
        int 10h

        dec si

        dec dh
        mov dl, 60
        mov ah, 02h ; setar o cursor
        mov bh, 0   ; pagina
        int 10h

        jmp input

    verde:
        mov bl, 2  ; seta a cor do caractere como verde
        jmp seta_cursor
        aqui_verde:
        jmp printa_char
        printa_verde:
        inc word [points]
        jmp input

    vermelho:
        mov bl, 4  ; seta a cor do caractere como vermelho
        jmp seta_cursor
        aqui_vermelho:
        jmp printa_char
        printa_vermelho:
        cmp word [points], 0
        je input
        dec word [points]
        jmp input

;fim das funçoes do jogo
;Inicio do programa
start:
    ;Zerando os registradores
    mov ax, 0
    mov ds, ax

    ;Chamando a função Menu
    call Menu

    jmp done

Menu:


    mov ah, 0
    mov al,12h ; iniciando o video
    int 10h

    ; Mudando a cor do fundo para lilas
    mov ah, 0bh
    mov bh, 0
    mov bl, 1101
    int 10h

    ;Colocando o Titulo
	mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 3    ;x
	mov dl, 20   ;y
	int 10h
    mov si, titulo
    call print_string

    mov si, coracao
    call print_string

    ;Colocando a string jogar
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 10   ;x
	mov dl, 20   ;y
	int 10h

    mov si, coracao
    call print_string

    mov si, jogar
    call print_string



    ;Colocando a string intrucoes
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 15   ;x
	mov dl, 20  ;y
	int 10h

    mov si, coracao
    call print_string

    mov si, instrucoes
    call print_string

    ;Colocando a string grupo
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 20   ;x
	mov dl, 20   ;y
	int 10h

    mov si, coracao
    call print_string
    mov si, grupo
    call print_string


    selecao:
        ;Receber a opção
        mov ah, 0
        int 16h

        ;Comparando com '1'
        cmp al, 49
        je jogar_

        ;Comparando com '2'
        cmp al, 50
        je instrucao

        ;Comparando com '3'
        cmp al, 51
        je credito

        ;Caso não seja nem '1' ou '2' ou '3' ele vai receber a string dnv
        jne selecao

jogar_:
    mov ax, 0
    mov ds, ax

    call musicas

    jmp done

musicas:
 ;iniciando o video
    mov ah, 0
    mov al,12h
    int 10h

    ;Mudando a cor do background para lilas
    mov ah, 0bh
    mov bh, 0
    mov bl, 1101
    int 10h

    ;Colocando o Titulo
	mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 3    ;x
	mov dl, 20   ;y
	int 10h
    mov si, titulo2
    call print_string

    ;Colocando a string jogar
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 10   ;x
	mov dl, 20   ;y
	int 10h

    mov si, coracao
    call print_string

    mov si, musica1
    call print_string

    ;Colocando a string intrucoes
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 15   ;x
	mov dl, 20   ;y
	int 10h

    mov si, coracao
    call print_string

    mov si, musica2
    call print_string

    ;Colocando a string grupo
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 20   ;x
	mov dl, 20   ;y
	int 10h

    mov si, coracao
    call print_string

    mov si, musica3
    call print_string


    ;Colocando a string instrucao5
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 25   ;x
	mov dl, 20   ;y
	int 10h
    mov si, esc
    call print_string

    ;Selecionar a opcao do usuario
    selecao2:
        ;Receber a opção
        mov ah, 0
        int 16h

        ;Comparando com '1'
        cmp al, 49
        je musica_1

        ;Comparando com '2'
        cmp al, 50
        je musica_2

        ;Comparando com '3'
        cmp al, 51
        je musica_3

        cmp al, 27
	    je Menu

        ;Caso não seja nem '1' ou '2' ou '3' ele vai receber a string dnv
        jne selecao2

musica_1:
    mov si, points
    mov [si], byte 0

    mov ah, 03h ; escolhe a funcao de ler o tempo do sistema
    mov ch, 0   ; horas
    mov cl, 0   ; minutos
    mov dh, 0   ; segundos
    mov dl, 1
    int 1aH     ; interrupcao que lida com o tempo do sistema

    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ah, 0   ; escolhe o modo do video
    mov al, 12h ; modo VGA
    int 10h     ; interrupcao de tela

    mov ah, 0bh  ; chamada para mudar a cor do background
    mov bh, 0    ; seta a pagina do video, 0
    mov bl, 1101 ; cor designada ao background
    int 10h

    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 3   ; valor y
    mov dl, 10  ; valor x
    int 10h

    mov si, texto1
    call print_string

    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 4   ; valor y
    mov dl, 11  ; valor x
    int 10h
    mov si, texto11
    call print_string


    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 13   ; valor y
    mov dl, 10  ; valor x
    int 10h

    mov si, trad1

    jmp input

musica_2:
    mov si, points
    mov [si], byte 0

    mov ah, 03h ; escolhe a funcao de ler o tempo do sistema
    mov ch, 0   ; horas
    mov cl, 0   ; minutos
    mov dh, 0   ; segundos
    mov dl, 1   ; seta o modo entre dia e noite do relogio do sistema(1 para dia)
    int 1aH     ; interrupcao que lida com o tempo do sistema

    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ah, 0   ; escolhe o modo do video
    mov al, 12h ; modo VGA
    int 10h     ; interrupcao de tela

    mov ah, 0bh  ; chamada para mudar a cor do background
    mov bh, 0    ; seta a pagina do video, nesse caso como so existe uma, eh 0
    mov bl, 1101    ; cor designada ao background
    int 10h

    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 3   ; valor y
    mov dl, 10  ; valor x
    int 10h

    mov si, texto2
    call print_string

    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 4   ; valor y
    mov dl, 11  ; valor x
    int 10h
    mov si, texto22
    call print_string



    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 13   ; valor y
    mov dl, 10  ; valor x
    int 10h

    mov si, trad2

    jmp input

musica_3:
    mov si, points
    mov [si], byte 0

    mov ah, 03h ; escolhe a funcao de ler o tempo do sistema
    mov ch, 0   ; horas
    mov cl, 0   ; minutos
    mov dh, 0   ; segundos
    mov dl, 1   ; seta o modo entre dia e noite do relogio do sistema(1 para dia)
    int 1aH     ; interrupcao que lida com o tempo do sistema

    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ah, 0   ; escolhe o modo do video
    mov al, 12h ; modo VGA
    int 10h     ; interrupcao de tela

    mov ah, 0bh  ; chamada para mudar a cor do background
    mov bh, 0    ; seta a pagina do video, nesse caso como so existe uma, eh 0
    mov bl, 1101    ; cor designada ao background
    int 10h

    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 3   ; valor y
    mov dl, 10  ; valor x
    int 10h

    mov si, texto3
    call print_string


    mov ah, 02h ; setar o cursor
    mov bh, 0   ; pagina
    mov dh, 13   ; valor y
    mov dl, 10  ; valor x
    int 10h

    mov si, trad3

    jmp input


instrucao:
    ;iniciando o video para limpar a tela
    mov ah, 0
    mov al,12h
    int 10h

    ;Mudando a cor do background para lilas
    mov ah, 0bh
    mov bh, 0
    mov bl, 1101
    int 10h

    ;Colocando o titulo
	mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 3    ;x
	mov dl, 29   ;y
	int 10h
    mov si, instrucoes
    call print_string

    ;Colocando a string instrucao1
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 7    ;x
	mov dl, 10   ;y
	int 10h
    mov si, instrucao1
    call print_string

    ;Colocando a string instrucao2
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 9    ;x
	mov dl, 10   ;y
	int 10h
    mov si, instrucao2
    call print_string

    ;Colocando a string instrucao3
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 11   ;x
	mov dl, 10   ;y
	int 10h
    mov si, instrucao3
    call print_string

    ;Colocando a string instrucao4
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 13   ;x
	mov dl, 10   ;y
	int 10h
    mov si, instrucao4
    call print_string

    ;Colocando a string instrucao5
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 20   ;x
	mov dl, 10   ;y
	int 10h
    mov si, instrucao5
    call print_string

esc_instrucao:
    ;Para receber o caractere
    mov ah, 0
    int 16h

    ;Apos receber 'Esc' volta pro menu
    cmp al, 27
	je Menu
	jne esc_instrucao


credito:
    ;iniciando o video para limpar a tela
    mov ah, 0
    mov al,12h
    int 10h

    ;Mudando a cor do background para lilas
    mov ah, 0bh
    mov bh, 0
    mov bl, 1101
    int 10h

    ;Colocando o titulo
	mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 3    ;x
	mov dl, 29   ;y
	int 10h
    mov si, grupo
    call print_string

    ;Colocando a string nome1
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 7    ;x
	mov dl, 10   ;y
	int 10h
    mov si, nome1
    call print_string

    ;Colocando a string nome2
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 9    ;x
	mov dl, 10   ;y
	int 10h
    mov si, nome2
    call print_string

    ;Colocando a string nome3
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 11   ;x
	mov dl, 10   ;y
	int 10h
    mov si, nome3
    call print_string

	;Colocando a string escgrupo
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 20   ;x
	mov dl, 10   ;y
	int 10h
    mov si, escgrupo
    call print_string

    mov ah, 0
    int 16h

    ;Apos receber 'Esc' volta pro menu
    cmp al, 27
	je Menu

score:
   ;iniciando o video para limpar a tela
    mov ah, 0
    mov al,12h
    int 10h

    ;Mudando a cor do background para lilas
    mov ah, 0bh
    mov bh, 0
    mov bl, 1101
    int 10h

    ;Colocando o Titulo
    mov ah, 02h  ;Setando o cursor
    mov bh, 0    ;Pagina 0
    mov dh, 3    ;x
    mov dl, 33   ;y
    int 10h
    mov si, pontuacao
    call print_string

    call print_score

    flag_volta:
        cmp word [points], 30
        jle ruim
        cmp word [points], 60
        jle medio
        cmp word [points], 73
        jle bom
        jg otimo

otimo:
    ;Colocando o score
    mov ah, 02h  ;Setando o cursor
    mov bh, 0    ;Pagina 0
    mov dh, 12    ;x
    mov dl, 15   ;y
    int 10h
    mov si, score5
    call print_string
jmp esc_score

medio:
    ;Colocando o score
    mov ah, 02h  ;Setando o cursor
    mov bh, 0    ;Pagina 0
    mov dh, 12    ;x
    mov dl, 15   ;y
    int 10h
    mov si, score4
    call print_string
jmp esc_score



ruim:
    ;Colocando o score
    mov ah, 02h  ;Setando o cursor
    mov bh, 0    ;Pagina 0
    mov dh, 12    ;x
    mov dl, 15   ;y
    int 10h
    mov si, score2
    call print_string
jmp esc_score

bom:
    ;Colocando o score
    mov ah, 02h  ;Setando o cursor
    mov bh, 0    ;Pagina 0
    mov dh, 12    ;x
    mov dl, 15   ;y
    int 10h
    mov si, score3
    call print_string

esc_score:
    ;Colocando a string score6
    mov ah, 02h  ;Setando o cursor
	mov bh, 0    ;Pagina 0
	mov dh, 20   ;x
	mov dl, 10   ;y
	int 10h
    mov si, score6
    call print_string

    ;Para receber o caractere
    mov ah, 0
    int 16h

    ;Apos receber 'Esc' volta pro menu
    cmp al, 27
    je Menu
    jne esc_score


done:
    jmp $