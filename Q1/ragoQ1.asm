;Rag�p G�nay 200316007
;Duygu Kamalak 200316046

LIST P = PIC16F877A
#include <P16F877A.INC>
__CONFIG H'3F31'  ; Konfig�rasyon ayarlar�

; TANIMLAMALAR
#define RS PORTC,0  ; LCD Register Select pini
#define RW PORTC,1  ; LCD Read/Write pini
#define EN PORTC,2  ; LCD Enable pini

; DE���KENLER
S1          EQU 0X20  ; Gecikme sayac� 1
S2          EQU 0X21  ; Gecikme sayac� 2
TEMP        EQU 0X22  ; Ge�ici de�i�ken
COUNTER     EQU 0X23  ; Say�c� (Kullan�lm�yor)
UNITS       EQU 0X24  ; Birler basama��
TENS        EQU 0X25  ; Onlar basama��

; BA�LANGI�
ORG 0X00
GOTO START

; KESME VEKT�R�
ORG 0x04  
GOTO ISR  ; Kesme Servis Rutini

START
CALL REG_INIT  ; Portlar� ba�lat
CALL LCD_INIT  ; LCD'yi ba�lat

MOVLW    0x80  ; LCD'nin ilk sat�r�na yazmaya ba�la
CALL    LCD_COMMAND
CALL 	PRINTC  ; LCD'ye "COUNTER:" yaz

; KESMELER� ETK�NLE�T�RME
BSF INTCON, GIE   ; Genel kesmeleri etkinle�tir
BSF INTCON, PEIE  ; �evresel kesmeleri etkinle�tir
BSF INTCON, INTE  ; Harici kesmeleri etkinle�tir
BCF INTCON, INTF  ; Harici kesme bayra��n� temizle

MAIN_LOOP
GOTO MAIN_LOOP  ; Sonsuz d�ng�

; Kesme Servis Rutini
ISR
BCF INTCON, INTF  ; Harici kesme bayra��n� temizle
CALL INCREMENT_UNITS  ; Birler basama��n� art�r
CALL DISPLAY_NUMBER  ; Say�y� LCD'de g�ster
RETFIE  ; Kesmeden ��k

; Port Ba�latma
REG_INIT
BANKSEL TRISC
MOVLW   B'00000001'  ; RB0 giri�, di�er t�m pinler ��k��
MOVWF   TRISB  ; TRISB registerini ayarla
CLRF    TRISC  ; T�m TRISC pinlerini ��k�� olarak ayarla
CLRF    TRISD  ; T�m TRISD pinlerini ��k�� olarak ayarla
BANKSEL PORTD
CLRF    PORTD  ; T�m PORTD pinlerini temizle
CLRF    PORTB  ; T�m PORTB pinlerini temizle
CLRF    UNITS  ; Birler basama��n� s�f�rla
CLRF    TENS   ; Onlar basama��n� s�f�rla
RETURN

; LCD'ye "COUNTER:" yaz
PRINTC
MOVLW	"C"
CALL	LCD_DATA
MOVLW	"O"
CALL	LCD_DATA
MOVLW	"U"
CALL	LCD_DATA
MOVLW	"N"
CALL	LCD_DATA
MOVLW	"T"
CALL	LCD_DATA
MOVLW	"E"
CALL	LCD_DATA
MOVLW	"R"
CALL	LCD_DATA
MOVLW	":"
CALL	LCD_DATA
RETURN

; Birler Basama��n� Art�r
INCREMENT_UNITS
INCF    UNITS, F  ; Birler basama��n� 1 art�r
MOVLW   0x0A  ; E�er 10 olduysa
SUBWF   UNITS, W
BTFSS   STATUS, Z
RETURN
CLRF    UNITS  ; Birler basama��n� s�f�rla
CALL    INCREMENT_TENS  ; Onlar basama��n� art�r
RETURN

; Onlar Basama��n� Art�r
INCREMENT_TENS
INCF    TENS, F  ; Onlar basama��n� 1 art�r
MOVLW   0x0A  ; E�er 10 olduysa
SUBWF   TENS, W
BTFSS   STATUS, Z
RETURN
CLRF    TENS  ; Onlar basama��n� s�f�rla
RETURN

; Say�y� LCD'de G�ster
DISPLAY_NUMBER
MOVLW    0xC0  ; �mleci ikinci sat�ra ta��
CALL    LCD_COMMAND
BANKSEL TENS
MOVF    TENS, W
ADDLW   '0'  ; Onlar basama��n� karaktere �evir
CALL    LCD_DATA
BANKSEL UNITS
MOVF    UNITS, W
ADDLW   '0'  ; Birler basama��n� karaktere �evir
CALL    LCD_DATA
RETURN

