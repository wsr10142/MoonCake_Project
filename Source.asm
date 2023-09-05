INCLUDE Irvine32.inc

.data
;---------------------------------
LifeSymbol BYTE "��",0 ;�ͩR�Ÿ�
LifeNum BYTE 0 ;�n��ܪ��ͩR�ƶq
LifeName BYTE "LIFE :",0 ;�ͩR���
TotalLife BYTE 3 ;
BlankLife BYTE "��������������������",0	;
JudgeLive BYTE  0;
;--------------------------------
Life BYTE 0 ;�ͩR
judgeLife BYTE 0 ;�P�_�ͩR�Ϊ��F��

GOODmsg BYTE "�����N�n�δ�"	,0dh,0ah,0
SOSOmsg BYTE "�������H���������ի�"	,0dh,0ah,0
BADmsg BYTE "�������A�n��"	,0dh,0ah,0
;---------------------------------

line BYTE "��������������������",0	;�b�b����
lineX BYTE 10
lineY BYTE 20	;�sXY
OldLineX BYTE 10 
OldLineY BYTE 20	;��XY
LeftBoundX BYTE 0	;�����
RightBoundX BYTE 80		;�k���
score DWORD 0	;����
ScoreName BYTE "SCORE:",0

	bonus byte "�C",0
	b_x byte 0
	b_y byte 0
	count byte 0
	bonus_count byte 0				;�������ƶq
	generate_count byte 0			;�������ͦ��W�v
	location_y byte 0				;������y��m(�}�C)
	location_x byte 0				;������x��m(�}�C)	
	store_esi byte 0				;���Vlocation�̧��ݪ���}
	store_esi_head byte 0
	bonus_count_temp byte 0
	mode_select byte 0				;�Ҧ��t��
	;mode_easy byte 10
	;mode_normal byte 15
	;mode_hard byte 10
	;mode_boss byte 5

	mode_string byte "��J�Q�����Ҧ�:",0

	CaptionString BYTE "Welcome",0
	MessageString BYTE "��������", 0dh, 0ah
                    BYTE "�}�l���� ", 0dh, 0ah, 0



ContentCaption BYTE "ChooseMode",0
ContentString BYTE "(1) ²��Ҧ�   Easy",0dh,0ah
					BYTE "(2) �@��Ҧ�   Normal",0dh,0ah
					BYTE "(3) �x���Ҧ�   Hard",0dh,0ah,0


GameOverCaption  BYTE "Game Message",0
GameOverQuestion BYTE "GAMEOVER!", 0dh, 0ah,0
			     ;BYTE "Would you like to try again?" ,0dh, 0ah, 0

background BYTE " ",0
backgroundColor DWORD (gray*16)+gray
frontColorMask BYTE 0Fh


screenColumns  DWORD 80
screenLeftBoundry BYTE 0
screenRightBoundry BYTE 79
QuitFlag   BYTE 0

;-----------------------------------------------------
.code
main PROC

S:
 MOV eax,0
 
 call Clrscr      ; clear screen
 call Intro
 
 mov ebx, OFFSET CaptionString
 mov edx, OFFSET MessageString
call MsgBox

 mov ebx, OFFSET ContentCaption
 mov edx, OFFSET ContentString
call MsgBox

 call ShowModeString
 call readInt

 cmp eax,1
 je	EasyMode
 cmp eax,2
 je NormalMode
 cmp eax,3
 je HardMode
 jmp BossMode
 

EasyMode:

	CALL ShowScore
	CALL ShowLife
	CALL ChangeScore

	call randomize
	call rand


	ALL_easy:
	call print_b
	call movebonus_easy
	CALL DrawLine
	CALL MoveEvent
	CALL ChangeScore
	CALL changeLife
	CMP QuitFlag,1
	JE OVER

	LOOP ALL_easy


NormalMode:

	CALL ShowScore
	CALL ShowLife
	CALL ChangeScore

	call randomize
	call rand


	ALL_normal:
	call print_b
	call movebonus_normal
	CALL DrawLine
	CALL MoveEvent
	CALL ChangeScore
	CALL changeLife
	CMP QuitFlag,1
	JE OVER

	LOOP ALL_normal

