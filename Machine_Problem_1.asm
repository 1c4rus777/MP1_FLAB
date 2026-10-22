; Machine Problem 1 - Zodiac Horoscope and Fortune Teller
; NASM x86 32-bit Linux, int 0x80
BITS 32
global _start
section .data
welcome db 10,'=======================================',10,'       THE MYSTIC ZODIAC ORACLE',10,'=======================================',10,'           *         *',10,'        *      /\      *',10,'              /  \',10,'        *    /____\    *',10,'             |    |',10,'         *   |____|  *',10,'       DISCOVER YOUR DESTINY!',10,'=======================================',10,0
askname db 'Enter your name: ',0
askmonth db 'Enter birth month (1-12): ',0
askday db 'Enter birth day (1-31): ',0
invalidmonth db 'Invalid month. Enter a number from 1 to 12.',10,0
invalidday db 'Invalid date for that month. Try again.',10,0
invalidname db 'Name cannot be empty. Try again.',10,0
hello db 10,'Welcome, ',0
bang db '!',10,0
zhead db 10,'=======================================',10,'         YOUR ZODIAC SIGN',10,'=======================================',10,0
slabel db 'Zodiac Sign: ',0
elabel db 'Element: ',0
sylabel db 'Symbol: ',0
plabel db 'Personality: ',0
nl db 10,0
menu db 10,'========== HOROSCOPE MENU ==========',10,'[1] Love and Relationships',10,'[2] Career and Studies',10,'[3] Health and Wellness',10,'[4] Lucky Number and Color',10,'[5] View Zodiac Information',10,'[6] Exit',10,'Enter your choice: ',0
badmenu db 'Invalid selection. Please choose 1-6.',10,0
returnprompt db 10,'Return to menu? (Y/N): ',0
badreturn db 'Please enter Y or N.',10,0
goodbye db 10,'Thank you for visiting the Mystic Zodiac Oracle!',10,0
lovehead db 10,'--- LOVE AND RELATIONSHIPS ---',10,0
careerhead db 10,'--- CAREER AND STUDIES ---',10,0
healthhead db 10,'--- HEALTH AND WELLNESS ---',10,0
luckyhead db 10,'--- LUCKY NUMBER AND COLOR ---',10,0
predictionprefix db ', your stars suggest: ',0
love1 db 'A thoughtful conversation may bring you closer to someone.',10,0
love2 db 'An unexpected kindness may brighten your relationships.',10,0
love3 db 'Honesty and patience will help your connections grow.',10,0
career1 db 'Your creativity can help solve a difficult problem today.',10,0
career2 db 'Focus on one goal and steady progress will follow.',10,0
career3 db 'Working with others may reveal a promising opportunity.',10,0
health1 db 'Take time to rest and recharge your energy.',10,0
health2 db 'A peaceful routine may help you feel refreshed.',10,0
health3 db 'Balance your responsibilities with moments of relaxation.',10,0
lucknum db 'Lucky Number: ',0
luckcolor db 'Lucky Color: ',0
num_end db 10,0
; Signs indexed 0..11: Aries through Pisces
aries db 'ARIES',0
taurus db 'TAURUS',0
gemini db 'GEMINI',0
cancer db 'CANCER',0
leo db 'LEO',0
virgo db 'VIRGO',0
libra db 'LIBRA',0
scorpio db 'SCORPIO',0
sagittarius db 'SAGITTARIUS',0
capricorn db 'CAPRICORN',0
aquarius db 'AQUARIUS',0
pisces db 'PISCES',0
signs dd aries,taurus,gemini,cancer,leo,virgo,libra,scorpio,sagittarius,capricorn,aquarius,pisces
fire db 'Fire',0
earth db 'Earth',0
air db 'Air',0
water db 'Water',0
elements dd fire,earth,air,water,fire,earth,air,water,fire,earth,air,water
ram db 'Ram',0
bull db 'Bull',0
twins db 'Twins',0
crab db 'Crab',0
lion db 'Lion',0
maiden db 'Maiden',0
scales db 'Scales',0
scorpion db 'Scorpion',0
archer db 'Archer',0
goat db 'Sea-Goat',0
waterbearer db 'Water Bearer',0
fish db 'Fish',0
symbols dd ram,bull,twins,crab,lion,maiden,scales,scorpion,archer,goat,waterbearer,fish
p0 db 'Bold, energetic, determined.',10,0
p1 db 'Patient, loyal, dependable.',10,0
p2 db 'Curious, adaptable, expressive.',10,0
p3 db 'Caring, intuitive, protective.',10,0
p4 db 'Confident, creative, courageous.',10,0
p5 db 'Practical, thoughtful, organized.',10,0
p6 db 'Fair-minded, friendly, diplomatic.',10,0
p7 db 'Passionate, resourceful, focused.',10,0
p8 db 'Adventurous, optimistic, independent.',10,0
p9 db 'Disciplined, ambitious, responsible.',10,0
p10 db 'Original, imaginative, independent.',10,0
p11 db 'Compassionate, artistic, sensitive.',10,0
personalities dd p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11
; Three distinct ASCII drawings selected according to zodiac symbol group
artfire db '          /\',10,'         /  \',10,'        / /\ \',10,'        \____/',10,0
artearth db '        ______',10,'       / ____ \',10,'      | |    | |',10,'      | |____| |',10,'       \______/',10,0
artair db '       ~ ~ ~ ~ ~',10,'        ~ ~ ~ ~',10,'       ~ ~ ~ ~ ~',10,0
artwater db '         __',10,'       _/  \_',10,'      /  ><  \',10,'      \______/',10,0
; Sign-specific stylized glyphs (each has its own entry)
art0 db '        /\  /\',10,'       /  \/  \',10,0
art1 db '       (  __  )',10,'        \____/',10,0
art2 db '        |\  /|',10,'        | \/ |',10,0
art3 db '       (  o o )',10,'        \____/',10,0
art4 db '        /\_/\',10,'       ( o.o )',10,'        > ^ <',10,0
art5 db '         /\',10,'        /||\',10,'         ||',10,0
art6 db '       _______',10,'      __\___/__',10,'        /   \',10,0
art7 db '        \  /',10,'         \/___>',10,0
art8 db '        ----->',10,'         /\',10,'        /  \',10,0
art9 db '        /\  /\',10,'       /  \/  \',10,'         ||',10,0
art10 db '       \____/',10,'        \  /',10,'       ~~~~~~',10,0
art11 db '       ><(((o>',10,'       <o)))><',10,0
arts dd art0,art1,art2,art3,art4,art5,art6,art7,art8,art9,art10,art11
red db 'Red',0
green db 'Green',0
yellow db 'Yellow',0
silver db 'Silver',0
gold db 'Gold',0
navy db 'Navy Blue',0
pink db 'Pink',0
maroon db 'Maroon',0
purple db 'Purple',0
brown db 'Brown',0
blue db 'Electric Blue',0
sea db 'Sea Green',0
colors dd red,green,yellow,silver,gold,navy,pink,maroon,purple,brown,blue,sea
lucky_numbers dd 9,6,5,2,1,4,7,8,3,10,11,12
month_lengths dd 31,28,31,30,31,30,31,31,30,31,30,31
; Last day for previous sign in each month, and sign after that cutoff
cutoffs dd 19,18,20,19,20,20,22,22,22,22,21,21
before_sign dd 9,10,11,0,1,2,3,4,5,6,7,8
after_sign dd 10,11,0,1,2,3,4,5,6,7,8,9
section .bss
namebuf resb 65
inputbuf resb 128
month resd 1
day resd 1
sign_index resd 1
choice resd 1
numberbuf resb 16
section .text
_start:
   call display_welcome
   call get_user_info
   call determine_zodiac
   call display_zodiac_art