; LCD Ba�latma
LCD_INIT
MOVLW    0X38  ; 8-bit mode, 2-line display, 5x8 font
CALL     LCD_COMMAND
MOVLW    0X06  ; Entry mode set
CALL     LCD_COMMAND
MOVLW    0X0E  ; Display on, cursor on
CALL     LCD_COMMAND
MOVLW    0X01  ; Display clear
CALL     LCD_COMMAND
RETURN

; LCD Komutu
LCD_COMMAND
BCF     RS  ; RS = 0 (Komut modu)
BCF     RW  ; RW = 0 (Yazma modu)
BSF     EN  ; Enable = 1
MOVWF   TEMP  ; Ge�ici de�i�kene komutu yaz
CALL    DELAY  ; K�sa bir gecikme
MOVFW   TEMP  ; Ge�ici de�i�kenden veriyi oku
BANKSEL PORTD
MOVWF   PORTD  ; Veriyi PORTD'ye yaz
BCF     EN  ; Enable = 0
RETURN

; LCD Verisi
LCD_DATA
BSF     RS  ; RS = 1 (Veri modu)
BCF     RW  ; RW = 0 (Yazma modu)
BSF     EN  ; Enable = 1
MOVWF   TEMP  ; Ge�ici de�i�kene veriyi yaz
CALL    DELAY  ; K�sa bir gecikme
MOVFW   TEMP  ; Ge�ici de�i�kenden veriyi oku
BANKSEL PORTD
MOVWF   PORTD  ; Veriyi PORTD'ye yaz
BCF     EN  ; Enable = 0
RETURN

; Gecikme Rutini
DELAY
MOVLW 0XFF
MOVWF S1  ; Gecikme sayac� 1
L1
    MOVLW 0XFF
    MOVWF S2  ; Gecikme sayac� 2
L2
    DECFSZ S2  ; S2'yi azalt
    GOTO   L2
    DECFSZ S1  ; S1'i azalt
    GOTO   L1
RETURN

END  ; Program sonu
;Rag�p G�nay 200316007
;Duygu Kamalak 200316046
LIST P = PIC16F877A
#include <P16F877A.INC>
__CONFIG H'3F31'  ; Konfig�rasyon ayarlar�

; TANIMLAMALAR
#define RS PORTC,0  ; LCD Register Select pini
#define RW PORTC,1  ; LCD Read/Write pini
#define EN PORTC,2  ; LCD Enable pini

; DE���KENLER
S1          EQU 0X20  ; Gecikme sayac� 1
S2          EQU 0X21  ; Gecikme sayac� 2
TEMP        EQU 0X22  ; Ge�ici de�i�ken
COUNTER     EQU 0X23  ; Say�c� (Kullan�lm�yor)
UNITS       EQU 0X24  ; Birler basama��
TENS        EQU 0X25  ; Onlar basama��

; BA�LANGI�
ORG 0X00
GOTO START

; KESME VEKT�R�
ORG 0x04  
GOTO ISR  ; Kesme Servis Rutini

START
CALL REG_INIT  ; Portlar� ba�lat
CALL LCD_INIT  ; LCD'yi ba�lat

MOVLW    0x80  ; LCD'nin ilk sat�r�na yazmaya ba�la
CALL    LCD_COMMAND
CALL 	PRINTC  ; LCD'ye "COUNTER:" yaz

; KESMELER� ETK�NLE�T�RME
BSF INTCON, GIE   ; Genel kesmeleri etkinle�tir
BSF INTCON, PEIE  ; �evresel kesmeleri etkinle�tir
BSF INTCON, INTE  ; Harici kesmeleri etkinle�tir
BCF INTCON, INTF  ; Harici kesme bayra��n� temizle

MAIN_LOOP
GOTO MAIN_LOOP  ; Sonsuz d�ng�

; Kesme Servis Rutini
ISR
BCF INTCON, INTF  ; Harici kesme bayra��n� temizle
CALL INCREMENT_UNITS  ; Birler basama��n� art�r
CALL DISPLAY_NUMBER  ; Say�y� LCD'de g�ster
RETFIE  ; Kesmeden ��k

