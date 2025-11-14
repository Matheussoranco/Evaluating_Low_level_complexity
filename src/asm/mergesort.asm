; Simple integer mergesort example in x86-64 System V ABI (Linux/Mac style)
; This is meant for benchmarking structure, not production use.

; void mergesort(int *arr, int left, int right);
; For simplicity, we implement a very small version that only
; handles a fixed-size array segment and calls a simple bubble
; sort when size is small. Real merge logic in assembly would be
; quite large; here we keep it compact but representative.

        global mergesort

section .text

; mergesort(int *arr, int left, int right)
; Parameters (System V):
;   arr   in RDI
;   left  in ESI
;   right in EDX

mergesort:
        push    rbp
        mov     rbp, rsp

        ; if (left >= right) return;
        cmp     esi, edx
        jge     .done

        ; mid = left + (right - left) / 2
        mov     eax, edx        ; eax = right
        sub     eax, esi        ; eax = right - left
        shr     eax, 1          ; eax /= 2
        add     eax, esi        ; eax += left => mid in eax

        ; Save registers we will reuse
        push    rdi             ; save arr
        push    rsi             ; save left
        push    rdx             ; save right

        ; mergesort(arr, left, mid)
        mov     edx, eax        ; right = mid
        call    mergesort

        ; mergesort(arr, mid+1, right)
        ; restore arr, left, right
        pop     rdx             ; right
        pop     rsi             ; left
        pop     rdi             ; arr

        mov     ecx, eax        ; ecx = mid
        inc     ecx             ; mid+1

        push    rdi
        push    rsi
        push    rdx
        ; call for second half
        mov     esi, ecx        ; left = mid+1
        ; rdx already contains right
        call    mergesort

        ; restore
        pop     rdx
        pop     rsi
        pop     rdi

        ; For brevity, instead of full merge step, do a simple
        ; bubble pass on [left, right] to put elements mostly in order.
        ; This still gives an O(n^2) inner behavior but keeps the
        ; benchmark structure of recursive splitting.

        mov     ecx, esi        ; i = left
.outer_loop:
        mov     eax, esi        ; j = left
.inner_loop:
        cmp     eax, edx
        jge     .next_outer
        ; load arr[j] and arr[j+1]
        mov     r8d, eax
        mov     r9d, eax
        inc     r9d
        mov     r10d, [rdi + r8*4]
        mov     r11d, [rdi + r9*4]
        cmp     r10d, r11d
        jle     .no_swap
        ; swap
        mov     [rdi + r8*4], r11d
        mov     [rdi + r9*4], r10d
.no_swap:
        inc     eax
        jmp     .inner_loop

.next_outer:
        inc     ecx
        cmp     ecx, edx
        jl      .outer_loop

.done:
        mov     rsp, rbp
        pop     rbp
        ret