HardMode:

	CALL ShowScore
	CALL ShowLife
	CALL ChangeScore

	call randomize
	call rand


	ALL_hard:
	call print_b
	call movebonus_hard
	CALL DrawLine
	CALL MoveEvent
	CALL ChangeScore
	CALL changeLife
	CMP QuitFlag,1
	JE OVER

	LOOP ALL_hard

BossMode:


	CALL ShowScore
	CALL ShowLife
	CALL ChangeScore

	call randomize
	call rand


	ALL_boss:
	call print_b
	call movebonus_boss
	CALL DrawLine
	CALL MoveEvent
	CALL ChangeScore
	CALL changeLife
	CMP QuitFlag,1
	JE OVER

	LOOP ALL_boss


OVER:
CALL Clrscr
MOV eax, white+(black*16)
call setTextColor
mov edx, offset ScoreName
call writestring
mov eax,0
mov eax,score
CALL WriteDec

  mov eax,0
  mov eax,score
  CMP score,20
  MOV edx,0
  JAE BIG
  CMP score,10
  JAE SOSO
  JMP LOSER

  BIG:
	call ShowMsg
	mov edx,OFFSET GOODmsg
	mov ebx,OFFSET GameOverCaption
	call MsgBox

	jmp E

  SOSO:
	call ShowMsg
    MOV edx,OFFSET SOSOmsg
	mov ebx,OFFSET GameOverCaption
	call MsgBox

	jmp E

  LOSER:
	call ShowMsg
    MOV edx,OFFSET BADmsg
	mov ebx,OFFSET GameOverCaption
	call MsgBox

	jmp E

	E:
INVOKE ExitProcess,0
;---------------------------------------------------------------------
;��ܥͩR���
ShowLife PROC
	MOV dl,83
	MOV dh,20
	CALL Gotoxy
	mov eax, white+(black*16)
	call setTextColor
	MOV edx,OFFSET LifeName
	CALL WriteString
	ret
ShowLife ENDP
;---------------------------------------------------------------------
;���ͩR���
changeLife PROC

	MOV dl,93
	MOV dh,20
	CALL Gotoxy
	MOV eax,0						 ;�M��eax
	MOV al,JudgeLive
	SUB eax,score 
	MOV ecx,0
	MOV cl,TotalLife
	SUB ecx,eax						 ;�ͩR��l��3 - �S���쪺�ƶq
	CMP ecx,0
	JE SLPE

	mov eax, black+(black*16)
	call setTextColor
	MOV edx,OFFSET BlankLife
	CALL WriteString

	MOV edx,0
	MOV dl,93
	MOV dh,20
	CALL Gotoxy
	mov eax, white+(black*16)
	call setTextColor
	PrintWhiteLife:
		MOV edx,OFFSET LifeSymbol
		CALL WriteString
	LOOP PrintWhiteLife
   RET
	SLPE:
		RET

changeLife ENDP
;---------------------------------------------------------------------

;�C���I��

Intro PROC
 pushad
 mov eax, backgroundColor
 call SetTextColor
 mov dh, 0
 mov dl, 0
 mov bx, dx
 mov ecx, 80
 
L1: 
 mov eax, ecx
 mov ecx, 23
 
L0:
 mov dx, bx 
 call Gotoxy
 mov edx, offset background
 call WriteString
 inc bh
 loop L0

 mov bh, 0
 inc bl
 mov ecx, eax
 loop L1

popad
 ret
Intro ENDP

;---------------------------------------------------------------------
;������ܪ�����
ChangeScore PROC
	MOV dl,93
	MOV dh,5
	CALL Gotoxy
	mov eax, white+(black*16)
	call setTextColor
	mov eax,0
	MOV eax,score
	CALL WriteDec
	;----�P�_�ͩR-----
	MOV al,judgeLife
	SUB eax,score
	CMP al,3
	JE GAMEEND
	;-----------------
	RET
	;---------�ͩR�k�s----
	GAMEEND:
		MOV QuitFlag,1
		RET
		
