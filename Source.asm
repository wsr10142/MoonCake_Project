INCLUDE Irvine32.inc

.data
;---------------------------------
LifeSymbol BYTE "★",0 ;生命符號
LifeNum BYTE 0 ;要顯示的生命數量
LifeName BYTE "LIFE :",0 ;生命欄位
TotalLife BYTE 3 ;
BlankLife BYTE "□□□□□□□□□□",0	;
JudgeLive BYTE  0;
;--------------------------------
Life BYTE 0 ;生命
judgeLife BYTE 0 ;判斷生命用的東西

GOODmsg BYTE "阿不就好棒棒"	,0dh,0ah,0
SOSOmsg BYTE "普普的人普普的分啦哈"	,0dh,0ah,0
BADmsg BYTE "哈哈哈你好爛"	,0dh,0ah,0
;---------------------------------

line BYTE "□□□□□□□□□□",0	;槓槓本體
lineX BYTE 10
lineY BYTE 20	;新XY
OldLineX BYTE 10 
OldLineY BYTE 20	;舊XY
LeftBoundX BYTE 0	;左邊界
RightBoundX BYTE 80		;右邊界
score DWORD 0	;分數
ScoreName BYTE "SCORE:",0

	bonus byte "＄",0
	b_x byte 0
	b_y byte 0
	count byte 0
	bonus_count byte 0				;掉落物數量
	generate_count byte 0			;掉落物生成頻率
	location_y byte 0				;掉落物y位置(陣列)
	location_x byte 0				;掉落物x位置(陣列)	
	store_esi byte 0				;指向location最尾端的位址
	store_esi_head byte 0
	bonus_count_temp byte 0
	mode_select byte 0				;模式速度
	;mode_easy byte 10
	;mode_normal byte 15
	;mode_hard byte 10
	;mode_boss byte 5

	mode_string byte "輸入想玩的模式:",0

	CaptionString BYTE "Welcome",0
	MessageString BYTE "接月餅游戲", 0dh, 0ah
                    BYTE "開始游戲 ", 0dh, 0ah, 0



ContentCaption BYTE "ChooseMode",0
ContentString BYTE "(1) 簡單模式   Easy",0dh,0ah
					BYTE "(2) 一般模式   Normal",0dh,0ah
					BYTE "(3) 困難模式   Hard",0dh,0ah,0


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
;顯示生命欄位
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
;更改生命欄位
changeLife PROC

	MOV dl,93
	MOV dh,20
	CALL Gotoxy
	MOV eax,0						 ;清空eax
	MOV al,JudgeLive
	SUB eax,score 
	MOV ecx,0
	MOV cl,TotalLife
	SUB ecx,eax						 ;生命初始值3 - 沒接到的數量
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

;遊戲背景

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
;改變顯示的分數
ChangeScore PROC
	MOV dl,93
	MOV dh,5
	CALL Gotoxy
	mov eax, white+(black*16)
	call setTextColor
	mov eax,0
	MOV eax,score
	CALL WriteDec
	;----判斷生命-----
	MOV al,judgeLife
	SUB eax,score
	CMP al,3
	JE GAMEEND
	;-----------------
	RET
	;---------生命歸零----
	GAMEEND:
		MOV QuitFlag,1
		RET
		
ChangeScore ENDP
;---------------------------------------------------------------------
;顯示輸入欄位
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
;結束遊戲對話框
 ShowMsg PROC
  mov ebx,OFFSET GameOverCaption
  mov edx,OFFSET GameOverQuestion
  call MsgBox
  ret
ShowMsg ENDP
;---------------------------------------------------------------------
;顯示分數欄位
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
;碰撞事件
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
;移動bonus_easy (清除原本bonus位置)
movebonus_easy proc
	mov count,0
	movzx esi,store_esi_head
move_easy:
	inc count
								;mov al,mode_select
	cmp generate_count,20		;判斷是否生成掉落物, 頻率為3 (即每三格生成一個)
	mov al,count
	je generate_rand_easy

continue_easy:
	mov eax,50					;速度
	call Delay
	mov eax,gray+(gray*16)		;設定顏色
	call SetTextColor
	mov al,location_y[esi]
	mov bl,location_x[esi]
	mov b_x,bl					;取得生成物x軸位址
	mov b_y,al					;取得生成物y軸位址
	mov dh,b_y
	mov dl,b_x
	call GoTOxy					;設定游標位址
	mov edx,OFFSET bonus	
	call WriteString			;印出黑塊覆蓋原本位址
	inc b_y						;設定bonus移動位址
	mov bl,b_y
	mov location_y[esi],bl
	CMP bl,19
	JE ADDSCORE_easy
	CMP bl,23
	JE STOPBonus_easy
HERE_easy:	
	add esi,4					;指標指向下一個位址
	
	mov al,count				;判斷生成物數量是否印完
	cmp al,bonus_count
	jne move_easy
	jmp next_easy

STOPBonus_easy:
	add store_esi_head,4
	dec bonus_count
	;---------------計算碰到底線的掉落物數量----------
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
;移動bonus_normal (清除原本bonus位置)
movebonus_normal proc
	mov count,0
	movzx esi,store_esi_head
move_normal:
	inc count
								;mov al,mode_select
	cmp generate_count,15		;判斷是否生成掉落物, 頻率為3 (即每三格生成一個)
	mov al,count
	je generate_rand_normal

