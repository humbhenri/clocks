        format ELF64
        STDOUT = 1
        STDERR = 2
        SDL_RENDERER_ACCELERATED = 0x00000002
        SDL_RENDERER_PRESENTVSYNC = 0x00000004
        SDL_QUIT = 0x100
        
        extrn SDL_Init
        extrn SDL_CreateWindow
        extrn SDL_DestroyWindow
        extrn SDL_Quit
        extrn SDL_Delay
        extrn SDL_SetHint
        extrn SDL_CreateRenderer
        extrn SDL_GetWindowSurface
        extrn SDL_PollEvent

        section '.data'
        title db 'SDL2 Window', 0
        error_msg db 'ERROR!', 0
        error_msg_len = $ - error_msg
        sdlhint db '1', 0
        window_ptr dd 0
        renderer_ptr dd 0
        surface_ptr dd 0
        sdl_event dq 0

        section '.text' writeable executable
        public _start

        macro write fd, buf, count
        {
        mov rax, 1
        mov rdi, fd
        mov rsi, buf
        mov rdx, count
        syscall
        }

        macro exit code
        {
        mov rax, 60
        mov rdi, code
        syscall
        }

_start:
                                ; Initialize SDL2 (SDL_Init(SDL_INIT_VIDEO))
        mov rdi, 0x00000020       ; SDL_INIT_VIDEO flag
        call SDL_Init
        cmp rax, 0
        jl error

        mov rdi, sdlhint
        call SDL_SetHint
        cmp rax, 0
        jl error
        
        mov rdi, title            ; Window title
        mov rsi, 100              ; x position
        mov rdx, 100              ; y position
        mov rcx, 800              ; width
        mov r8, 600               ; height
        mov r9, 0x00000004        ; SDL_WINDOW_SHOWN flag
        call SDL_CreateWindow
        cmp rax, 0
        jl error
        mov dword [window_ptr], eax                ; Save the window pointer

        ;; create renderer
        mov rdi, rbx
        mov rsi, -1
        mov rdx, SDL_RENDERER_ACCELERATED
        or rdx, SDL_RENDERER_PRESENTVSYNC
        call SDL_CreateRenderer
        cmp rax, 0
        jl error
        mov dword [renderer_ptr], eax

        ;; create surface
        mov edi, dword [window_ptr]
        call SDL_GetWindowSurface
        cmp rax, 0
        jl error
        mov dword [surface_ptr], eax

render_loop:
        lea rdi, [sdl_event]        ; Load address of event struct into rdi
        call SDL_PollEvent
        cmp rax, 0
        jz no_event
        cmp dword [sdl_event], SDL_QUIT
        je quit

        ;; mov rdi, 3000
        ;; call SDL_Delay
        
no_event:
                                ; Delay to limit CPU usage (SDL_Delay(16) ~ 60 FPS)
        mov rdi, 16 
        call SDL_Delay

                                ; Continue the loop
        jmp render_loop

quit:
        mov edi, dword [window_ptr]
        call SDL_DestroyWindow
        call SDL_Quit
        exit 0

error:
        write STDERR, error_msg, error_msg_len
        exit 1