ChangeScore ENDP
;---------------------------------------------------------------------
;��ܿ�J���
ShowModeString PROC
	MOV dl,83
	MOV dh,0
	CALL Gotoxy
	mov eax, white+(black*16)
	call setTextColor
	MOV edx,OFFSET mode_string
	CALL WriteString
	ret
ShowModeString ENDP
;---------------------------------------------------------------------
;�����C����ܮ�
 ShowMsg PROC
  mov ebx,OFFSET GameOverCaption
  mov edx,OFFSET GameOverQuestion
  call MsgBox
  ret
ShowMsg ENDP
;---------------------------------------------------------------------
;��ܤ������
ShowScore PROC
	MOV dl,83
	MOV dh,5
	CALL Gotoxy
	mov eax, white+(black*16)
	call setTextColor
	MOV edx,OFFSET ScoreName
	CALL WriteString
	ret
ShowScore ENDP
;---------------------------------------------------------------------
;�I���ƥ�
TouchEvent PROC
	MOV dl,0
	MOV dl,lineX
	CMP b_x,dl
	JL NoScore
	ADD dl,20
	CMP b_x,dl
	JG NoScore
	INC score
	RET
NoScore:
	RET
TouchEvent ENDP
;------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------
;����bonus_easy (�M���쥻bonus��m)
movebonus_easy proc
	mov count,0
	movzx esi,store_esi_head
move_easy:
	inc count
								;mov al,mode_select
	cmp generate_count,20		;�P�_�O�_�ͦ�������, �W�v��3 (�Y�C�T��ͦ��@��)
	mov al,count
	je generate_rand_easy

continue_easy:
	mov eax,50					;�t��
	call Delay
	mov eax,gray+(gray*16)		;�]�w�C��
	call SetTextColor
	mov al,location_y[esi]
	mov bl,location_x[esi]
	mov b_x,bl					;���o�ͦ���x�b��}
	mov b_y,al					;���o�ͦ���y�b��}
	mov dh,b_y
	mov dl,b_x
	call GoTOxy					;�]�w��Ц�}
	mov edx,OFFSET bonus	
	call WriteString			;�L�X�¶��л\�쥻��}
	inc b_y						;�]�wbonus���ʦ�}
	mov bl,b_y
	mov location_y[esi],bl
	CMP bl,19
	JE ADDSCORE_easy
	CMP bl,23
	JE STOPBonus_easy
HERE_easy:	
	add esi,4					;���Ы��V�U�@�Ӧ�}
	
	mov al,count				;�P�_�ͦ����ƶq�O�_�L��
	cmp al,bonus_count
	jne move_easy
	jmp next_easy

STOPBonus_easy:
	add store_esi_head,4
	dec bonus_count
	;---------------�p��I�쩳�u���������ƶq----------
	INC judgeLife
	;-------------------------------------------------
	jmp HERE_easy

ADDSCORE_easy:
	;-------------------------------------------------
	INC JudgeLive
	CALL TouchEvent
	JMP HERE_easy
	

generate_rand_easy:
	call rand
	mov esi,0
	jmp next_easy

next_easy:
	inc generate_count
	mov esi,0
ret
movebonus_easy endp
;------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------
;����bonus_normal (�M���쥻bonus��m)
movebonus_normal proc
	mov count,0
	movzx esi,store_esi_head
move_normal:
	inc count
								;mov al,mode_select
	cmp generate_count,15		;�P�_�O�_�ͦ�������, �W�v��3 (�Y�C�T��ͦ��@��)
	mov al,count
	je generate_rand_normal

continue_normal:
	mov eax,35					;�t��
	call Delay
	mov eax,gray+(gray*16)		;�]�w�C��
	call SetTextColor
	mov al,location_y[esi]
	mov bl,location_x[esi]
	mov b_x,bl					;���o�ͦ���x�b��}
	mov b_y,al					;���o�ͦ���y�b��}
	mov dh,b_y
	mov dl,b_x
	call GoTOxy					;�]�w��Ц�}
	mov edx,OFFSET bonus	
	call WriteString			;�L�X�¶��л\�쥻��}
	inc b_y						;�]�wbonus���ʦ�}
	mov bl,b_y
	mov location_y[esi],bl
	CMP bl,19
	JE ADDSCORE_normal
	CMP bl,23
	JE STOPBonus_normal
