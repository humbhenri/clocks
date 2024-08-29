        format ELF64    
        extrn SDL_Init
        extrn SDL_CreateWindow
        extrn SDL_DestroyWindow
        extrn SDL_Quit
        extrn SDL_Delay

        section '.data'
        title db 'SDL2 Window', 0   ; Window title string

        section '.text' writeable executable
        public _start

_start:
                                ; Initialize SDL2 (SDL_Init(SDL_INIT_VIDEO))
        mov rdi, 0x00000020       ; SDL_INIT_VIDEO flag
        call SDL_Init

                                ; Create SDL2 window (SDL_CreateWindow)
        mov rdi, title            ; Window title
        mov rsi, 100              ; x position
        mov rdx, 100              ; y position
        mov rcx, 640              ; width
        mov r8, 480               ; height
        mov r9, 0x00000004        ; SDL_WINDOW_SHOWN flag
        call SDL_CreateWindow
        mov rbx, rax              ; Save the window pointer

                                ; Wait for 3 seconds (3000 ms) (SDL_Delay)
        mov rdi, 3000
        call SDL_Delay

                                ; Destroy the window (SDL_DestroyWindow)
        mov rdi, rbx
        call SDL_DestroyWindow

                                ; Quit SDL2 (SDL_Quit)
        call SDL_Quit

                                ; Exit the program (syscall: exit)
        mov rax, 60               ; syscall: exit
        xor rdi, rdi              ; status: 0
        syscall                   ; make the syscall