; Port Ba�latma
REG_INIT
BANKSEL TRISC
MOVLW   B'00000001'  ; RB0 giri�, di�er t�m pinler ��k��
MOVWF   TRISB  ; TRISB registerini ayarla
CLRF    TRISC  ; T�m TRISC pinlerini ��k�� olarak ayarla
CLRF    TRISD  ; T�m TRISD pinlerini ��k�� olarak ayarla
BANKSEL PORTD
CLRF    PORTD  ; T�m PORTD pinlerini temizle
CLRF    PORTB  ; T�m PORTB pinlerini temizle
CLRF    UNITS  ; Birler basama��n� s�f�rla
CLRF    TENS   ; Onlar basama��n� s�f�rla
RETURN

; LCD'ye "COUNTER:" yaz
PRINTC
MOVLW	"C"
CALL	LCD_DATA
MOVLW	"O"
CALL	LCD_DATA
MOVLW	"U"
CALL	LCD_DATA
MOVLW	"N"
CALL	LCD_DATA
MOVLW	"T"
CALL	LCD_DATA
MOVLW	"E"
CALL	LCD_DATA
MOVLW	"R"
CALL	LCD_DATA
MOVLW	":"
CALL	LCD_DATA
RETURN

; Birler Basama��n� Art�r
INCREMENT_UNITS
INCF    UNITS, F  ; Birler basama��n� 1 art�r
MOVLW   0x0A  ; E�er 10 olduysa
SUBWF   UNITS, W
BTFSS   STATUS, Z
RETURN
CLRF    UNITS  ; Birler basama��n� s�f�rla
CALL    INCREMENT_TENS  ; Onlar basama��n� art�r
RETURN

; Onlar Basama��n� Art�r
INCREMENT_TENS
INCF    TENS, F  ; Onlar basama��n� 1 art�r
MOVLW   0x0A  ; E�er 10 olduysa
SUBWF   TENS, W
BTFSS   STATUS, Z
RETURN
CLRF    TENS  ; Onlar basama��n� s�f�rla
RETURN

; Say�y� LCD'de G�ster
DISPLAY_NUMBER
MOVLW    0xC0  ; �mleci ikinci sat�ra ta��
CALL    LCD_COMMAND
BANKSEL TENS
MOVF    TENS, W
ADDLW   '0'  ; Onlar basama��n� karaktere �evir
CALL    LCD_DATA
BANKSEL UNITS
MOVF    UNITS, W
ADDLW   '0'  ; Birler basama��n� karaktere �evir
CALL    LCD_DATA
RETURN

; LCD Ba�latma
LCD_INIT
MOVLW    0X38  ; 8-bit mode, 2-line display, 5x8 font
CALL     LCD_COMMAND
MOVLW    0X06  ; Entry mode set
CALL     LCD_COMMAND
MOVLW    0X0E  ; Display on, cursor on
CALL     LCD_COMMAND
MOVLW    0X01  ; Display clear
CALL     LCD_COMMAND
RETURN

; LCD Komutu
LCD_COMMAND
BCF     RS  ; RS = 0 (Komut modu)
BCF     RW  ; RW = 0 (Yazma modu)
BSF     EN  ; Enable = 1
MOVWF   TEMP  ; Ge�ici de�i�kene komutu yaz
CALL    DELAY  ; K�sa bir gecikme
MOVFW   TEMP  ; Ge�ici de�i�kenden veriyi oku
BANKSEL PORTD
MOVWF   PORTD  ; Veriyi PORTD'ye yaz
BCF     EN  ; Enable = 0
RETURN

; LCD Verisi
LCD_DATA
BSF     RS  ; RS = 1 (Veri modu)
BCF     RW  ; RW = 0 (Yazma modu)
BSF     EN  ; Enable = 1
MOVWF   TEMP  ; Ge�ici de�i�kene veriyi yaz
CALL    DELAY  ; K�sa bir gecikme
MOVFW   TEMP  ; Ge�ici de�i�kenden veriyi oku
BANKSEL PORTD
MOVWF   PORTD  ; Veriyi PORTD'ye yaz
BCF     EN  ; Enable = 0
RETURN

; Gecikme Rutini
DELAY
MOVLW 0XFF
MOVWF S1  ; Gecikme sayac� 1
L1
    MOVLW 0XFF
    MOVWF S2  ; Gecikme sayac� 2
L2
    DECFSZ S2  ; S2'yi azalt
    GOTO   L2
    DECFSZ S1  ; S1'i azalt
    GOTO   L1
RETURN

END  ; Program sonu