HERE_normal:	
	add esi,4					;���Ы��V�U�@�Ӧ�}
	
	mov al,count				;�P�_�ͦ����ƶq�O�_�L��
	cmp al,bonus_count
	jne move_normal
	jmp next_normal

STOPBonus_normal:
	add store_esi_head,4
	dec bonus_count
	;---------------�p��I�쩳�u���������ƶq----------
	INC judgeLife
	;-------------------------------------------------
	jmp HERE_normal

ADDSCORE_normal:
	;-------------------------------------------------
	INC JudgeLive
	CALL TouchEvent
	JMP HERE_normal
	

generate_rand_normal:
	call rand
	mov esi,0
	jmp next_normal

next_normal:
	inc generate_count
	mov esi,0
ret
movebonus_normal endp
;------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------
;����bonus_hard (�M���쥻bonus��m)
movebonus_hard proc
	mov count,0
	movzx esi,store_esi_head
move_hard:
	inc count
								;mov al,mode_select
	cmp generate_count,10		;�P�_�O�_�ͦ�������, �W�v��3 (�Y�C�T��ͦ��@��)
	mov al,count
	je generate_rand_hard

continue_hard:
	mov eax,20					;�t��
	call Delay
	mov eax,gray+(gray*16)		;�]�w�C��
	call SetTextColor
	mov al,location_y[esi]
	mov bl,location_x[esi]
	mov b_x,bl					;���o�ͦ���x�b��}
	mov b_y,al					;���o�ͦ���y�b��}
	mov dh,b_y
	mov dl,b_x
	call GoTOxy					;�]�w��Ц�}
	mov edx,OFFSET bonus	
	call WriteString			;�L�X�¶��л\�쥻��}
	inc b_y						;�]�wbonus���ʦ�}
	mov bl,b_y
	mov location_y[esi],bl
	CMP bl,19
	JE ADDSCORE_hard
	CMP bl,23
	JE STOPBonus_hard
HERE_hard:	
	add esi,4					;���Ы��V�U�@�Ӧ�}
	
	mov al,count				;�P�_�ͦ����ƶq�O�_�L��
	cmp al,bonus_count
	jne move_hard
	jmp next_hard

STOPBonus_hard:
	add store_esi_head,4
	dec bonus_count
	;---------------�p��I�쩳�u���������ƶq----------
	INC judgeLife
	;-------------------------------------------------
	jmp HERE_hard

ADDSCORE_hard:
	;-------------------------------------------------
	INC JudgeLive
	CALL TouchEvent
	JMP HERE_hard
	

generate_rand_hard:
	call rand
	mov esi,0
	jmp next_hard

next_hard:
	inc generate_count
	mov esi,0
ret
movebonus_hard endp
;------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------
;����bonus_boss (�M���쥻bonus��m)
movebonus_boss proc
	mov count,0
	movzx esi,store_esi_head
move_boss:
	inc count
								;mov al,mode_select
	cmp generate_count,10		;�P�_�O�_�ͦ�������, �W�v��3 (�Y�C�T��ͦ��@��)
	mov al,count
	je generate_rand_boss

continue_boss:
	mov eax,10					;�t��
	call Delay
	mov eax,gray+(gray*16)		;�]�w�C��
	call SetTextColor
	mov al,location_y[esi]
	mov bl,location_x[esi]
	mov b_x,bl					;���o�ͦ���x�b��}
	mov b_y,al					;���o�ͦ���y�b��}
	mov dh,b_y
	mov dl,b_x
	call GoTOxy					;�]�w��Ц�}
	mov edx,OFFSET bonus	
	call WriteString			;�L�X�¶��л\�쥻��}
	inc b_y						;�]�wbonus���ʦ�}
	mov bl,b_y
	mov location_y[esi],bl
	CMP bl,19
	JE ADDSCORE_boss
	CMP bl,23
	JE STOPBonus_boss
HERE_boss:	
	add esi,4					;���Ы��V�U�@�Ӧ�}
	
	mov al,count				;�P�_�ͦ����ƶq�O�_�L��
	cmp al,bonus_count
	jne move_boss
	jmp next_boss

