.intel_syntax noprefix
.text
.globl _start

_start:
	call test_parameters
	call save_parameters
	call test_expression
	call show_expression
	call show_enter
	call find_max_bracket
	call show_bracket_msg
	call print_max_brackets_expressions
	call show_enter

	mov eax,1
	mov ebx,0
	int 0x80

show_bracket_msg:
	push eax
	push ebx
	push ecx
	push edx

	mov eax,4
	mov ebx,1
	mov ecx, offset brackets_show_msg
	mov edx, offset brackets_show_msg_len
	int 0x80

	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

show_expression:
	push eax
	push ebx
	push ecx
	push edx

	mov eax,4
	mov ebx,1
	mov ecx, offset expression_msg 
	mov edx, offset expression_msg_len
	int 0x80

	mov eax, offset wsk_string
	mov ebx, offset string_len
	push ebx
	push eax
	call print_string
	add esp,8

	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

print_max_brackets_expressions:
	push eax
	push ebx
	push ecx
	push edx
	push edi
	push esi

	mov eax,offset wsk_string
	mov eax,[eax]
	mov ebx,0
	mov ecx,offset string_len
	mov ecx,[ecx]
	mov edi,offset max_bracket
	mov edi,[edi]
	
	pmbe_loop:
		mov dl,[eax]	
		cmp dl,40
		je pmbe_left_bracket
		cmp dl,41
		je pmbe_right_bracket
		jmp end_pmbe_loop
		
		pmbe_left_bracket:
			inc ebx
			cmp edi,ebx
			jne end_pmbe_loop
				mov esi,offset temp_string
				mov [esi],eax
				push edi
				mov edi,1
				br_end_lf:
					inc edi
					inc eax
					mov dl,[eax]
					cmp dl,41
					jne br_end_lf
					dec ebx
					push eax
						mov eax,offset temp_string_len
						mov [eax],edi
					
					pop eax
					push eax
					push ebx
						mov eax, offset temp_string
						mov ebx, offset temp_string_len
						push ebx
						push eax
						call print_string
						add esp,8
					pop ebx
					pop eax
					call show_space
				pop edi
			jmp end_pmbe_loop
		
		pmbe_right_bracket:
			dec ebx
			jmp end_pmbe_loop

		end_pmbe_loop:
		inc eax
		loop pmbe_loop

	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

find_max_bracket:
	push eax
	push ebx
	push ecx
	push edx
	push edi

	mov eax,offset wsk_string
	mov eax,[eax]
	mov ebx,0
	mov edi,0
	mov ecx,offset string_len
	mov ecx,[ecx]
	
	fmb_loop:
		mov dl,[eax]	
		cmp dl,40
		je fmb_left_bracket
		cmp dl,41
		je fmb_right_bracket
		jmp end_fmb_loop
		
		fmb_left_bracket:
			inc ebx
			cmp edi,ebx
			jge end_fmb_loop
			mov edi,ebx
			jmp end_fmb_loop
		
		fmb_right_bracket:
			dec ebx
			jmp end_fmb_loop

		end_fmb_loop:
		inc eax
		loop fmb_loop

	mov eax, offset max_bracket
	mov [eax],edi

	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

test_expression:
	push eax
	push ebx
	push ecx
	push edx

	mov eax,offset wsk_string
	mov eax,[eax]
	mov ebx,0
	mov ecx,offset string_len
	mov ecx,[ecx]
	
	te_loop:
		mov dl,[eax]	
		cmp dl,40
		je te_left_bracket
		cmp dl,41
		je te_right_bracket
		jmp end_te_loop
		
		te_left_bracket:
			inc ebx
			jmp end_te_loop
		
		te_right_bracket:
			dec ebx
			jmp end_te_loop

		end_te_loop:
		inc eax
		loop te_loop

	cmp ebx,0
	jne expression_error

	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

print_string:
	push eax
	push ebx
	push ecx
	push edx

	mov eax,4
	mov ebx,1
	mov ecx,[esp + 20]
	mov ecx,[ecx]
	mov edx,[esp + 24]
	mov edx,[edx]
	int 0x80

	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

test_parameters:
	push eax
	push ebx
	push ecx
	push edx

	mov eax,[esp + 20]
	cmp eax,2
	jne param_error

	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

save_parameters:
	push eax
	push ebx
	push ecx
	push edx

	mov eax, offset wsk_string
	mov ebx, [esp + 28]
	mov [eax], ebx

	mov eax, offset wsk_envir_var
	mov ebx, [esp + 36]
	mov [eax], ebx

	call find_string_len
	
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

find_string_len:
	push eax
	push ebx
	push ecx
	push edx

	mov eax,offset wsk_string
	mov eax,[eax]
	mov edx,offset wsk_envir_var
	mov edx,[edx]
	sub edx,eax
	mov eax, offset string_len
	mov [eax], edx

	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

param_error:
	mov eax,4
	mov ebx,1
	mov ecx,offset param_error_msg
	mov edx,offset param_error_msg_len
	int 0x80

	mov eax,1
	mov ebx,0
	int 0x80

expression_error:
	mov eax,4
	mov ebx,1
	mov ecx,offset express_error_msg
	mov edx,offset express_error_msg_len
	int 0x80

	mov eax,1
	mov ebx,0
	int 0x80

show_space:
	push eax
	push ebx
	push ecx
	push edx

	mov eax,4
	mov ebx,1
	mov ecx,offset space
	mov edx,1
	int 0x80

	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

show_enter:
	push eax
	push ebx
	push ecx
	push edx

	mov eax,4
	mov ebx,1
	mov ecx,offset enter
	mov edx,1
	int 0x80

	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

.data
	wsk_string: .long 0
	wsk_envir_var: .long 0
	string_len: .long 0
	max_bracket: .long 0
	temp_string: .long 0
	temp_string_len: .long 0
	space: .ascii " "
	enter: .ascii "\n"
	param_error_msg: .ascii "Nieprawidlowa liczba parametrow!\n"
		.equ param_error_msg_len, $-param_error_msg

	expression_msg: .ascii "Podane wyrazenie: "
		.equ expression_msg_len, $-expression_msg

	express_error_msg: .ascii "Nieprawidlowe wyrazenie!\n"
		.equ express_error_msg_len, $-express_error_msg

	brackets_show_msg: .ascii "Najglebsze nawiasy: "
		.equ brackets_show_msg_len, $-brackets_show_msg