.menu_loop:
   call display_menu
   call read_line
   call parse_number
   jc .bad_choice
   mov [choice],eax
   cmp eax,1
   jl .bad_choice
   cmp eax,6
   jg .bad_choice
   je exit_program
   cmp eax,5
   je .details
   call show_horoscope
   jmp .ask_return
.details:
   call display_zodiac_art
.ask_return:
   call ask_return
   cmp eax,1
   je .menu_loop
   jmp exit_program
.bad_choice:
   mov ecx,badmenu
   call print_string
   jmp .menu_loop
; print zero-terminated ECX string; preserves all registers
print_string:
   pushad
   mov edi,ecx
   xor edx,edx
.len:
   cmp byte [edi+edx],0
   je .write
   inc edx
   jmp .len
.write:
   mov eax,4
   mov ebx,1
   int 0x80
   popad
   ret
; Read one line, remove newline, flush excess characters
read_line:
   pushad
   xor edi,edi
.loop:
   mov eax,3
   xor ebx,ebx
   lea ecx,[inputbuf+edi]
   mov edx,1
   int 0x80
   cmp eax,1
   jne .done
   mov al,[inputbuf+edi]
   cmp al,10
   je .done
   cmp al,13
   je .done
   cmp edi,126
   jge .loop
   inc edi
   jmp .loop