STOPBonus_boss:
	add store_esi_head,4
	dec bonus_count
	;---------------�p��I�쩳�u���������ƶq----------
	INC judgeLife
	;-------------------------------------------------
	jmp HERE_boss

ADDSCORE_boss:
	;-------------------------------------------------
	INC JudgeLive
	CALL TouchEvent
	JMP HERE_boss
	

generate_rand_boss:
	call rand
	mov esi,0
	jmp next_boss

next_boss:
	inc generate_count
	mov esi,0
ret
movebonus_boss endp
;------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------
;�L�X�ͦ���
print_b proc
	mov count,0					;count = �j�馸��
	movzx esi,store_esi_head
printbonus:
	inc count
	mov al,location_y[esi]
	mov bl,location_x[esi]
	mov b_y, al					;�s���ͦ���y�b��}
	mov b_x, bl					;�s���ͦ���x�b��}
	add esi,4					;���V�U�@�Ӧ�}
	mov dh,b_y
	mov dl,b_x
	call GoTOxy					;�]�w��Ц�}
	mov eax,yellow+(gray*16)	;�ͦ����C��
	call SetTextColor
	mov edx,OFFSET bonus
	call WriteString

	mov al,count				;�P�_�ͦ����ƶq�O�_�L��
	cmp al,bonus_count
	jne printbonus

ret
print_b endp
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;�H�����ͥͦ�����}
rand proc

	inc bonus_count
	mov generate_count,0

	mov eax,79					;�üƽd��0-79
	call RandomRange
	movzx esi,store_esi			;�s���ͦ�����}�̧��ݪ�����
	mov location_y[esi],0		;�x�s�s�ͦ���y�b��}
	mov location_x[esi],al		;�x�s�s�ͦ���x�b��}
	add store_esi,4				;�V����@�Ӧ�m
ret
rand endp
;---------------------------------------------------------------------
;-----------------------------------------------------------------------------------
;���Ȱ��{��
MoveEvent PROC
MOV eax,1 ;0.1��
CALL Delay
MOV eax,0						 ;eax�k�s
;Ū����L��J
CALL ReadKey					 ;al = key_in
;�P�_���k
CMP al,'a'
JE LEFT
CMP al,'d'
JE RIGHT
CMP al,'A'
JE LEFT
CMP al,'D'
JE RIGHT
JMP OTHERS

LEFT:
	CALL MoveLeft
	JMP OTHERS

RIGHT:
	CALL MoveRight
	JMP OTHERS

OTHERS:
	MOV eax,0
ret

MoveEvent ENDP
;-----------------------------------------------------------------------------------
MoveLeft PROC

MOV al,LeftBoundX	
ADD al,1						;�N����ɩ��k���@��
CMP lineX,al					;���
JBE Stay
MOV al,0
MOV al,lineX
SUB al,5
MOV lineX,al
CALL DeleteLine
MOV eax,0
JMP Stay

Stay:
	ret
MoveLeft ENDP
;-----------------------------------------------------------------------------------
MoveRight PROC

MOV al,RightBoundX
SUB al,20
CMP lineX,al			;���
JAE Stay
MOV al,lineX
ADD al,5
MOV lineX,al
CALL DeleteLine
JMP Stay

Stay:
	ret
MoveRight ENDP
;-----------------------------------------------------------------------------------
DrawLine PROC
;��ܺb�b
MOV edx,0
MOV dl,lineX
MOV dh,lineY
CALL Gotoxy
MOV eax,white+(gray*16)
CALL SetTextColor
MOV edx,0
MOV edx,OFFSET line
CALL WriteString
ret
DrawLine ENDP
;-----------------------------------------------------------------------------------
DeleteLine PROC
MOV edx,0
MOV dl,OldLineX
MOV dh,OldLineY
CALL Gotoxy					;���ª���m
MOV eax,gray +(gray*16)
CALL SetTextColor
MOV edx,0
MOV edx,OFFSET line
CALL WriteString
MOV al,lineX
MOV OldLineX,al
MOV al,lineY
MOV OldLineY,al
ret
DeleteLine ENDP
;-----------------------------------------------------------------------------------
main ENDP
END main
