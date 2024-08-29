        format ELF64
        STDOUT = 1
        STDERR = 2
        SDL_RENDERER_ACCELERATED = 0x00000002
        SDL_RENDERER_PRESENTVSYNC = 0x00000004
        SDL_QUIT = 0x100
        SCREEN_WIDTH = 1024
        SCREEN_HEIGHT = 1024
        CENTER_X = 512
        CENTER_Y = 512
        CLOCK_RADIUS = 200
        SDL_WINDOWPOS_CENTERED = 0x2FFF0000
        
        extrn SDL_Init
        extrn SDL_CreateWindow
        extrn SDL_DestroyWindow
        extrn SDL_Quit
        extrn SDL_Delay
        extrn SDL_SetHint
        extrn SDL_CreateRenderer
        extrn SDL_GetWindowSurface
        extrn SDL_PollEvent
        extrn SDL_SetRenderDrawColor
        extrn SDL_RenderClear
        extrn SDL_RenderPresent
        extrn SDL_DestroyRenderer
        extrn SDL_RenderDrawPoint

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

        macro draw_point x, y
        {
        mov edi, dword [renderer_ptr]
        mov rsi, x
        mov rdx, y
        call SDL_RenderDrawPoint
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
        mov rsi, SDL_WINDOWPOS_CENTERED              ; x position
        mov rdx, SDL_WINDOWPOS_CENTERED              ; y position
        mov rcx, SCREEN_WIDTH              ; width
        mov r8, SCREEN_HEIGHT               ; height
        mov r9, 0x00000004        ; SDL_WINDOW_SHOWN flag
        call SDL_CreateWindow
        cmp rax, 0
        jl error
        mov dword [window_ptr], eax                ; Save the window pointer

        ;; create renderer
        mov edi, dword [window_ptr]
        mov rsi, -1
        mov rdx, SDL_RENDERER_ACCELERATED
        or rdx, SDL_RENDERER_PRESENTVSYNC
        call SDL_CreateRenderer
        cmp rax, 0
        jl error
        mov dword [renderer_ptr], eax

render_loop:
        lea rdi, [sdl_event]        ; Load address of event struct into rdi
        call SDL_PollEvent
        cmp rax, 0
        jz no_event
        cmp dword [sdl_event], SDL_QUIT
        je quit
        
no_event:
        mov edi, dword [renderer_ptr]
        mov rsi, 0xFF
        mov rdx, 0xFF
        mov rcx, 0xFF
        mov r8d, 255
        call SDL_SetRenderDrawColor
        mov edi, dword [renderer_ptr]
        call SDL_RenderClear

        ;; present the renderer
        mov edi, dword [renderer_ptr]
        call SDL_RenderPresent 
        
        mov rdi, 16             ; FPS = 60
        call SDL_Delay

                                ; Continue the loop
        jmp render_loop

quit:
        mov edi, dword [renderer_ptr]
        call SDL_DestroyRenderer 
        mov edi, dword [window_ptr]
        call SDL_DestroyWindow
        call SDL_Quit
        exit 0

error:
        write STDERR, error_msg, error_msg_len
        exit 1