.done:
   mov byte [inputbuf+edi],0
   popad
   ret
; Strict positive decimal integer; EAX=result, CF=1 on invalid
parse_number:
   push ebx
   push ecx
   push edx
   push esi
   xor eax,eax
   xor esi,esi
   cmp byte [inputbuf],0
   je .invalid
.next:
   movzx ecx,byte [inputbuf+esi]
   test ecx,ecx
   jz .valid
   cmp ecx,'0'
   jb .invalid
   cmp ecx,'9'
   ja .invalid
   sub ecx,'0'
   mov ebx,10
   mul ebx
   test edx,edx
   jnz .invalid
   add eax,ecx
   jc .invalid
   inc esi
   jmp .next
.valid:
   clc
   jmp .out
.invalid:
   stc
.out:
   pop esi
   pop edx
   pop ecx
   pop ebx
   ret
display_welcome:
   mov ecx,welcome
   call print_string
   ret
get_user_info:
.name:
   mov ecx,askname
   call print_string
   call read_line
   cmp byte [inputbuf],0
   je .badname
   mov esi,inputbuf
   mov edi,namebuf
   mov ecx,64
.copy:
   lodsb
   stosb
   test al,al
   jz .name_done
   loop .copy
   mov byte [edi],0
.name_done:
   jmp .month
.badname:
   mov ecx,invalidname
   call print_string
   jmp .name
.month:
   mov ecx,askmonth
   call print_string
   call read_line
   call parse_number
   jc .badmonth
   cmp eax,1
   jl .badmonth
   cmp eax,12
   jg .badmonth
   mov [month],eax
   jmp .day
.badmonth:
   mov ecx,invalidmonth
   call print_string
   jmp .month
.day:
   mov ecx,askday
   call print_string
   call read_line
   call parse_number
   jc .badday
   mov [day],eax
   call validate_birthdate
   cmp eax,1
   jne .badday
   mov ecx,hello
   call print_string
   mov ecx,namebuf
   call print_string
   mov ecx,bang
   call print_string
   ret
.badday:
   mov ecx,invalidday
   call print_string
   jmp .day
; EAX=1 if valid, 0 otherwise
validate_birthdate:
   mov eax,[month]
   cmp eax,1
   jl .invalid
   cmp eax,12
   jg .invalid
   mov edx,[day]
   cmp edx,1
   jl .invalid
   dec eax
   cmp edx,[month_lengths+eax*4]
   jg .invalid
   mov eax,1
   ret
.invalid:
   xor eax,eax
   ret
; Month/day split using signed comparisons, including Capricorn year boundary
determine_zodiac:
   mov eax,[month]
   dec eax
   mov edx,[day]
   cmp edx,[cutoffs+eax*4]
   jle .before
   mov ecx,[after_sign+eax*4]
   jmp .store
.before:
   mov ecx,[before_sign+eax*4]
.store:
   mov [sign_index],ecx
   ret