continue_normal:
	mov eax,35					;速度
	call Delay
	mov eax,gray+(gray*16)		;設定顏色
	call SetTextColor
	mov al,location_y[esi]
	mov bl,location_x[esi]
	mov b_x,bl					;取得生成物x軸位址
	mov b_y,al					;取得生成物y軸位址
	mov dh,b_y
	mov dl,b_x
	call GoTOxy					;設定游標位址
	mov edx,OFFSET bonus	
	call WriteString			;印出黑塊覆蓋原本位址
	inc b_y						;設定bonus移動位址
	mov bl,b_y
	mov location_y[esi],bl
	CMP bl,19
	JE ADDSCORE_normal
	CMP bl,23
	JE STOPBonus_normal
HERE_normal:	
	add esi,4					;指標指向下一個位址
	
	mov al,count				;判斷生成物數量是否印完
	cmp al,bonus_count
	jne move_normal
	jmp next_normal

STOPBonus_normal:
	add store_esi_head,4
	dec bonus_count
	;---------------計算碰到底線的掉落物數量----------
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
;移動bonus_hard (清除原本bonus位置)
movebonus_hard proc
	mov count,0
	movzx esi,store_esi_head
move_hard:
	inc count
								;mov al,mode_select
	cmp generate_count,10		;判斷是否生成掉落物, 頻率為3 (即每三格生成一個)
	mov al,count
	je generate_rand_hard

continue_hard:
	mov eax,20					;速度
	call Delay
	mov eax,gray+(gray*16)		;設定顏色
	call SetTextColor
	mov al,location_y[esi]
	mov bl,location_x[esi]
	mov b_x,bl					;取得生成物x軸位址
	mov b_y,al					;取得生成物y軸位址
	mov dh,b_y
	mov dl,b_x
	call GoTOxy					;設定游標位址
	mov edx,OFFSET bonus	
	call WriteString			;印出黑塊覆蓋原本位址
	inc b_y						;設定bonus移動位址
	mov bl,b_y
	mov location_y[esi],bl
	CMP bl,19
	JE ADDSCORE_hard
	CMP bl,23
	JE STOPBonus_hard
HERE_hard:	
	add esi,4					;指標指向下一個位址
	
	mov al,count				;判斷生成物數量是否印完
	cmp al,bonus_count
	jne move_hard
	jmp next_hard

STOPBonus_hard:
	add store_esi_head,4
	dec bonus_count
	;---------------計算碰到底線的掉落物數量----------
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
;移動bonus_boss (清除原本bonus位置)
movebonus_boss proc
	mov count,0
	movzx esi,store_esi_head
move_boss:
	inc count
								;mov al,mode_select
	cmp generate_count,10		;判斷是否生成掉落物, 頻率為3 (即每三格生成一個)
	mov al,count
	je generate_rand_boss

continue_boss:
	mov eax,10					;速度
	call Delay
	mov eax,gray+(gray*16)		;設定顏色
	call SetTextColor
	mov al,location_y[esi]
	mov bl,location_x[esi]
	mov b_x,bl					;取得生成物x軸位址
	mov b_y,al					;取得生成物y軸位址
	mov dh,b_y
	mov dl,b_x
	call GoTOxy					;設定游標位址
	mov edx,OFFSET bonus	
	call WriteString			;印出黑塊覆蓋原本位址
	inc b_y						;設定bonus移動位址
	mov bl,b_y
	mov location_y[esi],bl
	CMP bl,19
	JE ADDSCORE_boss
	CMP bl,23
	JE STOPBonus_boss
HERE_boss:	
	add esi,4					;指標指向下一個位址
	
	mov al,count				;判斷生成物數量是否印完
	cmp al,bonus_count
	jne move_boss
	jmp next_boss

STOPBonus_boss:
	add store_esi_head,4
	dec bonus_count
	;---------------計算碰到底線的掉落物數量----------
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
;印出生成物
print_b proc
	mov count,0					;count = 迴圈次數
	movzx esi,store_esi_head
printbonus:
	inc count
	mov al,location_y[esi]
	mov bl,location_x[esi]
	mov b_y, al					;存取生成物y軸位址
	mov b_x, bl					;存取生成物x軸位址
	add esi,4					;指向下一個位址
	mov dh,b_y
	mov dl,b_x
	call GoTOxy					;設定游標位址
	mov eax,yellow+(gray*16)	;生成物顏色
	call SetTextColor
	mov edx,OFFSET bonus
	call WriteString

	mov al,count				;判斷生成物數量是否印完
	cmp al,bonus_count
	jne printbonus

ret
print_b endp
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;隨機產生生成物位址
rand proc

	inc bonus_count
	mov generate_count,0

	mov eax,79					;亂數範圍0-79
	call RandomRange
	movzx esi,store_esi			;存取生成物位址最尾端的指標
	mov location_y[esi],0		;儲存新生成的y軸位址
	mov location_x[esi],al		;儲存新生成的x軸位址
	add store_esi,4				;向後推一個位置
ret
rand endp
;---------------------------------------------------------------------
;-----------------------------------------------------------------------------------
;先暫停程式
MoveEvent PROC
MOV eax,1 ;0.1秒
CALL Delay
MOV eax,0						 ;eax歸零
;讀取鍵盤輸入
CALL ReadKey					 ;al = key_in
;判斷左右
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
ADD al,1						;將左邊界往右挪一格
CMP lineX,al					;比較
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
CMP lineX,al			;比較
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
;顯示槓槓
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
CALL Gotoxy					;到舊的位置
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
