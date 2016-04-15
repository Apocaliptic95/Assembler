.intel_syntax noprefix
.text
.globl zadanie

zadanie: 
		mov edi, offset wynik
		mov esi, edi
		mov ecx, 0b1
		xor dh,dh
		xor dl,dl
		inc dl
		tablica:
			mov eax,ecx
			jmp funkcja
			return:
			mov [edi],dl
			
			xor dl,dl
			inc dl
			inc edi
			inc ecx
			
			cmp ecx,0b10000000000000001
			jnz tablica
		ret

funkcja:
		
		cmp eax,0b1
		je return
		cmp dl,0b11111111
		je return
		
		bt eax,0b0
		jc npar
		par:
			inc dl
			sar eax
			cmp ecx,eax
			jle ety1
				mov dh,[esi+eax-0b1]
				add dl,dh
				jnc ety2
					mov dl,0b11111111
					jmp return
				ety2:
				dec dl
				jmp return
			ety1:
			jmp funkcja
			
		npar:		
			inc dl
			mov ebx,eax
			sal eax
			add eax,ebx
			inc eax
			jmp funkcja