display_zodiac_art:
   mov ecx,zhead
   call print_string
   mov ebx,[sign_index]
   mov ecx,[arts+ebx*4]
   call print_string
   mov ecx,slabel
   call print_string
   mov ecx,[signs+ebx*4]
   call print_string
   mov ecx,nl
   call print_string
   mov ecx,elabel
   call print_string
   mov ecx,[elements+ebx*4]
   call print_string
   mov ecx,nl
   call print_string
   mov ecx,sylabel
   call print_string
   mov ecx,[symbols+ebx*4]
   call print_string
   mov ecx,nl
   call print_string
   mov ecx,plabel
   call print_string
   mov ecx,[personalities+ebx*4]
   call print_string
   ret
display_menu:
   mov ecx,menu
   call print_string
   ret
show_horoscope:
   mov eax,[choice]
   cmp eax,1
   je .love
   cmp eax,2
   je .career
   cmp eax,3
   je .health
   cmp eax,4
   je .lucky
   ret
.love:
   mov ecx,lovehead
   call print_string
   mov esi,love1
   mov edi,love2
   mov edx,love3
   jmp .prediction
.career:
   mov ecx,careerhead
   call print_string
   mov esi,career1
   mov edi,career2
   mov edx,career3
   jmp .prediction
.health:
   mov ecx,healthhead
   call print_string
   mov esi,health1
   mov edi,health2
   mov edx,health3
.prediction:
   mov ebx,[sign_index]
   mov ecx,[signs+ebx*4]
   call print_string
   mov ecx,predictionprefix
   call print_string
   ; Choose one of three category predictions based on sign index
   mov eax,ebx
   xor edx,edx
   mov ecx,3
   div ecx
   cmp edx,0
   je .first
   cmp edx,1
   je .second
   mov ecx,health3
   cmp dword [choice],1
   je .third_love
   cmp dword [choice],2
   je .third_career
   jmp .printpred
.third_love:
   mov ecx,love3
   jmp .printpred
.third_career:
   mov ecx,career3
   jmp .printpred
.first:
   mov eax,[choice]
   cmp eax,1
   je .first_love
   cmp eax,2
   je .first_career
   mov ecx,health1
   jmp .printpred
.first_love:
   mov ecx,love1
   jmp .printpred
.first_career:
   mov ecx,career1
   jmp .printpred
.second:
   mov eax,[choice]
   cmp eax,1
   je .second_love
   cmp eax,2
   je .second_career
   mov ecx,health2
   jmp .printpred
.second_love:
   mov ecx,love2
   jmp .printpred
.second_career:
   mov ecx,career2
.printpred:
   call print_string
   ret
.lucky:
   mov ecx,luckyhead
   call print_string
   mov ecx,lucknum
   call print_string
   mov ebx,[sign_index]
   mov eax,[lucky_numbers+ebx*4]
   call print_number
   mov ecx,nl
   call print_string
   mov ecx,luckcolor
   call print_string
   mov ecx,[colors+ebx*4]
   call print_string
   mov ecx,nl
   call print_string
   ret
; EAX unsigned integer to stdout
print_number:
   pushad
   mov edi,numberbuf+15
   mov byte [edi],0
   mov ebx,10
.convert:
   xor edx,edx
   div ebx
   add dl,'0'
   dec edi
   mov [edi],dl
   test eax,eax
   jnz .convert
   mov ecx,edi
   call print_string
   popad
   ret
ask_return:
.ask:
   mov ecx,returnprompt
   call print_string
   call read_line
   mov al,[inputbuf]
   cmp byte [inputbuf+1],0
   jne .bad
   cmp al,'Y'
   je .yes
   cmp al,'y'
   je .yes
   cmp al,'N'
   je .no
   cmp al,'n'
   je .no
.bad:
   mov ecx,badreturn
   call print_string
   jmp .ask
.yes:
   mov eax,1
   ret
.no:
   xor eax,eax
   ret
exit_program:
   mov ecx,goodbye
   call print_string
   mov eax,1
   xor ebx,ebx
   int 0x80